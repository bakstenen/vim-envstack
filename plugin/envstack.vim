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

function ReadEnvFile(env_file)
    let env = {}
    for line in readfile(a:env_file)
        let key = split(line, '=')[0]
        let value = split(line, '=')[1]
        let env[key] = value
    endfor
    return env
endfunction

function StackEnvValue(variable_name, base_value, override_value)
    let list_env = [
    \    'PATH', 'PYTHONPATH', 'PATHEXT', 'PSMODULEPATH'
    \]
    if exists('g:list_env')
        let list_env += g:list_env
    endif
    let path_sep = has('win64') || has ('win32') ? ';' : ':'

    if (
    \    count(list_env, a:variable_name) > 0
    \    || stridx(a:base_value, path_sep) > -1
    \)
        return a:override_value . path_sep . a:base_value
    else
        return a:override_value
    endif
endfunction

function StackEnv(base_env, override_env)
    let new_env = a:base_env
    for key in keys(a:override_env)
        if !has_key(new_env, key)
            let new_env[key] = a:override_env[key]
        else
            let new_env[key] = StackEnvValue(
            \    toupper(key), new_env[key], a:override_env[key]
            \)
        endif
    endfor
    return new_env
endfunction

function SetEnv(env_files)
    let new_env = eval(string(g:launch_env))
    for env_file in a:env_files
        let env_dict = ReadEnvFile(env_file)
        let new_env = StackEnv(new_env, env_dict)
    endfor
    for key in sort(keys(new_env))
        let altered_value = substitute(new_env[key], '\\', '\\\\', 'g')
        echo 'evaluating: let $' . key . '="' . altered_value . '"'
        exec('let $' . key . '="' . altered_value . '"')
    endfor
endfunction
