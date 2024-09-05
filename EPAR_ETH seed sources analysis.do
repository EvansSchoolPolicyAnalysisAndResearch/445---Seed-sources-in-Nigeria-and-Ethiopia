/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  to analyze the different sources of seed used by households in Ethiopia
				  using the Ethiopia Socioeconomic Survey data.
*Author(s)		: TBC

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: This  Version - September 5, 2024
----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
* https://microdata.worldbank.org/index.php/catalog/lsms/?page=1&country%5B%5D=66&ps=15&repo=lsms


/* ----------------------------------------------------------------------------- *
* File structure 
* Part A: Construct wave 1 seed sources variables
* Part B: Construct wave 2 seed sources variables
* Part C: Construct wave 3 seed sources variables
* Part D: Construct wave 4 seed sources variables
* Part E: Construct wave 4 seed sources variables
* Part F: Construct panel data 
* Part G: Generate summary statistics by wave 
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

global path1 "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\335 - Ag Team Data Support\Waves\Ethiopia ESS" 
global path2 "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\445 - Seed sources in Nigeria and Ethiopia\Data and analysis\data files\Ethiopia"



/* ----------------------------------------------------------------------------- *
* 		Part A: Construct wave 1 seed sources variables
* ----------------------------------------------------------------------------- */
 
    use "$path1\Ethiopia ESS Wave 1\Raw DTA Files\ETH_2011_2012\sect_nr_pp_w1.dta", clear
	keep household_id pp_snrq00 pp_snrq02
	ren household_id hhid
	ren pp_snrq00 network_cd
	drop if network_cd==""
	collapse (min) pp_snrq02, by (hhid network_cd)
	save "$path2\ETH_W1_networks.dta", replace 
	
	use "$path1\Ethiopia ESS Wave 1\Raw DTA Files\ETH_2011_2012\sect5_pp_w1.dta", clear
	ren household_id hhid
	replace pp_s5q04_a=pp_s5q04_b if pp_s5q04_a=="" & pp_s5q04_b!=""
	ren pp_s5q04_a network_cd
	drop if network_cd==""
	merge m:1 hhid network_cd using "$path2\ETH_W1_networks.dta", nogen keep (1 3)
	 keep hhid network_cd crop_code crop_name pp_snrq02
	drop if crop_code==. | pp_snrq02==.
	collapse (max) pp_snrq02, by (hhid crop_code crop_name network_cd)
	
 replace crop_name="BARLEY" if crop_name=="" & crop_code==1
 replace crop_name="MAIZE" if crop_name=="" & crop_code==2
 replace crop_name="OATS" if crop_name=="" & crop_code==4
 replace crop_name="SORGHUM" if crop_name=="" & crop_code==6
 replace crop_name="TEFF" if crop_name=="" & crop_code==7
 replace crop_name="WHEAT" if crop_name=="" & crop_code==8
 replace crop_name="HARICOT BEANS" if crop_name=="" & crop_code==12
 replace crop_name="HORSE BEANS" if crop_name=="" & crop_code==13
 replace crop_name="LENTILS" if crop_name=="" & crop_code==14
 replace crop_name="FIELD PEAS" if crop_name=="" & crop_code==15
 replace crop_name="VETCH" if crop_name=="" & crop_code==16
 replace crop_name="NUEG" if crop_name=="" & crop_code==25
 replace crop_name="FENUGREEK" if crop_name=="" & crop_code==36
 replace crop_name="BEER ROOT" if crop_name=="" & crop_code==51
 replace crop_name="CABBAGE" if crop_name=="" & crop_code==52
 replace crop_name="CAULIFLOWER" if crop_name=="" & crop_code==54
 replace crop_name="GARLIC" if crop_name=="" & crop_code==55
 replace crop_name="KALE" if crop_name=="" & crop_code==56
 replace crop_name="ONION" if crop_name=="" & crop_code==58
 replace crop_name="POTATOES" if crop_name=="" & crop_code==60
 replace crop_name="GESHO" if crop_name=="" & crop_code==75
 
 
   
	
  	gen crop_beans=(crop_name=="HORSE BEANS" | crop_name=="HARICOT BEANS" | crop_name=="CASTOR BEANS") 
	gen crop_peas=(crop_name=="CHICK PEAS" | crop_name=="FIELD PEAS")
	gen crop_soybeans=(crop_name=="SOYA BEANS")
	gen crop_sesame=(crop_name=="SESAME")
	gen crop_gnuts=(crop_name=="GROUND NUTS")
	gen crop_gibto=(crop_name=="GIBTO")
	gen crop_vetch=(crop_name=="VETCH")
	gen crop_sunflower=(crop_name=="SUNFLOWER")
	gen crop_lentils=(crop_name=="LENTILS")
	gen crop_lineseed=(crop_name=="LINESEED")
	
	gen crop_legumes_nuts=(crop_beans==1 | crop_peas==1 | crop_soybeans==1 | crop_sesame==1 | crop_gnuts==1 | crop_gibto==1 | crop_vetch==1 | crop_sunflower==1 | crop_lentils==1 | crop_lineseed==1) 
	
	gen crop_cassava=(crop_name=="CASSAVA")
	gen crop_potato=(crop_name=="POTATOES" | crop_name=="SWEET POTATO") 
	gen crop_godere=(crop_name=="GODERE")
	gen crop_banana=(crop_name=="BANANAS" | crop_name=="ENSET") 
	
	gen crop_rootstubers=(crop_cassava==1 | crop_potato==1 | crop_godere==1 | crop_banana==1) 
		
	gen crop_sorghum=(crop_name=="SORGHUM")	
	gen crop_maize=(crop_name=="MAIZE")
	gen crop_millet=(crop_name=="MILLET")
	gen crop_rice=(crop_name=="RICE")
	gen crop_teff=(crop_name=="TEFF")
	gen crop_wheat=(crop_name=="WHEAT") 
	gen crop_barley=(crop_name=="BARLEY") 
	gen crop_oats=(crop_name=="OATS")
	
	gen crop_cereals=(crop_sorghum==1 | crop_maize==1 | crop_millet==1 | crop_rice==1 | crop_teff==1 | crop_wheat==1 | crop_barley==1 | crop_oats==1) 
	
	gen crop_carrot=(crop_name=="CARROT")
	gen crop_fennel=(crop_name=="FENNEL")	
	gen crop_cabbage=(crop_name=="CABBAGE")
	gen crop_tomato=(crop_name=="TOMATOES")
	gen crop_beatroot=(crop_name=="BEER ROOT")
	gen crop_ginger=(crop_name=="GINGER")	
	gen crop_blackcumin=(crop_name=="BLACK CUMIN")
	gen crop_onion=(crop_name=="ONION")
	gen crop_pepper=(crop_name=="RED PEPPER" | crop_name=="GREEN PEPPER" | crop_name=="CHILIES") 
	gen crop_cardamon=(crop_name=="CARDAMON")
	gen crop_spinach=(crop_name=="SPINACH")
	gen crop_pineapple=(crop_name=="PINAPPLES")
	gen crop_watermelon=(crop_name=="WATERMELON")
	gen crop_cauliflower=(crop_name=="CAULIFLOWER")
	gen crop_cactus=(crop_name=="CACTUS")
	gen crop_cinnamon=(crop_name=="CINNAMON")
	gen crop_coriander=(crop_name=="CORIANDER") 
	gen crop_fenugreek=(crop_name=="FENUGREEK") 
	gen crop_feto=(crop_name=="FETO") 
	gen crop_garlic=(crop_name=="GARLIC") 
	gen crop_tumeric=(crop_name=="TUMERIC") 
	gen crop_kinem=(crop_name=="TIMIZ KIMEM") 
	gen crop_pumpkin=(crop_name=="PUMPKINS") 
	gen crop_lettuce=(crop_name=="LETTUCE") 
	gen crop_basil=(crop_name=="SACRED BASIL") 
	gen crop_kale=(crop_name=="KALE") 
	gen crop_mustard=(crop_name=="MUSTARD") 
	gen crop_nueg=(crop_name=="NUEG") 
	gen crop_rue=(crop_name=="RUE") 
	gen crop_savory=(crop_name=="SAVORY") 
	gen crop_strawberry=(crop_name=="STRAWBERRY")
	
	gen crop_hortcrops=(crop_carrot==1 | crop_fennel==1 | crop_cabbage==1 | crop_tomato==1 | crop_beatroot==1 | crop_ginger==1 | crop_blackcumin==1 | crop_onion==1 | crop_pepper==1 | crop_cardamon==1 | crop_spinach==1 | crop_pineapple==1 | crop_pumpkin==1 | crop_watermelon==1 | crop_cauliflower==1 | crop_cactus==1 | crop_cinnamon==1 | crop_coriander==1 | crop_fenugreek==1 | crop_feto==1 | crop_garlic==1 | crop_tumeric==1 | crop_kinem==1 | crop_lettuce==1 | crop_basil==1 | crop_kale==1 | crop_mustard==1 | crop_nueg==1 | crop_rue==1 | crop_savory==1 | crop_strawberry==1) 
	
	gen crop_cotton=(crop_name=="COTTON" | crop_name=="COTTON SEED") 
	gen crop_coffee=(crop_name=="COFFEE")
	gen crop_sugarcane=(crop_name=="SUGAR CANE")
	gen crop_tobacco=(crop_name=="TOBACCO")
	gen crop_tea=(crop_name=="TEA")
	gen crop_tropcashcrops=(crop_cotton==1 | crop_coffee==1 | crop_sugarcane==1 | crop_tobacco==1 | crop_tea==1)
	
	gen crop_guava=(crop_name=="GUAVA")
	gen crop_mango=(crop_name=="MANGOS")
	gen crop_orange=(crop_name=="ORANGES" | crop_name=="LEMONS" | crop_name=="CITRON" | crop_name=="MANDARINS") 
	gen crop_grapes=(crop_name=="GRAPES")
	gen crop_pawpaw=(crop_name=="PAPAYA")
	gen crop_peach=(crop_name=="PEACH")
	gen crop_avocado=(crop_name=="AVOCADOS")
	gen crop_apple=(crop_name=="APPLES")
	gen crop_gesho=(crop_name=="GESHO")
	gen crop_raspseed=(crop_name=="RAPE SEED") 
	gen crop_gishita=(crop_name=="GISHITA") 
	gen crop_kazmir=(crop_name=="KAZMIR") 
	gen crop_shiferaw=(crop_name=="SHIFERAW")
	
	gen crop_fruittrees=(crop_guava==1 | crop_mango==1 | crop_orange==1 | crop_grapes==1 | crop_peach==1 | crop_pawpaw==1 |  crop_avocado==1 | crop_apple==1 | crop_gesho==1 | crop_raspseed==1 | crop_gishita==1 | crop_kazmir==1 | crop_shiferaw==1)
	
	global crop beans peas soybeans sesame gnuts gibto vetch sunflower lentils lineseed legumes_nuts cassava potato godere banana rootstubers sorghum maize millet rice teff wheat barley oats cereals carrot fennel cabbage tomato beatroot ginger blackcumin onion pepper cardamon spinach pineapple pumpkin watermelon cauliflower cactus cinnamon coriander fenugreek feto garlic tumeric kinem lettuce basil kale mustard nueg rue savory strawberry hortcrops cotton coffee sugarcane tobacco tea tropcashcrops guava mango orange grapes peach pawpaw avocado apple gesho raspseed gishita kazmir shiferaw fruittrees
	
	
	
	global source relative village market govt microf ngo coop 
	
	* purchased seed sources 
	
  
 gen purch_relative=(pp_snrq02==1 | pp_snrq02==2) 
 gen purch_village=(pp_snrq02==3 | pp_snrq02==4 | pp_snrq02==5 | pp_snrq02==6 | pp_snrq02==7 | pp_snrq02==8 | pp_snrq02==19) 
 gen purch_market=(pp_snrq02==9 | pp_snrq02==10 | pp_snrq02==11 | pp_snrq02==12 | pp_snrq02==13 | pp_snrq02==14 | pp_snrq02==15 | pp_snrq02==16 | pp_snrq02==30) 
 gen purch_govt=(pp_snrq02==17 | pp_snrq02==18 | pp_snrq02==24 | pp_snrq02==25 | pp_snrq02==31) 
 gen purch_microf=(pp_snrq02==20 | pp_snrq02==21 | pp_snrq02==23)
 gen purch_ngo=(pp_snrq02==28 | pp_snrq02==29 | pp_snrq02==32)
 gen purch_coop=(pp_snrq02==22 | pp_snrq02==26 | pp_snrq02==27)
 
 
 foreach crop of global crop {
 	foreach source of global source {
	gen purch_`source'_`crop'=purch_`source' * crop_`crop'	
	}	
 }
 
 ren crop_name cropname
 
 collapse (max) crop_* purch_*, by (hhid)
 merge 1:1 hhid using "$path1\Ethiopia ESS Wave 1\Final DTA Files\created_data\Ethiopia_ESS_W1_hhids.dta", nogen keep(2 3)
 save "$path2\ETH_W1_purchasedsources.dta", replace 
 

 
 use "$path1\Ethiopia ESS Wave 1\Raw DTA Files\ETH_2011_2012\sect5_pp_w1.dta", clear
 ren household_id hhid
 replace crop_name="BARLEY" if crop_name=="" & crop_code==1
 replace crop_name="MAIZE" if crop_name=="" & crop_code==2
 replace crop_name="OATS" if crop_name=="" & crop_code==4
 replace crop_name="SORGHUM" if crop_name=="" & crop_code==6
 replace crop_name="TEFF" if crop_name=="" & crop_code==7
 replace crop_name="WHEAT" if crop_name=="" & crop_code==8
 replace crop_name="HARICOT BEANS" if crop_name=="" & crop_code==12
 replace crop_name="HORSE BEANS" if crop_name=="" & crop_code==13
 replace crop_name="LENTILS" if crop_name=="" & crop_code==14
 replace crop_name="FIELD PEAS" if crop_name=="" & crop_code==15
 replace crop_name="VETCH" if crop_name=="" & crop_code==16
 replace crop_name="NUEG" if crop_name=="" & crop_code==25
 replace crop_name="FENUGREEK" if crop_name=="" & crop_code==36
 replace crop_name="BEER ROOT" if crop_name=="" & crop_code==51
 replace crop_name="CABBAGE" if crop_name=="" & crop_code==52
 replace crop_name="CAULIFLOWER" if crop_name=="" & crop_code==54
 replace crop_name="GARLIC" if crop_name=="" & crop_code==55
 replace crop_name="KALE" if crop_name=="" & crop_code==56
 replace crop_name="ONION" if crop_name=="" & crop_code==58
 replace crop_name="POTATOES" if crop_name=="" & crop_code==60
 replace crop_name="GESHO" if crop_name=="" & crop_code==75
 
	
  	gen crop_beans=(crop_name=="HORSE BEANS" | crop_name=="HARICOT BEANS" | crop_name=="CASTOR BEANS") 
	gen crop_peas=(crop_name=="CHICK PEAS" | crop_name=="FIELD PEAS")
	gen crop_soybeans=(crop_name=="SOYA BEANS")
	gen crop_sesame=(crop_name=="SESAME")
	gen crop_gnuts=(crop_name=="GROUND NUTS")
	gen crop_gibto=(crop_name=="GIBTO")
	gen crop_vetch=(crop_name=="VETCH")
	gen crop_sunflower=(crop_name=="SUNFLOWER")
	gen crop_lentils=(crop_name=="LENTILS")
	gen crop_lineseed=(crop_name=="LINESEED")
	
	gen crop_legumes_nuts=(crop_beans==1 | crop_peas==1 | crop_soybeans==1 | crop_sesame==1 | crop_gnuts==1 | crop_gibto==1 | crop_vetch==1 | crop_sunflower==1 | crop_lentils==1 | crop_lineseed==1) 
	
	gen crop_cassava=(crop_name=="CASSAVA")
	gen crop_potato=(crop_name=="POTATOES" | crop_name=="SWEET POTATO") 
	gen crop_godere=(crop_name=="GODERE")
	gen crop_banana=(crop_name=="BANANAS" | crop_name=="ENSET") 
	
	gen crop_rootstubers=(crop_cassava==1 | crop_potato==1 | crop_godere==1 | crop_banana==1) 
		
	gen crop_sorghum=(crop_name=="SORGHUM")	
	gen crop_maize=(crop_name=="MAIZE")
	gen crop_millet=(crop_name=="MILLET")
	gen crop_rice=(crop_name=="RICE")
	gen crop_teff=(crop_name=="TEFF")
	gen crop_wheat=(crop_name=="WHEAT") 
	gen crop_barley=(crop_name=="BARLEY") 
	gen crop_oats=(crop_name=="OATS")
	
	gen crop_cereals=(crop_sorghum==1 | crop_maize==1 | crop_millet==1 | crop_rice==1 | crop_teff==1 | crop_wheat==1 | crop_barley==1 | crop_oats==1) 
	
	gen crop_carrot=(crop_name=="CARROT")
	gen crop_fennel=(crop_name=="FENNEL")	
	gen crop_cabbage=(crop_name=="CABBAGE")
	gen crop_tomato=(crop_name=="TOMATOES")
	gen crop_beatroot=(crop_name=="BEER ROOT")
	gen crop_ginger=(crop_name=="GINGER")	
	gen crop_blackcumin=(crop_name=="BLACK CUMIN")
	gen crop_onion=(crop_name=="ONION")
	gen crop_pepper=(crop_name=="RED PEPPER" | crop_name=="GREEN PEPPER" | crop_name=="CHILIES") 
	gen crop_cardamon=(crop_name=="CARDAMON")
	gen crop_spinach=(crop_name=="SPINACH")
	gen crop_pineapple=(crop_name=="PINAPPLES")
	gen crop_watermelon=(crop_name=="WATERMELON")
	gen crop_cauliflower=(crop_name=="CAULIFLOWER")
	gen crop_cactus=(crop_name=="CACTUS")
	gen crop_cinnamon=(crop_name=="CINNAMON")
	gen crop_coriander=(crop_name=="CORIANDER") 
	gen crop_fenugreek=(crop_name=="FENUGREEK") 
	gen crop_feto=(crop_name=="FETO") 
	gen crop_garlic=(crop_name=="GARLIC") 
	gen crop_tumeric=(crop_name=="TUMERIC") 
	gen crop_kinem=(crop_name=="TIMIZ KIMEM") 
	gen crop_pumpkin=(crop_name=="PUMPKINS") 
	gen crop_lettuce=(crop_name=="LETTUCE") 
	gen crop_basil=(crop_name=="SACRED BASIL") 
	gen crop_kale=(crop_name=="KALE") 
	gen crop_mustard=(crop_name=="MUSTARD") 
	gen crop_nueg=(crop_name=="NUEG") 
	gen crop_rue=(crop_name=="RUE") 
	gen crop_savory=(crop_name=="SAVORY") 
	gen crop_strawberry=(crop_name=="STRAWBERRY")
	
	gen crop_hortcrops=(crop_carrot==1 | crop_fennel==1 | crop_cabbage==1 | crop_tomato==1 | crop_beatroot==1 | crop_ginger==1 | crop_blackcumin==1 | crop_onion==1 | crop_pepper==1 | crop_cardamon==1 | crop_spinach==1 | crop_pineapple==1 | crop_pumpkin==1 | crop_watermelon==1 | crop_cauliflower==1 | crop_cactus==1 | crop_cinnamon==1 | crop_coriander==1 | crop_fenugreek==1 | crop_feto==1 | crop_garlic==1 | crop_tumeric==1 | crop_kinem==1 | crop_lettuce==1 | crop_basil==1 | crop_kale==1 | crop_mustard==1 | crop_nueg==1 | crop_rue==1 | crop_savory==1 | crop_strawberry==1) 
	
	gen crop_cotton=(crop_name=="COTTON" | crop_name=="COTTON SEED") 
	gen crop_coffee=(crop_name=="COFFEE")
	gen crop_sugarcane=(crop_name=="SUGAR CANE")
	gen crop_tobacco=(crop_name=="TOBACCO")
	gen crop_tea=(crop_name=="TEA")
	gen crop_tropcashcrops=(crop_cotton==1 | crop_coffee==1 | crop_sugarcane==1 | crop_tobacco==1 | crop_tea==1)
	
	gen crop_guava=(crop_name=="GUAVA")
	gen crop_mango=(crop_name=="MANGOS")
	gen crop_orange=(crop_name=="ORANGES" | crop_name=="LEMONS" | crop_name=="CITRON" | crop_name=="MANDARINS") 
	gen crop_grapes=(crop_name=="GRAPES")
	gen crop_pawpaw=(crop_name=="PAPAYA")
	gen crop_peach=(crop_name=="PEACH")
	gen crop_avocado=(crop_name=="AVOCADOS")
	gen crop_apple=(crop_name=="APPLES")
	gen crop_gesho=(crop_name=="GESHO")
	gen crop_raspseed=(crop_name=="RAPE SEED") 
	gen crop_gishita=(crop_name=="GISHITA") 
	gen crop_kazmir=(crop_name=="KAZMIR") 
	gen crop_shiferaw=(crop_name=="SHIFERAW")
	
	gen crop_fruittrees=(crop_guava==1 | crop_mango==1 | crop_orange==1 | crop_grapes==1 | crop_peach==1 | crop_pawpaw==1 |  crop_avocado==1 | crop_apple==1 | crop_gesho==1 | crop_raspseed==1 | crop_gishita==1 | crop_kazmir==1 | crop_shiferaw==1)
	
	global crop beans peas soybeans sesame gnuts gibto vetch sunflower lentils lineseed legumes_nuts cassava potato godere banana rootstubers sorghum maize millet rice teff wheat barley oats cereals carrot fennel cabbage tomato beatroot ginger blackcumin onion pepper cardamon spinach pineapple pumpkin watermelon cauliflower cactus cinnamon coriander fenugreek feto garlic tumeric kinem lettuce basil kale mustard nueg rue savory strawberry hortcrops cotton coffee sugarcane tobacco tea tropcashcrops guava mango orange grapes peach pawpaw avocado apple gesho raspseed gishita kazmir shiferaw fruittrees
	
	global source relative village market govt nonmarket
	
  
 * home saved seeds 
  gen saved_seed=(pp_s5q17==1) if pp_s5q17!=.
 foreach crop of global crop {
	gen saved_`crop'=saved_seed * crop_`crop'	
	}	
	
	 gen savedseed_kg=pp_s5q19_a + (pp_s5q19_b/1000) if pp_s5q19_a!=. | pp_s5q19_b!=.
 foreach crop of global crop {
	gen savedkg_`crop'=savedseed_kg * crop_`crop'	
	}	
	
 * free seeds 
gen free_seed=(pp_s5q13==1) if pp_s5q13!=.
 foreach crop of global crop {
	gen free_`crop'=free_seed * crop_`crop'	
	}
	
	
	gen freeseed_kg=pp_s5q14_a + (pp_s5q14_b/1000) if pp_s5q14_a!=. | pp_s5q14_b!=.
 foreach crop of global crop {
	gen freekg_`crop'=freeseed_kg * crop_`crop'	
	}	
 
 
 * purchased seed
 gen purchased_seed=(pp_s5q03==1) if pp_s5q03!=.
 foreach crop of global crop {
	gen purchased_`crop'=purchased_seed * crop_`crop'	
	}	
 
 
 gen purchasedseed_kg=pp_s5q05_a + (pp_s5q05_b/1000) if pp_s5q05_a!=. | pp_s5q05_b!=.
 foreach crop of global crop {
	gen purchasedkg_`crop'=purchasedseed_kg * crop_`crop'	
	}	
 
 
 
 
 ren crop_name cropname
 collapse (max) crop_* saved_* free_*  purchased_* (sum) savedkg_* freekg_* purchasedkg_* *_kg, by (hhid)
 
 egen totalseedkg=rowtotal(savedseed_kg freeseed_kg purchasedseed_kg) if savedseed_kg!=. | freeseed_kg!=. | purchasedseed_kg!=.
 gen share_savedkg=(savedseed_kg/totalseedkg) if savedseed_kg!=. & totalseedkg!=.
 gen share_freekg=(freeseed_kg/totalseedkg) if freeseed_kg!=. & totalseedkg!=.
 gen share_purchasedkg=(purchasedseed_kg/totalseedkg) if purchasedseed_kg!=. & totalseedkg!=.
 
 
 merge 1:1 hhid using "$path1\Ethiopia ESS Wave 1\Final DTA Files\created_data\Ethiopia_ESS_W1_hhids.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path2\ETH_W1_purchasedsources.dta", nogen 
 merge 1:1 hhid using "$path1\Ethiopia ESS Wave 1\Final DTA Files\created_data\Ethiopia_ESS_W1_farm_area.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path1\Ethiopia ESS Wave 1\Final DTA Files\created_data\Ethiopia_ESS_W1_hhsize.dta", nogen keep(2 3)
 ren hhid household_id
 merge 1:1 household_id using "$path1\Ethiopia ESS Wave 1\Final DTA Files\created_data\Ethiopia_ESS_W1_yield_hh_level.dta", nogen 
ren household_id hhid 
destring zone, gen (zon)
destring woreda, gen(wor)
destring kebele, gen(keb)
destring ea, gen(eaa)
drop zone woreda kebele ea
ren zon zone
ren wor woreda
ren keb kebele
ren eaa ea 
gen wave=1
 
  
  
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
	
save "$path2\ETH_W1_seed_sources.dta", replace 
  
 
 
 
/* ----------------------------------------------------------------------------- *
* 		Part B: Construct wave 2 seed sources variables
* ----------------------------------------------------------------------------- */
 
    use "$path1\Ethiopia ESS Wave 2\Raw DTA Files\ETH_2013_ESS_v02_M_Stata8\sectnr_pp_w2.dta", clear
	keep household_id2 pp_snrq00 pp_snrq02
	ren pp_snrq00 network_cd
	drop if network_cd==""
	collapse (min) pp_snrq02, by (household_id2 network_cd)
	save "$path2\ETH_W2_networks.dta", replace 
	
	use  "$path1\Ethiopia ESS Wave 2\Raw DTA Files\ETH_2013_ESS_v02_M_Stata8\sect5_pp_w2.dta", clear
	replace pp_s5q04_a=pp_s5q04_b if pp_s5q04_a=="" & pp_s5q04_b!=""
	ren pp_s5q04_a network_cd
	drop if network_cd==""
	merge m:1 household_id2 network_cd using "$path2\ETH_W2_networks.dta", nogen keep (1 3)
	 keep household_id2 network_cd crop_code crop_name pp_snrq02
	drop if crop_code==. | pp_snrq02==.
	collapse (max) pp_snrq02, by (household_id2 crop_code crop_name network_cd)
	
	replace crop_name="CASSAVA" if crop_name=="" & crop_code==10
 replace crop_name="Boye/yam" if crop_name=="" & crop_code==95
    
	
  	gen crop_beans=(crop_name=="HORSE BEANS" | crop_name=="HARICOT BEANS") 
	gen crop_peas=(crop_name=="CHICK PEAS" | crop_name=="FIELD PEAS")
	gen crop_soybeans=(crop_name=="SOYA BEANS")
	gen crop_sesame=(crop_name=="SESAME")
	gen crop_gnuts=(crop_name=="GROUND NUTS")
	gen crop_gibto=(crop_name=="GIBTO")
	gen crop_vetch=(crop_name=="VETCH")
	gen crop_sunflower=(crop_name=="SUNFLOWER")
	gen crop_lentils=(crop_name=="LENTILS")
	gen crop_lineseed=(crop_name=="LINESEED")
	
	gen crop_legumes_nuts=(crop_beans==1 | crop_peas==1 | crop_soybeans==1 | crop_sesame==1 | crop_gnuts==1 | crop_gibto==1 | crop_vetch==1 | crop_sunflower==1 | crop_lentils==1 | crop_lineseed==1) 
	
	gen crop_cassava=(crop_name=="CASSAVA")
	gen crop_potato=(crop_name=="POTATOES" | crop_name=="SWEET POTATO") 
	gen crop_godere=(crop_name=="GODERE")
	gen crop_yam=(crop_name=="Boye/yam")
	gen crop_banana=(crop_name=="BANANAS" | crop_name=="ENSET") 
	
	gen crop_rootstubers=(crop_cassava==1 | crop_potato==1 | crop_godere==1 | crop_yam==1 | crop_banana==1) 
		
	gen crop_sorghum=(crop_name=="SORGHUM")	
	gen crop_maize=(crop_name=="MAIZE")
	gen crop_millet=(crop_name=="MILLET")
	gen crop_rice=(crop_name=="RICE")
	gen crop_teff=(crop_name=="TEFF")
	gen crop_wheat=(crop_name=="WHEAT") 
	gen crop_barley=(crop_name=="BARLEY") 
	gen crop_oats=(crop_name=="OATS")
	
	gen crop_cereals=(crop_sorghum==1 | crop_maize==1 | crop_millet==1 | crop_rice==1 | crop_teff==1 | crop_wheat==1 | crop_barley==1 | crop_oats==1) 
	
	gen crop_carrot=(crop_name=="CARROT")
	gen crop_fennel=(crop_name=="FENNEL")	
	gen crop_cabbage=(crop_name=="CABBAGE")
	gen crop_tomato=(crop_name=="TOMATOES")
	gen crop_beatroot=(crop_name=="BEER ROOT")
	gen crop_ginger=(crop_name=="GINGER")	
	gen crop_blackcumin=(crop_name=="BLACK CUMIN")
	gen crop_onion=(crop_name=="ONION")
	gen crop_pepper=(crop_name=="BLACK PEPPER" | crop_name=="GREEN PEPPER" | | crop_name=="RED PEPPER") 
	gen crop_cardamon=(crop_name=="CARDAMON")
	gen crop_spinach=(crop_name=="SPINACH")
	gen crop_pineapple=(crop_name=="PINAPPLES")
	gen crop_watermelon=(crop_name=="WATERMELON")
	gen crop_cauliflower=(crop_name=="CAULIFLOWER")
	gen crop_cactus=(crop_name=="CACTUS")
	gen crop_cinnamon=(crop_name=="CINNAMON")
	gen crop_coriander=(crop_name=="CORIANDER") 
	gen crop_fenugreek=(crop_name=="FENUGREEK") 
	gen crop_feto=(crop_name=="FETO") 
	gen crop_garlic=(crop_name=="GARLIC") 
	gen crop_tumeric=(crop_name=="TUMERIC") 
	gen crop_kinem=(crop_name=="TIMIZ KIMEM") 
	gen crop_pumpkin=(crop_name=="PUMPKINS") 
	gen crop_lettuce=(crop_name=="LETTUCE") 
	gen crop_basil=(crop_name=="SACRED BASIL") 
	gen crop_kale=(crop_name=="KALE") 
	gen crop_mustard=(crop_name=="MUSTARD") 
	gen crop_nueg=(crop_name=="NUEG") 
	gen crop_rue=(crop_name=="RUE") 
	gen crop_savory=(crop_name=="SAVORY") 
	gen crop_strawberry=(crop_name=="STRAWBERRY")
	
	gen crop_hortcrops=(crop_carrot==1 | crop_fennel==1 | crop_cabbage==1 | crop_tomato==1 | crop_beatroot==1 | crop_ginger==1 | crop_blackcumin==1 | crop_onion==1 | crop_pepper==1 | crop_cardamon==1 | crop_spinach==1 | crop_pineapple==1 | crop_pumpkin==1 | crop_watermelon==1 | crop_cauliflower==1 | crop_cactus==1 | crop_cinnamon==1 | crop_coriander==1 | crop_fenugreek==1 | crop_feto==1 | crop_garlic==1 | crop_tumeric==1 | crop_kinem==1 | crop_lettuce==1 | crop_basil==1 | crop_kale==1 | crop_mustard==1 | crop_nueg==1 | crop_rue==1 | crop_savory==1 | crop_strawberry==1) 
	
	gen crop_cotton=(crop_name=="COTTON") 
	gen crop_coffee=(crop_name=="COFFEE")
	gen crop_sugarcane=(crop_name=="SUGAR CANE")
	gen crop_tobacco=(crop_name=="TOBACCO")
	gen crop_tea=(crop_name=="TEA")
	gen crop_tropcashcrops=(crop_cotton==1 | crop_coffee==1 | crop_sugarcane==1 | crop_tobacco==1 | crop_tea==1)
	
	gen crop_guava=(crop_name=="GUAVA")
	gen crop_mango=(crop_name=="MANGOS")
	gen crop_orange=(crop_name=="ORANGES" | crop_name=="LEMONS" | crop_name=="CITRON" | crop_name=="MANDARINS") 
	gen crop_grapes=(crop_name=="GRAPES")
	gen crop_pawpaw=(crop_name=="PAPAYA")
	gen crop_peach=(crop_name=="PEACH")
	gen crop_avocado=(crop_name=="AVOCADOS")
	gen crop_apple=(crop_name=="APPLES")
	gen crop_gesho=(crop_name=="GESHO")
	gen crop_raspseed=(crop_name=="RAPE SEED") 
	gen crop_gishita=(crop_name=="GISHITA") 
	gen crop_kazmir=(crop_name=="KAZMIR") 
	gen crop_shiferaw=(crop_name=="SHIFERAW")
	
	gen crop_fruittrees=(crop_guava==1 | crop_mango==1 | crop_orange==1 | crop_grapes==1 | crop_peach==1 | crop_pawpaw==1 |  crop_avocado==1 | crop_apple==1 | crop_gesho==1 | crop_raspseed==1 | crop_gishita==1 | crop_kazmir==1 | crop_shiferaw==1)
	
	global crop beans peas soybeans sesame gnuts gibto vetch sunflower lentils lineseed legumes_nuts cassava potato godere yam banana rootstubers sorghum maize millet rice teff wheat barley oats cereals carrot fennel cabbage tomato beatroot ginger blackcumin onion pepper cardamon spinach pineapple pumpkin watermelon cauliflower cactus cinnamon coriander fenugreek feto garlic tumeric kinem lettuce basil kale mustard nueg rue savory strawberry hortcrops cotton coffee sugarcane tobacco tea tropcashcrops guava mango orange grapes peach pawpaw avocado apple gesho raspseed gishita kazmir shiferaw fruittrees
	
	
	global source relative village market govt microf ngo coop 
	
	* purchased seed sources 
 gen purch_relative=(pp_snrq02==1 | pp_snrq02==2) 
 gen purch_village=(pp_snrq02==3 | pp_snrq02==4 | pp_snrq02==5 | pp_snrq02==6 | pp_snrq02==7 | pp_snrq02==8 | pp_snrq02==19) 
 gen purch_market=(pp_snrq02==9 | pp_snrq02==10 | pp_snrq02==11 | pp_snrq02==12 | pp_snrq02==13 | pp_snrq02==14 | pp_snrq02==15 | pp_snrq02==16 | pp_snrq02==30) 
 gen purch_govt=(pp_snrq02==17 | pp_snrq02==18 | pp_snrq02==24 | pp_snrq02==25 | pp_snrq02==31) 
 gen purch_microf=(pp_snrq02==20 | pp_snrq02==21 | pp_snrq02==23)
 gen purch_ngo=(pp_snrq02==28 | pp_snrq02==29 | pp_snrq02==32)
 gen purch_coop=(pp_snrq02==22 | pp_snrq02==26 | pp_snrq02==27)
 
 
 foreach crop of global crop {
 	foreach source of global source {
	gen purch_`source'_`crop'=purch_`source' * crop_`crop'	
	}	
 }
 
 ren crop_name cropname
 collapse (max) crop_* purch_*, by (household_id2)  
 ren household_id2 hhid
 merge 1:1 hhid using "$path1\Ethiopia ESS Wave 2\Final DTA Files\created_data\Ethiopia_ESS_W2_hhids.dta", nogen keep(2 3)
 ren hhid household_id2
 save "$path2\ETH_W2_purchasedsources.dta", replace 
 
 
 
 use  "$path1\Ethiopia ESS Wave 2\Raw DTA Files\ETH_2013_ESS_v02_M_Stata8\sect5_pp_w2.dta", clear
 
 replace crop_name="CASSAVA" if crop_name=="" & crop_code==10
 replace crop_name="Boye/yam" if crop_name=="" & crop_code==95
    
	
  	gen crop_beans=(crop_name=="HORSE BEANS" | crop_name=="HARICOT BEANS") 
	gen crop_peas=(crop_name=="CHICK PEAS" | crop_name=="FIELD PEAS")
	gen crop_soybeans=(crop_name=="SOYA BEANS")
	gen crop_sesame=(crop_name=="SESAME")
	gen crop_gnuts=(crop_name=="GROUND NUTS")
	gen crop_gibto=(crop_name=="GIBTO")
	gen crop_vetch=(crop_name=="VETCH")
	gen crop_sunflower=(crop_name=="SUNFLOWER")
	gen crop_lentils=(crop_name=="LENTILS")
	gen crop_lineseed=(crop_name=="LINESEED")
	
	gen crop_legumes_nuts=(crop_beans==1 | crop_peas==1 | crop_soybeans==1 | crop_sesame==1 | crop_gnuts==1 | crop_gibto==1 | crop_vetch==1 | crop_sunflower==1 | crop_lentils==1 | crop_lineseed==1) 
	
	gen crop_cassava=(crop_name=="CASSAVA")
	gen crop_potato=(crop_name=="POTATOES" | crop_name=="SWEET POTATO") 
	gen crop_godere=(crop_name=="GODERE")
	gen crop_yam=(crop_name=="Boye/yam")
	gen crop_banana=(crop_name=="BANANAS" | crop_name=="ENSET") 
	
	gen crop_rootstubers=(crop_cassava==1 | crop_potato==1 | crop_godere==1 | crop_yam==1 | crop_banana==1) 
		
	gen crop_sorghum=(crop_name=="SORGHUM")	
	gen crop_maize=(crop_name=="MAIZE")
	gen crop_millet=(crop_name=="MILLET")
	gen crop_rice=(crop_name=="RICE")
	gen crop_teff=(crop_name=="TEFF")
	gen crop_wheat=(crop_name=="WHEAT") 
	gen crop_barley=(crop_name=="BARLEY") 
	gen crop_oats=(crop_name=="OATS")
	
	gen crop_cereals=(crop_sorghum==1 | crop_maize==1 | crop_millet==1 | crop_rice==1 | crop_teff==1 | crop_wheat==1 | crop_barley==1 | crop_oats==1) 
	
	gen crop_carrot=(crop_name=="CARROT")
	gen crop_fennel=(crop_name=="FENNEL")	
	gen crop_cabbage=(crop_name=="CABBAGE")
	gen crop_tomato=(crop_name=="TOMATOES")
	gen crop_beatroot=(crop_name=="BEER ROOT")
	gen crop_ginger=(crop_name=="GINGER")	
	gen crop_blackcumin=(crop_name=="BLACK CUMIN")
	gen crop_onion=(crop_name=="ONION")
	gen crop_pepper=(crop_name=="BLACK PEPPER" | crop_name=="GREEN PEPPER" | | crop_name=="RED PEPPER") 
	gen crop_cardamon=(crop_name=="CARDAMON")
	gen crop_spinach=(crop_name=="SPINACH")
	gen crop_pineapple=(crop_name=="PINAPPLES")
	gen crop_watermelon=(crop_name=="WATERMELON")
	gen crop_cauliflower=(crop_name=="CAULIFLOWER")
	gen crop_cactus=(crop_name=="CACTUS")
	gen crop_cinnamon=(crop_name=="CINNAMON")
	gen crop_coriander=(crop_name=="CORIANDER") 
	gen crop_fenugreek=(crop_name=="FENUGREEK") 
	gen crop_feto=(crop_name=="FETO") 
	gen crop_garlic=(crop_name=="GARLIC") 
	gen crop_tumeric=(crop_name=="TUMERIC") 
	gen crop_kinem=(crop_name=="TIMIZ KIMEM") 
	gen crop_pumpkin=(crop_name=="PUMPKINS") 
	gen crop_lettuce=(crop_name=="LETTUCE") 
	gen crop_basil=(crop_name=="SACRED BASIL") 
	gen crop_kale=(crop_name=="KALE") 
	gen crop_mustard=(crop_name=="MUSTARD") 
	gen crop_nueg=(crop_name=="NUEG") 
	gen crop_rue=(crop_name=="RUE") 
	gen crop_savory=(crop_name=="SAVORY") 
	gen crop_strawberry=(crop_name=="STRAWBERRY")
	
	gen crop_hortcrops=(crop_carrot==1 | crop_fennel==1 | crop_cabbage==1 | crop_tomato==1 | crop_beatroot==1 | crop_ginger==1 | crop_blackcumin==1 | crop_onion==1 | crop_pepper==1 | crop_cardamon==1 | crop_spinach==1 | crop_pineapple==1 | crop_pumpkin==1 | crop_watermelon==1 | crop_cauliflower==1 | crop_cactus==1 | crop_cinnamon==1 | crop_coriander==1 | crop_fenugreek==1 | crop_feto==1 | crop_garlic==1 | crop_tumeric==1 | crop_kinem==1 | crop_lettuce==1 | crop_basil==1 | crop_kale==1 | crop_mustard==1 | crop_nueg==1 | crop_rue==1 | crop_savory==1 | crop_strawberry==1) 
	
	gen crop_cotton=(crop_name=="COTTON") 
	gen crop_coffee=(crop_name=="COFFEE")
	gen crop_sugarcane=(crop_name=="SUGAR CANE")
	gen crop_tobacco=(crop_name=="TOBACCO")
	gen crop_tea=(crop_name=="TEA")
	gen crop_tropcashcrops=(crop_cotton==1 | crop_coffee==1 | crop_sugarcane==1 | crop_tobacco==1 | crop_tea==1)
	
	gen crop_guava=(crop_name=="GUAVA")
	gen crop_mango=(crop_name=="MANGOS")
	gen crop_orange=(crop_name=="ORANGES" | crop_name=="LEMONS" | crop_name=="CITRON" | crop_name=="MANDARINS") 
	gen crop_grapes=(crop_name=="GRAPES")
	gen crop_pawpaw=(crop_name=="PAPAYA")
	gen crop_peach=(crop_name=="PEACH")
	gen crop_avocado=(crop_name=="AVOCADOS")
	gen crop_apple=(crop_name=="APPLES")
	gen crop_gesho=(crop_name=="GESHO")
	gen crop_raspseed=(crop_name=="RAPE SEED") 
	gen crop_gishita=(crop_name=="GISHITA") 
	gen crop_kazmir=(crop_name=="KAZMIR") 
	gen crop_shiferaw=(crop_name=="SHIFERAW")
	
	gen crop_fruittrees=(crop_guava==1 | crop_mango==1 | crop_orange==1 | crop_grapes==1 | crop_peach==1 | crop_pawpaw==1 |  crop_avocado==1 | crop_apple==1 | crop_gesho==1 | crop_raspseed==1 | crop_gishita==1 | crop_kazmir==1 | crop_shiferaw==1)
	
	global crop beans peas soybeans sesame gnuts gibto vetch sunflower lentils lineseed legumes_nuts cassava potato godere yam banana rootstubers sorghum maize millet rice teff wheat barley oats cereals carrot fennel cabbage tomato beatroot ginger blackcumin onion pepper cardamon spinach pineapple pumpkin watermelon cauliflower cactus cinnamon coriander fenugreek feto garlic tumeric kinem lettuce basil kale mustard nueg rue savory strawberry hortcrops cotton coffee sugarcane tobacco tea tropcashcrops guava mango orange grapes peach pawpaw avocado apple gesho raspseed gishita kazmir shiferaw fruittrees
	
	global source relative village market govt nonmarket
	
	
  
 * home saved seeds 
  gen saved_seed=(pp_s5q17==1) if pp_s5q17!=.
 foreach crop of global crop {
	gen saved_`crop'=saved_seed * crop_`crop'	
	}	
	

gen savedseed_kg=pp_s5q19_a + (pp_s5q19_b/1000) if pp_s5q19_a!=. | pp_s5q19_b!=.
 foreach crop of global crop {
	gen savedkg_`crop'=savedseed_kg * crop_`crop'	
	}	
	
 * free seeds 
gen free_seed=(pp_s5q13==1) if pp_s5q13!=.
 foreach crop of global crop {
	gen free_`crop'=free_seed * crop_`crop'	
	}
 
 
 gen freeseed_kg=pp_s5q14_a + (pp_s5q14_b/1000) if pp_s5q14_a!=. | pp_s5q14_b!=.
 foreach crop of global crop {
	gen freekg_`crop'=freeseed_kg * crop_`crop'	
	}	
	
 
 * purchased seed
 gen purchased_seed=(pp_s5q03==1) if pp_s5q03!=.
 foreach crop of global crop {
	gen purchased_`crop'=purchased_seed * crop_`crop'	
	}	
 
 
 gen purchasedseed_kg=pp_s5q05_a + (pp_s5q05_b/1000) if pp_s5q05_a!=. | pp_s5q05_b!=.
 foreach crop of global crop {
	gen purchasedkg_`crop'=purchasedseed_kg * crop_`crop'	
	}	
 
 ren crop_name cropname
 
 collapse (max) crop_* saved_* free_*  purchased_* (sum) savedkg_* freekg_* purchasedkg_* *_kg, by (household_id2)
    

 egen totalseedkg=rowtotal(savedseed_kg freeseed_kg purchasedseed_kg) if savedseed_kg!=. | freeseed_kg!=. | purchasedseed_kg!=.
 gen share_savedkg=(savedseed_kg/totalseedkg) if savedseed_kg!=. & totalseedkg!=.
 gen share_freekg=(freeseed_kg/totalseedkg) if freeseed_kg!=. & totalseedkg!=.
 gen share_purchasedkg=(purchasedseed_kg/totalseedkg) if purchasedseed_kg!=. & totalseedkg!=.
 ren household_id2 hhid
 merge 1:1 hhid using "$path1\Ethiopia ESS Wave 2\Final DTA Files\created_data\Ethiopia_ESS_W2_hhids.dta", nogen keep(2 3) 
 ren hhid household_id2
 merge 1:1 household_id2 using "$path2\ETH_W2_purchasedsources.dta", nogen 
 ren household_id2 hhid
 merge 1:1 hhid using "$path1\Ethiopia ESS Wave 2\Final DTA Files\created_data\Ethiopia_ESS_W2_farm_area.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path1\Ethiopia ESS Wave 2\Final DTA Files\created_data\Ethiopia_ESS_W2_male_head", nogen keep(2 3)
 ren hhid household_id2
 merge 1:1 household_id2 using "$path1\Ethiopia ESS Wave 2\Final DTA Files\created_data\old\Ethiopia_ESS_W2_yield_hh_level.dta", nogen 
 ren household_id2 hhid
 gen wave=2
 
  
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

	save "$path2\ETH_W2_seed_sources.dta", replace 
 

 
 
 
/* ----------------------------------------------------------------------------- *
* 		Part C: Construct wave 3 seed sources variables
* ----------------------------------------------------------------------------- */
 
 use "$path1\Ethiopia ESS Wave 3\Raw DTA Files\ETH_2015_ESS_v02_M_STATA8\sectnr_pp_w3.dta", clear
	keep household_id2 pp_snrq00 pp_snrq02
	ren pp_snrq00 network_cd
	drop if network_cd==""
	collapse (min) pp_snrq02, by (household_id2 network_cd)
	save "$path2\ETH_W3_networks.dta", replace 
	
	use "$path1\Ethiopia ESS Wave 3\Raw DTA Files\ETH_2015_ESS_v02_M_STATA8\sect5_pp_w3.dta", clear
	replace pp_s5q04_a=pp_s5q04_b if pp_s5q04_a=="" & pp_s5q04_b!=""
	gen network_cd=substr(pp_s5q04_a, 1, 1) + "0" + substr(pp_s5q04_a, 2, 1) if pp_s5q04_a!=""
	drop if network_cd==""
	merge m:1 household_id2 network_cd using "$path2\ETH_W3_networks.dta", nogen keep (1 3)
	 keep household_id2 network_cd pp_s5q0a pp_s5q00 pp_snrq02
	drop if pp_s5q00==. | pp_snrq02==.
	collapse (max) pp_snrq02, by (household_id2 pp_s5q0a pp_s5q00 network_cd)
 
 	ren pp_s5q0a crop_name
  	gen crop_beans=(crop_name=="HORSE BEANS" | crop_name=="HARICOT BEANS" | crop_name=="Mung Bean/ MASHO" | crop_name=="MENGIBIN/ MASHO" | crop_name=="RED KIDENY BEANS") 
	gen crop_peas=(crop_name=="CHICK PEAS" | crop_name=="FIELD PEAS")
	gen crop_soybeans=(crop_name=="SOYA BEANS")
	gen crop_sesame=(crop_name=="SESAME")
	gen crop_gnuts=(crop_name=="GROUND NUTS")
	gen crop_gibto=(crop_name=="GIBTO")
	gen crop_vetch=(crop_name=="VETCH")
	gen crop_sunflower=(crop_name=="SUNFLOWER")
	gen crop_lentils=(crop_name=="LENTILS")
	gen crop_lineseed=(crop_name=="LINESEED")
	
	gen crop_legumes_nuts=(crop_beans==1 | crop_peas==1 | crop_soybeans==1 | crop_sesame==1 | crop_gnuts==1 | crop_gibto==1 | crop_vetch==1 | crop_sunflower==1 | crop_lentils==1 | crop_lineseed==1) 
	
	gen crop_cassava=(crop_name=="CASSAVA")
	gen crop_potato=(crop_name=="POTATOES" | crop_name=="SWEET POTATO") 
	gen crop_godere=(crop_name=="GODERE")
	gen crop_banana=(crop_name=="BANANAS" | crop_name=="ENSET") 
	
	gen crop_rootstubers=(crop_cassava==1 | crop_potato==1 | crop_godere==1 | crop_banana==1) 
		
	gen crop_sorghum=(crop_name=="SORGHUM")	
	gen crop_maize=(crop_name=="MAIZE")
	gen crop_millet=(crop_name=="MILLET")
	gen crop_rice=(crop_name=="RICE")
	gen crop_teff=(crop_name=="TEFF")
	gen crop_wheat=(crop_name=="WHEAT") 
	gen crop_barley=(crop_name=="BARLEY") 
	gen crop_oats=(crop_name=="OATS")
	
	gen crop_cereals=(crop_sorghum==1 | crop_maize==1 | crop_millet==1 | crop_rice==1 | crop_teff==1 | crop_wheat==1 | crop_barley==1 | crop_oats==1) 
	
	gen crop_carrot=(crop_name=="CARROT")
	gen crop_fennel=(crop_name=="FENNEL")	
	gen crop_cabbage=(crop_name=="CABBAGE")
	gen crop_tomato=(crop_name=="TOMATOES")
	gen crop_beatroot=(crop_name=="BEER ROOT")
	gen crop_ginger=(crop_name=="GINGER")	
	gen crop_blackcumin=(crop_name=="BLACK CUMIN")
	gen crop_onion=(crop_name=="ONION")
	gen crop_pepper=(crop_name=="RED PEPPER" | crop_name=="GREEN PEPPER" | crop_name=="CHILIES") 
	gen crop_cardamon=(crop_name=="CARDAMON")
	gen crop_spinach=(crop_name=="SPINACH")
	gen crop_pineapple=(crop_name=="PINAPPLES")
	gen crop_watermelon=(crop_name=="WATERMELON")
	gen crop_cauliflower=(crop_name=="CAULIFLOWER")
	gen crop_cactus=(crop_name=="CACTUS")
	gen crop_cinnamon=(crop_name=="CINNAMON")
	gen crop_coriander=(crop_name=="CORIANDER") 
	gen crop_fenugreek=(crop_name=="FENUGREEK") 
	gen crop_feto=(crop_name=="FETO") 
	gen crop_garlic=(crop_name=="GARLIC") 
	gen crop_tumeric=(crop_name=="TUMERIC") 
	gen crop_kinem=(crop_name=="TIMIZ KIMEM") 
	gen crop_pumpkin=(crop_name=="PUMPKINS") 
	gen crop_lettuce=(crop_name=="LETTUCE") 
	gen crop_basil=(crop_name=="SACRED BASIL") 
	gen crop_kale=(crop_name=="KALE") 
	gen crop_mustard=(crop_name=="MUSTARD") 
	gen crop_nueg=(crop_name=="NUEG") 
	gen crop_rue=(crop_name=="RUE") 
	gen crop_savory=(crop_name=="SAVORY") 
	gen crop_strawberry=(crop_name=="STRAWBERRY")
	
	gen crop_hortcrops=(crop_carrot==1 | crop_fennel==1 | crop_cabbage==1 | crop_tomato==1 | crop_beatroot==1 | crop_ginger==1 | crop_blackcumin==1 | crop_onion==1 | crop_pepper==1 | crop_cardamon==1 | crop_spinach==1 | crop_pineapple==1 | crop_pumpkin==1 | crop_watermelon==1 | crop_cauliflower==1 | crop_cactus==1 | crop_cinnamon==1 | crop_coriander==1 | crop_fenugreek==1 | crop_feto==1 | crop_garlic==1 | crop_tumeric==1 | crop_kinem==1 | crop_lettuce==1 | crop_basil==1 | crop_kale==1 | crop_mustard==1 | crop_nueg==1 | crop_rue==1 | crop_savory==1 | crop_strawberry==1) 
	
	gen crop_cotton=(crop_name=="COTTON" | crop_name=="COTTON SEED") 
	gen crop_coffee=(crop_name=="COFFEE")
	gen crop_sugarcane=(crop_name=="SUGAR CANE")
	gen crop_tobacco=(crop_name=="TOBACCO")
	gen crop_tea=(crop_name=="TEA")
	gen crop_tropcashcrops=(crop_cotton==1 | crop_coffee==1 | crop_sugarcane==1 | crop_tobacco==1 | crop_tea==1)
	
	gen crop_guava=(crop_name=="GUAVA")
	gen crop_mango=(crop_name=="MANGOS")
	gen crop_orange=(crop_name=="ORANGES" | crop_name=="LEMONS" | crop_name=="CITRON" | crop_name=="MANDARINS") 
	gen crop_grapes=(crop_name=="GRAPES")
	gen crop_pawpaw=(crop_name=="PAPAYA")
	gen crop_peach=(crop_name=="PEACH")
	gen crop_avocado=(crop_name=="AVOCADOS")
	gen crop_apple=(crop_name=="APPLES")
	gen crop_gesho=(crop_name=="GESHO")
	gen crop_raspseed=(crop_name=="RAPE SEED") 
	gen crop_gishita=(crop_name=="GISHITA") 
	gen crop_kazmir=(crop_name=="KAZMIR") 
	gen crop_shiferaw=(crop_name=="SHIFERAW")
	
	gen crop_fruittrees=(crop_guava==1 | crop_mango==1 | crop_orange==1 | crop_grapes==1 | crop_peach==1 | crop_pawpaw==1 |  crop_avocado==1 | crop_apple==1 | crop_gesho==1 | crop_raspseed==1 | crop_gishita==1 | crop_kazmir==1 | crop_shiferaw==1)
	
	global crop beans peas soybeans sesame gnuts gibto vetch sunflower lentils lineseed legumes_nuts cassava potato godere banana rootstubers sorghum maize millet rice teff wheat barley oats cereals carrot fennel cabbage tomato beatroot ginger blackcumin onion pepper cardamon spinach pineapple pumpkin watermelon cauliflower cactus cinnamon coriander fenugreek feto garlic tumeric kinem lettuce basil kale mustard nueg rue savory strawberry hortcrops cotton coffee sugarcane tobacco tea tropcashcrops guava mango orange grapes peach pawpaw avocado apple gesho raspseed gishita kazmir shiferaw fruittrees
	
 	global source relative village market govt microf ngo coop 
	
	* purchased seed sources 
	
  
 gen purch_relative=(pp_snrq02==1 | pp_snrq02==2) 
 gen purch_village=(pp_snrq02==3 | pp_snrq02==4 | pp_snrq02==5 | pp_snrq02==6 | pp_snrq02==7 | pp_snrq02==8 | pp_snrq02==19) 
 gen purch_market=(pp_snrq02==9 | pp_snrq02==10 | pp_snrq02==11 | pp_snrq02==12 | pp_snrq02==13 | pp_snrq02==14 | pp_snrq02==15 | pp_snrq02==16 | pp_snrq02==30) 
 gen purch_govt=(pp_snrq02==17 | pp_snrq02==18 | pp_snrq02==24 | pp_snrq02==25 | pp_snrq02==31) 
 gen purch_microf=(pp_snrq02==20 | pp_snrq02==21 | pp_snrq02==23)
 gen purch_ngo=(pp_snrq02==28 | pp_snrq02==29 | pp_snrq02==32)
 gen purch_coop=(pp_snrq02==22 | pp_snrq02==26 | pp_snrq02==27)
 
 
 foreach crop of global crop {
 	foreach source of global source {
	gen purch_`source'_`crop'=purch_`source' * crop_`crop'	
	}	
 }
 
 ren crop_name cropname
 collapse (max) crop_* purch_*, by (household_id2)
 merge 1:1 household_id2 using "$path1\Ethiopia ESS Wave 3\Final DTA Files\created_data\Ethiopia_ESS_W3_hhids.dta", nogen keep(2 3)
 save "$path2\ETH_W3_purchasedsources.dta", replace 
 
 
 use "$path1\Ethiopia ESS Wave 3\Raw DTA Files\ETH_2015_ESS_v02_M_STATA8\sect5_pp_w3.dta", clear
 
    
	ren pp_s5q0a crop_name
  	gen crop_beans=(crop_name=="HORSE BEANS" | crop_name=="HARICOT BEANS" | crop_name=="Mung Bean/ MASHO" | crop_name=="MENGIBIN/ MASHO" | crop_name=="RED KIDENY BEANS") 
	gen crop_peas=(crop_name=="CHICK PEAS" | crop_name=="FIELD PEAS")
	gen crop_soybeans=(crop_name=="SOYA BEANS")
	gen crop_sesame=(crop_name=="SESAME")
	gen crop_gnuts=(crop_name=="GROUND NUTS")
	gen crop_gibto=(crop_name=="GIBTO")
	gen crop_vetch=(crop_name=="VETCH")
	gen crop_sunflower=(crop_name=="SUNFLOWER")
	gen crop_lentils=(crop_name=="LENTILS")
	gen crop_lineseed=(crop_name=="LINESEED")
	
	gen crop_legumes_nuts=(crop_beans==1 | crop_peas==1 | crop_soybeans==1 | crop_sesame==1 | crop_gnuts==1 | crop_gibto==1 | crop_vetch==1 | crop_sunflower==1 | crop_lentils==1 | crop_lineseed==1) 
	
	gen crop_cassava=(crop_name=="CASSAVA")
	gen crop_potato=(crop_name=="POTATOES" | crop_name=="SWEET POTATO") 
	gen crop_godere=(crop_name=="GODERE")
	gen crop_banana=(crop_name=="BANANAS" | crop_name=="ENSET") 
	
	gen crop_rootstubers=(crop_cassava==1 | crop_potato==1 | crop_godere==1 | crop_banana==1) 
		
	gen crop_sorghum=(crop_name=="SORGHUM")	
	gen crop_maize=(crop_name=="MAIZE")
	gen crop_millet=(crop_name=="MILLET")
	gen crop_rice=(crop_name=="RICE")
	gen crop_teff=(crop_name=="TEFF")
	gen crop_wheat=(crop_name=="WHEAT") 
	gen crop_barley=(crop_name=="BARLEY") 
	gen crop_oats=(crop_name=="OATS")
	
	gen crop_cereals=(crop_sorghum==1 | crop_maize==1 | crop_millet==1 | crop_rice==1 | crop_teff==1 | crop_wheat==1 | crop_barley==1 | crop_oats==1) 
	
	gen crop_carrot=(crop_name=="CARROT")
	gen crop_fennel=(crop_name=="FENNEL")	
	gen crop_cabbage=(crop_name=="CABBAGE")
	gen crop_tomato=(crop_name=="TOMATOES")
	gen crop_beatroot=(crop_name=="BEER ROOT")
	gen crop_ginger=(crop_name=="GINGER")	
	gen crop_blackcumin=(crop_name=="BLACK CUMIN")
	gen crop_onion=(crop_name=="ONION")
	gen crop_pepper=(crop_name=="RED PEPPER" | crop_name=="GREEN PEPPER" | crop_name=="CHILIES") 
	gen crop_cardamon=(crop_name=="CARDAMON")
	gen crop_spinach=(crop_name=="SPINACH")
	gen crop_pineapple=(crop_name=="PINAPPLES")
	gen crop_watermelon=(crop_name=="WATERMELON")
	gen crop_cauliflower=(crop_name=="CAULIFLOWER")
	gen crop_cactus=(crop_name=="CACTUS")
	gen crop_cinnamon=(crop_name=="CINNAMON")
	gen crop_coriander=(crop_name=="CORIANDER") 
	gen crop_fenugreek=(crop_name=="FENUGREEK") 
	gen crop_feto=(crop_name=="FETO") 
	gen crop_garlic=(crop_name=="GARLIC") 
	gen crop_tumeric=(crop_name=="TUMERIC") 
	gen crop_kinem=(crop_name=="TIMIZ KIMEM") 
	gen crop_pumpkin=(crop_name=="PUMPKINS") 
	gen crop_lettuce=(crop_name=="LETTUCE") 
	gen crop_basil=(crop_name=="SACRED BASIL") 
	gen crop_kale=(crop_name=="KALE") 
	gen crop_mustard=(crop_name=="MUSTARD") 
	gen crop_nueg=(crop_name=="NUEG") 
	gen crop_rue=(crop_name=="RUE") 
	gen crop_savory=(crop_name=="SAVORY") 
	gen crop_strawberry=(crop_name=="STRAWBERRY")
	
	gen crop_hortcrops=(crop_carrot==1 | crop_fennel==1 | crop_cabbage==1 | crop_tomato==1 | crop_beatroot==1 | crop_ginger==1 | crop_blackcumin==1 | crop_onion==1 | crop_pepper==1 | crop_cardamon==1 | crop_spinach==1 | crop_pineapple==1 | crop_pumpkin==1 | crop_watermelon==1 | crop_cauliflower==1 | crop_cactus==1 | crop_cinnamon==1 | crop_coriander==1 | crop_fenugreek==1 | crop_feto==1 | crop_garlic==1 | crop_tumeric==1 | crop_kinem==1 | crop_lettuce==1 | crop_basil==1 | crop_kale==1 | crop_mustard==1 | crop_nueg==1 | crop_rue==1 | crop_savory==1 | crop_strawberry==1) 
	
	gen crop_cotton=(crop_name=="COTTON" | crop_name=="COTTON SEED") 
	gen crop_coffee=(crop_name=="COFFEE")
	gen crop_sugarcane=(crop_name=="SUGAR CANE")
	gen crop_tobacco=(crop_name=="TOBACCO")
	gen crop_tea=(crop_name=="TEA")
	gen crop_tropcashcrops=(crop_cotton==1 | crop_coffee==1 | crop_sugarcane==1 | crop_tobacco==1 | crop_tea==1)
	
	gen crop_guava=(crop_name=="GUAVA")
	gen crop_mango=(crop_name=="MANGOS")
	gen crop_orange=(crop_name=="ORANGES" | crop_name=="LEMONS" | crop_name=="CITRON" | crop_name=="MANDARINS") 
	gen crop_grapes=(crop_name=="GRAPES")
	gen crop_pawpaw=(crop_name=="PAPAYA")
	gen crop_peach=(crop_name=="PEACH")
	gen crop_avocado=(crop_name=="AVOCADOS")
	gen crop_apple=(crop_name=="APPLES")
	gen crop_gesho=(crop_name=="GESHO")
	gen crop_raspseed=(crop_name=="RAPE SEED") 
	gen crop_gishita=(crop_name=="GISHITA") 
	gen crop_kazmir=(crop_name=="KAZMIR") 
	gen crop_shiferaw=(crop_name=="SHIFERAW")
	
	gen crop_fruittrees=(crop_guava==1 | crop_mango==1 | crop_orange==1 | crop_grapes==1 | crop_peach==1 | crop_pawpaw==1 |  crop_avocado==1 | crop_apple==1 | crop_gesho==1 | crop_raspseed==1 | crop_gishita==1 | crop_kazmir==1 | crop_shiferaw==1)
	
	global crop beans peas soybeans sesame gnuts gibto vetch sunflower lentils lineseed legumes_nuts cassava potato godere banana rootstubers sorghum maize millet rice teff wheat barley oats cereals carrot fennel cabbage tomato beatroot ginger blackcumin onion pepper cardamon spinach pineapple pumpkin watermelon cauliflower cactus cinnamon coriander fenugreek feto garlic tumeric kinem lettuce basil kale mustard nueg rue savory strawberry hortcrops cotton coffee sugarcane tobacco tea tropcashcrops guava mango orange grapes peach pawpaw avocado apple gesho raspseed gishita kazmir shiferaw fruittrees
	
  
 * home saved seeds 
  gen saved_seed=(pp_s5q17==1) if pp_s5q17!=.
 foreach crop of global crop {
	gen saved_`crop'=saved_seed * crop_`crop'	
	}	

gen savedseed_kg=pp_s5q19_a + (pp_s5q19_b/1000) if pp_s5q19_a!=. | pp_s5q19_b!=.
 foreach crop of global crop {
	gen savedkg_`crop'=savedseed_kg * crop_`crop'	
	}
	
 * free seeds 
gen free_seed=(pp_s5q13==1) if pp_s5q13!=.
 foreach crop of global crop {
	gen free_`crop'=free_seed * crop_`crop'	
	}

	
gen freeseed_kg=pp_s5q14_a + (pp_s5q14_b/1000) if pp_s5q14_a!=. | pp_s5q14_b!=.
 foreach crop of global crop {
	gen freekg_`crop'=freeseed_kg * crop_`crop'	
	}	
 
 * purchased seed
 gen purchased_seed=(pp_s5q03==1) if pp_s5q03!=.
 foreach crop of global crop {
	gen purchased_`crop'=purchased_seed * crop_`crop'	
	}	

	gen purchasedseed_kg=pp_s5q05_a + (pp_s5q05_b/1000) if pp_s5q05_a!=. | pp_s5q05_b!=.
 foreach crop of global crop {
	gen purchasedkg_`crop'=purchasedseed_kg * crop_`crop'	
	}	
	
 
 ren crop_name cropname
 collapse (max) crop_* saved_* free_*  purchased_* (sum) savedkg_* freekg_* purchasedkg_* *_kg, by (household_id2)
 
 egen totalseedkg=rowtotal(savedseed_kg freeseed_kg purchasedseed_kg) if savedseed_kg!=. | freeseed_kg!=. | purchasedseed_kg!=.
 gen share_savedkg=(savedseed_kg/totalseedkg) if savedseed_kg!=. & totalseedkg!=.
 gen share_freekg=(freeseed_kg/totalseedkg) if freeseed_kg!=. & totalseedkg!=.
 gen share_purchasedkg=(purchasedseed_kg/totalseedkg) if purchasedseed_kg!=. & totalseedkg!=.

 merge 1:1 household_id2 using "$path1\Ethiopia ESS Wave 3\Final DTA Files\created_data\Ethiopia_ESS_W3_hhids.dta", nogen keep(2 3)
 merge 1:1 household_id2 using "$path2\ETH_W3_purchasedsources.dta", nogen 
 merge 1:1 household_id2 using "$path1\Ethiopia ESS Wave 3\Final DTA Files\created_data\Ethiopia_ESS_W3_farm_area.dta", nogen keep(2 3)
 merge 1:1 household_id2 using "$path1\Ethiopia ESS Wave 3\Final DTA Files\created_data\Ethiopia_ESS_W3_male_head.dta", nogen keep(2 3)
 merge 1:1 household_id2 using "$path1\Ethiopia ESS Wave 3\Final DTA Files\created_data\Ethiopia_ESS_W3_yield_hh_level.dta", nogen 
 ren household_id2 hhid
 gen wave=3
 
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
save "$path2\ETH_W3_seed_sources.dta", replace 
  
 
 


/* ----------------------------------------------------------------------------- *
* 		Part D: Construct wave 4 seed sources variables
* ----------------------------------------------------------------------------- */
 
 
 use  "$path1\Ethiopia ESS Wave 4\Raw DTA Files\sect5_pp_w4.dta", clear
 
    
	gen crop_name=s5q0B
  	gen crop_beans=(crop_name==9 | crop_name==12 | crop_name==13 | crop_name==19) 
	gen crop_peas=(crop_name==11 | crop_name==15)
	gen crop_soybeans=(crop_name==18)
	gen crop_sesame=(crop_name==27)
	gen crop_gnuts=(crop_name==24)
	gen crop_gibto=(crop_name==17)
	gen crop_vetch=(crop_name==16)
	gen crop_sunflower=(crop_name==28)
	gen crop_lentils=(crop_name==14)
	gen crop_lineseed=(crop_name==23)
	
	gen crop_legumes_nuts=(crop_beans==1 | crop_peas==1 | crop_soybeans==1 | crop_sesame==1 | crop_gnuts==1 | crop_gibto==1 | crop_vetch==1 | crop_sunflower==1 | crop_lentils==1 | crop_lineseed==1) 
	
	gen crop_cassava=(crop_name==10)
	gen crop_potato=(crop_name==60 | crop_name==62) 
	gen crop_godere=(crop_name==64)
	gen crop_banana=(crop_name==42 | crop_name==74) 
	
	gen crop_rootstubers=(crop_cassava==1 | crop_potato==1 | crop_godere==1 | crop_banana==1) 
		
	gen crop_sorghum=(crop_name==6)	
	gen crop_maize=(crop_name==2)
	gen crop_millet=(crop_name==3)
	gen crop_rice=(crop_name==5)
	gen crop_teff=(crop_name==7)
	gen crop_wheat=(crop_name==8) 
	gen crop_barley=(crop_name==1) 
	gen crop_oats=(crop_name==4)
	
	gen crop_cereals=(crop_sorghum==1 | crop_maize==1 | crop_millet==1 | crop_rice==1 | crop_teff==1 | crop_wheat==1 | crop_barley==1 | crop_oats==1) 
	
	gen crop_carrot=(crop_name==53)
	gen crop_fennel=(crop_name==20)	
	gen crop_cabbage=(crop_name==52)
	gen crop_tomato=(crop_name==63)
	gen crop_beatroot=(crop_name==51)
	gen crop_ginger=(crop_name==37)	
	gen crop_blackcumin=(crop_name==31)
	gen crop_onion=(crop_name==58)
	gen crop_pepper=(crop_name==34 | crop_name==38 | crop_name==59) 
	gen crop_cardamon=(crop_name==33)
	gen crop_spinach=(crop_name==69)
	gen crop_pineapple=(crop_name==49)
	gen crop_watermelon=(crop_name==83)
	gen crop_cauliflower=(crop_name==54)
	gen crop_cactus=(crop_name==999)
	gen crop_cinnamon=(crop_name==999)
	gen crop_coriander=(crop_name==79) 
	gen crop_fenugreek=(crop_name==36) 
	gen crop_feto=(crop_name==999) 
	gen crop_garlic=(crop_name==55) 
	gen crop_tumeric=(crop_name==39) 
	gen crop_kinem=(crop_name==999) 
	gen crop_pumpkin=(crop_name==61) 
	gen crop_lettuce=(crop_name==57) 
	gen crop_basil=(crop_name==80) 
	gen crop_kale=(crop_name==56) 
	gen crop_mustard=(crop_name==999) 
	gen crop_nueg=(crop_name==25) 
	gen crop_rue=(crop_name==81) 
	gen crop_savory=(crop_name==999) 
	gen crop_strawberry=(crop_name==999)
	
	gen crop_hortcrops=(crop_carrot==1 | crop_fennel==1 | crop_cabbage==1 | crop_tomato==1 | crop_beatroot==1 | crop_ginger==1 | crop_blackcumin==1 | crop_onion==1 | crop_pepper==1 | crop_cardamon==1 | crop_spinach==1 | crop_pineapple==1 | crop_pumpkin==1 | crop_watermelon==1 | crop_cauliflower==1 | crop_cactus==1 | crop_cinnamon==1 | crop_coriander==1 | crop_fenugreek==1 | crop_feto==1 | crop_garlic==1 | crop_tumeric==1 | crop_kinem==1 | crop_lettuce==1 | crop_basil==1 | crop_kale==1 | crop_mustard==1 | crop_nueg==1 | crop_rue==1 | crop_savory==1 | crop_strawberry==1) 
	
	gen crop_cotton=(crop_name==73) 
	gen crop_coffee=(crop_name==72)
	gen crop_sugarcane=(crop_name==76)
	gen crop_tobacco=(crop_name==78)
	gen crop_tea=(crop_name==999)
	gen crop_tropcashcrops=(crop_cotton==1 | crop_coffee==1 | crop_sugarcane==1 | crop_tobacco==1 | crop_tea==1)
	
	gen crop_guava=(crop_name==65)
	gen crop_mango=(crop_name==46)
	gen crop_orange=(crop_name==44 | crop_name==45 | crop_name==47) 
	gen crop_grapes=(crop_name==999)
	gen crop_pawpaw=(crop_name==48)
	gen crop_peach=(crop_name==66)
	gen crop_avocado=(crop_name==84)
	gen crop_apple=(crop_name==41)
	gen crop_gesho=(crop_name==75)
	gen crop_raspseed=(crop_name==26) 
	gen crop_gishita=(crop_name==82) 
	gen crop_kazmir=(crop_name==112) 
	gen crop_shiferaw=(crop_name==114)
	
	gen crop_fruittrees=(crop_guava==1 | crop_mango==1 | crop_orange==1 | crop_grapes==1 | crop_peach==1 | crop_pawpaw==1 |  crop_avocado==1 | crop_apple==1 | crop_gesho==1 | crop_raspseed==1 | crop_gishita==1 | crop_kazmir==1 | crop_shiferaw==1)
	
	global crop beans peas soybeans sesame gnuts gibto vetch sunflower lentils lineseed legumes_nuts cassava potato godere banana rootstubers sorghum maize millet rice teff wheat barley oats cereals carrot fennel cabbage tomato beatroot ginger blackcumin onion pepper cardamon spinach pineapple pumpkin watermelon cauliflower cactus cinnamon coriander fenugreek feto garlic tumeric kinem lettuce basil kale mustard nueg rue savory strawberry hortcrops cotton coffee sugarcane tobacco tea tropcashcrops guava mango orange grapes peach pawpaw avocado apple gesho raspseed gishita kazmir shiferaw fruittrees
	
	global source relative village market govt microf ngo coop 
	
  
 * home saved seeds 
  gen saved_seed=(s5q16==1) if s5q16!=.
 foreach crop of global crop {
	gen saved_`crop'=saved_seed * crop_`crop'	
	}	

ren s5q17 savedseed_kg
 foreach crop of global crop {
	gen savedkg_`crop'=savedseed_kg * crop_`crop'	
	}
	
 * free seeds 
gen free_seed=(s5q12==1) if s5q12!=.
 foreach crop of global crop {
	gen free_`crop'=free_seed * crop_`crop'	
	}
 

 ren s5q13 freeseed_kg
 foreach crop of global crop {
	gen freekg_`crop'=freeseed_kg * crop_`crop'	
	}	
	
	
 * purchased seed
 gen purchased_seed=(s5q02==1) if s5q02!=.
 foreach crop of global crop {
	gen purchased_`crop'=purchased_seed * crop_`crop'	
	}	
 

ren s5q04 purchasedseed_kg
 foreach crop of global crop {
	gen purchasedkg_`crop'=purchasedseed_kg * crop_`crop'	
	}	
	
  * purchased seed sources 
 replace s5q03_1=s5q03_2 if s5q03_1==. & s5q03_2!=.
 
 gen purch_relative=(s5q03_1==7 | s5q03_1==8) if s5q03_1!=.
 gen purch_village=(s5q03_1==11) if s5q03_1!=.
 gen purch_market=(s5q03_1==5 | s5q03_1==6) if s5q03_1!=.
 gen purch_govt=(s5q03_1==3) if s5q03_1!=.
 gen purch_microf=(s5q03_1==999) if s5q03_1!=.
 gen purch_ngo=(s5q03_1==10) if s5q03_1!=.
 gen purch_coop=(s5q03_1==1 | s5q03_1==2 | s5q03_1==4) if s5q03_1!=.
 
 

 foreach crop of global crop {
 	foreach source of global source {
	gen purch_`source'_`crop'=purch_`source' * crop_`crop'	
	}	
 }
 
 
 ren crop_name cropname
 collapse (max) crop_* saved_* free_*  purchased_* purch_* (sum) savedkg_* freekg_* purchasedkg_* *_kg, by (household_id)
 
 egen totalseedkg=rowtotal(savedseed_kg freeseed_kg purchasedseed_kg) if savedseed_kg!=. | freeseed_kg!=. | purchasedseed_kg!=.
 gen share_savedkg=(savedseed_kg/totalseedkg) if savedseed_kg!=. & totalseedkg!=.
 gen share_freekg=(freeseed_kg/totalseedkg) if freeseed_kg!=. & totalseedkg!=.
 gen share_purchasedkg=(purchasedseed_kg/totalseedkg) if purchasedseed_kg!=. & totalseedkg!=.
 
 ren household_id hhid 
 merge 1:1 hhid using "$path1\Ethiopia ESS Wave 4\Final DTA Files\created_data\Ethiopia_ESS_W4_hhids.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path1\Ethiopia ESS Wave 4\Final DTA Files\created_data\Ethiopia_ESS_W4_farm_area.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path1\Ethiopia ESS Wave 4\Final DTA Files\created_data\Ethiopia_ESS_W4_male_head.dta", nogen keep(2 3)
 ren hhid household_id  
 merge 1:1 household_id using "$path1\Ethiopia ESS Wave 4\Final DTA Files\created_data\Ethiopia_ESS_W4_yield_hh_level.dta", nogen 
 ren household_id hhid
destring kebele, gen(keb)
destring ea, gen(eaa)
drop kebele ea
ren keb kebele
ren eaa ea 
 gen wave=4

 
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

	 save "$path2\ETH_W4_seed_sources.dta", replace 
 
 
 
/* ----------------------------------------------------------------------------- *
* 		Part E: Construct wave 5 seed sources variables
* ----------------------------------------------------------------------------- */
 
 use  "$path1\Ethiopia ESS Wave 5\Raw DTA Files\sect5_pp_w5.dta", clear
 
 
  	gen crop_name=s5q0B
  	gen crop_beans=(crop_name==9 | crop_name==12 | crop_name==13 | crop_name==19) 
	gen crop_peas=(crop_name==11 | crop_name==15)
	gen crop_soybeans=(crop_name==18)
	gen crop_sesame=(crop_name==27)
	gen crop_gnuts=(crop_name==24)
	gen crop_gibto=(crop_name==17)
	gen crop_vetch=(crop_name==16)
	gen crop_sunflower=(crop_name==28)
	gen crop_lentils=(crop_name==14)
	gen crop_lineseed=(crop_name==23)
	
	gen crop_legumes_nuts=(crop_beans==1 | crop_peas==1 | crop_soybeans==1 | crop_sesame==1 | crop_gnuts==1 | crop_gibto==1 | crop_vetch==1 | crop_sunflower==1 | crop_lentils==1 | crop_lineseed==1) 
	
	gen crop_cassava=(crop_name==10)
	gen crop_potato=(crop_name==60 | crop_name==62) 
	gen crop_godere=(crop_name==64)
	gen crop_banana=(crop_name==42 | crop_name==74) 
	
	gen crop_rootstubers=(crop_cassava==1 | crop_potato==1 | crop_godere==1 | crop_banana==1) 
		
	gen crop_sorghum=(crop_name==6)	
	gen crop_maize=(crop_name==2)
	gen crop_millet=(crop_name==3)
	gen crop_rice=(crop_name==5)
	gen crop_teff=(crop_name==7)
	gen crop_wheat=(crop_name==8) 
	gen crop_barley=(crop_name==1) 
	gen crop_oats=(crop_name==4)
	
	gen crop_cereals=(crop_sorghum==1 | crop_maize==1 | crop_millet==1 | crop_rice==1 | crop_teff==1 | crop_wheat==1 | crop_barley==1 | crop_oats==1) 
	
	gen crop_carrot=(crop_name==53)
	gen crop_fennel=(crop_name==20)	
	gen crop_cabbage=(crop_name==52)
	gen crop_tomato=(crop_name==63)
	gen crop_beatroot=(crop_name==51)
	gen crop_ginger=(crop_name==37)	
	gen crop_blackcumin=(crop_name==31)
	gen crop_onion=(crop_name==58)
	gen crop_pepper=(crop_name==32 | crop_name==34 | crop_name==38 | crop_name==59) 
	gen crop_cardamon=(crop_name==33)
	gen crop_spinach=(crop_name==69)
	gen crop_pineapple=(crop_name==49)
	gen crop_watermelon=(crop_name==83)
	gen crop_cauliflower=(crop_name==54)
	gen crop_cactus=(crop_name==999)
	gen crop_cinnamon=(crop_name==999)
	gen crop_coriander=(crop_name==79) 
	gen crop_fenugreek=(crop_name==36) 
	gen crop_feto=(crop_name==999) 
	gen crop_garlic=(crop_name==55) 
	gen crop_tumeric=(crop_name==39) 
	gen crop_kinem=(crop_name==999) 
	gen crop_pumpkin=(crop_name==61) 
	gen crop_lettuce=(crop_name==57) 
	gen crop_basil=(crop_name==80) 
	gen crop_kale=(crop_name==56) 
	gen crop_mustard=(crop_name==999) 
	gen crop_nueg=(crop_name==25) 
	gen crop_rue=(crop_name==81) 
	gen crop_savory=(crop_name==999) 
	gen crop_strawberry=(crop_name==113)
	
	gen crop_hortcrops=(crop_carrot==1 | crop_fennel==1 | crop_cabbage==1 | crop_tomato==1 | crop_beatroot==1 | crop_ginger==1 | crop_blackcumin==1 | crop_onion==1 | crop_pepper==1 | crop_cardamon==1 | crop_spinach==1 | crop_pineapple==1 | crop_pumpkin==1 | crop_watermelon==1 | crop_cauliflower==1 | crop_cactus==1 | crop_cinnamon==1 | crop_coriander==1 | crop_fenugreek==1 | crop_feto==1 | crop_garlic==1 | crop_tumeric==1 | crop_kinem==1 | crop_lettuce==1 | crop_basil==1 | crop_kale==1 | crop_mustard==1 | crop_nueg==1 | crop_rue==1 | crop_savory==1 | crop_strawberry==1) 
	
	gen crop_cotton=(crop_name==73) 
	gen crop_coffee=(crop_name==72)
	gen crop_sugarcane=(crop_name==76)
	gen crop_tobacco=(crop_name==78)
	gen crop_tea=(crop_name==999)
	gen crop_tropcashcrops=(crop_cotton==1 | crop_coffee==1 | crop_sugarcane==1 | crop_tobacco==1 | crop_tea==1)
	
	gen crop_guava=(crop_name==65)
	gen crop_mango=(crop_name==46)
	gen crop_orange=(crop_name==44 | crop_name==47 | crop_name==50) 
	gen crop_grapes=(crop_name==999)
	gen crop_pawpaw=(crop_name==48)
	gen crop_peach=(crop_name==66)
	gen crop_avocado=(crop_name==84)
	gen crop_apple=(crop_name==41)
	gen crop_gesho=(crop_name==75)
	gen crop_raspseed=(crop_name==26) 
	gen crop_gishita=(crop_name==82) 
	gen crop_kazmir=(crop_name==112) 
	gen crop_shiferaw=(crop_name==114)
	
	gen crop_fruittrees=(crop_guava==1 | crop_mango==1 | crop_orange==1 | crop_grapes==1 | crop_peach==1 | crop_pawpaw==1 |  crop_avocado==1 | crop_apple==1 | crop_gesho==1 | crop_raspseed==1 | crop_gishita==1 | crop_kazmir==1 | crop_shiferaw==1)
	
	global crop beans peas soybeans sesame gnuts gibto vetch sunflower lentils lineseed legumes_nuts cassava potato godere banana rootstubers sorghum maize millet rice teff wheat barley oats cereals carrot fennel cabbage tomato beatroot ginger blackcumin onion pepper cardamon spinach pineapple pumpkin watermelon cauliflower cactus cinnamon coriander fenugreek feto garlic tumeric kinem lettuce basil kale mustard nueg rue savory strawberry hortcrops cotton coffee sugarcane tobacco tea tropcashcrops guava mango orange grapes peach pawpaw avocado apple gesho raspseed gishita kazmir shiferaw fruittrees
	
	global source relative village market govt microf ngo coop 
	
  
 * home saved seeds 
  gen saved_seed=(s5q16==1) if s5q16!=.
 foreach crop of global crop {
	gen saved_`crop'=saved_seed * crop_`crop'	
	}	

ren s5q17 savedseed_kg
 foreach crop of global crop {
	gen savedkg_`crop'=savedseed_kg * crop_`crop'	
	}	
	
	
 * free seeds 
gen free_seed=(s5q12==1) if s5q12!=.
 foreach crop of global crop {
	gen free_`crop'=free_seed * crop_`crop'	
	}
 

 ren s5q13 freeseed_kg
 foreach crop of global crop {
	gen freekg_`crop'=freeseed_kg * crop_`crop'	
	}	
 
 * purchased seed
 gen purchased_seed=(s5q02==1) if s5q02!=.
 foreach crop of global crop {
	gen purchased_`crop'=purchased_seed * crop_`crop'	
	}	

ren s5q04 purchasedseed_kg
 foreach crop of global crop {
	gen purchasedkg_`crop'=purchasedseed_kg * crop_`crop'	
	}	
	
 
 * purchased seed sources 
 replace s5q03_1=s5q03_2 if s5q03_1==. & s5q03_2!=.
 
 gen purch_relative=(s5q03_1==7 | s5q03_1==8) if s5q03_1!=.
 gen purch_village=(s5q03_1==11) if s5q03_1!=.
 gen purch_market=(s5q03_1==5 | s5q03_1==6) if s5q03_1!=.
 gen purch_govt=(s5q03_1==3) if s5q03_1!=.
 gen purch_microf=(s5q03_1==999) if s5q03_1!=.
 gen purch_ngo=(s5q03_1==10) if s5q03_1!=.
 gen purch_coop=(s5q03_1==1 | s5q03_1==4) if s5q03_1!=.
 
 
 foreach crop of global crop {
 	foreach source of global source {
	gen purch_`source'_`crop'=purch_`source' * crop_`crop'	
	}	
 }
 
 
 ren crop_name cropname
 collapse (max) crop_* saved_* free_*  purchased_* purch_* (sum) savedkg_* freekg_* purchasedkg_* *_kg, by (household_id)
 
 egen totalseedkg=rowtotal(savedseed_kg freeseed_kg purchasedseed_kg) if savedseed_kg!=. | freeseed_kg!=. | purchasedseed_kg!=.
 gen share_savedkg=(savedseed_kg/totalseedkg) if savedseed_kg!=. & totalseedkg!=.
 gen share_freekg=(freeseed_kg/totalseedkg) if freeseed_kg!=. & totalseedkg!=.
 gen share_purchasedkg=(purchasedseed_kg/totalseedkg) if purchasedseed_kg!=. & totalseedkg!=.
  
 ren household_id hhid 
 merge 1:1 hhid using "$path1\Ethiopia ESS Wave 5\Final DTA Files\created_data\Ethiopia_ESS_W5_hhids.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path1\Ethiopia ESS Wave 5\Final DTA Files\created_data\Ethiopia_ESS_W5_farm_area.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path1\Ethiopia ESS Wave 5\Final DTA Files\created_data\Ethiopia_ESS_W5_hhsize.dta", nogen keep(2 3)
 merge 1:1 hhid using "$path1\Ethiopia ESS Wave 5\Final DTA Files\created_data\Ethiopia_ESS_W5_yield_hh_crop_level.dta", nogen 
  
destring zone, gen (zon)
destring woreda, gen(wor)
destring kebele, gen(keb)
destring ea, gen(eaa)
destring city, gen(cit)
destring subcity, gen(subcit)
destring household, gen(househd)
drop zone woreda kebele ea city subcity household 
ren zon zone
ren wor woreda
ren keb kebele
ren eaa ea 
ren cit city
ren subcit subcity
ren househd household

gen wave=5
 
 
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
 
 save "$path2\ETH_W5_seed_sources.dta", replace 
 
 
 
 

/* ----------------------------------------------------------------------------- *
* 		Part F: Construct panel data 
* ----------------------------------------------------------------------------- */

use "$path2\ETH_W1_seed_sources.dta", clear
drop zone woreda subcity kebele ea
append using "$path2\ETH_W2_seed_sources.dta"
drop zone woreda subcity kebele ea household
append using "$path2\ETH_W3_seed_sources.dta"
drop zone woreda subcity kebele ea
append using "$path2\ETH_W4_seed_sources.dta"
drop zone woreda subcity kebele ea
append using "$path2\ETH_W5_seed_sources.dta"
save "$path2\ETH_seed_sources_panel.dta", replace 
drop if hhid==""
sort hhid wave 



/* ----------------------------------------------------------------------------- *
* 		Part G: Generate summary statistics by wave
* ----------------------------------------------------------------------------- */

* directories still need to be reconciled
global crop legumes_nuts rootstubers cereals hortcrops

* Main seed sources and shares used 

foreach num of numlist 1 2 3 4 5 {
estpost su *_seed share_* [aw=weight] if rural==1 & wave==`num'
estimates store ETH_seedsources_`num'
esttab ETH_seedsources_`num' using "C:\Users\pagamile\Desktop\results\ETH_seedsources_`num'.csv", title("Table `num': Seed sources and shares - Wave `num'") cells("count(fmt(0))mean(fmt(3)) sd(fmt(3))") collabels("Obs" "Mean" "SD.") coeflabels (saved_seed "Saved seed" free_seed "Free seed" purchased_seed "Purchased seed" share_savedkg "Share saved" share_freekg "Share free" share_purchasedkg "Share purchased") replace  	
}


* Main seed sources and shares used by gender of household head
foreach num of numlist 1 2 3 4 5 {
	foreach val of numlist 0 1 {
estpost su *_seed share_* [aw=weight] if rural==1 & wave==`num' & fhh==`val'
est store ETH_seedsourcehh_`val'_`num'
esttab ETH_seedsourcehh_`val'_`num' using "C:\Users\pagamile\Desktop\results\ETH_seedsourcehh_`val'_`num'.csv", title("Table `num': Seed sources and shares by gender of household head (`val') - Wave `num'") cells("count(fmt(0))mean(fmt(3)) sd(fmt(3))") collabels("Obs" "Mean" "SD.") coeflabels (saved_seed "Saved seed" free_seed "Free seed" purchased_seed "Purchased seed" share_savedkg "Share saved" share_freekg "Share free" share_purchasedkg "Share purchased") replace  	
}
}


* Main seed sources by crop group 
foreach num of numlist 1 2 3 4 5 {
	foreach crop of global crop {
estpost su *_seed [aw=weight] if rural==1 & wave==`num' & crop_`crop'==1
est store ETH_sdgp_`num'_`crop'
esttab ETH_sdgp_`num'_`crop' using "C:\Users\pagamile\Desktop\results\ETH_sdgp_`num'_`crop'.csv", title("Table `num': Main seed sources of `crop' - Wave `num'") cells("count(fmt(0))mean(fmt(3)) sd(fmt(3))") collabels("Obs" "Mean" "SD.") coeflabels (saved_seed "Saved seed" free_seed "Free seed" purchased_seed "Purchased seed") replace  	
}
}


* Sources of purchased seeds by crop group
foreach num of numlist 1 2 3 4 5 {
	foreach crop of global crop {
estpost su purch_*_`crop' [aw=weight] if rural==1 & wave==`num' & crop_`crop'==1
est store ETH_pcs_`num'_`crop'
esttab ETH_pcs_`num'_`crop' using "C:\Users\pagamile\Desktop\results\ETH_pcs_`num'_`crop'.csv", title("Table `num': Sources of purchased `crop' seeds - Wave `num'") cells("count(fmt(0))mean(fmt(3)) sd(fmt(3))") collabels("Obs" "Mean" "SD.") coeflabels (purch_relative_`crop' "Relative" purch_village_`crop' "Village" purch_market_`crop' "Market" purch_govt_`crop' "Government" purch_microf_`crop' "Microfinance" purch_ngo_`crop' "NGO" purch_coop_`crop' "Cooperative") replace  	
}
}

 
 
 
*----------------------------------------------------------------------------- *
cap log close  
 