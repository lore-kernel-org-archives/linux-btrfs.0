Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36565 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934320AbdBQOoN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:13 -0500
Received: by mail-wr0-f196.google.com with SMTP id z61so4717741wrc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:08 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 15/38] btrfs: Make btrfs_requeue_inode_defrag take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:06 +0200
Message-Id: <1487342609-20652-16-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nikolay Borisov <n.borisov.lkml@gmail.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/file.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 26ebb7608b92..18edcc74150c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -194,10 +194,10 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
  * the same inode in the tree, we will merge them together (by
  * __btrfs_add_inode_defrag()) and free the one that we want to requeue.
  */
-static void btrfs_requeue_inode_defrag(struct inode *inode,
+static void btrfs_requeue_inode_defrag(struct btrfs_inode *inode,
 				       struct inode_defrag *defrag)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	int ret;
 
 	if (!__need_auto_defrag(fs_info))
@@ -208,7 +208,7 @@ static void btrfs_requeue_inode_defrag(struct inode *inode,
 	 * them together.
 	 */
 	spin_lock(&fs_info->defrag_inodes_lock);
-	ret = __btrfs_add_inode_defrag(BTRFS_I(inode), defrag);
+	ret = __btrfs_add_inode_defrag(inode, defrag);
 	spin_unlock(&fs_info->defrag_inodes_lock);
 	if (ret)
 		goto out;
@@ -334,7 +334,7 @@ static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
 	 */
 	if (num_defrag == BTRFS_DEFRAG_BATCH) {
 		defrag->last_offset = range.start;
-		btrfs_requeue_inode_defrag(inode, defrag);
+		btrfs_requeue_inode_defrag(BTRFS_I(inode), defrag);
 	} else if (defrag->last_offset && !defrag->cycled) {
 		/*
 		 * we didn't fill our defrag batch, but
@@ -343,7 +343,7 @@ static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
 		 */
 		defrag->last_offset = 0;
 		defrag->cycled = 1;
-		btrfs_requeue_inode_defrag(inode, defrag);
+		btrfs_requeue_inode_defrag(BTRFS_I(inode), defrag);
 	} else {
 		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
 	}
-- 
2.7.4

