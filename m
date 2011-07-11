From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v2 0/3] Btrfs-progs: add the first "inspect-internal" commands
Date: Mon, 11 Jul 2011 19:47:56 +0200
Message-ID: <cover.1310405883.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is the follow up to the patch series
   "[PATCH v1 0/2] Btrfs-progs: commands "resolve inode" and "resolve logical"
I chose to change the subject as the command names changed.

Changes v1->v2:
- commands renamed as suggested by Goffredo Baroncelli
- man pages added

The kernel patch series just sent (Subject: "Btrfs: scrub: print path to
corrupted files and trigger nodatasum fixup") introduces two new ioctls to
do in-kernel filesystem path construction. This series provides the
corresponding userspace changes, adding two new commands to the btrfs utility.

These patches are based on Hugo's current integration branch.

Please try them out and report bugs here.

-Jan

Jan Schmidt (3):
  Btrfs-progs: btrfs-list: split list_subvols
  Btrfs-progs: added ioctls and commands to resolve inodes and logical
    addrs
  Btrfs-progs: added resolve commands to man page

 btrfs-list.c   |  139 +++++++++++++++++++++++++++++++++-----------
 btrfs.c        |   10 +++
 btrfs_cmds.c   |  177 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 btrfs_cmds.h   |    3 +
 ioctl.h        |   29 +++++++++
 man/btrfs.8.in |   29 +++++++++
 6 files changed, 352 insertions(+), 35 deletions(-)

-- 
1.7.3.4

