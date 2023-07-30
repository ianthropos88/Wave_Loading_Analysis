/* 
(A batch is a partial quantity of a product or material with homogeneous characteristics . A Batch Object in SAP, is defined by Batch Number, 
Material Number and Plant Number (The plant is only relevant if the batch level is defined on plant level).

The Batch dataset provides below information:

Batch Master Data - Info about Batch ID, Material ID, Created Date , Changed Date, Expiry Date,  etc. 
Batch Quality Information - Info on Batch Classification and Quality Characteristics Data ( Germination count, TSW, AI Content %, etc.)
*/


SELECT

	b.batch_cid,
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
	b.origin_country_cde, 
	b.designated_country_cde, 
	b.system_goods_receipt_date,
    b.db_update_date_time

            FROM public.db_batch b

--- batch batch number
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG894'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) batch_number ON batch_number.batch_cid = b.batch_cid

--- batch quality status
LEFT JOIN 
(
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG897'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) quality_status ON quality_status.batch_cid = b.batch_cid 

--- batch quality class
LEFT JOIN 
(
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG906'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) quality_class ON quality_class.batch_cid = b.batch_cid 

--- batch supply status
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG903'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) supply_status ON supply_status.batch_cid = b.batch_cid

--- batch certification status
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG1445'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) certification_status ON certification_status.batch_cid = b.batch_cid

--- batch certification type
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG869'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) certification_type ON certification_type.batch_cid = b.batch_cid

--- batch oic status
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG1583'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) oic_status ON oic_status.batch_cid = b.batch_cid

--- batch harvest year
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG898'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) harvest_year ON harvest_year.batch_cid = b.batch_cid

--- batch packing plant
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG913'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) packing_plant ON packing_plant.batch_cid = b.batch_cid

--- batch process plant
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG923'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) process_plant ON process_plant.batch_cid = b.batch_cid

--- batch treatment plant
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG928'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) treatment_plant ON treatment_plant.batch_cid = b.batch_cid

--- batch sizing accuracy
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG3346'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) sizing_accuracy ON sizing_accuracy.batch_cid = b.batch_cid

--- batch internal lot number
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG907'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) internal_lot_number ON internal_lot_number.batch_cid = b.batch_cid

--- batch official number
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG912'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) official_number ON official_number.batch_cid = b.batch_cid

--- batch germination final count
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG914'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) germination_final_count ON germination_final_count.batch_cid = b.batch_cid


--- batch batch caliber

LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG926'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) batch_caliber ON batch_caliber.batch_cid = b.batch_cid

--- batch visual appearance rating
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG1393'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) visual_appearance_rating ON visual_appearance_rating.batch_cid = b.batch_cid

--- batch phyto certificate number
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG1032'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) phyto_certificate_number ON phyto_certificate_number.batch_cid = b.batch_cid

--- batch field multiplication certification
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG2736'
						AND source_system_cde = 'FNDG'
						AND db_current_status IS true 
) field_multiplication_certification ON field_multiplication_certification.batch_cid = b.batch_cid

WHERE b.batch_deleted_ind = 'false' 



						AND b.source_system_cde = 'FNDG'
						AND date_part(year, system_goods_receipt_date) >= '2022'
						AND b.designated_country_cde IN ('Country_1','Country_2','Country_3','Country_4')
;
