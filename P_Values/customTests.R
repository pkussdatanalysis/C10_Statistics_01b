# Put custom tests in this file.
      
      # Uncommenting the following line of code will disable
      # auto-detection of new variables and thus prevent swirl from
      # executing every command twice, which can slow things down.
      
      # AUTO_DETECT_NEWVAR <- FALSE
      
      # However, this means that you should detect user-created
      # variables when appropriate. The answer test, creates_new_var()
      # can be used for for the purpose, but it also re-evaluates the
      # expression which the user entered, so care must be taken.
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
    sbj=paste(student_no,"C10_08",sep="-")
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