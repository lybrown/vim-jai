" Vim syntax file
" Language: jai
" Maintainer: Lyren Brown

syn match jaiWord "\h\w*" " Prevent Number from matching inside word

syn keyword jaiKeyword xx cast break continue defer delete else enum for
syn keyword jaiKeyword free if it it_index
syn keyword jaiKeyword new return sizeof struct then using while
syn keyword jaiKeyword SOA CAST
syn keyword jaiLiteral true false null
syn keyword jaiType float float16 float32 float64
syn keyword jaiType int s64 s32 s16 s8 u64 u32 u16 u8 bool
syn keyword jaiType string void

syn match jaiStatement "::"
syn match jaiStatement ":"
syn match jaiStatement "="
syn match jaiStatement ":="
syn match jaiOperation "\."
syn match jaiOperation "+"
syn match jaiOperation "-"
syn match jaiOperation "!"
syn match jaiOperation "=="
syn match jaiOperation "!="
syn match jaiOperation "<"
syn match jaiOperation ">"
syn match jaiOperation ">="
syn match jaiOperation "<="
syn match jaiOperation "\*"
syn match jaiOperation "<<"
syn match jaiOperation "/"
syn match jaiOperation "%"
syn match jaiOperation "&&"
syn match jaiOperation "||"
syn match jaiStatement "+="
syn match jaiStatement "-="
syn match jaiStatement "*="
syn match jaiStatement "/="
syn match jaiLiteral "---"
syn match jaiFunction "->"
syn match jaiNote "@[^ \t\n]\+"
syn match jaiPoly "\$\w\+"
syn match jaiDirective "#\w\+"
syn match jaiNumber "[-+]\?\(\d\+\(\.\d\+\)\?\|\.\d\+\)\([eE][-+]\?\d\+\)\?"
syn match jaiNumber "0x[0-9A-Fa-f]\+"
syn match jaiTrailingSpace " \+$"
syn match jaiComment "//.*"
syn region jaiMultilineComment start=/\/\*/ end=/\*\// contains=jaiMultilineComment
syn region jaiString start=/"/ skip=/\\"/ end=/"/

hi def link jaiNumber Number
"hi def link jaiIdent Identifier
hi def link jaiKeyword Keyword
hi def link jaiStatement Identifier
hi def link jaiOperation Statement
hi def link jaiLiteral Constant
hi def link jaiDirective PreProc
hi def link jaiNote PreProc
hi def link jaiPoly PreProc
hi def link jaiFunction Identifier
hi def link jaiString String
hi def link jaiType Type
hi def link jaiComment Comment
hi def link jaiMultilineComment Comment

hi def link jaiTrailingSpace Error
