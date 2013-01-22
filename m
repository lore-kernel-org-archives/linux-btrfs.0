Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:15667 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab3AVKv2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 05:51:28 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0MApODI019388
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 18:51:24 +0800
Message-ID: <50FE6F54.9040201@cn.fujitsu.com>
Date: Tue, 22 Jan 2013 18:52:04 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/5] Btrfs: don't traverse the ordered operation list repeatedly
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_run_ordered_operations() needn't traverse the ordered operation list
repeatedly, it is because the transaction commiter will invoke it again when
there is no other writer in this transaction, it can ensure that no one can
add new objects into the ordered operation list.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ordered-data.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index f107312..5548176 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -558,14 +558,10 @@ int btrfs_run_ordered_operations(struct btrfs_root *root, int wait)
 
 	mutex_lock(&root->fs_info->ordered_operations_mutex);
 	spin_lock(&root->fs_info->ordered_extent_lock);
-again:
 	list_splice_init(&root->fs_info->ordered_operations, &splice);
-
 	while (!list_empty(&splice)) {
-
 		btrfs_inode = list_entry(splice.next, struct btrfs_inode,
 				   ordered_operations);
-
 		inode = &btrfs_inode->vfs_inode;
 
 		list_del_init(&btrfs_inode->ordered_operations);
@@ -574,22 +570,20 @@ again:
 		 * the inode may be getting freed (in sys_unlink path).
 		 */
 		inode = igrab(inode);
-
-		if (!wait && inode) {
-			list_add_tail(&BTRFS_I(inode)->ordered_operations,
-			      &root->fs_info->ordered_operations);
-		}
-
 		if (!inode)
 			continue;
+
+		if (!wait)
+			list_add_tail(&BTRFS_I(inode)->ordered_operations,
+				      &root->fs_info->ordered_operations);
 		spin_unlock(&root->fs_info->ordered_extent_lock);
 
 		work = btrfs_alloc_delalloc_work(inode, wait, 1);
 		if (!work) {
+			spin_lock(&root->fs_info->ordered_extent_lock);
 			if (list_empty(&BTRFS_I(inode)->ordered_operations))
 				list_add_tail(&btrfs_inode->ordered_operations,
 					      &splice);
-			spin_lock(&root->fs_info->ordered_extent_lock);
 			list_splice_tail(&splice,
 					 &root->fs_info->ordered_operations);
 			spin_unlock(&root->fs_info->ordered_extent_lock);
@@ -603,9 +597,6 @@ again:
 		cond_resched();
 		spin_lock(&root->fs_info->ordered_extent_lock);
 	}
-	if (wait && !list_empty(&root->fs_info->ordered_operations))
-		goto again;
-
 	spin_unlock(&root->fs_info->ordered_extent_lock);
 out:
 	list_for_each_entry_safe(work, next, &works, list) {
-- 
1.6.5.2
