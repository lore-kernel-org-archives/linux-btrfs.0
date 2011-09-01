From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v4 0/3] Btrfs-progs: add the first "inspect-internal" commands
Date: Thu,  1 Sep 2011 15:05:56 +0200
Message-ID: <cover.1314878395.git.list.btrfs@jan-o-sch.net>
Cc: hugo@carfax.org.uk
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This version is still based on Hugo's current integration branch and can also be
pulled from git://git.jan-o-sch.net/btrfs-progs-unstable.

Changes v3->v4:
- bugfix: don't overwrite parent_id after setting it correctly in resolve_root
  (reported by David Sterba)

Changes v2->v3:
- adapted to a change in the ioctl interface in the accompanying kernel patch
  series v8. we now use bytes_missing and bytes_left (unsigned) instead of
  size (signed)
- explicit casts added when printing u32 to avoid compiler warnings

Changes v1->v2:
- commands renamed as suggested by Goffredo Baroncelli
- man pages added

The kernel patch series just sent (Subject: "Btrfs: scrub: print path to
corrupted files and trigger nodatasum fixup") introduces two new ioctls to
do in-kernel filesystem path construction. This series provides the
corresponding userspace changes, adding two new commands to the btrfs utility.

Please try them out and report bugs here.

-Jan


Jan Schmidt (3):
  Btrfs-progs: btrfs-list: split list_subvols
  Btrfs-progs: added ioctls and commands to resolve inodes and logical
    addrs
  Btrfs-progs: added resolve commands to man page

 btrfs-list.c   |  138 +++++++++++++++++++++++++++++++-----------
 btrfs.c        |   10 +++
 btrfs_cmds.c   |  183 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 btrfs_cmds.h   |    3 +
 ioctl.h        |   30 +++++++++
 man/btrfs.8.in |   29 +++++++++
 6 files changed, 358 insertions(+), 35 deletions(-)

-- 
1.7.3.4

