% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/2a_effectFunctions_exogenous.R
\name{dyadic_covariate_resource_attribute}
\alias{dyadic_covariate_resource_attribute}
\title{dyadic_covariate_resource_attribute}
\usage{
dyadic_covariate_resource_attribute(
  dep.var = 1,
  attribute.index,
  resource.attribute.index,
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

\item{attribute.index}{}

\item{resource.attribute.index}{}

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
Is mobility between locations predicted by the dyadic covariate u weighted by
the individual covariate w? E.g., is mobility of women more likely between
organisations that are in the same region? Note that this effect can be used
to also model the interaction between the ‘same covariate’/‘covariate similarity’
effect and individual attributes, since sameness and similarity between locations
can be translated into dyadic covariates.
}
\keyword{internal}
