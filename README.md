#cpp-vimrc

vimrc of C++er.



##Introduction

C++er 用のサンプル vimrc です。
いくつかのプラグインの設定などが記述されています。
単体で使用することも可能ですし、改変して使用したり、一部を切り取って使用するなり好きにして下さい。


##Guideline

* C++er 向けの参考になる/汎用的な vimrc の提示が目的
 * あくまでも C++er 向けの vimrc を目指しているので C++ に直接関係のない設定は記述しない方向
* この vimrc を元に自分で設定などを追加して使用してもらう
 * ただし、単体でも使用可能
* なるべく余計なコードや設定は行わず簡素な vimrc を目指す
 * 需要があるのであればそのその限りではない
* プラグインの管理は [neobundle.vim](https://github.com/Shougo/neobundle.vim) を使用


##Requirement

* __[git](http://git-scm.com/)__
* __[vimproc.vim](https://github.com/Shougo/vimproc.vim)__
 * Windows 環境であれば自前でビルドする必要がある
 * Windows 以外であれば neobundle.vim が自動的にビルドを行う
 * [Kaoriya 版 Vim](http://www.kaoriya.net/software/vim/) であれば vimproc.vim が同梱されているので自前で用意する必要はない



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
|$VIM_CPP_STDLIB|C++ の標準ライブラリへのパス|""|
|$VIM_CPP_INCLUDE_DIR|C++ のインクルードディレクトリ|""|


####フラグ
1 が設定されている場合は有効になります。
これは本 vimrc が読み込まれる前に設定しておく必要があります。


|変数名|説明|デフォルト値|
|----|----|----|


####コールバック関数

|関数名|説明|
|----|----|
|CppVimrcOnFileType_cpp()|filetype=cpp 時に呼ばれる|
|CppVimrcOnPrePlugin()|プラグインの設定前に呼ばれる|
|CppVimrcOnFinish()|読み込みが終了して一番最後に呼ばれる|


####Example


```vim
" neobundle.vim がインストールするプラグインへのパス
" neobundle.vim もこのディレクトリにインストールが行われる
" default : ""
let $VIM_NEOBUNDLE_PLUGIN_DIR = "~/.vim/bundle"

" C++ の標準ライブラリへのパス
" $VIM_CPP_INCLUDE_DIR とは別に設定しておく
" default : ""
let $VIM_CPP_STDLIB = "C:/MinGW/lib/gcc/mingw32/4.6.2/include/c++"

" C++ のインクルードディレクトリ
" 複数の場合は , 区切りで設定
" default : ""
let $VIM_CPP_INCLUDE_DIR = "D:/home/cpp/boost/boost_1_55_0,D:/home/cpp/Sprout"


" filetype=cpp の設定はこの関数内で行う
" set ではなくて setlocal を使用する
function! CppVimrcOnFileType_cpp()
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

####Vim 全体
* 自動的に neobundle.vim の`git clone` を行う
* 自動補完
 * バッファ内のワード
 * シンタックス
 * ファイル名
* Wandbox でコードの実行
 * wandbox.vim
* アウトラインの出力
 * `:Unite outline`
* バッファのコードを実行
 * `:QuickRun` or `<leader>r`
* quickrun 時に実行が成功すればバッファへ、失敗すれば quickfix へと結果を出力する
 * その為、出力はバッファリングされます
* quickrun の出力バッファのウィンドウは `botright` で開く
* quickfix のエラー箇所のハイライト
* 保存時にシンタックスチェックを行う


####filetype=cpp のみ
* `'matchpairs'` に <\> を追加
* BOOST\_PP\_ から始まる単語のハイライト
* marching.vim を使用した高度なコード補完
* #include 時のヘッダーファイル名の補完
* quickrun 時に 'path' のディレクトリをインクルードオプションとして設定


####キーマッピング

|モード|キー|説明|
|----|----|----|
|nv|&lt;Leader&gt;c|コメントアウトのトグル|
|nv|&lt;Leader&gt;C|コメントアウトを解除|
|nx|&lt;Space&gt;m|カーソル下のワードのハイライトのトグル|
|nx|&lt;Space&gt;M|&lt;Space&gt;m で設定した全てのハイライトの解除|
|n|&lt;Space&gt;ns|スニペットファイルの編集|
|is||&lt;Tab&gt;|スニペットの展開|


##Install plugins

* [neobundle.vim](https://github.com/Shougo/neobundle.vim) - プラグイン管理プラグイン
* [cpp-vim](https://github.com/vim-jp/cpp-vim) - C++ のシンタックス
* [wandbox-vim](https://github.com/rhysd/wandbox-vim) - Wandbox でコードの実行
* [marching.vim](https://github.com/osyo-manga/vim-marching) - Clang を使用したコード補完
* [quickrun.vim](https://github.com/thinca/vim-quickrun) - コードの実行
* [vimproc.vim](https://github.com/Shougo/vimproc.vim) - 非同期で外部コマンドを実行
* [vim-hier](https://github.com/jceb/vim-hier) - quickfix の該当箇所をハイライト
* [neocomplete.vim](https://github.com/Shougo/neocomplete.vim) - コード補完
* [neosnippet.vim](https://github.com/Shougo/neosnippet.vim) - スニペット
* [unite.vim](https://github.com/Shougo/unite.vim) - unite.vim
* [unite-outline](https://github.com/Shougo/unite-outline) - アウトラインの表示
* [caw.vim](https://github.com/tyru/caw.vim) - コメントアウト
* [vim-quickhl](https://github.com/t9md/vim-quickhl) - カーソル下のワードのハイライト


##Screencapture


####caw.vim
![caw](https://f.cloud.github.com/assets/214488/1780800/041ae102-6883-11e3-926f-4007ca8b91cf.gif)


####unite-outline
![unite_outline](https://f.cloud.github.com/assets/214488/1779845/b889ba84-6859-11e3-9a23-51eedb171131.PNG)


####unite-file_include
![file_include](https://f.cloud.github.com/assets/214488/1779950/97029b30-685c-11e3-8be6-fb1bf8889c4f.PNG)


####neocomplete.vim
![file](https://f.cloud.github.com/assets/214488/1779896/dad7008c-685a-11e3-8ff9-9471f4c779fd.png)

![syntax](https://f.cloud.github.com/assets/214488/1779905/06ac3038-685b-11e3-91d0-0c85db54d11c.png)

![file_include](https://f.cloud.github.com/assets/214488/1780557/d182211a-6878-11e3-88a8-0bd8c5ff7252.gif)


####marching.vim
![marching](https://f.cloud.github.com/assets/214488/1779935/22c5271a-685c-11e3-97f1-2e9e6fb84720.PNG)


####neosnippet.vim
![neosnippet](https://f.cloud.github.com/assets/214488/1780088/64816da2-6862-11e3-8582-1b0ab238f02f.gif)


####quickrun.vim
#####成功
![success](https://f.cloud.github.com/assets/214488/1780264/729b479c-686b-11e3-9a8c-0f095c06d9fb.PNG)


#####失敗
![error](https://f.cloud.github.com/assets/214488/1780270/b1010030-686b-11e3-937a-3b662a6e6550.PNG)


##License

[NYSL](http://www.kmonos.net/nysl/)

[NYSL English](http://www.kmonos.net/nysl/index.en.html)


