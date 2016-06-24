Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbcFXWPa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:30 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 295E3ADC0
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:27 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/31] btrfs: tests, use BTRFS_FS_STATE_DUMMY_FS_INFO instead of dummy root
Date: Fri, 24 Jun 2016 18:14:59 -0400
Message-Id: <1466806524-27508-7-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Now that we have a dummy fs_info associated with each test that
uses a root, we don't need the DUMMY_ROOT bit anymore.  This lets
us make choices without needing an actual root like in e.g.
btrfs_find_create_tree_block.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/backref.c     |  2 +-
 fs/btrfs/ctree.c       |  2 +-
 fs/btrfs/ctree.h       | 17 ++++++++---------
 fs/btrfs/disk-io.c     |  3 +--
 fs/btrfs/extent-tree.c |  8 ++++----
 fs/btrfs/inode.c       |  4 ++--
 fs/btrfs/qgroup.c      |  4 ++--
 7 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 8bb3509..8637069 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -361,7 +361,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 		goto out;
 	}
 
-	if (btrfs_test_is_dummy_root(root)) {
+	if (btrfs_is_testing(fs_info)) {
 		srcu_read_unlock(&fs_info->subvol_srcu, index);
 		ret = -ENOENT;
 		goto out;
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6276add..2bf3d58 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1505,7 +1505,7 @@ static inline int should_cow_block(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   struct extent_buffer *buf)
 {
-	if (btrfs_test_is_dummy_root(root))
+	if (btrfs_is_testing(root->fs_info))
 		return 0;
 
 	/* ensure we can see the force_cow */
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4781057..0b107d1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1113,12 +1113,11 @@ struct btrfs_subvolume_writers {
 #define BTRFS_ROOT_REF_COWS		1
 #define BTRFS_ROOT_TRACK_DIRTY		2
 #define BTRFS_ROOT_IN_RADIX		3
-#define BTRFS_ROOT_DUMMY_ROOT		4
-#define BTRFS_ROOT_ORPHAN_ITEM_INSERTED	5
-#define BTRFS_ROOT_DEFRAG_RUNNING	6
-#define BTRFS_ROOT_FORCE_COW		7
-#define BTRFS_ROOT_MULTI_LOG_TASKS	8
-#define BTRFS_ROOT_DIRTY		9
+#define BTRFS_ROOT_ORPHAN_ITEM_INSERTED	4
+#define BTRFS_ROOT_DEFRAG_RUNNING	5
+#define BTRFS_ROOT_FORCE_COW		6
+#define BTRFS_ROOT_MULTI_LOG_TASKS	7
+#define BTRFS_ROOT_DIRTY		8
 
 /*
  * in ram representation of the tree.  extent_root is used for all allocations
@@ -3600,13 +3599,13 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
 void btrfs_test_destroy_inode(struct inode *inode);
 #endif
 
-static inline int btrfs_test_is_dummy_root(struct btrfs_root *root)
+static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
 {
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-	if (unlikely(test_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state)))
+	if (unlikely(test_bit(BTRFS_FS_STATE_DUMMY_FS_INFO,
+			      &fs_info->fs_state)))
 		return 1;
 #endif
 	return 0;
 }
-
 #endif
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 418163d..e1b36e1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1146,7 +1146,7 @@ struct extent_buffer *btrfs_find_tree_block(struct btrfs_fs_info *fs_info,
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 						 u64 bytenr)
 {
-	if (btrfs_test_is_dummy_root(root))
+	if (btrfs_is_testing(root->fs_info))
 		return alloc_test_extent_buffer(root->fs_info, bytenr,
 				root->nodesize);
 	return alloc_extent_buffer(root->fs_info, bytenr);
@@ -1330,7 +1330,6 @@ struct btrfs_root *btrfs_alloc_dummy_root(struct btrfs_fs_info *fs_info,
 	/* We don't use the stripesize in selftest, set it as sectorsize */
 	__setup_root(nodesize, sectorsize, sectorsize, root, fs_info,
 			BTRFS_ROOT_TREE_OBJECTID);
-	set_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state);
 	root->alloc_bytenr = 0;
 
 	return root;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index efb5459..ee8cd29 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3214,7 +3214,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			    u64, u64, u64, u64, u64, u64);
 
 
-	if (btrfs_test_is_dummy_root(root))
+	if (btrfs_is_testing(root->fs_info))
 		return 0;
 
 	ref_root = btrfs_header_owner(buf);
@@ -5894,7 +5894,7 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 	if (dropped > 0)
 		to_free += btrfs_calc_trans_metadata_size(root, dropped);
 
-	if (btrfs_test_is_dummy_root(root))
+	if (btrfs_is_testing(root->fs_info))
 		return;
 
 	trace_btrfs_space_reservation(root->fs_info, "delalloc",
@@ -6992,7 +6992,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	int ret;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
-	if (btrfs_test_is_dummy_root(root))
+	if (btrfs_is_testing(fs_info))
 		return 0;
 
 	add_pinned_bytes(root->fs_info, num_bytes, owner, root_objectid);
@@ -8132,7 +8132,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 	bool skinny_metadata = btrfs_fs_incompat(root->fs_info,
 						 SKINNY_METADATA);
 
-	if (btrfs_test_is_dummy_root(root)) {
+	if (btrfs_is_testing(root->fs_info)) {
 		buf = btrfs_init_new_buffer(trans, root, root->alloc_bytenr,
 					    level);
 		if (!IS_ERR(buf))
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 141a233..1acba51 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1740,7 +1740,7 @@ static void btrfs_set_bit_hook(struct inode *inode,
 		}
 
 		/* For sanity tests */
-		if (btrfs_test_is_dummy_root(root))
+		if (btrfs_is_testing(root->fs_info))
 			return;
 
 		__percpu_counter_add(&root->fs_info->delalloc_bytes, len,
@@ -1799,7 +1799,7 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 			btrfs_delalloc_release_metadata(inode, len);
 
 		/* For sanity tests. */
-		if (btrfs_test_is_dummy_root(root))
+		if (btrfs_is_testing(root->fs_info))
 			return;
 
 		if (root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 13e28d8..3a83631 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -571,7 +571,7 @@ static int add_qgroup_item(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
 
-	if (btrfs_test_is_dummy_root(quota_root))
+	if (btrfs_is_testing(quota_root->fs_info))
 		return 0;
 
 	path = btrfs_alloc_path();
@@ -728,7 +728,7 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 	int ret;
 	int slot;
 
-	if (btrfs_test_is_dummy_root(root))
+	if (btrfs_is_testing(root->fs_info))
 		return 0;
 
 	key.objectid = 0;
-- 
2.7.1

