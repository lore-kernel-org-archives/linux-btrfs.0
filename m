Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:42157 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754894AbeCSHag (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 03:30:36 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 3E66BAC00AB
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 16:30:29 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 97CDFBD645A
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 16:30:28 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [RFC PATCH v3 0/7] btrfs-progs: Allow normal user to call "subvolume
 list/show"
Message-ID: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
Date: Mon, 19 Mar 2018 16:30:17 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

changelog:

v2 -> v3
  - use get_euid() to check the caller's privilege (and remove 3rd patch)
  - improve error handling
v1 -> v2
  - add independent error handling patch (1st patch)
  - reimplement according to ioctl change
  - various cleanup
===

This RFC implements user version of "subvolume list/show" using three new ioctls.
The ioctl patch to the kernel can be found in the ML titled 
  "[PATCH v3 0/3] btrfs: Add three new unprivileged ioctls to allow normal users to call "sub list/show" etc.

1th patch is independent and improvements of error handling
2nd-4th are some prepartion works.
5th patch is the main part.
6th-7th adds the test for "subvolume list"

The main behavior differences between root and normal users are:

- "sub list" list the subvolumes which exist under the specified path 
(including the path itself). The specified path itself is not needed to be
 a subvolume. Also If the subvolume cannot be opend but the parent
directory can be, the information other than name or id would be zeroed out.

- snapshot filed of "subvolume show" just lists
the snapshots under the specified subvolume.


This is a part of RFC I sent last December[1] whose aim is to improve normal users' usability.
The remaining works of RFC are: 
  - Allow "sub delete" for empty subvolume
  - Allow "qgroup show" to check quota limit

[1] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg70991.html


Tomohiro Misono (7):
  btrfs-progs: sub list: Call rb_free_nodes() in error path
  btrfs-progs: ioctl: Add 3 definitions of new unprivileged ioctl
  btrfs-progs: sub list: Pass specified path down to
    btrfs_list_subvols()
  btrfs-progs: fallback to open without O_NOATIME flag in
    find_mount_root()
  btrfs-progs: sub list: Allow normal user to call "subvolume list/show"
  btrfs-progs: test: Add helper function to check if test user exists
  btrfs-porgs: test: Add cli-test/009 to check subvolume list for both
    root and normal user

 btrfs-list.c                               | 376 +++++++++++++++++++++++++++--
 btrfs-list.h                               |   7 +-
 cmds-subvolume.c                           |  14 +-
 ioctl.h                                    |  86 +++++++
 tests/cli-tests/009-subvolume-list/test.sh | 136 +++++++++++
 tests/common                               |  10 +
 utils.c                                    |  13 +-
 7 files changed, 609 insertions(+), 33 deletions(-)
 create mode 100755 tests/cli-tests/009-subvolume-list/test.sh

-- 
2.14.3

