Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:29733 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751433AbeEKH1f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:27:35 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id CEE10AC01FC
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 16:27:26 +0900 (JST)
From: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Omar Sandoval <osandov@fb.com>
Subject: [PATCH 00/11] btrfs-progs: Rework of "subvolume list/show" and relax the root privileges of them 
Date: Fri, 11 May 2018 16:29:38 +0900
Message-ID: <20180511072949.15269-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This series is an updated version of
  [RFC PATCH v3 0/7] btrfs-progs: Allow normal user to call "subvolume list/show" [1]
and requires new ioctls which can be found in ML as
  [PATCH v4 0/3] btrfs: Add three new unprivileged ioctls to allow normal users to call "sub list/show" etc.

Or, code can be found at:
  kernel ... https://github.com/t-msn/linux/tree/add-user-subvol-ioctl-misc
  progs  ... https://github.com/t-msn/btrfs-progs/tree/rework-sub-list

Since libbtrfsutil has been merged, I completely rewrote the logic using
libbtrfsutil and reset the version number.

The aim of this series is to relax the root privileges of "sub list/show"
while keeping as much output consistency between root and non-privileged
user. For "subvolume list", default output has been changed from current
btrfs-progs (see below).

* Behavior summary of new "sub list/show"
 - "subvolume list"
   - The default behavior is changed to output only the subvolumes which
     exist below the specified path (incl. the specified path itself.
     the subvolumes mounted below the specified path is not considered yet).
   - If kernel supports new ioctls, the path to a non-subvolume directory
     can be specified.
   - If kernel supports new ioctls, non-privileged user can also call it.
     The subvolumes which cannot be accessed will be skipped.

  Note that root user can get all the subvolume information in the fs
  by using -a option just as before.

 - "subvolume show"
   - No change for root.
   - If kernel supports new ioctls, non-privileged user can also call it.
     In that case, the path to be shown is a relative from mount point and
     snapshots field lists snapshots which exist under mountpoint.

* Patch structure
 1st-5th update the libbtrfsutil using new ioctls:
   - Relax the privileges of following functions if kernel supports new
     ioctls and @top/@id is zero (i.e. the given path/fd is used instead
     of arbitrary subvolume id).
     - util_subvolume_info()
     - subvolume iterator related ones (util_subvolume_iterator_next() etc.)
   - For subvolume iterator, if kernel supports new ioctls and @top is zero,
     non-subvolume directory can be specified as a start point. Also,
     subvolume which cannot be accessed (either because of permission
     error or not found (may happen if other volume is mounted in the
     path)) will be skipped.

 6th patch update the "sub list" to use libbtrfsutil (no behavior change)
   This is a copy of non-merged following patch originally written
   by Omar Sandoval:
     btrfs-progs: use libbtrfsutil for subvolume list [2]
   expect this commit keeps libbtrfs implementation which above commit
   tries to remove.

   (I suspect that the part of the reason that the original patch has not
   been merged is it removes libbtrfs and this commits modify this. but
   I'm completely fine with the original patch instead of this.)

 7th-9th patch update the behavior of "sub list/show"

 10th-11th patch is a cli-test for "sub list" of new behavior.

* Future todo:
If this approach is ok, I'd like to update the output of "sub list" more like:
  - Consider subvolume mounted below the specified path and list them as well
  - Remove obsolete field (i.e. top-level) from output

Any comments are welcome.
Thanks,
Tomohiro Misono

[1] https://www.spinics.net/lists/linux-btrfs/msg76008.html
[2] https://www.spinics.net/lists/linux-btrfs/msg74917.html 


Tomohiro Misono (11):
  btrfs-progs: ioctl/libbtrfsutil: Add 3 definitions of new unprivileged
    ioctl
  btrfs-progs: libbtrfsutil: Factor out btrfs_util_subvolume_info_fd()
  btrfs-porgs: libbtrfsutil: Relax the privileges of
    util_subvolume_info()
  btrfs-progs: libbtrfsuitl: Factor out
    btrfs_util_subvolume_iterator_next()
  btrfs-progs: libbtrfsutil: Update the behavior of subvolume iterator
    and relax the privileges
  btrfs-progs: sub list: Use libbtrfsuitl for subvolume list
  btrfs-progs: sub list: Change the default behavior of "subvolume list"
    and allow non-privileged user to call it
  btrfs-progs: utils: Fallback to open without O_NOATIME flag in
    find_mount_root():
  btrfs-progs: sub show: Allow non-privileged user to call "subvolume
    show"
  btrfs-progs: test: Add helper function to check if test user exists
  btrfs-porgs: test: Add cli-test/009 to check subvolume list for both
    root and normal user

 Documentation/btrfs-subvolume.asciidoc     |    2 +
 cmds-subvolume.c                           | 1123 +++++++++++++++++++++++++++-
 ioctl.h                                    |   86 +++
 libbtrfsutil/btrfs.h                       |   84 +++
 libbtrfsutil/btrfsutil.h                   |   26 +-
 libbtrfsutil/errors.c                      |    8 +
 libbtrfsutil/subvolume.c                   |  429 +++++++++--
 tests/cli-tests/009-subvolume-list/test.sh |  136 ++++
 tests/common                               |   10 +
 utils.c                                    |    3 +
 10 files changed, 1819 insertions(+), 88 deletions(-)
 create mode 100755 tests/cli-tests/009-subvolume-list/test.sh

-- 
2.14.3


