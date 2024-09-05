/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  to analyze the different sources of seed used by households in Nigeria
				  using the Nigeria General Household Survey data.
*Author(s)		: TBC

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: This  Version - September 5, 2024
----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*https://microdata.worldbank.org/index.php/catalog/lsms/?page=1&country%5B%5D=157&ps=15&repo=lsms


/* ----------------------------------------------------------------------------- *
* File structure 
* Part A: Construct wave 1 seed sources variables
* Part B: Construct wave 2 seed sources variables
* Part C: Construct wave 3 seed sources variables
* Part D: Construct wave 4 seed sources variables
* Part E: Construct panel data 
* Part F: Generate summary statistics by wave 
* ----------------------------------------------------------------------------- */



clear all
clear mata
matrix drop _all
global drop _all
set more off
cap log close


/* ----------------------------------------------------------------------------- *
* MACROS																		*
* ----------------------------------------------------------------------------- */

global path1 "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\335 - Ag Team Data Support\Waves\Nigeria GHS" 
global path2 "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\445 - Seed sources in Nigeria and Ethiopia\Data and analysis\data files\Nigeria"


/* ----------------------------------------------------------------------------- *
* 		Part A: Construct wave 1 seed sources variables
* ----------------------------------------------------------------------------- */
 
    use "$path1\Nigeria GHS Wave 1\Raw DTA Files\NGA_2010_GHSP-W1_v03_M_STATA\sect12_plantingw1.dta", clear
	keep hhid network_cd s12q2
	drop if network_cd==""
	save "$path2\NGA_W1_networks.dta", replace 
	
	use "$path1\Nigeria GHS Wave 1\Raw DTA Files\NGA_2010_GHSP-W1_v03_M_STATA\sect11e_plantingw1.dta", clear
	ren s11eq15 network_cd
	drop if network_cd==""
	merge m:1 hhid network_cd using "$path2\NGA_W1_networks.dta", nogen keep (1 3)
	keep hhid network_cd s12q2 s11eq2
	drop if s11eq2==. | s12q2==.
	collapse (max) s12q2, by (hhid s11eq2 network_cd)
	ren s11eq2 cropcode
	 
  	gen crop_beanscowpeas=(cropcode==1010)
	gen crop_pigeonpeas=(cropcode==2150)
	gen crop_soybeans=(cropcode==2220)
	gen crop_sesame=(cropcode==2040)
	gen crop_gnuts=(cropcode==1060 | cropcode==1061 | cropcode==1062)
	gen crop_megusi=(cropcode==1090 | cropcode==1091 | cropcode==1093)
	gen crop_cashew=(cropcode==3020 | cropcode==3021)
	gen crop_kolanut=(cropcode==3110 | cropcode==3111 | cropcode==3112 | cropcode==3113)
	gen crop_bambara_nut=(cropcode==2020)
	gen crop_shea_nut=(cropcode==2210)
	gen crop_locustbean=(cropcode==3140)
	gen crop_walnut=(cropcode==2270)
	
	gen crop_legumes_nuts=(crop_beanscowpeas==1 | crop_pigeonpeas==1 | crop_soybeans==1 | crop_sesame==1 | crop_gnuts==1 | crop_megusi==1 | crop_cashew==1 | crop_kolanut==1 | crop_bambara_nut==1 | crop_shea_nut==1 | crop_locustbean==1 | crop_walnut==1) 
	
	gen crop_cassava=(cropcode==1020)
	gen crop_potato=(cropcode==2180 | cropcode==2181)
	gen crop_yams=(cropcode==1040 | cropcode==1120 | cropcode==1121 | cropcode==1122 | cropcode==1123 | cropcode==1124)
	gen crop_banana=(cropcode==2030 | cropcode==2170)
	gen crop_rootstubers=(crop_cassava==1 | crop_potato==1 | crop_yams==1 | crop_banana==1)
		
	gen crop_sorghum=(cropcode==1070)	
	gen crop_maize=(cropcode==1080 | cropcode==1081 | cropcode==1082)
	gen crop_millet=(cropcode==1100)
	gen crop_rice=(cropcode==1110 | cropcode==1111 | cropcode==1112)
	gen crop_acha=(cropcode==2010)
	gen crop_wheat=(cropcode==2280)
	gen crop_cereals=(crop_sorghum==1 | crop_maize==1 | crop_millet==1 | crop_rice==1 | crop_acha==1 | crop_wheat==1)
	
	gen crop_carrot=(cropcode==2050)
	gen crop_cucumber=(cropcode==2060)	
	gen crop_cabbage=(cropcode==2070 | cropcode==2071)
	gen crop_tomato=(cropcode==2260)
	gen crop_garden_egg=(cropcode==2080)
	gen crop_ginger=(cropcode==2100)	
	gen crop_okro=(cropcode==2120)
	gen crop_onion=(cropcode==2130)
	gen crop_pepper=(cropcode==2140 | cropcode==2141 | cropcode==2142 | cropcode==2143)
	gen crop_greenvegtable=(cropcode==2194 | cropcode==2195)
	gen crop_zobo=(cropcode==2290)
	gen crop_pineapple=(cropcode==2160)
	gen crop_pumpkin=(cropcode==2190 | cropcode==2191 | cropcode==2192 | cropcode==2193)
	gen crop_gumarabic=(cropcode==2110)
	gen crop_iyere=(cropcode==3260)
	gen crop_hortcrops=(crop_carrot==1 | crop_cucumber==1 | crop_cabbage==1 | crop_tomato==1 | crop_garden_egg==1 | crop_ginger==1 | crop_okro==1 | crop_onion==1 | crop_pepper==1 | crop_greenvegtable==1 | crop_zobo==1 | crop_pineapple==1 | crop_pumpkin==1 | crop_gumarabic==1 | crop_iyere==1)
	
	gen crop_cotton=(cropcode==1050 | cropcode==1051 | cropcode==1053)
	gen crop_sugarcane=(cropcode==2230)
	gen crop_tobacco=(cropcode==2250)
	gen crop_cocoa=(cropcode==3040 | cropcode==3041 | cropcode==3042)
	gen crop_tropcashcrops=(crop_cotton==1 | crop_sugarcane==1 | crop_tobacco==1 | crop_cocoa==1)
	
	gen crop_guava=(cropcode==3090)
	gen crop_mango=(cropcode==3160)
	gen crop_orange=(cropcode==3170 | cropcode==3150)
	gen crop_palmoil=(cropcode==3180 | cropcode==3181 | cropcode==3183)
	gen crop_agbono=(cropcode==3190)
	gen crop_pawpaw=(cropcode==3210)
	gen crop_pear=(cropcode==3220)
	gen crop_avocado=(cropcode==3221)
	gen crop_apple=(cropcode==3010)
	gen crop_coconut=(cropcode==3050)
	gen crop_oilbean=(cropcode==3200)
	gen crop_fruittrees=(crop_guava==1 | crop_mango==1 | crop_orange==1 | crop_palmoil==1 | crop_agbono==1 | crop_pawpaw==1 | crop_pear==1 | crop_avocado==1 | crop_apple==1 | crop_coconut==1 | crop_oilbean==1)
	
	global crop beanscowpeas pigeonpeas soybeans sesame gnuts megusi cashew kolanut bambara_nut legumes_nuts cassava potato yams banana rootstubers sorghum maize millet rice acha cereals carrot cucumber cabbage tomato garden_egg ginger okro onion pepper greenvegtable zobo pineapple pumpkin hortcrops cotton sugarcane tobacco cocoa tropcashcrops guava mango orange palmoil agbono pawpaw pear avocado fruittrees wheat shea_nut apple coconut locustbean gumarabic walnut oilbean iyere
	
global source relative village market govt microf ngo coop 
	
	* purchased seed sources 
 gen purch_relative=(s12q2==1 | s12q2==2) 
 gen purch_village=(s12q2==3 | s12q2==4 | s12q2==5 | s12q2==6 | s12q2==7 | s12q2==18) 
 gen purch_market=(s12q2==8 | s12q2==9 | s12q2==10 | s12q2==11 | s12q2==12 | s12q2==13 | s12q2==14 | s12q2==15 | s12q2==28) 
 gen purch_govt=(s12q2==16 | s12q2==17 | s12q2==23 | s12q2==24 | s12q2==29) 
 gen purch_microf=(s12q2==19 | s12q2==20 | s12q2==22)
 gen purch_ngo=(s12q2==27 | s12q2==30)
 gen purch_coop=(s12q2==21 | s12q2==25 | s12q2==26)
 
 
 foreach crop of global crop {
 	foreach source of global source {
	gen purch_`source'_`crop'=purch_`source' * crop_`crop'	
	}	
 }
 
 
 
 collapse (max) crop_* purch_*, by (hhid)
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 1\Final DTA files\created_data\Nigeria_GHS_W1_weights.dta", nogen keep (2 3)
 save "$path2\NGA_W1_purchasedsources.dta", replace 
 

 
    use  "$path1\Nigeria GHS Wave 1\Raw DTA Files\NGA_2010_GHSP-W1_v03_M_STATA\sect11e_plantingw1.dta", clear
	ren s11eq2 cropcode
	
  	gen crop_beanscowpeas=(cropcode==1010)
	gen crop_pigeonpeas=(cropcode==2150)
	gen crop_soybeans=(cropcode==2220)
	gen crop_sesame=(cropcode==2040)
	gen crop_gnuts=(cropcode==1060 | cropcode==1061 | cropcode==1062)
	gen crop_megusi=(cropcode==1090 | cropcode==1091 | cropcode==1093)
	gen crop_cashew=(cropcode==3020 | cropcode==3021)
	gen crop_kolanut=(cropcode==3110 | cropcode==3111 | cropcode==3112 | cropcode==3113)
	gen crop_bambara_nut=(cropcode==2020)
	gen crop_shea_nut=(cropcode==2210)
	gen crop_locustbean=(cropcode==3140)
	gen crop_walnut=(cropcode==2270)
	
	gen crop_legumes_nuts=(crop_beanscowpeas==1 | crop_pigeonpeas==1 | crop_soybeans==1 | crop_sesame==1 | crop_gnuts==1 | crop_megusi==1 | crop_cashew==1 | crop_kolanut==1 | crop_bambara_nut==1 | crop_shea_nut==1 | crop_locustbean==1 | crop_walnut==1) 
	
	gen crop_cassava=(cropcode==1020)
	gen crop_potato=(cropcode==2180 | cropcode==2181)
	gen crop_yams=(cropcode==1040 | cropcode==1120 | cropcode==1121 | cropcode==1122 | cropcode==1123 | cropcode==1124)
	gen crop_banana=(cropcode==2030 | cropcode==2170)
	gen crop_rootstubers=(crop_cassava==1 | crop_potato==1 | crop_yams==1 | crop_banana==1)
		
	gen crop_sorghum=(cropcode==1070)	
	gen crop_maize=(cropcode==1080 | cropcode==1081 | cropcode==1082)
	gen crop_millet=(cropcode==1100)
	gen crop_rice=(cropcode==1110 | cropcode==1111 | cropcode==1112)
	gen crop_acha=(cropcode==2010)
	gen crop_wheat=(cropcode==2280)
	gen crop_cereals=(crop_sorghum==1 | crop_maize==1 | crop_millet==1 | crop_rice==1 | crop_acha==1 | crop_wheat==1)
	
	gen crop_carrot=(cropcode==2050)
	gen crop_cucumber=(cropcode==2060)	
	gen crop_cabbage=(cropcode==2070 | cropcode==2071)
	gen crop_tomato=(cropcode==2260)
	gen crop_garden_egg=(cropcode==2080)
	gen crop_ginger=(cropcode==2100)	
	gen crop_okro=(cropcode==2120)
	gen crop_onion=(cropcode==2130)
	gen crop_pepper=(cropcode==2140 | cropcode==2141 | cropcode==2142 | cropcode==2143)
	gen crop_greenvegtable=(cropcode==2194 | cropcode==2195)
	gen crop_zobo=(cropcode==2290)
	gen crop_pineapple=(cropcode==2160)
	gen crop_pumpkin=(cropcode==2190 | cropcode==2191 | cropcode==2192 | cropcode==2193)
	gen crop_gumarabic=(cropcode==2110)
	gen crop_iyere=(cropcode==3260)
	gen crop_hortcrops=(crop_carrot==1 | crop_cucumber==1 | crop_cabbage==1 | crop_tomato==1 | crop_garden_egg==1 | crop_ginger==1 | crop_okro==1 | crop_onion==1 | crop_pepper==1 | crop_greenvegtable==1 | crop_zobo==1 | crop_pineapple==1 | crop_pumpkin==1 | crop_gumarabic==1 | crop_iyere==1)
	
	gen crop_cotton=(cropcode==1050 | cropcode==1051 | cropcode==1053)
	gen crop_sugarcane=(cropcode==2230)
	gen crop_tobacco=(cropcode==2250)
	gen crop_cocoa=(cropcode==3040 | cropcode==3041 | cropcode==3042)
	gen crop_tropcashcrops=(crop_cotton==1 | crop_sugarcane==1 | crop_tobacco==1 | crop_cocoa==1)
	
	gen crop_guava=(cropcode==3090)
	gen crop_mango=(cropcode==3160)
	gen crop_orange=(cropcode==3170 | cropcode==3150)
	gen crop_palmoil=(cropcode==3180 | cropcode==3181 | cropcode==3183)
	gen crop_agbono=(cropcode==3190)
	gen crop_pawpaw=(cropcode==3210)
	gen crop_pear=(cropcode==3220)
	gen crop_avocado=(cropcode==3221)
	gen crop_apple=(cropcode==3010)
	gen crop_coconut=(cropcode==3050)
	gen crop_oilbean=(cropcode==3200)
	gen crop_fruittrees=(crop_guava==1 | crop_mango==1 | crop_orange==1 | crop_palmoil==1 | crop_agbono==1 | crop_pawpaw==1 | crop_pear==1 | crop_avocado==1 | crop_apple==1 | crop_coconut==1 | crop_oilbean==1)
	
	global crop beanscowpeas pigeonpeas soybeans sesame gnuts megusi cashew kolanut bambara_nut legumes_nuts cassava potato yams banana rootstubers sorghum maize millet rice acha cereals carrot cucumber cabbage tomato garden_egg ginger okro onion pepper greenvegtable zobo pineapple pumpkin hortcrops cotton sugarcane tobacco cocoa tropcashcrops guava mango orange palmoil agbono pawpaw pear avocado fruittrees wheat shea_nut apple coconut locustbean gumarabic walnut oilbean iyere
	
 
	
  
 * home saved seeds 
  gen saved_seed=(s11eq4==1) if s11eq4!=.
 foreach crop of global crop {
	gen saved_`crop'=saved_seed * crop_`crop'	
	}	
	
	
gen savedseed_kg=(s11eq6a/1000) if s11eq6a!=. & s11eq6b==1
replace savedseed_kg=s11eq6a if s11eq6a!=. & s11eq6b==2   
replace savedseed_kg=s11eq6a if s11eq6a!=. & s11eq6b==3
 foreach crop of global crop {
	gen savedkg_`crop'=savedseed_kg * crop_`crop'	
	}	
	
	
 * free seeds 
gen free_seed=(s11eq8==1) if s11eq8!=.
 foreach crop of global crop {
	gen free_`crop'=free_seed * crop_`crop'	
	}
 

 
gen freeseed_kg=(s11eq10a/1000) if s11eq10a!=. & s11eq10b==1
replace freeseed_kg=s11eq10a if s11eq10a!=. & s11eq10b==2   
replace freeseed_kg=s11eq10a if s11eq10a!=. & s11eq10b==3
 foreach crop of global crop {
	gen freekg_`crop'=freeseed_kg * crop_`crop'	
	}	

	
 * purchased seed
 gen purchased_seed=(s11eq14==1) if s11eq14!=.
 foreach crop of global crop {
	gen purchased_`crop'=purchased_seed * crop_`crop'	
	}	
 
 
 
gen purchasedseed_kg=(s11eq17a/1000) if s11eq17a!=. & s11eq17b==1
replace purchasedseed_kg=s11eq17a if s11eq17a!=. & s11eq17b==2   
replace purchasedseed_kg=s11eq17a if s11eq17a!=. & s11eq17b==3
 foreach crop of global crop {
	gen purchasedkg_`crop'=purchasedseed_kg * crop_`crop'	
	}
 
 collapse (max) crop_* saved_* free_*  purchased_* (sum) savedkg_* freekg_* purchasedkg_* *_kg, by (hhid)
 
  egen totalseedkg=rowtotal(savedseed_kg freeseed_kg purchasedseed_kg) if savedseed_kg!=. | freeseed_kg!=. | purchasedseed_kg!=.
 gen share_savedkg=(savedseed_kg/totalseedkg) if savedseed_kg!=. & totalseedkg!=.
 gen share_freekg=(freeseed_kg/totalseedkg) if freeseed_kg!=. & totalseedkg!=.
 gen share_purchasedkg=(purchasedseed_kg/totalseedkg) if purchasedseed_kg!=. & totalseedkg!=.
 
 
 * merge in other household variables (pre-constructed from main Nigeria coding)
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 1\Final DTA files\created_data\Nigeria_GHS_W1_weights.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path2\NGA_W1_purchasedsources.dta", nogen 
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 1\Final DTA files\created_data\Nigeria_GHS_W1_farmsize_all_agland.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 1\Final DTA files\created_data\Nigeria_GHS_W1_hhsize.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 1\Final DTA files\created_data\Nigeria_GHS_W1_yield_hh_crop_level.dta", nogen
   
 * reconcile if households dont report seed source but quantity of seed from different sources is reported
  egen seeduse=rowtotal(saved_seed free_seed purchased_seed) if (saved_seed!=. | free_seed!=. | purchased_seed!=.)
  for var *_seed: replace X=. if X==0 & seeduse==0
  for var *_seed: replace X=0 if X==. & (seeduse==1 | seeduse==2 | seeduse==3)
  
  replace saved_seed=1 if saved_seed==. & share_savedkg>=0 & share_savedkg!=.
  replace free_seed=1 if free_seed==. & share_freekg>=0 & share_freekg!=.
  replace purchased_seed=1 if purchased_seed==. & share_purchasedkg>=0 & share_purchasedkg!=.
  
  * reconcile shares if households only report using seeds from a single source but dont report actual quantity of seed used
  replace share_savedkg=1 if share_savedkg==. & saved_seed==1 & seeduse==1
  replace share_freekg=1 if share_freekg==. & free_seed==1 & seeduse==1
  replace share_purchasedkg=1 if share_purchasedkg==. & purchased_seed==1 & seeduse==1
  
  replace share_savedkg=0 if share_savedkg==. & (share_freekg==1 | share_purchasedkg==1)
  replace share_freekg=0 if share_freekg==. & (share_savedkg==1 | share_purchasedkg==1)
  replace share_purchasedkg=0 if share_purchasedkg==. & (share_savedkg==1 | share_freekg==1)
 
  foreach crop of global crop {
	for var purch_*_`crop': replace X=0 if X==. & purchased_`crop'==1	
	}	

gen wave=1
save "$path2\NGA_W1_seed_sources.dta", replace 
 

 
 
 
/* ----------------------------------------------------------------------------- *
* 		Part B: Construct wave 2 seed sources variables
* ----------------------------------------------------------------------------- */
 
  use "$path1\Nigeria GHS Wave 2\Raw DTA Files\NGA_2012_GHSP-W2_v02_M\sect12_plantingw2.dta", clear
	keep hhid network_cd s12q2
	drop if network_cd==""
	save "$path2\NGA_W2_networks.dta", replace 
	
	use "$path1\Nigeria GHS Wave 2\Raw DTA Files\NGA_2012_GHSP-W2_v02_M\sect11e_plantingw2.dta", clear
	ren s11eq16 network_cd
	drop if network_cd==""
	merge m:1 hhid network_cd using "$path2\NGA_W2_networks.dta", nogen keep (1 3)
	keep hhid network_cd s12q2 cropcode
	drop if cropcode==. | s12q2==.
	collapse (max) s12q2, by (hhid cropcode network_cd)
	
	gen crop_beanscowpeas=(cropcode==1010)
	gen crop_pigeonpeas=(cropcode==2150)
	gen crop_soybeans=(cropcode==2220)
	gen crop_sesame=(cropcode==2040)
	gen crop_gnuts=(cropcode==1060 | cropcode==1061 | cropcode==1062)
	gen crop_megusi=(cropcode==1090 | cropcode==1091 | cropcode==1092 | cropcode==1093)
	gen crop_cashew=(cropcode==3020 | cropcode==3022)
	gen crop_kolanut=(cropcode==3110 | cropcode==3112 | cropcode==3113)
	gen crop_bambara_nut=(cropcode==2020)
	gen crop_locustbean=(cropcode==3140)
	gen crop_walnut=(cropcode==2270)
	
	gen crop_legumes_nuts=(crop_beanscowpeas==1 | crop_pigeonpeas==1 | crop_soybeans==1 | crop_sesame==1 | crop_gnuts==1 | crop_megusi==1 | crop_cashew==1 | crop_kolanut==1 | crop_bambara_nut==1 | crop_locustbean==1 | crop_walnut==1) 
	
	gen crop_cassava=(cropcode==1020)
	gen crop_potato=(cropcode==2180 | cropcode==2181)
	gen crop_yams=(cropcode==1040 | cropcode==1120 | cropcode==1121 | cropcode==1122 | cropcode==1123 | cropcode==1124)
	gen crop_banana=(cropcode==2030 | cropcode==2170)
	gen crop_rootstubers=(crop_cassava==1 | crop_potato==1 | crop_yams==1 | crop_banana==1)
		
	gen crop_sorghum=(cropcode==1070)	
	gen crop_maize=(cropcode==1080 | cropcode==1081 | cropcode==1082 | cropcode==1083)
	gen crop_millet=(cropcode==1100)
	gen crop_rice=(cropcode==1110 | cropcode==1111)
	gen crop_acha=(cropcode==2010)
	gen crop_wheat=(cropcode==2280)
	gen crop_cereals=(crop_sorghum==1 | crop_maize==1 | crop_millet==1 | crop_rice==1 | crop_acha==1 | crop_wheat==1)
	
	gen crop_carrot=(cropcode==2050)
	gen crop_cucumber=(cropcode==2060)	
	gen crop_cabbage=(cropcode==2070 | cropcode==2071)
	gen crop_tomato=(cropcode==2260)
	gen crop_garden_egg=(cropcode==2080)
	gen crop_ginger=(cropcode==2100 | cropcode==2103)	
	gen crop_okro=(cropcode==2120)
	gen crop_onion=(cropcode==2130)
	gen crop_pepper=(cropcode==2140 | cropcode==2142)
	gen crop_greenvegtable=(cropcode==2194 | cropcode==2195)
	gen crop_zobo=(cropcode==2290 | cropcode==2291)
	gen crop_pineapple=(cropcode==2160)
	gen crop_pumpkin=(cropcode==2190 | cropcode==2191 | cropcode==2192 | cropcode==2193 | cropcode==2194 | cropcode==2195)
	gen crop_gumarabic=(cropcode==2110)
	gen crop_datepalm=(cropcode==3070)
	gen crop_jute=(cropcode==3100)
	gen crop_eru=(cropcode==3250)
	gen crop_hortcrops=(crop_carrot==1 | crop_cucumber==1 | crop_cabbage==1 | crop_tomato==1 | crop_garden_egg==1 | crop_ginger==1 | crop_okro==1 | crop_onion==1 | crop_pepper==1 | crop_greenvegtable==1 | crop_zobo==1 | crop_pineapple==1 | crop_pumpkin==1 | crop_gumarabic==1 | crop_datepalm==1 | crop_jute==1 | crop_eru==1)
	
	gen crop_cotton=(cropcode==1050 | cropcode==1051 | cropcode==1053)
	gen crop_sugarcane=(cropcode==2230)
	gen crop_tobacco=(cropcode==2250)
	gen crop_cocoa=(cropcode==3040 | cropcode==3041 | cropcode==3042)
	gen crop_coffee=(cropcode==3060)
	gen crop_tropcashcrops=(crop_cotton==1 | crop_sugarcane==1 | crop_tobacco==1 | crop_cocoa==1)
	
	gen crop_guava=(cropcode==3090)
	gen crop_mango=(cropcode==3160)
	gen crop_orange=(cropcode==3170 | cropcode==3150 | cropcode==3130)
	gen crop_palmoil=(cropcode==3180 | cropcode==3183)
	gen crop_agbono=(cropcode==3190)
	gen crop_pawpaw=(cropcode==3210)
	gen crop_pear=(cropcode==3220)
	gen crop_avocado=(cropcode==3221)
	gen crop_apple=(cropcode==3010)
	gen crop_coconut=(cropcode==3050)
	gen crop_oilbean=(cropcode==3200)
	gen crop_grapefruit=(cropcode==3080)
	gen crop_rubber=(cropcode==3230)
	gen crop_agbalumo=(cropcode==3240)
	
	gen crop_fruittrees=(crop_guava==1 | crop_mango==1 | crop_orange==1 | crop_palmoil==1 | crop_agbono==1 | crop_pawpaw==1 | crop_pear==1 | crop_avocado==1 | crop_apple==1 | crop_coconut==1 | crop_oilbean==1 | crop_grapefruit==1 | crop_rubber==1)
	
	global crop beanscowpeas pigeonpeas soybeans sesame gnuts megusi cashew kolanut bambara_nut legumes_nuts cassava potato yams banana rootstubers sorghum maize millet rice acha cereals carrot cucumber cabbage tomato garden_egg ginger okro onion pepper greenvegtable zobo pineapple pumpkin hortcrops cotton sugarcane tobacco cocoa tropcashcrops guava mango orange palmoil agbono pawpaw pear avocado fruittrees wheat apple coconut locustbean gumarabic walnut oilbean rubber datepalm jute eru agbalumo
 
 global source relative village market govt microf ngo coop 
	
	* purchased seed sources 
 gen purch_relative=(s12q2==1 | s12q2==2) 
 gen purch_village=(s12q2==3 | s12q2==4 | s12q2==5 | s12q2==6 | s12q2==7 | s12q2==18) 
 gen purch_market=(s12q2==8 | s12q2==9 | s12q2==10 | s12q2==11 | s12q2==12 | s12q2==13 | s12q2==14 | s12q2==15 | s12q2==28) 
 gen purch_govt=(s12q2==16 | s12q2==17 | s12q2==23 | s12q2==24 | s12q2==29) 
 gen purch_microf=(s12q2==19 | s12q2==20 | s12q2==22)
 gen purch_ngo=(s12q2==27 | s12q2==30)
 gen purch_coop=(s12q2==21 | s12q2==25 | s12q2==26)
 
 
 foreach crop of global crop {
 	foreach source of global source {
	gen purch_`source'_`crop'=purch_`source' * crop_`crop'	
	}	
 }
 
 
 collapse (max) crop_* purch_*, by (hhid)
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 2\Final DTA files\created_data\Nigeria_GHS_W2_weights.dta", nogen keep (2 3)
 save "$path2\NGA_W2_purchasedsources.dta", replace 
 
 
 
 
 use  "$path1\Nigeria GHS Wave 2\Raw DTA Files\NGA_2012_GHSP-W2_v02_M\sect11e_plantingw2.dta", clear
  
  	gen crop_beanscowpeas=(cropcode==1010)
	gen crop_pigeonpeas=(cropcode==2150)
	gen crop_soybeans=(cropcode==2220)
	gen crop_sesame=(cropcode==2040)
	gen crop_gnuts=(cropcode==1060 | cropcode==1061 | cropcode==1062)
	gen crop_megusi=(cropcode==1090 | cropcode==1091 | cropcode==1092 | cropcode==1093)
	gen crop_cashew=(cropcode==3020 | cropcode==3022)
	gen crop_kolanut=(cropcode==3110 | cropcode==3112 | cropcode==3113)
	gen crop_bambara_nut=(cropcode==2020)
	gen crop_locustbean=(cropcode==3140)
	gen crop_walnut=(cropcode==2270)
	
	gen crop_legumes_nuts=(crop_beanscowpeas==1 | crop_pigeonpeas==1 | crop_soybeans==1 | crop_sesame==1 | crop_gnuts==1 | crop_megusi==1 | crop_cashew==1 | crop_kolanut==1 | crop_bambara_nut==1 | crop_locustbean==1 | crop_walnut==1) 
	
	gen crop_cassava=(cropcode==1020)
	gen crop_potato=(cropcode==2180 | cropcode==2181)
	gen crop_yams=(cropcode==1040 | cropcode==1120 | cropcode==1121 | cropcode==1122 | cropcode==1123 | cropcode==1124)
	gen crop_banana=(cropcode==2030 | cropcode==2170)
	gen crop_rootstubers=(crop_cassava==1 | crop_potato==1 | crop_yams==1 | crop_banana==1)
		
	gen crop_sorghum=(cropcode==1070)	
	gen crop_maize=(cropcode==1080 | cropcode==1081 | cropcode==1082 | cropcode==1083)
	gen crop_millet=(cropcode==1100)
	gen crop_rice=(cropcode==1110 | cropcode==1111)
	gen crop_acha=(cropcode==2010)
	gen crop_wheat=(cropcode==2280)
	gen crop_cereals=(crop_sorghum==1 | crop_maize==1 | crop_millet==1 | crop_rice==1 | crop_acha==1 | crop_wheat==1)
	
	gen crop_carrot=(cropcode==2050)
	gen crop_cucumber=(cropcode==2060)	
	gen crop_cabbage=(cropcode==2070 | cropcode==2071)
	gen crop_tomato=(cropcode==2260)
	gen crop_garden_egg=(cropcode==2080)
	gen crop_ginger=(cropcode==2100 | cropcode==2103)	
	gen crop_okro=(cropcode==2120)
	gen crop_onion=(cropcode==2130)
	gen crop_pepper=(cropcode==2140 | cropcode==2142)
	gen crop_greenvegtable=(cropcode==2194 | cropcode==2195)
	gen crop_zobo=(cropcode==2290 | cropcode==2291)
	gen crop_pineapple=(cropcode==2160)
	gen crop_pumpkin=(cropcode==2190 | cropcode==2191 | cropcode==2192 | cropcode==2193 | cropcode==2194 | cropcode==2195)
	gen crop_gumarabic=(cropcode==2110)
	gen crop_datepalm=(cropcode==3070)
	gen crop_jute=(cropcode==3100)
	gen crop_eru=(cropcode==3250)
	gen crop_hortcrops=(crop_carrot==1 | crop_cucumber==1 | crop_cabbage==1 | crop_tomato==1 | crop_garden_egg==1 | crop_ginger==1 | crop_okro==1 | crop_onion==1 | crop_pepper==1 | crop_greenvegtable==1 | crop_zobo==1 | crop_pineapple==1 | crop_pumpkin==1 | crop_gumarabic==1 | crop_datepalm==1 | crop_jute==1 | crop_eru==1)
	
	gen crop_cotton=(cropcode==1050 | cropcode==1051 | cropcode==1053)
	gen crop_sugarcane=(cropcode==2230)
	gen crop_tobacco=(cropcode==2250)
	gen crop_cocoa=(cropcode==3040 | cropcode==3041 | cropcode==3042)
	gen crop_coffee=(cropcode==3060)
	gen crop_tropcashcrops=(crop_cotton==1 | crop_sugarcane==1 | crop_tobacco==1 | crop_cocoa==1)
	
	gen crop_guava=(cropcode==3090)
	gen crop_mango=(cropcode==3160)
	gen crop_orange=(cropcode==3170 | cropcode==3150 | cropcode==3130)
	gen crop_palmoil=(cropcode==3180 | cropcode==3183)
	gen crop_agbono=(cropcode==3190)
	gen crop_pawpaw=(cropcode==3210)
	gen crop_pear=(cropcode==3220)
	gen crop_avocado=(cropcode==3221)
	gen crop_apple=(cropcode==3010)
	gen crop_coconut=(cropcode==3050)
	gen crop_oilbean=(cropcode==3200)
	gen crop_grapefruit=(cropcode==3080)
	gen crop_rubber=(cropcode==3230)
	gen crop_agbalumo=(cropcode==3240)
	
	gen crop_fruittrees=(crop_guava==1 | crop_mango==1 | crop_orange==1 | crop_palmoil==1 | crop_agbono==1 | crop_pawpaw==1 | crop_pear==1 | crop_avocado==1 | crop_apple==1 | crop_coconut==1 | crop_oilbean==1 | crop_grapefruit==1 | crop_rubber==1)
	
	global crop beanscowpeas pigeonpeas soybeans sesame gnuts megusi cashew kolanut bambara_nut legumes_nuts cassava potato yams banana rootstubers sorghum maize millet rice acha cereals carrot cucumber cabbage tomato garden_egg ginger okro onion pepper greenvegtable zobo pineapple pumpkin hortcrops cotton sugarcane tobacco cocoa tropcashcrops guava mango orange palmoil agbono pawpaw pear avocado fruittrees wheat apple coconut locustbean gumarabic walnut oilbean rubber datepalm jute eru agbalumo
	
	 
 * home saved seeds 
  gen saved_seed=(s11eq4==1) if s11eq4!=.
 foreach crop of global crop {
	gen saved_`crop'=saved_seed * crop_`crop'	
	}	
	
	
ren s11eq6a savedseed_kg
 foreach crop of global crop {
	gen savedkg_`crop'=savedseed_kg * crop_`crop'	
	}	
	
	
 * free seeds 
gen free_seed=(s11eq8==1) if s11eq8!=.
 foreach crop of global crop {
	gen free_`crop'=free_seed * crop_`crop'	
	}

ren s11eq10a freeseed_kg
 foreach crop of global crop {
	gen freekg_`crop'=freeseed_kg * crop_`crop'	
	}	
	
  
 * purchased seed
 gen purchased_seed=(s11eq14==1) if s11eq14!=.
 foreach crop of global crop {
	gen purchased_`crop'=purchased_seed * crop_`crop'	
	}	
 
ren s11eq18a purchasedseed_kg
 foreach crop of global crop {
	gen purchasedkg_`crop'=purchasedseed_kg * crop_`crop'	
	} 

 
 collapse (max) crop_* saved_* free_* purchased_* (sum) savedkg_* freekg_* purchasedkg_* *_kg, by (hhid)
 
 egen totalseedkg=rowtotal(savedseed_kg freeseed_kg purchasedseed_kg) if savedseed_kg!=. | freeseed_kg!=. | purchasedseed_kg!=.
 gen share_savedkg=(savedseed_kg/totalseedkg) if savedseed_kg!=. & totalseedkg!=.
 gen share_freekg=(freeseed_kg/totalseedkg) if freeseed_kg!=. & totalseedkg!=.
 gen share_purchasedkg=(purchasedseed_kg/totalseedkg) if purchasedseed_kg!=. & totalseedkg!=.
 
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 2\Final DTA files\created_data\Nigeria_GHS_W2_weights.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path2\NGA_W2_purchasedsources.dta", nogen 
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 2\Final DTA files\created_data\Nigeria_GHS_W2_farmsize_all_agland.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 2\Final DTA files\created_data\Nigeria_GHS_W2_hhsize2.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 2\Final DTA files\created_data\Nigeria_GHS_W2_yield_hh_crop_level.dta", nogen 
 
 
 * reconcile if households dont report seed source but quantity of seed from different sources is reported
  egen seeduse=rowtotal(saved_seed free_seed purchased_seed) if (saved_seed!=. | free_seed!=. | purchased_seed!=.)
  for var *_seed: replace X=. if X==0 & seeduse==0
  for var *_seed: replace X=0 if X==. & (seeduse==1 | seeduse==2 | seeduse==3)
  
  replace saved_seed=1 if saved_seed==. & share_savedkg>=0 & share_savedkg!=.
  replace free_seed=1 if free_seed==. & share_freekg>=0 & share_freekg!=.
  replace purchased_seed=1 if purchased_seed==. & share_purchasedkg>=0 & share_purchasedkg!=.
  
  * reconcile shares if households only report using seeds from a single source but dont report actual quantity of seed used
  replace share_savedkg=1 if share_savedkg==. & saved_seed==1 & seeduse==1
  replace share_freekg=1 if share_freekg==. & free_seed==1 & seeduse==1
  replace share_purchasedkg=1 if share_purchasedkg==. & purchased_seed==1 & seeduse==1
  
  replace share_savedkg=0 if share_savedkg==. & (share_freekg==1 | share_purchasedkg==1)
  replace share_freekg=0 if share_freekg==. & (share_savedkg==1 | share_purchasedkg==1)
  replace share_purchasedkg=0 if share_purchasedkg==. & (share_savedkg==1 | share_freekg==1)
 
  foreach crop of global crop {
	for var purch_*_`crop': replace X=0 if X==. & purchased_`crop'==1	
	}	

gen wave=2
save "$path2\NGA_W2_seed_sources.dta", replace 


 
 
 
/* ----------------------------------------------------------------------------- *
* 		Part C: Construct wave 3 seed sources variables
* ----------------------------------------------------------------------------- */
 
  use "$path1\Nigeria GHS Wave 3\Raw DTA Files\NGA_2015_GHSP-W3_v02_M_Stata\sect12_plantingw3.dta", clear
	keep hhid network_cd s12q2
	ren network_cd networkcd
	gen network_cd=substr(networkcd, 1, 1) + substr(networkcd, 3, 1)
	drop if network_cd==""
	save "$path2\NGA_W3_networks.dta", replace 
	
	use "$path1\Nigeria GHS Wave 3\Raw DTA Files\NGA_2015_GHSP-W3_v02_M_Stata\sect11e_plantingw3.dta", clear
	ren s11eq16 network_cd
	
	drop if network_cd==""
	merge m:1 hhid network_cd using "$path2\NGA_W3_networks.dta", nogen keep (1 3)
	keep hhid network_cd s12q2 cropcode
	drop if cropcode==. | s12q2==.
	collapse (max) s12q2, by (hhid cropcode network_cd)
	
	gen crop_beanscowpeas=(cropcode==1010)
	gen crop_pigeonpeas=(cropcode==2150)
	gen crop_soybeans=(cropcode==2220)
	gen crop_sesame=(cropcode==2040)
	gen crop_gnuts=(cropcode==1060 | cropcode==1061 | cropcode==1062)
	gen crop_megusi=(cropcode==1090 | cropcode==1091 | cropcode==1093)
	gen crop_cashew=(cropcode==3020 | cropcode==3022)
	gen crop_kolanut=(cropcode==3110 | cropcode==3111 | cropcode==3112 | cropcode==3113)
	gen crop_bambara_nut=(cropcode==2020)
	gen crop_walnut=(cropcode==2270)
	
	gen crop_legumes_nuts=(crop_beanscowpeas==1 | crop_pigeonpeas==1 | crop_soybeans==1 | crop_sesame==1 | crop_gnuts==1 | crop_megusi==1 | crop_cashew==1 | crop_kolanut==1 | crop_bambara_nut==1 | crop_walnut==1) 
	
	gen crop_cassava=(cropcode==1020)
	gen crop_potato=(cropcode==2180 | cropcode==2181)
	gen crop_yams=(cropcode==1040 | cropcode==1120 | cropcode==1121 | cropcode==1122 | cropcode==1123 | cropcode==1124)
	gen crop_banana=(cropcode==2030 | cropcode==2170)
	gen crop_rootstubers=(crop_cassava==1 | crop_potato==1 | crop_yams==1 | crop_banana==1)
		
	gen crop_sorghum=(cropcode==1070)	
	gen crop_maize=(cropcode==1080 | cropcode==1081 | cropcode==1082)
	gen crop_millet=(cropcode==1100)
	gen crop_rice=(cropcode==1110 | cropcode==1111)
	gen crop_acha=(cropcode==2010)
	gen crop_wheat=(cropcode==2280)
	gen crop_cereals=(crop_sorghum==1 | crop_maize==1 | crop_millet==1 | crop_rice==1 | crop_acha==1 | crop_wheat==1)
	
	gen crop_carrot=(cropcode==2050)
	gen crop_cucumber=(cropcode==2060)	
	gen crop_cabbage=(cropcode==2070 | cropcode==2071)
	gen crop_tomato=(cropcode==2260)
	gen crop_garden_egg=(cropcode==2080)
	gen crop_ginger=(cropcode==2100)	
	gen crop_okro=(cropcode==2120)
	gen crop_onion=(cropcode==2130)
	gen crop_pepper=(cropcode==2140 | cropcode==2141 | cropcode==2142 | cropcode==3030)
	gen crop_greenvegtable=(cropcode==2194)
	gen crop_zobo=(cropcode==2290)
	gen crop_pineapple=(cropcode==2160)
	gen crop_pumpkin=(cropcode==2190 | cropcode==2191 | cropcode==2192 | cropcode==2193 | cropcode==2194)
	
	gen crop_hortcrops=(crop_carrot==1 | crop_cucumber==1 | crop_cabbage==1 | crop_tomato==1 | crop_garden_egg==1 | crop_ginger==1 | crop_okro==1 | crop_onion==1 | crop_pepper==1 | crop_greenvegtable==1 | crop_zobo==1 | crop_pineapple==1 | crop_pumpkin==1)
	
	gen crop_cotton=(cropcode==1050 | cropcode==1053)
	gen crop_sugarcane=(cropcode==2230)
	gen crop_cocoa=(cropcode==3040 | cropcode==3041)
	gen crop_tropcashcrops=(crop_cotton==1 | crop_sugarcane==1 | crop_cocoa==1)
	
	gen crop_guava=(cropcode==3090)
	gen crop_mango=(cropcode==3160)
	gen crop_orange=(cropcode==3170 | cropcode==3150)
	gen crop_palmoil=(cropcode==3180 | cropcode==3183 | cropcode==3184)
	gen crop_agbono=(cropcode==3190)
	gen crop_pawpaw=(cropcode==3210)
	gen crop_pear=(cropcode==3220)
	gen crop_avocado=(cropcode==3221)
	gen crop_apple=(cropcode==3010)
	gen crop_coconut=(cropcode==3050)
	gen crop_oilbean=(cropcode==3200)
	gen crop_grapefruit=(cropcode==3080)
	gen crop_rubber=(cropcode==3230)
	
	
	gen crop_fruittrees=(crop_guava==1 | crop_mango==1 | crop_orange==1 | crop_palmoil==1 | crop_agbono==1 | crop_pawpaw==1 | crop_pear==1 | crop_avocado==1 | crop_apple==1 | crop_coconut==1 | crop_oilbean==1 | crop_grapefruit==1 | crop_rubber==1)
	
	global crop beanscowpeas pigeonpeas soybeans sesame gnuts megusi cashew kolanut bambara_nut legumes_nuts cassava potato yams banana rootstubers sorghum maize millet rice acha cereals carrot cucumber cabbage tomato garden_egg ginger okro onion pepper greenvegtable zobo pineapple pumpkin hortcrops cotton sugarcane cocoa tropcashcrops guava mango orange palmoil agbono pawpaw pear avocado fruittrees wheat apple coconut walnut oilbean grapefruit rubber
	
	 global source relative village market govt microf ngo coop 
	
	* purchased seed sources 
 gen purch_relative=(s12q2==1 | s12q2==2) 
 gen purch_village=(s12q2==3 | s12q2==4 | s12q2==5 | s12q2==6 | s12q2==7 | s12q2==18) 
 gen purch_market=(s12q2==8 | s12q2==9 | s12q2==10 | s12q2==11 | s12q2==12 | s12q2==13 | s12q2==14 | s12q2==15 | s12q2==28) 
 gen purch_govt=(s12q2==16 | s12q2==17 | s12q2==23 | s12q2==24 | s12q2==29) 
 gen purch_microf=(s12q2==19 | s12q2==20 | s12q2==22)
 gen purch_ngo=(s12q2==27 | s12q2==30)
 gen purch_coop=(s12q2==21 | s12q2==25 | s12q2==26)
 
 
 foreach crop of global crop {
 	foreach source of global source {
	gen purch_`source'_`crop'=purch_`source' * crop_`crop'	
	}	
 }
 
 
 collapse (max) crop_* purch_*, by (hhid)
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 3\Final DTA files\created_data\Nigeria_GHS_W3_weights.dta", nogen keep (2 3) 
 save "$path2\NGA_W3_purchasedsources.dta", replace 
 
 
 
 use  "$path1\Nigeria GHS Wave 3\Raw DTA Files\NGA_2015_GHSP-W3_v02_M_Stata\sect11e_plantingw3.dta", clear
  
  	gen crop_beanscowpeas=(cropcode==1010)
	gen crop_pigeonpeas=(cropcode==2150)
	gen crop_soybeans=(cropcode==2220)
	gen crop_sesame=(cropcode==2040)
	gen crop_gnuts=(cropcode==1060 | cropcode==1061 | cropcode==1062)
	gen crop_megusi=(cropcode==1090 | cropcode==1091 | cropcode==1093)
	gen crop_cashew=(cropcode==3020 | cropcode==3022)
	gen crop_kolanut=(cropcode==3110 | cropcode==3111 | cropcode==3112 | cropcode==3113)
	gen crop_bambara_nut=(cropcode==2020)
	gen crop_walnut=(cropcode==2270)
	
	gen crop_legumes_nuts=(crop_beanscowpeas==1 | crop_pigeonpeas==1 | crop_soybeans==1 | crop_sesame==1 | crop_gnuts==1 | crop_megusi==1 | crop_cashew==1 | crop_kolanut==1 | crop_bambara_nut==1 | crop_walnut==1) 
	
	gen crop_cassava=(cropcode==1020)
	gen crop_potato=(cropcode==2180 | cropcode==2181)
	gen crop_yams=(cropcode==1040 | cropcode==1120 | cropcode==1121 | cropcode==1122 | cropcode==1123 | cropcode==1124)
	gen crop_banana=(cropcode==2030 | cropcode==2170)
	gen crop_rootstubers=(crop_cassava==1 | crop_potato==1 | crop_yams==1 | crop_banana==1)
		
	gen crop_sorghum=(cropcode==1070)	
	gen crop_maize=(cropcode==1080 | cropcode==1081 | cropcode==1082)
	gen crop_millet=(cropcode==1100)
	gen crop_rice=(cropcode==1110 | cropcode==1111)
	gen crop_acha=(cropcode==2010)
	gen crop_wheat=(cropcode==2280)
	gen crop_cereals=(crop_sorghum==1 | crop_maize==1 | crop_millet==1 | crop_rice==1 | crop_acha==1 | crop_wheat==1)
	
	gen crop_carrot=(cropcode==2050)
	gen crop_cucumber=(cropcode==2060)	
	gen crop_cabbage=(cropcode==2070 | cropcode==2071)
	gen crop_tomato=(cropcode==2260)
	gen crop_garden_egg=(cropcode==2080)
	gen crop_ginger=(cropcode==2100)	
	gen crop_okro=(cropcode==2120)
	gen crop_onion=(cropcode==2130)
	gen crop_pepper=(cropcode==2140 | cropcode==2141 | cropcode==2142 | cropcode==3030)
	gen crop_greenvegtable=(cropcode==2194)
	gen crop_zobo=(cropcode==2290)
	gen crop_pineapple=(cropcode==2160)
	gen crop_pumpkin=(cropcode==2190 | cropcode==2191 | cropcode==2192 | cropcode==2193 | cropcode==2194)
	
	gen crop_hortcrops=(crop_carrot==1 | crop_cucumber==1 | crop_cabbage==1 | crop_tomato==1 | crop_garden_egg==1 | crop_ginger==1 | crop_okro==1 | crop_onion==1 | crop_pepper==1 | crop_greenvegtable==1 | crop_zobo==1 | crop_pineapple==1 | crop_pumpkin==1)
	
	gen crop_cotton=(cropcode==1050 | cropcode==1053)
	gen crop_sugarcane=(cropcode==2230)
	gen crop_cocoa=(cropcode==3040 | cropcode==3041)
	gen crop_tropcashcrops=(crop_cotton==1 | crop_sugarcane==1 | crop_cocoa==1)
	
	gen crop_guava=(cropcode==3090)
	gen crop_mango=(cropcode==3160)
	gen crop_orange=(cropcode==3170 | cropcode==3150)
	gen crop_palmoil=(cropcode==3180 | cropcode==3183 | cropcode==3184)
	gen crop_agbono=(cropcode==3190)
	gen crop_pawpaw=(cropcode==3210)
	gen crop_pear=(cropcode==3220)
	gen crop_avocado=(cropcode==3221)
	gen crop_apple=(cropcode==3010)
	gen crop_coconut=(cropcode==3050)
	gen crop_oilbean=(cropcode==3200)
	gen crop_grapefruit=(cropcode==3080)
	gen crop_rubber=(cropcode==3230)
	
	
	gen crop_fruittrees=(crop_guava==1 | crop_mango==1 | crop_orange==1 | crop_palmoil==1 | crop_agbono==1 | crop_pawpaw==1 | crop_pear==1 | crop_avocado==1 | crop_apple==1 | crop_coconut==1 | crop_oilbean==1 | crop_grapefruit==1 | crop_rubber==1)
	
	global crop beanscowpeas pigeonpeas soybeans sesame gnuts megusi cashew kolanut bambara_nut legumes_nuts cassava potato yams banana rootstubers sorghum maize millet rice acha cereals carrot cucumber cabbage tomato garden_egg ginger okro onion pepper greenvegtable zobo pineapple pumpkin hortcrops cotton sugarcane cocoa tropcashcrops guava mango orange palmoil agbono pawpaw pear avocado fruittrees wheat apple coconut walnut oilbean grapefruit rubber
	
	
	
	* home saved seeds 
  gen saved_seed=(s11eq4==1) if s11eq4!=.
 foreach crop of global crop {
	gen saved_`crop'=saved_seed * crop_`crop'	
	}	
	
ren s11eq6a savedseed_kg
 foreach crop of global crop {
	gen savedkg_`crop'=savedseed_kg * crop_`crop'	
	}

 * free seeds 
gen free_seed=(s11eq8==1) if s11eq8!=.
 foreach crop of global crop {
	gen free_`crop'=free_seed * crop_`crop'	
	}
 
 ren s11eq10a freeseed_kg
 foreach crop of global crop {
	gen freekg_`crop'=freeseed_kg * crop_`crop'	
	}	
  
 * purchased seed
 gen purchased_seed=(s11eq14==1) if s11eq14!=.
 foreach crop of global crop {
	gen purchased_`crop'=purchased_seed * crop_`crop'	
	}	
 
ren s11eq18a purchasedseed_kg
 foreach crop of global crop {
	gen purchasedkg_`crop'=purchasedseed_kg * crop_`crop'	
	}
	
 
 collapse (max) crop_* saved_* free_* purchased_* (sum) savedkg_* freekg_* purchasedkg_* *_kg, by (hhid)
 
 egen totalseedkg=rowtotal(savedseed_kg freeseed_kg purchasedseed_kg) if savedseed_kg!=. | freeseed_kg!=. | purchasedseed_kg!=.
 gen share_savedkg=(savedseed_kg/totalseedkg) if savedseed_kg!=. & totalseedkg!=.
 gen share_freekg=(freeseed_kg/totalseedkg) if freeseed_kg!=. & totalseedkg!=.
 gen share_purchasedkg=(purchasedseed_kg/totalseedkg) if purchasedseed_kg!=. & totalseedkg!=.
 
 
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 3\Final DTA files\created_data\Nigeria_GHS_W3_weights.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path2\NGA_W3_purchasedsources.dta", nogen
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 3\Final DTA files\created_data\Nigeria_GHS_W3_farmsize_all_agland.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 3\Final DTA files\created_data\Nigeria_GHS_W3_hhsize.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 3\Final DTA files\created_data\Nigeria_GHS_W3_yield_hh_crop_level.dta", nogen

 
 * reconcile if households dont report seed source but quantity of seed from different sources is reported
  egen seeduse=rowtotal(saved_seed free_seed purchased_seed) if (saved_seed!=. | free_seed!=. | purchased_seed!=.)
  for var *_seed: replace X=. if X==0 & seeduse==0
  for var *_seed: replace X=0 if X==. & (seeduse==1 | seeduse==2 | seeduse==3)
  
  replace saved_seed=1 if saved_seed==. & share_savedkg>=0 & share_savedkg!=.
  replace free_seed=1 if free_seed==. & share_freekg>=0 & share_freekg!=.
  replace purchased_seed=1 if purchased_seed==. & share_purchasedkg>=0 & share_purchasedkg!=.
  
  * reconcile shares if households only report using seeds from a single source but dont report actual quantity of seed used
  replace share_savedkg=1 if share_savedkg==. & saved_seed==1 & seeduse==1
  replace share_freekg=1 if share_freekg==. & free_seed==1 & seeduse==1
  replace share_purchasedkg=1 if share_purchasedkg==. & purchased_seed==1 & seeduse==1
  
  replace share_savedkg=0 if share_savedkg==. & (share_freekg==1 | share_purchasedkg==1)
  replace share_freekg=0 if share_freekg==. & (share_savedkg==1 | share_purchasedkg==1)
  replace share_purchasedkg=0 if share_purchasedkg==. & (share_savedkg==1 | share_freekg==1)
 
  foreach crop of global crop {
	for var purch_*_`crop': replace X=0 if X==. & purchased_`crop'==1	
	}	
gen wave=3
save "$path2\NGA_W3_seed_sources.dta", replace 
 
 


/* ----------------------------------------------------------------------------- *
* 		Part D: Construct wave 4 seed sources variables
* ----------------------------------------------------------------------------- */
 
 * generate specific crop and crop group variables 
 
 use  "$path1\Nigeria GHS Wave 4\Raw DTA Files\NGA_2018_GHSP-W4_v03_M_Stata12\sect11e1_plantingw4.dta", clear
  
  	gen crop_beanscowpeas=(cropcode==1010)
	gen crop_pigeonpeas=(cropcode==2150)
	gen crop_soybeans=(cropcode==2220)
	gen crop_sesame=(cropcode==2040)
	gen crop_gnuts=(cropcode==1060)
	gen crop_megusi=(cropcode==1090)
	gen crop_cashew=(cropcode==3020)
	gen crop_kolanut=(cropcode==3110)
	gen crop_bambara_nut=(cropcode==2020)
	
	gen crop_legumes_nuts=(crop_beanscowpeas==1 | crop_pigeonpeas==1 | crop_soybeans==1 | crop_sesame==1 | crop_gnuts==1 | crop_megusi==1 | crop_cashew==1 | crop_kolanut==1 | crop_bambara_nut==1) 
	
	
	gen crop_cassava=(cropcode==1020)
	gen crop_potato=(cropcode==2180 | cropcode==2181)
	gen crop_yams=(cropcode==1040 | cropcode==1121 | cropcode==1122 | cropcode==1123 | cropcode==1124)
	gen crop_banana=(cropcode==2030 | cropcode==2170)
	gen crop_rootstubers=(crop_cassava==1 | crop_potato==1 | crop_yams==1 | crop_banana==1)
		
		
	gen crop_sorghum=(cropcode==1070)	
	gen crop_maize=(cropcode==1080)
	gen crop_millet=(cropcode==1100)
	gen crop_rice=(cropcode==1110)
	gen crop_acha=(cropcode==2010)
	gen crop_cereals=(crop_sorghum==1 | crop_maize==1 | crop_millet==1 | crop_rice==1 | crop_acha==1)
	
	gen crop_carrot=(cropcode==2050)
	gen crop_cucumber=(cropcode==2060)	
	gen crop_cabbage=(cropcode==2070)
	gen crop_tomato=(cropcode==2260)
	gen crop_garden_egg=(cropcode==2080)
	gen crop_ginger=(cropcode==2100)	
	gen crop_okro=(cropcode==2120)
	gen crop_onion=(cropcode==2130)
	gen crop_pepper=(cropcode==2141 | cropcode==2142)
	gen crop_greenvegtable=(cropcode==2194)
	gen crop_zobo=(cropcode==2290)
	gen crop_pineapple=(cropcode==2160)
	gen crop_pumpkin=(cropcode==2190)
	gen crop_hortcrops=(crop_carrot==1 | crop_cucumber==1 | crop_cabbage==1 | crop_tomato==1 | crop_garden_egg==1 | crop_ginger==1 | crop_okro==1 | crop_onion==1 | crop_pepper==1 | crop_greenvegtable==1 | crop_zobo==1 | crop_pineapple==1 | crop_pumpkin==1)
	
	gen crop_cotton=(cropcode==1050)
	gen crop_sugarcane=(cropcode==2230)
	gen crop_tobacco=(cropcode==2250)
	gen crop_cocoa=(cropcode==3040)
	gen crop_tropcashcrops=(crop_cotton==1 | crop_sugarcane==1 | crop_tobacco==1 | crop_cocoa==1)
	
	gen crop_guava=(cropcode==3090)
	gen crop_mango=(cropcode==3160)
	gen crop_orange=(cropcode==3170)
	gen crop_palmoil=(cropcode==3180)
	gen crop_agbono=(cropcode==3190)
	gen crop_pawpaw=(cropcode==3210)
	gen crop_pear=(cropcode==3220)
	gen crop_avocado=(cropcode==3221)
	gen crop_fruittrees=(crop_guava==1 | crop_mango==1 | crop_orange==1 | crop_palmoil==1 | crop_agbono==1 | crop_pawpaw==1 | crop_pear==1 | crop_avocado==1)
	
	global crop beanscowpeas pigeonpeas soybeans sesame gnuts megusi cashew kolanut bambara_nut legumes_nuts cassava potato yams banana rootstubers sorghum maize millet rice acha ///
	       cereals carrot cucumber cabbage tomato garden_egg ginger okro onion pepper greenvegtable zobo pineapple pumpkin hortcrops cotton sugarcane tobacco cocoa tropcashcrops ///
		   guava mango orange palmoil agbono pawpaw pear avocado fruittrees
	
	 global source relative village market govt microf ngo coop 	 
 
 * home saved seeds 
  gen saved_seed=(s11eq4==1) if s11eq4!=.
 foreach crop of global crop {
	gen saved_`crop'=saved_seed * crop_`crop'	
	}	
	
ren s11eq6a savedseed_kg
 foreach crop of global crop {
	gen savedkg_`crop'=savedseed_kg * crop_`crop'	
	}	
	
	
 * free seeds 
gen free_seed=(s11eq8==1) if s11eq8!=.
 foreach crop of global crop {
	gen free_`crop'=free_seed * crop_`crop'	
	}

ren s11eq10a freeseed_kg
 foreach crop of global crop {
	gen freekg_`crop'=freeseed_kg * crop_`crop'	
	}	
  
 * purchased seed
 gen purchased_seed=(s11eq14==1) if s11eq14!=.
 foreach crop of global crop {
	gen purchased_`crop'=purchased_seed * crop_`crop'	
	}	


ren s11eq18a purchasedseed_kg
 foreach crop of global crop {
	gen purchasedkg_`crop'=purchasedseed_kg * crop_`crop'	
	}
	
	
 gen purch_relative=(s11eq22a==1 | s11eq22a==2) if s11eq22a!=.
 gen purch_village=(s11eq22a==3 | s11eq22a==4) if s11eq22a!=.
 gen purch_market=(s11eq22a==5 | s11eq22a==6 | s11eq22a==7) if s11eq22a!=.
 gen purch_govt=(s11eq22a==8 | s11eq22a==9) if s11eq22a!=.
 gen purch_microf=(s11eq22a==999) if s11eq22a!=.
 gen purch_ngo=(s11eq22a==999) if s11eq22a!=.
 gen purch_coop=(s11eq22a==999) if s11eq22a!=.
 
 foreach crop of global crop {
 	foreach source of global source {
	gen purch_`source'_`crop'=purch_`source' * crop_`crop'	
	}	
 }
 
 
 collapse (max) crop_* saved_* free_* purchased_* purch_* (sum) savedkg_* freekg_* purchasedkg_* *_kg, by (hhid)
 
 egen totalseedkg=rowtotal(savedseed_kg freeseed_kg purchasedseed_kg) if savedseed_kg!=. | freeseed_kg!=. | purchasedseed_kg!=.
 gen share_savedkg=(savedseed_kg/totalseedkg) if savedseed_kg!=. & totalseedkg!=.
 gen share_freekg=(freeseed_kg/totalseedkg) if freeseed_kg!=. & totalseedkg!=.
 gen share_purchasedkg=(purchasedseed_kg/totalseedkg) if purchasedseed_kg!=. & totalseedkg!=.
 
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 4\Final DTA files\created_data\Nigeria_GHS_W4_weights.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 4\Final DTA files\created_data\Nigeria_GHS_W4_farmsize_all_agland.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 4\Final DTA files\created_data\Nigeria_GHS_W4_hhsize.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path1\Nigeria GHS Wave 4\Final DTA files\created_data\Nigeria_GHS_W4_yield_hh_crop_level.dta", nogen
  
 * reconcile if households dont report seed source but quantity of seed from different sources is reported
  egen seeduse=rowtotal(saved_seed free_seed purchased_seed) if (saved_seed!=. | free_seed!=. | purchased_seed!=.)
  for var *_seed: replace X=. if X==0 & seeduse==0
  for var *_seed: replace X=0 if X==. & (seeduse==1 | seeduse==2 | seeduse==3)
  
  replace saved_seed=1 if saved_seed==. & share_savedkg>=0 & share_savedkg!=.
  replace free_seed=1 if free_seed==. & share_freekg>=0 & share_freekg!=.
  replace purchased_seed=1 if purchased_seed==. & share_purchasedkg>=0 & share_purchasedkg!=.
  
  * reconcile shares if households only report using seeds from a single source but dont report actual quantity of seed used
  replace share_savedkg=1 if share_savedkg==. & saved_seed==1 & seeduse==1
  replace share_freekg=1 if share_freekg==. & free_seed==1 & seeduse==1
  replace share_purchasedkg=1 if share_purchasedkg==. & purchased_seed==1 & seeduse==1
  
  replace share_savedkg=0 if share_savedkg==. & (share_freekg==1 | share_purchasedkg==1)
  replace share_freekg=0 if share_freekg==. & (share_savedkg==1 | share_purchasedkg==1)
  replace share_purchasedkg=0 if share_purchasedkg==. & (share_savedkg==1 | share_freekg==1)
  
  foreach crop of global crop {
	for var purch_*_`crop': replace X=0 if X==. & purchased_`crop'==1	
	}	

gen wave=4
save "$path2\NGA_W4_seed_sources.dta", replace 



/* ----------------------------------------------------------------------------- *
* 		Part E: Construct panel data 
* ----------------------------------------------------------------------------- */

use "$path2\NGA_W1_seed_sources.dta", clear
append using "$path2\NGA_W2_seed_sources.dta"
append using "$path2\NGA_W3_seed_sources.dta"
append using "$path2\NGA_W4_seed_sources.dta"
sort hhid wave 
save "$path2\NGA_seed_sources_panel.dta", replace 



/* ----------------------------------------------------------------------------- *
* 		Part F: Generate summary statistics by wave 
* ----------------------------------------------------------------------------- */


* directories still need to be reconciled
global crop legumes_nuts rootstubers cereals hortcrops

* Main seed sources and shares used 

foreach num of numlist 1 2 3 4 {
estpost su *_seed share_* [aw=weight_pop_rururb] if rural==1 & wave==`num'
estimates store NGA_seedsources_`num'
esttab NGA_seedsources_`num' using "C:\Users\pagamile\Desktop\results\NGA_seedsources_`num'.csv", title("Table `num': Seed sources and shares - Wave `num'") cells("count(fmt(0))mean(fmt(3)) sd(fmt(3))") collabels("Obs" "Mean" "SD.") coeflabels (saved_seed "Saved seed" free_seed "Free seed" purchased_seed "Purchased seed" share_savedkg "Share saved" share_freekg "Share free" share_purchasedkg "Share purchased") replace  	
}


* Main seed sources and shares used by gender of household head
foreach num of numlist 1 2 3 4 {
	foreach val of numlist 0 1 {
estpost su *_seed share_* [aw=weight_pop_rururb] if rural==1 & wave==`num' & fhh==`val'
est store NGA_seedsourcehh_`val'_`num'
esttab NGA_seedsourcehh_`val'_`num' using "C:\Users\pagamile\Desktop\results\NGA_seedsourcehh_`val'_`num'.csv", title("Table `num': Seed sources and shares by gender of household head (`val') - Wave `num'") cells("count(fmt(0))mean(fmt(3)) sd(fmt(3))") collabels("Obs" "Mean" "SD.") coeflabels (saved_seed "Saved seed" free_seed "Free seed" purchased_seed "Purchased seed" share_savedkg "Share saved" share_freekg "Share free" share_purchasedkg "Share purchased") replace  	
}
}


* Main seed sources by crop group 
foreach num of numlist 1 2 3 4 {
	foreach crop of global crop {
estpost su *_seed [aw=weight_pop_rururb] if rural==1 & wave==`num' & crop_`crop'==1
est store NGA_sdgp_`num'_`crop'
esttab NGA_sdgp_`num'_`crop' using "C:\Users\pagamile\Desktop\results\NGA_sdgp_`num'_`crop'.csv", title("Table `num': Main seed sources of `crop' - Wave `num'") cells("count(fmt(0))mean(fmt(3)) sd(fmt(3))") collabels("Obs" "Mean" "SD.") coeflabels (saved_seed "Saved seed" free_seed "Free seed" purchased_seed "Purchased seed") replace  	
}
}


* Sources of purchased seeds by crop group
foreach num of numlist 1 2 3 4 {
	foreach crop of global crop {
estpost su purch_*_`crop' [aw=weight_pop_rururb] if rural==1 & wave==`num' & crop_`crop'==1
est store NGA_pcs_`num'_`crop'
esttab NGA_pcs_`num'_`crop' using "C:\Users\pagamile\Desktop\results\NGA_pcs_`num'_`crop'.csv", title("Table `num': Sources of purchased `crop' seeds - Wave `num'") cells("count(fmt(0))mean(fmt(3)) sd(fmt(3))") collabels("Obs" "Mean" "SD.") coeflabels (purch_relative_`crop' "Relative" purch_village_`crop' "Village" purch_market_`crop' "Market" purch_govt_`crop' "Government" purch_microf_`crop' "Microfinance" purch_ngo_`crop' "NGO" purch_coop_`crop' "Cooperative") replace  	
}
}

 
 
*----------------------------------------------------------------------------- *
cap log close 
 
 
 
 