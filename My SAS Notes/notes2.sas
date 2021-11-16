* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * *   WEEK  1   * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;

/* View execution in the log */
putlog _all_;
putlog column-name=;
putlog "message";

/* explicit output */
output;

data output1(drop=col-name)
	 output2(keep=col-name);
	set input;
run;

if something then output col-name;



* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * *   WEEK  2   * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;

/* Retaining values in the PDV */
	retain col-name <initial-value>;
	
/* Using sum statement */
	col-name + col2; 
	*equivalent;
	retain col-name;
	col-name=sum(col-name, col2); *ignore missing values, set initial value to 0;

/* Subsetting rows */
data storm2017_max;
	set storm2017_sort;
	by Basin; *order;
	if first.Basin=1; *first appearance, another is last;
	StormLength=EndDate-StartDate;
run;



* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * *   WEEK  3   * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;

/* column list */
	Mean=mean(of Quiz1-Quiz5); *col1-coln;
	/* Name Prefix: all columns that begin with the specified character string */ 
	Mean=mean(of Q:);
	format col--col 3.1; *double dash, not need of;

/* call functions */
	call function-name(argument);
	
/* some common functions */
largest(n, of col1-coln); *nth largest among col1 to coln;
rand('integer', 10, 99); *a random integer between 10 and 99;
round(num, .1); 
ceil(num);
floor(num);
int(num); *returns the ingeter part of the number;
datepart(datetime-value);
timepart(datetime-value);
intck('weekday', start-date, end-date, <method>); *interval between, default is discrete method, edning each Saturaday;
intnx('week', start-date, increment, <alignment>); *same, middle, end;
compbl(string);	*Returns a character string with all multiple blanks in the source string converted to single blanks.;
COMPRESS(string, <characters>); *Returns a character string with specified characters removed from the source string.;
STRIP(string);	*Returns a character string with leading and trailing blanks removed.;
scan(string, nth-to-extract, ','); *extract strings;
find(str,substr,<modifier>); *return start-position, 'I'-case insensitive, 'T'-trim leading and trailing blanks;
LENGTH(string);	*Returns the length of a non-blank character string, excluding trailing blanks; returns 1 for a completely blank string;
ANYDIGIT(string); *Returns the first position at which a digit is found in the string;
ANYALPHA(string); *Returns the first position at which an alpha character is found in the string;
ANYPUNCT(string); *Returns the first position at which punctuation character is found in the string;
tranwrd(source, target, replacement);
CAT(string1, ... stringn); *Concatenates strings together, does not remove leading or trailing blanks;
CATS(string1, ... stringn); *Concatenates strings together, removes leading or trailing blanks from each string;
CATX('delimiter', string1, ... stringn); *Concatenates strings together, removes leading or trailing blanks from each string, and inserts the delimiter between each string;
input(source, format); *character to numeric;
put(source, format); *numeric to character;


* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * *   WEEK  4   * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;

/* formats */
comma12.	dollar8.2		monyy7.		year4.		dat9.

/* create your own format */
proc format;
	value $charformat 'old', 'abc'='new'
					  'old2'='new2'
					  other='new3';
	value numformat low='a'; *1-2: [1,2] 1<-<2: (1,2);
run;

/* use input table to create format */
data work.newtable;
	retain FmtName '$fmt';
	set path.old-table(rename=(old=Start old2=End old3=Label));
	keep FmtName Start End Label;
run;
proc format cntlin=work.newtable;
run;

/* library=pg2.myfmt library=pg2 lib=pg2 *by default, name is pg2.formats; */
options fmtsearch=(pg2.myfmts sashelp);



* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * *   WEEK  5   * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;

/* Concatenating tables with matching columns */
data output-dable;
	set input-table1 input-table2;
run;

/* Mergeing tables */
data output-dable;
	merge input-table1 input-table2;
	by col-name; *sorted column;
run;

/* Mergeing tables with matching columns*/
data class2;
    merge pg2.class1(in=inUpdate) 
          pg2.class1(in=inTeachers);
    by name;
run; 

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * *   WEEK  6   * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;

/* loop */
do index-col = 1 to 3 by 1;
	code;
	output;
end; *increment here;

/* conditional */
do until|while (condition);
	codes;
end; *until-check at the bottom, while-check at the top;

/* combine loop and conditional */
do index-col = 1 to 3 until|while (condition);
end; *until-check coniditon then increment at the bottom, while-c top i bottom



* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * *   WEEK  7   * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;

/* restructure data tables */
data class_wide;
	set class_narrow;
	by Name;
	retain Name Math Reading;
	if TestSubject="Math" then Math=TestScore;
	else if TestSubject="Reading" then Reading=TestScore;
run;

data class_narrow;
	set class_wide;
	CampType='Tent';
	CampCount=Tent;
	output;
	CampType='RV';
	CampCount=RV;
	output;
	CampType='Backcountry';
	CampCount=Backcountry;
	output;
run;

proc transpose data=input out=output; *narrow to wide;
	var c;
	id c;
	by c;
run;

proc transpose data=input out=output name=index prefix=value; *wide to narrow;
	by c;
	var c;
run;