# vim-envstack
Vim plugin to set environment variables with env files


## Functions

*SetEnv({env_files})*

Set the environment based on a list of .env files. Environment variables in later env files will overwrite environment variables in earlier files.

For list type variables, the new values are prepended to the existing value
with the os specific path separator.

Standard list environment variables are
* PATH
* PYTHONPATH
* PATHEXT
* PSMODULEPATH

## Global variables

*g:list_env*

Use this to define additional list type environment variables
