ANALYSIS PROCEDURES AND DESIGN
•	The initial step in the analysis is to import the data set into the R-studio where it is filtered to select the literacy records of all participating student across all the schools. 
•	A new data frame is created when the overall score of the individual student is calculated across all respective literacy test is taken. The grades are then assigned based on the calculated overall score of each student.  
•	Another data frame is created by aggregating the number of students across each school that fall under different specified grades. This aggregation does not consider the year in which the test is taken. 
•	Apart from the creation of data frames the students with overall score of zero are assumed to not be present for the test, therefore, this group is accounted for under the “Absent” column.
•	After the data frames got created, the created data frames are exported into an excel document where the percentage of students with RED grade are calculated and appended to the same excel file. 
•	The excel file which is created is imported into the power BI desktop application where further percentage of red “{year}. % Red” is calculated. 
