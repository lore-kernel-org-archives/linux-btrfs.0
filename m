Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:52411 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753002AbeDRCfl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 22:35:41 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 62F8AAC00F2
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 11:35:36 +0900 (JST)
Received: from g01jpexchkw36.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 404CBBD6732
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 11:35:35 +0900 (JST)
Subject: [PATCH v5 3/3] btrfs: Allow rmdir(2) to delete an empty subvolume
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <558a949c-ceb5-115d-744f-80fac2620f7d@jp.fujitsu.com>
Message-ID: <afaab1c3-4f17-2d39-4de7-d4ab50e93b33@jp.fujitsu.com>
Date: Wed, 18 Apr 2018 11:35:31 +0900
MIME-Version: 1.0
In-Reply-To: <558a949c-ceb5-115d-744f-80fac2620f7d@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Change the behavior of rmdir(2) and allow it to delete an empty subvolume
by using btrfs_delete_subvolume() which is used by
btrfs_ioctl_snap_destroy(). The required lock for @dir and inode of
@dentry is already acquired in vfs layer.

We need some check before deleting a subvolume. Permission check is done
in vfs layer, emptiness check is in btrfs_rmdir() and additional check
(i.e. neither the subvolume is a default subvolume nor send is in progress)
is in btrfs_delete_subvolume().

Note that in btrfs_ioctl_snap_destroy(), d_delete() is called after
btrfs_delete_subvolume(). For rmdir(2), d_delete() is called in vfs
layer later.

Tested-by: Goffredo Baroncelli <kreijack@inwind.it>
Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b421aa8dd1a4..231e4c2ea1b4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4522,7 +4522,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
 		return -ENOTEMPTY;
 	if (btrfs_ino(BTRFS_I(inode)) == BTRFS_FIRST_FREE_OBJECTID)
-		return -EPERM;
+		return btrfs_delete_subvolume(dir, dentry);
 
 	trans = __unlink_start_trans(dir);
 	if (IS_ERR(trans))
-- 
2.14.3

