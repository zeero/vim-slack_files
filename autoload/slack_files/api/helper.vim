" =============================================================================
" File:          autoload/slack_files/api/helper.vim
" Description:   Functions for API helper
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim


" Vital
let s:V = vital#slack_files#new()
let s:JSON = s:V.import('Web.JSON')

" Const
let s:SLACK_API_DOMAIN = 'https://slack.com/api'


" get Slack API domain
function! slack_files#api#helper#api_domain() "{{{
  return s:SLACK_API_DOMAIN
endfunction "}}}

" parse Slack API response
" Arguments: [res] Web.HTTP response
" Return:    Web.HTTP content
function! slack_files#api#helper#parse_response(res) "{{{
  call slack_files#api#helper#check_http_status(a:res.status)

  let content = s:JSON.decode(a:res.content)
  if ! content.ok
    echomsg a:res.content
    throw 'ERROR: Slack API error'
  endif
  return content
endfunction "}}}

" check http status
function! slack_files#api#helper#check_http_status(status) "{{{
  if a:status != '200'
    echomsg a:status
    throw 'ERROR: Slack API network error'
  endif
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
