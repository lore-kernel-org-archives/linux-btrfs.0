Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33542 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934302AbdBQOoW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:22 -0500
Received: by mail-wm0-f68.google.com with SMTP id v77so2937977wmv.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:21 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 34/38] btrfs: Make btrfs_clear_bit_hook take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:25 +0200
Message-Id: <1487342609-20652-35-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c |  2 +-
 fs/btrfs/extent_io.h |  3 ++-
 fs/btrfs/inode.c     | 37 ++++++++++++++++++-------------------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index aecc3d87255e..fad5b2030c37 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -428,7 +428,7 @@ static void clear_state_cb(struct extent_io_tree *tree,
 			   struct extent_state *state, unsigned *bits)
 {
 	if (tree->ops && tree->ops->clear_bit_hook)
-		tree->ops->clear_bit_hook(tree->mapping->host, state, bits);
+		tree->ops->clear_bit_hook(BTRFS_I(tree->mapping->host), state, bits);
 }
 
 static void set_state_bits(struct extent_io_tree *tree,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a6150f1be662..302e64be2e20 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -84,6 +84,7 @@ extern void le_bitmap_clear(u8 *map, unsigned int start, int len);
 
 struct extent_state;
 struct btrfs_root;
+struct btrfs_inode;
 struct btrfs_io_bio;
 struct io_failure_record;
 
@@ -107,7 +108,7 @@ struct extent_io_ops {
 				      struct extent_state *state, int uptodate);
 	void (*set_bit_hook)(struct inode *inode, struct extent_state *state,
 			     unsigned *bits);
-	void (*clear_bit_hook)(struct inode *inode, struct extent_state *state,
+	void (*clear_bit_hook)(struct btrfs_inode *inode, struct extent_state *state,
 			       unsigned *bits);
 	void (*merge_extent_hook)(struct inode *inode,
 				  struct extent_state *new,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5545a49a3396..1ba412440979 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1706,18 +1706,18 @@ static void btrfs_set_bit_hook(struct inode *inode,
 /*
  * extent_io.c clear_bit_hook, see set_bit_hook for why
  */
-static void btrfs_clear_bit_hook(struct inode *inode,
+static void btrfs_clear_bit_hook(struct btrfs_inode *inode,
 				 struct extent_state *state,
 				 unsigned *bits)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	u64 len = state->end + 1 - state->start;
 	u32 num_extents = count_max_extents(len);
 
-	spin_lock(&BTRFS_I(inode)->lock);
+	spin_lock(&inode->lock);
 	if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG))
-		BTRFS_I(inode)->defrag_bytes -= len;
-	spin_unlock(&BTRFS_I(inode)->lock);
+		inode->defrag_bytes -= len;
+	spin_unlock(&inode->lock);
 
 	/*
 	 * set_bit and clear bit hooks normally require _irqsave/restore
@@ -1725,15 +1725,15 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 	 * bit, which is only set or cleared with irqs on
 	 */
 	if ((state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
-		struct btrfs_root *root = BTRFS_I(inode)->root;
-		bool do_list = !btrfs_is_free_space_inode(BTRFS_I(inode));
+		struct btrfs_root *root = inode->root;
+		bool do_list = !btrfs_is_free_space_inode(inode);
 
 		if (*bits & EXTENT_FIRST_DELALLOC) {
 			*bits &= ~EXTENT_FIRST_DELALLOC;
 		} else if (!(*bits & EXTENT_DO_ACCOUNTING)) {
-			spin_lock(&BTRFS_I(inode)->lock);
-			BTRFS_I(inode)->outstanding_extents -= num_extents;
-			spin_unlock(&BTRFS_I(inode)->lock);
+			spin_lock(&inode->lock);
+			inode->outstanding_extents -= num_extents;
+			spin_unlock(&inode->lock);
 		}
 
 		/*
@@ -1743,7 +1743,7 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 		 */
 		if (*bits & EXTENT_DO_ACCOUNTING &&
 		    root != fs_info->tree_root)
-			btrfs_delalloc_release_metadata(BTRFS_I(inode), len);
+			btrfs_delalloc_release_metadata(inode, len);
 
 		/* For sanity tests. */
 		if (btrfs_is_testing(fs_info))
@@ -1753,18 +1753,17 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 		    && do_list && !(state->state & EXTENT_NORESERVE)
 		    && (*bits & (EXTENT_DO_ACCOUNTING |
 		    EXTENT_CLEAR_DATA_RESV)))
-			btrfs_free_reserved_data_space_noquota(inode,
+			btrfs_free_reserved_data_space_noquota(&inode->vfs_inode,
 					state->start, len);
 
 		__percpu_counter_add(&fs_info->delalloc_bytes, -len,
 				     fs_info->delalloc_batch);
-		spin_lock(&BTRFS_I(inode)->lock);
-		BTRFS_I(inode)->delalloc_bytes -= len;
-		if (do_list && BTRFS_I(inode)->delalloc_bytes == 0 &&
-		    test_bit(BTRFS_INODE_IN_DELALLOC_LIST,
-			     &BTRFS_I(inode)->runtime_flags))
-			btrfs_del_delalloc_inode(root, inode);
-		spin_unlock(&BTRFS_I(inode)->lock);
+		spin_lock(&inode->lock);
+		inode->delalloc_bytes -= len;
+		if (do_list && inode->delalloc_bytes == 0 &&
+		    test_bit(BTRFS_INODE_IN_DELALLOC_LIST, &inode->runtime_flags))
+			btrfs_del_delalloc_inode(root, &inode->vfs_inode);
+		spin_unlock(&inode->lock);
 	}
 }
 
-- 
2.7.4

