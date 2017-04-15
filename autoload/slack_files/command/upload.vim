" =============================================================================
" File:          autoload/slack_files/command/upload.vim
" Description:   Functions called from Commands :SlackFilesUpload.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim


" Vital
let s:V = vital#slack_files#new()
let s:OptionParser = s:V.import('OptionParser')
let s:parser = s:OptionParser.new()


" command interface
function! slack_files#command#upload#call(qargs) abort "{{{
  let opts = s:parser.parse(a:qargs)
  let filetype = get(opts, 'filetype')
  let comment = get(opts, 'comment')
  let channels = get(opts, 'channels')

  let filename = expand('%:t')
  let contents = getline('0', '$')
  let config = {}
  let config.title = expand('%:t')
  if filetype isnot 0
    let config.filetype = filetype
  endif
  if comment isnot 0
    let config.comment = comment
  endif
  if channels isnot 0
    let config.channels = chennels
  endif
  return slack_files#write(filename, contents, config)
endfunction "}}}

" define options
call s:parser.on('--filetype=VALUE', 'A file type identifier.', {'completion': function('slack_files#command#upload#filetype_completion')})
call s:parser.on('--comment=VALUE', 'Initial comment to add to file.')
call s:parser.on('--channels=VALUE', 'Comma-separated list of channel names or IDs where the file will be shared.')

" completion for --filetype option
function! slack_files#command#upload#filetype_completion(optlead, cmdline, cursorpos) "{{{
  let candidates = ['auto', 'text', 'applescript', 'boxnote', 'c', 'csharp', 'cpp', 'css', 'csv', 'clojure', 'coffeescript', 'cfm', 'd', 'dart', 'diff', 'dockerfile', 'erlang', 'fsharp', 'fortran', 'go', 'groovy', 'html', 'handlebars', 'haskell', 'haxe', 'java', 'javascript', 'kotlin', 'latex', 'lisp', 'lua', 'markdown', 'matlab', 'mumps', 'ocaml', 'objc', 'php', 'pascal', 'perl', 'pig', 'post', 'powershell', 'puppet', 'python', 'r', 'ruby', 'rust', 'sql', 'sass', 'scala', 'scheme', 'shell', 'smalltalk', 'swift', 'tsv', 'vb', 'vbscript', 'velocity', 'verilog', 'xml', 'yaml']
  return filter(candidates, 'a:optlead == "" ? 1 : (v:val =~# a:optlead)')
endfunction "}}}

" completion for command
function! slack_files#command#upload#completion(arglead, cmdline, cursorpos) "{{{
  return s:parser.complete(a:arglead, a:cmdline, a:cursorpos)
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo

