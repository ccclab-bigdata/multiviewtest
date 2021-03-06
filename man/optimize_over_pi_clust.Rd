% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/optimize_over_pi_clust.R
\name{optimize_over_pi_clust}
\alias{optimize_over_pi_clust}
\title{Pseudo likelihood ratio test for independence of clusterings}
\usage{
optimize_over_pi_clust(logphi1, logphi2, row, col, maxiter = 1000,
  stepsize = 0.01, Pi = NULL)
}
\arguments{
\item{logphi1}{log(phi1), where the n x K1 matrix phi1 is defined in equation 2.9}

\item{logphi2}{log(phi1), where the n x K2 matrix phi2 is defined in equation 2.9
use for the permutation procedure. The default number is 200.}

\item{row}{K1-vector containing the estimated mixture component probabilities on view 1}

\item{col}{K2-vector containing the estimated mixture component probabilities on view 2}

\item{maxiter}{Maximum number of iterations to run. The default maximum is 1000.}

\item{stepsize}{Fixed step size to be used in the optimization. See Supplement B of
"Are Clusterings of Multiple Data Views Independent?" for details.}

\item{Pi}{An optional initial value for the optimization algorithm. The default
value is matrix(1, K1, K2).}
}
\value{
A list containing the following output components:
\item{Pi.est}{The maximizer}
\item{obj}{The objective value.}
}
\description{
Implements the optimization algorithm for solving equation 2.8)
in Section 2.3.2 of "Are Clusterings of Multiple Data Views Independent?"
}
\examples{
library(mclust)
set.seed(1)
n <- 50
sig <- 2
p <- 2
K <- 3
mu1 <- cbind(c(2, 0), c(0, 2),  c(2, -2), c(-2, 0), c(0, -2), c(-2, 2))
mu2 <- cbind(c(-2, 0), c(0, -2), c(-2, 2), c(2, 0), c(0, 2), c(2, -2))
# Generate two-view data where the clusters are identical, 
# so Pi = I/3.
cl <- sample(1:K, n, replace=TRUE)
x <- list(matrix(sig* rnorm(n*p), n, p) + t(mu1)[cl, ],
matrix(sig * rnorm(n*p), n, p) + t(mu2)[cl, ])

# Clusters each view
EM.View1 <- Mclust(x[[1]], G=3, modelNames=c("EII"))
EM.View2 <- Mclust(x[[2]], G=3, modelNames=c("EII"))

# Constructs phi1 and phi2 matrices
logphi1 <-  cdens("EII", x[[1]], logarithm=TRUE, EM.View1$parameters)
logphi2 <-  cdens("EII", x[[2]], logarithm=TRUE, EM.View2$parameters)

pi1.est <- EM.View1$parameters$pro
pi2.est <- EM.View2$parameters$pro 

# Solves equation 2.8
Pi.est <- optimize_over_pi_clust(logphi1, logphi2,
 pi1.est, pi2.est, step=0.001)
 Pi.est$Pi


}
\references{
Gao, L.L., Bien, J., Witten, D. (2018) Are Clusterings of Multiple Data Views Independent?
submitted to Biostatistics.
}
