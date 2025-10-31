" Keep clipboard in sync with system
set clipboard=unnamed

" Unmap space so we can use it as leader
unmap <Space>

" === Existing Sidebar setup ===
exmap toggleLeft obcommand app:toggle-left-sidebar
exmap toggleRight obcommand app:toggle-right-sidebar

nmap <Space>e :toggleLeft<CR>
nmap <Space>r :toggleRight<CR>

" === Existing Search setup ===
exmap qs obcommand switcher:open
nmap <Space>sf :qs<CR>

exmap lg obcommand global-search:open
nmap <Space>sg :lg<CR>

" === Buffer-like mappings (Neovim style) ===

" <leader>bo → close all tabs (like :%bd)
exmap bo obcommand workspace:close-all
nmap <Space>bo :bo<CR>

" <leader>bd → close current note (like :bd)
exmap bd obcommand editor:close-note
nmap <Space>bd :bd<CR>

" <leader>q → open command palette (like :Trouble or :Quickfix)
exmap q obcommand workspace:open-command-palette
nmap <Space>q :q<CR>

" Optional: clear search highlight with ESC
nnoremap <Esc> :nohlsearch<CR>

" --- Daily notes via Vimrc Support ---
" Show available command IDs in dev console: :obcommand

" Core Daily Notes plugin
exmap DailyToday obcommand daily-notes
exmap DailyPrev  obcommand daily-notes:goto-prev
exmap DailyNext  obcommand daily-notes:goto-next


nnoremap <Space>dd :DailyToday<CR>
nnoremap <Space>dp :DailyPrev<CR>
nnoremap <Space>dn :DailyNext<CR>


" === Toggle Modes ===
exmap ReadingMode obcommand markdown:toggle-preview
exmap SourceMode obcommand editor:toggle-source

nnoremap <Space>mr :ReadingMode<CR>
nnoremap <Space>ms :SourceMode<CR>
