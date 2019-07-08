# Huawei-Dorado6000V3-Benchmark


NAME:		TESTRUN1-HOST1-COMPR
TESTRUN: 	1
HOSTS:		1
Devices:	1 to 9
Paralellity:	1 to 10
Compression:	ON
First testrun on HOST1 with compressed LUNs and a parallelity of 1 to 10, because oof an error in the scripts, the results shows only 1 to 9 devices instead of 1 to 10.

NAME:		TESTRUN5-HOST1_3_COMPR
TESTRUN:	5
HOSTS:		1,2,3
Devices:	1 to 10
Paralellity:	1 to 10
Compression:	ON

NAME:		TESTRUN6-HOST1_3-COMPR
TESTRUN: 	6
HOSTS:		1,2,3
Devices:	1 to 10
Paralellity:	1 to 10
Compression:	ON

NAME:		TESTRUN7-HOST1_3-UNCOMPR
TESTRUN: 	7
HOSTS:		1,2,3
Devices:	1 to 10
Paralellity:	1 to 10
Compression:	OFF

NAME:		TESTRUN8-HOST1_4-UNCOMPR-LARGE
TESTRUN: 	8
HOSTS:		1,2,3,4
Devices:	1 to 10
Paralellity:	1,5,10,15,20,30,40,50,75,100
Compression:	OFF

NAME:		TESTRUN9-HOST1_4-COMPR-LARGE
TESTRUN: 	9
HOSTS:		1,2,3,4
Devices:	1 to 10
Paralellity:	1,5,10,15,20,30,40,50,75,100
Compression:	OFF


*/fio-benchmark-output/*.txt 	==> FIO outputfiles
*/LivePerf-View/*.png 		==> Printscreens from the performance console of the Huawei system
				    Not always cotinuois because of disconnecting remote sessionn
*/*TIMESTAMPS.png		==> Timestamp files to match the different timezones
getResults.sh			==> Script to analyze the FIO outputfiles
