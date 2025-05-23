# snippets
Short function snippets

## bash: snippets to used in bash shells

### colours.bash
This holds 2 functions to show all the normal ANSI colours as well as set the
colours in variables for easy use in other scripts.

showcolours: show the 16 ANSI colours

setColours: set the colours as variable names.

### genpass.bash
A function to print a screen worth of random passwords taken from /dev/urandom.
Defaults to 16. You can change it by issuing the command with a number of
characters you want. Example:

```bash
genpass 32  # show a screen worth of 32 char passwords
```

### ssh.bash
Functions to help with ssh connections and usage.

sshtmp: temporarily connect to a host w/o saving nor remembering it's host key.

sshpub: show a list of all your public keys in your ~/.ssh directory

### tmpsh.bash
A function to help with temp shells and sandboxes.

tmpsh: create a shell in a random temp directory for testing. Exiting the shell removes the temp directory.
