Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38729 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751909Ab3LRVHt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 16:07:49 -0500
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id rBIL3kjU031462
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 13:07:48 -0800
Received: from mail.thefacebook.com (prn1-cmdf-dc01-fw1-nat.corp.tfbnw.net [173.252.71.129] (may be forged))
	by mx0b-00082601.pphosted.com with ESMTP id 1gu017k9p4-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 13:07:48 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] Btrfs: add sanity tests for new qgroup accounting code
Date: Wed, 18 Dec 2013 16:07:29 -0500
Message-ID: <1387400849-7274-4-git-send-email-jbacik@fb.com>
In-Reply-To: <1387400849-7274-1-git-send-email-jbacik@fb.com>
References: <1387400849-7274-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This exercises the various parts of the new qgroup accounting code.  We do some
basic stuff and do some things with the shared refs to make sure all that code
works.  I had to add a bunch of infrastructure because I needed to be able to
insert items into a fake tree without having to do all the hard work myself,
hopefully this will be usefull in the future.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/Makefile             |   2 +-
 fs/btrfs/ctree.c              |   4 +
 fs/btrfs/ctree.h              |   3 +
 fs/btrfs/disk-io.c            |  18 +-
 fs/btrfs/disk-io.h            |   1 +
 fs/btrfs/extent-tree.c        |  25 ++
 fs/btrfs/extent_io.c          |  47 ++++
 fs/btrfs/extent_io.h          |   2 +
 fs/btrfs/qgroup.c             |  23 ++
 fs/btrfs/super.c              |   3 +
 fs/btrfs/tests/btrfs-tests.c  |  91 +++++++
 fs/btrfs/tests/btrfs-tests.h  |   9 +
 fs/btrfs/tests/inode-tests.c  |  35 +--
 fs/btrfs/tests/qgroup-tests.c | 617 ++++++++++++++++++++++++++++++++++++++++++
 14 files changed, 843 insertions(+), 37 deletions(-)
 create mode 100644 fs/btrfs/tests/qgroup-tests.c

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 1a44e42..e6df2dd 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -16,4 +16,4 @@ btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
 
 btrfs-$(CONFIG_BTRFS_FS_RUN_SANITY_TESTS) += tests/free-space-tests.o \
 	tests/extent-buffer-tests.o tests/btrfs-tests.o \
-	tests/extent-io-tests.o tests/inode-tests.o
+	tests/extent-io-tests.o tests/inode-tests.o tests/qgroup-tests.o
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a57507a..38ef590 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1344,6 +1344,10 @@ static inline int should_cow_block(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   struct extent_buffer *buf)
 {
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	if (unlikely(root->dummy_root))
+		return 0;
+#endif
 	/* ensure we can see the force_cow */
 	smp_rmb();
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 944c916..8ad5adb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1783,6 +1783,7 @@ struct btrfs_root {
 	int in_radix;
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 	int dummy_root;
+	u64 alloc_bytenr;
 #endif
 	u64 defrag_trans_start;
 	struct btrfs_key defrag_progress;
@@ -4094,6 +4095,8 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
 /* Sanity test specific functions */
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 void btrfs_test_destroy_inode(struct inode *inode);
+int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
+			       u64 rfer, u64 excl);
 #endif
 
 #endif
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3eb27b9..c30de3d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1095,6 +1095,11 @@ struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 						 u64 bytenr, u32 blocksize)
 {
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	if (unlikely(root->dummy_root))
+		return alloc_test_extent_buffer(root->fs_info, bytenr,
+						blocksize);
+#endif
 	return alloc_extent_buffer(root->fs_info, bytenr, blocksize);
 }
 
@@ -1245,6 +1250,7 @@ struct btrfs_root *btrfs_alloc_dummy_root(void)
 		return ERR_PTR(-ENOMEM);
 	__setup_root(4096, 4096, 4096, 4096, root, NULL, 1);
 	root->dummy_root = 1;
+	root->alloc_bytenr = 0;
 
 	return root;
 }
@@ -2034,7 +2040,7 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 		free_root_extent_buffers(info->chunk_root);
 }
 
-static void del_fs_roots(struct btrfs_fs_info *fs_info)
+void btrfs_free_fs_roots(struct btrfs_fs_info *fs_info)
 {
 	int ret;
 	struct btrfs_root *gang[8];
@@ -2929,7 +2935,7 @@ fail_qgroup:
 fail_trans_kthread:
 	kthread_stop(fs_info->transaction_kthread);
 	btrfs_cleanup_transaction(fs_info->tree_root);
-	del_fs_roots(fs_info);
+	btrfs_free_fs_roots(fs_info);
 fail_cleaner:
 	kthread_stop(fs_info->cleaner_kthread);
 
@@ -3454,8 +3460,10 @@ void btrfs_drop_and_free_fs_root(struct btrfs_fs_info *fs_info,
 		btrfs_free_log_root_tree(NULL, fs_info);
 	}
 
-	__btrfs_remove_free_space_cache(root->free_ino_pinned);
-	__btrfs_remove_free_space_cache(root->free_ino_ctl);
+	if (root->free_ino_pinned)
+		__btrfs_remove_free_space_cache(root->free_ino_pinned);
+	if (root->free_ino_ctl)
+		__btrfs_remove_free_space_cache(root->free_ino_ctl);
 	free_fs_root(root);
 }
 
@@ -3580,7 +3588,7 @@ int close_ctree(struct btrfs_root *root)
 
 	btrfs_sysfs_remove_one(fs_info);
 
-	del_fs_roots(fs_info);
+	btrfs_free_fs_roots(fs_info);
 
 	btrfs_free_block_groups(fs_info);
 
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 53059df..23ce3ce 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -68,6 +68,7 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
 int btrfs_init_fs_root(struct btrfs_root *root);
 int btrfs_insert_fs_root(struct btrfs_fs_info *fs_info,
 			 struct btrfs_root *root);
+void btrfs_free_fs_roots(struct btrfs_fs_info *fs_info);
 
 struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
 				     struct btrfs_key *key,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 71673d6..3cfdbc4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -694,6 +694,10 @@ int lock_ref(struct btrfs_fs_info *fs_info, u64 root_objectid, u64 bytenr,
 	struct btrfs_block_group_cache *cache;
 	int ret;
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	if (unlikely(fs_info->extent_root->dummy_root))
+		return 0;
+#endif
 	if (!fs_info->quota_enabled || !is_fstree(root_objectid))
 		return 0;
 
@@ -731,6 +735,10 @@ int unlock_ref(struct btrfs_fs_info *fs_info, u64 root_objectid, u64 bytenr,
 {
 	int ret;
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	if (unlikely(fs_info->extent_root->dummy_root))
+		return 0;
+#endif
 	if (!fs_info->quota_enabled || !is_fstree(root_objectid))
 		return 0;
 
@@ -3404,6 +3412,10 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
 			    u64, u64, u64, u64, u64, u64, int);
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	if (unlikely(root->dummy_root))
+		return 0;
+#endif
 	ref_root = btrfs_header_owner(buf);
 	nritems = btrfs_header_nritems(buf);
 	level = btrfs_header_level(buf);
@@ -6477,6 +6489,10 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	int ret;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	if (unlikely(root->dummy_root))
+		return 0;
+#endif
 	add_pinned_bytes(root->fs_info, num_bytes, owner, root_objectid);
 
 	/*
@@ -7477,6 +7493,15 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 	bool skinny_metadata = btrfs_fs_incompat(root->fs_info,
 						 SKINNY_METADATA);
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	if (unlikely(root->dummy_root)) {
+		buf = btrfs_init_new_buffer(trans, root, root->alloc_bytenr,
+					    blocksize, level);
+		if (!IS_ERR(buf))
+			root->alloc_bytenr += blocksize;
+		return buf;
+	}
+#endif
 	block_rsv = use_block_rsv(trans, root, blocksize);
 	if (IS_ERR(block_rsv))
 		return ERR_CAST(block_rsv);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a8cc389..d0ace88 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4540,6 +4540,53 @@ struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
 	return NULL;
 }
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
+					       u64 start, unsigned long len)
+{
+	struct extent_buffer *eb, *exists = NULL;
+	int ret;
+
+	eb = find_extent_buffer(fs_info, start);
+	if (eb)
+		return eb;
+	eb = alloc_dummy_extent_buffer(start, len);
+	if (!eb)
+		return NULL;
+	eb->fs_info = fs_info;
+again:
+	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+	if (ret)
+		goto free_eb;
+	spin_lock(&fs_info->buffer_lock);
+	ret = radix_tree_insert(&fs_info->buffer_radix,
+				start >> PAGE_CACHE_SHIFT, eb);
+	spin_unlock(&fs_info->buffer_lock);
+	radix_tree_preload_end();
+	if (ret == -EEXIST) {
+		exists = find_extent_buffer(fs_info, start);
+		if (exists)
+			goto free_eb;
+		else
+			goto again;
+	}
+	check_buffer_tree_ref(eb);
+	set_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags);
+
+	/*
+	 * We will free dummy extent buffer's if they come into
+	 * free_extent_buffer with a ref count of 2, but if we are using this we
+	 * want the buffers to stay in memory until we're done with them, so
+	 * bump the ref count again.
+	 */
+	atomic_inc(&eb->refs);
+	return eb;
+free_eb:
+	btrfs_release_extent_buffer(eb);
+	return exists;
+}
+#endif
+
 struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 					  u64 start, unsigned long len)
 {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 58b27e5..a47dca1 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -349,5 +349,7 @@ noinline u64 find_lock_delalloc_range(struct inode *inode,
 				      struct extent_io_tree *tree,
 				      struct page *locked_page, u64 *start,
 				      u64 *end, u64 max_bytes);
+struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
+					       u64 start, unsigned long len);
 #endif
 #endif
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1ecc528..6831e30 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -259,6 +259,21 @@ static int del_relation_rb(struct btrfs_fs_info *fs_info,
 	return -ENOENT;
 }
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
+			       u64 rfer, u64 excl)
+{
+	struct btrfs_qgroup *qgroup;
+
+	qgroup = find_qgroup_rb(fs_info, qgroupid);
+	if (!qgroup)
+		return -EINVAL;
+	if (qgroup->rfer != rfer || qgroup->excl != excl)
+		return -EINVAL;
+	return 0;
+}
+#endif
+
 /*
  * The full config is read in one go, only called from open_ctree()
  * It doesn't use any locking, as at this point we're still single-threaded
@@ -537,6 +552,10 @@ static int add_qgroup_item(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	if (unlikely(quota_root->dummy_root))
+		return 0;
+#endif
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -686,6 +705,10 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 	int ret;
 	int slot;
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	if (unlikely(root->dummy_root))
+		return 0;
+#endif
 	key.objectid = 0;
 	key.type = BTRFS_QGROUP_INFO_KEY;
 	key.offset = qgroup->qgroupid;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0d4b1c3..fb322d9 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1809,6 +1809,9 @@ static int btrfs_run_sanity_tests(void)
 	if (ret)
 		goto out;
 	ret = btrfs_test_inodes();
+	if (ret)
+		goto out;
+	ret = btrfs_test_qgroups();
 out:
 	btrfs_destroy_test_fs();
 	return ret;
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 757ef00..b359caa 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -21,6 +21,8 @@
 #include <linux/magic.h>
 #include "btrfs-tests.h"
 #include "../ctree.h"
+#include "../volumes.h"
+#include "../disk-io.h"
 
 static struct vfsmount *test_mnt = NULL;
 
@@ -72,3 +74,92 @@ void btrfs_destroy_test_fs(void)
 	kern_unmount(test_mnt);
 	unregister_filesystem(&test_type);
 }
+
+struct btrfs_fs_info *btrfs_alloc_dummy_fs_info(void)
+{
+	struct btrfs_fs_info *fs_info = kzalloc(sizeof(struct btrfs_fs_info),
+						GFP_NOFS);
+
+	if (!fs_info)
+		return fs_info;
+	fs_info->fs_devices = kzalloc(sizeof(struct btrfs_fs_devices),
+				      GFP_NOFS);
+	if (!fs_info->fs_devices) {
+		kfree(fs_info);
+		return NULL;
+	}
+	fs_info->super_copy = kzalloc(sizeof(struct btrfs_super_block),
+				      GFP_NOFS);
+	if (!fs_info->super_copy) {
+		kfree(fs_info->fs_devices);
+		kfree(fs_info);
+		return NULL;
+	}
+
+	if (init_srcu_struct(&fs_info->subvol_srcu)) {
+		kfree(fs_info->fs_devices);
+		kfree(fs_info->super_copy);
+		kfree(fs_info);
+		return NULL;
+	}
+
+	spin_lock_init(&fs_info->buffer_lock);
+	spin_lock_init(&fs_info->qgroup_lock);
+	spin_lock_init(&fs_info->super_lock);
+	spin_lock_init(&fs_info->fs_roots_radix_lock);
+	mutex_init(&fs_info->qgroup_ioctl_lock);
+	mutex_init(&fs_info->qgroup_rescan_lock);
+	fs_info->running_transaction = NULL;
+	fs_info->qgroup_tree = RB_ROOT;
+	fs_info->qgroup_ulist = NULL;
+	INIT_LIST_HEAD(&fs_info->dirty_qgroups);
+	INIT_LIST_HEAD(&fs_info->dead_roots);
+	INIT_RADIX_TREE(&fs_info->buffer_radix, GFP_ATOMIC);
+	INIT_RADIX_TREE(&fs_info->fs_roots_radix, GFP_ATOMIC);
+	return fs_info;
+}
+
+static void btrfs_free_dummy_fs_info(struct btrfs_fs_info *fs_info)
+{
+	struct radix_tree_iter iter;
+	void **slot;
+
+	spin_lock(&fs_info->buffer_lock);
+restart:
+	radix_tree_for_each_slot(slot, &fs_info->buffer_radix, &iter, 0) {
+		struct extent_buffer *eb;
+
+		eb = radix_tree_deref_slot(slot);
+		if (!eb)
+			continue;
+		/* Shouldn't happen but that kind of thinking creates CVE's */
+		if (radix_tree_exception(eb)) {
+			if (radix_tree_deref_retry(eb))
+				goto restart;
+			continue;
+		}
+		spin_unlock(&fs_info->buffer_lock);
+		free_extent_buffer_stale(eb);
+		spin_lock(&fs_info->buffer_lock);
+	}
+	spin_unlock(&fs_info->buffer_lock);
+
+	btrfs_free_qgroup_config(fs_info);
+	btrfs_free_fs_roots(fs_info);
+	cleanup_srcu_struct(&fs_info->subvol_srcu);
+	kfree(fs_info->super_copy);
+	kfree(fs_info->fs_devices);
+	kfree(fs_info);
+}
+
+void btrfs_free_dummy_root(struct btrfs_root *root)
+{
+	if (!root)
+		return;
+	if (root->node)
+		free_extent_buffer(root->node);
+	if (root->fs_info)
+		btrfs_free_dummy_fs_info(root->fs_info);
+	kfree(root);
+}
+
diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
index b353bc8..d2dc9e4 100644
--- a/fs/btrfs/tests/btrfs-tests.h
+++ b/fs/btrfs/tests/btrfs-tests.h
@@ -23,13 +23,18 @@
 
 #define test_msg(fmt, ...) pr_info("btrfs: selftest: " fmt, ##__VA_ARGS__)
 
+struct btrfs_root;
+
 int btrfs_test_free_space_cache(void);
 int btrfs_test_extent_buffer_operations(void);
 int btrfs_test_extent_io(void);
 int btrfs_test_inodes(void);
+int btrfs_test_qgroups(void);
 int btrfs_init_test_fs(void);
 void btrfs_destroy_test_fs(void);
 struct inode *btrfs_new_test_inode(void);
+struct btrfs_fs_info *btrfs_alloc_dummy_fs_info(void);
+void btrfs_free_dummy_root(struct btrfs_root *root);
 #else
 static inline int btrfs_test_free_space_cache(void)
 {
@@ -54,6 +59,10 @@ static inline int btrfs_test_inodes(void)
 {
 	return 0;
 }
+static inline int btrfs_test_qgroups(void)
+{
+	return 0;
+}
 #endif
 
 #endif
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 397d1f9..3ae0f5b 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -23,33 +23,6 @@
 #include "../extent_io.h"
 #include "../volumes.h"
 
-static struct btrfs_fs_info *alloc_dummy_fs_info(void)
-{
-	struct btrfs_fs_info *fs_info = kzalloc(sizeof(struct btrfs_fs_info),
-						GFP_NOFS);
-	if (!fs_info)
-		return fs_info;
-	fs_info->fs_devices = kzalloc(sizeof(struct btrfs_fs_devices),
-				      GFP_NOFS);
-	if (!fs_info->fs_devices) {
-		kfree(fs_info);
-		return NULL;
-	}
-	return fs_info;
-}
-static void free_dummy_root(struct btrfs_root *root)
-{
-	if (!root)
-		return;
-	if (root->fs_info) {
-		kfree(root->fs_info->fs_devices);
-		kfree(root->fs_info);
-	}
-	if (root->node)
-		free_extent_buffer(root->node);
-	kfree(root);
-}
-
 static void insert_extent(struct btrfs_root *root, u64 start, u64 len,
 			  u64 ram_bytes, u64 offset, u64 disk_bytenr,
 			  u64 disk_len, u32 type, u8 compression, int slot)
@@ -276,7 +249,7 @@ static noinline int test_btrfs_get_extent(void)
 	 * We do this since btrfs_get_extent wants to assign em->bdev to
 	 * root->fs_info->fs_devices->latest_bdev.
 	 */
-	root->fs_info = alloc_dummy_fs_info();
+	root->fs_info = btrfs_alloc_dummy_fs_info();
 	if (!root->fs_info) {
 		test_msg("Couldn't allocate dummy fs info\n");
 		goto out;
@@ -837,7 +810,7 @@ out:
 	if (!IS_ERR(em))
 		free_extent_map(em);
 	iput(inode);
-	free_dummy_root(root);
+	btrfs_free_dummy_root(root);
 	return ret;
 }
 
@@ -864,7 +837,7 @@ static int test_hole_first(void)
 		goto out;
 	}
 
-	root->fs_info = alloc_dummy_fs_info();
+	root->fs_info = btrfs_alloc_dummy_fs_info();
 	if (!root->fs_info) {
 		test_msg("Couldn't allocate dummy fs info\n");
 		goto out;
@@ -934,7 +907,7 @@ out:
 	if (!IS_ERR(em))
 		free_extent_map(em);
 	iput(inode);
-	free_dummy_root(root);
+	btrfs_free_dummy_root(root);
 	return ret;
 }
 
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
new file mode 100644
index 0000000..36d1498
--- /dev/null
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -0,0 +1,617 @@
+/*
+ * Copyright (C) 2013 Facebook.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include "btrfs-tests.h"
+#include "../ctree.h"
+#include "../transaction.h"
+#include "../disk-io.h"
+
+static void init_dummy_trans(struct btrfs_trans_handle *trans)
+{
+	memset(trans, 0, sizeof(*trans));
+	trans->transid = 1;
+	INIT_LIST_HEAD(&trans->qgroup_ref_list);
+}
+
+static int insert_normal_tree_ref(struct btrfs_root *root, u64 bytenr,
+				  u64 num_bytes, u64 parent, u64 root_objectid)
+{
+	struct btrfs_trans_handle trans;
+	struct btrfs_extent_item *item;
+	struct btrfs_extent_inline_ref *iref;
+	struct btrfs_tree_block_info *block_info;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_key ins;
+	u32 size = sizeof(*item) + sizeof(*iref) + sizeof(*block_info);
+	int ret;
+
+	init_dummy_trans(&trans);
+
+	ins.objectid = bytenr;
+	ins.type = BTRFS_EXTENT_ITEM_KEY;
+	ins.offset = num_bytes;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		test_msg("Couldn't allocate path\n");
+		return -ENOMEM;
+	}
+
+	path->leave_spinning = 1;
+	ret = btrfs_insert_empty_item(&trans, root, path, &ins, size);
+	if (ret) {
+		test_msg("Couldn't insert ref %d\n", ret);
+		btrfs_free_path(path);
+		return ret;
+	}
+
+	leaf = path->nodes[0];
+	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
+	btrfs_set_extent_refs(leaf, item, 1);
+	btrfs_set_extent_generation(leaf, item, 1);
+	btrfs_set_extent_flags(leaf, item, BTRFS_EXTENT_FLAG_TREE_BLOCK);
+	block_info = (struct btrfs_tree_block_info *)(item + 1);
+	btrfs_set_tree_block_level(leaf, block_info, 1);
+	iref = (struct btrfs_extent_inline_ref *)(block_info + 1);
+	if (parent > 0) {
+		btrfs_set_extent_inline_ref_type(leaf, iref,
+						 BTRFS_SHARED_BLOCK_REF_KEY);
+		btrfs_set_extent_inline_ref_offset(leaf, iref, parent);
+	} else {
+		btrfs_set_extent_inline_ref_type(leaf, iref, BTRFS_TREE_BLOCK_REF_KEY);
+		btrfs_set_extent_inline_ref_offset(leaf, iref, root_objectid);
+	}
+	btrfs_free_path(path);
+	return 0;
+}
+
+static int add_tree_ref(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
+			u64 parent, u64 root_objectid)
+{
+	struct btrfs_trans_handle trans;
+	struct btrfs_extent_item *item;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	u64 refs;
+	int ret;
+
+	init_dummy_trans(&trans);
+
+	key.objectid = bytenr;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+	key.offset = num_bytes;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		test_msg("Couldn't allocate path\n");
+		return -ENOMEM;
+	}
+
+	path->leave_spinning = 1;
+	ret = btrfs_search_slot(&trans, root, &key, path, 0, 1);
+	if (ret) {
+		test_msg("Couldn't find extent ref\n");
+		btrfs_free_path(path);
+		return ret;
+	}
+
+	item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			      struct btrfs_extent_item);
+	refs = btrfs_extent_refs(path->nodes[0], item);
+	btrfs_set_extent_refs(path->nodes[0], item, refs + 1);
+	btrfs_release_path(path);
+
+	key.objectid = bytenr;
+	if (parent) {
+		key.type = BTRFS_SHARED_BLOCK_REF_KEY;
+		key.offset = parent;
+	} else {
+		key.type = BTRFS_TREE_BLOCK_REF_KEY;
+		key.offset = root_objectid;
+	}
+
+	ret = btrfs_insert_empty_item(&trans, root, path, &key, 0);
+	if (ret)
+		test_msg("Failed to insert backref\n");
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int remove_extent_item(struct btrfs_root *root, u64 bytenr,
+			      u64 num_bytes)
+{
+	struct btrfs_trans_handle trans;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	int ret;
+
+	init_dummy_trans(&trans);
+
+	key.objectid = bytenr;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+	key.offset = num_bytes;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		test_msg("Couldn't allocate path\n");
+		return -ENOMEM;
+	}
+	path->leave_spinning = 1;
+
+	ret = btrfs_search_slot(&trans, root, &key, path, -1, 1);
+	if (ret) {
+		test_msg("Didn't find our key %d\n", ret);
+		btrfs_free_path(path);
+		return ret;
+	}
+	btrfs_del_item(&trans, root, path);
+	btrfs_free_path(path);
+	return 0;
+}
+
+static int remove_extent_ref(struct btrfs_root *root, u64 bytenr,
+			     u64 num_bytes, u64 parent, u64 root_objectid)
+{
+	struct btrfs_trans_handle trans;
+	struct btrfs_extent_item *item;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	u64 refs;
+	int ret;
+
+	init_dummy_trans(&trans);
+
+	key.objectid = bytenr;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+	key.offset = num_bytes;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		test_msg("Couldn't allocate path\n");
+		return -ENOMEM;
+	}
+
+	path->leave_spinning = 1;
+	ret = btrfs_search_slot(&trans, root, &key, path, 0, 1);
+	if (ret) {
+		test_msg("Couldn't find extent ref\n");
+		btrfs_free_path(path);
+		return ret;
+	}
+
+	item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			      struct btrfs_extent_item);
+	refs = btrfs_extent_refs(path->nodes[0], item);
+	btrfs_set_extent_refs(path->nodes[0], item, refs - 1);
+	btrfs_release_path(path);
+
+	key.objectid = bytenr;
+	if (parent) {
+		key.type = BTRFS_SHARED_BLOCK_REF_KEY;
+		key.offset = parent;
+	} else {
+		key.type = BTRFS_TREE_BLOCK_REF_KEY;
+		key.offset = root_objectid;
+	}
+
+	ret = btrfs_search_slot(&trans, root, &key, path, -1, 1);
+	if (ret) {
+		test_msg("Couldn't find backref %d\n", ret);
+		btrfs_free_path(path);
+		return ret;
+	}
+	btrfs_del_item(&trans, root, path);
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int test_no_shared_qgroup(struct btrfs_root *root)
+{
+	struct btrfs_trans_handle trans;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	int ret;
+
+	init_dummy_trans(&trans);
+
+	test_msg("Qgroup basic add\n");
+	ret = btrfs_create_qgroup(NULL, fs_info, 5, NULL);
+	if (ret) {
+		test_msg("Couldn't create a qgroup %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, 5, 4096, 4096, 0,
+				      BTRFS_QGROUP_OPER_ADD_EXCL);
+	if (ret) {
+		test_msg("Couldn't add space to a qgroup %d\n", ret);
+		return ret;
+	}
+
+	ret = insert_normal_tree_ref(root, 4096, 4096, 0, 5);
+	if (ret)
+		return ret;
+
+	ret = btrfs_delayed_qgroup_accounting(&trans, fs_info);
+	if (ret) {
+		test_msg("Delayed qgroup accounting failed %d\n", ret);
+		return ret;
+	}
+
+	if (btrfs_verify_qgroup_counts(fs_info, 5, 4096, 4096)) {
+		test_msg("Qgroup counts didn't match expected values\n");
+		return -EINVAL;
+	}
+
+	ret = remove_extent_item(root, 4096, 4096);
+	if (ret)
+		return -EINVAL;
+
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, 5, 4096, 4096, 0,
+				      BTRFS_QGROUP_OPER_SUB_EXCL);
+	if (ret) {
+		test_msg("Couldn't remove space from the qgroup %d\n", ret);
+		return -EINVAL;
+	}
+
+	ret = btrfs_delayed_qgroup_accounting(&trans, fs_info);
+	if (ret) {
+		test_msg("Qgroup accounting failed %d\n", ret);
+		return -EINVAL;
+	}
+
+	if (btrfs_verify_qgroup_counts(fs_info, 5, 0, 0)) {
+		test_msg("Qgroup counts didn't match expected values\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * Add a ref for two different roots to make sure the shared value comes out
+ * right, also remove one of the roots and make sure the exclusive count is
+ * adjusted properly.
+ */
+static int test_multiple_refs(struct btrfs_root *root)
+{
+	struct btrfs_trans_handle trans;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	int ret;
+
+	init_dummy_trans(&trans);
+
+	test_msg("Qgroup multiple refs test\n");
+
+	/* We have 5 created already from the previous test */
+	ret = btrfs_create_qgroup(NULL, fs_info, 256, NULL);
+	if (ret) {
+		test_msg("Couldn't create a qgroup %d\n", ret);
+		return ret;
+	}
+
+	ret = insert_normal_tree_ref(root, 4096, 4096, 0, 5);
+	if (ret)
+		return ret;
+
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, 5, 4096, 4096, 0,
+				      BTRFS_QGROUP_OPER_ADD_EXCL);
+	if (ret) {
+		test_msg("Couldn't add space to a qgroup %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_delayed_qgroup_accounting(&trans, fs_info);
+	if (ret) {
+		test_msg("Delayed qgroup accounting failed %d\n", ret);
+		return ret;
+	}
+
+	if (btrfs_verify_qgroup_counts(fs_info, 5, 4096, 4096)) {
+		test_msg("Qgroup counts didn't match expected values\n");
+		return -EINVAL;
+	}
+
+	ret = add_tree_ref(root, 4096, 4096, 0, 256);
+	if (ret)
+		return ret;
+
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, 256, 4096, 4096, 0,
+				      BTRFS_QGROUP_OPER_ADD_SHARED);
+	if (ret) {
+		test_msg("Qgroup record ref failed %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_delayed_qgroup_accounting(&trans, fs_info);
+	if (ret) {
+		test_msg("Qgroup accounting failed %d\n", ret);
+		return ret;
+	}
+
+	if (btrfs_verify_qgroup_counts(fs_info, 5, 4096, 0)) {
+		test_msg("Qgroup counts didn't match expected values\n");
+		return -EINVAL;
+	}
+
+	if (btrfs_verify_qgroup_counts(fs_info, 256, 4096, 0)) {
+		test_msg("Qgroup counts didn't match expected values\n");
+		return -EINVAL;
+	}
+
+	ret = remove_extent_ref(root, 4096, 4096, 0, 256);
+	if (ret)
+		return ret;
+
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, 256, 4096, 4096, 0,
+				      BTRFS_QGROUP_OPER_SUB_SHARED);
+	if (ret) {
+		test_msg("Qgroup record ref failed %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_delayed_qgroup_accounting(&trans, fs_info);
+	if (ret) {
+		test_msg("Qgroup accounting failed %d\n", ret);
+		return ret;
+	}
+
+	if (btrfs_verify_qgroup_counts(fs_info, 256, 0, 0)) {
+		test_msg("Qgroup counts didn't match expected values\n");
+		return -EINVAL;
+	}
+
+	if (btrfs_verify_qgroup_counts(fs_info, 5, 4096, 4096)) {
+		test_msg("Qgroup counts didn't match expected values\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int test_shared_refs(struct btrfs_root *root)
+{
+	struct btrfs_trans_handle trans;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	int ret;
+
+	init_dummy_trans(&trans);
+
+	ret = insert_normal_tree_ref(root, 8192, 4096, 0, 256);
+	if (ret)
+		return ret;
+
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, 256, 8192, 4096, 0,
+				      BTRFS_QGROUP_OPER_ADD_EXCL);
+	if (ret) {
+		test_msg("Qgroup record ref failed %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_delayed_qgroup_accounting(&trans, fs_info);
+	if (ret) {
+		test_msg("Qgroup delayed accounting failed %d\n", ret);
+		return ret;
+	}
+
+	if (btrfs_verify_qgroup_counts(fs_info, 256, 4096, 4096)) {
+		test_msg("Qgroup counts didn't match expected values\n");
+		return -EINVAL;
+	}
+
+	/* Add a shared ref to 4096 for the block we just added */
+	ret = add_tree_ref(root, 4096, 4096, 8192, 0);
+	if (ret)
+		return ret;
+
+	/*
+	 * This is kind of an impossible case with metadata, but I didn't feel
+	 * like adding a bunch of extra code to handle data refs so I'm just
+	 * pretending with metadata refs.
+	 */
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, 256, 4096, 4096, 0,
+				      BTRFS_QGROUP_OPER_ADD_SHARED);
+	if (ret) {
+		test_msg("Qgroup record ref failed %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_delayed_qgroup_accounting(&trans, fs_info);
+	if (ret) {
+		test_msg("Qgroup delayed accounting failed %d\n", ret);
+		return ret;
+	}
+
+	if (btrfs_verify_qgroup_counts(fs_info, 256, 8192, 4096)) {
+		test_msg("Qgroup counts didn't match expected values\n");
+		return -EINVAL;
+	}
+
+	if (btrfs_verify_qgroup_counts(fs_info, 5, 4096, 0)) {
+		test_msg("Qgroup counts didn't match expected values\n");
+		return -EINVAL;
+	}
+
+	/* Add a full ref to make sure that we don't up the count */
+	ret = add_tree_ref(root, 4096, 4096, 0, 256);
+	if (ret)
+		return ret;
+
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, 256, 4096, 4096, 0,
+				      BTRFS_QGROUP_OPER_ADD_SHARED);
+	if (ret) {
+		test_msg("Qgroup record ref failed %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_qgroup_add_shared_ref(&trans, 256, 8192);
+	if (ret) {
+		test_msg("Qgroup add shared ref failed %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_delayed_qgroup_accounting(&trans, fs_info);
+	if (ret) {
+		test_msg("Qgroup delayed accounting failed %d\n", ret);
+		return ret;
+	}
+
+	if (btrfs_verify_qgroup_counts(fs_info, 256, 8192, 4096)) {
+		test_msg("Qgroup counts didn't match expected values\n");
+		return ret;
+	}
+
+	if (btrfs_verify_qgroup_counts(fs_info, 5, 4096, 0)) {
+		test_msg("Qgroup counts didn't match the expected values\n");
+		return ret;
+	}
+
+	/*
+	 * Ok now remove both refs and do the shared removal dance and make sure
+	 * that works out right.
+	 */
+	ret = remove_extent_ref(root, 4096, 4096, 8192, 0);
+	if (ret)
+		return ret;
+
+	ret = remove_extent_ref(root, 4096, 4096, 0, 256);
+	if (ret)
+		return ret;
+
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, 256, 4096, 4096, 0,
+				      BTRFS_QGROUP_OPER_SUB_SHARED);
+	if (ret) {
+		test_msg("Qgroup record ref failed %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_qgroup_add_shared_ref(&trans, 256, 8192);
+	if (ret) {
+		test_msg("Qgroup add shared ref failed %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, 256, 4096, 4096, 8192,
+				      BTRFS_QGROUP_OPER_SUB_SHARED);
+	if (ret) {
+		test_msg("Qgroup record ref failed %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_delayed_qgroup_accounting(&trans, fs_info);
+	if (ret) {
+		test_msg("Qgroup delayed accounting failed %d\n", ret);
+		return ret;
+	}
+
+	if (btrfs_verify_qgroup_counts(fs_info, 256, 4096, 4096)) {
+		test_msg("Qgroup counts didn't match expected values\n");
+		return -EINVAL;
+	}
+
+	if (btrfs_verify_qgroup_counts(fs_info, 5, 4096, 4096)) {
+		test_msg("Qgroup counts didn't match expected values\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int btrfs_test_qgroups(void)
+{
+	struct btrfs_root *root;
+	struct btrfs_root *tmp_root;
+	int ret = 0;
+
+	root = btrfs_alloc_dummy_root();
+	if (IS_ERR(root)) {
+		test_msg("Couldn't allocate root\n");
+		return PTR_ERR(root);
+	}
+
+	root->fs_info = btrfs_alloc_dummy_fs_info();
+	if (!root->fs_info) {
+		test_msg("Couldn't allocate dummy fs info\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/*
+	 * Can't use bytenr 0, some things freak out
+	 * *cough*backref walking code*cough*
+	 */
+	root->node = alloc_test_extent_buffer(root->fs_info, 4096, 4096);
+	if (!root->node) {
+		test_msg("Couldn't allocate dummy buffer\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+	root->alloc_bytenr += 8192;
+
+	tmp_root = btrfs_alloc_dummy_root();
+	if (IS_ERR(tmp_root)) {
+		test_msg("Couldn't allocate a fs root\n");
+		ret = PTR_ERR(tmp_root);
+		goto out;
+	}
+
+	tmp_root->root_key.objectid = 5;
+	root->fs_info->fs_root = tmp_root;
+	ret = btrfs_insert_fs_root(root->fs_info, tmp_root);
+	if (ret) {
+		test_msg("Couldn't insert fs root %d\n", ret);
+		goto out;
+	}
+
+	tmp_root = btrfs_alloc_dummy_root();
+	if (IS_ERR(tmp_root)) {
+		test_msg("Couldn't allocate a fs root\n");
+		ret = PTR_ERR(tmp_root);
+		goto out;
+	}
+
+	tmp_root->root_key.objectid = 256;
+	ret = btrfs_insert_fs_root(root->fs_info, tmp_root);
+	if (ret) {
+		test_msg("Couldn't insert fs root %d\n", ret);
+		goto out;
+	}
+
+	/* We are using this root as our extent root */
+	root->fs_info->extent_root = root;
+
+	/*
+	 * Some of the paths we test assume we have a filled out fs_info, so we
+	 * just need to addt he root in there so we don't panic.
+	 */
+	root->fs_info->tree_root = root;
+	root->fs_info->quota_root = root;
+	root->fs_info->quota_enabled = 1;
+
+	test_msg("Running qgroup tests\n");
+	ret = test_no_shared_qgroup(root);
+	if (ret)
+		goto out;
+	ret = test_multiple_refs(root);
+	if (ret)
+		goto out;
+	ret = test_shared_refs(root);
+out:
+	btrfs_free_dummy_root(root);
+	return ret;
+}
-- 
1.8.3.1

