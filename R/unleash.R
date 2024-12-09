#' Create better line breaks
#'
#' Currently `unleash()` only adds line breaks after sentences.
#' For better results,
#' you should also add line breaks after long sentence parts, manually.
#'
#' @param path Path to the Markdown file
#' @param new_path Path where to save the new file
#'
#' @return Path to the new file (invisibly)
#' @export
#'
#' @examples
#' markdown_file <- system.file("example.md", package = "aeolus")
#' readLines(markdown_file)
#' unleash(markdown_file)
#' readLines(markdown_file)
unleash <- function(path, new_path = path) {
  if (!file.exists(path)) {
    cli::cli_abort("Can't find path {path}.")
  }

  # sourcepos needed to protect footnotes!
  yarn <- tinkr::yarn$new(path, sourcepos = TRUE)

  paragraphs <- xml2::xml_find_all(yarn$body, "./d1:paragraph[not(d1:image)]")
  purrr::walk(paragraphs, handle_node)

  list_items <- xml2::xml_find_all(yarn$body, "./d1:list/d1:item")
  purrr::walk(list_items, handle_node)

  text <- xml2::xml_find_all(yarn$body, ".//text")
  purrr::walk(text, handle_text)

  text <- xml2::xml_find_all(yarn$body, ".//d1:text")
  purrr::walk(text, handle_text)

  yarn$write(new_path)
  invisible(new_path)
}

handle_node <- function(node) {
  softbreaks <- xml2::xml_find_all(node, "./d1:softbreak")
  xml2::xml_replace(softbreaks, "text", " ")

  for (kiddo in xml2::xml_children(node)) {
    if (xml2::xml_name(kiddo) == "text") {
      sentences <- tokenizers::tokenize_sentences(
        xml2::xml_text(kiddo),
        simplify = TRUE
      )
      if (length(sentences) > 1) {
        for (sentence in rev(sentences[-1])) {
          xml2::xml_add_sibling(
            kiddo,
            "text",
            sentence,
            .where = "after"
          )
        }
        xml2::xml_replace(
          kiddo,
          "text",
          sentences[1]
        )
      }
    }
  }
  how_many_kiddos <- length(xml2::xml_children(node))
  if (how_many_kiddos == 1) {
    return()
  }

  for (kiddo in xml2::xml_children(node)[-how_many_kiddos]) {
    if (xml2::xml_name(kiddo) %in% c("text", "strong", "italic") &&
        grepl("[\\.\\!\\?\\;\\:](\\*\\_)?$", xml2::xml_text(kiddo))) {
      xml2::xml_add_sibling(
        kiddo,
        "softbreak",
        .where = "after"
      )
    }
  }

}

handle_text <- function(text) {
  next_sibling <- xml2::xml_find_all(text, "following-sibling::*[1]")
  if (length(next_sibling) > 0 && xml2::xml_name(next_sibling) == "link") {
    end_space <- grepl(" $", xml2::xml_text(text))
    if (!end_space) {
      xml2::xml_text(text) <- paste0(xml2::xml_text(text), " ")
    }
  }

  if (startsWith(xml2::xml_text(text), " ")) {
    last_sibling <- xml2::xml_find_all(text, "preceding-sibling::*[1]")
    if (xml2::xml_name(last_sibling) == "softbreak") {
      xml2::xml_text(text) <- sub("^ ", "", xml2::xml_text(text))
    }
  }
}
