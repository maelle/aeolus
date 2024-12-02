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

  yarn <- tinkr::yarn$new(path)

  paragraphs <- xml2::xml_find_all(yarn$body, "./d1:paragraph")
  purrr::walk(paragraphs, handle_node)

  list_items <- xml2::xml_find_all(yarn$body, "./d1:list/d1:item")
  purrr::walk(list_items, handle_node)

  yarn$write(new_path)
  invisible(new_path)
}

handle_node <- function(node) {
  softbreaks <- xml2::xml_find_all(node, "./d1:softbreak")
  xml2::xml_replace(softbreaks, "text", " ")
  placeholder <- create_placeholder(node)

  md_file <- withr::local_tempfile()
  placeholder$write(md_file)
  md_lines <- brio::read_lines(md_file)
  # no empty lines in nodes
  md_lines <- md_lines[nzchar(md_lines)]

  md_lines <- tokenizers::tokenize_sentences(md_lines)[[1]]

  md_lines <- paste(md_lines, collapse = "\n")
  xml <- xml2::read_xml(commonmark::markdown_xml(md_lines))
  body <- xml2::xml_child(xml)
  if (xml2::xml_name(node) == "paragraph") {
    xml2::xml_replace(node, body)
  } else if (xml2::xml_name(node) == "item") {
    xml2::xml_name(body) <- xml2::xml_name(node)
    kiddo <- xml2::xml_child(body)
    xml2::xml_name(kiddo) <- xml2::xml_name(xml2::xml_child(node))
  }
}


create_placeholder <- function(xml) {
  temp_file <- withr::local_tempfile()

  lines <- paste(
    readLines(system.file("template.xml", package = "aeolus")),
    collapse = "\n"
  )

  fill <- if (inherits(xml, "xml_nodeset")) {
    paste(as.character(xml), collapse = "\n")
  } else if (inherits(xml, "xml_node")) {
    as.character(xml)
  } else
  {
    paste(
      purrr::map_chr(xml, ~ paste(as.character(xml2::xml_children(.x)), collapse = "\n")),
      collapse = "\n"
    )
  }
  lines <- sub("FILLHERE", fill, lines, fixed = TRUE)
  brio::write_lines(lines, temp_file)
  placeholder <- tinkr::yarn$new()
  placeholder$body <- xml2::read_xml(temp_file)
  placeholder
}
