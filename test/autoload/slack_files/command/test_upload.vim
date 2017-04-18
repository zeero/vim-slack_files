let s:suite = themis#suite('Test for autoload/slack_files/command/upload.vim -')
let s:assert = themis#helper('assert')

function! s:suite.after() "{{{
  exe 'source autoload/slack_files/common.vim'
endfunction "}}}

function! s:suite.call()
  let filename = expand('%:t')
  let contents = getline('0', '$')
  let expected = 'mock value'

  try
    call vmock#mock('slack_files#common#write').with(filename, contents, [{'title': expand('%:t')}]).return(expected).once()
    let actual = slack_files#command#upload#call('')
    call s:assert.equals(actual, expected)
    
    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction

function! s:suite.call_with_full_options()
  let filename = expand('%:t')
  let contents = getline('0', '$')
  let expected = 'mock value'

  let channels = 'dummy_channels1,dummy_channels2'
  let filetype = 'dummy_ft'
  let comment  = 'dummy_comment'

  let qargs    = printf('--channels=%s --filetype=%s --comment=%s', channels, filetype, comment)

  let expected_config = {
  \ 'title': expand('%:t'),
  \ 'channels': channels,
  \ 'filetype': filetype,
  \ 'comment': comment,
  \}

  try
    call vmock#mock('slack_files#common#write').with(filename, contents, [expected_config]).return(expected).once()
    let actual = slack_files#command#upload#call(qargs)
    call s:assert.equals(actual, expected)
    
    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction

