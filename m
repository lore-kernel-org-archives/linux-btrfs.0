Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:50755 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbcFAPwy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2016 11:52:54 -0400
Received: from localhost
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 09:52:52 -0600
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, chandan@linux.vnet.ibm.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH V2 3/8] Btrfs: self-tests: Support non-4k page size
Date: Wed,  1 Jun 2016 15:51:42 +0000
Message-Id: <1464796307-67173-4-git-send-email-xufeifei@linux.vnet.ibm.com>
In-Reply-To: <1464796307-67173-1-git-send-email-xufeifei@linux.vnet.ibm.com>
References: <1464796307-67173-1-git-send-email-xufeifei@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

self-tests code assumes 4k as the sectorsize and nodesize. This commit
fix hardcoded 4K. Enables the self-tests code to be executed on non-4k
page sized systems (e.g. ppc64).

Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.c                       |   6 +-
 fs/btrfs/disk-io.c                     |   8 +-
 fs/btrfs/disk-io.h                     |   2 +-
 fs/btrfs/extent_io.c                   |  10 +-
 fs/btrfs/extent_io.h                   |   4 +-
 fs/btrfs/free-space-cache.c            |   2 +-
 fs/btrfs/super.c                       |  16 +-
 fs/btrfs/tests/btrfs-tests.c           |   6 +-
 fs/btrfs/tests/btrfs-tests.h           |  27 +--
 fs/btrfs/tests/extent-buffer-tests.c   |  11 +-
 fs/btrfs/tests/extent-io-tests.c       |  27 +--
 fs/btrfs/tests/free-space-tests.c      |  68 ++++---
 fs/btrfs/tests/free-space-tree-tests.c |  30 +--
 fs/btrfs/tests/inode-tests.c           | 344 ++++++++++++++++++---------------
 fs/btrfs/tests/qgroup-tests.c          |  85 ++++----
 15 files changed, 355 insertions(+), 291 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 427c36b..4602568 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1373,7 +1373,8 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 
 	if (tm->op == MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
 		BUG_ON(tm->slot != 0);
-		eb_rewin = alloc_dummy_extent_buffer(fs_info, eb->start);
+		eb_rewin = alloc_dummy_extent_buffer(fs_info, eb->start,
+						eb->len);
 		if (!eb_rewin) {
 			btrfs_tree_read_unlock_blocking(eb);
 			free_extent_buffer(eb);
@@ -1454,7 +1455,8 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 	} else if (old_root) {
 		btrfs_tree_read_unlock(eb_root);
 		free_extent_buffer(eb_root);
-		eb = alloc_dummy_extent_buffer(root->fs_info, logical);
+		eb = alloc_dummy_extent_buffer(root->fs_info, logical,
+					root->nodesize);
 	} else {
 		btrfs_set_lock_blocking_rw(eb_root, BTRFS_READ_LOCK);
 		eb = btrfs_clone_extent_buffer(eb_root);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6628fca..06ef433 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1147,7 +1147,8 @@ struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 						 u64 bytenr)
 {
 	if (btrfs_test_is_dummy_root(root))
-		return alloc_test_extent_buffer(root->fs_info, bytenr);
+		return alloc_test_extent_buffer(root->fs_info, bytenr,
+				root->nodesize);
 	return alloc_extent_buffer(root->fs_info, bytenr);
 }
 
@@ -1314,14 +1315,15 @@ static struct btrfs_root *btrfs_alloc_root(struct btrfs_fs_info *fs_info,
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 /* Should only be used by the testing infrastructure */
-struct btrfs_root *btrfs_alloc_dummy_root(void)
+struct btrfs_root *btrfs_alloc_dummy_root(u32 sectorsize, u32 nodesize)
 {
 	struct btrfs_root *root;
 
 	root = btrfs_alloc_root(NULL, GFP_KERNEL);
 	if (!root)
 		return ERR_PTR(-ENOMEM);
-	__setup_root(4096, 4096, 4096, root, NULL, 1);
+	/* We don't use the stripesize in selftest, set it as sectorsize */
+	__setup_root(nodesize, sectorsize, sectorsize, root, NULL, 1);
 	set_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state);
 	root->alloc_bytenr = 0;
 
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 8e79d00..acba821 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -90,7 +90,7 @@ void btrfs_drop_and_free_fs_root(struct btrfs_fs_info *fs_info,
 void btrfs_free_fs_root(struct btrfs_root *root);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-struct btrfs_root *btrfs_alloc_dummy_root(void);
+struct btrfs_root *btrfs_alloc_dummy_root(u32 sectorsize, u32 nodesize);
 #endif
 
 /*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3cd5782..b0a554d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4718,16 +4718,16 @@ err:
 }
 
 struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
-						u64 start)
+						u64 start, u32 nodesize)
 {
 	unsigned long len;
 
 	if (!fs_info) {
 		/*
 		 * Called only from tests that don't always have a fs_info
-		 * available, but we know that nodesize is 4096
+		 * available
 		 */
-		len = 4096;
+		len = nodesize;
 	} else {
 		len = fs_info->tree_root->nodesize;
 	}
@@ -4823,7 +4823,7 @@ struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
-					       u64 start)
+					u64 start, u32 nodesize)
 {
 	struct extent_buffer *eb, *exists = NULL;
 	int ret;
@@ -4831,7 +4831,7 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 	eb = find_extent_buffer(fs_info, start);
 	if (eb)
 		return eb;
-	eb = alloc_dummy_extent_buffer(fs_info, start);
+	eb = alloc_dummy_extent_buffer(fs_info, start, nodesize);
 	if (!eb)
 		return NULL;
 	eb->fs_info = fs_info;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 1baf19c..c0c1c4f 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -348,7 +348,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 						  u64 start, unsigned long len);
 struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
-						u64 start);
+						u64 start, u32 nodesize);
 struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src);
 struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
 					 u64 start);
@@ -468,5 +468,5 @@ noinline u64 find_lock_delalloc_range(struct inode *inode,
 				      u64 *end, u64 max_bytes);
 #endif
 struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
-					       u64 start);
+					       u64 start, u32 nodesize);
 #endif
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 2813ef0..69d270f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1660,7 +1660,7 @@ static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
 	 * sure we don't go over our overall goal of MAX_CACHE_BYTES_PER_GIG as
 	 * we add more bitmaps.
 	 */
-	bitmap_bytes = (ctl->total_bitmaps + 1) * PAGE_SIZE;
+	bitmap_bytes = (ctl->total_bitmaps + 1) * ctl->unit;
 
 	if (bitmap_bytes >= max_bytes) {
 		ctl->extents_thresh = 0;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4e59a91..5b0b354 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2319,27 +2319,31 @@ static void btrfs_print_mod_info(void)
 static int btrfs_run_sanity_tests(void)
 {
 	int ret;
+	u32 sectorsize, nodesize;
 
+	sectorsize = PAGE_SIZE;
+	nodesize = PAGE_SIZE;
 	ret = btrfs_init_test_fs();
 	if (ret)
 		return ret;
 
-	ret = btrfs_test_free_space_cache();
+	ret = btrfs_test_free_space_cache(sectorsize, nodesize);
 	if (ret)
 		goto out;
-	ret = btrfs_test_extent_buffer_operations();
+	ret = btrfs_test_extent_buffer_operations(sectorsize,
+		nodesize);
 	if (ret)
 		goto out;
-	ret = btrfs_test_extent_io();
+	ret = btrfs_test_extent_io(sectorsize, nodesize);
 	if (ret)
 		goto out;
-	ret = btrfs_test_inodes();
+	ret = btrfs_test_inodes(sectorsize, nodesize);
 	if (ret)
 		goto out;
-	ret = btrfs_test_qgroups();
+	ret = btrfs_test_qgroups(sectorsize, nodesize);
 	if (ret)
 		goto out;
-	ret = btrfs_test_free_space_tree();
+	ret = btrfs_test_free_space_tree(sectorsize, nodesize);
 out:
 	btrfs_destroy_test_fs();
 	return ret;
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index f54bf45..10eb249 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -175,7 +175,7 @@ void btrfs_free_dummy_root(struct btrfs_root *root)
 }
 
 struct btrfs_block_group_cache *
-btrfs_alloc_dummy_block_group(unsigned long length)
+btrfs_alloc_dummy_block_group(unsigned long length, u32 sectorsize)
 {
 	struct btrfs_block_group_cache *cache;
 
@@ -192,8 +192,8 @@ btrfs_alloc_dummy_block_group(unsigned long length)
 	cache->key.objectid = 0;
 	cache->key.offset = length;
 	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
-	cache->sectorsize = 4096;
-	cache->full_stripe_len = 4096;
+	cache->sectorsize = sectorsize;
+	cache->full_stripe_len = sectorsize;
 
 	INIT_LIST_HEAD(&cache->list);
 	INIT_LIST_HEAD(&cache->cluster_list);
diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
index 054b8c7..66fb6b70 100644
--- a/fs/btrfs/tests/btrfs-tests.h
+++ b/fs/btrfs/tests/btrfs-tests.h
@@ -26,27 +26,28 @@
 struct btrfs_root;
 struct btrfs_trans_handle;
 
-int btrfs_test_free_space_cache(void);
-int btrfs_test_extent_buffer_operations(void);
-int btrfs_test_extent_io(void);
-int btrfs_test_inodes(void);
-int btrfs_test_qgroups(void);
-int btrfs_test_free_space_tree(void);
+int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize);
+int btrfs_test_extent_buffer_operations(u32 sectorsize, u32 nodesize);
+int btrfs_test_extent_io(u32 sectorsize, u32 nodesize);
+int btrfs_test_inodes(u32 sectorsize, u32 nodesize);
+int btrfs_test_qgroups(u32 sectorsize, u32 nodesize);
+int btrfs_test_free_space_tree(u32 sectorsize, u32 nodesize);
 int btrfs_init_test_fs(void);
 void btrfs_destroy_test_fs(void);
 struct inode *btrfs_new_test_inode(void);
 struct btrfs_fs_info *btrfs_alloc_dummy_fs_info(void);
 void btrfs_free_dummy_root(struct btrfs_root *root);
 struct btrfs_block_group_cache *
-btrfs_alloc_dummy_block_group(unsigned long length);
+btrfs_alloc_dummy_block_group(unsigned long length, u32 sectorsize);
 void btrfs_free_dummy_block_group(struct btrfs_block_group_cache *cache);
 void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans);
 #else
-static inline int btrfs_test_free_space_cache(void)
+static inline int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize)
 {
 	return 0;
 }
-static inline int btrfs_test_extent_buffer_operations(void)
+static inline int btrfs_test_extent_buffer_operations(u32 sectorsize,
+	u32 nodesize)
 {
 	return 0;
 }
@@ -57,19 +58,19 @@ static inline int btrfs_init_test_fs(void)
 static inline void btrfs_destroy_test_fs(void)
 {
 }
-static inline int btrfs_test_extent_io(void)
+static inline int btrfs_test_extent_io(u32 sectorsize, u32 nodesize)
 {
 	return 0;
 }
-static inline int btrfs_test_inodes(void)
+static inline int btrfs_test_inodes(u32 sectorsize, u32 nodesize)
 {
 	return 0;
 }
-static inline int btrfs_test_qgroups(void)
+static inline int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 {
 	return 0;
 }
-static inline int btrfs_test_free_space_tree(void)
+static inline int btrfs_test_free_space_tree(u32 sectorsize, u32 nodesize)
 {
 	return 0;
 }
diff --git a/fs/btrfs/tests/extent-buffer-tests.c b/fs/btrfs/tests/extent-buffer-tests.c
index f51963a..17b110f 100644
--- a/fs/btrfs/tests/extent-buffer-tests.c
+++ b/fs/btrfs/tests/extent-buffer-tests.c
@@ -22,7 +22,7 @@
 #include "../extent_io.h"
 #include "../disk-io.h"
 
-static int test_btrfs_split_item(void)
+static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 {
 	struct btrfs_path *path;
 	struct btrfs_root *root;
@@ -40,7 +40,7 @@ static int test_btrfs_split_item(void)
 
 	test_msg("Running btrfs_split_item tests\n");
 
-	root = btrfs_alloc_dummy_root();
+	root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(root)) {
 		test_msg("Could not allocate root\n");
 		return PTR_ERR(root);
@@ -53,7 +53,8 @@ static int test_btrfs_split_item(void)
 		return -ENOMEM;
 	}
 
-	path->nodes[0] = eb = alloc_dummy_extent_buffer(NULL, 4096);
+	path->nodes[0] = eb = alloc_dummy_extent_buffer(NULL, nodesize,
+							nodesize);
 	if (!eb) {
 		test_msg("Could not allocate dummy buffer\n");
 		ret = -ENOMEM;
@@ -222,8 +223,8 @@ out:
 	return ret;
 }
 
-int btrfs_test_extent_buffer_operations(void)
+int btrfs_test_extent_buffer_operations(u32 sectorsize, u32 nodesize)
 {
 	test_msg("Running extent buffer operation tests");
-	return test_btrfs_split_item();
+	return test_btrfs_split_item(sectorsize, nodesize);
 }
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 5572460..755fceb 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -65,7 +65,7 @@ static noinline int process_page_range(struct inode *inode, u64 start, u64 end,
 	return count;
 }
 
-static int test_find_delalloc(void)
+static int test_find_delalloc(u32 sectorsize)
 {
 	struct inode *inode;
 	struct extent_io_tree tmp;
@@ -113,7 +113,7 @@ static int test_find_delalloc(void)
 	 * |--- delalloc ---|
 	 * |---  search  ---|
 	 */
-	set_extent_delalloc(&tmp, 0, 4095, NULL);
+	set_extent_delalloc(&tmp, 0, sectorsize - 1, NULL);
 	start = 0;
 	end = 0;
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
@@ -122,9 +122,9 @@ static int test_find_delalloc(void)
 		test_msg("Should have found at least one delalloc\n");
 		goto out_bits;
 	}
-	if (start != 0 || end != 4095) {
-		test_msg("Expected start 0 end 4095, got start %Lu end %Lu\n",
-			 start, end);
+	if (start != 0 || end != (sectorsize - 1)) {
+		test_msg("Expected start 0 end %u, got start %llu end %llu\n",
+			sectorsize - 1, start, end);
 		goto out_bits;
 	}
 	unlock_extent(&tmp, start, end);
@@ -144,7 +144,7 @@ static int test_find_delalloc(void)
 		test_msg("Couldn't find the locked page\n");
 		goto out_bits;
 	}
-	set_extent_delalloc(&tmp, 4096, max_bytes - 1, NULL);
+	set_extent_delalloc(&tmp, sectorsize, max_bytes - 1, NULL);
 	start = test_start;
 	end = 0;
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
@@ -172,7 +172,7 @@ static int test_find_delalloc(void)
 	 * |--- delalloc ---|
 	 *                    |--- search ---|
 	 */
-	test_start = max_bytes + 4096;
+	test_start = max_bytes + sectorsize;
 	locked_page = find_lock_page(inode->i_mapping, test_start >>
 				     PAGE_SHIFT);
 	if (!locked_page) {
@@ -351,14 +351,15 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 	return 0;
 }
 
-static int test_eb_bitmaps(void)
+static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 {
-	unsigned long len = PAGE_SIZE * 4;
+	unsigned long len;
 	unsigned long *bitmap;
 	struct extent_buffer *eb;
 	int ret;
 
 	test_msg("Running extent buffer bitmap tests\n");
+	len = sectorsize * 4;
 
 	bitmap = kmalloc(len, GFP_KERNEL);
 	if (!bitmap) {
@@ -379,7 +380,7 @@ static int test_eb_bitmaps(void)
 
 	/* Do it over again with an extent buffer which isn't page-aligned. */
 	free_extent_buffer(eb);
-	eb = __alloc_dummy_extent_buffer(NULL, PAGE_SIZE / 2, len);
+	eb = __alloc_dummy_extent_buffer(NULL, nodesize / 2, len);
 	if (!eb) {
 		test_msg("Couldn't allocate test extent buffer\n");
 		kfree(bitmap);
@@ -393,17 +394,17 @@ out:
 	return ret;
 }
 
-int btrfs_test_extent_io(void)
+int btrfs_test_extent_io(u32 sectorsize, u32 nodesize)
 {
 	int ret;
 
 	test_msg("Running extent I/O tests\n");
 
-	ret = test_find_delalloc();
+	ret = test_find_delalloc(sectorsize);
 	if (ret)
 		goto out;
 
-	ret = test_eb_bitmaps();
+	ret = test_eb_bitmaps(sectorsize, nodesize);
 out:
 	test_msg("Extent I/O tests finished\n");
 	return ret;
diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index f3756d6..029343b 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -99,7 +99,8 @@ static int test_extents(struct btrfs_block_group_cache *cache)
 	return 0;
 }
 
-static int test_bitmaps(struct btrfs_block_group_cache *cache)
+static int test_bitmaps(struct btrfs_block_group_cache *cache,
+			u32 sectorsize)
 {
 	u64 next_bitmap_offset;
 	int ret;
@@ -139,7 +140,7 @@ static int test_bitmaps(struct btrfs_block_group_cache *cache)
 	 * The first bitmap we have starts at offset 0 so the next one is just
 	 * at the end of the first bitmap.
 	 */
-	next_bitmap_offset = (u64)(BITS_PER_BITMAP * 4096);
+	next_bitmap_offset = (u64)(BITS_PER_BITMAP * sectorsize);
 
 	/* Test a bit straddling two bitmaps */
 	ret = test_add_free_space_entry(cache, next_bitmap_offset - SZ_2M,
@@ -167,9 +168,10 @@ static int test_bitmaps(struct btrfs_block_group_cache *cache)
 }
 
 /* This is the high grade jackassery */
-static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache)
+static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache,
+				    u32 sectorsize)
 {
-	u64 bitmap_offset = (u64)(BITS_PER_BITMAP * 4096);
+	u64 bitmap_offset = (u64)(BITS_PER_BITMAP * sectorsize);
 	int ret;
 
 	test_msg("Running bitmap and extent tests\n");
@@ -401,7 +403,8 @@ static int check_cache_empty(struct btrfs_block_group_cache *cache)
  * requests.
  */
 static int
-test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
+test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
+				       u32 sectorsize)
 {
 	int ret;
 	u64 offset;
@@ -539,7 +542,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 	 * The goal is to test that the bitmap entry space stealing doesn't
 	 * steal this space region.
 	 */
-	ret = btrfs_add_free_space(cache, SZ_128M + SZ_16M, 4096);
+	ret = btrfs_add_free_space(cache, SZ_128M + SZ_16M, sectorsize);
 	if (ret) {
 		test_msg("Error adding free space: %d\n", ret);
 		return ret;
@@ -597,8 +600,8 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 		return -ENOENT;
 	}
 
-	if (cache->free_space_ctl->free_space != (SZ_1M + 4096)) {
-		test_msg("Cache free space is not 1Mb + 4Kb\n");
+	if (cache->free_space_ctl->free_space != (SZ_1M + sectorsize)) {
+		test_msg("Cache free space is not 1Mb + %u\n", sectorsize);
 		return -EINVAL;
 	}
 
@@ -611,22 +614,25 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 		return -EINVAL;
 	}
 
-	/* All that remains is a 4Kb free space region in a bitmap. Confirm. */
+	/*
+	 * All that remains is a sectorsize free space region in a bitmap.
+	 * Confirm.
+	 */
 	ret = check_num_extents_and_bitmaps(cache, 1, 1);
 	if (ret)
 		return ret;
 
-	if (cache->free_space_ctl->free_space != 4096) {
-		test_msg("Cache free space is not 4Kb\n");
+	if (cache->free_space_ctl->free_space != sectorsize) {
+		test_msg("Cache free space is not %u\n", sectorsize);
 		return -EINVAL;
 	}
 
 	offset = btrfs_find_space_for_alloc(cache,
-					    0, 4096, 0,
+					    0, sectorsize, 0,
 					    &max_extent_size);
 	if (offset != (SZ_128M + SZ_16M)) {
-		test_msg("Failed to allocate 4Kb from space cache, returned offset is: %llu\n",
-			 offset);
+		test_msg("Failed to allocate %u, returned offset : %llu\n",
+			 sectorsize, offset);
 		return -EINVAL;
 	}
 
@@ -733,7 +739,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 	 * The goal is to test that the bitmap entry space stealing doesn't
 	 * steal this space region.
 	 */
-	ret = btrfs_add_free_space(cache, SZ_32M, 8192);
+	ret = btrfs_add_free_space(cache, SZ_32M, 2 * sectorsize);
 	if (ret) {
 		test_msg("Error adding free space: %d\n", ret);
 		return ret;
@@ -757,7 +763,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 
 	/*
 	 * Confirm that our extent entry didn't stole all free space from the
-	 * bitmap, because of the small 8Kb free space region.
+	 * bitmap, because of the small 2 * sectorsize free space region.
 	 */
 	ret = check_num_extents_and_bitmaps(cache, 2, 1);
 	if (ret)
@@ -783,8 +789,8 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 		return -ENOENT;
 	}
 
-	if (cache->free_space_ctl->free_space != (SZ_1M + 8192)) {
-		test_msg("Cache free space is not 1Mb + 8Kb\n");
+	if (cache->free_space_ctl->free_space != (SZ_1M + 2 * sectorsize)) {
+		test_msg("Cache free space is not 1Mb + %u\n", 2 * sectorsize);
 		return -EINVAL;
 	}
 
@@ -796,21 +802,25 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 		return -EINVAL;
 	}
 
-	/* All that remains is a 8Kb free space region in a bitmap. Confirm. */
+	/*
+	 * All that remains is 2 * sectorsize free space region
+	 * in a bitmap. Confirm.
+	 */
 	ret = check_num_extents_and_bitmaps(cache, 1, 1);
 	if (ret)
 		return ret;
 
-	if (cache->free_space_ctl->free_space != 8192) {
-		test_msg("Cache free space is not 8Kb\n");
+	if (cache->free_space_ctl->free_space != 2 * sectorsize) {
+		test_msg("Cache free space is not %u\n", 2 * sectorsize);
 		return -EINVAL;
 	}
 
 	offset = btrfs_find_space_for_alloc(cache,
-					    0, 8192, 0,
+					    0, 2 * sectorsize, 0,
 					    &max_extent_size);
 	if (offset != SZ_32M) {
-		test_msg("Failed to allocate 8Kb from space cache, returned offset is: %llu\n",
+		test_msg("Failed to allocate %u, offset: %llu\n",
+			 2 * sectorsize,
 			 offset);
 		return -EINVAL;
 	}
@@ -825,7 +835,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 	return 0;
 }
 
-int btrfs_test_free_space_cache(void)
+int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize)
 {
 	struct btrfs_block_group_cache *cache;
 	struct btrfs_root *root = NULL;
@@ -833,13 +843,13 @@ int btrfs_test_free_space_cache(void)
 
 	test_msg("Running btrfs free space cache tests\n");
 
-	cache = btrfs_alloc_dummy_block_group(1024 * 1024 * 1024);
+	cache = btrfs_alloc_dummy_block_group(1024 * 1024 * 1024, sectorsize);
 	if (!cache) {
 		test_msg("Couldn't run the tests\n");
 		return 0;
 	}
 
-	root = btrfs_alloc_dummy_root();
+	root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(root)) {
 		ret = PTR_ERR(root);
 		goto out;
@@ -855,14 +865,14 @@ int btrfs_test_free_space_cache(void)
 	ret = test_extents(cache);
 	if (ret)
 		goto out;
-	ret = test_bitmaps(cache);
+	ret = test_bitmaps(cache, sectorsize);
 	if (ret)
 		goto out;
-	ret = test_bitmaps_and_extents(cache);
+	ret = test_bitmaps_and_extents(cache, sectorsize);
 	if (ret)
 		goto out;
 
-	ret = test_steal_space_from_bitmap_to_extent(cache);
+	ret = test_steal_space_from_bitmap_to_extent(cache, sectorsize);
 out:
 	btrfs_free_dummy_block_group(cache);
 	btrfs_free_dummy_root(root);
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 7cea446..aac5070 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -16,6 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <linux/types.h>
 #include "btrfs-tests.h"
 #include "../ctree.h"
 #include "../disk-io.h"
@@ -30,7 +31,7 @@ struct free_space_extent {
  * The test cases align their operations to this in order to hit some of the
  * edge cases in the bitmap code.
  */
-#define BITMAP_RANGE (BTRFS_FREE_SPACE_BITMAP_BITS * 4096)
+#define BITMAP_RANGE (BTRFS_FREE_SPACE_BITMAP_BITS * PAGE_SIZE)
 
 static int __check_free_space_extents(struct btrfs_trans_handle *trans,
 				      struct btrfs_fs_info *fs_info,
@@ -439,7 +440,8 @@ typedef int (*test_func_t)(struct btrfs_trans_handle *,
 			   struct btrfs_block_group_cache *,
 			   struct btrfs_path *);
 
-static int run_test(test_func_t test_func, int bitmaps)
+static int run_test(test_func_t test_func, int bitmaps,
+		u32 sectorsize, u32 nodesize)
 {
 	struct btrfs_root *root = NULL;
 	struct btrfs_block_group_cache *cache = NULL;
@@ -447,7 +449,7 @@ static int run_test(test_func_t test_func, int bitmaps)
 	struct btrfs_path *path = NULL;
 	int ret;
 
-	root = btrfs_alloc_dummy_root();
+	root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(root)) {
 		test_msg("Couldn't allocate dummy root\n");
 		ret = PTR_ERR(root);
@@ -466,7 +468,8 @@ static int run_test(test_func_t test_func, int bitmaps)
 	root->fs_info->free_space_root = root;
 	root->fs_info->tree_root = root;
 
-	root->node = alloc_test_extent_buffer(root->fs_info, 4096);
+	root->node = alloc_test_extent_buffer(root->fs_info,
+		nodesize, nodesize);
 	if (!root->node) {
 		test_msg("Couldn't allocate dummy buffer\n");
 		ret = -ENOMEM;
@@ -474,9 +477,9 @@ static int run_test(test_func_t test_func, int bitmaps)
 	}
 	btrfs_set_header_level(root->node, 0);
 	btrfs_set_header_nritems(root->node, 0);
-	root->alloc_bytenr += 8192;
+	root->alloc_bytenr += 2 * nodesize;
 
-	cache = btrfs_alloc_dummy_block_group(8 * BITMAP_RANGE);
+	cache = btrfs_alloc_dummy_block_group(8 * BITMAP_RANGE, sectorsize);
 	if (!cache) {
 		test_msg("Couldn't allocate dummy block group cache\n");
 		ret = -ENOMEM;
@@ -534,17 +537,18 @@ out:
 	return ret;
 }
 
-static int run_test_both_formats(test_func_t test_func)
+static int run_test_both_formats(test_func_t test_func,
+	u32 sectorsize, u32 nodesize)
 {
 	int ret;
 
-	ret = run_test(test_func, 0);
+	ret = run_test(test_func, 0, sectorsize, nodesize);
 	if (ret)
 		return ret;
-	return run_test(test_func, 1);
+	return run_test(test_func, 1, sectorsize, nodesize);
 }
 
-int btrfs_test_free_space_tree(void)
+int btrfs_test_free_space_tree(u32 sectorsize, u32 nodesize)
 {
 	test_func_t tests[] = {
 		test_empty_block_group,
@@ -561,9 +565,11 @@ int btrfs_test_free_space_tree(void)
 
 	test_msg("Running free space tree tests\n");
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
-		int ret = run_test_both_formats(tests[i]);
+		int ret = run_test_both_formats(tests[i], sectorsize,
+			nodesize);
 		if (ret) {
-			test_msg("%pf failed\n", tests[i]);
+			test_msg("%pf : sectorsize %u failed\n",
+				tests[i], sectorsize);
 			return ret;
 		}
 	}
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 8a25fe8..29648c0 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -16,6 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <linux/types.h>
 #include "btrfs-tests.h"
 #include "../ctree.h"
 #include "../btrfs_inode.h"
@@ -86,19 +87,19 @@ static void insert_inode_item_key(struct btrfs_root *root)
  * diagram of how the extents will look though this may not be possible we still
  * want to make sure everything acts normally (the last number is not inclusive)
  *
- * [0 - 5][5 -  6][6 - 10][10 - 4096][  4096 - 8192 ][8192 - 12288]
- * [hole ][inline][ hole ][ regular ][regular1 split][    hole    ]
+ * [0 - 5][5 -  6][     6 - 4096     ][ 4096 - 4100][4100 - 8195][8195 - 12291]
+ * [hole ][inline][hole but no extent][  hole   ][   regular ][regular1 split]
  *
- * [ 12288 - 20480][20480 - 24576][  24576 - 28672  ][28672 - 36864][36864 - 45056]
- * [regular1 split][   prealloc1 ][prealloc1 written][   prealloc1 ][ compressed  ]
+ * [12291 - 16387][16387 - 24579][24579 - 28675][ 28675 - 32771][32771 - 36867 ]
+ * [    hole    ][regular1 split][   prealloc ][   prealloc1  ][prealloc1 written]
  *
- * [45056 - 49152][49152-53248][53248-61440][61440-65536][     65536+81920   ]
- * [ compressed1 ][  regular  ][compressed1][  regular  ][ hole but no extent]
+ * [36867 - 45059][45059 - 53251][53251 - 57347][57347 - 61443][61443- 69635]
+ * [  prealloc1  ][ compressed  ][ compressed1 ][    regular  ][ compressed1]
  *
- * [81920-86016]
- * [  regular  ]
+ * [69635-73731][   73731 - 86019   ][86019-90115]
+ * [  regular  ][ hole but no extent][  regular  ]
  */
-static void setup_file_extents(struct btrfs_root *root)
+static void setup_file_extents(struct btrfs_root *root, u32 sectorsize)
 {
 	int slot = 0;
 	u64 disk_bytenr = SZ_1M;
@@ -119,7 +120,7 @@ static void setup_file_extents(struct btrfs_root *root)
 	insert_extent(root, offset, 1, 1, 0, 0, 0, BTRFS_FILE_EXTENT_INLINE, 0,
 		      slot);
 	slot++;
-	offset = 4096;
+	offset = sectorsize;
 
 	/* Now another hole */
 	insert_extent(root, offset, 4, 4, 0, 0, 0, BTRFS_FILE_EXTENT_REG, 0,
@@ -128,99 +129,106 @@ static void setup_file_extents(struct btrfs_root *root)
 	offset += 4;
 
 	/* Now for a regular extent */
-	insert_extent(root, offset, 4095, 4095, 0, disk_bytenr, 4096,
-		      BTRFS_FILE_EXTENT_REG, 0, slot);
+	insert_extent(root, offset, sectorsize - 1, sectorsize - 1, 0,
+		      disk_bytenr, sectorsize, BTRFS_FILE_EXTENT_REG, 0, slot);
 	slot++;
-	disk_bytenr += 4096;
-	offset += 4095;
+	disk_bytenr += sectorsize;
+	offset += sectorsize - 1;
 
 	/*
 	 * Now for 3 extents that were split from a hole punch so we test
 	 * offsets properly.
 	 */
-	insert_extent(root, offset, 4096, 16384, 0, disk_bytenr, 16384,
-		      BTRFS_FILE_EXTENT_REG, 0, slot);
+	insert_extent(root, offset, sectorsize, 4 * sectorsize, 0, disk_bytenr,
+		      4 * sectorsize, BTRFS_FILE_EXTENT_REG, 0, slot);
 	slot++;
-	offset += 4096;
-	insert_extent(root, offset, 4096, 4096, 0, 0, 0, BTRFS_FILE_EXTENT_REG,
-		      0, slot);
+	offset += sectorsize;
+	insert_extent(root, offset, sectorsize, sectorsize, 0, 0, 0,
+		      BTRFS_FILE_EXTENT_REG, 0, slot);
 	slot++;
-	offset += 4096;
-	insert_extent(root, offset, 8192, 16384, 8192, disk_bytenr, 16384,
+	offset += sectorsize;
+	insert_extent(root, offset, 2 * sectorsize, 4 * sectorsize,
+		      2 * sectorsize, disk_bytenr, 4 * sectorsize,
 		      BTRFS_FILE_EXTENT_REG, 0, slot);
 	slot++;
-	offset += 8192;
-	disk_bytenr += 16384;
+	offset += 2 * sectorsize;
+	disk_bytenr += 4 * sectorsize;
 
 	/* Now for a unwritten prealloc extent */
-	insert_extent(root, offset, 4096, 4096, 0, disk_bytenr, 4096,
-		      BTRFS_FILE_EXTENT_PREALLOC, 0, slot);
+	insert_extent(root, offset, sectorsize, sectorsize, 0, disk_bytenr,
+		sectorsize, BTRFS_FILE_EXTENT_PREALLOC, 0, slot);
 	slot++;
-	offset += 4096;
+	offset += sectorsize;
 
 	/*
 	 * We want to jack up disk_bytenr a little more so the em stuff doesn't
 	 * merge our records.
 	 */
-	disk_bytenr += 8192;
+	disk_bytenr += 2 * sectorsize;
 
 	/*
 	 * Now for a partially written prealloc extent, basically the same as
 	 * the hole punch example above.  Ram_bytes never changes when you mark
 	 * extents written btw.
 	 */
-	insert_extent(root, offset, 4096, 16384, 0, disk_bytenr, 16384,
-		      BTRFS_FILE_EXTENT_PREALLOC, 0, slot);
+	insert_extent(root, offset, sectorsize, 4 * sectorsize, 0, disk_bytenr,
+		      4 * sectorsize, BTRFS_FILE_EXTENT_PREALLOC, 0, slot);
 	slot++;
-	offset += 4096;
-	insert_extent(root, offset, 4096, 16384, 4096, disk_bytenr, 16384,
-		      BTRFS_FILE_EXTENT_REG, 0, slot);
+	offset += sectorsize;
+	insert_extent(root, offset, sectorsize, 4 * sectorsize, sectorsize,
+		      disk_bytenr, 4 * sectorsize, BTRFS_FILE_EXTENT_REG, 0,
+		      slot);
 	slot++;
-	offset += 4096;
-	insert_extent(root, offset, 8192, 16384, 8192, disk_bytenr, 16384,
+	offset += sectorsize;
+	insert_extent(root, offset, 2 * sectorsize, 4 * sectorsize,
+		      2 * sectorsize, disk_bytenr, 4 * sectorsize,
 		      BTRFS_FILE_EXTENT_PREALLOC, 0, slot);
 	slot++;
-	offset += 8192;
-	disk_bytenr += 16384;
+	offset += 2 * sectorsize;
+	disk_bytenr += 4 * sectorsize;
 
 	/* Now a normal compressed extent */
-	insert_extent(root, offset, 8192, 8192, 0, disk_bytenr, 4096,
-		      BTRFS_FILE_EXTENT_REG, BTRFS_COMPRESS_ZLIB, slot);
+	insert_extent(root, offset, 2 * sectorsize, 2 * sectorsize, 0,
+		      disk_bytenr, sectorsize, BTRFS_FILE_EXTENT_REG,
+		      BTRFS_COMPRESS_ZLIB, slot);
 	slot++;
-	offset += 8192;
+	offset += 2 * sectorsize;
 	/* No merges */
-	disk_bytenr += 8192;
+	disk_bytenr += 2 * sectorsize;
 
 	/* Now a split compressed extent */
-	insert_extent(root, offset, 4096, 16384, 0, disk_bytenr, 4096,
-		      BTRFS_FILE_EXTENT_REG, BTRFS_COMPRESS_ZLIB, slot);
+	insert_extent(root, offset, sectorsize, 4 * sectorsize, 0, disk_bytenr,
+		      sectorsize, BTRFS_FILE_EXTENT_REG,
+		      BTRFS_COMPRESS_ZLIB, slot);
 	slot++;
-	offset += 4096;
-	insert_extent(root, offset, 4096, 4096, 0, disk_bytenr + 4096, 4096,
+	offset += sectorsize;
+	insert_extent(root, offset, sectorsize, sectorsize, 0,
+		      disk_bytenr + sectorsize, sectorsize,
 		      BTRFS_FILE_EXTENT_REG, 0, slot);
 	slot++;
-	offset += 4096;
-	insert_extent(root, offset, 8192, 16384, 8192, disk_bytenr, 4096,
+	offset += sectorsize;
+	insert_extent(root, offset, 2 * sectorsize, 4 * sectorsize,
+		      2 * sectorsize, disk_bytenr, sectorsize,
 		      BTRFS_FILE_EXTENT_REG, BTRFS_COMPRESS_ZLIB, slot);
 	slot++;
-	offset += 8192;
-	disk_bytenr += 8192;
+	offset += 2 * sectorsize;
+	disk_bytenr += 2 * sectorsize;
 
 	/* Now extents that have a hole but no hole extent */
-	insert_extent(root, offset, 4096, 4096, 0, disk_bytenr, 4096,
-		      BTRFS_FILE_EXTENT_REG, 0, slot);
+	insert_extent(root, offset, sectorsize, sectorsize, 0, disk_bytenr,
+		      sectorsize, BTRFS_FILE_EXTENT_REG, 0, slot);
 	slot++;
-	offset += 16384;
-	disk_bytenr += 4096;
-	insert_extent(root, offset, 4096, 4096, 0, disk_bytenr, 4096,
-		      BTRFS_FILE_EXTENT_REG, 0, slot);
+	offset += 4 * sectorsize;
+	disk_bytenr += sectorsize;
+	insert_extent(root, offset, sectorsize, sectorsize, 0, disk_bytenr,
+		      sectorsize, BTRFS_FILE_EXTENT_REG, 0, slot);
 }
 
 static unsigned long prealloc_only = 0;
 static unsigned long compressed_only = 0;
 static unsigned long vacancy_only = 0;
 
-static noinline int test_btrfs_get_extent(void)
+static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 {
 	struct inode *inode = NULL;
 	struct btrfs_root *root = NULL;
@@ -240,7 +248,7 @@ static noinline int test_btrfs_get_extent(void)
 	BTRFS_I(inode)->location.objectid = BTRFS_FIRST_FREE_OBJECTID;
 	BTRFS_I(inode)->location.offset = 0;
 
-	root = btrfs_alloc_dummy_root();
+	root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(root)) {
 		test_msg("Couldn't allocate root\n");
 		goto out;
@@ -256,7 +264,7 @@ static noinline int test_btrfs_get_extent(void)
 		goto out;
 	}
 
-	root->node = alloc_dummy_extent_buffer(NULL, 4096);
+	root->node = alloc_dummy_extent_buffer(NULL, nodesize, nodesize);
 	if (!root->node) {
 		test_msg("Couldn't allocate dummy buffer\n");
 		goto out;
@@ -273,7 +281,7 @@ static noinline int test_btrfs_get_extent(void)
 
 	/* First with no extents */
 	BTRFS_I(inode)->root = root;
-	em = btrfs_get_extent(inode, NULL, 0, 0, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, 0, sectorsize, 0);
 	if (IS_ERR(em)) {
 		em = NULL;
 		test_msg("Got an error when we shouldn't have\n");
@@ -295,7 +303,7 @@ static noinline int test_btrfs_get_extent(void)
 	 * setup_file_extents, so if you change anything there you need to
 	 * update the comment and update the expected values below.
 	 */
-	setup_file_extents(root);
+	setup_file_extents(root, sectorsize);
 
 	em = btrfs_get_extent(inode, NULL, 0, 0, (u64)-1, 0);
 	if (IS_ERR(em)) {
@@ -318,7 +326,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -327,7 +335,8 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected an inline, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4091) {
+
+	if (em->start != offset || em->len != (sectorsize - 5)) {
 		test_msg("Unexpected extent wanted start %llu len 1, got start "
 			 "%llu len %llu\n", offset, em->start, em->len);
 		goto out;
@@ -344,7 +353,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -366,7 +375,7 @@ static noinline int test_btrfs_get_extent(void)
 	free_extent_map(em);
 
 	/* Regular extent */
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -375,7 +384,7 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4095) {
+	if (em->start != offset || em->len != sectorsize - 1) {
 		test_msg("Unexpected extent wanted start %llu len 4095, got "
 			 "start %llu len %llu\n", offset, em->start, em->len);
 		goto out;
@@ -393,7 +402,7 @@ static noinline int test_btrfs_get_extent(void)
 	free_extent_map(em);
 
 	/* The next 3 are split extents */
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -402,9 +411,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -421,7 +431,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -430,9 +440,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a hole, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -442,7 +453,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -451,9 +462,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 8192) {
-		test_msg("Unexpected extent wanted start %llu len 8192, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != 2 * sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, 2 * sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -475,7 +487,7 @@ static noinline int test_btrfs_get_extent(void)
 	free_extent_map(em);
 
 	/* Prealloc extent */
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -484,9 +496,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != prealloc_only) {
@@ -503,7 +516,7 @@ static noinline int test_btrfs_get_extent(void)
 	free_extent_map(em);
 
 	/* The next 3 are a half written prealloc extent */
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -512,9 +525,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != prealloc_only) {
@@ -532,7 +546,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -541,9 +555,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -564,7 +579,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -573,9 +588,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 8192) {
-		test_msg("Unexpected extent wanted start %llu len 8192, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != 2 * sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, 2 * sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != prealloc_only) {
@@ -598,7 +614,7 @@ static noinline int test_btrfs_get_extent(void)
 	free_extent_map(em);
 
 	/* Now for the compressed extent */
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -607,9 +623,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 8192) {
-		test_msg("Unexpected extent wanted start %llu len 8192, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != 2 * sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u,"
+			"got start %llu len %llu\n",
+			offset, 2 * sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != compressed_only) {
@@ -631,7 +648,7 @@ static noinline int test_btrfs_get_extent(void)
 	free_extent_map(em);
 
 	/* Split compressed extent */
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -640,9 +657,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u,"
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != compressed_only) {
@@ -665,7 +683,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -674,9 +692,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -691,7 +710,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -701,9 +720,10 @@ static noinline int test_btrfs_get_extent(void)
 			 disk_bytenr, em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 8192) {
-		test_msg("Unexpected extent wanted start %llu len 8192, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != 2 * sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, 2 * sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != compressed_only) {
@@ -725,7 +745,7 @@ static noinline int test_btrfs_get_extent(void)
 	free_extent_map(em);
 
 	/* A hole between regular extents but no hole extent */
-	em = btrfs_get_extent(inode, NULL, 0, offset + 6, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset + 6, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -734,9 +754,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -765,9 +786,10 @@ static noinline int test_btrfs_get_extent(void)
 	 * length of the actual hole, if this changes we'll have to change this
 	 * test.
 	 */
-	if (em->start != offset || em->len != 12288) {
-		test_msg("Unexpected extent wanted start %llu len 12288, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != 3 * sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, 3 * sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != vacancy_only) {
@@ -783,7 +805,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -792,9 +814,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u,"
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -815,7 +838,7 @@ out:
 	return ret;
 }
 
-static int test_hole_first(void)
+static int test_hole_first(u32 sectorsize, u32 nodesize)
 {
 	struct inode *inode = NULL;
 	struct btrfs_root *root = NULL;
@@ -832,7 +855,7 @@ static int test_hole_first(void)
 	BTRFS_I(inode)->location.objectid = BTRFS_FIRST_FREE_OBJECTID;
 	BTRFS_I(inode)->location.offset = 0;
 
-	root = btrfs_alloc_dummy_root();
+	root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(root)) {
 		test_msg("Couldn't allocate root\n");
 		goto out;
@@ -844,7 +867,7 @@ static int test_hole_first(void)
 		goto out;
 	}
 
-	root->node = alloc_dummy_extent_buffer(NULL, 4096);
+	root->node = alloc_dummy_extent_buffer(NULL, nodesize, nodesize);
 	if (!root->node) {
 		test_msg("Couldn't allocate dummy buffer\n");
 		goto out;
@@ -861,9 +884,9 @@ static int test_hole_first(void)
 	 * btrfs_get_extent.
 	 */
 	insert_inode_item_key(root);
-	insert_extent(root, 4096, 4096, 4096, 0, 4096, 4096,
-		      BTRFS_FILE_EXTENT_REG, 0, 1);
-	em = btrfs_get_extent(inode, NULL, 0, 0, 8192, 0);
+	insert_extent(root, sectorsize, sectorsize, sectorsize, 0, sectorsize,
+		      sectorsize, BTRFS_FILE_EXTENT_REG, 0, 1);
+	em = btrfs_get_extent(inode, NULL, 0, 0, 2 * sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -872,9 +895,10 @@ static int test_hole_first(void)
 		test_msg("Expected a hole, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != 0 || em->len != 4096) {
-		test_msg("Unexpected extent wanted start 0 len 4096, got start "
-			 "%llu len %llu\n", em->start, em->len);
+	if (em->start != 0 || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start 0 len %u, "
+			"got start %llu len %llu\n",
+			sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != vacancy_only) {
@@ -884,18 +908,19 @@ static int test_hole_first(void)
 	}
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, 4096, 8192, 0);
+	em = btrfs_get_extent(inode, NULL, 0, sectorsize, 2 * sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
 	}
-	if (em->block_start != 4096) {
+	if (em->block_start != sectorsize) {
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != 4096 || em->len != 4096) {
-		test_msg("Unexpected extent wanted start 4096 len 4096, got "
-			 "start %llu len %llu\n", em->start, em->len);
+	if (em->start != sectorsize || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %u len %u, "
+			"got start %llu len %llu\n",
+			sectorsize, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -912,7 +937,7 @@ out:
 	return ret;
 }
 
-static int test_extent_accounting(void)
+static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 {
 	struct inode *inode = NULL;
 	struct btrfs_root *root = NULL;
@@ -924,7 +949,7 @@ static int test_extent_accounting(void)
 		return ret;
 	}
 
-	root = btrfs_alloc_dummy_root();
+	root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(root)) {
 		test_msg("Couldn't allocate root\n");
 		goto out;
@@ -954,10 +979,11 @@ static int test_extent_accounting(void)
 		goto out;
 	}
 
-	/* [BTRFS_MAX_EXTENT_SIZE][4k] */
+	/* [BTRFS_MAX_EXTENT_SIZE][sectorsize] */
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE,
-					BTRFS_MAX_EXTENT_SIZE + 4095, NULL);
+					BTRFS_MAX_EXTENT_SIZE + sectorsize - 1,
+					NULL);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -969,10 +995,10 @@ static int test_extent_accounting(void)
 		goto out;
 	}
 
-	/* [BTRFS_MAX_EXTENT_SIZE/2][4K HOLE][the rest] */
+	/* [BTRFS_MAX_EXTENT_SIZE/2][sectorsize HOLE][the rest] */
 	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree,
 			       BTRFS_MAX_EXTENT_SIZE >> 1,
-			       (BTRFS_MAX_EXTENT_SIZE >> 1) + 4095,
+			       (BTRFS_MAX_EXTENT_SIZE >> 1) + sectorsize - 1,
 			       EXTENT_DELALLOC | EXTENT_DIRTY |
 			       EXTENT_UPTODATE | EXTENT_DO_ACCOUNTING, 0, 0,
 			       NULL, GFP_KERNEL);
@@ -987,10 +1013,11 @@ static int test_extent_accounting(void)
 		goto out;
 	}
 
-	/* [BTRFS_MAX_EXTENT_SIZE][4K] */
+	/* [BTRFS_MAX_EXTENT_SIZE][sectorsize] */
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE >> 1,
-					(BTRFS_MAX_EXTENT_SIZE >> 1) + 4095,
+					(BTRFS_MAX_EXTENT_SIZE >> 1)
+					+ sectorsize - 1,
 					NULL);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
@@ -1004,16 +1031,17 @@ static int test_extent_accounting(void)
 	}
 
 	/*
-	 * [BTRFS_MAX_EXTENT_SIZE+4K][4K HOLE][BTRFS_MAX_EXTENT_SIZE+4K]
+	 * [BTRFS_MAX_EXTENT_SIZE+sectorsize][sectorsize HOLE][BTRFS_MAX_EXTENT_SIZE+sectorsize]
 	 *
 	 * I'm artificially adding 2 to outstanding_extents because in the
 	 * buffered IO case we'd add things up as we go, but I don't feel like
 	 * doing that here, this isn't the interesting case we want to test.
 	 */
 	BTRFS_I(inode)->outstanding_extents += 2;
-	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE + 8192,
-					(BTRFS_MAX_EXTENT_SIZE << 1) + 12287,
-					NULL);
+	ret = btrfs_set_extent_delalloc(inode,
+			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize,
+			(BTRFS_MAX_EXTENT_SIZE << 1) + 3 * sectorsize - 1,
+			NULL);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1025,10 +1053,13 @@ static int test_extent_accounting(void)
 		goto out;
 	}
 
-	/* [BTRFS_MAX_EXTENT_SIZE+4k][4k][BTRFS_MAX_EXTENT_SIZE+4k] */
+	/*
+	* [BTRFS_MAX_EXTENT_SIZE+sectorsize][sectorsize][BTRFS_MAX_EXTENT_SIZE+sectorsize]
+	*/
 	BTRFS_I(inode)->outstanding_extents++;
-	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE+4096,
-					BTRFS_MAX_EXTENT_SIZE+8191, NULL);
+	ret = btrfs_set_extent_delalloc(inode,
+			BTRFS_MAX_EXTENT_SIZE + sectorsize,
+			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1042,8 +1073,8 @@ static int test_extent_accounting(void)
 
 	/* [BTRFS_MAX_EXTENT_SIZE+4k][4K HOLE][BTRFS_MAX_EXTENT_SIZE+4k] */
 	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree,
-			       BTRFS_MAX_EXTENT_SIZE+4096,
-			       BTRFS_MAX_EXTENT_SIZE+8191,
+			       BTRFS_MAX_EXTENT_SIZE + sectorsize,
+			       BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1,
 			       EXTENT_DIRTY | EXTENT_DELALLOC |
 			       EXTENT_DO_ACCOUNTING | EXTENT_UPTODATE, 0, 0,
 			       NULL, GFP_KERNEL);
@@ -1063,8 +1094,9 @@ static int test_extent_accounting(void)
 	 * might fail and I'd rather satisfy my paranoia at this point.
 	 */
 	BTRFS_I(inode)->outstanding_extents++;
-	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE+4096,
-					BTRFS_MAX_EXTENT_SIZE+8191, NULL);
+	ret = btrfs_set_extent_delalloc(inode,
+			BTRFS_MAX_EXTENT_SIZE + sectorsize,
+			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1103,7 +1135,7 @@ out:
 	return ret;
 }
 
-int btrfs_test_inodes(void)
+int btrfs_test_inodes(u32 sectorsize, u32 nodesize)
 {
 	int ret;
 
@@ -1112,13 +1144,13 @@ int btrfs_test_inodes(void)
 	set_bit(EXTENT_FLAG_PREALLOC, &prealloc_only);
 
 	test_msg("Running btrfs_get_extent tests\n");
-	ret = test_btrfs_get_extent();
+	ret = test_btrfs_get_extent(sectorsize, nodesize);
 	if (ret)
 		return ret;
 	test_msg("Running hole first btrfs_get_extent test\n");
-	ret = test_hole_first();
+	ret = test_hole_first(sectorsize, nodesize);
 	if (ret)
 		return ret;
 	test_msg("Running outstanding_extents tests\n");
-	return test_extent_accounting();
+	return test_extent_accounting(sectorsize, nodesize);
 }
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 8aa4ded3..9c1d273 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -16,6 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <linux/types.h>
 #include "btrfs-tests.h"
 #include "../ctree.h"
 #include "../transaction.h"
@@ -216,7 +217,8 @@ static int remove_extent_ref(struct btrfs_root *root, u64 bytenr,
 	return ret;
 }
 
-static int test_no_shared_qgroup(struct btrfs_root *root)
+static int test_no_shared_qgroup(struct btrfs_root *root,
+		u32 sectorsize, u32 nodesize)
 {
 	struct btrfs_trans_handle trans;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -238,18 +240,18 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 	 * we can only call btrfs_qgroup_account_extent() directly to test
 	 * quota.
 	 */
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &old_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		test_msg("Couldn't find old roots: %d\n", ret);
 		return ret;
 	}
 
-	ret = insert_normal_tree_ref(root, 4096, 4096, 0, 5);
+	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0, 5);
 	if (ret)
 		return ret;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &new_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
@@ -257,32 +259,32 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 		return ret;
 	}
 
-	ret = btrfs_qgroup_account_extent(&trans, fs_info, 4096, 4096,
-					  old_roots, new_roots);
+	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
+					  nodesize, old_roots, new_roots);
 	if (ret) {
 		test_msg("Couldn't account space for a qgroup %d\n", ret);
 		return ret;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 5, 4096, 4096)) {
+	if (btrfs_verify_qgroup_counts(fs_info, 5, nodesize, nodesize)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
 	old_roots = NULL;
 	new_roots = NULL;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &old_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		test_msg("Couldn't find old roots: %d\n", ret);
 		return ret;
 	}
 
-	ret = remove_extent_item(root, 4096, 4096);
+	ret = remove_extent_item(root, nodesize, nodesize);
 	if (ret)
 		return -EINVAL;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &new_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
@@ -290,8 +292,8 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 		return ret;
 	}
 
-	ret = btrfs_qgroup_account_extent(&trans, fs_info, 4096, 4096,
-					  old_roots, new_roots);
+	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
+					  nodesize, old_roots, new_roots);
 	if (ret) {
 		test_msg("Couldn't account space for a qgroup %d\n", ret);
 		return -EINVAL;
@@ -310,7 +312,8 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
  * right, also remove one of the roots and make sure the exclusive count is
  * adjusted properly.
  */
-static int test_multiple_refs(struct btrfs_root *root)
+static int test_multiple_refs(struct btrfs_root *root,
+		u32 sectorsize, u32 nodesize)
 {
 	struct btrfs_trans_handle trans;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -329,18 +332,18 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return ret;
 	}
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &old_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		test_msg("Couldn't find old roots: %d\n", ret);
 		return ret;
 	}
 
-	ret = insert_normal_tree_ref(root, 4096, 4096, 0, 5);
+	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0, 5);
 	if (ret)
 		return ret;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &new_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
@@ -348,30 +351,31 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return ret;
 	}
 
-	ret = btrfs_qgroup_account_extent(&trans, fs_info, 4096, 4096,
-					  old_roots, new_roots);
+	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
+					  nodesize, old_roots, new_roots);
 	if (ret) {
 		test_msg("Couldn't account space for a qgroup %d\n", ret);
 		return ret;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 5, 4096, 4096)) {
+	if (btrfs_verify_qgroup_counts(fs_info, 5,
+				       nodesize, nodesize)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &old_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		test_msg("Couldn't find old roots: %d\n", ret);
 		return ret;
 	}
 
-	ret = add_tree_ref(root, 4096, 4096, 0, 256);
+	ret = add_tree_ref(root, nodesize, nodesize, 0, 256);
 	if (ret)
 		return ret;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &new_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
@@ -379,35 +383,35 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return ret;
 	}
 
-	ret = btrfs_qgroup_account_extent(&trans, fs_info, 4096, 4096,
-					  old_roots, new_roots);
+	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
+					  nodesize, old_roots, new_roots);
 	if (ret) {
 		test_msg("Couldn't account space for a qgroup %d\n", ret);
 		return ret;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 5, 4096, 0)) {
+	if (btrfs_verify_qgroup_counts(fs_info, 5, nodesize, 0)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 256, 4096, 0)) {
+	if (btrfs_verify_qgroup_counts(fs_info, 256, nodesize, 0)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &old_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		test_msg("Couldn't find old roots: %d\n", ret);
 		return ret;
 	}
 
-	ret = remove_extent_ref(root, 4096, 4096, 0, 256);
+	ret = remove_extent_ref(root, nodesize, nodesize, 0, 256);
 	if (ret)
 		return ret;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &new_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
@@ -415,8 +419,8 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return ret;
 	}
 
-	ret = btrfs_qgroup_account_extent(&trans, fs_info, 4096, 4096,
-					  old_roots, new_roots);
+	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
+					  nodesize, old_roots, new_roots);
 	if (ret) {
 		test_msg("Couldn't account space for a qgroup %d\n", ret);
 		return ret;
@@ -427,7 +431,7 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return -EINVAL;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 5, 4096, 4096)) {
+	if (btrfs_verify_qgroup_counts(fs_info, 5, nodesize, nodesize)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
@@ -435,13 +439,13 @@ static int test_multiple_refs(struct btrfs_root *root)
 	return 0;
 }
 
-int btrfs_test_qgroups(void)
+int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 {
 	struct btrfs_root *root;
 	struct btrfs_root *tmp_root;
 	int ret = 0;
 
-	root = btrfs_alloc_dummy_root();
+	root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(root)) {
 		test_msg("Couldn't allocate root\n");
 		return PTR_ERR(root);
@@ -468,7 +472,8 @@ int btrfs_test_qgroups(void)
 	 * Can't use bytenr 0, some things freak out
 	 * *cough*backref walking code*cough*
 	 */
-	root->node = alloc_test_extent_buffer(root->fs_info, 4096);
+	root->node = alloc_test_extent_buffer(root->fs_info, nodesize,
+					nodesize);
 	if (!root->node) {
 		test_msg("Couldn't allocate dummy buffer\n");
 		ret = -ENOMEM;
@@ -476,9 +481,9 @@ int btrfs_test_qgroups(void)
 	}
 	btrfs_set_header_level(root->node, 0);
 	btrfs_set_header_nritems(root->node, 0);
-	root->alloc_bytenr += 8192;
+	root->alloc_bytenr += 2 * nodesize;
 
-	tmp_root = btrfs_alloc_dummy_root();
+	tmp_root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(tmp_root)) {
 		test_msg("Couldn't allocate a fs root\n");
 		ret = PTR_ERR(tmp_root);
@@ -493,7 +498,7 @@ int btrfs_test_qgroups(void)
 		goto out;
 	}
 
-	tmp_root = btrfs_alloc_dummy_root();
+	tmp_root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(tmp_root)) {
 		test_msg("Couldn't allocate a fs root\n");
 		ret = PTR_ERR(tmp_root);
@@ -508,10 +513,10 @@ int btrfs_test_qgroups(void)
 	}
 
 	test_msg("Running qgroup tests\n");
-	ret = test_no_shared_qgroup(root);
+	ret = test_no_shared_qgroup(root, sectorsize, nodesize);
 	if (ret)
 		goto out;
-	ret = test_multiple_refs(root);
+	ret = test_multiple_refs(root, sectorsize, nodesize);
 out:
 	btrfs_free_dummy_root(root);
 	return ret;
-- 
2.7.4

