replace_before_document <- function(file_path) {
  lines <- readLines(file_path)
  preamble_index <- grep("\\\\begin\\{document\\}", lines)
  
  if (length(preamble_index) > 0) {
    new_lines <- c("\\documentclass[../main.tex]{subfiles}
 \\graphicspath{{images/Background/}{Background/}}", lines[(preamble_index):length(lines)])
    new_content <- paste(new_lines, collapse = "\n")
    writeLines(new_content, file_path)
    cat("Replaced preamble in", file_path, "\n")
  } else {
    cat("No \\begin{document} found in", file_path, "\n")
  }
}

replace_before_document_in_folder <- function(folder_path) {
  files <- list.files(folder_path, pattern = "\\.tex$", full.names = TRUE)
  lapply(files, replace_before_document)
}

# Example usage:
folder_path <- "chapters_tex/chapters_quarto/"
replace_before_document_in_folder(folder_path)
