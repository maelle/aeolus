

# adapted from https://github.com/r-lib/usethis/blob/20e7eb244deb6157991c105786bf42efb2ac8640/R/rstudio.R#L60 # nolint: line_length_linter
#' Set Visual editor's Markdown wrapping option to "Sentence".
#'
#' @param scope Edit globally for the current *user*,
#' or locally for the current *project*.
#'
#' @return Nothing, used for its side-effects.
#' @export
use_sentence_linebreaks <- function(scope = c("user", "project")) {

  scope <- rlang::arg_match(scope)

  rlang::check_installed("rstudioapi")

  if (!rstudioapi::isAvailable()) {
    cli::cli_abort("Can't use {.fun use_sentence_linebreaks} outside of RStudio IDE.") # nolint: line_length_linter
  }

  if (scope == "user") {
    rstudioapi::writeRStudioPreference(
      "visual_markdown_editing_wrap", "sentence"
    )
    cli::cli_alert_success("Set Markdown wrap option to {.val Sentence} for the current user.") # nolint: line_length_linter
  } else {
    rproj <- dir(
      rstudioapi::getActiveProject(),
      pattern = "*.Rproj",
      full.names = TRUE
    )

    lines <- brio::read_lines(rproj)

    markdown_wrap <- grep("MarkdownWrap", lines)

    if (length(markdown_wrap) == 0) {
      lines <- append(lines, c("", "MarkdownWrap: Sentence"))
    } else {
      lines[markdown_wrap] <- "MarkdownWrap: Sentence"
    }

    brio::write_lines(lines, rproj)
    cli::cli_alert_success("Set Markdown wrap option to {.val Sentence} for the current project.") # nolint: line_length_linter
  }

  invisible()
}
