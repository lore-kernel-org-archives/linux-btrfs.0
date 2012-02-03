From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 0/3] Btrfs-progs: restriper interface
Date: Fri,  3 Feb 2012 23:49:09 +0200
Message-ID: <1328305752-32160-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is the userspace part of restriper, rebased onto the new progs
infrastructure.  Restriper commands are located under 'balance' prefix,
which is now the top level command group.  However to not confuse
existing users 'balance' prefix is also available under 'filesystem':

btrfs [filesystem] balance start
btrfs [filesystem] balance pause
btrfs [filesystem] balance cancel
btrfs [filesystem] balance resume
btrfs [filesystem] balance status

Backwards compatibility is fully preserved thanks to the new command
parser: the old 'btrfs filesystem balance <path>' works as expected.

The patchset is on top of the new parser posted half an hour ago,
available at:

git://github.com/idryomov/btrfs-progs.git restriper

Thanks,

		Ilya


Ilya Dryomov (3):
  Btrfs-progs: add restriper headers
  Btrfs-progs: add 'balance' command group infrastructure
  Btrfs-progs: add restriper commands

 Makefile          |    2 +-
 btrfs.c           |    1 +
 cmds-balance.c    |  684 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-filesystem.c |   38 +---
 commands.h        |    2 +
 ctree.h           |   23 ++-
 ioctl.h           |   53 ++++
 print-tree.c      |    6 +
 volumes.h         |   31 +++
 9 files changed, 795 insertions(+), 45 deletions(-)
 create mode 100644 cmds-balance.c

-- 
1.7.6.3

