/*
The main source for Company Materials

The product info (material) object (db02) is the main source to retrieve *all* kinds of Material information from the dbcloud
*/


--- material attributes

SELECT 

    material_id, 
    material_number,
	description,
	species, 
    species_description,
    crop,
    crop_description,
    subcrop,
    subcrop_description,
    grouping,
    grouping_description,
	material_group,
	material_group_description, 
    material_status,
    material_type,
	variety_name,
    variety_number,
	treatment,
	treatment_description,
    division,
    division_description,
    business_division,
    business_division_description,
    caliber,
    caliber_description,
    germ_level,
    germ_level_description,
    density_value,
    density_uom,
    height_value,
    height_uom,
    generation,
    generation_description,
    maturity_group,
    maturity_group_description,
    package_contents,
    pack_configuration,
    pack_responsibility,
    pack_responsibility_person,
    pack_responsibility_region
    quantity_value,
    quantity_uom,
    quantity_of_package,
    quantity_of_package_uom,
    quantity_per_pallet,
    process_stage,
    process_stage_description,
    productline_group,
    productline_group_description,
    productline_owner,
    productline_seller,
    productline_seller_description,
    country_code,
    manufacturing_country_code,
    local_brand_code,
    family_code,
    transportable,
    material_modified_on,
    db_update_date_time

			FROM public.db_material 
			WHERE record_type = 'Seeds' 

						AND identifier_type LIKE '%materialnumber%'
						AND preferred_id = 'true'
                        AND is_active = 'true'
                        AND date_part(year, material_create_date) >= '2015'
                        AND species IN ('Product_1','Product_2','Product_3','Product_4','Product_5');
