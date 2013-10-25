Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63357 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab3JYJci (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 05:32:38 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r9P9WYLB011986
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 17:32:34 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix the free space write out failure when there is no data space
Date: Fri, 25 Oct 2013 17:33:36 +0800
Message-Id: <1382693616-16976-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After running space balance on a new fs, the fs check program outputed the
following warning message:
 free space inode generation (0) did not match free space cache generation (20)

Steps to reproduce:
 # mkfs.btrfs -f <dev>
 # mount <dev> <mnt>
 # btrfs balance start <mnt>
 # umount <mnt>
 # btrfs check <dev>

It was because there was no data space after the space balance, and the free
space write out task didn't try to allocate a new data chunk for the free space
inode when doing the reservation. So the data space reservation failed, and in
order to tell the free space loader that this free space inode could not be
trusted, the generation of the free space inode wasn't updated. Then the check
program found this problem and outputed the above message.

But in fact, it is safe that we try to allocate a new data chunk when we find
the data space is not enough. The patch fixes the above problem by this way.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d58bef1..1d238ed 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3605,10 +3605,9 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 	/* make sure bytes are sectorsize aligned */
 	bytes = ALIGN(bytes, root->sectorsize);
 
-	if (root == root->fs_info->tree_root ||
-	    BTRFS_I(inode)->location.objectid == BTRFS_FREE_INO_OBJECTID) {
-		alloc_chunk = 0;
+	if (btrfs_is_free_space_inode(inode)) {
 		committed = 1;
+		ASSERT(current->journal_info);
 	}
 
 	data_sinfo = fs_info->data_sinfo;
@@ -3636,6 +3635,16 @@ again:
 			spin_unlock(&data_sinfo->lock);
 alloc:
 			alloc_target = btrfs_get_alloc_profile(root, 1);
+			/*
+			 * It is ugly that we don't call nolock join
+			 * transaction for the free space inode case here.
+			 * But it is safe because we only do the data space
+			 * reservation for the free space cache in the
+			 * transaction context, the common join transaction
+			 * just increase the counter of the current transaction
+			 * handler, doesn't try to acquire the trans_lock of
+			 * the fs.
+			 */
 			trans = btrfs_join_transaction(root);
 			if (IS_ERR(trans))
 				return PTR_ERR(trans);
-- 
1.8.3.1

