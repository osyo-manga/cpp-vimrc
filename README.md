#cpp-vimrc

vimrc of C++er.



##Introduction

C++er 用のサンプル vimrc です。
いくつかのプラグインの設定などが記述されています。
単体で使用することも可能ですし、改変して使用したり、一部を切り取って使用するなり好きにして下さい。


##Guideline

* C++er 向けの参考になる/汎用的な vimrc の提示が目的
* この vimrc を元に自分で設定などを追加して使用してもらう
 * ただし、単体でも使用可能
* なるべく余計なコードや設定は行わず簡素な vimrc を目指す
 * 需要があるのであればそのその限りではない
* プラグインの管理は [neobundle.vim](https://github.com/Shougo/neobundle.vim) を使用


##Requirement

* __Executable__
 * __[git](http://git-scm.com/)__



##Usage

* 1．この vimrc を読み込む、または自分の vimrc に組み込む
* 2．初回起動時に neobundle.vim がインストールされていなければインストールが行われる
 * 2.a．neobundle.vim がインストールされるディレクトリは $VIM_NEOBUNDLE_PLUGIN_DIR
 * 2.b．neobundle.vim のインストール後に Vim を再起動する必要がある
* 3．インストールされていないプラグインのインストールが行われる
 * 3.a．プラグインがインストールされるディレクトリは $VIM_NEOBUNDLE_PLUGIN_DIR
 * 3.b．プラグインのインストールには時間がかかるので注意
* 4．プラグインのインストールが終了したら利用する事が可能
* 5．以降、プラグインを更新する場合は `:NeoBundleUpdate` を使用する


##User setting

####環境変数

|環境変数|説明|デフォルト値|
|----|----|----|
|$VIM_NEOBUNDLE_PLUGIN_DIR|neobundle.vim のインストールディレクトリ|"~/.vim/bundle/"|
|$VIM_CPP_INCLUDE_DIR|C++ のインクルードディレクトリ|""|


####フラグ
1 が設定されている場合は有効になります。
これは本 vimrc が読み込まれる前に設定しておく必要があります。


|変数名|説明|デフォルト値|
|----|----|----|


####コールバック関数

|関数名|説明|
|----|----|
|CppVimrcFileType_cpp()|filetype=cpp 時に呼ばれる|
|CppVimrcPrePlugin()|プラグインの設定前に呼ばれる|
|CppVimrcFinish()|読み込みが終了して一番最後に呼ばれる|


####Example


```vim
" C++ のインクルードディレクトリ
" 複数の場合は , 区切りで設定
" default : ""
let $VIM_CPP_INCLUDE_DIR = "D:/home/work/software/lib/cpp/boost/boost_1_55_0,D:/home/work/software/lib/cpp/neobundle/Sprout"

let $VIM_NEOBUNDLE_PLUGIN_DIR = "$VIM/dotfiles/neobundle.vim/"
let $VIM_CPP_INCLUDE_DIR = "D:/home/work/software/lib/cpp/boost/boost_1_55_0,D:/home/work/software/lib/cpp/neobundle/Sprout"


" filetype=cpp の設定はこの関数内で行う
" set ではなくて setlocal を使用する
function! FileType_cpp()
	"タブ文字の長さ
	setlocal tabstop=4
	setlocal shiftwidth=4

	" 空白文字ではなくてタブ文字を使用する
	setlocal noexpandtab

	" 最後に定義された include 箇所へ移動してを挿入モードへ
	nnoremap <buffer><silent> <Space>ii :execute "?".&include<CR> :noh<CR> o
endfunction


" 一番最後に呼ばれる関数
" 設定などを上書きしたい場合に使用する
function! FinishCppVimrc()
	NeoBundleDisable "neocomplete.vim"
endfunction


" 以降に本 vimrc の設定を記述する
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```


##Default setting

* Vim 全体
 * 自動補完
* filetype=cpp のみ
 * <\> のハイライト
 * BOOST_PP_ から始まる単語のハイライト


####キーマッピング

|mode|key|description|
|----|----|----|
|nv||<leader>c|コメントアウトのトグル|


##Install plugins

* プラグイン管理プラグイン - [neobundle.vim](https://github.com/Shougo/neobundle.vim)
* C++ のシンタックス - [cpp-vim](https://github.com/vim-jp/cpp-vim)
* [](https://github.com/)


##License

[NYSL](http://www.kmonos.net/nysl/)

[NYSL http://www.kmonos.net/nysl/](http://www.kmonos.net/nysl/index.en.html)


