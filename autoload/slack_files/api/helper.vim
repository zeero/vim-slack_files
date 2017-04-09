" =============================================================================
" File:          autoload/slack_files/api/helper.vim
" Description:   Functions for API helper
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim


" Vital
let s:V = vital#slack_files#new()
let s:HTTP = s:V.import('Web.HTTP')
let s:JSON = s:V.import('Web.JSON')

" Const
let s:SLACK_API_DOMAIN = 'https://slack.com/api/'


" post to Slack Web API
" Arguments: [path] Slack Web API path
" Arguments: [...]  post data Dictionary
" Return:    response Dictionary
function! slack_files#api#helper#post(path, ...) abort "{{{
  let data = get(a:000, 0, {})
  " to avoid infinite loop, dont use get() with default value
  if get(data, 'token') is 0
    let data.token = slack_files#get_token()
  endif

  let req = {}
  let req.url = s:SLACK_API_DOMAIN . a:path
  let req.method = 'post'
  let req.data = s:HTTP.encodeURI(data)

  let res = s:HTTP.request(req)
  return s:parse_response(res)
endfunction "}}}

" download slack file & return contents
" Arguments: [url] slack file url_private
" Return:    contents String
function! slack_files#api#helper#get(url) abort "{{{
  let req = {}
  let req.url = a:url
  let req.method = 'get'
  let req.headers = {}
  let req.headers.Authorization = printf('Bearer %s', slack_files#get_token())

  let res = s:HTTP.request(req)
  call s:check_http_status(res)
  return res.content
endfunction "}}}


" Private Functions

" parse Slack API response
" Arguments: [res] Web.HTTP response
" Return:    Web.HTTP content
function! s:parse_response(res) abort "{{{
  call s:check_http_status(a:res)

  let content = s:JSON.decode(a:res.content)
  if ! content.ok
    echomsg a:res.content
    throw 'slack_files: Slack API error'
  endif
  return content
endfunction "}}}

" check http status
" Arguments: [res] Web.HTTP response
function! s:check_http_status(res) abort "{{{
  if ! (a:res.success || count(a:res.allHeaders, 'HTTP/2 200 '))
    echomsg string(a:res)
    throw 'slack_files: Slack API network error'
  endif
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo

