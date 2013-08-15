Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:32837 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab3HOR5f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Aug 2013 13:57:35 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C984F7C068B
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Aug 2013 11:57:34 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id dvZDBBeahmQ1X7As (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 15 Aug 2013 11:57:33 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: separate out tests into their own directory V2
Date: Thu, 15 Aug 2013 13:57:30 -0400
Message-ID: <1376589450-1581-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The plan is to have a bunch of unit tests that run when btrfs is loaded when you
build with the appropriate config option.  My ultimate goal is to have a test
for every non-static function we have, but at first I'm going to focus on the
things that cause us the most problems.  To start out with this just adds a
tests/ directory and moves the existing free space cache tests into that
directory and sets up all of the infrastructure.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2:
-fix some build errors with different config options
-add gpl header to the new files

 fs/btrfs/Makefile                 |    2 +
 fs/btrfs/free-space-cache.c       |  488 +++++--------------------------------
 fs/btrfs/free-space-cache.h       |    8 +-
 fs/btrfs/super.c                  |   10 +-
 fs/btrfs/tests/btrfs-tests.h      |   34 +++
 fs/btrfs/tests/free-space-tests.c |  395 ++++++++++++++++++++++++++++++
 6 files changed, 505 insertions(+), 432 deletions(-)
 create mode 100644 fs/btrfs/tests/btrfs-tests.h
 create mode 100644 fs/btrfs/tests/free-space-tests.c

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 3932224..47553d5 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -12,3 +12,5 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
+
+btrfs-$(CONFIG_BTRFS_FS_RUN_SANITY_TESTS) += tests/free-space-tests.o
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 2c262a5..34ecc65 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2972,33 +2972,68 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 }
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-static struct btrfs_block_group_cache *init_test_block_group(void)
+/*
+ * Use this if you need to make a bitmap or extent entry specifically, it
+ * doesn't do any of the merging that add_free_space does, this acts a lot like
+ * how the free space cache loading stuff works, so you can get really weird
+ * configurations.
+ */
+int test_add_free_space_entry(struct btrfs_block_group_cache *cache,
+			      u64 offset, u64 bytes, bool bitmap)
 {
-	struct btrfs_block_group_cache *cache;
+	struct btrfs_free_space_ctl *ctl = cache->free_space_ctl;
+	struct btrfs_free_space *info = NULL, *bitmap_info;
+	void *map = NULL;
+	u64 bytes_added;
+	int ret;
 
-	cache = kzalloc(sizeof(*cache), GFP_NOFS);
-	if (!cache)
-		return NULL;
-	cache->free_space_ctl = kzalloc(sizeof(*cache->free_space_ctl),
-					GFP_NOFS);
-	if (!cache->free_space_ctl) {
-		kfree(cache);
-		return NULL;
+again:
+	if (!info) {
+		info = kmem_cache_zalloc(btrfs_free_space_cachep, GFP_NOFS);
+		if (!info)
+			return -ENOMEM;
 	}
 
-	cache->key.objectid = 0;
-	cache->key.offset = 1024 * 1024 * 1024;
-	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
-	cache->sectorsize = 4096;
+	if (!bitmap) {
+		spin_lock(&ctl->tree_lock);
+		info->offset = offset;
+		info->bytes = bytes;
+		ret = link_free_space(ctl, info);
+		spin_unlock(&ctl->tree_lock);
+		if (ret)
+			kmem_cache_free(btrfs_free_space_cachep, info);
+		return ret;
+	}
+
+	if (!map) {
+		map = kzalloc(PAGE_CACHE_SIZE, GFP_NOFS);
+		if (!map) {
+			kmem_cache_free(btrfs_free_space_cachep, info);
+			return -ENOMEM;
+		}
+	}
+
+	spin_lock(&ctl->tree_lock);
+	bitmap_info = tree_search_offset(ctl, offset_to_bitmap(ctl, offset),
+					 1, 0);
+	if (!bitmap_info) {
+		info->bitmap = map;
+		map = NULL;
+		add_new_bitmap(ctl, info, offset);
+		bitmap_info = info;
+	}
 
-	spin_lock_init(&cache->lock);
-	INIT_LIST_HEAD(&cache->list);
-	INIT_LIST_HEAD(&cache->cluster_list);
-	INIT_LIST_HEAD(&cache->new_bg_list);
+	bytes_added = add_bytes_to_bitmap(ctl, bitmap_info, offset, bytes);
+	bytes -= bytes_added;
+	offset += bytes_added;
+	spin_unlock(&ctl->tree_lock);
 
-	btrfs_init_free_space_ctl(cache);
+	if (bytes)
+		goto again;
 
-	return cache;
+	if (map)
+		kfree(map);
+	return 0;
 }
 
 /*
@@ -3006,8 +3041,8 @@ static struct btrfs_block_group_cache *init_test_block_group(void)
  * just used to check the absence of space, so if there is free space in the
  * range at all we will return 1.
  */
-static int check_exists(struct btrfs_block_group_cache *cache, u64 offset,
-			u64 bytes)
+int test_check_exists(struct btrfs_block_group_cache *cache,
+		      u64 offset, u64 bytes)
 {
 	struct btrfs_free_space_ctl *ctl = cache->free_space_ctl;
 	struct btrfs_free_space *info;
@@ -3084,411 +3119,4 @@ out:
 	spin_unlock(&ctl->tree_lock);
 	return ret;
 }
-
-/*
- * Use this if you need to make a bitmap or extent entry specifically, it
- * doesn't do any of the merging that add_free_space does, this acts a lot like
- * how the free space cache loading stuff works, so you can get really weird
- * configurations.
- */
-static int add_free_space_entry(struct btrfs_block_group_cache *cache,
-				u64 offset, u64 bytes, bool bitmap)
-{
-	struct btrfs_free_space_ctl *ctl = cache->free_space_ctl;
-	struct btrfs_free_space *info = NULL, *bitmap_info;
-	void *map = NULL;
-	u64 bytes_added;
-	int ret;
-
-again:
-	if (!info) {
-		info = kmem_cache_zalloc(btrfs_free_space_cachep, GFP_NOFS);
-		if (!info)
-			return -ENOMEM;
-	}
-
-	if (!bitmap) {
-		spin_lock(&ctl->tree_lock);
-		info->offset = offset;
-		info->bytes = bytes;
-		ret = link_free_space(ctl, info);
-		spin_unlock(&ctl->tree_lock);
-		if (ret)
-			kmem_cache_free(btrfs_free_space_cachep, info);
-		return ret;
-	}
-
-	if (!map) {
-		map = kzalloc(PAGE_CACHE_SIZE, GFP_NOFS);
-		if (!map) {
-			kmem_cache_free(btrfs_free_space_cachep, info);
-			return -ENOMEM;
-		}
-	}
-
-	spin_lock(&ctl->tree_lock);
-	bitmap_info = tree_search_offset(ctl, offset_to_bitmap(ctl, offset),
-					 1, 0);
-	if (!bitmap_info) {
-		info->bitmap = map;
-		map = NULL;
-		add_new_bitmap(ctl, info, offset);
-		bitmap_info = info;
-	}
-
-	bytes_added = add_bytes_to_bitmap(ctl, bitmap_info, offset, bytes);
-	bytes -= bytes_added;
-	offset += bytes_added;
-	spin_unlock(&ctl->tree_lock);
-
-	if (bytes)
-		goto again;
-
-	if (map)
-		kfree(map);
-	return 0;
-}
-
-#define test_msg(fmt, ...) printk(KERN_INFO "btrfs: selftest: " fmt, ##__VA_ARGS__)
-
-/*
- * This test just does basic sanity checking, making sure we can add an exten
- * entry and remove space from either end and the middle, and make sure we can
- * remove space that covers adjacent extent entries.
- */
-static int test_extents(struct btrfs_block_group_cache *cache)
-{
-	int ret = 0;
-
-	test_msg("Running extent only tests\n");
-
-	/* First just make sure we can remove an entire entry */
-	ret = btrfs_add_free_space(cache, 0, 4 * 1024 * 1024);
-	if (ret) {
-		test_msg("Error adding initial extents %d\n", ret);
-		return ret;
-	}
-
-	ret = btrfs_remove_free_space(cache, 0, 4 * 1024 * 1024);
-	if (ret) {
-		test_msg("Error removing extent %d\n", ret);
-		return ret;
-	}
-
-	if (check_exists(cache, 0, 4 * 1024 * 1024)) {
-		test_msg("Full remove left some lingering space\n");
-		return -1;
-	}
-
-	/* Ok edge and middle cases now */
-	ret = btrfs_add_free_space(cache, 0, 4 * 1024 * 1024);
-	if (ret) {
-		test_msg("Error adding half extent %d\n", ret);
-		return ret;
-	}
-
-	ret = btrfs_remove_free_space(cache, 3 * 1024 * 1024, 1 * 1024 * 1024);
-	if (ret) {
-		test_msg("Error removing tail end %d\n", ret);
-		return ret;
-	}
-
-	ret = btrfs_remove_free_space(cache, 0, 1 * 1024 * 1024);
-	if (ret) {
-		test_msg("Error removing front end %d\n", ret);
-		return ret;
-	}
-
-	ret = btrfs_remove_free_space(cache, 2 * 1024 * 1024, 4096);
-	if (ret) {
-		test_msg("Error removing middle peice %d\n", ret);
-		return ret;
-	}
-
-	if (check_exists(cache, 0, 1 * 1024 * 1024)) {
-		test_msg("Still have space at the front\n");
-		return -1;
-	}
-
-	if (check_exists(cache, 2 * 1024 * 1024, 4096)) {
-		test_msg("Still have space in the middle\n");
-		return -1;
-	}
-
-	if (check_exists(cache, 3 * 1024 * 1024, 1 * 1024 * 1024)) {
-		test_msg("Still have space at the end\n");
-		return -1;
-	}
-
-	/* Cleanup */
-	__btrfs_remove_free_space_cache(cache->free_space_ctl);
-
-	return 0;
-}
-
-static int test_bitmaps(struct btrfs_block_group_cache *cache)
-{
-	u64 next_bitmap_offset;
-	int ret;
-
-	test_msg("Running bitmap only tests\n");
-
-	ret = add_free_space_entry(cache, 0, 4 * 1024 * 1024, 1);
-	if (ret) {
-		test_msg("Couldn't create a bitmap entry %d\n", ret);
-		return ret;
-	}
-
-	ret = btrfs_remove_free_space(cache, 0, 4 * 1024 * 1024);
-	if (ret) {
-		test_msg("Error removing bitmap full range %d\n", ret);
-		return ret;
-	}
-
-	if (check_exists(cache, 0, 4 * 1024 * 1024)) {
-		test_msg("Left some space in bitmap\n");
-		return -1;
-	}
-
-	ret = add_free_space_entry(cache, 0, 4 * 1024 * 1024, 1);
-	if (ret) {
-		test_msg("Couldn't add to our bitmap entry %d\n", ret);
-		return ret;
-	}
-
-	ret = btrfs_remove_free_space(cache, 1 * 1024 * 1024, 2 * 1024 * 1024);
-	if (ret) {
-		test_msg("Couldn't remove middle chunk %d\n", ret);
-		return ret;
-	}
-
-	/*
-	 * The first bitmap we have starts at offset 0 so the next one is just
-	 * at the end of the first bitmap.
-	 */
-	next_bitmap_offset = (u64)(BITS_PER_BITMAP * 4096);
-
-	/* Test a bit straddling two bitmaps */
-	ret = add_free_space_entry(cache, next_bitmap_offset -
-				   (2 * 1024 * 1024), 4 * 1024 * 1024, 1);
-	if (ret) {
-		test_msg("Couldn't add space that straddles two bitmaps %d\n",
-				ret);
-		return ret;
-	}
-
-	ret = btrfs_remove_free_space(cache, next_bitmap_offset -
-				      (1 * 1024 * 1024), 2 * 1024 * 1024);
-	if (ret) {
-		test_msg("Couldn't remove overlapping space %d\n", ret);
-		return ret;
-	}
-
-	if (check_exists(cache, next_bitmap_offset - (1 * 1024 * 1024),
-			 2 * 1024 * 1024)) {
-		test_msg("Left some space when removing overlapping\n");
-		return -1;
-	}
-
-	__btrfs_remove_free_space_cache(cache->free_space_ctl);
-
-	return 0;
-}
-
-/* This is the high grade jackassery */
-static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache)
-{
-	u64 bitmap_offset = (u64)(BITS_PER_BITMAP * 4096);
-	int ret;
-
-	test_msg("Running bitmap and extent tests\n");
-
-	/*
-	 * First let's do something simple, an extent at the same offset as the
-	 * bitmap, but the free space completely in the extent and then
-	 * completely in the bitmap.
-	 */
-	ret = add_free_space_entry(cache, 4 * 1024 * 1024, 1 * 1024 * 1024, 1);
-	if (ret) {
-		test_msg("Couldn't create bitmap entry %d\n", ret);
-		return ret;
-	}
-
-	ret = add_free_space_entry(cache, 0, 1 * 1024 * 1024, 0);
-	if (ret) {
-		test_msg("Couldn't add extent entry %d\n", ret);
-		return ret;
-	}
-
-	ret = btrfs_remove_free_space(cache, 0, 1 * 1024 * 1024);
-	if (ret) {
-		test_msg("Couldn't remove extent entry %d\n", ret);
-		return ret;
-	}
-
-	if (check_exists(cache, 0, 1 * 1024 * 1024)) {
-		test_msg("Left remnants after our remove\n");
-		return -1;
-	}
-
-	/* Now to add back the extent entry and remove from the bitmap */
-	ret = add_free_space_entry(cache, 0, 1 * 1024 * 1024, 0);
-	if (ret) {
-		test_msg("Couldn't re-add extent entry %d\n", ret);
-		return ret;
-	}
-
-	ret = btrfs_remove_free_space(cache, 4 * 1024 * 1024, 1 * 1024 * 1024);
-	if (ret) {
-		test_msg("Couldn't remove from bitmap %d\n", ret);
-		return ret;
-	}
-
-	if (check_exists(cache, 4 * 1024 * 1024, 1 * 1024 * 1024)) {
-		test_msg("Left remnants in the bitmap\n");
-		return -1;
-	}
-
-	/*
-	 * Ok so a little more evil, extent entry and bitmap at the same offset,
-	 * removing an overlapping chunk.
-	 */
-	ret = add_free_space_entry(cache, 1 * 1024 * 1024, 4 * 1024 * 1024, 1);
-	if (ret) {
-		test_msg("Couldn't add to a bitmap %d\n", ret);
-		return ret;
-	}
-
-	ret = btrfs_remove_free_space(cache, 512 * 1024, 3 * 1024 * 1024);
-	if (ret) {
-		test_msg("Couldn't remove overlapping space %d\n", ret);
-		return ret;
-	}
-
-	if (check_exists(cache, 512 * 1024, 3 * 1024 * 1024)) {
-		test_msg("Left over peices after removing overlapping\n");
-		return -1;
-	}
-
-	__btrfs_remove_free_space_cache(cache->free_space_ctl);
-
-	/* Now with the extent entry offset into the bitmap */
-	ret = add_free_space_entry(cache, 4 * 1024 * 1024, 4 * 1024 * 1024, 1);
-	if (ret) {
-		test_msg("Couldn't add space to the bitmap %d\n", ret);
-		return ret;
-	}
-
-	ret = add_free_space_entry(cache, 2 * 1024 * 1024, 2 * 1024 * 1024, 0);
-	if (ret) {
-		test_msg("Couldn't add extent to the cache %d\n", ret);
-		return ret;
-	}
-
-	ret = btrfs_remove_free_space(cache, 3 * 1024 * 1024, 4 * 1024 * 1024);
-	if (ret) {
-		test_msg("Problem removing overlapping space %d\n", ret);
-		return ret;
-	}
-
-	if (check_exists(cache, 3 * 1024 * 1024, 4 * 1024 * 1024)) {
-		test_msg("Left something behind when removing space");
-		return -1;
-	}
-
-	/*
-	 * This has blown up in the past, the extent entry starts before the
-	 * bitmap entry, but we're trying to remove an offset that falls
-	 * completely within the bitmap range and is in both the extent entry
-	 * and the bitmap entry, looks like this
-	 *
-	 *   [ extent ]
-	 *      [ bitmap ]
-	 *        [ del ]
-	 */
-	__btrfs_remove_free_space_cache(cache->free_space_ctl);
-	ret = add_free_space_entry(cache, bitmap_offset + 4 * 1024 * 1024,
-				   4 * 1024 * 1024, 1);
-	if (ret) {
-		test_msg("Couldn't add bitmap %d\n", ret);
-		return ret;
-	}
-
-	ret = add_free_space_entry(cache, bitmap_offset - 1 * 1024 * 1024,
-				   5 * 1024 * 1024, 0);
-	if (ret) {
-		test_msg("Couldn't add extent entry %d\n", ret);
-		return ret;
-	}
-
-	ret = btrfs_remove_free_space(cache, bitmap_offset + 1 * 1024 * 1024,
-				      5 * 1024 * 1024);
-	if (ret) {
-		test_msg("Failed to free our space %d\n", ret);
-		return ret;
-	}
-
-	if (check_exists(cache, bitmap_offset + 1 * 1024 * 1024,
-			 5 * 1024 * 1024)) {
-		test_msg("Left stuff over\n");
-		return -1;
-	}
-
-	__btrfs_remove_free_space_cache(cache->free_space_ctl);
-
-	/*
-	 * This blew up before, we have part of the free space in a bitmap and
-	 * then the entirety of the rest of the space in an extent.  This used
-	 * to return -EAGAIN back from btrfs_remove_extent, make sure this
-	 * doesn't happen.
-	 */
-	ret = add_free_space_entry(cache, 1 * 1024 * 1024, 2 * 1024 * 1024, 1);
-	if (ret) {
-		test_msg("Couldn't add bitmap entry %d\n", ret);
-		return ret;
-	}
-
-	ret = add_free_space_entry(cache, 3 * 1024 * 1024, 1 * 1024 * 1024, 0);
-	if (ret) {
-		test_msg("Couldn't add extent entry %d\n", ret);
-		return ret;
-	}
-
-	ret = btrfs_remove_free_space(cache, 1 * 1024 * 1024, 3 * 1024 * 1024);
-	if (ret) {
-		test_msg("Error removing bitmap and extent overlapping %d\n", ret);
-		return ret;
-	}
-
-	__btrfs_remove_free_space_cache(cache->free_space_ctl);
-	return 0;
-}
-
-void btrfs_test_free_space_cache(void)
-{
-	struct btrfs_block_group_cache *cache;
-
-	test_msg("Running btrfs free space cache tests\n");
-
-	cache = init_test_block_group();
-	if (!cache) {
-		test_msg("Couldn't run the tests\n");
-		return;
-	}
-
-	if (test_extents(cache))
-		goto out;
-	if (test_bitmaps(cache))
-		goto out;
-	if (test_bitmaps_and_extents(cache))
-		goto out;
-out:
-	__btrfs_remove_free_space_cache(cache->free_space_ctl);
-	kfree(cache->free_space_ctl);
-	kfree(cache);
-	test_msg("Free space cache tests finished\n");
-}
-#undef test_msg
-#else /* !CONFIG_BTRFS_FS_RUN_SANITY_TESTS */
-void btrfs_test_free_space_cache(void) {}
-#endif /* !CONFIG_BTRFS_FS_RUN_SANITY_TESTS */
+#endif /* CONFIG_BTRFS_FS_RUN_SANITY_TESTS */
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 4acfb19..c749041 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -112,6 +112,12 @@ int btrfs_return_cluster_to_free_space(
 int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 			   u64 *trimmed, u64 start, u64 end, u64 minlen);
 
-void btrfs_test_free_space_cache(void);
+/* Support functions for runnint our sanity tests */
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+int test_add_free_space_entry(struct btrfs_block_group_cache *cache,
+			      u64 offset, u64 bytes, bool bitmap);
+int test_check_exists(struct btrfs_block_group_cache *cache,
+		      u64 offset, u64 bytes);
+#endif
 
 #endif
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1967903..f53faf0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -56,6 +56,7 @@
 #include "rcu-string.h"
 #include "dev-replace.h"
 #include "free-space-cache.h"
+#include "tests/btrfs-tests.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
@@ -1762,6 +1763,11 @@ static void btrfs_print_info(void)
 			"\n");
 }
 
+static int btrfs_run_sanity_tests(void)
+{
+	return btrfs_test_free_space_cache();
+}
+
 static int __init init_btrfs_fs(void)
 {
 	int err;
@@ -1811,8 +1817,10 @@ static int __init init_btrfs_fs(void)
 	btrfs_init_lockdep();
 
 	btrfs_print_info();
-	btrfs_test_free_space_cache();
 
+	err = btrfs_run_sanity_tests();
+	if (err)
+		goto unregister_ioctl;
 	return 0;
 
 unregister_ioctl:
diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
new file mode 100644
index 0000000..5808776
--- /dev/null
+++ b/fs/btrfs/tests/btrfs-tests.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2013 Fusion IO.  All rights reserved.
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
+#ifndef __BTRFS_TESTS
+#define __BTRFS_TESTS
+
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+
+#define test_msg(fmt, ...) pr_info("btrfs: selftest: " fmt, ##__VA_ARGS__)
+
+int btrfs_test_free_space_cache(void);
+#else
+static inline int btrfs_test_free_space_cache(void)
+{
+	return 0;
+}
+#endif
+
+#endif
diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
new file mode 100644
index 0000000..6fc8201
--- /dev/null
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -0,0 +1,395 @@
+/*
+ * Copyright (C) 2013 Fusion IO.  All rights reserved.
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
+#include <linux/slab.h>
+#include "btrfs-tests.h"
+#include "../ctree.h"
+#include "../free-space-cache.h"
+
+#define BITS_PER_BITMAP		(PAGE_CACHE_SIZE * 8)
+static struct btrfs_block_group_cache *init_test_block_group(void)
+{
+	struct btrfs_block_group_cache *cache;
+
+	cache = kzalloc(sizeof(*cache), GFP_NOFS);
+	if (!cache)
+		return NULL;
+	cache->free_space_ctl = kzalloc(sizeof(*cache->free_space_ctl),
+					GFP_NOFS);
+	if (!cache->free_space_ctl) {
+		kfree(cache);
+		return NULL;
+	}
+
+	cache->key.objectid = 0;
+	cache->key.offset = 1024 * 1024 * 1024;
+	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+	cache->sectorsize = 4096;
+
+	spin_lock_init(&cache->lock);
+	INIT_LIST_HEAD(&cache->list);
+	INIT_LIST_HEAD(&cache->cluster_list);
+	INIT_LIST_HEAD(&cache->new_bg_list);
+
+	btrfs_init_free_space_ctl(cache);
+
+	return cache;
+}
+
+/*
+ * This test just does basic sanity checking, making sure we can add an exten
+ * entry and remove space from either end and the middle, and make sure we can
+ * remove space that covers adjacent extent entries.
+ */
+static int test_extents(struct btrfs_block_group_cache *cache)
+{
+	int ret = 0;
+
+	test_msg("Running extent only tests\n");
+
+	/* First just make sure we can remove an entire entry */
+	ret = btrfs_add_free_space(cache, 0, 4 * 1024 * 1024);
+	if (ret) {
+		test_msg("Error adding initial extents %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 0, 4 * 1024 * 1024);
+	if (ret) {
+		test_msg("Error removing extent %d\n", ret);
+		return ret;
+	}
+
+	if (test_check_exists(cache, 0, 4 * 1024 * 1024)) {
+		test_msg("Full remove left some lingering space\n");
+		return -1;
+	}
+
+	/* Ok edge and middle cases now */
+	ret = btrfs_add_free_space(cache, 0, 4 * 1024 * 1024);
+	if (ret) {
+		test_msg("Error adding half extent %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 3 * 1024 * 1024, 1 * 1024 * 1024);
+	if (ret) {
+		test_msg("Error removing tail end %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 0, 1 * 1024 * 1024);
+	if (ret) {
+		test_msg("Error removing front end %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 2 * 1024 * 1024, 4096);
+	if (ret) {
+		test_msg("Error removing middle peice %d\n", ret);
+		return ret;
+	}
+
+	if (test_check_exists(cache, 0, 1 * 1024 * 1024)) {
+		test_msg("Still have space at the front\n");
+		return -1;
+	}
+
+	if (test_check_exists(cache, 2 * 1024 * 1024, 4096)) {
+		test_msg("Still have space in the middle\n");
+		return -1;
+	}
+
+	if (test_check_exists(cache, 3 * 1024 * 1024, 1 * 1024 * 1024)) {
+		test_msg("Still have space at the end\n");
+		return -1;
+	}
+
+	/* Cleanup */
+	__btrfs_remove_free_space_cache(cache->free_space_ctl);
+
+	return 0;
+}
+
+static int test_bitmaps(struct btrfs_block_group_cache *cache)
+{
+	u64 next_bitmap_offset;
+	int ret;
+
+	test_msg("Running bitmap only tests\n");
+
+	ret = test_add_free_space_entry(cache, 0, 4 * 1024 * 1024, 1);
+	if (ret) {
+		test_msg("Couldn't create a bitmap entry %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 0, 4 * 1024 * 1024);
+	if (ret) {
+		test_msg("Error removing bitmap full range %d\n", ret);
+		return ret;
+	}
+
+	if (test_check_exists(cache, 0, 4 * 1024 * 1024)) {
+		test_msg("Left some space in bitmap\n");
+		return -1;
+	}
+
+	ret = test_add_free_space_entry(cache, 0, 4 * 1024 * 1024, 1);
+	if (ret) {
+		test_msg("Couldn't add to our bitmap entry %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 1 * 1024 * 1024, 2 * 1024 * 1024);
+	if (ret) {
+		test_msg("Couldn't remove middle chunk %d\n", ret);
+		return ret;
+	}
+
+	/*
+	 * The first bitmap we have starts at offset 0 so the next one is just
+	 * at the end of the first bitmap.
+	 */
+	next_bitmap_offset = (u64)(BITS_PER_BITMAP * 4096);
+
+	/* Test a bit straddling two bitmaps */
+	ret = test_add_free_space_entry(cache, next_bitmap_offset -
+				   (2 * 1024 * 1024), 4 * 1024 * 1024, 1);
+	if (ret) {
+		test_msg("Couldn't add space that straddles two bitmaps %d\n",
+				ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, next_bitmap_offset -
+				      (1 * 1024 * 1024), 2 * 1024 * 1024);
+	if (ret) {
+		test_msg("Couldn't remove overlapping space %d\n", ret);
+		return ret;
+	}
+
+	if (test_check_exists(cache, next_bitmap_offset - (1 * 1024 * 1024),
+			 2 * 1024 * 1024)) {
+		test_msg("Left some space when removing overlapping\n");
+		return -1;
+	}
+
+	__btrfs_remove_free_space_cache(cache->free_space_ctl);
+
+	return 0;
+}
+
+/* This is the high grade jackassery */
+static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache)
+{
+	u64 bitmap_offset = (u64)(BITS_PER_BITMAP * 4096);
+	int ret;
+
+	test_msg("Running bitmap and extent tests\n");
+
+	/*
+	 * First let's do something simple, an extent at the same offset as the
+	 * bitmap, but the free space completely in the extent and then
+	 * completely in the bitmap.
+	 */
+	ret = test_add_free_space_entry(cache, 4 * 1024 * 1024, 1 * 1024 * 1024, 1);
+	if (ret) {
+		test_msg("Couldn't create bitmap entry %d\n", ret);
+		return ret;
+	}
+
+	ret = test_add_free_space_entry(cache, 0, 1 * 1024 * 1024, 0);
+	if (ret) {
+		test_msg("Couldn't add extent entry %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 0, 1 * 1024 * 1024);
+	if (ret) {
+		test_msg("Couldn't remove extent entry %d\n", ret);
+		return ret;
+	}
+
+	if (test_check_exists(cache, 0, 1 * 1024 * 1024)) {
+		test_msg("Left remnants after our remove\n");
+		return -1;
+	}
+
+	/* Now to add back the extent entry and remove from the bitmap */
+	ret = test_add_free_space_entry(cache, 0, 1 * 1024 * 1024, 0);
+	if (ret) {
+		test_msg("Couldn't re-add extent entry %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 4 * 1024 * 1024, 1 * 1024 * 1024);
+	if (ret) {
+		test_msg("Couldn't remove from bitmap %d\n", ret);
+		return ret;
+	}
+
+	if (test_check_exists(cache, 4 * 1024 * 1024, 1 * 1024 * 1024)) {
+		test_msg("Left remnants in the bitmap\n");
+		return -1;
+	}
+
+	/*
+	 * Ok so a little more evil, extent entry and bitmap at the same offset,
+	 * removing an overlapping chunk.
+	 */
+	ret = test_add_free_space_entry(cache, 1 * 1024 * 1024, 4 * 1024 * 1024, 1);
+	if (ret) {
+		test_msg("Couldn't add to a bitmap %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 512 * 1024, 3 * 1024 * 1024);
+	if (ret) {
+		test_msg("Couldn't remove overlapping space %d\n", ret);
+		return ret;
+	}
+
+	if (test_check_exists(cache, 512 * 1024, 3 * 1024 * 1024)) {
+		test_msg("Left over peices after removing overlapping\n");
+		return -1;
+	}
+
+	__btrfs_remove_free_space_cache(cache->free_space_ctl);
+
+	/* Now with the extent entry offset into the bitmap */
+	ret = test_add_free_space_entry(cache, 4 * 1024 * 1024, 4 * 1024 * 1024, 1);
+	if (ret) {
+		test_msg("Couldn't add space to the bitmap %d\n", ret);
+		return ret;
+	}
+
+	ret = test_add_free_space_entry(cache, 2 * 1024 * 1024, 2 * 1024 * 1024, 0);
+	if (ret) {
+		test_msg("Couldn't add extent to the cache %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 3 * 1024 * 1024, 4 * 1024 * 1024);
+	if (ret) {
+		test_msg("Problem removing overlapping space %d\n", ret);
+		return ret;
+	}
+
+	if (test_check_exists(cache, 3 * 1024 * 1024, 4 * 1024 * 1024)) {
+		test_msg("Left something behind when removing space");
+		return -1;
+	}
+
+	/*
+	 * This has blown up in the past, the extent entry starts before the
+	 * bitmap entry, but we're trying to remove an offset that falls
+	 * completely within the bitmap range and is in both the extent entry
+	 * and the bitmap entry, looks like this
+	 *
+	 *   [ extent ]
+	 *      [ bitmap ]
+	 *        [ del ]
+	 */
+	__btrfs_remove_free_space_cache(cache->free_space_ctl);
+	ret = test_add_free_space_entry(cache, bitmap_offset + 4 * 1024 * 1024,
+				   4 * 1024 * 1024, 1);
+	if (ret) {
+		test_msg("Couldn't add bitmap %d\n", ret);
+		return ret;
+	}
+
+	ret = test_add_free_space_entry(cache, bitmap_offset - 1 * 1024 * 1024,
+				   5 * 1024 * 1024, 0);
+	if (ret) {
+		test_msg("Couldn't add extent entry %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, bitmap_offset + 1 * 1024 * 1024,
+				      5 * 1024 * 1024);
+	if (ret) {
+		test_msg("Failed to free our space %d\n", ret);
+		return ret;
+	}
+
+	if (test_check_exists(cache, bitmap_offset + 1 * 1024 * 1024,
+			 5 * 1024 * 1024)) {
+		test_msg("Left stuff over\n");
+		return -1;
+	}
+
+	__btrfs_remove_free_space_cache(cache->free_space_ctl);
+
+	/*
+	 * This blew up before, we have part of the free space in a bitmap and
+	 * then the entirety of the rest of the space in an extent.  This used
+	 * to return -EAGAIN back from btrfs_remove_extent, make sure this
+	 * doesn't happen.
+	 */
+	ret = test_add_free_space_entry(cache, 1 * 1024 * 1024, 2 * 1024 * 1024, 1);
+	if (ret) {
+		test_msg("Couldn't add bitmap entry %d\n", ret);
+		return ret;
+	}
+
+	ret = test_add_free_space_entry(cache, 3 * 1024 * 1024, 1 * 1024 * 1024, 0);
+	if (ret) {
+		test_msg("Couldn't add extent entry %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 1 * 1024 * 1024, 3 * 1024 * 1024);
+	if (ret) {
+		test_msg("Error removing bitmap and extent overlapping %d\n", ret);
+		return ret;
+	}
+
+	__btrfs_remove_free_space_cache(cache->free_space_ctl);
+	return 0;
+}
+
+int btrfs_test_free_space_cache(void)
+{
+	struct btrfs_block_group_cache *cache;
+	int ret;
+
+	test_msg("Running btrfs free space cache tests\n");
+
+	cache = init_test_block_group();
+	if (!cache) {
+		test_msg("Couldn't run the tests\n");
+		return 0;
+	}
+
+	ret = test_extents(cache);
+	if (ret)
+		goto out;
+	ret = test_bitmaps(cache);
+	if (ret)
+		goto out;
+	ret = test_bitmaps_and_extents(cache);
+	if (ret)
+		goto out;
+out:
+	__btrfs_remove_free_space_cache(cache->free_space_ctl);
+	kfree(cache->free_space_ctl);
+	kfree(cache);
+	test_msg("Free space cache tests finished\n");
+	return ret;
+}
-- 
1.7.7.6

