
--- This query gives a high level view of current Company inventory from SAP ECC systems (GSAP, LSAP, NSAP, Foundation)


SELECT
	
	i.material_id,
	m.description, 
	m.material_group,
	m.material_group_description,  
	m.variety_name,
	m.variety_number,
	m.product_category,
	m.material_type,
	i.plant_id,
	i.storage_location_cid,
	i.batch_cid,
	b.batch_quality_characteristic_cde_cid, 
	b.batch_quality_characteristic_description, 
	b.batch_quality_characteristic_value,
	quality_status.batch_quality_characteristic_value AS batch_quality_status, 
    supply_status.batch_quality_characteristic_value AS batch_supply_status,
	b.last_goods_receipt_date,
	b.system_goods_receipt_date, 
	b.origin_country_cde, 
	b.designated_country_cde, 
	i.inventory_bp_cid,
	i.inventory_date,
	i.inventory_report_date,
	i.stock_category,
	i.inventory_type,
	SUM(i.inventory_quantity) AS inventory_quantity,
	i.inventory_uom,
	i.db_version_valid_from,
	i.db_version_valid_to
	

		
	
FROM public.db_current_inventory_fact i

-- material attributes
LEFT JOIN (
			SELECT 
				material_id, 
                description,
				material_group,
				material_group_description, 
                variety_name,
				variety_number,
				product_category,
				material_type,
				species
			FROM public.db_material 
			WHERE record_type = 'Seeds'
---				AND material_type = 'ZSTK' 
				AND identifier_type ILIKE '%materialnumber%'
				AND variety_number IS NOT NULL
				AND preferred_id IS true
			) m ON m.material_id = i.material_id


-- batch quality status
LEFT JOIN (
			SELECT 
				batch_cid, 
                batch_quality_characteristic_value
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG897'
		   ) quality_status ON quality_status.batch_cid = i.batch_cid 

-- batch supply status
LEFT JOIN ( 
			SELECT 
				batch_cid, 
                batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG903'
			) supply_status ON supply_status.batch_cid = i.batch_cid


-- batch attributes
LEFT JOIN (
			SELECT 
				batch_cid,
				batch_quality_characteristic_cde_cid, 
				batch_quality_characteristic_description, 
				batch_quality_characteristic_value, 
				last_goods_receipt_date, 
				origin_country_cde, 
				designated_country_cde, 
				system_goods_receipt_date
			FROM public.db_batch
			WHERE source_system_cde = 'FNDG'
				AND db_current_status IS true 
		   ) b ON b.batch_cid = i.batch_cid

	
--- WHERE datepart(Y,i.inventory_report_date) >= '2022'
 	WHERE db_version_valid_from <= GETDATE()-1 
 	AND db_version_valid_to >= GETDATE()


	AND i.inventory_quantity <> 0
	AND i.inventory_type = 'company_inventory'
	AND m.material_group IN ('COM700') 
	AND m.species IN ('Product_1','Product_2')
	AND m.identifier_type ILIKE '%materialnumber%'
	AND m.record_type = 'Seeds'
	AND b.designated_country_cde IN ('Country_1','Country_2','Country_3','Country_4')
	GROUP BY 1,2,3
	ORDER BY inventory_quantity DESC;
