% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/2e_effectFunctions_transitivity.R
\name{transitivity_netflow}
\alias{transitivity_netflow}
\title{transitivity_netflow}
\usage{
transitivity_netflow(
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
Do individuals move in one direction in locally ordered triads? E.g., is there
a local hierarchy that individuals follow when moving between locations? The
effect is sample size consistent.
}
\keyword{internal}
