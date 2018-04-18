Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:19023 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753623AbeDRCdp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 22:33:45 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 02246AC0107
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 11:33:39 +0900 (JST)
Received: from g01jpexchkw36.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 554D43284A8
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 11:33:38 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH v5 0/3] Allow rmdir(2) to delete a subvolume
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <558a949c-ceb5-115d-744f-80fac2620f7d@jp.fujitsu.com>
Date: Wed, 18 Apr 2018 11:32:57 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cangelog:
  v4 -> v5 ... Merge 2nd and 3rd patches and update commit log
               No code change in total
  v3 -> v4 ... Reorganize patches and update commit log
               No code change in total
  v2 -> v3 ... Use if-else block instead of two if blocks and
               add Tested-by tag in 2nd patch
  v1 -> v2 ... Split the patch to hopefully make review easier

Note: I will send a xfstest if this series is merged.

This series changes the behavior of rmdir(2) and allow it to delete an
empty subvolume.

In order so that, 1st and 2nd patch refactor btrfs_ioctl_snap_destroy()
and extract the actual deletion process as btrfs_delete_subvolume()
(remaining part in btrfs_ioctl_snap_destroy() is mainly permission checks).

Then, 3rd patch changes btrfs_rmdir() to call this function. The
required permission check is already done in vfs layer.

Tomohiro Misono (3):
  btrfs: Move may_destroy_subvol() from ioctl.c to inode.c
  btrfs: Factor out the main deletion process from btrfs_ioctl_snap_destroy()
  btrfs: Allow rmdir(2) to delete an empty subvolume

 fs/btrfs/ctree.h |   5 +-
 fs/btrfs/inode.c | 197 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ioctl.c | 185 +--------------------------------------------------
 3 files changed, 198 insertions(+), 189 deletions(-)

-- 
2.14.3


