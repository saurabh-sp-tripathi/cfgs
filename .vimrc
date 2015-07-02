" Отключить совместимость с vi.
set nocompatible

" Загрузить плагины.
execute pathogen#infect()

" Устанавливать размер отступа и загрузать плагины в зависимости от типа файла.
filetype indent plugin on

" Подсвечивать синтаксис файла.
syntax enable

" Как хранить символы внутри Vim.
set encoding=utf-8
" Список кодировок файлов для автоопределения.
set fileencodings=utf-8,cp1251,koi8-r,cp866
" Список форматов файлов.
set fileformats=unix,dos,mac
" Не делать бекапы.
set nobackup
" Не делать бекап перед перезаписыванием файла.
set nowb
" Не делать swap файлы.
set noswapfile

" Для нормального удаления символов перевода строк, отступов и места, где
" произошел переход в режим вставки, в нормальном режиме.
set backspace=indent,eol,start

" При использовании авто-дополнения в командной строке показывать доступные
" варианты над командной строкой.
set wildmenu

" Размер табуляции в пробелах.
set tabstop=4
" Количество пробелов при добавлении табуляции.
set softtabstop=4
" Заменять табуляцию на пробелы.
set expandtab
" Количество пробелов, добавляемых командами >> и <<.
set shiftwidth=4

" Копировать отступ предыдущей строки.
set autoindent
" Вставить дополнительный уровень идентации в некоторых случаях.
set smartindent

" Не заворачивать длинные строки.
set nowrap

" Показывать номера строк.
set number
" Подсвечивать текущую строку.
set cursorline
" Отключить мигание экрана и бипа при отображении ошибок.
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Включить отображение дополнительной информации в статусной строке.
set laststatus=2
set statusline=%f%h\ %y\ %m\ %r\ %{&encoding}\
set statusline+=%=Line:%l/%L[%p%%]\ Col:%c\ [%b][0x%B]
set statusline+=\ Buf:%n\

" Изменять заголовок окна. 
set title
" Задать заголовок вида: vim /path/to/file.
set titlestring=VIM:\ %-25.55F\ %a%r%m titlelen=70
" Показывать информацию о текущей строке, колонке, виртуальной колонке и
" относительной позиции курсора в файле.
set ruler
" Показывать информацию о набрнанной команде на последней строке экрана.
set showcmd
" Показывать текущий режим работы Vim.
set showmode
" Формат показываемой информации в правом нижнем углу.
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)

" Сохраняет обновление экрана в буфер вместо прямого вывода на экран. Полезно
" для быстрого перемещения по файлу.
set lazyredraw

" Подсвечивать результаты поиска в процессе набора.
set incsearch
" Подсвечивать результаты поиска.
set hlsearch
" Глобальный флаг замены по умолчанию.
set gdefault
" Игнорировать регистр символов при поиске командами / и ?.
set ignorecase
" Если шаблон содержит заглавный символ, то он будет учтен.
set smartcase

" Обновлять файл изменный извне.
set autoread

" Для улучшения сглаживания при перерисовки.
set ttyfast

" Количество команд, хранимых в истории.
set history=1000
" Количество состояний для возможной отмены.
set undolevels=1000

" Для того, чтобы курсор всегда находился посередине.
set scrolljump=7
set scrolloff=10
set sidescrolloff=10
set sidescroll=1

" Прятать несохраненный файл при открытии другого файла.
set hidden

" Заминать позицию перед выходом из файла. 
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" Нормальный режим по jj.
imap jj <Esc>
" По нажатию пробела выключить подсветку найденных шаблонов и очистить все
" выведенные сообщения.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

