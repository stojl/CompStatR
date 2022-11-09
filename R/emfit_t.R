#' EM Implementation for Fitting Generalized t-Distribution
#' @export
#'
emfit_t <- function(x, nu, maxit = 500L, min.eps = 1e-7, par = NULL) {
  if(is.null(par)) par <- c(stats::median(x), stats::IQR(x))
  par1 <- numeric(2)
  n <- length(x)
  EW <- numeric(n)
  result <- .Call("C_em_t_dist",
                  par0 = par,
                  x = x,
                  nu = nu,
                  maxit = as.integer(maxit),
                  eps = min.eps)
  if(result[[2]] == maxit) warning("Maximum number of itertaions ", maxit, " reached.")
  names(result[[1]]) <- c("mu", "sigma_sq")
  structure(
    list(par = c(result[[1]]),
         iterations = result[[2]],
         nu = nu),
    class = "em_estimate"
  )
}
