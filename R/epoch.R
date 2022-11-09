#' ADAM Mini Batch Epoch
#' @export
#'
epoch_adam <- function(mini_batch_size = 1, alpha = 0.95, beta = 0.9) {
  rho <- v <- 0
  function(par0, index, loss_gr, gamma) {
    mini_batch_size <- min(length(index), mini_batch_size)
    M <- floor(length(index) / mini_batch_size)
    par <- par0
    for(i in 1:M) {
      mini_batch_index <- ((i - 1) * mini_batch_size + 1):(i * mini_batch_size)
      gr <- loss_gr(par, index[mini_batch_index])
      rho <<- alpha * rho + (1 - alpha) * gr
      v <<- beta * v + (1 - beta) * gr^2
      par <- par - gamma * (rho / (sqrt(v) + 1e-8))
    }
    par
  }
}

#' Mini Batch Epoch with Momentum
#' @export
#'
epoch_momentum <- function(mini_batch_size = 1, beta = 0.95) {
  rho <- 0
  function(par0, index, loss_gr, gamma) {
    mini_batch_size <- min(length(index), mini_batch_size)
    M <- floor(length(index) / mini_batch_size)
    par <- par0
    for(i in 1:M) {
      mini_batch_index <- ((i - 1) * mini_batch_size + 1):(i * mini_batch_size)
      gr <- loss_gr(par, index[mini_batch_index])
      rho <<- beta * rho + (1 - beta) * gr
      par <- par - gamma * rho
    }
    par
  }
}

#' Mini Batch Epoch
#' @export
#'
epoch_batch <- function(mini_batch_size = 1) {
  function(par0, index, loss_gr, gamma0) {
    .Call("epoch_batch",
          par0,
          index,
          loss_gr,
          gamma0,
          as.integer(mini_batch_size),
          environment())
  }
}
# epoch_batch <- function(mini_batch_size = 1) {
#   function(par0, index, loss_gr, gamma) {
#     mini_batch_size <- min(length(index), mini_batch_size)
#     M <- floor(length(index) / mini_batch_size)
#     par <- par0
#     for(i in 1:M) {
#       mini_batch_index <- ((i - 1) * mini_batch_size + 1):(i * mini_batch_size)
#       gr <- loss_gr(par, index[mini_batch_index])
#       par <- par - gamma * gr
#     }
#     par
#   }
# }

#' Batch Epoch
#' @export
#'
epoch_full <- function() {
  function(par0, index, loss_gr, gamma) {
    for(i in 1:length(index)) {
      gr <- loss_gr(par0, index[i])
      par0 <- par0 - gamma * gr
    }
    par0
  }
}

#' Batch Epoch with Momentum
#' @export
#'
epoch_full_momentum <- function(beta = 0.9) {
  rho <- 0
  function(par0, index, loss_gr, gamma) {
    for(i in 1:length(index)) {
      gr <- loss_gr(par0, index[i])
      rho <<- beta * rho + (1 - beta) * gr
      par0 <- par0 - gamma * rho
    }
    par0
  }
}

#' ADAM Batch Epoch
#' @export
#'
epoch_full_adam <- function(alpha = 0.95, beta = 0.9) {
  rho <- v <- 0
  function(par0, index, loss_gr, gamma) {
    for(i in 1:length(i)) {
      gr <- loss_gr(par0, index[i])
      rho <<- alpha * rho + (1 - alpha) * gr
      v <<- beta * v + (1 - beta) * gr^2
      par0 <- par0 - gamma * (rho / (sqrt(v) + 1e-8))
    }
    par0
  }
}
