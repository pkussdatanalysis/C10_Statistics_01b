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

is_robust_match <- function(expr1, expr2, eval_for_class, eval_env=NULL){
  expr1 <- rmatch_calls(expr1, eval_for_class, eval_env)
  expr2 <- rmatch_calls(expr2, eval_for_class, eval_env)
  isTRUE(all.equal(expr1, expr2))
}

rmatch_calls <- function(expr, eval_for_class=FALSE, eval_env=NULL){
  # If expr is not a call, just return it.
  if(!is.call(expr))return(expr)
  # Replace expr's components with matched versions.
  for(n in 1:length(expr)){
    expr[[n]] <- rmatch_calls(expr[[n]],eval_for_class)
  }
  # If match.fun(expr[[1]]) raises an exception here, the code which follows
  # would be likely to give a misleading result. Catch the error merely to
  # produce a better diagnostic.
  tryCatch(fct <- match.fun(expr[[1]]),
           error=function(e)stop(paste0("Illegal expression ", dprs(expr), 
                                        ": ", dprs(expr[[1]]), " is not a function.\n")))
  # If fct is a special function such as `$`, or builtin such as `+`, return expr.
  if(is.primitive(fct)){
    return(expr)
  }
  # If fct is an (S4) standardGeneric, match.call is likely to give a misleading result,
  # so raise an exception. (Note that builtins were handled earlier.)
  if(is(fct, "standardGeneric")){
    stop(paste0("Illegal expression, ", dprs(expr), ": ", dprs(expr[[1]]), " is a standardGeneric.\n"))
  }
  # At this point, fct should be an ordinary function or an S3 method.
  if(isS3(fct)){
    # If the S3 method's first argument, expr[[2]], is anything but atomic 
    # its class can't be determined here without evaluation.
    if(!is.atomic(expr[[2]]) & !eval_for_class){
      stop(paste0("Illegal expression, ", dprs(expr),": The first argument, ", dprs(expr[[2]]), 
                  ", to S3 method '", dprs(expr[[1]]), 
                  "', is a ", class(expr[[2]]) , ", which (as an expression) is not atomic,",
                  " hence its class can't be determined in an abstract",
                  " syntax tree without additional information.\n"))
    }
    # Otherwise, attempt to find the appropriate method.
    if(is.null(eval_env)){
      eval_env <- new.env()
    } else {
      eval_env <- new.env(parent=eval_env)
    }
    temp <- eval(expr[[2]], envir = eval_env)
    classes <- try(class(temp), silent=TRUE)
    for(cls in classes){
      err <- try(fct <- getS3method(as.character(expr[[1]]), cls), silent=TRUE)
      if(!is(err, "try-error"))break
    }
    # If there was no matching method, attempt to find the default method. If that fails,
    # raise an error
    if(is(err, "try-error")){
      tryCatch(fct <- getS3method(as.character(expr[[1]]), "default"),
               error = function(e)stop(paste0("Illegal expression ", dprs(expr), ": ",
                                              "There is no matching S3 method or default for object, ",
                                              dprs(expr[[2]]), ", of class, ", cls,".\n")))
    }
  }
  # Form preliminary match. If match.call raises an error here, the remaining code is
  # likely to give a misleading result. Catch the error merely to give a better diagnostic.
  tryCatch(expr <- match.call(fct, expr),
           error = function(e)stop(paste0("Illegal expression ", dprs(expr), ": ", 
                                          dprs(expr[[1]]), " is not a function.\n")))
  # Append named formals with default values which are not included
  # in the preliminary match
  fmls <- formals(fct)
  for(n in names(fmls)){
    if(!isTRUE(fmls[[n]] == quote(expr=)) && !(n %in% names(expr[-1]))){
      expr[n] <- fmls[n]
    }
  }
  # match call again, for order
  expr <- match.call(fct, expr)
  return(expr)
}

isS3 <- function(fct)isTRUE(grep("UseMethod", body(fct)) > 0)
dprs <- function(expr)deparse(expr, width.cutoff=500)

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
    sbj=paste(student_no,"C10_06",sep="-")
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