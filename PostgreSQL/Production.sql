/*
Description:
A Process Order is used for the production of materials or for rendering of services in a specific quantity on a specific date. 
They enable the planning of resources, control of process order management, and specify the rules for account assignment and order settlement. 

*/

SELECT 

	pof.process_order_type_cid, 
	pof.process_order_number, 
	pof.process_order_item, 
	pos.sales_order_document_number,
	pos.sales_order_item_number,
	pos.process_order_status_cid,
	pos.short_description,
	pos.long_description,
	pof.material_id, 
	m.description, 
	m.material_group, 
	m.material_group_description, 
	m.variety_name,
	m.treatment,
	m.treatment_description,
	pof.batch_cid,
	batch_number.batch_quality_characteristic_value AS batch_number,
	quality_status.batch_quality_characteristic_value AS batch_quality_status, 
	quality_class.batch_quality_characteristic_value AS batch_quality_class,
    supply_status.batch_quality_characteristic_value AS batch_supply_status,
	certification_status.batch_quality_characteristic_value AS batch_certification_status,
	certification_type.batch_quality_characteristic_value AS batch_certification_type,
	oic_status.batch_quality_characteristic_value AS batch_oic_status,
	harvest_year.batch_quality_characteristic_value AS batch_harvest_year,
	packing_plant.batch_quality_characteristic_value AS batch_packing_plant,
	process_plant.batch_quality_characteristic_value AS batch_process_plant,
	treatment_plant.batch_quality_characteristic_value AS batch_treatment_plant,
	sizing_accuracy.batch_quality_characteristic_value AS batch_sizing_accuracy,
	internal_lot_number.batch_quality_characteristic_value AS batch_internal_lot_number,
	official_number.batch_quality_characteristic_value AS batch_official_number,
	germination_final_count.batch_quality_characteristic_value AS batch_germination_final_count,
	batch_caliber.batch_quality_characteristic_value AS batch_caliber,
	visual_appearance_rating.batch_quality_characteristic_value AS batch_visual_appearance_rating,
	phyto_certificate_number.batch_quality_characteristic_value AS batch_phyto_certificate_number,
	field_multiplication_certification.batch_quality_characteristic_value AS batch_field_multiplication_certification,
	b.last_goods_receipt_date, 
	b.origin_country_cde, 
	b.designated_country_cde, 
	pof.grower_contract_number,
	pof.vendor_bp_cid,
	bp.name AS vendor_name,
	pof.confirmed_quantity_in_base_uom, 
	pof.base_uom,
	pof.basic_start_date,
	pof.basic_finish_date,
	pof.company_code, 
	pof.plant_id,
	pof.target_quantity_in_base_uom, 
	pof.scheduled_start_date,
	pof.scheduled_end_date,
	date_part(year, pof.scheduled_end_date) AS scheduled_end_year,
	date_part(month, pof.scheduled_end_date) AS scheduled_end_month,
	date_part(quarter, pof.scheduled_end_date) AS scheduled_end_quarter,
	date_part(week, pof.scheduled_end_date) AS scheduled_end_week,
	date_part(day, pof.scheduled_end_date) AS scheduled_end_day,
	pof.confirmed_order_finish_date,
	pof.actual_release_date,
	pof.planned_release_date,
	pof.order_item_quantity_in_base_uom,
	pof.scrap_quantity_item_in_base_uom,
	pof.goods_receipt_quantity_in_base_uom,
	b.system_goods_receipt_date,
	date_part(year, b.system_goods_receipt_date) AS system_goods_receipt_year,
	date_part(month, b.system_goods_receipt_date) AS system_goods_receipt_month,
	date_part(quarter, b.system_goods_receipt_date) AS system_goods_receipt_quarter,
	date_part(week, b.system_goods_receipt_date) AS system_goods_receipt_week,
	date_part(day, b.system_goods_receipt_date) AS system_goods_receipt_day,
	pof.actual_start_date,
	pof.actual_end_date,
	pof.storage_location_cid,
	pof.scheduled_release_date,
	pof.fix_quantity_scrap_in_base_uom,
	pof.total_planned_order_quantity_in_base_uom,
	pof.current_estimate_quantity,
	pof.current_estimate_quantity_uom,
	pof.record_type,
	pof.at_risk_quantity,
	pof.total_order_quantity,
	pof.yield_uom,
	pof.riskqty_unit_of_measure,
	pof.vendor_bp_cid,
	pof.basic_finish_date_updated,
	pof.stock_at_farm_in_kg,
	pof.actual_scrap_quantity_in_goods_received_base_uom,
	pof.db_update_date_time
					
FROM public.db120_process_order_fact pof

--- material attributes
LEFT JOIN 
(
			SELECT
							material_id, 
							description,
							species, 
							material_group, 
							material_group_description, 
							variety_name,
							treatment,
							treatment_description
			FROM public.db02_material 
			WHERE record_type = 'Seeds' 
						AND identifier_type LIKE '%materialnumber%'
						AND preferred_id = 'true'
) m ON m.material_id = pof.material_id
		
	
--- process order status (TECO = Technically Closed, CLSD = Closed, DLV = Delivered)
LEFT JOIN 
(
			SELECT 
							process_order_number,
							sales_order_document_number,
							sales_order_item_number,
							process_order_status_cid,
							short_description,
							long_description
			FROM public.db120_process_order_status 
			WHERE db_source_system_cde = 'FNDG'
						AND short_description IN ('TECO','CLSD','DLV')
) pos ON pos.process_order_number = pof.process_order_number 

--- batch attributes
LEFT JOIN 
(
			SELECT 
							batch_cid,
							last_goods_receipt_date, 
							origin_country_cde, 
							designated_country_cde, 
							system_goods_receipt_date
			FROM public.db119_batch
			WHERE source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) b ON b.batch_cid = pof.batch_cid

--- batch batch number
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG894'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) batch_number ON batch_number.batch_cid = pof.batch_cid

--- batch quality status
LEFT JOIN 
(
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG897'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) quality_status ON quality_status.batch_cid = pof.batch_cid 

--- batch quality class
LEFT JOIN 
(
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG906'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) quality_class ON quality_class.batch_cid = pof.batch_cid 

--- batch supply status
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG903'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) supply_status ON supply_status.batch_cid = pof.batch_cid

--- batch certification status
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG1445'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) certification_status ON certification_status.batch_cid = pof.batch_cid

--- batch certification type
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG869'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) certification_type ON certification_type.batch_cid = pof.batch_cid

--- batch oic status
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG1583'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) oic_status ON oic_status.batch_cid = pof.batch_cid

--- batch harvest year
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG898'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) harvest_year ON harvest_year.batch_cid = pof.batch_cid

--- batch packing plant
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG913'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) packing_plant ON packing_plant.batch_cid = pof.batch_cid

--- batch process plant
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG923'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) process_plant ON process_plant.batch_cid = pof.batch_cid

--- batch treatment plant
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG928'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) treatment_plant ON treatment_plant.batch_cid = pof.batch_cid

--- batch sizing accuracy
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG3346'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) sizing_accuracy ON sizing_accuracy.batch_cid = pof.batch_cid

--- batch internal lot number
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG907'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) internal_lot_number ON internal_lot_number.batch_cid = pof.batch_cid

--- batch official number
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG912'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) official_number ON official_number.batch_cid = pof.batch_cid

--- batch germination final count
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG914'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) germination_final_count ON germination_final_count.batch_cid = pof.batch_cid


--- batch batch caliber

LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG926'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) batch_caliber ON batch_caliber.batch_cid = pof.batch_cid

--- batch visual appearance rating
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG1393'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) visual_appearance_rating ON visual_appearance_rating.batch_cid = pof.batch_cid

--- batch phyto certificate number
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG1032'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) phyto_certificate_number ON phyto_certificate_number.batch_cid = pof.batch_cid

--- batch field multiplication certification
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG2736'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) field_multiplication_certification ON field_multiplication_certification.batch_cid = pof.batch_cid
	
--- Vendors for Process Orders
LEFT JOIN 
(
			SELECT DISTINCT
							bp_cid,  
							name
            FROM public.db03_business_partner 
            WHERE bp_cid IN 
(
            SELECT DISTINCT 
							vendor_bp_cid 
            FROM public.db120_process_order_fact 
            WHERE source_system_cde = 'FNDG'
                		AND date_part(year, actual_end_date) >= '2020'
)) bp ON bp.bp_cid = pof.vendor_bp_cid	
	




			WHERE date_part(year, actual_end_date) >= '2022'

						AND pof.process_order_type_cid IN ('F01','FNP02','FN03','FN04')
						AND pof.record_type = 'item'
						AND db_delete_flag = 'false'
						AND db_current_status = 'true'
						AND source_system_cde = 'FNDG'
					---	AND pof.vendor_bp_cid IS NOT NULL
						AND m.material_group IN ('COM700') 
						AND m.species IN ('Product_1','Product_2')
						AND b.designated_country_cde IN ('Country_1','Country_2','Country_3','Country_4')
---			GROUP BY 1,2,3,4,5,6,7,8,9,10
---			ORDER BY target_quantity_in_base_uom DESC, goods_receipt_quantity_in_base_uom DESC
;
