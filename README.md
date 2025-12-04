<img src="https://kekse.biz/github.php?draw&override=github:prompt" />

<br>

# My notorious **`$PS1`** prompt
By using the **`$PROMPT_COMMAND`** variable, this script dynamically
creates the **`$PS1` prompt**.

* [Version v**2.9.3**](src/prompt.sh) (updated **2025-12-04**)

<br>

![kinda logo](img/logo.png)

<br><br>

## News
* \[**2025-12-04**\] Changed colors/style, just a little bit.. v**2.9.3**;
* \[**2025-11-25**\] Tiny change (where using `find`), v**2.9.2**;
* \[**2025-05-19**\] Tiny change of `$_TERMUX` defaults: w/ `$_USERNAME` now, but w/o `$_HOSTNAME`; v**2.9.1**.
* \[**2025-05-15**\] "Alles ist besser mit Bluetooth!" ... v**2.9.0**.
* \[**2025-05-04**\] Beautified it a bit, renamed two [config variables](#configuration), and a bit more. .. v**2.8.0**!
* \[**2025-05-03**\] Two new [configuration](#configuration) items! Update to v**2.7.0**.
* \[**2025-03-10**\] Also updated the [example screenshot](#screenshot);
* \[**2025-03-10**\] v**2.6.2** w/ some changed colors. Looks a bit better now (imho);
* \[**2025-03-05**\] v**2.6.1** w/ correct `local` everywhere; plus better listings
* \[**2025-03-03**\] Update to v**2.5.2**: new [config](#configuration) variable `$_CODE`!
* \[**2025-03-01**\] Update to v**2.4.0**: new **`_TTY`** [configuration](#configuration);
* \[**2025-03-01**\] Update to v**2.3.0**: including `ls` output **if `$PWD` changed** (see `$_LIST` [config](#configuration));
* \[**2024-07-12**\] New v**2.1.5**. Both 'root' colors (UID+GID) have changed;

<br><br>

## Screenshot
![$PS1](img/example.png)

<br><br>

### Installation
Copy this file to the **`/etc/profile.d/`** directory. This should include it automatically
when spawning a new shell etc. (via `source` or `.`).

<br>

### Configuration
The configuration is located on top of the file (as simple variables, which will be enforced
into your environments where you include this script).

> [!TIP]
> If you want to test them, or just change the config during usage, you can easily
> **change the variables in your console**! Example given: `_LIST=0` will
> **temporarily** disable the directory listings. After/with the next login
> the values will be the original ones, right as defined in the script/file.

| Variable name           | Type    | Default    | Description                                                                                                                    |
| ----------------------: | ------: | :--------- | :----------------------------------------------------------------------------------------------------------------------------- |
| **`$_SUCCESS`**         | Boolean | 0          | Display success (`$?`), or only in case of errors?                                                                             |
| **`$_SPACE`**           | Boolean | 1          | Spaces between the blocks?                                                                                                     |
| **`$_CODE`**            | Boolean | 1          | Instead of indicating errors (return values != 0) with an ✘, the real error code is being displayed.                           |
| **`$_TTY`**             | Boolean | 1          | Includes the currently used **tty** in it's output                                                                             |
| **`$_LIST`**            | Boolean | 1          | When directory changes(!), you'll get to see it's contents.                                                                    |
| **`$_TERMUX`**          | Boolean | 0          | Will enforce some settings to fit better to the [`Termux` Linux](https://termux.dev/) (for Android phones)                     |
| **`$_ANSI`**            | Boolean | 1          | Here you could also disable all ANSI Escape Sequences (for colors and styles)                                                  |
| **`$_MULTI_LINE`**      | Boolean | 1          | Looks better when using a two line prompt                                                                                      |
| **`$_DEPTH`**           | Integer | 4          | The amount of directories to show in your current working directory.. see the [`getBase()`](#getbase) section                  |
| **`$_REST_STRING`**     | String  | `...`      | Also for the [`getBase()`](#getbase) function: the cut off parts of your current working directory are replaced by this string |
| **`$_COUNT`**           | Boolean | 1          | Will also show the amount of directories and regular files in the current working directory                                    |
| **`$_HOSTNAME`**        | Boolean | 1          | Also show your machine's hostname (if set, directly at the username)                                                           |
| **`$_USERNAME`**        | Boolean | 1          | Would also include your username in the output (if set, directly at the hostname)                                              |
| **`$_LOAD`**            | Boolean | 1          | The load average (parsing the `/proc/loadavg`; if not readable or available, it'll be ignored)                                 |
| **`$_DATE`**            | Boolean | 1          | Depends on the both variables below [ `$_DATE_FORMAT_ONE` and `$_DATE_FORMAT_TWO` ]                                            |
| **`$_DATE_FORMAT_ONE`** | String  | `%H:%M:%S` | First `date` format; by default only the current time (the date in the `$_DATE_FORMAT_TWO`)                                    |
| **`$_DATE_FORMAT_TWO`** | String  | `%j`       | Second `date` format; by default the number of current days in the year                                                        |

The `Boolean` types are just `Integer` values with either `0` as `false` or `1` as `true`.

<br>

### Details
It's also using **ANSI Escape Sequences** to colorize up the prompt (if you don't disable it via `$_ANSI`
[configuration](#configuration) variable).

#### `getBase()`
It also has a `getBase()` function to reduce the amount of slash `/` separators in the directory depth..
with a bit of intelligence. See also the [configuration](#configuration) variables [ `$_SLASHES`, `$_REST_STRING` ];

<br><br>

# Contact
<img src="https://kekse.biz/github.php?override=github:prompt&draw&text=prompt@kekse.biz&angle=6&size=38pt&fg=150,20,90&font=OpenSans&ro&readonly&h=64&v=16" />

# Copyright and License
The Copyright is [(c) Sebastian Kucharczyk](./COPYRIGHT.txt),
and it's licensed under the [MIT](./LICENSE.txt) (also known as 'X' or 'X11' license).

<a href="https://kekse.biz/">
<img src="favicon.png" alt="Favicon" />
</a>

