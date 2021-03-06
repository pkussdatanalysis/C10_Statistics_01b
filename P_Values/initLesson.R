# Put initialization code in this file.
library(ggplot2)

# For compatibility with 2.2.21
.get_course_path <- function(){
  tryCatch(swirl:::swirl_courses_dir(),
           error = function(c) {file.path(find.package("swirl"),"Courses")}
  )
}

#get correct paths for plotting
pathtofile <- function(fileName){
  mypath <- file.path(.get_course_path(),
  	"C10_Statistics_01b","P_Values",
                      fileName)
}
fxfer <- function(fileName){
  mypath <- pathtofile(fileName)
  file.copy(mypath,fileName)
  fileName
}
#fname <- paste(getwd(),"C10_Statistics_01b/Hypothesis_Testing/father_son.csv",sep="/")
fname <- pathtofile("father_son.csv")
fs <- read.csv(fname)
quants <- c(-1:7)
mybin <- pbinom(quants,size=8,p=.5,lower.tail=FALSE)
