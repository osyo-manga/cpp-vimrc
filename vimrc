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
	let &l:path = join(filter(split($VIM_CPP_INCLUDE_DIR, '[,;]'), 'isdirectory(v:val)'), ',')

	" 括弧を構成する設定に <> を追加する
	" template<> を多用するのであれば
	setlocal matchpairs+=<:>

	" BOOST_PP_XXX 等のハイライトを行う
	syntax match boost_pp /BOOST_PP_[A-z0-9_]*/
	highlight link boost_pp cppStatement

	if exists("*CppVimrcFileType_cpp")
		call CppVimrcFileType_cpp()
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



filetype plugin indent on
syntax enable


" インストールのチェック
NeoBundleCheck


" プラグインの設定
" これはプラグインが読み込まれた場合に有効になる

" neocomplcache
let s:hooks = neobundle#get_hooks("caw.vim")
function! s:hooks.on_source(bundle)
	" コメントアウトを切り替えるマッピング
	" <leader>c でカーソル行をコメントアウト
	" 再度 <leader>c でコメントアウトを解除
	" 選択してから複数行の <leader>c も可能
	nmap <leader>c <Plug>(caw:I:toggle)
	vmap <leader>c <Plug>(caw:I:toggle)
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



if exists("*CppVimrcPrePlugin")
	call CppVimrcPrePlugin()
endif


call neobundle#call_hook('on_source')



if exists("*CppVimrcFinish")
	call CppVimrcFinish()
endif



augroup vimrc-cpp
	autocmd!
	" filetype=cpp が設定された場合に関数を呼ぶ
	autocmd FileType cpp call s:cpp()
augroup END






