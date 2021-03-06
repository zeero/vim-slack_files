" =============================================================================
" File:          plugin/slack_files.vim
" Description:   Vim plugin for Slack Files.
" =============================================================================

if exists('g:loaded_slack_files') && (! exists('g:slack_files#dev') )
  finish
endif
let g:loaded_slack_files = 1

let s:save_cpo = &cpo
set cpo&vim


" Commands
command! -nargs=* -complete=customlist,slack_files#command#upload#completion SlackFilesUpload call slack_files#command#upload#call(<q-args>)
command! -bar CtrlPSlackFiles call ctrlp#init(ctrlp#slack_files#id())

" Keymaps

" Autocmds
augroup slack_files
  autocmd!
  exe printf('autocmd BufReadCmd %s* call slack_files#autocmd#onBufReadCmd(expand("%%"))', slack_files#util#prefix_bufname())
  exe printf('autocmd BufWriteCmd %s* call slack_files#autocmd#onBufWriteCmd(expand("%%"))', slack_files#util#prefix_bufname())
augroup END


let &cpo = s:save_cpo
unlet s:save_cpo

