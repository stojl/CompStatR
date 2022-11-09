#' Oracle Bandwidth Selection
#' @export
#'
bw_oracle <- function(x, kernel) {
  n <- length(x)
  K <- stats::integrate(function(x) kernel(x)^2, -Inf, Inf)$value
  sigma2 <- stats::integrate(function(x) kernel(x) * x^2, -Inf, Inf)$value
  sigma <- min(stats::sd(x), stats::IQR(x) / 1.34)
  (8 * sqrt(pi) * K / (3 * sigma2^2))^(1/5) * sigma * n^(-1/5)
}

#' LOOCV Bandwidth Selection
#' @export
#'
bw_loocv <- function(x, kernel, max_bw = 2) {
  cv_func <- function(l) .Call("C_loocv", x, kernel, l, environment())
  stats::optimize(cv_func, c(.Machine$double.eps, max_bw))$minimum
}
