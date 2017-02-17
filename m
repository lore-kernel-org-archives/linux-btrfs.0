Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35043 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934421AbdBQOoC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:02 -0500
Received: by mail-wr0-f193.google.com with SMTP id q39so5486933wrb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:02 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 14/38] btrfs: Make (__)btrfs_add_inode_defrag take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:05 +0200
Message-Id: <1487342609-20652-15-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nikolay Borisov <n.borisov.lkml@gmail.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h |  2 +-
 fs/btrfs/file.c  | 22 +++++++++++-----------
 fs/btrfs/inode.c |  8 ++++----
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7f7f3b60a73d..5246cbe4c17f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3215,7 +3215,7 @@ ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
 int btrfs_auto_defrag_init(void);
 void btrfs_auto_defrag_exit(void);
 int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
-			   struct inode *inode);
+			   struct btrfs_inode *inode);
 int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info);
 void btrfs_cleanup_defrag_inodes(struct btrfs_fs_info *fs_info);
 int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1e98e0673684..26ebb7608b92 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -92,10 +92,10 @@ static int __compare_inode_defrag(struct inode_defrag *defrag1,
  * If an existing record is found the defrag item you
  * pass in is freed
  */
-static int __btrfs_add_inode_defrag(struct inode *inode,
+static int __btrfs_add_inode_defrag(struct btrfs_inode *inode,
 				    struct inode_defrag *defrag)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	struct inode_defrag *entry;
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
@@ -123,7 +123,7 @@ static int __btrfs_add_inode_defrag(struct inode *inode,
 			return -EEXIST;
 		}
 	}
-	set_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags);
+	set_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags);
 	rb_link_node(&defrag->rb_node, parent, p);
 	rb_insert_color(&defrag->rb_node, &fs_info->defrag_inodes);
 	return 0;
@@ -145,10 +145,10 @@ static inline int __need_auto_defrag(struct btrfs_fs_info *fs_info)
  * enabled
  */
 int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
-			   struct inode *inode)
+			   struct btrfs_inode *inode)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_root *root = inode->root;
 	struct inode_defrag *defrag;
 	u64 transid;
 	int ret;
@@ -156,24 +156,24 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 	if (!__need_auto_defrag(fs_info))
 		return 0;
 
-	if (test_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags))
+	if (test_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags))
 		return 0;
 
 	if (trans)
 		transid = trans->transid;
 	else
-		transid = BTRFS_I(inode)->root->last_trans;
+		transid = inode->root->last_trans;
 
 	defrag = kmem_cache_zalloc(btrfs_inode_defrag_cachep, GFP_NOFS);
 	if (!defrag)
 		return -ENOMEM;
 
-	defrag->ino = btrfs_ino(BTRFS_I(inode));
+	defrag->ino = btrfs_ino(inode);
 	defrag->transid = transid;
 	defrag->root = root->root_key.objectid;
 
 	spin_lock(&fs_info->defrag_inodes_lock);
-	if (!test_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags)) {
+	if (!test_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags)) {
 		/*
 		 * If we set IN_DEFRAG flag and evict the inode from memory,
 		 * and then re-read this inode, this new inode doesn't have
@@ -208,7 +208,7 @@ static void btrfs_requeue_inode_defrag(struct inode *inode,
 	 * them together.
 	 */
 	spin_lock(&fs_info->defrag_inodes_lock);
-	ret = __btrfs_add_inode_defrag(inode, defrag);
+	ret = __btrfs_add_inode_defrag(BTRFS_I(inode), defrag);
 	spin_unlock(&fs_info->defrag_inodes_lock);
 	if (ret)
 		goto out;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 34cd64720eda..4d81f83a2a5d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -389,12 +389,12 @@ static inline int inode_need_compress(struct inode *inode)
 	return 0;
 }
 
-static inline void inode_should_defrag(struct inode *inode,
+static inline void inode_should_defrag(struct btrfs_inode *inode,
 		u64 start, u64 end, u64 num_bytes, u64 small_write)
 {
 	/* If this is a small write inside eof, kick off a defrag */
 	if (num_bytes < small_write &&
-	    (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
+	    (start > 0 || end + 1 < inode->disk_i_size))
 		btrfs_add_inode_defrag(NULL, inode);
 }
 
@@ -440,7 +440,7 @@ static noinline void compress_file_range(struct inode *inode,
 	int compress_type = fs_info->compress_type;
 	int redirty = 0;
 
-	inode_should_defrag(inode, start, end, end - start + 1, SZ_16K);
+	inode_should_defrag(BTRFS_I(inode), start, end, end - start + 1, SZ_16K);
 
 	actual_end = min_t(u64, isize, end + 1);
 again:
@@ -943,7 +943,7 @@ static noinline int cow_file_range(struct inode *inode,
 	num_bytes = max(blocksize,  num_bytes);
 	disk_num_bytes = num_bytes;
 
-	inode_should_defrag(inode, start, end, num_bytes, SZ_64K);
+	inode_should_defrag(BTRFS_I(inode), start, end, num_bytes, SZ_64K);
 
 	if (start == 0) {
 		/* lets try to make an inline extent */
-- 
2.7.4

