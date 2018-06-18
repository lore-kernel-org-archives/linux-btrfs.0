Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:28186 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968190AbeFRIiN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:13 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 3D563AC016E
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:08 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Omar Sandoval <osandov@fb.com>
Subject: [PATCH v2 00/20] btrfs-progs:  Rework of "subvolume list/show" and relax the root privileges of them
Date: Mon, 18 Jun 2018 17:40:48 +0900
Message-ID: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Changelog
 
 v1 -> v2: 
  generally update whole patch set, especially:
   - rebased to progs 4.17
   - Improve error handling
   - Update man/help/commit message
   - Add/Update several options of sub list:
      -f ... follow mounted subvolumes
      -a ... remove meaningless filter
      -A ... print path in absolute path
      --nosort ... output results incrementally
     Please see below examples
=====
github:  https://github.com/t-msn/btrfs-progs/tree/rework-sub-list

Hello,

This series requires some new ioctls which are now in kernel 4.18-rc1. 

The aim of this series is to relax the root privileges of "sub list/show"
while keeping as much output consistency between root and non-privileged
user. For "subvolume list", default output has been changed from current
btrfs-progs (in both old and new kernel) and some options are newly added.
For "subvolume show", root's output is the same as before but there are
some difference from non-privileged user's output. 

Please see below examples.


* Behavior summary of new "sub list"
  - default (no option)
    - lists subvolumes below the specified path (inc. path itself)
    - If new ioctls exists
      - the path can be non-subvolume directory
      - non-privileged user can call it
        (subvolumes to which the user cannot access will be skipped)

  - -f
    - follow mounted subvolume below the specified path and list them too 
      (only if it is the same filesystem)

  - -a
    - updated to remove filter. i.e. the output is the same as current progs
      without option (require root privileges)

  - -A
    - print path in absolute path

  -- nosort
    - output results incrementally without loading information to memory

 [Example]
  $ mkfs.btrfs -f $DEV
  $ mkfs.btrfs -f $DEV2
  $ mount $DEV $MNT

  $ btrfs subvolume create $MNT/AAA
  $ btrfs subvolume create $MNT/BBB
  $ btrfs subvolume create $MNT/CCC
  $ btrfs subvolume create $MNT/DDD
  $ mkdir $MNT/AAA/bbb
  $ mkdir $MNT/AAA/ccc
  $ mkdir $MNT/AAA/other

  $ umount $MNT
  $ mount -o subvol=AAA $DEV $MNT
  $ mount -o subvol=BBB $DEV $MNT/bbb
  $ mount -o subvol=CCC $DEV $MNT/ccc
  $ mount -o $DEV2 $MNT/other

  $ btrfs subvolume list $MNT # print subvolumes below the path
  ID 256 gen 10 top level 5 path .

  $ btrfs subvolume list -A $MNT # print path in absolute path
  ID 256 gen 10 top level 5 path /mnt

  $ btrfs subvolume list -f $MNT # follow mounted subvolumes too
  ID 256 gen 10 top level 5 path .
  ID 258 gen 7 top level 5 path bbb
  ID 259 gen 8 top level 5 path ccc

  $ btrfs subvolume list -a $MNT
  # print all subvolumes in the fs. same output as progs<=4.17 without option
  ID 256 gen 10 top level 5 path AAA
  ID 258 gen 7 top level 5 path BBB
  ID 259 gen 8 top level 5 path CCC
  ID 260 gen 9 top level 5 path DDD

 More details are in each commit log.


* Behavior summary of new "sub show"
  - No change for root's output
  - If new ioctls exists, non-privileged user can call it
    - In that case, path to be shown is absolute path
      (for root, it is relative to top-level subvolume)
      Also, snapshots to be shown are to which the user can
      access from current mount point.
      (for root, all snapshots in the fs)


* Patch structure
The first several patches update libbtrfsutil and the latter patches update
sub list/show command.

 1st patch is independent and updates man doc of btrfs-subvolume

 2nd-6th update the libbtrfsutil using new ioctls:
   - Relax the privileges of following functions if kernel supports new
     ioctls and @top/@id is zero (i.e. the given path/fd is used instead
     of arbitrary subvolume id).
     - util_subvolume_info()
     - subvolume iterator related ones (util_subvolume_iterator_next() etc.)

   - For subvolume iterator, if kernel supports new ioctls and @top is zero,
     non-subvolume directory can be specified as a start point. Also,
     subvolume which cannot be accessed (either because of permission
     error or not found (may happen if other volume is mounted in the
     path) will be skipped for non-privileged user.

   - Code path of root and non-privileged user is different. While root uses
     TREE_SEARCH ioctl as before, non-privileged user uses newly added
     ioctls. However, There is only one exception and when subvolume
     iterator is created from non-subvolume directory, code path of both is
     the same (and thus both use new ioctls).

 7th patch update the "sub list" to use libbtrfsutil (no behavior change yet)
   This is a copy of non-merged following patch originally written
   by Omar Sandoval:
     btrfs-progs: use libbtrfsutil for subvolume list [1]
   expect this commit keeps libbtrfs implementation which above commit
   tries to remove.

   (I suspect that the part of the reason that the original patch has not
   been merged is it removes libbtrfs and this commits modify this. but
   I'm completely fine with the original patch instead of this.)

 8th-15th patch update the behavior of "sub list"

 16th-17th patch update the behavior of "sub show"

 18th-20th patch are cli-test for "sub list" of new behavior.


* Future todo:
If this approach is ok, I'd like to update the output of "sub list" more like:
  - Remove obsolete field (i.e. top-level) from output

Any comments are welcome.
Thanks,
Tomohiro Misono

[1] https://www.spinics.net/lists/linux-btrfs/msg74917.html 

Misono Tomohiro (20):
  btrfs-progs: doc: Update man btrfs subvolume
  btrfs-progs: ioctl/libbtrfsutil: Add 3 definitions of new unprivileged
    ioctl
  btrfs-progs: libbtrfsutil: Factor out btrfs_util_subvolume_info_fd()
  btrfs-porgs: libbtrfsutil: Relax the privileges of
    util_subvolume_info()
  btrfs-progs: libbtrfsuitl: Factor out
    btrfs_util_subvolume_iterator_next()
  btrfs-progs: libbtrfsutil: Relax the privileges of subvolume iterator
  btrfs-progs: sub list: Use libbtrfsuitl for subvolume list
  btrfs-progs: sub list: factor out main part of btrfs_list_subvols
  btrfs-progs: sub list: Change the default behavior of "subvolume list"
    and allow non-privileged user to call it
  btrfs-progs: sub list: Add -A option to output path in absolute path
  btrfs-progs: sub list: Add -f option to follow mounted subvolumes
    below the path
  btrfs-progs: sub list: Add --nosort option to output incrementally
    without sort
  btrfs-progs: sub list: Update -a option and remove meaningless filter
  btrfs-progs: sub list: Update help message of -o option
  btrfs-progs: sub list: Update help message of -d option
  btrfs-progs: utils: Fallback to open without O_NOATIME flag in
    find_mount_root():
  btrfs-progs: sub show: Allow non-privileged user to call "subvolume
    show"
  btrfs-progs: test: Add helper function to check if test user exists
  btrfs-porgs: test: Add cli-test/009 to check subvolume list for both
    root and normal user
  btrfs-progs: test: Add cli-test/010 to check "subvolume list -f"
    option

 Documentation/btrfs-subvolume.asciidoc            |  108 +-
 cmds-subvolume.c                                  | 1372 ++++++++++++++++++++-
 ioctl.h                                           |   99 ++
 libbtrfsutil/btrfs.h                              |   97 ++
 libbtrfsutil/btrfsutil.h                          |   25 +-
 libbtrfsutil/errors.c                             |   10 +
 libbtrfsutil/subvolume.c                          |  494 +++++++-
 tests/cli-tests/009-subvolume-list/test.sh        |  134 ++
 tests/cli-tests/010-subvolume-list-follow/test.sh |   86 ++
 tests/common                                      |   10 +
 utils.c                                           |    3 +
 11 files changed, 2315 insertions(+), 123 deletions(-)
 create mode 100755 tests/cli-tests/009-subvolume-list/test.sh
 create mode 100755 tests/cli-tests/010-subvolume-list-follow/test.sh

-- 
2.14.4


