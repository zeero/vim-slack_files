" =============================================================================
" File:          plugin/slack_files.vim
" Description:   Vim plugin for Slack Files.
" =============================================================================

if exists('g:loaded_slack_files') && (! exists('g:slack_files_dev') )
  finish
endif
let g:loaded_slack_files = 1

let s:save_cpo = &cpo
set cpo&vim


" Variables
let g:slack_files_list_types = get(g:, 'slack_files_list_types', 'snippets')
let g:slack_files_token_dir = get(g:, 'slack_files_token_dir', $HOME . '/.cache/vim-slack_files')

" Commands
command! -nargs=* -complete=customlist,slack_files#command#upload#completion SlackFilesUpload call slack_files#command#upload#call(<q-args>)
command! -bar CtrlPSlackFiles call ctrlp#init(ctrlp#slack_files#id())

" Keymaps

" Autocommand
augroup slack_files_write_file
  autocmd!
  execute printf('autocmd BufWriteCmd  %s* call slack_files#autocmd#onBufWriteCmd()', slack_files#util#prefix_bufname())
augroup END


let &cpo = s:save_cpo
unlet s:save_cpo

