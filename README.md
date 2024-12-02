
<!-- README.md is generated from README.Rmd. Please edit that file -->

# aeolus

<!-- badges: start -->

[![R-CMD-check](https://github.com/maelle/aeolus/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/maelle/aeolus/actions/workflows/R-CMD-check.yaml)
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

    #>  [1] "1. thing"                                                                                                                          
    #>  [2] "2. other thing"                                                                                                                    
    #>  [3] ""                                                                                                                                  
    #>  [4] "- item 1"                                                                                                                          
    #>  [5] "- item 2"                                                                                                                          
    #>  [6] "- item 3"                                                                                                                          
    #>  [7] ""                                                                                                                                  
    #>  [8] "This is a **sentence**. This is another [sentence](https://github.com)."                                                           
    #>  [9] ""                                                                                                                                  
    #> [10] "In this paragraph"                                                                                                                 
    #> [11] "I made "                                                                                                                           
    #> [12] "random line "                                                                                                                      
    #> [13] "breaks. How annoying"                                                                                                              
    #> [14] "is it?!"                                                                                                                           
    #> [15] ""                                                                                                                                  
    #> [16] "```md"                                                                                                                             
    #> [17] "This is a sentence. This is another"                                                                                               
    #> [18] "sentence."                                                                                                                         
    #> [19] "```"                                                                                                                               
    #> [20] ""                                                                                                                                  
    #> [21] "This is a very long paragraph very very long without any breaks whatsoever which is sad, because who wants to get such a git diff."
    #> [22] ""                                                                                                                                  
    #> [23] ""

``` r
unleash(markdown_file)
readLines(markdown_file)
```

    #>  [1] "1. thing"                                                                                                                          
    #>  [2] "2. other thing"                                                                                                                    
    #>  [3] ""                                                                                                                                  
    #>  [4] "- item 1"                                                                                                                          
    #>  [5] "- item 2"                                                                                                                          
    #>  [6] "- item 3"                                                                                                                          
    #>  [7] ""                                                                                                                                  
    #>  [8] "This is a **sentence**."                                                                                                           
    #>  [9] "This is another [sentence](https://github.com)."                                                                                   
    #> [10] ""                                                                                                                                  
    #> [11] "In this paragraph I made random line breaks."                                                                                      
    #> [12] "How annoying is it?!"                                                                                                              
    #> [13] ""                                                                                                                                  
    #> [14] "```md"                                                                                                                             
    #> [15] "This is a sentence. This is another"                                                                                               
    #> [16] "sentence."                                                                                                                         
    #> [17] "```"                                                                                                                               
    #> [18] ""                                                                                                                                  
    #> [19] "This is a very long paragraph very very long without any breaks whatsoever which is sad, because who wants to get such a git diff."
    #> [20] ""                                                                                                                                  
    #> [21] ""
