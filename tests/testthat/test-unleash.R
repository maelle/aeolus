test_that("unleash() works", {
  temp_file <- withr::local_tempfile()
  unleash(system.file("example.md", package = "aeolus"), temp_file)
  expect_snapshot(brio::read_lines(temp_file))
})
