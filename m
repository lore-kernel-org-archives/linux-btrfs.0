From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: make sure we find a bitmap entry v2
Date: Fri, 31 Jul 2009 10:31:31 -0400
Message-ID: <20090731143130.GB15150@localhost.localdomain>
References: <20090731134218.GA14255@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, zheng.yan@oracle.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090731134218.GA14255@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Yan Zheng hit a problem where we tried to remove some free space but failed
because we couldn't find the free space entry.  This is because the free space
was held within a bitmap that had a starting offset well before the actual
offset of the free space, and there were free space extents that were in the
same range as that offset, so tree_search_offset returned with NULL because we
couldn't find a free space extent that had that offset.  This is fixed by making
sure that if we fail to find the entry, we re-search again with bitmap_only set
to 1 and do an offset_to_bitmap so we can get the appropriate bitmap.  A similar
problem happens in btrfs_alloc_from_bitmap for the clustering code, but that is
not as bad since we will just go and redo our cluster allocation.

Also this adds some debugging stuff to make sure that the free space we are
trying to remove from the bitmap is in fact there.  This can probably go away
after a while, but since this code is only used by the tree-logging stuff it
would be nice to run with it for a while to make sure there are no problems.

Version 2 actually has comments :).  Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/free-space-cache.c |   73 +++++++++++++++++++++++++++++++++++++-----
 1 files changed, 64 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index af99b78..5edcee3 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -414,11 +414,29 @@ static noinline int remove_from_bitmap(struct btrfs_block_group_cache *block_gro
 			      u64 *offset, u64 *bytes)
 {
 	u64 end;
+	u64 search_start, search_bytes;
+	int ret;
 
 again:
 	end = bitmap_info->offset +
 		(u64)(BITS_PER_BITMAP * block_group->sectorsize) - 1;
 
+	/*
+	 * XXX - this can go away after a few releases.
+	 *
+	 * since the only user of btrfs_remove_free_space is the tree logging
+	 * stuff, and the only way to test that is under crash conditions, we
+	 * want to have this debug stuff here just in case somethings not
+	 * working.  Search the bitmap for the space we are trying to use to
+	 * make sure its actually there.  If its not there then we need to stop
+	 * because something has gone wrong.
+	 */
+	search_start = *offset;
+	search_bytes = *bytes;
+	ret = search_bitmap(block_group, bitmap_info, &search_start,
+			    &search_bytes);
+	BUG_ON(ret < 0 || search_start != *offset);
+
 	if (*offset > bitmap_info->offset && *offset + *bytes > end) {
 		bitmap_clear_bits(block_group, bitmap_info, *offset,
 				  end - *offset + 1);
@@ -430,6 +448,7 @@ again:
 	}
 
 	if (*bytes) {
+		struct rb_node *next = rb_next(&bitmap_info->offset_index);
 		if (!bitmap_info->bytes) {
 			unlink_free_space(block_group, bitmap_info);
 			kfree(bitmap_info->bitmap);
@@ -438,16 +457,36 @@ again:
 			recalculate_thresholds(block_group);
 		}
 
-		bitmap_info = tree_search_offset(block_group,
-						 offset_to_bitmap(block_group,
-								  *offset),
-						 1, 0);
-		if (!bitmap_info)
+		/*
+		 * no entry after this bitmap, but we still have bytes to
+		 * remove, so something has gone wrong.
+		 */
+		if (!next)
 			return -EINVAL;
 
+		bitmap_info = rb_entry(next, struct btrfs_free_space,
+				       offset_index);
+
+		/*
+		 * if the next entry isn't a bitmap we need to return to let the
+		 * extent stuff do its work.
+		 */
 		if (!bitmap_info->bitmap)
 			return -EAGAIN;
 
+		/*
+		 * Ok the next item is a bitmap, but it may not actually hold
+		 * the information for the rest of this free space stuff, so
+		 * look for it, and if we don't find it return so we can try
+		 * everything over again.
+		 */
+		search_start = *offset;
+		search_bytes = *bytes;
+		ret = search_bitmap(block_group, bitmap_info, &search_start,
+				    &search_bytes);
+		if (ret < 0 || search_start != *offset)
+			return -EAGAIN;
+
 		goto again;
 	} else if (!bitmap_info->bytes) {
 		unlink_free_space(block_group, bitmap_info);
@@ -644,8 +683,17 @@ int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 again:
 	info = tree_search_offset(block_group, offset, 0, 0);
 	if (!info) {
-		WARN_ON(1);
-		goto out_lock;
+		/*
+		 * oops didn't find an extent that matched the space we wanted
+		 * to remove, look for a bitmap instead
+		 */
+		info = tree_search_offset(block_group,
+					  offset_to_bitmap(block_group, offset),
+					  1, 0);
+		if (!info) {
+			WARN_ON(1);
+			goto out_lock;
+		}
 	}
 
 	if (info->bytes < bytes && rb_next(&info->offset_index)) {
@@ -957,8 +1005,15 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
 	if (cluster->block_group != block_group)
 		goto out;
 
-	entry = tree_search_offset(block_group, search_start, 0, 0);
-
+	/*
+	 * search_start is the beginning of the bitmap, but at some point it may
+	 * be a good idea to point to the actual start of the free area in the
+	 * bitmap, so do the offset_to_bitmap trick anyway, and set bitmap_only
+	 * to 1 to make sure we get the bitmap entry
+	 */
+	entry = tree_search_offset(block_group,
+				   offset_to_bitmap(block_group, search_start),
+				   1, 0);
 	if (!entry || !entry->bitmap)
 		goto out;
 
-- 
1.5.4.3

