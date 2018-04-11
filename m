Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:44286 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbeDKFSq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 01:18:46 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 2F8EFAC0118
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 14:18:39 +0900 (JST)
Received: from G01JPEXCHKW15.g01.fujitsu.local (G01JPEXCHKW15.g01.fujitsu.local [10.0.194.54])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 8BD06BD674B
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 14:18:38 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH v4 0/4] Allow rmdir(2) to delete a subvolume
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <d5c7d8e3-4c07-18c3-56a5-0482c899cfe5@jp.fujitsu.com>
Date: Wed, 11 Apr 2018 14:18:03 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

changelog:
  v3 -> v4 ... Reorganize patches and updates commit log.
               No code change in total
  v2 -> v3 ... Use if-else block instead of two if blocks and 
               add Tested-by tag in 2nd patch
  v1 -> v2 ... Split the patch to hopefully make review easier

Note: I will send a xfstest if this series is merged.

This series changes the behavior of rmdir(2) and allow it to delete an
empty subvolume.

1st to 3rd patches refactor btrfs_ioctl_snap_destroy() and no functional
change happens.

btrfs_ioctl_snap_destroy() is roughly comprised of two parts.
The first part is permission check of the (parent) subvolume. The second
part is additional check (1. send is not in progress. 2. the subvolume
is not a default subvolume. 3. the subvolume does not contain other
subvoume) and actual deletion process.

The aim of 1st to 3rd patches is to  extract the second part as
btrfs_delete_subvolume().

4th patch is just one line but this changes the behavior of rmdir(2)
by calling btrfs_delete_subvolume(). For rmdir(2), permission check is
already done in vfs layer.

Tomohiro Misono (4):
  btrfs: move may_destroy_subvol() from ioctl.c to inode.c
  btrfs: Add definition of btrfs_delete_subvolume()
  btrfs: Refactor btrfs_ioctl_snap_destroy() by using
    btrfs_delete_subvolume()
  btrfs: Allow rmdir(2) to delete an empty subvolume

 fs/btrfs/ctree.h |   5 +-
 fs/btrfs/inode.c | 197 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ioctl.c | 185 +--------------------------------------------------
 3 files changed, 198 insertions(+), 189 deletions(-)

-- 
2.14.3


