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
            summarise(perc = n()/nrow(.)*100) %>%
			pivot_wider(names_from = gender_slider.response, values_from = perc),
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
