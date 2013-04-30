Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761195Ab3D3QwQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 12:52:16 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 720D8A535C
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 18:52:15 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/3] btrfs: add prefix to sanity tests messages
Date: Tue, 30 Apr 2013 18:51:57 +0200
Message-Id: <3a6cf8f1935c365ae4038bae96b5c8a92441f554.1367339998.git.dsterba@suse.cz>
In-Reply-To: <cover.1367339998.git.dsterba@suse.cz>
References: <cover.1367339998.git.dsterba@suse.cz>
In-Reply-To: <cover.1367339998.git.dsterba@suse.cz>
References: <cover.1367339998.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And change the message level to KERN_INFO.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/free-space-cache.c |   97 ++++++++++++++++++++++---------------------
 1 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ecca6c7..3808303 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3153,6 +3153,8 @@ again:
 	return 0;
 }
 
+#define test_msg(fmt, ...) printk(KERN_INFO "btrfs: selftest: " fmt, ##__VA_ARGS__)
+
 /*
  * This test just does basic sanity checking, making sure we can add an exten
  * entry and remove space from either end and the middle, and make sure we can
@@ -3162,63 +3164,63 @@ static int test_extents(struct btrfs_block_group_cache *cache)
 {
 	int ret = 0;
 
-	printk(KERN_ERR "Running extent only tests\n");
+	test_msg("Running extent only tests\n");
 
 	/* First just make sure we can remove an entire entry */
 	ret = btrfs_add_free_space(cache, 0, 4 * 1024 * 1024);
 	if (ret) {
-		printk(KERN_ERR "Error adding initial extents %d\n", ret);
+		test_msg("Error adding initial extents %d\n", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 0, 4 * 1024 * 1024);
 	if (ret) {
-		printk(KERN_ERR "Error removing extent %d\n", ret);
+		test_msg("Error removing extent %d\n", ret);
 		return ret;
 	}
 
 	if (check_exists(cache, 0, 4 * 1024 * 1024)) {
-		printk(KERN_ERR "Full remove left some lingering space\n");
+		test_msg("Full remove left some lingering space\n");
 		return -1;
 	}
 
 	/* Ok edge and middle cases now */
 	ret = btrfs_add_free_space(cache, 0, 4 * 1024 * 1024);
 	if (ret) {
-		printk(KERN_ERR "Error adding half extent %d\n", ret);
+		test_msg("Error adding half extent %d\n", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 3 * 1024 * 1024, 1 * 1024 * 1024);
 	if (ret) {
-		printk(KERN_ERR "Error removing tail end %d\n", ret);
+		test_msg("Error removing tail end %d\n", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 0, 1 * 1024 * 1024);
 	if (ret) {
-		printk(KERN_ERR "Error removing front end %d\n", ret);
+		test_msg("Error removing front end %d\n", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 2 * 1024 * 1024, 4096);
 	if (ret) {
-		printk(KERN_ERR "Error removing middle peice %d\n", ret);
+		test_msg("Error removing middle peice %d\n", ret);
 		return ret;
 	}
 
 	if (check_exists(cache, 0, 1 * 1024 * 1024)) {
-		printk(KERN_ERR "Still have space at the front\n");
+		test_msg("Still have space at the front\n");
 		return -1;
 	}
 
 	if (check_exists(cache, 2 * 1024 * 1024, 4096)) {
-		printk(KERN_ERR "Still have space in the middle\n");
+		test_msg("Still have space in the middle\n");
 		return -1;
 	}
 
 	if (check_exists(cache, 3 * 1024 * 1024, 1 * 1024 * 1024)) {
-		printk(KERN_ERR "Still have space at the end\n");
+		test_msg("Still have space at the end\n");
 		return -1;
 	}
 
@@ -3233,34 +3235,34 @@ static int test_bitmaps(struct btrfs_block_group_cache *cache)
 	u64 next_bitmap_offset;
 	int ret;
 
-	printk(KERN_ERR "Running bitmap only tests\n");
+	test_msg("Running bitmap only tests\n");
 
 	ret = add_free_space_entry(cache, 0, 4 * 1024 * 1024, 1);
 	if (ret) {
-		printk(KERN_ERR "Couldn't create a bitmap entry %d\n", ret);
+		test_msg("Couldn't create a bitmap entry %d\n", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 0, 4 * 1024 * 1024);
 	if (ret) {
-		printk(KERN_ERR "Error removing bitmap full range %d\n", ret);
+		test_msg("Error removing bitmap full range %d\n", ret);
 		return ret;
 	}
 
 	if (check_exists(cache, 0, 4 * 1024 * 1024)) {
-		printk(KERN_ERR "Left some space in bitmap\n");
+		test_msg("Left some space in bitmap\n");
 		return -1;
 	}
 
 	ret = add_free_space_entry(cache, 0, 4 * 1024 * 1024, 1);
 	if (ret) {
-		printk(KERN_ERR "Couldn't add to our bitmap entry %d\n", ret);
+		test_msg("Couldn't add to our bitmap entry %d\n", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 1 * 1024 * 1024, 2 * 1024 * 1024);
 	if (ret) {
-		printk(KERN_ERR "Couldn't remove middle chunk %d\n", ret);
+		test_msg("Couldn't remove middle chunk %d\n", ret);
 		return ret;
 	}
 
@@ -3274,21 +3276,21 @@ static int test_bitmaps(struct btrfs_block_group_cache *cache)
 	ret = add_free_space_entry(cache, next_bitmap_offset -
 				   (2 * 1024 * 1024), 4 * 1024 * 1024, 1);
 	if (ret) {
-		printk(KERN_ERR "Couldn't add space that straddles two bitmaps"
-		       " %d\n", ret);
+		test_msg("Couldn't add space that straddles two bitmaps %d\n",
+				ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, next_bitmap_offset -
 				      (1 * 1024 * 1024), 2 * 1024 * 1024);
 	if (ret) {
-		printk(KERN_ERR "Couldn't remove overlapping space %d\n", ret);
+		test_msg("Couldn't remove overlapping space %d\n", ret);
 		return ret;
 	}
 
 	if (check_exists(cache, next_bitmap_offset - (1 * 1024 * 1024),
 			 2 * 1024 * 1024)) {
-		printk(KERN_ERR "Left some space when removing overlapping\n");
+		test_msg("Left some space when removing overlapping\n");
 		return -1;
 	}
 
@@ -3303,7 +3305,7 @@ static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache)
 	u64 bitmap_offset = (u64)(BITS_PER_BITMAP * 4096);
 	int ret;
 
-	printk(KERN_ERR "Running bitmap and extent tests\n");
+	test_msg("Running bitmap and extent tests\n");
 
 	/*
 	 * First let's do something simple, an extent at the same offset as the
@@ -3312,42 +3314,42 @@ static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache)
 	 */
 	ret = add_free_space_entry(cache, 4 * 1024 * 1024, 1 * 1024 * 1024, 1);
 	if (ret) {
-		printk(KERN_ERR "Couldn't create bitmap entry %d\n", ret);
+		test_msg("Couldn't create bitmap entry %d\n", ret);
 		return ret;
 	}
 
 	ret = add_free_space_entry(cache, 0, 1 * 1024 * 1024, 0);
 	if (ret) {
-		printk(KERN_ERR "Couldn't add extent entry %d\n", ret);
+		test_msg("Couldn't add extent entry %d\n", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 0, 1 * 1024 * 1024);
 	if (ret) {
-		printk(KERN_ERR "Couldn't remove extent entry %d\n", ret);
+		test_msg("Couldn't remove extent entry %d\n", ret);
 		return ret;
 	}
 
 	if (check_exists(cache, 0, 1 * 1024 * 1024)) {
-		printk(KERN_ERR "Left remnants after our remove\n");
+		test_msg("Left remnants after our remove\n");
 		return -1;
 	}
 
 	/* Now to add back the extent entry and remove from the bitmap */
 	ret = add_free_space_entry(cache, 0, 1 * 1024 * 1024, 0);
 	if (ret) {
-		printk(KERN_ERR "Couldn't re-add extent entry %d\n", ret);
+		test_msg("Couldn't re-add extent entry %d\n", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 4 * 1024 * 1024, 1 * 1024 * 1024);
 	if (ret) {
-		printk(KERN_ERR "Couldn't remove from bitmap %d\n", ret);
+		test_msg("Couldn't remove from bitmap %d\n", ret);
 		return ret;
 	}
 
 	if (check_exists(cache, 4 * 1024 * 1024, 1 * 1024 * 1024)) {
-		printk(KERN_ERR "Left remnants in the bitmap\n");
+		test_msg("Left remnants in the bitmap\n");
 		return -1;
 	}
 
@@ -3357,19 +3359,18 @@ static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache)
 	 */
 	ret = add_free_space_entry(cache, 1 * 1024 * 1024, 4 * 1024 * 1024, 1);
 	if (ret) {
-		printk(KERN_ERR "Couldn't add to a bitmap %d\n", ret);
+		test_msg("Couldn't add to a bitmap %d\n", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 512 * 1024, 3 * 1024 * 1024);
 	if (ret) {
-		printk(KERN_ERR "Couldn't remove overlapping space %d\n", ret);
+		test_msg("Couldn't remove overlapping space %d\n", ret);
 		return ret;
 	}
 
 	if (check_exists(cache, 512 * 1024, 3 * 1024 * 1024)) {
-		printk(KERN_ERR "Left over peices after removing "
-		       "overlapping\n");
+		test_msg("Left over peices after removing overlapping\n");
 		return -1;
 	}
 
@@ -3378,24 +3379,24 @@ static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache)
 	/* Now with the extent entry offset into the bitmap */
 	ret = add_free_space_entry(cache, 4 * 1024 * 1024, 4 * 1024 * 1024, 1);
 	if (ret) {
-		printk(KERN_ERR "Couldn't add space to the bitmap %d\n", ret);
+		test_msg("Couldn't add space to the bitmap %d\n", ret);
 		return ret;
 	}
 
 	ret = add_free_space_entry(cache, 2 * 1024 * 1024, 2 * 1024 * 1024, 0);
 	if (ret) {
-		printk(KERN_ERR "Couldn't add extent to the cache %d\n", ret);
+		test_msg("Couldn't add extent to the cache %d\n", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 3 * 1024 * 1024, 4 * 1024 * 1024);
 	if (ret) {
-		printk(KERN_ERR "Problem removing overlapping space %d\n", ret);
+		test_msg("Problem removing overlapping space %d\n", ret);
 		return ret;
 	}
 
 	if (check_exists(cache, 3 * 1024 * 1024, 4 * 1024 * 1024)) {
-		printk(KERN_ERR "Left something behind when removing space");
+		test_msg("Left something behind when removing space");
 		return -1;
 	}
 
@@ -3413,27 +3414,27 @@ static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache)
 	ret = add_free_space_entry(cache, bitmap_offset + 4 * 1024 * 1024,
 				   4 * 1024 * 1024, 1);
 	if (ret) {
-		printk(KERN_ERR "Couldn't add bitmap %d\n", ret);
+		test_msg("Couldn't add bitmap %d\n", ret);
 		return ret;
 	}
 
 	ret = add_free_space_entry(cache, bitmap_offset - 1 * 1024 * 1024,
 				   5 * 1024 * 1024, 0);
 	if (ret) {
-		printk(KERN_ERR "Couldn't add extent entry %d\n", ret);
+		test_msg("Couldn't add extent entry %d\n", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, bitmap_offset + 1 * 1024 * 1024,
 				      5 * 1024 * 1024);
 	if (ret) {
-		printk(KERN_ERR "Failed to free our space %d\n", ret);
+		test_msg("Failed to free our space %d\n", ret);
 		return ret;
 	}
 
 	if (check_exists(cache, bitmap_offset + 1 * 1024 * 1024,
 			 5 * 1024 * 1024)) {
-		printk(KERN_ERR "Left stuff over\n");
+		test_msg("Left stuff over\n");
 		return -1;
 	}
 
@@ -3447,20 +3448,19 @@ static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache)
 	 */
 	ret = add_free_space_entry(cache, 1 * 1024 * 1024, 2 * 1024 * 1024, 1);
 	if (ret) {
-		printk(KERN_ERR "Couldn't add bitmap entry %d\n", ret);
+		test_msg("Couldn't add bitmap entry %d\n", ret);
 		return ret;
 	}
 
 	ret = add_free_space_entry(cache, 3 * 1024 * 1024, 1 * 1024 * 1024, 0);
 	if (ret) {
-		printk(KERN_ERR "Couldn't add extent entry %d\n", ret);
+		test_msg("Couldn't add extent entry %d\n", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 1 * 1024 * 1024, 3 * 1024 * 1024);
 	if (ret) {
-		printk(KERN_ERR "Error removing bitmap and extent "
-		       "overlapping %d\n", ret);
+		test_msg("Error removing bitmap and extent overlapping %d\n", ret);
 		return ret;
 	}
 
@@ -3472,11 +3472,11 @@ void btrfs_test_free_space_cache(void)
 {
 	struct btrfs_block_group_cache *cache;
 
-	printk(KERN_ERR "Running btrfs free space cache tests\n");
+	test_msg("Running btrfs free space cache tests\n");
 
 	cache = init_test_block_group();
 	if (!cache) {
-		printk(KERN_ERR "Couldn't run the tests\n");
+		test_msg("Couldn't run the tests\n");
 		return;
 	}
 
@@ -3490,6 +3490,7 @@ out:
 	__btrfs_remove_free_space_cache(cache->free_space_ctl);
 	kfree(cache->free_space_ctl);
 	kfree(cache);
-	printk(KERN_ERR "Free space cache tests finished\n");
+	test_msg("Free space cache tests finished\n");
 }
+#undef test_msg
 #endif /* CONFIG_BTRFS_FS_RUN_SANITY_TESTS */
-- 
1.7.9


