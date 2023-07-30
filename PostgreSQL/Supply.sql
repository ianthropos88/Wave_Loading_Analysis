SELECT

	sa.master_profile,
	sa.material_id,
	m.description, 

CASE
	WHEN mm.species = 'CRNF' THEN 'Corn'
	WHEN mm.species = 'SUNF' THEN 'Sunflower'
	WHEN mm.species = 'WOSR' THEN 'Winter Oilseed Rape'
	ELSE '<no_data>'
	END AS crop,

	CASE
	WHEN mm.species = 'CRNF' OR mm.grouping ILIKE '%BLD%' OR mm.grouping_description ILIKE '%Blended%' THEN 'Blended'
	WHEN mm.species = 'CRNF' OR mm.grouping ILIKE '%MED%' OR mm.grouping_description ILIKE '%Medium yield%' THEN 'Medium Yield'
	WHEN mm.species = 'CRNF' OR mm.grouping ILIKE '%HIG%' OR mm.grouping_description ILIKE '%High yield%' THEN 'High Yield'
	WHEN mm.species = 'CRNF' OR mm.grouping ILIKE '%LOW%' OR mm.grouping_description ILIKE '%Low yield%' THEN 'Low Yield'
	WHEN mm.species = 'CRNF' OR mm.grouping ILIKE '%CRN%' OR mm.grouping_description ILIKE '%NORMAL%' THEN 'Normal'
	WHEN mm.species = 'CRNF' OR mm.grouping ILIKE '%EPV%' OR mm.grouping_description ILIKE '%Epivio%' THEN 'Epivio'
	WHEN mm.species = 'CRNF' OR mm.grouping ILIKE '%SAC%' OR mm.grouping_description ILIKE '%Saca Acabada Process%' THEN 'Saca Acabada Process'
	WHEN mm.species = 'SUNF' OR mm.grouping ILIKE '%PRO%' OR mm.grouping_description ILIKE '%Pro%' THEN 'Pro'
	WHEN mm.species = 'SUNF' OR mm.grouping ILIKE '%ORG%' OR mm.grouping_description ILIKE '%Organic%' THEN 'Organic'
	WHEN mm.species = 'SUNF' OR mm.grouping ILIKE '%GLD%' OR mm.grouping_description ILIKE '%Gold%' THEN 'Gold'
	WHEN mm.species = 'WOSR' THEN 'Winter Oilseed Rape'
	ELSE '<no_data>'
	END AS breed,
	
	m.material_group,
	m.material_group_description, 

	mp.plant_id AS specific_plant_id,
	mp.procurement_type,

	CASE
	WHEN mp.procurement_type = 'F' THEN 'Transferred'
	WHEN mp.procurement_type = 'E' THEN 'In-House Production'
	WHEN mp.procurement_type = 'X' THEN 'Description Under Review / Thank you for Patience'
	ELSE 'Others'
	END AS procurement_type_description,

	mp.plant_specific_material_status,

	CASE
	WHEN mp.plant_specific_material_status = 'DM' THEN 'Material Deleted/Never Used'
	WHEN mp.plant_specific_material_status = 'TB' THEN 'Material Fully Retired'
	WHEN mp.plant_specific_material_status = 'RP' THEN 'Retirement : In Progress/All transactions are blocked'
	WHEN mp.plant_specific_material_status = 'RT' THEN 'Retirement : In progress with no stock but still open orders/All transactions are blocked except those for closing operational elements'
	WHEN mp.plant_specific_material_status = 'RB' THEN 'Retirement : In progress with orders closed but stock remains/All transactions are blocked except those for inventory removal'
	WHEN mp.plant_specific_material_status = 'RA' THEN 'Retirement : Set for retirement analysis/All transactions are blocked'
	WHEN mp.plant_specific_material_status = 'WF' THEN 'Material is currently being created/modified'
	WHEN mp.plant_specific_material_status IS NULL THEN 'Active'
	ELSE 'Description Under Review / Thank you for Patience'
	END AS plant_specific_material_status_description,
	
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
				AND identifier_type ILIKE '%materialnumber%'
				AND variety_number IS NOT NULL
				AND preferred_id IS true
			) m ON m.material_id = sa.material_id

	--- Material Plant Attributes
LEFT JOIN 
(
			SELECT DISTINCT
							material_id,
							plant_id, 
							procurement_type, 
							plant_specific_material_status
			FROM public.mio02_material_plant
			WHERE record_type = 'material_plant' 
						AND source_system_cde = 'FNDG'
) mp ON mp.material_id = sa.material_id

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
				AND db_current_status IS true 
		   ) b ON b.batch_cid = sa.batch_cid
		
WHERE sa.availability_date >= GETDATE()
	
	AND sa.master_profile IN ('EAME Prod_1','EAME Prod_2')
	AND sa.available_quantity_for_planning_in_reporting_uom <> 0
	AND m.material_group IN ('COM500','COM700') 
	AND m.species IN ('Prod_1','Prod_2')
	AND b.designated_country_cde IN ('Country_1','Country_2','Country_3','Country_4')
	GROUP BY 1,2,3,4
	ORDER BY quantity_in_reporting_uom DESC;
