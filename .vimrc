
" vim-plug
call plug#begin('~/.vim/plugged')
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
Plug 'https://github.com/preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'https://github.com/flazz/vim-colorschemes'
Plug 'https://github.com/ctrlpvim/ctrlp.vim'
Plug 'https://github.com/airblade/vim-gitgutter' "git 修改
Plug 'jlanzarotta/bufexplorer' " ,be filelist
Plug 'https://github.com/vim-scripts/taglist.vim'
Plug 'https://github.com/zivyangll/git-blame.vim'
Plug 'vim-scripts/AutoComplPop'
Plug 'vim-scripts/lookupfile'
Plug 'vim-scripts/genutils' " bind with lookupfile
Plug 'vim-scripts/OmniCppComplete'
Plug 'vim-scripts/SuperTab'
Plug 'kshenoy/vim-signature' "命令和文件目录提示
Plug 'https://github.com/rking/ag.vim'
Plug 'https://github.com/mhinz/vim-startify' " start page
Plug 'https://github.com/lfv89/vim-interestingwords' " highlight word
" Plug 'https://github.com/Yggdroot/indentLine'   "缩进指示线
" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'
call plug#end()

"""""""""""""""""""""非映射"""""""""""""""""""""
" 设置鼠标
" set mouse=a

" set nu
set hlsearch "搜索高亮
set incsearch
set ignorecase "忽略大小写

" set wildmenu vim下的命令补全
set wildmenu
set wildmode=list:longest,full

" 设置光标所在行高亮
set cursorline
highlight CursorLine   cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE

"vim 保存时自动删除行尾空格"
autocmd BufWritePre * :%s/\s\+$//e

" 错误上没有恼人的声音,No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" let g:solarized_termcolors=256
set t_Co=256
syntax enable
syntax on  "语法高亮
colorscheme molokai
set autoread
filetype on                              "检测文件的类型

" set nu
set tabstop=4                        "tab 键默认4个空格长度
set noexpandtab                      "不扩展tab 到 空格
" set expandtab                      "扩展tab 到 空格
set smarttab
" set autoindent

set whichwrap+=<,>,h,l               "h l 可以跳到上下行
set splitright                       "window split时放在右侧

"显示tab键'
set list
set listchars=tab:>-,trail:-

"自动补全
inoremap ' ''<ESC>i
inoremap " ""<ESC>i
inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap { {<CR>}<ESC>O

" 显示中文
set helplang=cn

""""""""""""""""""""映射“”“”“”“”“”“”“”“”“”“”“”“
let mapleader = ","

" git-blame.vim.git
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

" nmap <C-v> "+p
nmap <leader>u :bn<cr>
nmap <leader>n :bp<cr>

"ag.vim
nmap <leader>g :norm yiw<CR>:Ag! -t -Q "<C-R>""

" NERDTree
let g:NERDTreeWinSize = 25 "设定 NERDTree 视窗大小
let NERDTreeShowBookmarks=1  " 开启Nerdtree时自动显示Bookmarks
let NERDTreeIgnore = ['\.pyc$', '\.swp', '\.swo', '\.vscode', '__pycache__']  " 过滤所有.pyc文件不显示
let g:NERDTreeHidden=0     "不显示隐藏文件

" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction
" Call NERDTreeFind if NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction
" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()

function! ToggleNerdTree()
  set eventignore=BufEnter
  NERDTreeToggle
  set eventignore=
endfunction
nmap <F3> :call ToggleNerdTree()<CR>


"leaderf
nmap ;f :LeaderfFunction<cr>
nmap ;b :LeaderfBuffer<cr>
nmap ;m :LeaderfMru<cr>

" taglist
:nmap <F4> :TlistToggle<CR>
let Tlist_Exit_OnlyWindow = 1          "如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Use_Right_Window = 1         "在右侧窗口中显示taglist窗口

"jj 退出编辑模式
inoremap jj <Esc>`^

" Fast saving
nmap <leader>w :w!<cr>
 " Fast quit
nmap <leader>q :q<cr>

"取消行号
nmap <leader>3 :set nonu<cr>
nmap <leader>4 :set nu<cr>

function! Docomment(comment)
    let lnum = line('.')
    let str_line = getline('.')
    let comm_ident = "\/\/"
    let syntax_type = &syntax
    if syntax_type == "vim"
        let comm_ident = "\""
    elseif syntax_type == "cpp" || syntax_type == "c" || syntax_type == "java" || syntax_type == "dts"
        let comm_ident = "\/\/"
    elseif syntax_type == "sh" || syntax_type == "rc" || syntax_type == "mk"
        let comm_ident = "#"
    else
        return
    endif

    if a:comment
        let str_line = substitute(str_line, "\\(\\S.*$\\)", comm_ident . " \\1", "")
        call setline(lnum, str_line)
    else
        let str_line = substitute(str_line, "\\(^\\s*\\)" . comm_ident ." \\?", "\\1", "")
        call setline(lnum, str_line)
    endif
endfunction

nmap <leader>c :call Docomment(1)<CR>
nmap <leader>x :call Docomment(0)<CR>


"tab 标签
nmap K :tabnext<CR>
nmap J :tabprev<CR>
nmap tn :tabnew<CR>
nmap tc :tabclose<CR>
nmap t0 :tablast<CR>
nmap t1 1gt
nmap t2 2gt
nmap t3 3gt
nmap t4 4gt
nmap t5 5gt
nmap t6 6gt
nmap t7 7gt
nmap t8 8gt
nmap t9 9gt

"""""""""""""""""""""插件”“”“”“”“”“”“”“”“”“”“”
if has("cscope")
        " set csprg=/usr/local/bin/cscope
        set csto=0
        set cscopetag
        set cst
        " set cscopequickfix=s-,c-,d-,i-,t-,e- " 使用QuickFix窗口来显示cscope查找结果
        set nocsverb
        " add anydatabase in current directory
        if filereadable("cscope.out")
            cs add cscope.out
        " else add database pointed to by environment
        elseif $CSCOPE_DB != ""
            cs add $CSCOPE_DB
        endif
        set csverb



    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
""''  nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
""''  nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
""''  nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
""''  nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
""''  nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
""''  nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
""''  nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
""''  nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>
""''
""''  nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
""''  nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
""''  nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
""''  nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
""''  nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
""''  nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
""''  nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
""''  nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>
endif

"设置tags
nmap <c-]> g<c-]>
set tags=tags;
" set autochdir

""""""""START CTRLP CONFIG"""""""""""""""""
" 快捷键说明
" <f5> 更新目录缓存。
" <ctrl+f> / <ctrl+b>  f(forward)，b指backward，切换成前一个或后一个搜索模式
" <ctrl+d> 在”完整路径匹配“ 和 ”文件名匹配“ 之间切换
" <ctrl+r> 在“字符串模式” 和 “正则表达式模式” 之间切换
" <ctrl+j> / <ctrl+k> 上下移动光标
" <ctrl+t> 在新的 tab 打开文件
" <ctrl+v> 垂直分割窗口打开文件
" <ctrl+x> 水平分割窗口打开
" <ctrl+p>, <ctrl+n> 选择历史记录
" <ctrl+y> 文件不存在时创建文件及目录
" <ctrl+z> 标记/取消标记， 标记多个文件后可以使用 <ctrl+o> 同时打开多个文件

"ctrlp.vim setting
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
"<Leader>搜索MRU文件
nmap <Leader>e :CtrlPMRUFiles<CR>
""<Leader>h显示缓冲区文件，并可通过序号进行跳转
nmap <Leader>h :CtrlPBuffer<CR>
"工程目录较大时使用这个
" nmap <Leader>p :CtrlP getcwd()<cr>
"设置搜索时忽略的文件
set wildignore+=*.so,*.class,*.swp,*.zip,*.png,*.jpg,*.gif,*.apk,*.dex,*.ap_,*/HTML/*,HTML/*,*.bin,*/bin/*,*.o,*.JPG,build*,*.out,*/Documentation/*
set wildignore+=*/android/*
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn|rvm|Documentation)$',
    \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
    \ 'link': 'some_bad_symbolic_links',
    \ }
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_match_window_bottom = 1
"修改QuickFix窗口显示的最大条目数
let g:ctrlp_max_height = 30
let g:ctrlp_match_window_reversed = 0
"设置MRU最大条目数为500
let g:ctrlp_mruf_max = 500
let g:ctrlp_follow_symlinks = 1
"默认使用全路径搜索，置1后按文件名搜索，准确率会有所提高，可以用<C-d>进行切换
let g:ctrlp_by_filename = 1
"默认不使用正则表达式，置1改为默认使用正则表达式，可以用<C-r>进行切换
let g:ctrlp_regexp = 0
"自定义搜索列表的提示符
let g:ctrlp_line_prefix = '♪ '

""""END CTRLP CONFIG""""


""""""""""""""""""""""""""""""
" lookupfile setting
""""""""""""""""""""""""""""""
let g:LookupFile_MinPatLength = 2               "最少输入2个字符才开始查找
let g:LookupFile_PreserveLastPattern = 0        "不保存上次查找的字符串
let g:LookupFile_PreservePatternHistory = 1     "保存查找历史
let g:LookupFile_AlwaysAcceptFirst = 1          "回车打开第一个匹配项目
let g:LookupFile_AllowNewFiles = 0              "不允许创建不存在的文件
if filereadable("./filenametags")                "设置tag文件的名字
let g:LookupFile_TagExpr = '"./filenametags"'
endif
"映射LookupFile为,lk
nmap <silent> <leader>lk :LUTags<cr>
"映射LUBufs为,ll
nmap <silent> <leader>ll :LUBufs<cr>
"映射LUWalk为,lw
nmap <silent> <leader>lw :LUWalk<cr>

"" END LOOKUPFILE SETTING

" 自动补全OmniCppComplete
set completeopt=menu,menuone
let OmniCpp_MayCompleteDot=1    " 打开  . 操作符
let OmniCpp_MayCompleteArrow=1  " 打开 -> 操作符
let OmniCpp_MayCompleteScope=1  " 打开 :: 操作符
let OmniCpp_NamespaceSearch=1   " 打开命名空间
let OmniCpp_GlobalScopeSearch=1
let OmniCpp_DefaultNamespace=["std"]
let OmniCpp_ShowPrototypeInAbbr=1  " 打开显示函数原型
let OmniCpp_SelectFirstItem = 2 " 自动弹出时自动跳至第一个

" SuperTab
let g:SuperTabRetainCompletionType=2


"""""""""""""""""""""""""""""""
" vim-gitgutter setting
"""""""""""""""""""""""""""""""
" set the default value of updatetime to 100ms
set updatetime=100
" git signs max 500
let g:gitgutter_max_signs = 500
" next modify [c, ]c

"""""END vim-gitgutter"""""""""

"""""""""""""""""""""""""""""""
" indentLine
"""""""""""""""""""""""""""""""
" let g:indentLine_enabled = 1       " 显示缩进线
" let g:indentLine_char = '|'        " 缩进线的字符
" let g:indentLine_faster = 1        " 增加缩进线显示速度
" highlight IndentLine ctermfg=green  " 缩进线的颜色
"""""end indentLine""""""""""""

