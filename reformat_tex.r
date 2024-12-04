replace_before_document <- function(file_path) {
  lines <- readLines(file_path)
  preamble_index <- grep("\\\\begin\\{document\\}", lines)
  
  if (length(preamble_index) > 0) {
    new_lines <- c("\\documentclass[../main.tex]{subfiles}",
                   lines[(preamble_index):length(lines)])
    
    new_lines <- grep("\\\\maketitle", new_lines, invert = TRUE, value = TRUE)
    
    new_lines <- sapply(new_lines, function(line) {
      match <- regexpr("(\\\\includegraphics)(\\[[^\\]]*\\])?(\\{[^\\}]+\\})", line, perl = TRUE)
      
      if (match[1] != -1) {
        graphics_command <- regmatches(line, match)[1]
        
        if (!grepl("width=", graphics_command)) {
          # Check if there are existing options (`[...]`)
          if (grepl("\\[[^\\]]*\\]", graphics_command)) {
            # Append `width=\textwidth,` to existing options
            modified_command <- sub(
              "(\\\\includegraphics\\[)([^\\]]*)",
              "\\1width=\\\\textwidth,\\2",
              graphics_command
            )
          } else {
            # Add `width=\textwidth` as a new option
            modified_command <- sub(
              "(\\\\includegraphics)(\\{)",
              "\\1[width=\\\\textwidth]\\2",
              graphics_command
            )
          }
          regmatches(line, match) <- modified_command
        }
      }
      line
    }, USE.NAMES = FALSE)
    
    writeLines(new_lines, file_path)
    cat("Replaced preamble, removed \\maketitle, and modified \\includegraphics in", file_path, "\n")
  } else {
    cat("No \\begin{document} found in", file_path, "\n")
  }
}

replace_before_document_in_folder <- function(folder_path) {
  files <- list.files(folder_path, pattern = "\\.tex$", full.names = TRUE)
  lapply(files, replace_before_document)
}