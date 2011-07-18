From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v3 0/5] btrfs-progs: scrub interface
Date: Mon, 18 Jul 2011 14:37:20 +0200
Message-ID: <cover.1310990184.git.list.btrfs@jan-o-sch.net>
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

Change log v2->v3:
- unverified_errors counter added
- return code of utility now depends on detected disk errors
- bail out when check_mounted_where returns an error
- changes as suggested by Hugo Mill's review. incomplete list:
	- style (checkpatch is happy now)
	- pthread_* error handling
	- use /var/lib/btrfs instead of /var/btrfs for storing history

Attention: This version may be useful for Hugo, only. It is meant to be
	   included in his current integration branch. Also, I wanted to avoid
	   patching the patches previously sent and rather deliver a fresh
	   version. Therefore, I used "integration-20110705" from
	   http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ as a base,
	   reverted the scrub patches in the middle and built upon that.

-Jan

Jan Schmidt (5):
  btrfs-progs: commands added
  btrfs-progs: scrub ioctls
  btrfs-progs: added check_mounted_where
  btrfs-progs: scrub userland implementation
  btrfs-progs: scrub added to manpage

 Makefile       |    4 +-
 btrfs.c        |   23 +
 btrfs_cmds.c   |    2 +-
 btrfs_cmds.h   |    5 +
 ctree.h        |    2 +-
 ioctl.h        |   54 ++-
 man/btrfs.8.in |   64 +++-
 scrub.c        | 1666 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.c        |   29 +-
 utils.h        |    2 +
 10 files changed, 1838 insertions(+), 13 deletions(-)
 create mode 100644 scrub.c

-- 
1.7.3.4

