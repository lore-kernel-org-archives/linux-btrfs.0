Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:47472 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeCZI2d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 04:28:33 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 314C3AC01E3
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 17:28:25 +0900 (JST)
Received: from G01JPEXCHYT14.g01.fujitsu.local (G01JPEXCHYT14.g01.fujitsu.local [10.128.194.53])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 88C206D66DF
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 17:28:24 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH v2 0/3] Allow rmdir(2) to delete a subvolume
Message-ID: <ea15ef98-3668-b2bc-079c-439ec512ae76@jp.fujitsu.com>
Date: Mon, 26 Mar 2018 17:28:20 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

changelog:
  v1 -> v2 ... split the patch to hopefully make review easier

1st patch is a preparation work just moving the declaration of
may_destroy_subvol().

2nd patch is the main part. New function btrfs_delete_subvolume() is
introduced and used in btrfs_rmdir() when a direcoty is an empty
subvolume. The function is almost the copy of second half of
btrfs_ioctl_snap_destroy().
The code path for "sub delete" is not changed yet.

3rd patch is a cleanup of btrfs_ioctl_snap_destroy() and uses 
brrfs_delete_subvolume() for "sub delete" too.

Tomohiro Misono (3):
  btrfs: move may_destroy_subvol() from ioctl.c to inode.c
  btrfs: Allow rmdir(2) to delete a subvolume
  btrfs: cleanup btrfs_ioctl_snap_destroy() by using btrfs_delete_subvolume()

 fs/btrfs/ctree.h |   5 +-
 fs/btrfs/inode.c | 199 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ioctl.c | 185 +--------------------------------------------------
 3 files changed, 200 insertions(+), 189 deletions(-)

-- 
2.14.3

