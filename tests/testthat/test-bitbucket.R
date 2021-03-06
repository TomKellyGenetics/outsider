context('Testing \'bitbucket\'')
test_that('bitbucket_repo_search() works', {
  skip_if_offline()
  res <- bitbucket_repo_search(repo = 'dominicjbennett/om..hello.world')
  expect_true(inherits(res, 'data.frame'))
  expect_warning(bitbucket_repo_search(repo = 'dominicjbennett/notarepo'))
})
test_that('bitbucket_tags() works', {
  skip_if_offline()
  res <- bitbucket_tags(repos  = 'dominicjbennett/om..hello.world')
  expect_true(inherits(res, 'tbl_df'))
  expect_warning(bitbucket_tags(repos = 'dominicjbennett/notarepo'))
})
