/*
Description:
A delivery document is the central object in the logistic execution process, which allows documenting and tracking activities such as delivery scheduling, 
picking and packing.

This dataset provides a consolidated view on Delivery - both inbound and outbound delivery information for Seeds. Additionally, 
it contains the delivery conditions (for Products/Foundation), which provides the transport surcharges, etc.

Dataset -  provides the following details:

Who and What– who are the delivery partners, what is the type of delivery,  which material,  batch, quantities, delivery conditions, etc.
When and Where – What dates - for delivery, goods issue/receipt, picking, packing, etc and which plants, Shipping/receiving points.
GDPR Implementation: Personal identifiable attributes in this MIO are encrypted due to GDPR compliance requirements.

*/



SELECT 

--- Material Details from FNDG ---

    m.material_id,
    m.material_type,
    m.division,
    m.division_description,
    m.description,
    m.material_group,
    m.material_group_description,
    m.quantity_of_package,
    m.quantity_of_package_uom,
    m.base_uom,

--- Delivery Details from FNDG ---

    d.planned_goods_issue_date,
    d.actual_goods_issue_date,
	date_part(year, actual_goods_issue_date) AS AGI_year,
	date_part(quarter, actual_goods_issue_date) AS AGI_quarter,
	date_part(month, actual_goods_issue_date) AS AGI_month,
	date_part(week, actual_goods_issue_date) AS AGI_week,
	date_part(day, actual_goods_issue_date) AS AGI_day, 
    d.picking_control_ind,
	d.loading_date,
	date_part(year, loading_date) AS loading_year,
	date_part(quarter, loading_date) AS loading_quarter,
	date_part(month, loading_date) AS loading_month,
	date_part(week, loading_date) AS loading_week,
	date_part(day, loading_date) AS loading_day,
    d.created_date,
    d.sales_org_cde,
    d.delivery_date, 
    d.delivery_document_date,
	d.delivery_number,
---	COUNT(DISTINCT delivery_number)	AS delivery_number_count,
    d.delivery_item_number,
    d.delivery_type_cid,
    d.sales_order_number,
    d.sales_order_item_number,
    d.batch_number_cid,
    
--- Purchase Order and Sales Order Document from FNDG ---

	d.sales_order_number,
	d.sales_order_item_number,
    pof.order_document_type, 

--- Batch Details from FNDG ---

	bt.origin_country_cde, 
	bt.designated_country_cde, 
	bt.system_goods_receipt_date,

--- Batch Quality Details from FNDG ---

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

--- Delivery Details from FNDG ---

    d.shipping_point,
    d.plant_id,
    RIGHT(d.storage_location_cid,4) AS storage_location,
--- SUBSTRING(d.storage_location_cid, 5, LENGTH(d.storage_location_cid)) AS storage_location_id
    d.delivery_block_header,
    d.picking_date,
    d.actual_quantity_delivered_in_base_uom,
    (d.actual_quantity_delivered_in_base_uom * auom_ks. base_to_ks_conversion_rate) AS actual_quantity_delivered_in_ks, 
    (d.actual_quantity_delivered_in_base_uom * auom_kg. base_to_kg_conversion_rate) AS actual_quantity_delivered_in_kg,
    d.record_type,

--- Goods Movement Details ---

    gm.purchasing_document_number,
    gm.purchasing_document_item_number,
    gm.batch_cid,
    gm.posting_date AS GR_posting_date,

--- Business Partner Details ---

    bp.bp_cid,
    bp.city,
    bp.postalcode,
    bp.country_code,

--- Business Partner Storage Location Details ---

    sl.plant_id,
    sl.storage_location_cid,
    sl.source_system_cde,
    sl.customer_bp_cid,

--- Logistic Details from FNDG ---

	d.ship_to_bp_cid,
    d.gross_weight,
    d.net_weight,
    d.delivery_priority,
    d.base_uom,
    d.sales_uom,
    d.delivery_item_created_by,
    d.picking_control_ind,

--- Logistic Details from TMS Transportation Order ---

    tr.subitem_key,
    tr.batch_number,
    tr.business_unit,
    tr.item_quantity_per_package AS loaded_quantity_per_bag,
	tr.item_quantity AS loaded_units,
	tr.item_quantity_uom,
	tr.subitem_quantity AS loaded_bags_per_pallet,
	tr.subitem_quantity_uom,
    tr.status_code,

--- Transport Details from TMS ---

    sf.shipment_id,
    sf.shipment_mode,
    sf.container_container_load,
    sf.freight_forwarder AS carrier_name,
    sf.partner_no_carrier,
    sf.calculated_co2_emission,
    sf.distribution_type,
    sf.driver_name_id_company_name,
    sf.country_of_despatch,
    sf.country_of_destination,
    sf.departure_sub_contractor,
    sf.departure_driver_name,
    sf.receiving_site_truck_plate,
    sf.receiving_site_trailer_plate,
    sf.receiving_site_sub_contractor,
    sf.receiving_site_driver_name,

--- Shipment Details from TMS ---

    sh.truck_number,
    sh.trailer_number,

--- Milestone Details from TMS ---

    sm.ponumber,
    sm.milestone_code,
    sm.milestone_reason_code,
	sm.milestone_time_date,
	date_part(year, milestone_time_date) AS milestone_year,
	date_part(quarter, milestone_time_date) AS milestone_quarter,
	date_part(month, milestone_time_date) AS milestone_month,
	date_part(week, milestone_time_date) AS milestone_week,
	date_part(day, milestone_time_date) AS milestone_day, 
    sm.milestone_time_lt_date,
    sm.milestone_time_lt_datetime,

--- Billing Details ---

    bf.billing_document_number,
    bf.net_value_of_billing_item_in_document_currency,
    bf.document_currency
		
FROM public.db_delivery_fact d

--- Material Attributes
LEFT JOIN 
(
			SELECT DISTINCT
							material_id, 
                            material_type,
							description,
							species, 
							material_group,
							material_group_description, 
							variety_name,
							treatment,
							treatment_description,
                            division,
                            division_description,
                            quantity_of_package,
                            quantity_of_package_uom,
                            base_uom
			FROM public.db_material 
			WHERE record_type = 'Seeds' 
						AND division IN ('01','A','B','Z','E') 
                        OR (division IN ('99')
                        AND material_type = 'VERP')
						AND material_group like 'COM%'
                        AND identifier_type LIKE '%materialnumber%'
                        AND preferred_id = 'true'
) m ON m.material_id = d.material_id

--- Purchase Order and Sales Order Document Type Attributes
LEFT JOIN 
(
(
			SELECT DISTINCT 
							purchasing_document_number AS order_document_number, 
							purchasing_document_type AS order_document_type, 
							'db121_purchase_order_fact_seeds ' AS order_source_mio
			FROM public.db_purchase_order_fact_seeds 
			WHERE source_system_cde = 'FNDG'
                    	AND record_type = 'ITEM'
)
			UNION 
(
			SELECT DISTINCT 
							sales_order_document_number AS order_document_number, 
							order_type_cid AS order_document_type, 
							'db_sales_order_fact' AS order_source_mio
			FROM public.db20_sales_order_fact 
			WHERE source_system_cde = 'FNDG'
                    	AND record_type = 'ITEM'
                        AND (deleted_orders_ind IS NULL 
						OR deleted_orders_ind = '')
)
) pof ON pof.order_document_number = d.sales_order_number

--- Batch Attributes
LEFT JOIN 
(
			SELECT 
							batch_cid,
							origin_country_cde, 
							designated_country_cde, 
							system_goods_receipt_date
			FROM public.db119_batch
			WHERE source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) bt ON bt.batch_cid = d.batch_number_cid

--- Batch Number Attributes
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG894'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) batch_number ON batch_number.batch_cid = d.batch_number_cid

--- Batch Quality Status Attributes
LEFT JOIN 
(
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG897'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) quality_status ON quality_status.batch_cid = d.batch_number_cid 

--- Batch Quality Class Attributes
LEFT JOIN 
(
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG906'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) quality_class ON quality_class.batch_cid = d.batch_number_cid 

--- Batch Supply Status Attributes
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG903'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) supply_status ON supply_status.batch_cid = d.batch_number_cid

--- Batch Certification Status Attributes
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG1445'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) certification_status ON certification_status.batch_cid = d.batch_number_cid

--- Batch Certification Type Attributes
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG869'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) certification_type ON certification_type.batch_cid = d.batch_number_cid

--- Batch OIC Status Attributes
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG1583'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) oic_status ON oic_status.batch_cid = d.batch_number_cid

--- Batch Harvest Year Attributes
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG898'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) harvest_year ON harvest_year.batch_cid = d.batch_number_cid

--- Batch Packing Plant Attributes
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG913'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) packing_plant ON packing_plant.batch_cid = d.batch_number_cid

--- Batch Process Plant Attributes
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG923'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) process_plant ON process_plant.batch_cid = d.batch_number_cid

--- Batch Treatment Plant Attributes
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG928'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) treatment_plant ON treatment_plant.batch_cid = d.batch_number_cid

--- Batch Sizing Accuracy Attributes
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG3346'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) sizing_accuracy ON sizing_accuracy.batch_cid = d.batch_number_cid

--- Batch Internal Lot Number Attributes
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG907'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) internal_lot_number ON internal_lot_number.batch_cid = d.batch_number_cid

--- Batch Official Number Attributes
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG912'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) official_number ON official_number.batch_cid = d.batch_number_cid

--- Batch Germination Final Count Attributes
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG914'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) germination_final_count ON germination_final_count.batch_cid = d.batch_number_cid


--- Batch Caliber Attributes

LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG926'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) batch_caliber ON batch_caliber.batch_cid = d.batch_number_cid

--- Batch Visual Appearance Rating Attributes
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG1393'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) visual_appearance_rating ON visual_appearance_rating.batch_cid = d.batch_number_cid

--- Batch Phyto Certificate Number Attributes
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG1032'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) phyto_certificate_number ON phyto_certificate_number.batch_cid = d.batch_number_cid

--- Batch Field MLultiplication Certification Attributes
LEFT JOIN 
( 
			SELECT 
							batch_cid, 
							batch_quality_characteristic_value 
			FROM public.db119_batch_quality 
			WHERE batch_quality_characteristic_cde_cid = 'FNDG2736'
						AND source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
) field_multiplication_certification ON field_multiplication_certification.batch_cid = d.batch_number_cid

--- Conversion Factor for base_uom to KS Attributes 
LEFT JOIN 
(
			SELECT 
							(mma_ks.alt_uom_factor_base / mma_ks.alt_uom_factor_alt) AS base_to_ks_conversion_rate, 
							mma_ks.material_guid, 
							mm1.material_id, 
							mma_ks.alt_uom
			FROM public.db02_material_auom mma_ks
LEFT JOIN 
(
            SELECT 
							material_guid, 
							material_id 
            FROM public.db02_material 
            WHERE preferred_id = 'true'
						AND identifier_type LIKE '%materialnumber%'
						AND record_type = 'Seeds'
) mm1 ON mm1.material_guid = mma_ks.material_guid
			WHERE mma_ks.alt_uom = 'KS' 
						AND mma_ks.source_system_cde = 'FNDG'
) auom_ks ON auom_ks.material_id = d.material_id

--- Conversion Factor for base_uom to KG Attributes
LEFT JOIN 
(
			SELECT 
							(mma_kg.alt_uom_factor_base / mma_kg.alt_uom_factor_alt) AS base_to_kg_conversion_rate, 
							mma_kg.material_guid, 
							mm1.material_id, 
							mma_kg.alt_uom
			FROM public.db02_material_auom mma_kg
LEFT JOIN 
(
            SELECT 
							material_guid, 
							material_id 
        	FROM public.db02_material 
            WHERE preferred_id = 'true' 
						AND identifier_type LIKE '%materialnumber%'
						AND record_type = 'Seeds'
) mm1 ON mm1.material_guid = mma_kg.material_guid
			WHERE mma_kg.alt_uom = 'KG' 
						AND mma_kg.source_system_cde = 'FNDG'
) auom_kg ON auom_kg.material_id = d.material_id

--- Goods Movement Attributes
LEFT JOIN 
(
			SELECT 
                            purchasing_document_number,
                            purchasing_document_item_number,
                            batch_cid,
                            posting_date
			FROM public.db211_goods_movement_fact
            WHERE movement_type = '101'
            AND batch_cid IN
(
            SELECT DISTINCT 
							batch_number_cid 
            FROM public.db134_delivery_fact 
            WHERE record_type = 'item'
						AND source_system_cde = 'FNDG'
                        AND item_deleted_ind = 'false'
)) gm ON gm.batch_cid = d.batch_number_cid

--- Business Partner Attributes
LEFT JOIN 
(
			SELECT 
                            bp_cid,
                            city,
                            postalcode,
                            country_code
            FROM public.db03_business_partner 
            WHERE business_partner_type = 'customer'
            AND bp_cid IN 
(
            SELECT DISTINCT 
							ship_to_bp_cid 
            FROM public.db134_delivery_fact 
            WHERE source_system_cde = 'FNDG'
                        AND record_type = 'item'
                        AND item_deleted_ind = 'false'
                		AND date_part(year, created_date) >= '2020'
)) bp ON bp.bp_cid = d.ship_to_bp_cid	

--- Storage Location Attributes
LEFT JOIN 
(
			SELECT 
                            plant_id,
                            storage_location_cid,
                            source_system_cde,
                            customer_bp_cid
            FROM public.db54_storage_location 
            WHERE mio_delete_ind = 'false'
            AND db_current_status = 'true'
            AND source_system_cde = 'FNDG'
            AND customer_bp_cid IN 
(
            SELECT DISTINCT 
							ship_to_bp_cid 
            FROM public.db134_delivery_fact 
            WHERE source_system_cde = 'FNDG'
                        AND record_type = 'item'
                        AND item_deleted_ind = 'false'
                		AND date_part(year, created_date) >= '2020'
)) sl ON sl.customer_bp_cid = d.ship_to_bp_cid

--- Transportation Order Attributes
LEFT JOIN 
(
			SELECT DISTINCT
                            delivery_number,
                            item_material_id,
                            subitem_key,
                            batch_number,
                            business_unit,
                            item_quantity_per_package,
							item_quantity,
							item_quantity_uom,
							subitem_quantity,
							subitem_quantity_uom,
                            status_code
			FROM public.db101_transportation_order
            WHERE item_material_id IN 
(
            SELECT DISTINCT 
							material_id 
            FROM public.db02_material 
            WHERE record_type = 'Seeds' 
						AND division IN ('01','A','B','Z','E') 
                        OR (division IN ('99')
                        AND material_type = 'VERP')
						AND material_group like 'COM%'
)) tr ON tr.item_material_id = m.material_id

---  Shipment Delivery Attributes
LEFT JOIN 
(
			SELECT DISTINCT
                            shipment_id,
                            delivery_number,
                            shipment_mode,
                            container_container_load,
                            freight_forwarder,
                            partner_no_carrier,
                            calculated_co2_emission,
                            distribution_type,
                            driver_name_id_company_name,
                            country_of_despatch,
                            country_of_destination,
                            departure_sub_contractor,
                            departure_driver_name,
                            receiving_site_truck_plate,
                            receiving_site_trailer_plate,
                            receiving_site_sub_contractor,
                            receiving_site_driver_name

			FROM public.db007_shipment_fact
---			WHERE shipment_id IN ('H485454','3111','T503' ) 
---						AND shipment_source IN ('Delivery','DELIVERY')
---						AND date_part(y, acp_milestone_date_time) >= '2022'
---						AND date_part(mon, acp_milestone_date_time) >= '09'
) sf ON sf.shipment_id = d.shipment_cid

---  Shipment Vehicle Attributes
LEFT JOIN 
(
			SELECT DISTINCT
                            delivery_number,
                            shipment_id,
                            freight_forwarder,
                            truck_number,
                            trailer_number,
                            country_of_despatch,
                            country_of_destination

			FROM public.db007_shipment
---			WHERE shipment_id IN ('H454','3111','T503' ) 
---						AND shipment_source IN ('Delivery','DELIVERY')
---						AND date_part(y, acp_milestone_date_time) >= '2022'
---						AND date_part(mon, acp_milestone_date_time) >= '09'
) sh ON sh.shipment_id = d.shipment_cid

---  Shipment Milestone Attributes
LEFT JOIN 
(
			SELECT DISTINCT
                            shipment_id,
                            ponumber,
                            milestone_code,
                            milestone_reason_code,
							milestone_time_date,
                            milestone_time_lt_date,
                            milestone_time_lt_datetime

			FROM public.db007_shipment_milestone
            WHERE milestone_code IN ('PTP','AGP','ACP','LTP','EAD','AAD','PGI')
) sm ON  sm.shipment_id = d.shipment_cid

--- Billing Detail Attributes

LEFT JOIN 
(
			SELECT DISTINCT
                            delivery_number,
                            billing_document_number,
                            net_value_of_billing_item_in_document_currency,
                            document_currency

			FROM public.db021_billing_fact 
			WHERE record_type='billing_item' 
						AND record_cancellation_status = '0'

) bf ON bf.delivery_number = d.delivery_number

			WHERE d.material_id IN 
(
			SELECT DISTINCT 
							material_id 
			FROM public.db02_material 
			WHERE record_type = 'Seeds' 
						AND division IN ('01','A','B','Z','E') 
                        OR (division IN ('99')
                        AND material_type = 'VERP')
						AND material_group like 'COM%'
)
						AND d.actual_quantity_delivered_in_base_uom <> 0
						AND d.source_system_cde = 'FNDG'
                        AND d.record_type = 'item'
						AND d.loading_date >= '2022-09-01'
						AND d.item_deleted_ind = 'false'
						AND m.species IN ('Product_2','Product_1')
						AND m.material_group IN ('COM700')
						AND bp.country_code IN ('Country_1','Country_2','Country_3','Country_4')
;
