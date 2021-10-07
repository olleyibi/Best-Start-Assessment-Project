
## Clear Working Environment
rm(list=ls())


## Import Required Library
suppressMessages(library(readxl))
suppressMessages(library(tidyr))
suppressMessages(library(dplyr))
suppressMessages(library(ggplot2))


## Import Dataset
data = read_excel('C:/Users/olley/Downloads/Best Start K Data Extract.xlsx')


## Filter Literacy Data
data = data[which(data$Subject=='Literacy'),]
data = data[order(data$StudentIndex),] # Order Data by student Index


## Create Function to add grade Classes
l_grade = function(x){
  grade = vector()
  m = 1
  for (i in x){
    if (i >= 90){grade[m]="Green"}
    else if (i>=80){grade[m]="Grey"}
    else if (i>=70){grade[m]="Yellow"}
    else if (i == 0) {grade[m]="Absent"}
    else {grade[m]="Red"}
    m=m+1
  }
  return(grade)
}


## Get the overall score of individual students accross the schools
studentLearning_cumm=col=schoolName=LNAPStatus=Year=overall_score=vector()
m=0
for (i in unique(data$StudentIndex)){
  studentData = data[which(data$StudentIndex==i),c(-1,-3,-6)]
  learn_cumm=studentData[,c(3,5)]%>%group_by(`Key Learning Area`)%>%
    summarise_each(funs(sum))
  
  studentLearning_cumm=cbind(studentLearning_cumm,learn_cumm$Score)
  
  m=m+1
  col[m]=i
  schoolName[m]=as.character(data[which(data$StudentIndex==i)[1],1])
  LNAPStatus[m]=as.character(data[which(data$StudentIndex==i)[1],7])
  Year[m]=as.integer(data[which(data$StudentIndex==i)[1],3])
  overall_score[m] = sum(learn_cumm$Score)
}

# Rename row_names
row.names(studentLearning_cumm)=sort(unique(data$`Key Learning Area`))  
colnames(studentLearning_cumm)=col  # Rename colnames
studentLearning_cumm=data.frame(t(studentLearning_cumm)) # Transpose
studentLearning_cumm = data.frame(cbind(school = schoolName,LNAPStatus,
                                        StudentIndex = col,
                                        Year,studentLearning_cumm,overall_score))


## Apply grade class to overall scores
studentLearning_cumm$Grade = l_grade(studentLearning_cumm$overall_score)


## Extract grade distribution across all schools
mat = data.frame(matrix(0,nrow = 21,ncol=6))
colnames(mat) = c("School","Absent" ,"Green",  "Grey"  , "Red"  ,  "Yellow")
m=1
for (i in unique(studentLearning_cumm$school)){
  cut = studentLearning_cumm[which(studentLearning_cumm$school==i),]
  cut_count = data.frame(t(tapply(cut$school,as.factor(cut$Grade),length)))
  for (j in colnames(cut_count)){
    mat[[j]][m] = cut_count[[j]]
  }
  mat[m,1] = i
  mat$Total[m] = sum(cut_count)
  m=m+1
}


# Create function to Extract grade distribution across all schools by year
yr_dt = function(yr){
  yrdt=studentLearning_cumm[which(studentLearning_cumm$Year==yr,),]
  yr_mat = data.frame(matrix(0,nrow = 21,ncol=6))
  #  colnames(yr_mat) = c("School","Green",  "Grey"  , "Red"  ,  "Yellow")
  colnames(yr_mat) = c("School","Absent" ,"Green",  "Grey"  , "Red"  ,  "Yellow")
  m=1
  for (i in unique(yrdt$school)){
    yr_cut = yrdt[which(yrdt$school==i),]
    yr_cut_count = data.frame(t(tapply(yr_cut$school,as.factor(yr_cut$Grade),
                                       length)))
    for (j in colnames(yr_cut_count)){
      yr_mat[[j]][m] = yr_cut_count[[j]]
    }
    yr_mat[m,1]=i
    yr_mat$Total[m]=sum(yr_cut_count)
    m=m+1
  }
  return(yr_mat)
}


# Apply extraction funcction
comp2019 = yr_dt(2019)
comp2020 = yr_dt(2020)
comp2021 = yr_dt(2021)



# write dataframe to excel file
sheets <- list('2019'=comp2019,'2020'=comp2020,'2021'=comp2021,'Total'=mat)
write_xlsx(sheets,"C:/Users/olley/Downloads/SchoolFile.xlsx")
