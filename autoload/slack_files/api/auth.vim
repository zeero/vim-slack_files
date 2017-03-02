" =============================================================================
" File:          autoload/slack_files/api/auth.vim
" Description:   Functions for Slack Web API - auth
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim


" Vital
let s:V = vital#slack_files#new()
let s:HTTP = s:V.import('Web.HTTP')


function! slack_files#api#auth#test(token) "{{{
  if empty(a:token)
    return v:false
  endif

  let req = {}
  let req.url = slack_files#api#helper#api_domain() . '/auth.test'
  let req.method = 'post'
  let data = {}
  let data.token = a:token
  let req.data = s:HTTP.encodeURI(data)

  try
    let res = s:HTTP.request(req)
    call slack_files#api#helper#parse_response(res)
  catch
    return v:false
  endtry
  return v:true
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo

