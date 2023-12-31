% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/2d_effectFunctions_reciprocity.R
\name{reciprocity_min}
\alias{reciprocity_min}
\title{reciprocity_min}
\usage{
reciprocity_min(
  dep.var = 1,
  state,
  cache,
  i,
  j,
  edge,
  update,
  getTargetContribution = FALSE
)
}
\arguments{
\item{dep.var}{}

\item{state}{}

\item{cache}{}

\item{i}{}

\item{j}{}

\item{edge}{}

\item{update}{}

\item{getTargetContribution}{}
}
\value{
Returns the change statistic or target statistic of the effect for
internal use by the estimation algorithm.
}
\description{
Do individuals move to destinations that send more individuals to ego’s origin?
This version of the effect is the minimum of the moves in either direction,
thereby guarding against degeneracy and guaranteeing sample size consistency.
It counts the ‘raw’ number of reciprocated transitions in the mobility network.
}
\keyword{internal}
