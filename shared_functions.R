# Age, gender, and literacy extraction functions

extract_age <- function(df) {
    assign(
        paste0(deparse(substitute(df)), "_age"),
        df %>%
            distinct(participant, .keep_all = TRUE) %>%
            summarise(mean = mean(age_textbox.text, na.rm = TRUE),
                      sd = sd(age_textbox.text, na.rm = TRUE)),
        envir = .GlobalEnv
    )
}

extract_gender <- function(df) {
    assign(
        paste0(deparse(substitute(df)), "_gender"),
        df %>%
            distinct(participant, .keep_all = TRUE) %>%
			group_by(gender_slider.response) %>%
            summarise(count = n()) %>%
			pivot_wider(names_from = gender_slider.response, values_from = count),
        envir = .GlobalEnv
    )
}

extract_literacy <- function(df) {
    assign(
        paste0(deparse(substitute(df)), "_graph_literacy"),
        df %>%
            distinct(participant, .keep_all = TRUE) %>%
            summarise(mean = mean(literacy), sd = sd(literacy)),
        envir = .GlobalEnv
    )
}

# Plotting functions

## prepare slopes for plotting

prepare_slopes <- function (my_desired_r) {
  
  set.seed(1234)
  
  my_sample_size = 128
  
  mean_variable_1 = 0
  sd_variable_1 = 1
  
  mean_variable_2 = 0
  sd_variable_2 = 1
  
  mu <- c(mean_variable_1, mean_variable_2) 
  
  myr <- my_desired_r * sqrt(sd_variable_1) * sqrt(sd_variable_2)
  
  mysigma <- matrix(c(sd_variable_1, myr, myr, sd_variable_2), 2, 2) 
  
  corr_data = as_tibble(mvrnorm(my_sample_size, mu, mysigma, empirical = TRUE))
  
  corr_model <- lm(V2 ~ V1, data = corr_data)
  
  my_residuals <- abs(residuals(corr_model))
  
  data_with_resid <- round(cbind(corr_data, my_residuals), 2)
  
  slopes <- data_with_resid %>%
    mutate(slope_linear = my_residuals/3.2) %>%
    mutate(slope_0.25 = 1-(0.25)^my_residuals) %>%
    mutate(slope_inverted = (1 + (0.25)^ my_residuals)-1) %>%
    mutate(slope_inverted_floored = pmax(0.1,(1+(0.25)^my_residuals)-1)) 
  
  return(slopes)
}

plot_example_function <- function (df, t, o, s, title_size) {
  
  ggplot(df, aes(x = V1, y = V2)) +
    scale_alpha_identity() +
    scale_size_identity() +
    geom_point(aes(size = (s + 0.7),
                   alpha = o), shape = 16)  +
    labs(x = "", y = "",
         title = t) +
    theme_ggdist() +
    theme(axis.text = element_blank(),
          plot.margin = unit(c(0,0,0.4,0), "cm"),
          legend.position = "none",
          plot.title = element_text(size = title_size, vjust = -0.1),
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.line = element_line(linewidth = 0.25))
}

## plot example function for experiment 5

exp5_slope_function <- function(my_desired_r) {
  
  set.seed(1234)
  
  my_sample_size = 128
  
  mean_variable_1 = 5
  sd_variable_1 = 1
  
  mean_variable_2 = 76
  sd_variable_2 = 5
  
  mu <- c(mean_variable_1, mean_variable_2) 
  
  myr <- my_desired_r * sqrt(sd_variable_1) * sqrt(sd_variable_2)
  
  mysigma <- matrix(c(sd_variable_1, myr, myr, sd_variable_2), 2, 2) 
  
  corr_data = as_tibble(mvrnorm(my_sample_size, mu, mysigma, empirical = TRUE))
  
  corr_model <- lm(V2 ~ V1, data = corr_data)
  
  my_residuals <- abs(residuals(corr_model))
  
  data_with_resid <- round(cbind(corr_data, my_residuals), 2)
  
  slopes_exp5 <- data_with_resid %>%
    mutate(slope_0.25 = 1-(0.25)^my_residuals) %>%
    mutate(slope_inverted = (1 + (0.25)^ my_residuals)-1) %>%
    mutate(slope_inverted_floored = pmax(0.2,(1+(0.25)^my_residuals)-1)) %>%
    mutate(typical = 0.033) %>%
    mutate(standard_alpha = 1)
  
  return(slopes_exp5)
}

# manually specify variables from slopes_exp5 df

slopes_exp5 <- exp5_slope_function(0.6)
slopeI <- (slopes_exp5$slope_inverted)
slopeI_floored <- (slopes_exp5$slope_inverted_floored)
typical <- (slopes_exp5$typical)
standard_alpha <- (slopes_exp5$standard_alpha)

# function for creating example plots for exp 5

example_plot_function_exp5 <- function(slopes, my_desired_r, size_value, opacity_value, theme) {
  
  p <- ggplot(slopes, aes(x = V1, y = V2)) +
    scale_size_identity() +
    scale_alpha_identity() +
    geom_point(aes(size =  4*(size_value + 0.2), alpha = opacity_value), shape = 16) +  
    geom_hline(yintercept = 68, size = 1, colour="#333333") +
    geom_segment(x = 0, xend = 10, y = 66.2, yend = 66.2, size = 0.3, colour="#585858") +
    bbc_style() +
    theme(axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          plot.title = element_text(size = 12, vjust = -1),
          plot.subtitle = element_text(size = 6.75),
          plot.caption = element_text(size = 6, hjust = -0.02),
          plot.margin = unit(c(0,0,1,0), "cm")) +
    labs(title = "Spicy Foods",
         subtitle = "Higher consumption of plain (non-spicy) foods\nis associated with a higher risk of certain types of cancer.",
         caption = "Source: NHS England") +
    annotate("text", x = 3, y = 67, label = "Less plain Diet", size = 2.5) +
    annotate("text", x = 7, y = 67, label = "More plain Diet", size = 2.5) +
    annotate("text", x = 1, y = 71, label = "Fewer Cancer\nDiagnoses", angle = 90, size = 2.5) +
    annotate("text", x = 1, y = 80, label = "More Cancer\nDiagnoses", angle = 90, size = 2.5) +
    coord_cartesian(clip = "off")
  
  return(p)
  
}

# function for plotting error error bar plots per group, per r value
# usage requires renaming the factor as "grouping_var"

plot_error_bars_function <- function(df, grouping_var, measure, labels) {
  df %>% 
    drop_na() %>% 
    group_by(grouping_var, my_rs) %>% 
    summarise(sd = sd(get(measure)), mean = mean(get(measure))) %>% 
    ggplot(aes(x = my_rs, y = mean*-1)) +
    geom_errorbar(mapping = aes(ymin = -1*mean + sd, ymax = -1*mean - sd),
                  width = 0.01,
                  size = 0.3) +
    theme_ggdist() +
    scale_y_continuous(breaks = seq(-0.4,1, 0.2)) +
    theme(strip.text = element_text(size = 6,
                                    margin = margin(1,0,1,0, "mm")),
          aspect.ratio = 1,
          axis.text = element_text(size = 7),
          axis.title.y = ggtext::element_markdown(size = 8),
          axis.title.x = ggtext::element_markdown(size = 8)) +
    facet_wrap(grouping_var ~., ncol = 4, labeller = labeller(grouping_var = labels)) +
    labs(x = "Objective *r*",
         y = "Mean *r* Estimation Error") +
    geom_line(formula= x ~ y, size = 0.5) +
    xlim(0.2,1)
}

# Functions for working with experimental models

## comparison function - returns model with fixed fx terms removed

comparison <- function(model) {
  
  parens <- function(x) paste0("(",x,")")
  onlyBars <- function(form) reformulate(sapply(findbars(form),
                                                function(x)  parens(deparse(x))),
                                         response=".")
  onlyBars(formula(model))
  cmpr_model <- update(model,onlyBars(formula(model)))
  
  return(cmpr_model)
  
}

## anova results functions - outputs test statistics to global env

anova_results <- function(model, cmpr_model) {
  
  model_name <- deparse(substitute(model))
  
  if (class(model) == "buildmer") model <- model@model
  if (class(cmpr_model) == "buildmer") cmpr_model <- cmpr_model@model
  
    anova_output <- anova(model, cmpr_model)

  assign(paste0(model_name, ".Chisq"),
         anova_output$Chisq[2],
         envir = .GlobalEnv)
  assign(paste0(model_name, ".df"),
         anova_output$Df[2],
         envir = .GlobalEnv)
  assign(paste0(model_name, ".p"),
         anova_output$`Pr(>Chisq)`[2],
         envir = .GlobalEnv)
}

anova_results_e5 <- function(model, cmpr_model) {
  
  model_name <- deparse(substitute(model))
  
  if (class(model) == "buildmer") model <- model@model
  if (class(cmpr_model) == "buildmer") cmpr_model <- cmpr_model@model
  
  if (class(model) == "clmm") {
    
    anova_output <- ordinal:::anova.clm(model, cmpr_model)
    
    assign(paste0(model_name, ".LR"),
           anova_output$LR.stat[2],
           envir = .GlobalEnv)
    assign(paste0(model_name, ".df"),
           anova_output$df[2],
           envir = .GlobalEnv)
    assign(paste0(model_name, ".p"),
           anova_output$`Pr(>Chisq)`[2],
           envir = .GlobalEnv)
  }
}

## function to extract contrasts from model summaries using emmeans

contrasts_extract <- function(model, measure) {
  
  contrast_formula <- as.formula(paste("pairwise ~", measure))
  
  model_name <- deparse(substitute(model))
  
  if (class(model) == "buildmer") model <- model@model
  
  EMMs <- emmeans(model, contrast_formula)
  
  contrast_df <- as.data.frame(EMMs[2]) %>%
    rename_with(str_replace,
                pattern = "contrasts.", replacement = "",
                matches("contrasts")) %>%
    rename_with(str_to_title, !starts_with("p")) %>%
    select(c("Contrast", "Z.ratio", "p.value")) %>%
    mutate(p.value = scales::pvalue(p.value)) %>%
    rename("\\textit{p}" = "p.value",
           "Z ratio" = "Z.ratio")
  
  return(contrast_df)
}

## function to add a fixed effect term to any model

add_fixed_effect <- function(model, term, df) {
  
  if (class(model) == "buildmer") model <- model@model
  
  new_formula <- add.terms(formula(model), term)
  
  new_model <- eval(bquote(
    lmerTest::lmer(.(new_formula), data = .(as.name(df)))
  ))
  
  return(new_model)
}

## lme.dscore function, as EMAtools package is no longer available

lme.dscore <- function (mod, data, type){

    mod1 <- lmerTest::lmer(mod, data = data)
    eff <- cbind(summary(mod1)$coefficients[,4], summary(mod1)$coefficients[,3])
  
  colnames(eff) <- c("t","df")
  eff <- as.data.frame(eff)
  eff$d <- (2*eff$t)/sqrt(eff$df)
  eff <- eff[-1,]
  return(eff)
}

