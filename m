Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27841 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751023AbbDCMNq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 08:13:46 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t33CCcAA020620
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Apr 2015 20:12:38 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 7/9] btrfs: Support busy loop of write and delete
Date: Fri, 3 Apr 2015 20:12:02 +0800
Message-ID: <b9602ba3bf8f09a7534c621e5874250e29d90343.1428062473.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1428062473.git.zhaolei@cn.fujitsu.com>
References: <cover.1428062473.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Reproduce:
 while true; do
   dd if=/dev/zero of=/mnt/btrfs/file count=[75% fs_size]
   rm /mnt/btrfs/file
 done
 Then we can see above loop failed on NO_SPACE.

It it long-term problem since very beginning, because delayed-iput
after rm are not run.

We already have commit_transaction() in alloc_space code, but it is
not triggered in above case.
This patch trigger commit_transaction() to run delayed-iput and
reflash pinned-space to to make write success.

It is based on previous fix of delayed-iput in commit_transaction(),
need to be applied on top of:
btrfs: Fix NO_SPACE bug caused by delayed-iput

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 203ac63..5683736 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3641,13 +3641,13 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 used;
-	int ret = 0, committed = 0, have_pinned_space = 1, alloc_chunk = 1;
+	int ret = 0, need_commit = 2, have_pinned_space, alloc_chunk = 1;
 
 	/* make sure bytes are sectorsize aligned */
 	bytes = ALIGN(bytes, root->sectorsize);
 
 	if (btrfs_is_free_space_inode(inode)) {
-		committed = 1;
+		need_commit = 0;
 		ASSERT(current->journal_info);
 	}
 
@@ -3697,8 +3697,10 @@ alloc:
 			if (ret < 0) {
 				if (ret != -ENOSPC)
 					return ret;
-				else
+				else {
+					have_pinned_space = 1;
 					goto commit_trans;
+				}
 			}
 
 			if (!data_sinfo)
@@ -3712,23 +3714,23 @@ alloc:
 		 * allocation, and no removed chunk in current transaction,
 		 * don't bother committing the transaction.
 		 */
-		if (percpu_counter_compare(&data_sinfo->total_bytes_pinned,
-					   used + bytes -
-					   data_sinfo->total_bytes) < 0)
-			have_pinned_space = 0;
+		have_pinned_space = percpu_counter_compare(
+			&data_sinfo->total_bytes_pinned,
+			used + bytes - data_sinfo->total_bytes);
 		spin_unlock(&data_sinfo->lock);
 
 		/* commit the current transaction and try again */
 commit_trans:
-		if (!committed &&
+		if (need_commit &&
 		    !atomic_read(&root->fs_info->open_ioctl_trans)) {
-			committed = 1;
+			need_commit--;
 
 			trans = btrfs_join_transaction(root);
 			if (IS_ERR(trans))
 				return PTR_ERR(trans);
-			if (have_pinned_space ||
-			    trans->transaction->have_free_bgs) {
+			if (have_pinned_space >= 0 ||
+			    trans->transaction->have_free_bgs ||
+			    need_commit > 0) {
 				ret = btrfs_commit_transaction(trans, root);
 				if (ret)
 					return ret;
-- 
1.8.5.1

