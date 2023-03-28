SELECT

	sa.master_profile,
	sa.material_id,
	m.description, 
	m.material_group,
	m.material_group_description, 
	m.variety_name,
	sa.plant_id,
	sa.record_number,
	sa.batch_cid,
	b.batch_quality_characteristic_cde_cid, 
	b.batch_quality_characteristic_description, 
	b.batch_quality_characteristic_value, 
	quality_status.batch_quality_characteristic_value AS batch_quality_status, 
    supply_status.batch_quality_characteristic_value AS batch_supply_status,
	b.last_goods_receipt_date, 
	b.origin_country_cde, 
	b.designated_country_cde, 
	b.system_goods_receipt_date,
	sa.batch_caliber,
	sa.material_caliber,
	sa.level,
	sa.storage_location_cid,
	sa.material_requirements_planning_segment,
	sa.planning_segment_number,
	sa.mrp_element_data,
	sa.delivery_order_finish_date,
	sa.goods_receipt_processing_time_in_days,
	sa.po_order_type,
	sa.planning_production_plant,
	sa.issuing_storage_location_for_stock_transport_order,
	sa.available_from,
	sa.restricted_countries,
	sa.designated_countries,
	SUM(sa.quantity_in_reporting_uom) AS quantity_in_reporting_uom,
	SUM(sa.available_quantity_for_planning_in_reporting_uom) AS available_quantity_for_planning_in_reporting_uom,
	sa.reporting_uom,
	sa.availability_date,
	date_part(year, sa.availability_date) AS availability_year,
	date_part(month, sa.availability_date) AS availability_month,
	date_part(quarter, sa.availability_date) AS availability_quarter,
	date_part(week, sa.availability_date) AS availability_week,
	date_part(day, sa.availability_date) AS availability_day,
	sa.time_projection_rule,
	sa.time_projection_rule_number,
	sa.remarks,
	sa.last_change_date,
	sa.last_change_time,
	sa.mio_update_date_time
			
			
FROM public.db_estimate_available_supply_fact sa

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
				AND identifier_type LIKE '%materialnumber%'
				AND variety_number IS NOT NULL
				AND preferred_id = 'true'
			) m ON m.material_id = sa.material_id

-- batch quality status
LEFT JOIN (
			SELECT 
				batch_cid, 
                batch_quality_characteristic_value
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG897'
		   ) quality_status ON quality_status.batch_cid = sa.batch_cid 

-- batch supply status
LEFT JOIN ( 
			SELECT 
				batch_cid, 
                batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG903'
			) supply_status ON supply_status.batch_cid = sa.batch_cid

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
				AND db_current_status = 'true' 
		   ) b ON b.batch_cid = sa.batch_cid
		
WHERE sa.availability_date >= GETDATE()
	
	AND sa.master_profile IN ('EAME Prod_1','EAME Prod_2')
	AND sa.available_quantity_for_planning_in_reporting_uom <> 0
	AND m.material_group IN ('COM500','COM700') 
	AND m.species IN ('Prod_1','Prod_2')
	AND b.designated_country_cde IN ('Country_1','Country_2','Country_3','Country_4')
	GROUP BY 1,2,3,4
	ORDER BY quantity_in_reporting_uom DESC;
