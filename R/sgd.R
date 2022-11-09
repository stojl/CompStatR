#' Stochastic Gradient Descent
#' @export
#'
SGD <- function(par0,
                 loss_gr,
                 N,
                 batch,
                 epoch,
                 gamma0 = 1,
                 maxit = 15) {
  if(is.numeric(gamma0)) {
    if(length(gamma0) == 1) {
      gamma <- rep(gamma0, maxit)
    } else {
      gamma <- c(gamma0, rep(gamma0[length(gamma0)], maxit - length(gamma0)))
    }
  } else if (is.function(gamma0)) {
    gamma <- gamma0(1:maxit)
  } else {
    stop("gamma0 must be a numeric or a function.")
  }

  .Call("sgd",
        par0,
        loss_gr,
        N,
        batch,
        epoch,
        gamma,
        as.integer(maxit),
        environment())
}
