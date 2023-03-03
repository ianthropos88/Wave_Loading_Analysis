SELECT 

	sm.material_id,
	m.description, 
	m.material_group, 
	m.variety_name, 
	sm.batch_cid,
	b.batch_quality_characteristic_cde_cid, 
	b.batch_quality_characteristic_description, 
	b.batch_quality_characteristic_value, 
	b.last_goods_receipt_date, 
	b.origin_country_cde, 
	b.designated_country_cde, 
	b.system_goods_receipt_date,
	sm.plant_id,
	sm.movement_type, 
	sm.quantity_unit_of_entry, 
	sm.unit_of_entry,
	sm.amount_local_currency,
	sm.local_currency_code, 
	sm.number_of_pallets,
	sm.material_document_year,
	sm.document_date,
	sm.posting_date,
	sm.company_code,
	sm.order_number,
	sm.routing_operation_order_number,
	sm.delivery_costs_local_currency,
	sm.stock_values_lis,
	sm.stock_categories_lis,
	sm.stock_releavance,
	sm.purchase_value_local_currency,
	sm.valuation_area_plant_id,
	sm.reason_for_goods_movement,
	sm.business_area,
	sm.sales_order_document_number,
	sm.delivery_schedule_sales_order,
	sm.sales_order_item_number,
	sm.controlling_area,
	sm.cost_center,
	sm.warehouse_number,
	sm.storage_location_cid,
	sm.storage_bin,
	sm.storage_type,
	sm.account_number_vendor,
	sm.record_type,
	sm.base_uom,
	sm.quantity,
	sm.quantity_base_uom,
	sm.receiving_issuing_plant_id,
	sm.goods_recipient_ship_to_bp_cid,
	bp.fax AS bp_fax,
	bp.phone AS bp_phone,
	bp.email AS bp_email,
	bp.local_currency_code AS bp_local_currency_code,
	bp.first_name AS bp_first_name,
	bp.last_name AS bp_last_name,
	bp.city AS bp_city,
	bp.country AS bp_country,
	bp.country_code AS bp_country_code,
	bp.state AS bp_state,
	bp.street1 AS bp_street1,
	bp.street2 AS bp_street2,
	bp.district AS bp_district,
	bp.postalcode AS bp_postalcode,
	sm.total_usage_quantity,
	sm.total_usage_value,
	sm.valuated_stock_receipts_value,
	sm.quantity_sap,
	sm.db_update_date_time
			
			
FROM public.db211_goods_movement_fact sm

-- material attributes
LEFT JOIN (
			SELECT 
				material_id, 
                description,
				material_group, 
                variety_name,
				species
			FROM public.db02_material 
			WHERE record_type = 'Seeds' 
				AND identifier_type LIKE '%materialnumber%'
				AND preferred_id = 'true'
			) m ON m.material_id = sm.material_id


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
			FROM public.db119_batch
			WHERE source_system_cde = 'FNDG'
				AND db_current_status = 'true'
		   ) b ON b.batch_cid = sm.batch_cid


-- Business Partner attributes
LEFT JOIN (
			SELECT 
				bp_cid,
				fax,
				phone,
				email,
				local_currency_code,
				first_name,
				last_name,
				city,
				country,
				country_code,
				state,
				street1,
				street2,
				district,
				postalcode
            FROM public.db03_business_partner 
            WHERE bp_cid IN (
            	SELECT DISTINCT goods_recipient_ship_to_bp_cid 
                FROM public.db211_goods_movement_fact 
                WHERE db_source_system_cde = 'FNDG'
                	AND date_part(year, document_date) >= '2020'
          )) bp ON bp.bp_cid = sm.goods_recipient_ship_to_bp_cid	


WHERE date_part(year, posting_date) >= '2022'

	AND sm.movement_type IN ('261','262')
	AND b.designated_country_cde IN ('Country_1','Country_2','Country_3','Country_4')
	AND m.material_group IN ('COM700') 
	AND m.species IN ('Product_1','Product_2');