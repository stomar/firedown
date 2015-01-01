firedown - file-based (remote) shutdown
=======================================

`firedown` is a command line tool (written in [Ruby][Ruby])
that enables a remote shutdown of a Linux system
via Dropbox or other file synchronization services.

`firedown` monitors a specified directory (or several directories)
on the system for the presence of a trigger file or directory.
If a trigger is found, `firedown` issues a shutdown.

The monitored directory might be synchronized via remote services
like Dropbox, thus enabling a remotely triggered shutdown of the system.

Usage
-----

Set up `firedown`:

1.  Schedule a cron job on the machine(s) you might want to bring down
    remotely, specifying the directories that should be monitored
    (root privileges are needed).

    For example, to check every minute for the trigger file,
    include a line similar to this in `/etc/crontab`:

        * *   * * *   root   firedown -l /path/to/monitored/directory

2.  Alternatively, start `firedown` as a daemon process
    (again with root privileges):

        firedown --daemon /path/to/monitored/directory

    (Depending on the search path for root on your machine and on how you
    installed `firedown`, you might need to invoke `firedown` using its
    full path.)

Bring down the system by creating `firedown.host` as empty trigger file
or as empty directory in any of the monitored directories,
where `host` is the hostname of the system you want to bring down.
(With Dropbox this can be done over the web interface.)

As soon as a trigger file is detected in any of the monitored
directories, a shutdown with a delay of 60 seconds will be issued.
To prevent shutdowns from being triggered repeatedly by the
same file, the system will only be brought down when the trigger
previously has been removed successfully.

If run as a daemon, `firedown` writes messages to `/var/log/firedown.log`.
In non-daemon mode use the `--log` or `-l` option to write messages
to the log file instead of stderr.

You can set the logging level (`warn`, `info`, or `debug`)
with e.g. `--logging-level debug` (the default is `info`).
In daemon mode, you can toggle to `debug` level and back
by sending the `SIGUSR1` signal to the `firedown` process.

For testing, use the `--no-act` or `-n` option and the shutdown will
not be issued.

Remarks
-------

- To prevent loss of data,
  only empty files and directories will trigger a shutdown.

- Several machines sharing the same synchronized directory
  can be controlled individually, since each requires
  a different trigger file.

- No code in the shared directory is executed.

- No file needs to be edited.

Installation
------------

You can either

- clone or download the `firedown` repository and
  use `[sudo] rake install` to install `firedown`
  and its man page to `/usr/local`,

- put `firedown` manually into the search path of root,

- put `firedown` anywhere and invoke it using its full path.

Requirements
------------

- Ruby must be installed on your system.

- No additional Ruby gems are needed to run `firedown`.

- `firedown` has been tested with Ruby 1.8.7 and Ruby 1.9.3
  on a Linux machine.

Documentation
-------------

Use `firedown --help` to display a brief help message.

If you installed `firedown` using `rake install` you can read
its man page with `man firedown`.

Reporting bugs
--------------

Report bugs on the `firedown` home page: <https://github.com/stomar/firedown/>

License
-------

Copyright &copy; 2012-2015 Marcus Stollsteimer

`firedown` is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License version 3 or later (GPLv3+),
see [www.gnu.org/licenses/gpl.html](http://www.gnu.org/licenses/gpl.html).
There is NO WARRANTY, to the extent permitted by law.


[Ruby]: http://www.ruby-lang.org/
