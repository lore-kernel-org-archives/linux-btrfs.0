Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:48890 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab3ISUIf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Sep 2013 16:08:35 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id DCD809A0404
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Sep 2013 14:08:34 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id 5A1JAdGL2WRQKR1V (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 19 Sep 2013 14:08:34 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: add a sanity test for btrfs_split_item
Date: Thu, 19 Sep 2013 16:08:32 -0400
Message-ID: <1379621312-3823-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While looking at somebodys corruption I became completely convinced that
btrfs_split_item was broken, so I wrote this test to verify that it was working
as it was supposed to.  Thankfully it appears to be working as intended, so just
add this test to make sure nobody breaks it in the future.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/Makefile            |  3 ++-
 fs/btrfs/ctree.h             |  4 +++-
 fs/btrfs/disk-io.c           | 38 ++++++++++++++++++++++++++++++++++----
 fs/btrfs/disk-io.h           |  4 ++++
 fs/btrfs/super.c             |  7 ++++++-
 fs/btrfs/tests/btrfs-tests.h |  5 +++++
 6 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index a91a6a3..4c7dfbf 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -14,4 +14,5 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
 
-btrfs-$(CONFIG_BTRFS_FS_RUN_SANITY_TESTS) += tests/free-space-tests.o
+btrfs-$(CONFIG_BTRFS_FS_RUN_SANITY_TESTS) += tests/free-space-tests.o \
+	tests/extent-buffer-tests.o
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fa117f7d..ee0b8aa 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1724,7 +1724,9 @@ struct btrfs_root {
 	int ref_cows;
 	int track_dirty;
 	int in_radix;
-
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	int dummy_root;
+#endif
 	u64 defrag_trans_start;
 	struct btrfs_key defrag_progress;
 	struct btrfs_key defrag_max;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 17618b8..39427d8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1229,14 +1229,18 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	atomic_set(&root->refs, 1);
 	root->log_transid = 0;
 	root->last_log_commit = 0;
-	extent_io_tree_init(&root->dirty_log_pages,
-			     fs_info->btree_inode->i_mapping);
+	if (fs_info)
+		extent_io_tree_init(&root->dirty_log_pages,
+				     fs_info->btree_inode->i_mapping);
 
 	memset(&root->root_key, 0, sizeof(root->root_key));
 	memset(&root->root_item, 0, sizeof(root->root_item));
 	memset(&root->defrag_progress, 0, sizeof(root->defrag_progress));
 	memset(&root->root_kobj, 0, sizeof(root->root_kobj));
-	root->defrag_trans_start = fs_info->generation;
+	if (fs_info)
+		root->defrag_trans_start = fs_info->generation;
+	else
+		root->defrag_trans_start = 0;
 	init_completion(&root->kobj_unregister);
 	root->defrag_running = 0;
 	root->root_key.objectid = objectid;
@@ -1253,6 +1257,22 @@ static struct btrfs_root *btrfs_alloc_root(struct btrfs_fs_info *fs_info)
 	return root;
 }
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+/* Should only be used by the testing infrastructure */
+struct btrfs_root *btrfs_alloc_dummy_root(void)
+{
+	struct btrfs_root *root;
+
+	root = btrfs_alloc_root(NULL);
+	if (!root)
+		return ERR_PTR(-ENOMEM);
+	__setup_root(4096, 4096, 4096, 4096, root, NULL, 1);
+	root->dummy_root = 1;
+
+	return root;
+}
+#endif
+
 struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 				     struct btrfs_fs_info *fs_info,
 				     u64 objectid)
@@ -3669,10 +3689,20 @@ int btrfs_set_buffer_uptodate(struct extent_buffer *buf)
 
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 {
-	struct btrfs_root *root = BTRFS_I(buf->pages[0]->mapping->host)->root;
+	struct btrfs_root *root;
 	u64 transid = btrfs_header_generation(buf);
 	int was_dirty;
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	/*
+	 * This is a fast path so only do this check if we have sanity tests
+	 * enabled.  Normal people shouldn't be marking dummy buffers as dirty
+	 * outside of the sanity tests.
+	 */
+	if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &buf->bflags)))
+		return;
+#endif
+	root = BTRFS_I(buf->pages[0]->mapping->host)->root;
 	btrfs_assert_tree_locked(buf);
 	if (transid != root->fs_info->generation)
 		WARN(1, KERN_CRIT "btrfs transid mismatch buffer %llu, "
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index b71acd6e..8cd5be3 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -77,6 +77,10 @@ void btrfs_drop_and_free_fs_root(struct btrfs_fs_info *fs_info,
 				 struct btrfs_root *root);
 void btrfs_free_fs_root(struct btrfs_root *root);
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+struct btrfs_root *btrfs_alloc_dummy_root(void);
+#endif
+
 /*
  * This function is used to grab the root, and avoid it is freed when we
  * access it. But it doesn't ensure that the tree is not dropped.
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6ab0df5..56b719f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1779,7 +1779,12 @@ static void btrfs_print_info(void)
 
 static int btrfs_run_sanity_tests(void)
 {
-	return btrfs_test_free_space_cache();
+	int ret;
+
+	ret = btrfs_test_free_space_cache();
+	if (ret)
+		return ret;
+	return btrfs_test_extent_buffer_operations();
 }
 
 static int __init init_btrfs_fs(void)
diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
index 5808776..04f2cd2 100644
--- a/fs/btrfs/tests/btrfs-tests.h
+++ b/fs/btrfs/tests/btrfs-tests.h
@@ -24,11 +24,16 @@
 #define test_msg(fmt, ...) pr_info("btrfs: selftest: " fmt, ##__VA_ARGS__)
 
 int btrfs_test_free_space_cache(void);
+int btrfs_test_extent_buffer_operations(void);
 #else
 static inline int btrfs_test_free_space_cache(void)
 {
 	return 0;
 }
+static inline int btrfs_test_extent_buffer_operations(void)
+{
+	return 0;
+}
 #endif
 
 #endif
-- 
1.8.3.1

