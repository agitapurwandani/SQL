EDWIN_V.FACT_OCS					EDWIN_V.FACT_OCS_POST
	|									/
	|								   /
	|								  /
	|								 /															EDWIN_V.FACT_RECH(SERVED_MOBILE_NUMBER) --> data recharge isi ulang pulsa
	|								/
	|		_______________________/					
	| 	   /
    V      V
SANDBOX.PRICEPLAN_REFF(PROVIDER_ID)	-- Brand					   SANDBOX.PRODUCTLINE_REFF (L1,L2,L3)





ANALYTIC_V.PATTERN_HLR(PREFIX)							




ANALYTIC.VDIM_REGION(CGI,CGIOCS) --> lacci pricing						SANDBOX.LACCI(CGI,CGIPOST)--> lacci sales


	   inner join SANDBOX.PRICEPLAN_REFF spri on spri.PROVIDER_ID =  efo.PROVIDER_ID
   	   inner join SANDBOX.PRODUCTLINE_REFF spro on efo.L1 = spro.L1
   	   inner join EDWIN_V.FACT_RECH efr on efr.SERVED_MOBILE_NUMBER = efo.SERVED_MOBILE_NUMBER
   	   inner join ANALYTIC.VDIM_REGION avr on avr.CGIOCS = efo.CGI
where upper(spri.BRAND) = 'SIMPATI'
     and upper(spro.SERVICE_TYPE_NAME) = 'VOICE'
     and efo.DURATION >= 60
     and efr.NOMINAL >= 10000
     and avr.reg_name = 'JAWA BARAT'
union all 
select efo.SERVED_MOBILE_NUMBER
   from EDWIN_V.FACT_OCS_POST efo
   	   inner join SANDBOX.PRICEPLAN_REFF spri on spri.PROVIDER_ID =  efo.PROVIDER_ID
   	   inner join SANDBOX.PRODUCTLINE_REFF spro on efo.L1 = spro.L1
   	   inner join EDWIN_V.FACT_RECH efr on efr.SERVED_MOBILE_NUMBER = efo.SERVED_MOBILE_NUMBER
   	   inner join ANALYTIC.VDIM_REGION avr on avr.CGIOCS = efo.CGI
where upper(spri.BRAND) = 'SIMPATI'
     and upper(spro.SERVICE_TYPE_NAME) = 'VOICE'
     and efo.DURATION >= 60
     and efr.NOMINAL >= 10000
     and avr.reg_name = 'JAWA BARAT'

2. 

select efo.SERVED_MOBILE_NUMBER
from EDWIN_V.FACT_OCS efo
	 inner join SANDBOX.PRICEPLAN_REFF spri on spri.PROVIDER_ID = efo.PROVIDER_ID
	 inner join (select efr.SERVED_MOBILE_NUMBER 
	 	 				, month(efr.RECHARGE_DATE) as bulan
	 	 				, year(efr.RECHARGE_DATE) as tahun 
	 	 				, sum(NOMINAL) as jumlah
	 				from EDWIN_V.FACT_RECH efr
	 				group by  efr.SERVED_MOBILE_NUMBER  , month(efr.RECHARGE_DATE) , year(efr.RECHARGE_DATE)
	 			) tabR on tabR.SERVED_MOBILE_NUMBER = efo.SERVED_MOBILE_NUMBER
	 inner join SANDBOX.LACCI sl on sl.CGIPOST = efo.CGI
where (spri.PRICEPLAN = 'KartuAs Ekstra Ampuh' or spri.PRICEPLAN = 'KartuHALO New Halofit 1')
	and efo.L2 = 150 and efo.L3=1650
	and tabR.jumlah >= 100000
	and sl.kab_name = 'DEPOK'
union all 
select efo.SERVED_MOBILE_NUMBER
from EDWIN_V.FACT_OCS_POST efo
	 inner join SANDBOX.PRICEPLAN_REFF spri on spri.PROVIDER_ID = efo.PROVIDER_ID
	 inner join (select efr.SERVED_MOBILE_NUMBER 
	 	 				, month(efr.RECHARGE_DATE) as bulan
	 	 				, year(efr.RECHARGE_DATE) as tahun 
	 	 				, sum(NOMINAL) as jumlah
	 				from EDWIN_V.FACT_RECH efr
	 				group by  efr.SERVED_MOBILE_NUMBER  , month(efr.RECHARGE_DATE) , year(efr.RECHARGE_DATE)
	 			) tabR on tabR.SERVED_MOBILE_NUMBER = efo.SERVED_MOBILE_NUMBER
	 inner join SANDBOX.LACCI sl on sl.CGIPOST = efo.CGI
where (spri.PRICEPLAN = 'KartuAs Ekstra Ampuh' or spri.PRICEPLAN = 'KartuHALO New Halofit 1')
	and efo.L2 = 150 and efo.L3=1650
	and tabR.jumlah >= 100000
	and sl.kab_name = 'DEPOK'

3. 

select efo.SERVED_MOBILE_NUMBER
from EDWIN_V.FACT_OCS efo
	 inner join SANDBOX.PRICEPLAN_REFF spri on spri.PROVIDER_ID = efo.PROVIDER_ID
	 inner join EDWIN_V.FACT_RECH efr on efr.SERVED_MOBILE_NUMBER = efo.SERVED_MOBILE_NUMBER
where spri.PRICEPLAN = 'simPATI Time Based'
	and efo.VOLUME = 134217730 -- (asumsi volume byte biner)
	and efr.NOMINAL >= 25000
	and ( substring(efo.SERVED_MOBILE_NUMBER,3,7) = '8530253') or substring(efo.SERVED_MOBILE_NUMBER,3,6) = '852893') -- HRL reg Jabotabek
	and efo.L1 not in (1,2)
union all 
select efo.SERVED_MOBILE_NUMBER
from EDWIN_V.FACT_OCS_POST efo
	 inner join SANDBOX.PRICEPLAN_REFF spri on spri.PROVIDER_ID = efo.PROVIDER_ID
	 inner join EDWIN_V.FACT_RECH efr on efr.SERVED_MOBILE_NUMBER = efo.SERVED_MOBILE_NUMBER
where spri.PRICEPLAN = 'simPATI Time Based'
	and efo.VOLUME = 134217730 -- (asumsi volume byte biner)
	and efr.NOMINAL >= 25000
	and ( substring(efo.SERVED_MOBILE_NUMBER,3,7) = '8530253') or substring(efo.SERVED_MOBILE_NUMBER,3,6) = '852893') -- HRL reg Jabotabek
	and efo.L1 not in (1,2)

4. 
select efo.SERVED_MOBILE_NUMBER
from EDWIN_V.FACT_OCS efo
	inner join SANDBOX.PRICEPLAN_REFF spri on spri.PROVIDER_ID = efo.PROVIDER_ID
	inner join ANALYTIC.VDIM_REGION avr on avr.CGIOCS = efo.CGI
where spri.BRAND = 'KartuAs'
	and efo.L1 =  1
	and (avr.REGION = 'PUMA')
union all 
select efo.SERVED_MOBILE_NUMBER
from EDWIN_V.FACT_OCS_POST efo
	inner join SANDBOX.PRICEPLAN_REFF spri on spri.PROVIDER_ID = efo.PROVIDER_ID
	inner join ANALYTIC.VDIM_REGION avr on avr.CGIOCS = efo.CGI
where spri.BRAND = 'KartuAs'
	and efo.L1 =  1
	and (avr.REGION = 'PUMA')
