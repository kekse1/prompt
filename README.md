<img src="https://kekse.biz/github.php?draw&override=github:prompt" />

# My notorious **`$PS1`** prompt
By using the `$PROMPT_COMMAND` variable, this script dynamically created the `$PS1` prompt.

## Screenshot
![$PS1](img/prompt.png)

## **`prompt.sh`**
* [Version **v2.1.2**](sh/prompt.sh) (updated **2024-04-10**)

### Installation
Copy this file to `/etc/profile.d/[prompt.sh]`. This should `source` (`.`) it automatically.

### Configuration
The configuration is located on top of the file.

//**TODO**/ Explain all configuration variables!!

### Details
//**TODO**/ Describe the available features!!

### Implementation
It also has a `getBase()` function to reduce the amount of slash `/` separators
in the directory depth.. with a bit of intelligence.

# Copyright and License
The Copyright is [(c) Sebastian Kucharczyk](./COPYRIGHT.txt),
and it's licensed under the [MIT](./LICENSE.txt) (also known as 'X' or 'X11' license).

![kekse.biz](favicon.png)

