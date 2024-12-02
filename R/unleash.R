unleash <- function(path, max_part_length = 80L) {
  if (!file.exists(path)) {
    cli::cli_abort("Can't find path {path}.")
  }

  yarn <- tinkr::yarn$new(path)

  text <- purrr::keep(xml2::xml_children(yarn$body), \(x) xml2::xml_name(x) != "code_block")

  purrr::walk(text, handle_node)

  browser()
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
  xml2::xml_replace(node, body)
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
