#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

extern SEXP C_sgd(SEXP par0, SEXP loss_gr, SEXP N,
                SEXP batch, SEXP epoch,
                SEXP gamma0, SEXP maxit, SEXP rho);

extern SEXP C_adap_samp(SEXP n, SEXP density, SEXP a,
                        SEXP b, SEXP z, SEXP rho);

extern SEXP C_dens(SEXP x, SEXP p, SEXP kernel, SEXP bw, SEXP rho);

extern SEXP C_em_t_dist(SEXP par0, SEXP x, SEXP nu, SEXP maxit, SEXP eps);

extern SEXP C_epoch_batch(SEXP par0, SEXP index, SEXP loss_gr,
                          SEXP gamma, SEXP mbs, SEXP rho);

extern SEXP C_loocv(SEXP x, SEXP fn, SEXP lambda, SEXP rho);

extern SEXP C_newton_raphson(SEXP par0, SEXP H, SEXP gr, SEXP hess,
                             SEXP d, SEXP c, SEXP gamma0,
                             SEXP eps, SEXP maxit, SEXP env);

// REGISTER ROUTINES

static const R_CallMethodDef R_CallDef[] = {
  {"C_sgd", (DL_FUNC) &C_sgd, 8},
  {"C_adap_samp", (DL_FUNC) &C_adap_samp, 6},
  {"C_dens", (DL_FUNC) &C_dens, 5},
  {"C_em_t_dist", (DL_FUNC) &C_em_t_dist, 5},
  {"C_epoch_batch", (DL_FUNC) &C_epoch_batch, 6},
  {"C_loocv", (DL_FUNC) &C_loocv, 4},
  {"C_newton_raphson", (DL_FUNC) &C_newton_raphson, 10},
  {NULL, NULL, 0}
};

void R_init_CompStatR(DllInfo *dll) {
  R_registerRoutines(dll, NULL, R_CallDef, NULL, NULL);
}
