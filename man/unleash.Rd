% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/unleash.R
\name{unleash}
\alias{unleash}
\title{Create better line breaks}
\usage{
unleash(path, new_path = path)
}
\arguments{
\item{path}{Path to the Markdown file}

\item{new_path}{Path where to save the new file}
}
\value{
Path to the new file (invisibly)
}
\description{
Currently \code{unleash()} only adds line breaks after sentences.
For better results,
you should also add line breaks after long sentence parts, manually.
}
\examples{
markdown_file <- system.file("example.md", package = "aeolus")
readLines(markdown_file)
unleash(markdown_file)
readLines(markdown_file)
}
