From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v2 0/5] btrfs-progs: scrub interface
Date: Wed, 30 Mar 2011 18:53:08 +0200
Message-ID: <cover.1301503683.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is the next patch series for scrub userland tools.

Change log v1->v2:
- commands now reachable as "btrfs scrub ..." instead of "btrfs filesystem
  scrub ..."
- ability to scrub a single device instead of a whole file system
- superfluous command line options removed
- resume is now a separate command ("scrub resume") instead of "scrub start -r"
- read-only mode (which inherited the -r option immediately, sorry for that)
- up to date progress numbers with "btrfs scrub status" while scrub is running
- effective locking to protect against multiple scrubs on a filesystem
- man page entry for scrub added

Jan Schmidt (5):
  commands added
  scrub ioctls
  added check_mounted_where
  scrub userland implementation
  scrub added to manpage

 Makefile       |    4 +-
 btrfs.c        |   18 +-
 btrfs_cmds.c   |    3 +-
 btrfs_cmds.h   |    5 +
 ctree.h        |    2 +-
 ioctl.h        |   60 +++-
 man/btrfs.8.in |   66 +++-
 scrub.c        | 1568 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.c        |   29 +-
 utils.h        |    2 +
 10 files changed, 1743 insertions(+), 14 deletions(-)
 create mode 100644 scrub.c

-- 
1.7.3.4

