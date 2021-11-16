* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * *   WEEK  1   * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
/* select comment and then ctrl+slash
copy and paste - ctrl+v
Additional options for the output formats - Click the More application options icon on the
banner, and then select Preferences > Results to view the options. 

row - observation, record
column - varibale, field 	*/



* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * *   WEEK  2   * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;

/* Give General Information */
proc contents data="path/filename"; 
run;

/* Use library to Read SAS Data - libname libref engine "path";  */
options validvarname=v7; *naming conversions for sas; 
libname mylib xlsx "path/filename.xlsx";
proc contents data=mylib.tablename;
run;
libname mylib clear;

/* Import Unstructured Data from external source */
proc import datafile="path/filename" dbms=filetype out=output_table_name 
			<replace>; *if the file already exists;
	<guessingrows=N|MAX;> *guess column attributs;
	<sheet=sheetname; *if import xlsx file;>
run;



* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * *   WEEK  3   * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;

/* list first n rows */
proc print data=mylib.tablename (firstobs=1 obs=n); 
	var columnname1 columnname2; *only list these columns, hold ctrl, choose columns and drag;
run;

/* calculate summary statistics */
proc means data=mylib.tablename (obs=n); 
	var colname1 colname2; *only list these columns, hold ctrl, choose columns and drag;
run;

/* examine extreme values */
proc univariate data=mylib.tablename (obs=n); 
	var colname1 colname2; *only list these columns, hold ctrl, choose columns and drag;
run;

/* list frequncies */
proc freq data=mylib.tablename (obs=n); 
	tables colname1 colname2; *only list these columns, hold ctrl, choose columns and drag;
run;

/* where statement - select specific columns to rows*/
	where colname="name1" or colname="name2";
	where colname not in ("name1", "name2");
	where colname is not missing; * colname=. or colname=" ";
	where colname is null;
	where colname between value1 and value2; * including;
	where colname like 'A_ %'; *Aa apple, Ab bear;
	* EQ =, NE ^= ~=, GT >, LT <, >= GE, <= LE;
	* compare date: date > "1jan2015"d
	
/* macro variable */
%let name=value; *no qutation markers;
*when use in code; "&name"

/* Formatting Data (change style of data) */
	format colname formatsyntax;
/* 	formatsyntax = <$:character format>format-name<total-width>.<number of decimals> */
* common formats: dollar10.2, comma8.1;
* date7., date9., mmddyy10., ddmmyy8., monyy7., monname., weekdate.;


/* Sort Data */
proc sort data=input-table <out=output-table>; *if not use out, sort original table;
	by <descending> col-names; * default - ascending;
run;

/* Remove Duplicates */
proc sort data=input-table <out=output-table> 
		  nodupkey <dupout=output-table2>; 
	by _all_; * remove all the duplicates according to by colname;
	*or by colname;
run;
	
	
	
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * *   WEEK  4   * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;

/* Read a sas table and create a subset as a new sas table */
data output-name;
	set input-name;
	where condition;
	new-col = value;
	format col-name name;
	keep col-name;
	drop col-name;	
run;

/* common sed functions */
/* range,n,nmiss */
/* upcase,lowcase,propcase,cats,substr(str,position,length) */
/* day(sas-date),month(sas-date),year(sas-date),weekday(sas-date),qtr(sas-date) */
/* today(),mdy(month,day,year),yrdif(startdate, enddate, "age") */

/* if statement */
if a>1 then a= ;
else if a=1 then a=0;
else a=-1;

if a>1 then do;
	a=1;
	b=1;
end;
else do;
	a=0;
	b=0;
end;

/* length statement */
length char-column $ length-num;


* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * *   WEEK  5   * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;

/* titles */
title<n> "text"; *add titles, up tp 10 line;
footnote<n> "text";
/* these two are global; use the below to clear titles and footnotes; */
title; footnote;
ods noproctitle; *turn off procedure titles;
ods proctitle; *turn on;
	label col-name="text"; *add a new column called label to table;
/* exception - proc print: replace rather than new column */ 
proc print data=path label; label col-name="text"; run;

/* Segment reports */
* sort the table first by the name col-name;
proc freq data="";
	by col-name;
run;

/* frequence reports */
ods graphics on;
proc freq data=path order=freq nlevels noprint;
	tables col-name / nocum plots=freqplot(orient=horizontal scale=percent) out=new-name;
run;

/* two-way frequency reports */
proc freq data=path;
	tables col-name1*col-name2 / norow nocol nopercent crosslist list;
run;

/* mean reports */
proc means data=path <stat-list>; *<min max median maxdec=0>;
	var col-name1; *specify which columns;
	class col-name2; *data is calculated for each col in class;
	* for each col2, calculate col1;
	ways n; *one table has n class;
run;

	output out=output-table <statistics=col-name>;



* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * *   WEEK  6   * * * * * * * * * * * * * * * * * * * *;
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;

/* Exporting Data */
proc export data=table-name outfile="path/file" <dbms=identifier> <replace>;
run;

ods excel file="filename.xlsx" style=style options(sheet_name="label");
/* code */
ods excel close;

/* powerpoint - pptx */
/* csvall - csv */

ods rtf file="fiel.rtf" startpage=no;
/* codes */
ods rtf close;

ods pdf file="path/file.pdf" style=style startpage=no pdftoc=n; *bookmark number;
ods proclabel "label"; *bookmark name;
/* codes */
ods pdf close; 

/* SQL Syntax */
proc sql;
    select col-name1, col-name2 as aaa format=bbb 
/*     if want to select all, use *  */
	from c
	where c
	order by col-name desc;
quit;

	from table1  as alias1 inner join table2 as alias2
	on table1.column=table2.column