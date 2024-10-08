########## effectFunctions: effects concerning endogenous mechanisms linked to covariates


#' crowding_out_prop_covar_bin
#' 
#' Is the tendency to stay in vs. move out of a location of individuals of type 
#' non-w dependent on the proportion of individuals of type w moving into the location? 
#' This is especially geared towards modelling how some locations become more or 
#' less attractive dependent on the change in composition for
#' particular groups. This models segregation dynamics.
#' 
#' @param dep.var 
#' @param resource.attribute.index 
#' @param state 
#' @param cache 
#' @param i 
#' @param j 
#' @param edge 
#' @param update 
#' @param getTargetContribution 
#'
#' 
#' @return Returns the change statistic or target statistic of the effect for 
#' internal use by the estimation algorithm.
#' @keywords internal
crowding_out_prop_covar_bin <-
  function(dep.var = 1,
           resource.attribute.index,
           state,
           cache,
           i,
           j,
           edge,
           update,
           getTargetContribution = FALSE) {
    # proportion needs binary coding with only 0 and 1
    if (!all(state[[resource.attribute.index]]$data %in% c(0, 1))) {
      stop("effect crowding_out_prop_covar_bin only defined for binary covariates coded 0 1")
    }
    
    # get the target contribution
    if (getTargetContribution) {
      # if a dyad not on the diagonal is checked, return 0
      if (i != j) {
        return(0)
      }
      
      # get the diagonal value
      loops <-
        cache[[dep.var]]$valuedNetwork[i, j] - cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][i, j]
      
      # get the proportion of X'ers that move in to the node
      # if nobody comes in, the prop equals 0.5
      if ((sum(cache[[dep.var]]$valuedNetwork[, j]) - cache[[dep.var]]$valuedNetwork[i, j]) == 0) {
        prop <- 0.5
      } else {
        prop <-
          (sum(cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][, j]) -
             cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][i, j]) /
          (sum(cache[[dep.var]]$valuedNetwork[, j]) - cache[[dep.var]]$valuedNetwork[i, j])
      }
      
      return(loops * prop)
    }
    
    # get the change statistics
    # change statistics depends on either a new loop that is changed
    # or on the inflow proportion that the target node has
    # both need to know the proportion before
    
    if ((sum(cache[[dep.var]]$valuedNetwork[, j]) - cache[[dep.var]]$valuedNetwork[j, j]) == 0) {
      propBefore <- 0.5
    } else {
      propBefore <-
        (sum(cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][, j]) -
           cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][j, j]) /
        (sum(cache[[dep.var]]$valuedNetwork[, j]) - cache[[dep.var]]$valuedNetwork[j, j])
    }
    
    # first if a loop is formed
    if (i == j) {
      # if the res is of attribute == 1, then there are no change stats
      if (state[[resource.attribute.index]]$data[edge] == 1) {
        return(0)
      }
      # if the res attribute == 0, the change stat is the proportion
      return(propBefore * update)
    }
    
    # now if no loop is formed and the proportion changes
    # number of loops of type 0 people in target occ
    loops <-
      cache[[dep.var]]$valuedNetwork[j, j] - cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][j, j]
    
    # if the last one leaves, the proportion after becomes 0
    
    if (((sum(cache[[dep.var]]$valuedNetwork[, j]) + update) - cache[[dep.var]]$valuedNetwork[j, j]) == 0) {
      propAfter <- 0.5
    } else {
      propAfter <-
        ((sum(cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][, j]) +
            update * state[[resource.attribute.index]]$data[edge]) -
           cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][j, j]) /
        ((sum(cache[[dep.var]]$valuedNetwork[, j]) + update) - cache[[dep.var]]$valuedNetwork[j, j])
    }
    
    change <- propAfter - propBefore
    return(change * loops)
  }



#' staying_by_prop_bin_inflow
#' 
#' Is the tendency to stay in vs. move out of a location dependent on the proportion 
#' of individuals of type w that enter the location? This is especially geared 
#' towards modelling how some locations become more or less
#' attractive dependent on the change in composition.
#'
#' @param dep.var 
#' @param resource.attribute.index 
#' @param state 
#' @param cache 
#' @param i 
#' @param j 
#' @param edge 
#' @param update 
#' @param getTargetContribution 
#'
#' 
#' @return Returns the change statistic or target statistic of the effect for 
#' internal use by the estimation algorithm.
#' @keywords internal
staying_by_prop_bin_inflow <-
  function(dep.var = 1,
           resource.attribute.index,
           state,
           cache,
           i,
           j,
           edge,
           update,
           getTargetContribution = FALSE) {
    # proportion needs binary coding with only 0 and 1
    if (!all(state[[resource.attribute.index]]$data %in% c(0, 1))) {
      stop("effect staying_by_prop_bin_inflow only defined for binary covariates coded 0 1")
    }
    
    # get the target contribution
    if (getTargetContribution) {
      # if a dyad not on the diagonal is checked, return 0
      if (i != j) {
        return(0)
      }
      
      # get the diagonal value, i.e. the amount of people that stay here
      loops <- cache[[dep.var]]$valuedNetwork[i, j]
      
      # get the proportion of X'ers that move in to the node
      # if nobody comes in, the prop equals 0.5
      if ((sum(cache[[dep.var]]$valuedNetwork[, j]) - cache[[dep.var]]$valuedNetwork[j, j]) == 0) {
        prop <- 0.5
      } else {
        prop <-
          (sum(cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][, j]) -
             cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][j, j]) /
          (sum(cache[[dep.var]]$valuedNetwork[, j]) - cache[[dep.var]]$valuedNetwork[j, j])
      }
      
      return(loops * prop)
    }
    
    # get the change statistics
    # change statistics depends on either a new loop that is changed
    # or on the inflow proportion that the target node has
    # both need to know the proportion before
    
    if ((sum(cache[[dep.var]]$valuedNetwork[, j]) - cache[[dep.var]]$valuedNetwork[j, j]) == 0) {
      propBefore <- 0.5
    } else {
      propBefore <-
        (sum(cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][, j]) -
           cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][j, j]) /
        (sum(cache[[dep.var]]$valuedNetwork[, j]) - cache[[dep.var]]$valuedNetwork[j, j])
    }
    
    # first if a loop is formed
    if (i == j) {
      # the change stat is the proportion of res with attribute that move in
      return(propBefore * update)
    }
    
    # now if no loop is formed and the proportion changes
    # number of loops in target occ
    loops <- cache[[dep.var]]$valuedNetwork[j, j]
    
    # if the last one leaves, the proportion after becomes 0.5
    
    if (((sum(cache[[dep.var]]$valuedNetwork[, j]) + update) - cache[[dep.var]]$valuedNetwork[j, j]) == 0) {
      propAfter <- 0.5
    } else {
      propAfter <-
        ((sum(cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][, j]) +
            update * state[[resource.attribute.index]]$data[edge]) -
           cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][j, j]) /
        ((sum(cache[[dep.var]]$valuedNetwork[, j]) + update) - cache[[dep.var]]$valuedNetwork[j, j])
    }
    
    change <- propAfter - propBefore
    return(change * loops)
  }




#' joining_similar_avoiding_dissimilar_covar_bin
#' 
#' Do individuals with the same attribute tend to use the same paths and 
#' individuals with different attributes to move to different places? 
#' This statistic gives a positive contribution to all pairs of individuals
#' with the same (binary) covariate who use the same path and a negative one
#' to pairs of dissimilar individuals following the same path.
#' 
#' @param dep.var 
#' @param resource.attribute.index 
#' @param state 
#' @param cache 
#' @param i 
#' @param j 
#' @param edge 
#' @param update 
#' @param getTargetContribution 
#'
#' @return Returns the change statistic or target statistic of the effect for 
#' internal use by the estimation algorithm. 
#' @keywords internal
joining_similar_avoiding_dissimilar_covar_bin <- function(dep.var = 1, 
                                                          resource.attribute.index,
                                                          state, 
                                                          cache, 
                                                          i, 
                                                          j, 
                                                          edge, 
                                                          update, 
                                                          getTargetContribution = FALSE){

  nResources <- cache[[dep.var]]$valuedNetwork[i, j]
  
  ### calculate target statistic
  if(getTargetContribution){
    
    if(nResources < 2) return(0)
    nResources_1 <- cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][i, j]
    origin_size <- sum(cache[[dep.var]]$valuedNetwork[i, ])
    
    numerator <- nResources_1*(nResources_1 - 1) + 
      (nResources - nResources_1)*(nResources - nResources_1 - 1) -
      2*nResources_1*(nResources - nResources_1)
    denominator <- origin_size - 1
    return( numerator/denominator )
  }
  
  ### calculate change statistic
  if(update == -1){
    
    if(nResources < 2) return(0)
    nResources_1 <- cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][i, j]
    origin_size <- sum(cache[[dep.var]]$valuedNetwork[i, ])
    
    attr_removed <- state[[resource.attribute.index]]$data[edge]
    if(attr_removed == 1){ # then nResources_1 > 0
      cont <- (-2*(nResources_1 - 1) + 2*(nResources - nResources_1) ) /
        (origin_size - 1)
    } else { # then nResources-nResources_1 > 0
      cont <- (-2*(nResources - nResources_1 - 1) + 2*nResources_1 ) /
        (origin_size - 1)
    }
    
  }
  if(update == 1){
    
    if(nResources < 1) return(0)
    nResources_1 <- cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][i, j]
    origin_size <- sum(cache[[dep.var]]$valuedNetwork[i, ]) + 1
    
    attr_added <- state[[resource.attribute.index]]$data[edge]
    if(attr_added == 1){
      cont <- (2*nResources_1 - 2*(nResources - nResources_1) ) /
        (origin_size - 1)
    } else {
      cont <- (2*(nResources - nResources_1) - 2*(nResources_1) ) /
        (origin_size - 1)
    }
  }
  
  return(cont)
}


#' joining_similar_avoiding_dissimilar_covar_cont
#' 
#' Do individuals with the same attribute tend to use the same paths and 
#' individuals with different attributes to move to different places? 
#' This statistic gives a contribution to all pairs of individuals who use the 
#' same path that is weighted by the similarity between their continuous attribute. 
#' This similarity weight is measured as the range of the attribute, minus twice 
#' the absolute difference between their covariates, normalized by the range (the
#' weight of a pair is equal to 1 if both individuals have the same attribute,
#' and -1 if the absolute difference between their attributes is equal to the range).
#' 
#' @param dep.var 
#' @param resource.attribute.index 
#' @param state 
#' @param cache 
#' @param i 
#' @param j 
#' @param edge 
#' @param update 
#' @param getTargetContribution 
#'
#' @return Returns the change statistic or target statistic of the effect for 
#' internal use by the estimation algorithm. 
#' @keywords internal
joining_similar_avoiding_dissimilar_covar_cont <- function(dep.var = 1, 
                                                          resource.attribute.index,
                                                          state, 
                                                          cache, 
                                                          i, 
                                                          j, 
                                                          edge, 
                                                          update, 
                                                          getTargetContribution = FALSE){
  
  nResources <- cache[[dep.var]]$valuedNetwork[i, j]
  
  ### calculate target statistic
  if(getTargetContribution){
    
    if(nResources < 2) return(0)
    allResources <- state$transfers$data[,1] == i & state$transfers$data[,2] == j
    attributesResources <- state[[resource.attribute.index]]$data[allResources]
    attributeRange <- diff(range(state[[resource.attribute.index]]$data))
    origin_size <- sum(cache[[dep.var]]$valuedNetwork[i, ])
    
    distmat <- as.matrix(dist(attributesResources))
    up <- upper.tri(distmat)
    numerator <- sum( (attributeRange - 2*abs(as.numeric(distmat[up]))) / attributeRange ) 
    denominator <- origin_size - 1
    
    return( numerator/denominator )
    
  }
  
  ### calculate change statistic
  if(update == -1){
    
    if(nResources < 2) return(0)
    otherResources <- state$transfers$data[,1] == i & state$transfers$data[,2] == j &
      (1:state$transfers$size[1]) != edge
    attributesResources <- state[[resource.attribute.index]]$data[otherResources]
    attributeRange <- diff(range(state[[resource.attribute.index]]$data))
    origin_size <- sum(cache[[dep.var]]$valuedNetwork[i, ])
    
    attr_removed <- state[[resource.attribute.index]]$data[edge]
    cont <- - sum( (attributeRange - 2*abs(attr_removed-attributesResources)) / attributeRange ) /
      (origin_size - 1)
    
  }
  if(update == 1){
    
    if(nResources < 1) return(0)
    otherResources <- state$transfers$data[,1] == i & state$transfers$data[,2] == j &
        (1:state$transfers$size[1]) != edge
    attributesResources <- state[[resource.attribute.index]]$data[otherResources]
    attributeRange <- diff(range(state[[resource.attribute.index]]$data))
    origin_size <- sum(cache[[dep.var]]$valuedNetwork[i, ]) + 1
    
    attr_added <- state[[resource.attribute.index]]$data[edge]
    cont <- sum( (attributeRange - 2*abs(attr_added-attributesResources)) / attributeRange ) /
      (origin_size - 1)
  }
  return(cont)
}


#' avoiding_dissimilar_covar_bin
#' 
#' Do individuals with different attributes to move to different places? 
#' This statistic gives a negative contribution to pairs of dissimilar 
#' individuals following the same path.
#' 
#' @param dep.var 
#' @param resource.attribute.index 
#' @param state 
#' @param cache 
#' @param i 
#' @param j 
#' @param edge 
#' @param update 
#' @param getTargetContribution 
#'
#' @return Returns the change statistic or target statistic of the effect for 
#' internal use by the estimation algorithm. 
#' @keywords internal
avoiding_dissimilar_covar_bin <- function(dep.var = 1, 
                                          resource.attribute.index,
                                          state, 
                                          cache, 
                                          i, 
                                          j, 
                                          edge, 
                                          update, 
                                          getTargetContribution = FALSE){
  
  nResources <- cache[[dep.var]]$valuedNetwork[i, j]

  ### calculate target statistic
  if(getTargetContribution){
    
    if(nResources < 2) return(0)
    nResources_1 <- cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][i, j]
    origin_size <- sum(cache[[dep.var]]$valuedNetwork[i, ])
    
    numerator <- -2*nResources_1*(nResources - nResources_1)
    denominator <- origin_size - 1
    return( numerator/denominator )
    
  }
  
  ### calculate change statistic
  if(update == -1){
    
    if(nResources < 2) return(0)
    nResources_1 <- cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][i, j]
    origin_size <- sum(cache[[dep.var]]$valuedNetwork[i, ])
    
    attr_removed <- state[[resource.attribute.index]]$data[edge]
    if(attr_removed == 1){ # then nResources_1 > 0
      cont <- (2*(nResources - nResources_1)) /
        (origin_size - 1)
    } else { # then nResources-nResources_1 > 0
      cont <- (2*nResources_1) /
        (origin_size - 1)
    }
    
  }
  if(update == 1){
    
    if(nResources < 1) return(0)
    nResources_1 <- cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][i, j]
    origin_size <- sum(cache[[dep.var]]$valuedNetwork[i, ]) + 1
    
    attr_added <- state[[resource.attribute.index]]$data[edge]
    if(attr_added == 1){
      cont <- (-2*(nResources - nResources_1)) /
        (origin_size - 1)
    } else {
      cont <- (-2*(nResources_1)) /
        (origin_size - 1)
    }
    
  }
  return(cont)
}


#' avoiding_dissimilar_covar_cont
#' 
#' Do individuals with different attributes tend to move to different places? 
#' This statistic gives a contribution to all pairs of individuals who use the 
#' same path that is weighted by the absolute difference between their continuous attribute. 
#' 
#' @param dep.var 
#' @param resource.attribute.index 
#' @param state 
#' @param cache 
#' @param i 
#' @param j 
#' @param edge 
#' @param update 
#' @param getTargetContribution 
#'
#' @return Returns the change statistic or target statistic of the effect for 
#' internal use by the estimation algorithm. 
#' @keywords internal
avoiding_dissimilar_covar_cont <- function(dep.var = 1, 
                                           resource.attribute.index,
                                           state, 
                                           cache, 
                                           i, 
                                           j, 
                                           edge, 
                                           update, 
                                           getTargetContribution = FALSE){
  
  nResources <- cache[[dep.var]]$valuedNetwork[i, j]
  
  ### calculate target statistic
  if(getTargetContribution){
    
    if(nResources < 2) return(0)
    allResources <- state$transfers$data[,1] == i & state$transfers$data[,2] == j
    attributesResources <- state[[resource.attribute.index]]$data[allResources]
    attributeRange <- diff(range(state[[resource.attribute.index]]$data))
    origin_size <- sum(cache[[dep.var]]$valuedNetwork[i, ])
    
    distmat <- as.matrix(dist(attributesResources))
    up <- upper.tri(distmat)
    numerator <- sum( abs(as.numeric(distmat[up])) ) 
    denominator <- origin_size - 1
    
    return( numerator/denominator )
    
  }
  
  ### calculate change statistic
  if(update == -1){
    
    if(nResources < 2) return(0)
    otherResources <- state$transfers$data[,1] == i & state$transfers$data[,2] == j &
      (1:state$transfers$size[1]) != edge
    attributesResources <- state[[resource.attribute.index]]$data[otherResources]
    attributeRange <- diff(range(state[[resource.attribute.index]]$data))
    origin_size <- sum(cache[[dep.var]]$valuedNetwork[i, ])
    
    attr_removed <- state[[resource.attribute.index]]$data[edge]
    cont <- - sum( abs(attr_removed-attributesResources) ) /
      (origin_size - 1)
    
  }
  if(update == 1){
    
    if(nResources < 1) return(0)
    otherResources <- state$transfers$data[,1] == i & state$transfers$data[,2] == j &
      (1:state$transfers$size[1]) != edge
    attributesResources <- state[[resource.attribute.index]]$data[otherResources]
    attributeRange <- diff(range(state[[resource.attribute.index]]$data))
    origin_size <- sum(cache[[dep.var]]$valuedNetwork[i, ]) + 1
    
    attr_added <- state[[resource.attribute.index]]$data[edge]
    cont <- sum( abs(attr_added-attributesResources) ) /
      (origin_size - 1)
  }
  return(cont)
}



#' associativity_all_AC_covar_bin
#' 
#' Do individuals with the same attribute tend to use the same paths and 
#' individuals with different attributes to move to different places? 
#' This statistic gives a positive contribution to all cliques of individuals
#' with the same (binary) covariate who use the same path.
#' It's a geometrically-weighted statistic, so the more cliques we add, the
#' less they matter.
#' 
#' @param dep.var 
#' @param resource.attribute.index 
#' @param state 
#' @param cache 
#' @param i 
#' @param j 
#' @param edge 
#' @param update 
#' @param getTargetContribution 
#' @param alpha 
#'
#' @return Returns the change statistic or target statistic of the effect for 
#' internal use by the estimation algorithm. 
#' @keywords internal
associativity_all_AC_covar_bin <- function(dep.var = 1, 
                                       resource.attribute.index,
                                       state, 
                                       cache, 
                                       i, 
                                       j, 
                                       edge, 
                                       update, 
                                       getTargetContribution = FALSE,
                                       alpha = 2){
  
  nResources <- cache[[dep.var]]$valuedNetwork[i, j]
  nResources_1 <- cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][i, j]
  origin_size <- sum(cache[[dep.var]]$valuedNetwork[i, ])

  ### calculate target statistic
  if(getTargetContribution){
    
    g_cum <- function(y, a){
      contr <- 0
      if(y>1){
        for(k in 1:(y-1)){
          contr <- contr + (1 - (1-1/a)^(k))
        }
      }
      return(contr)
    }
    
    return( g_cum(nResources_1, a = alpha) + g_cum(nResources - nResources_1, a = alpha) )
  }
  
  ### calculate change statistic
  g_mar <- function(y, a){
    contr <- 0
    if(y>0) {
      contr <-  (1 - (1-1/a)^(y)) 
    } else {
      contr <- 0
    }
    return(contr)
  }
  
  if(update < 0){
    attr_removed <- state[[resource.attribute.index]]$data[edge]
    if(attr_removed == 1) {
      return(update * g_mar(y = (nResources_1 + update), a = alpha))
    } else {
      return(update * g_mar(y = (nResources - nResources_1 + update), a = alpha))
    }
  }
  if(update > 0){
    attr_added <- state[[resource.attribute.index]]$data[edge]
    if(attr_added == 1) {
      return(update * g_mar(y = nResources_1, a = alpha))
    } else {
      return(update * g_mar(y = nResources - nResources_1, a = alpha))
    }
  }
  
}


#' associativity_one_AC_covar_bin
#' 
#' Do individuals with the same attribute tend to use the same paths and 
#' individuals with different attributes to move to different places? 
#' This statistic gives a positive contribution to all cliques of individuals
#' with the value 1 of a binary covariate who use the same path.
#' It's a geometrically-weighted statistic, so the more cliques we add, the
#' less they matter.
#' 
#' @param dep.var 
#' @param resource.attribute.index 
#' @param state 
#' @param cache 
#' @param i 
#' @param j 
#' @param edge 
#' @param update 
#' @param getTargetContribution 
#' @param alpha 
#'
#' @return Returns the change statistic or target statistic of the effect for 
#' internal use by the estimation algorithm. 
#' @keywords internal
associativity_one_AC_covar_bin <- function(dep.var = 1, 
                                           resource.attribute.index,
                                           state, 
                                           cache, 
                                           i, 
                                           j, 
                                           edge, 
                                           update, 
                                           getTargetContribution = FALSE,
                                           alpha = 2){
  
  nResources <- cache[[dep.var]]$valuedNetwork[i, j]
  nResources_1 <- cache[[dep.var]]$resourceNetworks[[resource.attribute.index]][i, j]
  
  ### calculate target statistic
  if(getTargetContribution){
    
    g_cum <- function(y, a){
      contr <- 0
      if(y>1){
        for(k in 1:(y-1)){
          contr <- contr + (1 - (1-1/a)^(k))
        }
      }
      return(contr)
    }
    
    return( g_cum(nResources_1, a = alpha) )
  }
  
  ### calculate change statistic
  g_mar <- function(y, a){
    contr <- 0
    if(y>0) {
      contr <-  (1 - (1-1/a)^(y)) 
    } else {
      contr <- 0
    }
    return(contr)
  }
  
  if(update < 0){
    attr_removed <- state[[resource.attribute.index]]$data[edge]
    if(attr_removed == 1) {
      return(update * g_mar(y = (nResources_1 + update), a = alpha))
    } else {
      return(0)
    }
  }
  if(update > 0){
    attr_added <- state[[resource.attribute.index]]$data[edge]
    if(attr_added == 1) {
      return(update * g_mar(y = nResources_1, a = alpha))
    } else {
      return(0)
    }
  }
  
}