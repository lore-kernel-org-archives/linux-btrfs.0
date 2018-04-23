Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:34214 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750756AbeDWFHe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 01:07:34 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id D001EAC0129
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 14:07:28 +0900 (JST)
Received: from g01jpexchyt38.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 273EE46E62E
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 14:07:28 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [RFC PATCH v4 0/6] btrfs-porgs: Allow normal user to call "subvolume
 list"
Message-ID: <70590827-0c29-75ea-5e43-2e53264b3d4c@jp.fujitsu.com>
Date: Mon, 23 Apr 2018 14:05:55 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This version is only for testing new ioctls[1] with btrfs-progs 4.16 for the
meantime.

Since progs code has changed, "sub show" cannot be run by non-root user with
this version. Also, the behavior difference between root and non-root has not
been settled. I'll continue working on these and send updated version later.

[1] https://www.spinics.net/lists/linux-btrfs/msg76003.html

changelog:

v3 -> v4
  - rebased to btrfs progs v4.16
v2 -> v3
  - use get_euid() to check the caller's privilege (and remove 3rd patch)
  - improve error handling
v1 -> v2
  - add independent error handling patch (1st patch)
  - reimplement according to ioctl change
  - various cleanup
===

This RFC implements user version of "subvolume list" using three new ioctls.
The ioctl patch to the kernel can be found in the ML titled 
  "[PATCH v3 0/3] btrfs: Add three new unprivileged ioctls to allow normal
   users to call "sub list/show" etc.

1th patch is independent and improvements of error handling
2nd-3rd are some prepartion works.
4th patch is the main part.
5th-6th adds the test for "subvolume list"

The main behavior differences between root and normal users are:

- "sub list" list the subvolumes which exist under the specified path 
(including the path itself). The specified path itself is not needed to be
 a subvolume. Also If the subvolume cannot be opend but the parent
directory can be, the information other than name or id would be zeroed out.

This is a part of RFC I sent last December[2] whose aim is to improve normal
users' usability.
The remaining works of RFC are: 
  - Allow "sub delete" for empty subvolume
  - Allow "qgroup show" to check quota limit

[2] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg70991.html

Tomohiro Misono (6):
  btrfs-progs: sub list: Call rb_free_nodes() in error path
  btrfs-progs: ioctl: Add 3 definitions of new unprivileged ioctl
  btrfs-progs: sub list: Pass specified path down to btrfs_list_subvols()
  btrfs-progs: sub list: Allow normal user to call "subvolume list"
  btrfs-progs: test: Add helper function to check if test user exists
  btrfs-porgs: test: Add cli-test/009 to check subvolume list for both root and normal user

 btrfs-list.c                               | 382 +++++++++++++++++++++++++++--
 btrfs-list.h                               |   7 +-
 cmds-subvolume.c                           |  10 +-
 ioctl.h                                    |  86 +++++++
 tests/cli-tests/009-subvolume-list/test.sh | 136 ++++++++++
 tests/common                               |  10 +
 6 files changed, 605 insertions(+), 26 deletions(-)
 create mode 100755 tests/cli-tests/009-subvolume-list/test.sh

-- 
2.14.3

