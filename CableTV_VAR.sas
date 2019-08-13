LIBNAME _ALL_ CLEAR;

LIBNAME data 'C:/data/';
LIBNAME programs 'C:/programs/';

PROC IMPORT OUT= data.CABLETV_VAR 
            DATAFILE= "C:\data\import.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;


DATA WORK_CABLETV;
SET data.CABLETV_VAR;
RUN;

PROC CONTENTS;
run;


/**** VECTOR AUTOGREGRESSION *****/

proc varmax data=WORK_CABLETV;
id Date interval=daily;
model Biden_MA7 Biden_CABLETV_MA7 /*Biden_Google_MA7*// p=7 lagmax=8 print=(estimates diagnose roots) dify=(1);
run;

proc varmax data=WORK_CABLETV;
model Warren_MA7 Warren_CABLETV_MA7 /*Warren_Google_MA7*// p=7 lagmax=8 print=(estimates diagnose roots) dify=(1);
run;

proc varmax data=WORK_CABLETV;
model Sanders_MA7 Sanders_CABLETV_MA7 /*Sanders_Google_MA7*// p=7 lagmax=8 print=(estimates diagnose roots) dify=(1);
run;

proc varmax data=WORK_CABLETV;
model Harris_MA7 Harris_CABLETV_MA7 /*Harris_Google_MA7*// p=7 lagmax=8 print=(estimates diagnose roots) dify=(1);
run;


proc varmax data=WORK_CABLETV;
model Buttigieg_MA7 Buttigieg_CABLETV_MA7 /*Buttigieg_Google*// p=7 lagmax=8 print=(estimates diagnose roots) dify=(1);
run;


/**** STATIONARITY TEST *****/

PROC ARIMA data=WORK_CABLETV;
 identify var=Biden stationarity=(adf=(7));
identify var=Sanders stationarity=(adf=(7));
identify var=Warren stationarity=(adf=(7));
identify var=Harris stationarity=(adf=(7));
identify var=Buttigieg stationarity=(adf=(7));
run;

PROC ARIMA data=WORK_CABLETV;
 identify var=Biden stationarity=(adf=(2));
identify var=Sanders stationarity=(adf=(2));
identify var=Warren stationarity=(adf=(2));
identify var=Harris stationarity=(adf=(2));
identify var=Buttigieg stationarity=(adf=(2));
run;


proc corr data=WORK_CABLETV;
var Biden Biden_CABLETV Biden_Google Warren Warren_CABLETV Warren_Google Sanders Sanders_CABLETV Sanders_Google;
run;


/***** BOX JENKINS ******/

proc arima data=WORK_CABLETV;

   /*--- Look at the input process ----------------------------*/
   identify var=Biden_CABLETV_MA7(1);
   run;

   /*--- Fit a model for the input ----------------------------*/
   estimate q=7 plot;
   run;

   /*--- Cross-correlation of prewhitened series ---------------*/
   identify var=Biden_MA7(1) crosscorr=(Biden_CABLETV_MA7) nlag=14;
   run;

   /*--- Fit a simple transfer function - look at residuals ---
   estimate input=( 3 $ (1,2)/(1) x );
   run;

   /*--- Final Model - look at residuals ----------------------
   estimate p=2 input=( 3 $ (1,2)/(1) x );
   run; ----*/

quit;

/**** IMPULSE RESPONSE FUNCTIONS ******/

proc varmax data=WORK_CABLETV plot=impulse;
id Date interval=daily;
model Biden_MA7 Biden_CABLETV_MA7 /*Biden_Google_MA7*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) dify=(1);
run;

proc varmax data=WORK_CABLETV plot=impulse;
model Warren_MA7 Warren_CABLETV_MA7 /*Warren_Google_MA7*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) dify=(1);
run;

proc varmax data=WORK_CABLETV plot=impulse;
model Sanders_MA7 Sanders_CABLETV_MA7 /*Sanders_Google_MA7*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) dify=(1);
run;

proc varmax data=WORK_CABLETV plot=impulse;
model Harris_MA7 Harris_CABLETV_MA7 /*Harris_Google_MA7*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) dify=(1);
run;


proc varmax data=WORK_CABLETV plot=impulse;
model Buttigieg_MA7 Buttigieg_CABLETV_MA7 /*Buttigieg_Google*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) dify=(1);
run;


