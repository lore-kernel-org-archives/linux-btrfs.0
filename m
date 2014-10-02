Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbaJBQuq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:50:46 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 798B7AAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:50:45 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 14/14] btrfs: move checks for DUMMY_ROOT into a helper
Date: Thu,  2 Oct 2014 18:50:45 +0200
Message-Id: <fccb84c94a9755f48668e43d0a44d6ecc750900f.1412264873.git.dsterba@suse.cz>
In-Reply-To: <cover.1412264871.git.dsterba@suse.cz>
References: <cover.1412264871.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.c       |  5 ++---
 fs/btrfs/ctree.h       |  9 +++++++++
 fs/btrfs/disk-io.c     |  4 +---
 fs/btrfs/extent-tree.c | 16 +++++++---------
 fs/btrfs/qgroup.c      | 10 ++++------
 5 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 533657c508e2..ce1d71d171bb 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1506,10 +1506,9 @@ static inline int should_cow_block(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   struct extent_buffer *buf)
 {
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-	if (unlikely(test_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state)))
+	if (btrfs_test_is_dummy_root(root))
 		return 0;
-#endif
+
 	/* ensure we can see the force_cow */
 	smp_rmb();
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bae025a20e63..557fd9520607 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4131,4 +4131,13 @@ int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
 			       u64 rfer, u64 excl);
 #endif
 
+static inline int btrfs_test_is_dummy_root(struct btrfs_root *root)
+{
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	if (unlikely(test_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state)))
+		return 1;
+#endif
+	return 0;
+}
+
 #endif
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0abf4b0a9010..14117f85b545 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1130,11 +1130,9 @@ struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 						 u64 bytenr, u32 blocksize)
 {
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-	if (unlikely(test_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state)))
+	if (btrfs_test_is_dummy_root(root))
 		return alloc_test_extent_buffer(root->fs_info, bytenr,
 						blocksize);
-#endif
 	return alloc_extent_buffer(root->fs_info, bytenr, blocksize);
 }
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 44d04979f071..7895db9c6bdc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3073,10 +3073,10 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
 			    u64, u64, u64, u64, u64, u64, int);
 
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-	if (unlikely(test_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state)))
+
+	if (btrfs_test_is_dummy_root(root))
 		return 0;
-#endif
+
 	ref_root = btrfs_header_owner(buf);
 	nritems = btrfs_header_nritems(buf);
 	level = btrfs_header_level(buf);
@@ -6264,10 +6264,9 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	int ret;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-	if (unlikely(test_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state)))
+	if (btrfs_test_is_dummy_root(root))
 		return 0;
-#endif
+
 	add_pinned_bytes(root->fs_info, num_bytes, owner, root_objectid);
 
 	/*
@@ -7336,15 +7335,14 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 	bool skinny_metadata = btrfs_fs_incompat(root->fs_info,
 						 SKINNY_METADATA);
 
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-	if (unlikely(test_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state))) {
+	if (btrfs_test_is_dummy_root(root)) {
 		buf = btrfs_init_new_buffer(trans, root, root->alloc_bytenr,
 					    blocksize, level);
 		if (!IS_ERR(buf))
 			root->alloc_bytenr += blocksize;
 		return buf;
 	}
-#endif
+
 	block_rsv = use_block_rsv(trans, root, blocksize);
 	if (IS_ERR(block_rsv))
 		return ERR_CAST(block_rsv);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index cd9717ea8c9d..48b60dbf807f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -539,10 +539,9 @@ static int add_qgroup_item(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
 
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-	if (unlikely(test_bit(BTRFS_ROOT_DUMMY_ROOT, &quota_root->state)))
+	if (btrfs_test_is_dummy_root(quota_root))
 		return 0;
-#endif
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -698,10 +697,9 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 	int ret;
 	int slot;
 
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-	if (unlikely(test_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state)))
+	if (btrfs_test_is_dummy_root(root))
 		return 0;
-#endif
+
 	key.objectid = 0;
 	key.type = BTRFS_QGROUP_INFO_KEY;
 	key.offset = qgroup->qgroupid;
-- 
1.8.4.5

