library(pROC)
### Summary function
summary.bic.glm.pauc<- function (object, n.models = 5, digits = max(3, getOption("digits") - 
                                                                      3), conditional = FALSE, display.dropped = FALSE, ...) 
{
  x <- object
  cat("\nCall:\n", deparse(x$call), "\n\n", sep = "")
  if (display.dropped & x$reduced) {
    cat("\nThe following variables were dropped prior to averaging:\n")
    cat(x$dropped)
    cat("\n")
  }
  n.models <- min(n.models, x$n.models)
  sel <- 1:n.models
  cat("\n ", length(x$postprob), " models were selected")
  cat("\n Best ", n.models, " models (cumulative posterior probability = ", 
      round(sum(x$postprob[sel]), digits), "): \n\n")
  x$namesx <- c("Intercept", x$namesx)
  nms <- length(x$namesx)
  ncx <- length(unlist(x$assign))
  nvar <- rep(0, times = n.models)
  for (i in 1:(nms - 1)) nvar <- nvar + as.numeric(as.vector(rbind(rep(1, 
                                                                       length(x$assign[[i + 1]]))) %*% (t(x$mle[sel, x$assign[[i + 
                                                                                                                                 1]], drop = FALSE] != 0)) > 0))
  modelposts <- format(round(x$postprob[sel], 3), digits = 3)
  coeffs <- t(x$mle[sel, , drop = FALSE])
  cfbic <- rbind(x$bic[sel], coeffs)
  cfbicf <- format(cfbic, digits = digits)
  coeffsf <- cfbicf[-1, , drop = FALSE]
  bic <- cfbicf[1, , drop = FALSE]
  cfpauc <- rbind(x$pauc[sel], coeffs)
  cfpauc <- format(cfpauc, digits = digits)
  coeffsf <- cfpauc[-1, , drop = FALSE]
  pauc <- cfpauc[1, , drop = FALSE]
  
  # cfprior <- rbind(x$prior[sel], coeffs)
  # cfprior <- format(cfprior, digits = digits)
  # coeffsf <- cfprior[-1, , drop = FALSE]
  # prior <- cfprior[1, , drop = FALSE]
  
  postmeans <- format(x$postmean, digits = digits)
  postsds <- format(x$postsd, digits = digits)
  postmeans[is.na(x$postmean)] <- ""
  postsds[is.na(x$postsd)] <- ""
  if (conditional) {
    cpostmeans <- format(x$condpostmean, digits = digits)
    cpostsds <- format(x$condpostsd, digits = digits)
    cpostmeans[is.na(x$condpostmean)] <- ""
    cpostsds[is.na(x$condpostsd)] <- ""
  }
  varposts <- format(round(x$probne0, 1), digits = 3)
  strlength <- nchar(coeffsf[1, 1])
  decpos <- nchar(unlist(strsplit(coeffsf[2, 1], "\\."))[1])
  offset <- paste(rep(" ", times = decpos - 1), sep = "", collapse = "")
  offset2 <- paste(rep(" ", times = decpos + 1), sep = "", 
                   collapse = "")
  modelposts <- paste(offset, modelposts, sep = "")
  nvar <- paste(offset2, nvar, sep = "")
  dotoffset <- round(max(nchar(coeffsf))/2)
  zerocoefstring <- paste(paste(rep(" ", times = dotoffset), 
                                collapse = "", sep = ""), ".", sep = "")
  coeffsf[coeffs == 0] <- zerocoefstring
  coeffsf[is.na(coeffs)] <- ""
  avp <- NULL
  outnames <- c(NA, x$output.names)
  names(outnames)[1] <- "Intercept"
  varposts <- c("100", varposts)
  for (i in 1:nms) {
    avp <- rbind(avp, varposts[i])
    if (!is.na(outnames[[i]][1])) 
      avp <- rbind(avp, cbind(rep("", times = length(x$assign[[i]]))))
  }
  top <- cbind(postmeans, postsds)
  if (conditional) 
    top <- cbind(top, cpostmeans, cpostsds)
  top <- cbind(top, coeffsf)
  atop <- NULL
  for (i in 1:nms) {
    if (!is.na(outnames[[i]][1])) 
      atop <- rbind(atop, rbind(rep("", times = ncol(top))))
    atop <- rbind(atop, top[x$assign[[i]], ])
  }
  top <- cbind(avp, atop)
  linesep <- rep("", times = ncol(top))
  offset <- c("", "", "")
  if (conditional) 
    offset <- c(offset, c("", ""))
  
  c.hat=as.numeric(t(x$postmean[-1]%*%t(x$x))/sum(x$postmean[-1]))
  glm.out <- glm(x$y~c.hat, family = "binomial")
  test_prob = predict(glm.out, type = "response")
  test_roc = pROC::roc(x$y ~ test_prob, plot = FALSE, print.auc = FALSE,
                       levels = c(1,0) , direction = ">")
  pauc0=as.numeric(pROC::auc(test_roc, partial.auc=c(1, 2/3), partial.auc.focus="se",
                             partial.auc.correct=TRUE))
  
  bottom <- rbind(c(offset, nvar), c(offset, bic), c(c("", pauc0, ""), pauc), c(offset, 
                                                                                         modelposts))
  out <- rbind(top, linesep, bottom)
  vnames <- NULL
  for (i in 1:nms) {
    vnames <- c(vnames, names(outnames[i]))
    blnk <- paste(rep(" ", times = nchar(names(outnames[i]))), 
                  collapse = "")
    if (!is.na(outnames[i][1])) 
      vnames <- c(vnames, paste(blnk, unlist(outnames[i])[-1], 
                                sep = "."))
  }
  row.names(out) <- c(vnames, "", "nVar", "BIC", "PAUC" ,"post prob")
  colnms <- c("p!=0", " EV", "SD")
  if (conditional) 
    colnms <- c(colnms, "cond EV", "cond SD")
  colnms <- c(colnms, paste("model ", 1:n.models, sep = ""))
  dimnames(out)[[2]] <- colnms
  print.default(out, print.gap = 2, quote = FALSE, ...)
}