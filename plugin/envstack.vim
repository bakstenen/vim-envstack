if exists("g:launch_env")
    finish
endif

let g:launch_env={}
let raw_env = environ()
for key in keys(raw_env)
    if stridx(key, '(') > 0 || stridx(key, '.') > 0 || !len(key)
        continue
    endif

    if has('win64') || has ('win32')
        let g:launch_env[toupper(key)] = raw_env[key]
    else
        let g:launch_env[key] = raw_env[key]
    endif
endfor
