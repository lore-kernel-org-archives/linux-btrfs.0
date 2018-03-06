Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:21775 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750825AbeCFIdI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 03:33:08 -0500
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 1DB7CAC0131
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 17:33:02 +0900 (JST)
Received: from g01jpexchyt38.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 7482146E6F9
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 17:33:01 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [RFC PATCH 0/7] btrfs-progs: Allow normal user to call "subvolume
 list/show"
Message-ID: <94a0bad6-d696-a72e-ba7b-287d1d442997@jp.fujitsu.com>
Date: Tue, 6 Mar 2018 17:32:58 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This RFC implements user version of "subvolume list/show" using two new ioctls.
The ioctl patch to the kernel can be found in the ML titled 
  "[PATCH 0/2] btrfs: Add two new unprivileged ioctls to allow normal users to call "sub list/show" etc."

1st-4th are some prepartion works.
5th patch is the main part.
6th-7th adds the test for "subvolume list"

The main behavior differences between root and normal users are:
 - "subvolume list" only lists subvolumes which exist under the specified path.
   (The specified path itself is not needed to be a subvolume.)
 - snapshot filed of "subvolume show" just lists the snapshots under the specified path.

This is a part of RFC I sent last December[1] whose aim is to improve normal users' usability.
The remaining works of RFC are: 
  - Allow "sub delete" for empty subvolume
  - Allow "qgroup show" to check quota limit

[1] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg70991.html

Tomohiro Misono (7):
  btrfs-progs: Add 2 definitions of new unprivileged ioctl
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

 btrfs-list.c                               | 289 +++++++++++++++++++++++++++--
 btrfs-list.h                               |   8 +-
 cmds-subvolume.c                           |  12 +-
 ioctl.h                                    |  19 ++
 tests/cli-tests/009-subvolume-list/test.sh | 136 ++++++++++++++
 tests/common                               |  10 +
 utils.c                                    |  13 +-
 7 files changed, 464 insertions(+), 23 deletions(-)
 create mode 100755 tests/cli-tests/009-subvolume-list/test.sh

-- 
2.14.3

