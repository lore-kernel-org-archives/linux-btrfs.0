Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:29562 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750722AbeCOIMn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 04:12:43 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 5F1D9AC017A
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 17:12:39 +0900 (JST)
Received: from G01JPEXCHYT13.g01.fujitsu.local (G01JPEXCHYT13.g01.fujitsu.local [10.128.194.52])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id B88CB46E636
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 17:12:38 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [RFC PATCH v2 0/8] btrfs-progs: Allow normal user to call "subvolume
 list/show"
Message-ID: <226b6805-c5aa-c40d-4ea6-f81dc1b7de20@jp.fujitsu.com>
Date: Thu, 15 Mar 2018 17:12:35 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

changelog:
v1 -> v2
  - add independent error handling patch (1st patch)
  - reimplement according to ioctl change
  - various cleanup
===

This RFC implements user version of "subvolume list/show" using three new ioctls.
The ioctl patch to the kernel can be found in the ML titled 
  "[PATCH v2 0/3] btrfs: Add three new unprivileged ioctls to allow normal users to call "sub list/show" etc.

1th patch is independent and improvements of error handling
2nd-5th are some preparation works.
6th patch is the main part.
7th-8th adds the test for "subvolume list"

The main behavior differences between root and normal users are:

1. "sub list" list the subvolumes which exist under the specified path 
(including the path itself). The specified path itself is not needed to be
 a subvolume. Also If the subvolume cannot be opened but the parent
directory can be, the information other than name or id would be zeroed out.

2. snapshot filed of "subvolume show" just lists
the snapshots under the specified subvolume.


This is a part of RFC I sent last December[1] whose aim is to improve normal users' usability.
The remaining works of RFC are: 
  - Allow "sub delete" for empty subvolume
  - Allow "qgroup show" to check quota limit

[1] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg70991.html

Tomohiro Misono (8):
  btrfs-progs: sub list: Call rb_free_nodes() in error path
  btrfs-progs: ioctl: Add 3 definitions of new unprivileged ioctl
  btrfs-progs: sub list: Add helper function which checks the permission
    for tree search ioctl
  btrfs-progs: sub list: Pass specified path down to
    btrfs_list_subvols()
  btrfs-progs: fallback to open without O_NOATIME flag in
    find_mount_root()
  btrfs-progs: sub list: Allow normal user to call "subvolume list/show"
  btrfs-progs: test: Add helper function to check if test user exists
  btrfs-porgs: test: Add cli-test/009 to check subvolume list for both
    root and normal user

 btrfs-list.c                               | 391 +++++++++++++++++++++++++++--
 btrfs-list.h                               |   8 +-
 cmds-subvolume.c                           |  19 +-
 ioctl.h                                    |  86 +++++++
 tests/cli-tests/009-subvolume-list/test.sh | 136 ++++++++++
 tests/common                               |  10 +
 utils.c                                    |  13 +-
 7 files changed, 634 insertions(+), 29 deletions(-)
 create mode 100755 tests/cli-tests/009-subvolume-list/test.sh

-- 
2.14.3

