From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 0/3] Btrfs-progs: new subcommand infrastructure
Date: Fri,  3 Feb 2012 23:23:57 +0200
Message-ID: <1328304240-26100-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

When integrating restriper into progs I encountered a problem with the
core subcommand matcher - it wouldn't allow one to handle some of the
command groups in a custom way.  The existing parser operates only with
individual commands and there's no way to handle command groups as a
whole w/o losing ambiguity stuff and proper error reporting.

There are other problems with the existing infrastructure: it dumps
several screens of usage on you almost every time you misspell
something; if you misspell an option instead of usage for a particular
command you get an arbitrary error message; in response to

btrfs filesystem aaadfaaa /mnt

it prints

ERROR: unknown command 'filesystem'

when it really should print out aaadfaaa, etc.

So I decided to replace it completely with something that would allow
explicit command group handling and fix these annoyances along the way.
Instead of a global command table we now have per-level tables and
command group handlers, which allow command-group-specific handling of
options and subcommands.  The new parser exports a clear interface and
gets out of the way - all control over how matching is done is passed to
commands and command group handlers.

One side effect of this is that command implementors now have to check
the number of arguments themselves but that's a small price to pay,
besides the old argument counting thing did not take into account
options anyway.  I switched all existing commands and people with
outstanding progs patchsets are welcome to point me at them so I can
switch those too.

I also rearranged files around a bit - each command group resides in a
separate file now - so the diffstat seems to be huge, but it really is
not.

There should be no user-visible changes apart from usage and help
output.  If you find any please report them.  Any feedback is more than
welcome.

The patchset is on top of btrfs-progs master branch, available at:

git://github.com/idryomov/btrfs-progs.git parser

Thanks,

		Ilya


Ilya Dryomov (3):
  Btrfs-progs: rearrange files in the repo
  Btrfs-progs: implement new subcommand parser
  Btrfs-progs: switch all existing commands to a new parser

 Makefile          |    6 +-
 btrfs.c           |  579 ++++++------------
 btrfs_cmds.c      | 1307 ----------------------------------------
 btrfs_cmds.h      |   44 --
 cmds-device.c     |  259 ++++++++
 cmds-filesystem.c |  572 ++++++++++++++++++
 cmds-inspect.c    |  241 ++++++++
 cmds-scrub.c      | 1719 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-subvolume.c  |  531 +++++++++++++++++
 commands.h        |   95 +++
 common.c          |   46 ++
 help.c            |  207 +++++++
 scrub.c           | 1666 ---------------------------------------------------
 13 files changed, 3869 insertions(+), 3403 deletions(-)
 delete mode 100644 btrfs_cmds.c
 delete mode 100644 btrfs_cmds.h
 create mode 100644 cmds-device.c
 create mode 100644 cmds-filesystem.c
 create mode 100644 cmds-inspect.c
 create mode 100644 cmds-scrub.c
 create mode 100644 cmds-subvolume.c
 create mode 100644 commands.h
 create mode 100644 common.c
 create mode 100644 help.c
 delete mode 100644 scrub.c

-- 
1.7.6.3

