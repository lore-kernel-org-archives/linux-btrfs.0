Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:50140 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3CONl4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 09:41:56 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 5D9E27C067B
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Mar 2013 07:41:56 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id IIUWgF5PJSpu7dbr (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 15 Mar 2013 07:41:55 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: add some free space cache tests
Date: Fri, 15 Mar 2013 09:49:11 -0400
Message-ID: <1363355351-5364-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We keep hitting bugs in the tree log replay because btrfs_remove_free_space
doesn't account for some corner case.  So add a bunch of tests to try and fully
test btrfs_remove_free_space since the only time it is called is during tree log
replay.  These tests all finish successfully, so as we find more of these bugs
we need to add to these tests to make sure we don't regress in fixing things.
I've hidden the tests behind a Kconfig option, but they take no time to run so
all btrfs developers should have this turned on all the time.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/Kconfig            |   11 +
 fs/btrfs/free-space-cache.c |  519 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/free-space-cache.h |    5 +
 fs/btrfs/super.c            |    5 +
 4 files changed, 540 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 5f583c8..4b3ac45 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -53,3 +53,14 @@ config BTRFS_FS_CHECK_INTEGRITY
 	  In most cases, unless you are a btrfs developer who needs
 	  to verify the integrity of (super)-block write requests
 	  during the run of a regression test, say N
+
+config BTRFS_FS_RUN_SANITY_TESTS
+	bool "Btrfs will run sanity tests upon loading"
+	depends on BTRFS_FS
+	help
+	  This will run some basic sanity tests on the free space cache
+	  code to make sure it is acting as it should.  These are mostly
+	  regression tests and are only really interesting to btrfs devlopers.
+
+	  If unsure, say N.
+
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 1f84fc0..fcde73d 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2967,3 +2967,522 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 	iput(inode);
 	return ret;
 }
+
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
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
+ * Checks to see if the given range is in the free space cache.  This is really
+ * just used to check the absence of space, so if there is free space in the
+ * range at all we will return 1.
+ */
+static int check_exists(struct btrfs_block_group_cache *cache, u64 offset,
+			u64 bytes)
+{
+	struct btrfs_free_space_ctl *ctl = cache->free_space_ctl;
+	struct btrfs_free_space *info;
+	int ret = 0;
+
+	spin_lock(&ctl->tree_lock);
+	info = tree_search_offset(ctl, offset, 0, 0);
+	if (!info) {
+		info = tree_search_offset(ctl, offset_to_bitmap(ctl, offset),
+					  1, 0);
+		if (!info)
+			goto out;
+	}
+
+have_info:
+	if (info->bitmap) {
+		u64 bit_off, bit_bytes;
+		struct rb_node *n;
+		struct btrfs_free_space *tmp;
+
+		bit_off = offset;
+		bit_bytes = ctl->unit;
+		ret = search_bitmap(ctl, info, &bit_off, &bit_bytes);
+		if (!ret) {
+			if (bit_off == offset) {
+				ret = 1;
+				goto out;
+			} else if (bit_off > offset &&
+				   offset + bytes > bit_off) {
+				ret = 1;
+				goto out;
+			}
+		}
+
+		n = rb_prev(&info->offset_index);
+		while (n) {
+			tmp = rb_entry(n, struct btrfs_free_space,
+				       offset_index);
+			if (tmp->offset + tmp->bytes < offset)
+				break;
+			if (offset + bytes < tmp->offset) {
+				n = rb_prev(&info->offset_index);
+				continue;
+			}
+			info = tmp;
+			goto have_info;
+		}
+
+		n = rb_next(&info->offset_index);
+		while (n) {
+			tmp = rb_entry(n, struct btrfs_free_space,
+				       offset_index);
+			if (offset + bytes < tmp->offset)
+				break;
+			if (tmp->offset + tmp->bytes < offset) {
+				n = rb_next(&info->offset_index);
+				continue;
+			}
+			info = tmp;
+			goto have_info;
+		}
+
+		goto out;
+	}
+
+	if (info->offset == offset) {
+		ret = 1;
+		goto out;
+	}
+
+	if (offset > info->offset && offset < info->offset + info->bytes)
+		ret = 1;
+out:
+	spin_unlock(&ctl->tree_lock);
+	return ret;
+}
+
+/*
+ * Use this if you need to make a bitmap or extent entry specifically, it
+ * doesn't do any of the merging that add_free_space does, this acts a lot like
+ * how the free space cache loading stuff works, so you can get really weird
+ * configurations.
+ */
+static int add_free_space_entry(struct btrfs_block_group_cache *cache,
+				u64 offset, u64 bytes, bool bitmap)
+{
+	struct btrfs_free_space_ctl *ctl = cache->free_space_ctl;
+	struct btrfs_free_space *info = NULL, *bitmap_info;
+	void *map = NULL;
+	u64 bytes_added;
+	int ret;
+
+again:
+	if (!info) {
+		info = kmem_cache_zalloc(btrfs_free_space_cachep, GFP_NOFS);
+		if (!info)
+			return -ENOMEM;
+	}
+
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
+
+	bytes_added = add_bytes_to_bitmap(ctl, bitmap_info, offset, bytes);
+	bytes -= bytes_added;
+	offset += bytes_added;
+	spin_unlock(&ctl->tree_lock);
+
+	if (bytes)
+		goto again;
+
+	if (map)
+		kfree(map);
+	return 0;
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
+	printk(KERN_ERR "Running extent only tests\n");
+
+	/* First just make sure we can remove an entire entry */
+	ret = btrfs_add_free_space(cache, 0, 4 * 1024 * 1024);
+	if (ret) {
+		printk(KERN_ERR "Error adding initial extents %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 0, 4 * 1024 * 1024);
+	if (ret) {
+		printk(KERN_ERR "Error removing extent %d\n", ret);
+		return ret;
+	}
+
+	if (check_exists(cache, 0, 4 * 1024 * 1024)) {
+		printk(KERN_ERR "Full remove left some lingering space\n");
+		return -1;
+	}
+
+	/* Ok edge and middle cases now */
+	ret = btrfs_add_free_space(cache, 0, 4 * 1024 * 1024);
+	if (ret) {
+		printk(KERN_ERR "Error adding half extent %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 3 * 1024 * 1024, 1 * 1024 * 1024);
+	if (ret) {
+		printk(KERN_ERR "Error removing tail end %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 0, 1 * 1024 * 1024);
+	if (ret) {
+		printk(KERN_ERR "Error removing front end %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 2 * 1024 * 1024, 4096);
+	if (ret) {
+		printk(KERN_ERR "Error removing middle peice %d\n", ret);
+		return ret;
+	}
+
+	if (check_exists(cache, 0, 1 * 1024 * 1024)) {
+		printk(KERN_ERR "Still have space at the front\n");
+		return -1;
+	}
+
+	if (check_exists(cache, 2 * 1024 * 1024, 4096)) {
+		printk(KERN_ERR "Still have space in the middle\n");
+		return -1;
+	}
+
+	if (check_exists(cache, 3 * 1024 * 1024, 1 * 1024 * 1024)) {
+		printk(KERN_ERR "Still have space at the end\n");
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
+	printk(KERN_ERR "Running bitmap only tests\n");
+
+	ret = add_free_space_entry(cache, 0, 4 * 1024 * 1024, 1);
+	if (ret) {
+		printk(KERN_ERR "Couldn't create a bitmap entry %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 0, 4 * 1024 * 1024);
+	if (ret) {
+		printk(KERN_ERR "Error removing bitmap full range %d\n", ret);
+		return ret;
+	}
+
+	if (check_exists(cache, 0, 4 * 1024 * 1024)) {
+		printk(KERN_ERR "Left some space in bitmap\n");
+		return -1;
+	}
+
+	ret = add_free_space_entry(cache, 0, 4 * 1024 * 1024, 1);
+	if (ret) {
+		printk(KERN_ERR "Couldn't add to our bitmap entry %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 1 * 1024 * 1024, 2 * 1024 * 1024);
+	if (ret) {
+		printk(KERN_ERR "Couldn't remove middle chunk %d\n", ret);
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
+	ret = add_free_space_entry(cache, next_bitmap_offset -
+				   (2 * 1024 * 1024), 4 * 1024 * 1024, 1);
+	if (ret) {
+		printk(KERN_ERR "Couldn't add space that straddles two bitmaps"
+		       " %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, next_bitmap_offset -
+				      (1 * 1024 * 1024), 2 * 1024 * 1024);
+	if (ret) {
+		printk(KERN_ERR "Couldn't remove overlapping space %d\n", ret);
+		return ret;
+	}
+
+	if (check_exists(cache, next_bitmap_offset - (1 * 1024 * 1024),
+			 2 * 1024 * 1024)) {
+		printk(KERN_ERR "Left some space when removing overlapping\n");
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
+	printk(KERN_ERR "Running bitmap and extent tests\n");
+
+	/*
+	 * First let's do something simple, an extent at the same offset as the
+	 * bitmap, but the free space completely in the extent and then
+	 * completely in the bitmap.
+	 */
+	ret = add_free_space_entry(cache, 4 * 1024 * 1024, 1 * 1024 * 1024, 1);
+	if (ret) {
+		printk(KERN_ERR "Couldn't create bitmap entry %d\n", ret);
+		return ret;
+	}
+
+	ret = add_free_space_entry(cache, 0, 1 * 1024 * 1024, 0);
+	if (ret) {
+		printk(KERN_ERR "Couldn't add extent entry %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 0, 1 * 1024 * 1024);
+	if (ret) {
+		printk(KERN_ERR "Couldn't remove extent entry %d\n", ret);
+		return ret;
+	}
+
+	if (check_exists(cache, 0, 1 * 1024 * 1024)) {
+		printk(KERN_ERR "Left remnants after our remove\n");
+		return -1;
+	}
+
+	/* Now to add back the extent entry and remove from the bitmap */
+	ret = add_free_space_entry(cache, 0, 1 * 1024 * 1024, 0);
+	if (ret) {
+		printk(KERN_ERR "Couldn't re-add extent entry %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 4 * 1024 * 1024, 1 * 1024 * 1024);
+	if (ret) {
+		printk(KERN_ERR "Couldn't remove from bitmap %d\n", ret);
+		return ret;
+	}
+
+	if (check_exists(cache, 4 * 1024 * 1024, 1 * 1024 * 1024)) {
+		printk(KERN_ERR "Left remnants in the bitmap\n");
+		return -1;
+	}
+
+	/*
+	 * Ok so a little more evil, extent entry and bitmap at the same offset,
+	 * removing an overlapping chunk.
+	 */
+	ret = add_free_space_entry(cache, 1 * 1024 * 1024, 4 * 1024 * 1024, 1);
+	if (ret) {
+		printk(KERN_ERR "Couldn't add to a bitmap %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 512 * 1024, 3 * 1024 * 1024);
+	if (ret) {
+		printk(KERN_ERR "Couldn't remove overlapping space %d\n", ret);
+		return ret;
+	}
+
+	if (check_exists(cache, 512 * 1024, 3 * 1024 * 1024)) {
+		printk(KERN_ERR "Left over peices after removing "
+		       "overlapping\n");
+		return -1;
+	}
+
+	__btrfs_remove_free_space_cache(cache->free_space_ctl);
+
+	/* Now with the extent entry offset into the bitmap */
+	ret = add_free_space_entry(cache, 4 * 1024 * 1024, 4 * 1024 * 1024, 1);
+	if (ret) {
+		printk(KERN_ERR "Couldn't add space to the bitmap %d\n", ret);
+		return ret;
+	}
+
+	ret = add_free_space_entry(cache, 2 * 1024 * 1024, 2 * 1024 * 1024, 0);
+	if (ret) {
+		printk(KERN_ERR "Couldn't add extent to the cache %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 3 * 1024 * 1024, 4 * 1024 * 1024);
+	if (ret) {
+		printk(KERN_ERR "Problem removing overlapping space %d\n", ret);
+		return ret;
+	}
+
+	if (check_exists(cache, 3 * 1024 * 1024, 4 * 1024 * 1024)) {
+		printk(KERN_ERR "Left something behind when removing space");
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
+	ret = add_free_space_entry(cache, bitmap_offset + 4 * 1024 * 1024,
+				   4 * 1024 * 1024, 1);
+	if (ret) {
+		printk(KERN_ERR "Couldn't add bitmap %d\n", ret);
+		return ret;
+	}
+
+	ret = add_free_space_entry(cache, bitmap_offset - 1 * 1024 * 1024,
+				   5 * 1024 * 1024, 0);
+	if (ret) {
+		printk(KERN_ERR "Couldn't add extent entry %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, bitmap_offset + 1 * 1024 * 1024,
+				      5 * 1024 * 1024);
+	if (ret) {
+		printk(KERN_ERR "Failed to free our space %d\n", ret);
+		return ret;
+	}
+
+	if (check_exists(cache, bitmap_offset + 1 * 1024 * 1024,
+			 5 * 1024 * 1024)) {
+		printk(KERN_ERR "Left stuff over\n");
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
+	ret = add_free_space_entry(cache, 1 * 1024 * 1024, 2 * 1024 * 1024, 1);
+	if (ret) {
+		printk(KERN_ERR "Couldn't add bitmap entry %d\n", ret);
+		return ret;
+	}
+
+	ret = add_free_space_entry(cache, 3 * 1024 * 1024, 1 * 1024 * 1024, 0);
+	if (ret) {
+		printk(KERN_ERR "Couldn't add extent entry %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_remove_free_space(cache, 1 * 1024 * 1024, 3 * 1024 * 1024);
+	if (ret) {
+		printk(KERN_ERR "Error removing bitmap and extent "
+		       "overlapping %d\n", ret);
+		return ret;
+	}
+
+	__btrfs_remove_free_space_cache(cache->free_space_ctl);
+	return 0;
+}
+
+void btrfs_test_free_space_cache()
+{
+	struct btrfs_block_group_cache *cache;
+
+	printk(KERN_ERR "Running btrfs free space cache tests\n");
+
+	cache = init_test_block_group();
+	if (!cache) {
+		printk(KERN_ERR "Couldn't run the tests\n");
+		return;
+	}
+
+	if (test_extents(cache))
+		goto out;
+	if (test_bitmaps(cache))
+		goto out;
+	if (test_bitmaps_and_extents(cache))
+		goto out;
+out:
+	__btrfs_remove_free_space_cache(cache->free_space_ctl);
+	kfree(cache->free_space_ctl);
+	kfree(cache);
+	printk(KERN_ERR "Free space cache tests finished\n");
+}
+#endif /* CONFIG_BTRFS_FS_RUN_SANITY_TESTS */
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 8f2613f..4dc17d8 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -110,4 +110,9 @@ int btrfs_return_cluster_to_free_space(
 			       struct btrfs_free_cluster *cluster);
 int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 			   u64 *trimmed, u64 start, u64 end, u64 minlen);
+
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+void btrfs_test_free_space_cache(void);
+#endif
+
 #endif
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 68a29a1..096316f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -56,6 +56,7 @@
 #include "compression.h"
 #include "rcu-string.h"
 #include "dev-replace.h"
+#include "free-space-cache.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
@@ -1738,6 +1739,10 @@ static int __init init_btrfs_fs(void)
 
 	btrfs_init_lockdep();
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	btrfs_test_free_space_cache();
+#endif
+
 	printk(KERN_INFO "%s loaded\n", BTRFS_BUILD_VERSION);
 	return 0;
 
-- 
1.7.7.6

