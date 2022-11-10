#include <R.h>
#include <Rinternals.h>

double static dist(double x1, double x2, double y1, double y2) {
  double x_sq = x1 * x1 + x2 * x2;
  double y_sq = y1 * y1 + y2 * y2;
  double xy = x1 * y1 + x2 * y2;
  return sqrt(x_sq + y_sq - 2 * xy);
}

SEXP C_em_t_dist(SEXP par0,
                 SEXP x,
                 SEXP nu,
                 SEXP maxit,
                 SEXP eps) {
  int n = length(x);
  double *x_ = REAL(x), par[2], par1[2], eps_ = REAL(eps)[0], nu_ = REAL(nu)[0];
  double *EW = (double *)malloc(sizeof(double) * n);
  int maxit_ = INTEGER(maxit)[0];

  par[0] = REAL(par0)[0], par[1] = REAL(par0)[0];
  int i;
  for(i = 0; i < maxit_; ++i) {
    double S1 = 0, S2 = 0, S3 = 0;
    for(int j = 0; j < n; ++j) {
      EW[j] = (nu_ + 1) /
        (1 + (x_[j] * x_[j] + par[0] * par[0] - 2 * par[0] * x_[j]) /
          (nu_ * par[1]));
      S1 += EW[j];
      S2 += EW[j] * x_[j];
      S3 += EW[j] * x_[j] * x_[j];
    }
    par1[0] = S2 / S1;
    par1[1] = (S3 + par1[0] * par1[0] * S1 - 2 * par1[0] * S2) / (n * nu_);
    double norm_new = dist(par[0], par[1], par1[0], par1[1]);
    double norm_old = sqrt(par1[0] * par1[0] + par1[1] * par1[1]);
    if(norm_new < eps_ * (norm_old + eps_)) break;
    par[0] = par1[0];
    par[1] = par1[1];
  }
  if(i != maxit_) i += 1;
  free(EW);
  SEXP result = PROTECT(allocVector(VECSXP, 2));
  SEXP par_res = allocVector(REALSXP, 2);
  REAL(par_res)[0] = par1[0], REAL(par_res)[1] = par1[1];
  SET_VECTOR_ELT(result, 0, par_res);
  SET_VECTOR_ELT(result, 1, ScalarReal(i));
  UNPROTECT(1);
  return result;
}
