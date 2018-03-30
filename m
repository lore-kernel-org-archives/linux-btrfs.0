Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:24679 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbeC3GQD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 02:16:03 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id CBFE9AC00C3
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 15:15:55 +0900 (JST)
Received: from G01JPEXCHYT15.g01.fujitsu.local (G01JPEXCHYT15.g01.fujitsu.local [10.128.194.54])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 1E8B246E955
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 15:15:55 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH v3 0/3] Allow rmdir(2) to delete a subvolume
Message-ID: <1c798713-c896-f20c-5551-b8480ca74b72@jp.fujitsu.com>
Date: Fri, 30 Mar 2018 15:15:52 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

changelog:
  v2 -> v3 ... use if-else block instead of two if blocks and 
               add Tested-by tag in 2nd patch
  v1 -> v2 ... split the patch to hopefully make review easier

Note: I will send a xfstest if this series is merged.

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
  btrfs: cleanup btrfs_ioctl_snap_destroy() by using
    btrfs_delete_subvolume()

 fs/btrfs/ctree.h |   5 +-
 fs/btrfs/inode.c | 197 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ioctl.c | 185 +--------------------------------------------------
 3 files changed, 198 insertions(+), 189 deletions(-)

-- 
2.14.3


