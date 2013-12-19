scriptencoding utf-8

" 各種設定
if has('vim_starting')
	set nocompatible
endif


" C++ の設定
" FileType_cpp() 関数が定義されていれば最後にそれを呼ぶ
function! s:cpp()
	" インクルードパスを設定する
	" gf などでヘッダーファイルを開きたい場合に影響する
	let &l:path = join(filter(split($VIM_CPP_STDLIB . "," . $VIM_CPP_INCLUDE_DIR, '[,;]'), 'isdirectory(v:val)'), ',')

	" 括弧を構成する設定に <> を追加する
	" template<> を多用するのであれば
	setlocal matchpairs+=<:>

	" BOOST_PP_XXX 等のハイライトを行う
	syntax match boost_pp /BOOST_PP_[A-z0-9_]*/
	highlight link boost_pp cppStatement

	" quickrun.vim の設定
	let b:quickrun_config = {
\		"hook/add_include_option/enable" : 1
\	}

	if exists("*CppVimrcOnFileType_cpp")
		call CppVimrcOnFileType_cpp()
	endif
endfunction



" 括弧を入力した時にカーソルが移動しないように設定
set matchtime=0

" CursorHold の更新間隔
set updatetime=1000


let c_comment_strings=1
let c_no_curly_error=1


" プラグインのインストールディレクトリ
let s:neobundle_plugins_dir = expand(exists("$VIM_NEOBUNDLE_PLUGIN_DIR") ? $VIM_NEOBUNDLE_PLUGIN_DIR : '~/.vim/bundle')


" インクルードディレクトリ
let s:cpp_include_dirs = expand(exists("$VIM_CPP_INCLUDE_DIR") ? $VIM_CPP_INCLUDE_DIR : '')


" shell の設定
if has('win95') || has('win16') || has('win32')
	set shell=C:\WINDOWS\system32\cmd.exe
endif



" プラグインの読み込み
if !executable("git")
	echo "Please install git."
	finish
endif


if !isdirectory(s:neobundle_plugins_dir . "/neobundle.vim")
	echo "Please install neobundle.vim."
	function! s:install_neobundle()
		if input("Install neobundle.vim? [Y/N] : ") =="Y"
			if !isdirectory(s:neobundle_plugins_dir)
				call mkdir(s:neobundle_plugins_dir, "p")
			endif

			execute "!git clone git://github.com/Shougo/neobundle.vim "
			\ . s:neobundle_plugins_dir . "/neobundle.vim"
			echo "neobundle installed. Please restart vim."
		else
			echo "Canceled."
		endif
	endfunction
	augroup install-neobundle
		autocmd!
		autocmd VimEnter * call s:install_neobundle()
	augroup END
	finish
endif


" neobundle.vim でプラグインを読み込む
" https://github.com/Shougo/neobundle.vim
if has('vim_starting')
	execute "set runtimepath+=" . s:neobundle_plugins_dir . "/neobundle.vim"
endif

call neobundle#rc(s:neobundle_plugins_dir)


" neobundle 自身を neobundle で管理
NeoBundleFetch "Shougo/neobundle.vim"


" 各プラグインの読み込み
" プラグインの読み込みを行いたくない場合はコメントアウトして下さい


" コメントアウト
NeoBundle "tyru/caw.vim"



" 汎用的なコード補完プラグイン
" +lua な環境であれば neocomplete.vim を利用する
if has("lua")
	NeoBundle "Shougo/neocomplete.vim"
else
	NeoBundle "Shougo/neocomplcache"
endif

" スニペット
NeoBundle "Shougo/neosnippet.vim"

" unite.vim
NeoBundle "Shougo/unite.vim"

" アウトラインの出力
NeoBundle "Shougo/unite-outline"


" C++ のシンタックス
NeoBundle "vim-jp/cpp-vim"

" wandbox
NeoBundle "rhysd/wandbox-vim"

" コード補完
NeoBundle "osyo-manga/vim-marching"

" コードの実行
NeoBundle "thinca/vim-quickrun"


" quickfix の該当箇所をハイライト
NeoBundle "jceb/vim-hier"

" シンタックスチェッカー
NeoBundle "osyo-manga/vim-watchdogs"
NeoBundle "osyo-manga/shabadou.vim"



" vimproc.vim
" vimproc.vim を使用する場合は自前でビルドする必要があり
" kaoriya 版 vim では vimproc.vim が同梱されているので必要がないです
if !has("kaoriya")
	NeoBundle 'Shougo/vimproc.vim', {
	\ 'build' : {
	\     'windows' : 'make -f make_mingw32.mak',
	\     'cygwin' : 'make -f make_cygwin.mak',
	\     'mac' : 'make -f make_mac.mak',
	\     'unix' : 'make -f make_unix.mak',
	\    },
	\ }
endif




if exists("*CppVimrcOnNeoBundle")
	call CppVimrcOnNeoBundle()
endif




filetype plugin indent on
syntax enable


" インストールのチェック
NeoBundleCheck


" プラグインの設定
" これはプラグインが読み込まれた場合に有効になる

" caw.vim
let s:hooks = neobundle#get_hooks("caw.vim")
function! s:hooks.on_source(bundle)
	" コメントアウトを切り替えるマッピング
	" <leader>c でカーソル行をコメントアウト
	" 再度 <leader>c でコメントアウトを解除
	" 選択してから複数行の <leader>c も可能
	nmap <leader>c <Plug>(caw:I:toggle)
	vmap <leader>c <Plug>(caw:I:toggle)

	" <leader>C でコメントアウトを解除
	nmap <Leader>C <Plug>(caw:I:uncomment)
	vmap <Leader>C <Plug>(caw:I:uncomment)

endfunction
unlet s:hooks


" neocomplet.vim
let s:hooks = neobundle#get_hooks("neocomplete.vim")
function! s:hooks.on_source(bundle)
	" 補完を有効にする
	let g:neocomplete#enable_at_startup = 1

	" 補完に時間がかかってもスキップしない
	let g:neocomplete#skip_auto_completion_time = ""
endfunction
unlet s:hooks


" neocomplcache
let s:hooks = neobundle#get_hooks("neocomplcache")
function! s:hooks.on_source(bundle)
	" 補完を有効にする
	let g:neocomplcache_enable_at_startup=1
endfunction
unlet s:hooks


" neosnippet.vim
let s:hooks = neobundle#get_hooks("neosnippet.vim")
function! s:hooks.on_source(bundle)
	" スニペットを展開するキーマッピング
	" <Tab> で選択されているスニペットの展開を行う
	" 選択されている候補がスニペットであれば展開し、
	" それ以外であれば次の候補を選択する
	" また、既にスニペットが展開されている場合は次のマークへと移動する
	imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
	\ "\<Plug>(neosnippet_expand_or_jump)"
	\: pumvisible() ? "\<C-n>" : "\<TAB>"
	smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
	\ "\<Plug>(neosnippet_expand_or_jump)"
	\: "\<TAB>"

	let g:neosnippet#snippets_directory = "~/.neosnippet"

	" 現在の filetype のスニペットを編集する為のキーマッピング
	" こうしておくことでサッと編集や追加などを行うことができる
	" 以下の設定では新しいタブでスニペットファイルを開く
	nnoremap <Space>ns :execute "tabnew\|:NeoSnippetEdit ".&filetype<CR>
endfunction
unlet s:hooks


" marching.vim
let s:hooks = neobundle#get_hooks("vim-marching")
function! s:hooks.on_post_source(bundle)
	if !empty(g:marching_clang_command) && executable(g:marching_clang_command)
		" 非同期ではなくて同期処理で補完する
		let g:marching_backend = "sync_clang_command"
	else
		" clang コマンドが実行できなければ wandbox を使用する
		let g:marching_backend = "wandbox"
		let g:marching_clang_command = ""
	endif

	" オプションの設定
	" これは clang のコマンドに渡される
	let g:marching_clang_command_option="-std=c++1y"

	if !neobundle#is_sourced("neocomplete.vim")
		return
	endif

	" neocomplete.vim と併用して使用する場合
	" neocomplete.vim を使用すれば自動補完になる
	let g:marching_enable_neocomplete = 1

	if !exists('g:neocomplete#force_omni_input_patterns')
		let g:neocomplete#force_omni_input_patterns = {}
	endif

	let g:neocomplete#force_omni_input_patterns.cpp =
		\ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
	endfunction
unlet s:hooks


" quickrun.vim
let s:hooks = neobundle#get_hooks("vim-quickrun")
function! s:hooks.on_source(bundle)
	let g:quickrun_config = {
\		"_" : {
\			"runner" : "vimproc",
\			"runner/vimproc/sleep" : 10,
\			"runner/vimproc/updatetime" : 500,
\			"outputter" : "error",
\			"outputter/error/success" : "buffer",
\			"outputter/error/error"   : "quickfix",
\			"outputter/quickfix/open_cmd" : "copen",
\			"outputter/buffer/split" : ":botright 8sp",
\		},
\		"cpp/wandbox" : {
\			"runner" : "wandbox",
\			"runner/wandbox/compiler" : "clang-head",
\			"runner/wandbox/options" : "warning,c++1y,boost-1.55",
\		},
\	}

	let s:hook = {
	\	"name" : "add_include_option",
	\	"kind" : "hook",
	\	"config" : {
	\		"option_format" : "-I%s"
	\	},
	\}

	function! s:hook.on_normalized(session, context)
		" filetype==cpp 以外は設定しない
		if &filetype !=# "cpp"
			return
		endif
		let paths = filter(split(&path, ","), "len(v:val) && v:val !='.' && v:val !~ $CPP_STDLIB")
		
		if len(paths)
			let a:session.config.cmdopt .= " " . join(map(paths, "printf(self.config.option_format, v:val)")) . " "
		endi
	endfunction

	call quickrun#module#register(s:hook, 1)
	unlet s:hook


	let s:hook = {
	\	"name" : "clear_quickfix",
	\	"kind" : "hook",
	\}

	function! s:hook.on_normalized(session, context)
		call setqflist([])
	endfunction

	call quickrun#module#register(s:hook, 1)
	unlet s:hook

endfunction
unlet s:hooks



if exists("*CppVimrcOnPrePlugin")
	call CppVimrcOnPrePlugin()
endif


call neobundle#call_hook('on_source')



if exists("*CppVimrcOnFinish")
	call CppVimrcOnFinish()
endif



augroup vimrc-cpp
	autocmd!
	" filetype=cpp が設定された場合に関数を呼ぶ
	autocmd FileType cpp call s:cpp()
augroup END






