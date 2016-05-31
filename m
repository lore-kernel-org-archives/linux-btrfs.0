Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62259 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755908AbcEaHwY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 03:52:24 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: convert: Fix a bug that makes convert asserts at scan time
Date: Tue, 31 May 2016 15:51:13 +0800
Message-Id: <20160531075113.24603-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a ext2 fs filled with a 57M file, it's possible that convert fails
with assert in add_merge_cache_extent().

The problem is that the ext2 used space just takes some of the second
superblock.
And due to a bug in reserving superblock space, it corrupted used space
tree and cause assert.

Fix in by doing better used space merging for case where superblock
range is inside the ext2 used space.

Reported-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 74 insertions(+), 7 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index c28dae6..30dd6e8 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1928,6 +1928,57 @@ static int convert_open_fs(const char *devname,
 }
 
 /*
+ * Helper for expend and merge extent_cache for wipe_one_reserved_range()
+ * to handle wipe range is inside an existing cache case.
+ */
+static int _expand_extent_cache(struct cache_tree *tree,
+				struct cache_extent *entry,
+				u64 min_stripe_size, int backward)
+{
+	struct cache_extent *ce;
+	int diff;
+
+	if (entry->size >= min_stripe_size)
+		return 0;
+	diff = min_stripe_size - entry->size;
+
+	if (backward) {
+		ce = prev_cache_extent(entry);
+		if (!ce)
+			goto expand_back;
+		if (ce->start + ce->size >= entry->start - diff) {
+			/* Directly merge with previous extent */
+			ce->size = entry->start + entry->size - ce->start;
+			remove_cache_extent(tree, entry);
+			free(entry);
+			return 0;
+		}
+expand_back:
+		/* No over lap, normal extent */
+		if (entry->start < diff) {
+			error("can't find space for data chunk layout");
+			return -ENOSPC;
+		}
+		entry->start -= diff;
+		entry->size += diff;
+		return 0;
+	}
+	ce = next_cache_extent(entry);
+	if (!ce)
+		goto expand_after;
+	if (entry->start + entry->size + diff >= ce->start) {
+		/* Directly merge with next extent */
+		entry->size = ce->start + ce->size - entry->start;
+		remove_cache_extent(tree, ce);
+		free(ce);
+		return 0;
+	}
+expand_after:
+	entry->size += diff;
+	return 0;
+}
+
+/*
  * Remove one reserve range from given cache tree
  * if min_stripe_size is non-zero, it will ensure for split case,
  * all its split cache extent is no smaller than @min_strip_size / 2.
@@ -1986,21 +2037,37 @@ static int wipe_one_reserved_range(struct cache_tree *tree,
 		 * |-------cache-----|
 		 *	|-wipe-|
 		 */
+		u64 old_start = cache->start;
 		u64 old_len = cache->size;
 		u64 insert_start = start + len;
 		u64 insert_len;
 
 		cache->size = start - cache->start;
-		if (ensure_size)
-			cache->size = max(cache->size, min_stripe_size);
-		cache->start = start - cache->size;
+		/* Expand the leading half part if needed */
+		if (ensure_size && cache->size < min_stripe_size) {
+			ret = _expand_extent_cache(tree, cache,
+					min_stripe_size, 1);
+			if (ret < 0)
+				return ret;
+		}
 
 		/* And insert the new one */
-		insert_len = old_len - start - len;
-		if (ensure_size)
-			insert_len = max(insert_len, min_stripe_size);
-
+		insert_len = old_start + old_len - start - len;
 		ret = add_merge_cache_extent(tree, insert_start, insert_len);
+		if (ret < 0)
+			return ret;
+
+		/* Expand the last half part if needed */
+		if (ensure_size && insert_len < min_stripe_size) {
+			cache = lookup_cache_extent(tree, insert_start,
+						    insert_len);
+			if (!cache || cache->start != insert_start ||
+			    cache->size != insert_len)
+				return -ENOENT;
+			ret = _expand_extent_cache(tree, cache,
+					min_stripe_size, 0);
+		}
+
 		return ret;
 	}
 	/*
-- 
2.8.3



