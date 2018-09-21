" vim plugin to support email address completion via goobook
"
" Note that this plugin is heavily based on the following gist by Matthew Horan:
" http://recursivedream.com/blog/2012/auto-completing-google-contacts-in-vim/
"
" Authors: Alexander Lehmann <afwlehmann@googlemail.com>
"          Matthew Horan <matt@matthoran.com>

if exists("g:goobook_address")
  finish
else
  let g:goobook_address = 1
endif

" Escape query and handle goobook errors
function! goobook_complete#Complete(findstart, base)
    if a:findstart == 1
        let line = getline('.')
        let idx = col('.')
        while idx > 0
            let idx -= 1
            let c = line[idx]
            " break on header and previous email
            if c == ':' || c == '>'
                return idx + 2
            else
                continue
            endif
        endwhile
        return idx
    else
        if exists("g:goobookprg")
            let goobook=g:goobookprg
        elseif exists("g:goobookrc")
            let goobook="goobook -c " . g:goobookrc
        else
            let goobook="goobook"
        endif
        let res=system(goobook . ' query ' . shellescape(a:base))
        if v:shell_error
            return []
        else
            return goobook_complete#Format(goobook_complete#Trim(res))
        endif
    endif
endfunc

function! goobook_complete#Trim(res)
    let splits = split(a:res, '\r*\n')
    let splits = filter(splits, 'v:val != ""')                 " Remove empty lines
    let splits = filter(splits, 'v:val !~ "(other)$"')         " Remove lines ending with (other)
    return map(splits, "join(split(v:val, '\t')[0:1], '\t')")  " For each contact, keep the first
                                                               " two tab-separated chunks
endfunc

function! goobook_complete#Format(contacts)
    let contacts=map(copy(a:contacts), "split(v:val, '\t')")
    let ret=[]
    for [email, name] in contacts
        call add(ret, printf("%s <%s>", name, email))
    endfor
    return ret
endfunc

augroup goobook_address
  au!
  au FileType mail,notmuch-compose setlocal omnifunc=goobook_complete#Complete
  au BufRead /tmp/mutt-*,/tmp/neomutt-* setlocal omnifunc=goobook_complete#Complete
augroup END
