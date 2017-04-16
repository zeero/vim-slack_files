let s:suite = themis#suite('Test for autoload/unite/sources/slack_files.vim -')
let s:assert = themis#helper('assert')

function! s:suite.gather_candidates()
  let title = 'dummy_title'
  let filetype = 'dummy_filetype'
  let url = 'dummy_url'
  let id = 'dummy_id'
  let mock_value = {'files': [
  \ {
  \   'title': title,
  \   'filetype': filetype,
  \   'url_private': url,
  \   'id': id,
  \ }
  \]}
  let expected = [{
  \ 'word': title,
  \ 'source': 'slack_files',
  \ 'kind': 'file',
  \ 'action__path': slack_files#util#info2bufname(url, id, filetype, title),
  \}]
  try
    call vmock#mock('slack_files#api#files#list').return(mock_value).once()
    let dict = {'func': function('unite#sources#slack_files#gather_candidates')}
    let actual = dict.func('', '')
    call s:assert.equals(actual, expected)
    
    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction
