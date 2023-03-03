/*

Description:
This dataset contains information describing Outbound Delivery, 
3rd party Purchase Order and Shipping Orders taken from TMS. 
Shipping orders is a part of 3rd party PO process.

*/

SELECT  

	d.material_id,
	m.description,
	t.transportation_order_id,
	t.transportation_object_cid,
	t.po_number,
	t.transportation_order_type,
	t.status_code,
	t.order_function_code,
	t.shipment_method_code AS shipment_method,
	t.is_trans_shipment_allowed,
	t.is_partial_shipment_allowed,
	t.freight_payment_code,
	t.event_date,
	t.event_date_time,
	t.event_role_code,
	t.event_type_code,
	t.issue_date,
	t.cancel_after_date,
	t.shipping_point_plant_id,
	pt.long_description, 
    pt.country, 
	t.plant_company_code,
	d.delivery_number,
	t.delivery_priority,
	t.receiving_plant_id,
	t.bulkdelivery,
	t.primarysecondarydistribution,
	t.earliest_date,
	t.latest_date,
	t.promised_delivery_date,
	t.item_sequencenumber,
	t.item_destination_location_address_line AS delivery_address,
	t.item_destination_location_long_name AS delivery_address_description,
	t.delivery_object_cid,
	t.item_quantity_per_package AS quantity_per_bag,
	t.item_quantity AS units,
	t.item_quantity_uom,
	t.item_measurement_value AS gross_weight,
	t.item_measurement_uom AS unit_of_measure,
	t.item_net_weight AS net_weight,
	t.item_weight_uom AS item_unit_of_measure,
	t.subitem_key,
	t.subitem_quantity AS bags_per_pallet,
	t.subitem_quantity_uom,
	t.subitem_shipment_method_code,
	t.subitem_sequencenumber,
	t.batch_number,
	s.truck_number,
	s.trailer_number,
	s.container_number,
	s.departure_driver_name,
	s.receiving_site_driver_name AS receiving_driver_name,
    s.shipment_id, 
    s.shipment_mode,
	t.mio_update_date_time

FROM public.db101_transportation_order_fact t

--- material attributes
LEFT JOIN 
(
			SELECT 
							material_id, 
							species,
							material_group, 
							description
			FROM public.db02_material 
			WHERE record_type = 'Seeds' 
						AND identifier_type LIKE '%materialnumber%'
						AND preferred_id = 'true'
) m ON m.material_id = t.item_material_id

--- plant attributes
LEFT JOIN 
(
			SELECT 
							plant_id, 
							long_description, 
							country
			FROM public.db54_plant
			WHERE source_system_cde = 'FNDG'
						AND db_current_status = 'true' 
						AND fact_guid IS NOT NULL
) pt ON pt.plant_id = t.shipping_point_plant_id

---  Shipment Linitem attributes
LEFT JOIN 
(
			SELECT DISTINCT
                            shipment_id,
							delivery_object_cid,
							truck_number,
							trailer_number,
							container_number,
							departure_driver_name,
							receiving_site_driver_name, 
							shipment_mode

			FROM public.db007_shipment
---			WHERE shipment_id IN ('HSK0485454','319011','T079.113503' )
---			WHERE 
                    ---AND shipment_source IN ('Delivery','DELIVERY')
                	---AND date_part(y, acp_milestone_date_time) >= '2022'
                    ---AND date_part(mon, acp_milestone_date_time) >= '09'
) s ON s.delivery_object_cid = t.delivery_object_cid

---  delivery SAP attributes
LEFT JOIN 
(
			SELECT DISTINCT
                            material_id,
							delivery_number

			FROM public.db134_delivery_fact
			WHERE source_system_cde = 'FNDG'
						AND record_type = 'item'
						AND item_deleted_ind = 'false'
) d ON '00' + d.delivery_number = t.delivery_number

	
			WHERE date_part(year, promised_delivery_date) >= '2022'
						AND t.item_quantity <> 0
---						AND t.record_type = 'item'
---						AND t.transportation_order_type = 'DELIVERY'
						AND t.business_unit = 'Seeds'
---						AND t.primarysecondarydistribution = 'Secondary'
						AND t.item_to_country_code IN ('Country_1','Country_2','Country_3','Country_4')
						AND m.material_group = 'COM700'
						AND m.species IN ('Product_1','Product_2')
;