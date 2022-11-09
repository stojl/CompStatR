#' Density Estimation
#' @export
#'
dens <- function(x,
                 kernel,
                 bandwidth = bw_loocv,
                 ...,
                 points = 512L) {
  if(is.function(bandwidth)) {
    bw <- bandwidth(x, kernel, ...)
  } else {
    bw <- bandwidth
  }
  p <- seq(min(x) - bw, max(x) + bw, length.out = points)
  y <- .Call("C_dens", x, p, kernel, bw, environment())
  structure(
    list(
      x = p,
      y = y,
      bw = bw
    ),
    class = "dens"
  )
}
