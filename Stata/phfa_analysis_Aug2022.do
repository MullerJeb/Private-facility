
/*========================================================================================================================================================================================================================/
			*Project Title			: The role of private sector in improving access to FP in Ethiopia.																*
			*Purpose/ Objectives	: To assess the characteristics of FP users from private health sectors over time
			*proposed analysis: These include but not limited to descriptive statistics, measure of inequtiy, decomposition analysis, Multi level Mixed effect logistic regression Modeling, bayesian  Analysis and multivariate decomposition analysis*/
			*Source.raw data	 	: DHS and EPHI has collected five rounds of data  
			*Acknowledgments		: Greatful to BMGF and FMOH and regional health bureaus 
			*Author(s) and Date	started	: Mulusew J Geerbaba, Zelalem Adugna, Ali Kerim (06 April 2022)	
			*Analysis was done by   : Mulusew J Gerbaba  
			*Reviewed by            : Ali Kerim
			*Last updated			: 06.04.2022																								*
			*Affiliation			: HANZ Consultany PLC. and Jimma University
			*Excution instruction:
				*download the "mmasterdata"
				*save it in yor prefered directory (you will use this directory as  global raw data directory)
			*=========================================================================================================================================================================================================================*/
		//seting global directories
		clear all
		set more off,perm

        *set max_memory 16g, permanently
		set maxvar 32767
		capture log close

		*macro drop _all
		
		global raw_data   "data/raw"
		global cleaned_data   "data/clean"
		global analysis "data/analysis"
		global logs  "logs" 
		
		log using "c.smcl", replace
		
		use "C:\Users\HP Folio\Downloads\PHFA_DataSet.dta"
		*Browse|Count|Describe for data insepction 
		br
		desc
		describe, short 
		count  // The sample size = 2549 
		summarize
		
		
			
		** generate individual id
		gen phfaid = _n
		drop instanceID instanceName concent interviewer_Name supervisor_Name FACILITY_NO current_date
	    sort phfaid
		
		x 
		
		tab REGION
		rename REGION region 
		ta region 
		
		gen bweight= 4143/183 if region==3
		replace bweight=1470/160 if region==2
		replace bweight=166/91 if region==4
		replace bweight=167/89 if region==5
		replace bweight=1323/141 if region==6
		replace bweight=161/87 if region==7
		replace bweight=48/41 if region==8
		replace bweight=825/180 if region==9
		replace bweight=56/56 if region==10
        replace bweight=771/127 if region==11
		replace bweight=223/111 if region==12
		
		
		generate rr=202/160 if region==2
		replace rr=240/183 if region==3
		replace rr=91/98 if region==4
		replace rr=27/89 if region==5
		replace rr=162/141 if region==6
		replace rr=79/87 if region==7
		replace rr=32/41 if region==8
		replace rr=225/180 if region==9
		replace rr=50/56 if region==10
		replace rr=119/127 if region==11
		replace rr=119/111 if region==12
		
		gen sweight=bweight*rr
		
		gen fiweight= sweight/1000000
		

		
		ta MANAGING_AUTHORITY 
		
		ta Other_Managing_Authority

		gen manag_authority=.
		replace manag_authority=1 if MANAGING_AUTHORITY==1 | Other_Managing_Authority=="For the worker of the factory not for profit"| Other_Managing_Authority=="It serves the worker of the factory not profit"| Other_Managing_Authority=="Private but not for profit only to serve the worker of the factory"|Other_Managing_Authority=="Private not for profit"|Other_Managing_Authority=="Private not for profit."|Other_Managing_Authority=="NGO profitable"|Other_Managing_Authority=="Membership"
		replace manag_authority=2 if MANAGING_AUTHORITY==2
		replace manag_authority=3 if MANAGING_AUTHORITY==3
		ta manag_authority

		label define manag 1 "NGO/NOT4Profit" 2 "Private4profit" 3 "Mission/FBO" 
		label values manag_authority manag
	    ta manag_authority
	    ta manag_authority [aw=fiweight]
		   
		
        ta RESIDENCE
		rename RESIDENCE residence
		ta residence [iw=fiweight]
		ta residence 
		
		
		** Services availability fp
		ta PHFR_105
		ta PHFR_105 [aw=fiweight]
		
		

		sum PHFR_105_1, detail 
		recode PHFR_105_1(0=1)
		ta PHFR_105_1 
		sum PHFR_105_1, detail 
		
		
		 ta FACILITY_TYPE
		 gen facilitytype=.
		 replace facilitytype=1 if FACILITY_TYPE==1
		 replace facilitytype=2 if FACILITY_TYPE==2
		 replace facilitytype=3 if FACILITY_TYPE==3| FACILITY_TYPE==96
		 replace facilitytype=4 if FACILITY_TYPE==4
		 replace facilitytype=5 if FACILITY_TYPE==5
		 ta facilitytype
		 
         label define typef 1 "Generalhospt" 2 "PrimHosp" 3 "PrimClinic" 4 "MediumClinic" 5 "MCH/Speciality"
		 label values facilitytype typef
	     ta facilitytype 
		 ta facilitytype[aw=fiweight]
		 
		
		 
		 graph pie [aw=sweight] , over(PHFR_105) plabel(_all percent)   

		 graph bar (count), over(PHFR_105) percent  asyvars blabel(bar, position(outside) ///
         format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(5)
		 graph save graph1.gph, replace
		 
		 graph bar (count), over(PHFR_105) over(residence) percent  asyvars blabel(bar, position(outside) ///
         format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(5)
		 graph save graph1.gph, replace
		 
		 graph bar (count), over(PHFR_105) over(region) percent  asyvars blabel(bar, position(outside) ///
         format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(5)
		 graph save graph1.gph, replace
		 
		 graph bar (count), over(PHFR_105) over(facilitytype) percent  asyvars blabel(bar, position(outside) ///
         format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(5)
		 graph save graph1.gph, replace
		 
		 
		 
		 
		 
		 
		*ANC
		tab1 PHFR_106 PHFR_107 PHFR_108 PHFR_109 PHFR_110 PHFR_111 PHFR_112 PHFR_113 PHFR_114 PHFR_115
		
	
		ta PHFR_106 [aw=fiweight]
		ta PHFR_107 [aw=fiweight] 
		ta PHFR_108 [aw=fiweight] 
		ta PHFR_110 [aw=fiweight] 
		ta PHFR_111 [aw=fiweight]
		ta PHFR_112 [aw=fiweight] 
		ta PHFR_113 [aw=fiweight] 
		ta PHFR_114 [aw=fiweight]
		ta PHFR_115 [aw=fiweight]
		
		
		graph bar (count), over(PHFR_106) percent  asyvars blabel(bar, position(outside) ///
        format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(5)
		graph save graph2.gph, replace
		
		graph bar (count), over(PHFR_107) percent  asyvars blabel(bar, position(outside) ///
        format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(5)
		graph save graph3.gph, replace
		
		
		graph bar (count), over(PHFR_108) percent  asyvars blabel(bar, position(outside) ///
        format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(5)
		graph save graph4.gph, replace
		
		graph bar (count), over(PHFR_110) percent  asyvars blabel(bar, position(outside) ///
        format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(5)
		graph save graph5.gph, replace
		
		graph bar (count), over(PHFR_114) percent  asyvars blabel(bar, position(outside) ///
        format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(5)
		graph save graph6.gph, replace
		
		graph bar (count), over(PHFR_115) percent  asyvars blabel(bar, position(outside) ///
        format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(5)
		graph save graph7.gph, replace
		
		graph combine graph1.gph graph2.gph graph3.gph graph4.gph graph5.gph graph6.gph graph7.gph, row(3)

		
		
		graph bar (count), over(PHFR_105) over(manag_authority) percent  asyvars blabel(bar, position(outside) ///
        format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(5)
		graph save graph1.gph, replace
		
	
		
		**Human resources
		*Medical doctor
		tab1 PHFR_201_1 PHFR_201_2 PHFR_201_3
		* Obs and gyne
		tab1 PHFR_202_1 PHFR_202_2 PHFR_202_3
		*pediatrician
		tab1 PHFR_203_1 PHFR_203_2 PHFR_203_3 
		*Nurses
		tab1 PHFR_204_1 PHFR_204_2 PHFR_204_3 
		*Midwifery
		tab1 PHFR_205_1 PHFR_205_2 PHFR_205_3 
		*Health officers
		tab1 PHFR_206_1 PHFR_206_2 PHFR_206_3 
		*Pharmacy tech 
		tab1 PHFR_207_1 PHFR_207_1 PHFR_207_3
		*Lab tech
		tab1 PHFR_208_1 PHFR_208_2 PHFR_208_3 
		*Supporting staff
		tab1 PHFR_209_1 PHFR_209_2 PHFR_209_3
		
		** Services: Basic infrastracture 
		
   tab1 PHFR_301 PHFR_302 PHFR_303 PHFR_304 PHFR_305 PHFR_306 PHFR_307 PHFR_309 PHFR_310 PHFR_311 PHFR_312_1 PHFR_312_2 PHFR_312_3 PHFR_312_4 PHFR_312_4_Other PHFR_312_1_1 PHFR_313 PHFR_313_Other PHFR_314 PHFR_315 PHFR_316 PHFR_316_Other PHFR_317 PHFR_319 PHFR_320 PHFR_321 PHFR_322
   
   recode PHFR_301 (98=1)
   tab PHFR_301 
   ta PHFR_301 [aw=fiweight]
   
   ta PHFR_302
   ta PHFR_302[aw=fiweight]
   
   ta PHFR_303
   ta PHFR_303[aw=fiweight]
   
   ta PHFR_304
   recode PHFR_304 (98=0)
   ta PHFR_304
   ta PHFR_304 [aw=fiweight]
   
   ta PHFR_305
   ta PHFR_305[aw=fiweight]

   ta PHFR_306
   recode PHFR_306 (98=0)
   ta PHFR_306
   ta PHFR_306 [aw=fiweight]
   
   ta PHFR_307
   recode PHFR_307 (98=0)
   ta PHFR_307
   ta PHFR_307 [aw=fiweight]
   
   
   ta PHFR_309
   ta PHFR_309[aw=fiweight]
   
   ta PHFR_310
   recode PHFR_310 (98=0)
   ta PHFR_310
   ta PHFR_310 [aw=fiweight]
   
   ta PHFR_311
   recode PHFR_311 (98=0)
   ta PHFR_311
   ta PHFR_311[aw=fiweight]
   
   ta  PHFR_312_1
   ta PHFR_312_1[aw=fiweight]
   
   ta PHFR_312_3
   recode PHFR_312_3 (98=0)
   ta PHFR_312_3
   ta PHFR_312_3[aw=fiweight]
   
   ta PHFR_313
   
        gen improvedsdr=.
		replace improvedsdr=1 if PHFR_313==1|PHFR_313==2|PHFR_313==3|PHFR_313==5|PHFR_313==7
		replace improvedsdr=0 if PHFR_313==4|PHFR_313==6|PHFR_313==8|PHFR_313==9|PHFR_313==11|PHFR_313==12|PHFR_313==96
		
		label define improveds 1 "improved source" 0 "Unimproved source"
		label value improvedsdr improveds
		
		ta improvedsdr
		ta improvedsdr[aw=fiweight]
		
		ta PHFR_314
		ta PHFR_315
		
		gen improvedsanit=.
		replace improvedsanit=1 if PHFR_315==1|PHFR_315==2|PHFR_315==3
		replace improvedsanit=0 if PHFR_315==4|PHFR_315==7|PHFR_315==8
		
		label define improvedsanit1 1 "Improved sanitation facilities" 0 "Unimproved sanitation facilities"
		label values  improvedsanit improvedsanit1
		ta improvedsanit
		ta improvedsanit[aw=fiweight]
		
		gen consultroom=.
		replace consultroom=1 if PHFR_105_1 ==1|PHFR_105_1==2|PHFR_105_1==3|PHFR_105_1==4|PHFR_105_1==5|PHFR_105_1==5|PHFR_105_1==6|PHFR_105_1==7|PHFR_105_1==8|PHFR_105_1==9 
        replace consultroom=0 if PHFR_105==0
		ta consultroom
		ta consultroom[aw=fiweight]
		
		gen allitem=.
		replace allitem=1 if consultroom==1 & improvedsanit==1 & improvedsdr==1 & PHFR_311==1 & PHFR_306==1 & PHFR_305==1 &  PHFR_304==1 &  PHFR_302==1
		replace allitem=0 if allitem==.
		ta allitem[aw=fiweight]
		
		egen global_score =rowtotal(consultroom improvedsanit improvedsdr PHFR_311 PHFR_306 PHFR_305 PHFR_304 PHFR_302 )
		replace global_score = global_score/8 * 100
		sum global_score
		sum global_score[aw=fiweight]	
		
		graph bar (mean) global_score , over(facilitytype) blabel(bar, position(outside) ///
        format(%3.0f)) ylabel(none) yscale(r(0,80))  
		graph save graph1.gph, replace
		
   **waste management 
   tab1  PHFR_401 PHFR_401_Other PHFR_402 PHFR_403 PHFR_403_Other PHFR_404 PHFR_405 PHFR_406
   
   **Health information systems 
		tab1 PHFR_1001 PHFR_1002_1 PHFR_1002_2 PHFR_1002_3 PHFR_1002_4 
		tab1 PHFR_1004 PHFR_1005 PHFR_1006 PHFR_1006_1 PHFR_1007_1 PHFR_1007_2 PHFR_1007_3 PHFR_1007_4 PHFR_1007_5 PHFR_1007_6 PHFR_1008 PHFR_1009_1 PHFR_1009_2 PHFR_1009_3 PHFR_1009_4 PHFR_1009_5 PHFR_1010 
	
		
	recode PHFR_1001 PHFR_1004 PHFR_1006  PHFR_1006_1   (98=0)
	ta PHFR_1001
	ta PHFR_1001[aw=fiweight]
		
	tab1 PHFR_1002_1 PHFR_1002_2 PHFR_1002_3 
	recode PHFR_1002_2 (98=0)
	ta PHFR_1002_1[aw=fiweight]
	ta PHFR_1002_2[aw=fiweight]
	ta PHFR_1002_3[aw=fiweight]
	
	recode PHFR_1010 (98=0) (96=0)
	ta PHFR_1010[aw=fiweight]
	
		graph pie, over(PHFR_1001)
		
		graph pie [aw=fiweight], over(PHFR_1001) plabel(_all percent)

		graph bar (count), over(PHFR_1005) percent  asyvars blabel(bar, position(outside) ///
        format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(5)
		graph save graph1.gph, replace 
		
		
		tab1 PHFR_1011_1 PHFR_1011_1_Parttime PHFR_1011_2 PHFR_1011_2_Parttime PHFR_1011_3 PHFR_1011_3_Parttime PHFR_1011_4 PHFR_1011_4_Partime PHFR_1011_5 PHFR_1011_5_Partime PHFR_1011_6 PHFR_1011_6_Partime PHFR_1011_7 PHFR_1011_7_Partime PHFR_1011_8 PHFR_1011_8_Partime PHFR_1012
		
	**FP services 
		
		tab1 PHFR_501_1 PHFR_501_2 PHFR_501_3 PHFR_501_4 PHFR_501_5 PHFR_501_6 PHFR_501_7 PHFR_501_8 PHFR_501_9 PHFR_501_10 PHFR_501_11 PHFR_501_12
		
		ta PHFR_501_1 [aw=fiweight]
		ta PHFR_501_2 [aw=fiweight]
		ta PHFR_501_3 [aw=fiweight]
		ta PHFR_501_4 [aw=fiweight]
		ta PHFR_501_5 [aw=fiweight]
		ta PHFR_501_6 [aw=fiweight]
		ta PHFR_501_7 [aw=fiweight]
		ta PHFR_501_8 [aw=fiweight]
		ta PHFR_501_9 [aw=fiweight]
		ta PHFR_501_10 [aw=fiweight]
		ta PHFR_501_11 [aw=fiweight]
		ta PHFR_501_12 [aw=fiweight]

		tab1 PHFR_502 PHFR_503 PHFR_504_1 PHFR_504_2 PHFR_504_3 PHFR_504_4 PHFR_504_5 PHFR_504_6 PHFR_504_7 PHFR_505 PHFR_506 PHFR_507 
		tab1 PHFR_508 PHFR_509 PHFR_510 PHFR_511 PHFR_512 
		
		ta PHFR_502  
		
		ta PHFR_503 [aw=fiweight]
		ta PHFR_504_1 [aw=fiweight]
		ta PHFR_504_2 [aw=fiweight]
		ta PHFR_504_3 [aw=fiweight]
		ta PHFR_504_4 [aw=fiweight] 
		ta PHFR_504_5 [aw=fiweight]
		ta PHFR_504_6 [aw=fiweight]
		ta PHFR_504_7 [aw=fiweight]
		
	   gen FPtrain=.
	   replace FPtrain=0 if PHFR_512==0| PHFR_512==98
	   replace FPtrain=1 if  PHFR_512 ==1
	   ta FPtrain
	   
	   ta FPtrain [aw=fiweight]
	   
	    graph bar (count), over(FPtrain) over(region) percent  asyvars blabel(bar, position(outside) ///
        format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(5)
		graph save graph1.gph, replace 
	   
	   
	   
	   
		graph pie [aw=fiweight], over(PHFR_503) plabel(_all percent) 
		
		tab1 PHFR_1014_1 PHFR_1014_2 PHFR_1014_3 PHFR_1014_4 PHFR_1014_5 PHFR_1014_6 PHFR_1014_7 PHFR_1014_8 PHFR_1014_9 PHFR_1014_10 
		
		**Services integration 
		
		tab1 PHFR_513_1 PHFR_513_2 PHFR_513_3 PHFR_513_4 PHFR_513_5 PHFR_513_6 PHFR_514_1 PHFR_514_2 PHFR_514_3 PHFR_514_4 PHFR_514_5 PHFR_514_6 PHFR_515_1 PHFR_515_2 PHFR_515_3 PHFR_515_4 PHFR_515_5 PHFR_515_6 PHFR_516_1 PHFR_516_2 PHFR_516_3 PHFR_516_4 PHFR_516_5 PHFR_517_1 PHFR_517_2 PHFR_517_3 PHFR_517_4 PHFR_517_Other
		
	**Supplies and Equipment
		tab1 PHFR_600_1 PHFR_600_2 PHFR_600_3 PHFR_600_4 PHFR_600_5 PHFR_600_6 PHFR_600_7 PHFR_600_8 PHFR_600_9 PHFR_600_10 PHFR_600_11 PHFR_600_12 PHFR_600_13 PHFR_600_14 PHFR_600_15 PHFR_600_16 PHFR_600_17 PHFR_600_18 PHFR_600_19 PHFR_600_20 PHFR_600_21 PHFR_600_22 PHFR_600_23 PHFR_600_24 PHFR_600_25 PHFR_600_26 PHFR_600_27 PHFR_600_29 PHFR_600_30 PHFR_600_31 PHFR_600_32 PHFR_600_33 PHFR_600_34 PHFR_600_35 PHFR_600_36 PHFR_600_37 PHFR_600_38 PHFR_600_39 PHFR_600_40
		
		
		gen bp=.
		replace bp=1 if PHFR_600_17==1|PHFR_600_17 ==2
		replace bp=0 if PHFR_600_17 ==3
		
		gen fpguide=.
		replace fpguide=1 if PHFR_600_40==1|PHFR_600_40 ==2
		replace fpguide=0 if PHFR_600_40==3
		tab fpguide
		
		graph pie [aw=fiweight], over(PHFR_600_40) plabel(_all percent) 
		
		
	* basic equipments
	tab1 PHFR_600_15   PHFR_600_16  PHFR_600_17 PHFR_600_19 PHFR_600_20  PHFR_600_39  
	foreach var of varlist PHFR_600_15 PHFR_600_16  PHFR_600_17 PHFR_600_19 PHFR_600_20  PHFR_600_39 {
	recode `var' (2=3)
	tab1 `var'[aw=fiweight]
	egen g_score=rowtotal(`var')
	replace g_score = g_score/6*100
	sum g_score[aw=fiweight]
	}
		
	**Standard precaution
	
	tab1 PHFR_600_1 PHFR_600_2 PHFR_600_3 PHFR_600_4 PHFR_600_5 PHFR_600_6 PHFR_600_7 PHFR_600_8 PHFR_600_9 PHFR_600_10 PHFR_600_11 PHFR_600_12 PHFR_600_13 PHFR_600_14 PHFR_600_32                        
	foreach x of varlist PHFR_600_1 PHFR_600_2 PHFR_600_3 PHFR_600_4 PHFR_600_5 PHFR_600_6 PHFR_600_7 PHFR_600_8 PHFR_600_9 PHFR_600_10 PHFR_600_11 PHFR_600_12 PHFR_600_13 PHFR_600_14 PHFR_600_32{
		recode `x' (3=2)
		tab1 `x'[aw=fiweight] 
	} 
	
	*Reproductive healt commodities 
		tab1 PHFR_701_1 PHFR_701_2 PHFR_701_3 PHFR_701_4 PHFR_701_5 PHFR_701_6  PHFR_701_7 PHFR_701_8 PHFR_701_9 PHFR_701_10 PHFR_702 PHFR_703 PHFR_703_2 PHFR_703_2_Other PHFR_704 PHFR_704_2 PHFR_704_2_Other PHFR_705 PHFR_705_2 PHFR_705_2_Other PHFR_706 PHFR_706_2 PHFR_706_2_Other PHFR_707 PHFR_707_2 PHFR_707_2_Other PHFR_708 PHFR_708_2 PHFR_708_2_Other PHFR_709 PHFR_709_2 PHFR_709_2_Other PHFR_710 PHFR_710_2 PHFR_710_2_Other 
		
		graph bar (count), over( PHFR_701_1) percent  asyvars blabel(bar, position(outside) ///
        format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(5)
		graph save graph1.gph, replace 
		
		graph pie [aw=fiweight], over(PHFR_701_1) plabel(_all percent)
		graph pie [aw=fiweight], over(PHFR_701_2) plabel(_all percent)
		graph pie [aw=fiweight], over(PHFR_701_3) plabel(_all percent)
		graph pie [aw=fiweight], over(PHFR_701_4) plabel(_all percent)
		graph pie [aw=fiweight], over(PHFR_701_5) plabel(_all percent)
        graph pie [aw=fiweight], over(PHFR_701_6) plabel(_all percent)
		graph pie [aw=fiweight], over(PHFR_701_7) plabel(_all percent)
		graph pie [aw=fiweight], over(PHFR_701_8) plabel(_all percent)

	 
	 
	   *FP service user fee
	tab1 PHFR_801_1 PHFR_801_1_cost PHFR_801_2 PHFR_801_2_cost PHFR_801_3 PHFR_801_3_cost PHFR_801_4 PHFR_801_4_cost PHFR_801_5 PHFR_801_5_cost PHFR_801_6 PHFR_801_6_cost PHFR_801_7 PHFR_801_7_cost PHFR_801_8 PHFR_801_8_cost PHFR_801_9 PHFR_801_9_cost PHFR_801_10 PHFR_801_10_cost PHFR_801_11 PHFR_801_11_cost PHFR_801_12 PHFR_801_12_cost PHFR_801_13 PHFR_801_13_cost PHFR_802 
	
	**Facility statistics 
	tab1 PHFR_901 PHFR_902 PHFR_903 PHFR_904 PHFR_906 PHFR_907 PHFR_908 PHFR_909 
	
	**Number of units sold 
	tab1 PHFR_910_1 PHFR_910_2 PHFR_910_3 PHFR_910_4 PHFR_910_5 PHFR_910_6 PHFR_910_7 PHFR_910_8 PHFR_910_9 PHFR_910_10 PHFR_910_10 PHFR_910_11 
	
	tab1 PHFR_1013 PHFR_1013_Year PHFR_1013_Month PHFR_1013_Day 
	
	*supervision within six months
	ta PHFR_1015 
	recode PHFR_1015 (8=1) (7=1) (10=1) (12=1) (22=2) (23=2) (30=3) (33=3) (5555=5)
	sum PHFR_1015 , d 
	ta PHFR_1015
	graph box PHFR_1015, box(1,bcolor(dkorange)) graphregion(color(white)) 
	graph box PHFR_1015, over(manag_authority) 
	
	gen superv=. 
	replace superv=1 if PHFR_1015==1|PHFR_1015==2|PHFR_1015==3|PHFR_1015==4|PHFR_1015==5|PHFR_1015==6
	replace superv=0 if PHFR_1015==0
	ta superv [aw=fiweight]
	
	*profession background
	ta PHFR_1016 
	recode PHFR_1016 (6=8)
	ta  PHFR_1016
	
	ta  PHFR_1017
	gen age = PHFR_1017
	recode age(20/24=1) (25/29=2) (30/34=3) (35/39=4) (40/44=5) (45/49=5) (50/max=6) 
	
	* age of 
	*Gender provider
	ta PHFR_1018
		
***Readiness score
            gen phfrscore= FPtrain + fpguide+bp + PHFR_501_1 + PHFR_501_3 + PHFR_501_5 +  PHFR_501_7 + PHFR_501_8 + PHFR_501_10 
			
			factor FPtrain fpguide bp PHFR_501_1 PHFR_501_3 PHFR_501_5 PHFR_501_7 PHFR_501_8 PHFR_501_10, pcf
			
			predict phfscoref1
			sum phfscoref1, d
			sum phfscoref1, d
			hist phfscoref1, norm freq 
			
			graph box phfrscore, over(manag_authority)
			graph box phfscoref1, over(facilitytype) over(residence)
			
			*Kernel density	
			kdensity phfscoref1 if region == 1 , addplot(kdensity phfscoref1 if region == 2 || kdensity phfscoref1 if region == 3) ///
			legend(ring(0) pos(2) label(1 "Oromia") label(2 "Amhara") label(3 "SNNPR"))

			
			ttest phfscoref1, by(residence )  
			ttest phfscoref1, by(residence) unequal unpaired 
			
			
	**Quality of FP care 
	
	tab1 PHFR_106 PHFR_107 PHFR_108 PHFR_109 PHFR_110 PHFR_114 PHFR_115 PHFR_301 PHFR_302 PHFR_304 PHFR_305 PHFR_311 improvedsdr improvedsanit consultroom PHFR_1001 PHFR_1010 FPtrain PHFR_501_7 PHFR_501_8 PHFR_501_10 PHFR_501_1 PHFR_501_3 PHFR_501_5 PHFR_503 bp fpguide  PHFR_600_19  PHFR_600_20  PHFR_600_39 superv
			factor PHFR_106 PHFR_107 PHFR_108 PHFR_109 PHFR_110 PHFR_114 PHFR_115 PHFR_301 PHFR_302 PHFR_304 PHFR_305 PHFR_311 improvedsdr improvedsanit consultroom PHFR_1001 PHFR_1010 FPtrain PHFR_501_7 PHFR_501_8 PHFR_501_10 PHFR_501_1 PHFR_501_3 PHFR_501_5 PHFR_503 bp fpguide  PHFR_600_19  PHFR_600_20  PHFR_600_39 superv, pcf
			predict qualfpscore
			sum qualfpscore, d
			hist qualfpscore, norm freq
			graph box qualfpscore, over(manag_authority)
			graph box qualfpscore, over(residence)
			graph box qualfpscore, over(region)
			graph box qualfpscore, over(facilitytype)
			graph box qualfpscore, over(facilitytype) over(residence)
			
			*Kernel density	
			kdensity qualfpscore if region== 1 , addplot(kdensity qualfpscore if region == 2 || kdensity qualfpscore if region == 3) ///
			legend(ring(0) pos(2) label(1 "Oromia") label(2 "Amhara") label(3 "SNNPR"))

			

		