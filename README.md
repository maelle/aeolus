
<!-- README.md is generated from README.Rmd. Please edit that file -->

# aeolus

<!-- badges: start -->
<!-- badges: end -->

The goal of aeolus is to create better, more semantic linebreaks in your
Markdown file. aEOLus, get it? :wink:

## Installation

You can install the development version of aeolus like so:

``` r
pak::pak("maelle/aeolus")
```

## Why have semantic linebreaks?

For any Markdown parser the two following code chunks are the same:

``` md
This is a sentence. This is another
sentence.
```

``` md
This is a sentence. 
This is another sentence.
```

However, the second one will make your work easier when you use version
control. Git treats code by **line** so if lines are logical units as
opposed to random units or units of a certain length, the Git diff is
better.

If you change one sentence in a paragraph, and that paragraph is a
single line, the Git diff is less readable.

With semantic linebreaks, code suggestions in GitHub Pull Requests are
easier to make and use.

More information: <https://sembr.org/>.

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(aeolus)
markdown_file <- system.file("example.md", package = "aeolus")
readLines(markdown_file)
```

    #>  [1] "This is a **sentence**. This is another [sentence](https://github.com)."                                                           
    #>  [2] ""                                                                                                                                  
    #>  [3] "```md"                                                                                                                             
    #>  [4] "This is a sentence. This is another"                                                                                               
    #>  [5] "sentence."                                                                                                                         
    #>  [6] "```"                                                                                                                               
    #>  [7] ""                                                                                                                                  
    #>  [8] "This is a very long paragraph very very long without any breaks whatsoever which is sad, because who wants to get such a git diff."
    #>  [9] ""                                                                                                                                  
    #> [10] ""

``` r
unleash(markdown_file)
readLines(markdown_file)
```

    #>  [1] "This is a **sentence**."                                                                                                           
    #>  [2] "This is another [sentence](https://github.com)."                                                                                   
    #>  [3] ""                                                                                                                                  
    #>  [4] "```md"                                                                                                                             
    #>  [5] "This is a sentence. This is another"                                                                                               
    #>  [6] "sentence."                                                                                                                         
    #>  [7] "```"                                                                                                                               
    #>  [8] ""                                                                                                                                  
    #>  [9] "This is a very long paragraph very very long without any breaks whatsoever which is sad, because who wants to get such a git diff."
    #> [10] ""                                                                                                                                  
    #> [11] ""
