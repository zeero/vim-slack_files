let s:suite = themis#suite('Test for autoload/slack_files/command/upload.vim -')
let s:assert = themis#helper('assert')

function! s:suite.after() "{{{
  " exe 'source autoload/slack_files/common.vim'
endfunction "}}}

function! s:suite.call()
  let filename = expand('%:t')
  let contents = getline('0', '$')
  let expected = 'mock value'

  " TODO
  call s:assert.skip('TODO: vmock cant work with variable args.')

  try
    call vmock#mock('slack_files#common#write').with(filename, contents, {}).return(expected).once()
    let actual = slack_files#command#upload#call('')
    call s:assert.equals(actual, expected)
    
    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction
