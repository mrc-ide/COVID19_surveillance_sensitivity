ll3 <- function(beta,
                s_e,
                travel_ref,
                travel_other,
                obs_ref,
                obs_other) {
    out <- 0

    for (idx in seq_len(length(travel_ref))) {

        lambda_ref <- beta * travel_ref[idx]
        out <- out + dpois(
                         x = obs_ref[idx],
                         lambda = lambda_ref,
                         log = TRUE
                     )

    }
    ##message("out for ref countrries ",  out)
    lambda_other <- s_e * beta * travel_other
    ##message("s_e ", s_e)
    ##message("beta ", beta)
    ##message("travel_other ", travel_other)
    out <- out +
        dpois(
            x = obs_other, lambda = lambda_other, log = TRUE
        )
    ##message("lamda_ref = ", lambda_ref)
    ##message("out = ", out)

    out
}

## gold - countries we want to treat as gold standard
## this is singapore
## or singapore, frace, germany etc
## and one other country at a time
likelihood <- function(df, gold, other) {


    ref <- which(df$iso3c %in% gold)
    nonref <- which(df$iso3c == other)

    ref_obs <- as.integer(df$n[ref])
    ref_vol <- df$`Total...5`[ref]

    nonref_obs <- as.integer(df$n[nonref])
    nonref_vol <- df$`Total...5`[nonref]

    ##mle_lambda <- mean(ref_obs / ref_vol)
    mle_lambda <- sum(ref_obs) / sum(ref_vol)
    mle_se <- (nonref_obs * sum(ref_vol)) /
        (nonref_vol * sum(ref_obs))


    lambda_range <- seq(
        from = mle_lambda / 100,
        to = 10 * mle_lambda,
        by = mle_lambda / 10
    )

    if (mle_se == 0) {
        message("MLE SE is 0 for ", other)

        se_range <- seq(from = 0, to = 2, by = 0.001)
        ## lambda_rangde <- seq(
        ##     from = mle_lambda / 100,
        ##     to = 10 * mle_lambda,
        ##     length.out = length(se_range)
        ## )

    } else {

        se_range <- seq(
            from = 0.0001,
            to = 2,
            by = 0.001
        )

    }

    params <- expand.grid(
        se = se_range, lam = lambda_range
    )

    ll_profile <-  purrr::pmap(
        params,
        function(se, lam) {
            ll3(
                lam, se, ref_vol, nonref_vol, ref_obs, nonref_obs
            )
        }
      )
    out <- list(
        params = params,
        ll_profile = ll_profile,
        country = other
    )

    out

}


extract_ci <- function(out) {

    out$ll_profile <- unlist(out$ll_profile)
    idx <- which.max(out$ll_profile)
    se_mle <-  out$params[["se"]][idx]
    lambda_mle <- out$params[["lam"]][idx]

    se_ci <- which(
        abs(out$ll_profile[idx] - out$ll_profile) <= 3.84 / 2
    )

    se_ci_low <- min(out$params[["se"]][se_ci])
    se_ci_high <- max(out$params[["se"]][se_ci])

    lambda_ci_low <- min(out$params[["lam"]][se_ci])
    lambda_ci_high <- max(out$params[["lam"]][se_ci])


    data.frame(
        iso3c = out$country,
        se_ci_low = se_ci_low,
        se_mle = se_mle,
        se_ci_high = se_ci_high,

        lambda_ci_low = lambda_ci_low,
        lambda_mle = lambda_mle,
        lambda_ci_high = lambda_ci_high

    )

}
