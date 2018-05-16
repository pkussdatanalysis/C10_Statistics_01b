# So swirl does not repeat execution of plot commands
AUTO_DETECT_NEWVAR <- FALSE

# Returns TRUE if e$expr matches any of the expressions given
# (as characters) in the argument.
ANY_of_exprs <- function(...){
  e <- get("e", parent.frame())
  any(sapply(c(...), function(expr)omnitest(expr)))
}

equiv_val <- function(correctVal){
  e <- get("e", parent.frame()) 
  #print(paste("User val is ",e$val,"Correct ans is ",correctVal))
  isTRUE(all.equal(correctVal,e$val))
  
}

# Get the swirl state
getState <- function(){
  # Whenever swirl is running, its callback is at the top of its call stack.
  # Swirl's state, named e, is stored in the environment of the callback.
  environment(sys.function(1))$e
}

# Get the value which a user either entered directly or was computed
# by the command he or she entered.
getVal <- function(){
  getState()$val
}

# Get the last expression which the user entered at the R console.
getExpr <- function(){
  getState()$expr
}

post_on_demand <- function(){
  selection <- (environment(sys.function(1))$e)$val
  if(selection == "Yes"){
    student_no <- readline("Please input your student_number:(eg.170121xxxxx)? ")
    sbj=paste(student_no,"C10_07",sep="-")
    send.mail(from = "ayahui3@126.com",
          to = c("datanalysis2018@126.com"),
          subject = sbj,
          body = "Body of the email",
          smtp = list(host.name = "smtp.126.com", port = 25, user.name = "ayahui3", passwd = "920514a11", ssl = TRUE),
          authenticate = TRUE,
          encoding = "utf-8",
          send = TRUE)   
  }
  TRUE
}