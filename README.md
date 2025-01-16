<img src="https://kekse.biz/github.php?draw&override=github:prompt" />

# My notorious **`$PS1`** prompt
By using the **`$PROMPT_COMMAND`** variable, this script dynamically created the **`$PS1` prompt**.

* [Version **v2.1.5**](sh/prompt.sh) (updated **2024-07-15**)

## News
* \[**2024-07-12**\] New **v2.1.5**. Both 'root' colors (UID+GID) have changed (so screenshot is slightly out-of-date);

## Screenshot
![$PS1](img/screenshot.png)

### Explanation
//**TODO**/.. for now, look at the [**Configuration**](#configuration) section.

### Installation
Copy this file to the **`/etc/profile.d/`** directory. This should include it automatically
when spawning a new shell etc. (via `source` or `.`).

> [!IMPORTANT]
> **If** this won't work, the reason could be other scripts which overwrite the `$PS1` or so.
> In this case you could try to `grep -r PS1 /etc/` and fix it for yourself.

### Configuration
The configuration is located on top of the file (as simple variables, which will be enforced
into your environments where you include this script).

> [!TIP]
> To test various constellations, you could also just set 'em in your command line
> (after `source`ing this script). This will have an instant effect.

The `Boolean` types are just `Integer` values with either `0` as `false` or any other
(like `1`) for `true`.

| Variable name           | Type    | Default    | Description                                                                                                                    |
| ----------------------: | ------: | :--------- | :----------------------------------------------------------------------------------------------------------------------------- |
| **`$_TERMUX`**          | Boolean | 0          | Will enforce some settings to fit better to the [`Termux` Linux](https://termux.dev/) (for Android phones)                     |
| **`$_ANSI`**            | Boolean | 1          | Here you could also disable all ANSI Escape Sequences (for colors and styles)                                                  |
| **`$_MULTI_LINE`**      | Boolean | 1          | Looks better when using a two line prompt                                                                                      |
| **`$_SLASHES`**         | Integer | 4          | The amount of directories to show in your current working directory.. see the [`getBase()`](#getbase) section                  |
| **`$_REST_STRING`**     | String  | `...`      | Also for the [`getBase()`](#getbase) function: the cut off parts of your current working directory are replaced by this string |
| **`$_WITH_FILES`**      | Boolean | 1          | Will also show the amount of directories and regular files in the current working directory                                    |
| **`$_WITH_HOSTNAME`**   | Boolean | 1          | Also show your machine's hostname (if set, directly at the username)                                                           |
| **`$_WITH_USERNAME`**   | Boolean | 1          | Would also include your username in the output (if set, directly at the hostname)                                              |
| **`$_WITH_LOAD`**       | Boolean | 1          | The load average (parsing the `/proc/loadavg`; if not readable or available, it'll be ignored)                                 |
| **`$_WITH_DATE`**       | Boolean | 1          | Depends on the both variables below [ `$_DATE_FORMAT_ONE` and `$_DATE_FORMAT_TWO` ]                                            |
| **`$_DATE_FORMAT_ONE`** | String  | `%H:%M:%S` | First `date` format; by default only the current time (the date in the `$_DATE_FORMAT_TWO`)                                    |
| **`$_DATE_FORMAT_TWO`** | String  | `%j`       | Second `date` format; by default the number of current days in the year                                                        |

### Details
It's also using **ANSI Escape Sequences** to colorize up the prompt (if you don't disable it via `$_ANSI`
[configuration](#configuration) variable).

#### `getBase()`
It also has a `getBase()` function to reduce the amount of slash `/` separators in the directory depth..
with a bit of intelligence. See also the [configuration](#configuration) variables [ `$_SLASHES`, `$_REST_STRING` ];

# Contact
<img src="https://kekse.biz/github.php?override=github:prompt&draw&text=prompt@kekse.biz&angle=6&size=38pt&fg=150,20,90&font=OpenSans&ro&readonly&h=64&v=16" />

# Copyright and License
The Copyright is [(c) Sebastian Kucharczyk](./COPYRIGHT.txt),
and it's licensed under the [MIT](./LICENSE.txt) (also known as 'X' or 'X11' license).

<a href="https://kekse.biz/">
<img src="favicon.png" alt="Favicon" />
</a>

