let s:suite = themis#suite('Test for autoload/slack_files/util.vim -')
let s:assert = themis#helper('assert')

function! s:suite.info2bufname()
  let actual = slack_files#util#info2bufname('https://foo', 'bar', 'baz', 'qux')
  let expected = 'vimslackfiles://foo/bar/baz/qux'
  call s:assert.equals(actual, expected)
endfunction

function! s:suite.bufname2info()
  let actual = slack_files#util#bufname2info('vimslackfiles://foo/bar/baz/qux')
  let expected_url = 'https://foo'
  let expected_id = 'bar'
  let expected_filetype = 'baz'
  let expected_title = 'qux'
  call s:assert.equals(actual['url'], expected_url)
  call s:assert.equals(actual['id'], expected_id)
  call s:assert.equals(actual['filetype'], expected_filetype)
  call s:assert.equals(actual['title'], expected_title)
endfunction

function! s:suite.is_slack_buffer()
  let actual = slack_files#util#is_slack_buffer('vimslackfiles://this/is/slack_buffer')
  call s:assert.true(actual)
  let actual = slack_files#util#is_slack_buffer('/this/is/not/slack_buffer')
  call s:assert.false(actual)
endfunction

