Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbcA0OCN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 09:02:13 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 487B1AC2E
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 14:02:11 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: tests: switch to GFP_KERNEL
Date: Wed, 27 Jan 2016 15:02:02 +0100
Message-Id: <8cce83ba5062a301a09e0920df813bbbdd3e9dbf.1453902967.git.dsterba@suse.com>
In-Reply-To: <cover.1453902967.git.dsterba@suse.com>
References: <cover.1453902967.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's no reason to do GFP_NOFS in tests, it's not data-heavy and
memory allocation failures would affect only developers or testers.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/btrfs-tests.c     | 10 +++++-----
 fs/btrfs/tests/extent-io-tests.c | 12 ++++++------
 fs/btrfs/tests/inode-tests.c     |  8 ++++----
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index b1d920b30070..0e1e61a7ec23 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -82,18 +82,18 @@ void btrfs_destroy_test_fs(void)
 struct btrfs_fs_info *btrfs_alloc_dummy_fs_info(void)
 {
 	struct btrfs_fs_info *fs_info = kzalloc(sizeof(struct btrfs_fs_info),
-						GFP_NOFS);
+						GFP_KERNEL);
 
 	if (!fs_info)
 		return fs_info;
 	fs_info->fs_devices = kzalloc(sizeof(struct btrfs_fs_devices),
-				      GFP_NOFS);
+				      GFP_KERNEL);
 	if (!fs_info->fs_devices) {
 		kfree(fs_info);
 		return NULL;
 	}
 	fs_info->super_copy = kzalloc(sizeof(struct btrfs_super_block),
-				      GFP_NOFS);
+				      GFP_KERNEL);
 	if (!fs_info->super_copy) {
 		kfree(fs_info->fs_devices);
 		kfree(fs_info);
@@ -180,11 +180,11 @@ btrfs_alloc_dummy_block_group(unsigned long length)
 {
 	struct btrfs_block_group_cache *cache;
 
-	cache = kzalloc(sizeof(*cache), GFP_NOFS);
+	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
 	if (!cache)
 		return NULL;
 	cache->free_space_ctl = kzalloc(sizeof(*cache->free_space_ctl),
-					GFP_NOFS);
+					GFP_KERNEL);
 	if (!cache->free_space_ctl) {
 		kfree(cache);
 		return NULL;
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index e29fa297e053..669b58201e36 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -94,7 +94,7 @@ static int test_find_delalloc(void)
 	 * test.
 	 */
 	for (index = 0; index < (total_dirty >> PAGE_CACHE_SHIFT); index++) {
-		page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
+		page = find_or_create_page(inode->i_mapping, index, GFP_KERNEL);
 		if (!page) {
 			test_msg("Failed to allocate test page\n");
 			ret = -ENOMEM;
@@ -113,7 +113,7 @@ static int test_find_delalloc(void)
 	 * |--- delalloc ---|
 	 * |---  search  ---|
 	 */
-	set_extent_delalloc(&tmp, 0, 4095, NULL, GFP_NOFS);
+	set_extent_delalloc(&tmp, 0, 4095, NULL, GFP_KERNEL);
 	start = 0;
 	end = 0;
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
@@ -144,7 +144,7 @@ static int test_find_delalloc(void)
 		test_msg("Couldn't find the locked page\n");
 		goto out_bits;
 	}
-	set_extent_delalloc(&tmp, 4096, max_bytes - 1, NULL, GFP_NOFS);
+	set_extent_delalloc(&tmp, 4096, max_bytes - 1, NULL, GFP_KERNEL);
 	start = test_start;
 	end = 0;
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
@@ -199,7 +199,7 @@ static int test_find_delalloc(void)
 	 *
 	 * We are re-using our test_start from above since it works out well.
 	 */
-	set_extent_delalloc(&tmp, max_bytes, total_dirty - 1, NULL, GFP_NOFS);
+	set_extent_delalloc(&tmp, max_bytes, total_dirty - 1, NULL, GFP_KERNEL);
 	start = test_start;
 	end = 0;
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
@@ -262,7 +262,7 @@ static int test_find_delalloc(void)
 	}
 	ret = 0;
 out_bits:
-	clear_extent_bits(&tmp, 0, total_dirty - 1, (unsigned)-1, GFP_NOFS);
+	clear_extent_bits(&tmp, 0, total_dirty - 1, (unsigned)-1, GFP_KERNEL);
 out:
 	if (locked_page)
 		page_cache_release(locked_page);
@@ -360,7 +360,7 @@ static int test_eb_bitmaps(void)
 
 	test_msg("Running extent buffer bitmap tests\n");
 
-	bitmap = kmalloc(len, GFP_NOFS);
+	bitmap = kmalloc(len, GFP_KERNEL);
 	if (!bitmap) {
 		test_msg("Couldn't allocate test bitmap\n");
 		return -ENOMEM;
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 5de55fdd28bc..e2d3da02deee 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -974,7 +974,7 @@ static int test_extent_accounting(void)
 			       (BTRFS_MAX_EXTENT_SIZE >> 1) + 4095,
 			       EXTENT_DELALLOC | EXTENT_DIRTY |
 			       EXTENT_UPTODATE | EXTENT_DO_ACCOUNTING, 0, 0,
-			       NULL, GFP_NOFS);
+			       NULL, GFP_KERNEL);
 	if (ret) {
 		test_msg("clear_extent_bit returned %d\n", ret);
 		goto out;
@@ -1045,7 +1045,7 @@ static int test_extent_accounting(void)
 			       BTRFS_MAX_EXTENT_SIZE+8191,
 			       EXTENT_DIRTY | EXTENT_DELALLOC |
 			       EXTENT_DO_ACCOUNTING | EXTENT_UPTODATE, 0, 0,
-			       NULL, GFP_NOFS);
+			       NULL, GFP_KERNEL);
 	if (ret) {
 		test_msg("clear_extent_bit returned %d\n", ret);
 		goto out;
@@ -1079,7 +1079,7 @@ static int test_extent_accounting(void)
 	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, (u64)-1,
 			       EXTENT_DIRTY | EXTENT_DELALLOC |
 			       EXTENT_DO_ACCOUNTING | EXTENT_UPTODATE, 0, 0,
-			       NULL, GFP_NOFS);
+			       NULL, GFP_KERNEL);
 	if (ret) {
 		test_msg("clear_extent_bit returned %d\n", ret);
 		goto out;
@@ -1096,7 +1096,7 @@ static int test_extent_accounting(void)
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, (u64)-1,
 				 EXTENT_DIRTY | EXTENT_DELALLOC |
 				 EXTENT_DO_ACCOUNTING | EXTENT_UPTODATE, 0, 0,
-				 NULL, GFP_NOFS);
+				 NULL, GFP_KERNEL);
 	iput(inode);
 	btrfs_free_dummy_root(root);
 	return ret;
-- 
2.6.3

