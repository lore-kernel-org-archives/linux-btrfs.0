Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:11114 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbeDKFWM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 01:22:12 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id B15D0AC01FE
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 14:22:06 +0900 (JST)
Received: from g01jpexchkw34.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id D58FBBD6688
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 14:22:05 +0900 (JST)
Subject: [PATCH v4 4/4] btrfs: Allow rmdir(2) to delete an empty subvolume
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <d5c7d8e3-4c07-18c3-56a5-0482c899cfe5@jp.fujitsu.com>
Message-ID: <01a166e8-19b2-b29b-2d5f-26b90bfdbf2f@jp.fujitsu.com>
Date: Wed, 11 Apr 2018 14:22:03 +0900
MIME-Version: 1.0
In-Reply-To: <d5c7d8e3-4c07-18c3-56a5-0482c899cfe5@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Change the behaior of rmdir(2) and allow it to delete an empty subvolume
by calling btrfs_delete_subvolume() which is used by
btrfs_ioctl_snap_destroy(). The required lock for @dir and inode of
@dentry is already acquired in vfs layer.

We need some check before deleting a subvolume. Permission check is done
in vfs layer, emptiness check is in btrfs_rmdir() and additional check
(i.e. neither send is in progress nor the subvolume is a default subvolume)
is in btrfs_delete_subvolume().

Note that in btrfs_snap_destroy(), d_delete() is called after
btrfs_delete_subvolume(). For rmdir(2), d_delete() is called in vfs
layer later.

Tested-by: Goffredo Baroncelli <kreijack@inwind.it>
Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2db2e860ba90..afc631f28088 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4537,7 +4537,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
 		return -ENOTEMPTY;
 	if (btrfs_ino(BTRFS_I(inode)) == BTRFS_FIRST_FREE_OBJECTID)
-		return -EPERM;
+		return btrfs_delete_subvolume(dir, dentry);
 
 	trans = __unlink_start_trans(dir);
 	if (IS_ERR(trans))
-- 
2.14.3

