Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:45373 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310Ab2F1NHr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jun 2012 09:07:47 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id pkqOX4kQyYiLFAwp (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2012 07:07:46 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix tree log remove space corner case
Date: Thu, 28 Jun 2012 09:12:28 -0400
Message-ID: <1340889148-10165-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The tree log stuff can have allocated space that we end up having split
across a bitmap and a real extent.  The free space code does not deal with
this, it assumes that if it finds an extent or bitmap entry that the entire
range must fall within the entry it finds.  This isn't necessarily the case,
so rework the remove function so it can handle this case properly.  This
fixed two panics the user hit, first in the case where the space was
initially in a bitmap and then in an extent entry, and then the reverse
case.  Thanks,

Reported-and-tested-by: Shaun Reich <sreich@kde.org>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/free-space-cache.c |  145 +++++++++++++++---------------------------
 1 files changed, 52 insertions(+), 93 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 81296c5..6c4e2ba 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1543,29 +1543,26 @@ again:
 	end = bitmap_info->offset + (u64)(BITS_PER_BITMAP * ctl->unit) - 1;
 
 	/*
-	 * XXX - this can go away after a few releases.
-	 *
-	 * since the only user of btrfs_remove_free_space is the tree logging
-	 * stuff, and the only way to test that is under crash conditions, we
-	 * want to have this debug stuff here just in case somethings not
-	 * working.  Search the bitmap for the space we are trying to use to
-	 * make sure its actually there.  If its not there then we need to stop
-	 * because something has gone wrong.
+	 * We need to search for bits in this bitmap.  We could only cover some
+	 * of the extent in this bitmap thanks to how we add space, so we need
+	 * to search for as much as it as we can and clear that amount, and then
+	 * go searching for the next bit.
 	 */
 	search_start = *offset;
-	search_bytes = *bytes;
+	search_bytes = ctl->unit;
 	search_bytes = min(search_bytes, end - search_start + 1);
 	ret = search_bitmap(ctl, bitmap_info, &search_start, &search_bytes);
 	BUG_ON(ret < 0 || search_start != *offset);
 
-	if (*offset > bitmap_info->offset && *offset + *bytes > end) {
-		bitmap_clear_bits(ctl, bitmap_info, *offset, end - *offset + 1);
-		*bytes -= end - *offset + 1;
-		*offset = end + 1;
-	} else if (*offset >= bitmap_info->offset && *offset + *bytes <= end) {
-		bitmap_clear_bits(ctl, bitmap_info, *offset, *bytes);
-		*bytes = 0;
-	}
+	/* We may have found more bits than what we need */
+	search_bytes = min(search_bytes, *bytes);
+
+	/* Cannot clear past the end of the bitmap */
+	search_bytes = min(search_bytes, end - search_start + 1);
+
+	bitmap_clear_bits(ctl, bitmap_info, search_start, search_bytes);
+	*offset += search_bytes;
+	*bytes -= search_bytes;
 
 	if (*bytes) {
 		struct rb_node *next = rb_next(&bitmap_info->offset_index);
@@ -1596,7 +1593,7 @@ again:
 		 * everything over again.
 		 */
 		search_start = *offset;
-		search_bytes = *bytes;
+		search_bytes = ctl->unit;
 		ret = search_bitmap(ctl, bitmap_info, &search_start,
 				    &search_bytes);
 		if (ret < 0 || search_start != *offset)
@@ -1879,12 +1876,14 @@ int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *info;
-	struct btrfs_free_space *next_info = NULL;
 	int ret = 0;
 
 	spin_lock(&ctl->tree_lock);
 
 again:
+	if (!bytes)
+		goto out_lock;
+
 	info = tree_search_offset(ctl, offset, 0, 0);
 	if (!info) {
 		/*
@@ -1905,88 +1904,48 @@ again:
 		}
 	}
 
-	if (info->bytes < bytes && rb_next(&info->offset_index)) {
-		u64 end;
-		next_info = rb_entry(rb_next(&info->offset_index),
-					     struct btrfs_free_space,
-					     offset_index);
-
-		if (next_info->bitmap)
-			end = next_info->offset +
-			      BITS_PER_BITMAP * ctl->unit - 1;
-		else
-			end = next_info->offset + next_info->bytes;
-
-		if (next_info->bytes < bytes ||
-		    next_info->offset > offset || offset > end) {
-			printk(KERN_CRIT "Found free space at %llu, size %llu,"
-			      " trying to use %llu\n",
-			      (unsigned long long)info->offset,
-			      (unsigned long long)info->bytes,
-			      (unsigned long long)bytes);
-			WARN_ON(1);
-			ret = -EINVAL;
-			goto out_lock;
-		}
-
-		info = next_info;
-	}
-
-	if (info->bytes == bytes) {
+	if (!info->bitmap) {
 		unlink_free_space(ctl, info);
-		if (info->bitmap) {
-			kfree(info->bitmap);
-			ctl->total_bitmaps--;
-		}
-		kmem_cache_free(btrfs_free_space_cachep, info);
-		ret = 0;
-		goto out_lock;
-	}
-
-	if (!info->bitmap && info->offset == offset) {
-		unlink_free_space(ctl, info);
-		info->offset += bytes;
-		info->bytes -= bytes;
-		ret = link_free_space(ctl, info);
-		WARN_ON(ret);
-		goto out_lock;
-	}
+		if (offset == info->offset) {
+			u64 to_free = min(bytes, info->bytes);
+
+			info->bytes -= to_free;
+			info->offset += to_free;
+			if (info->bytes) {
+				ret = link_free_space(ctl, info);
+				WARN_ON(ret);
+			} else {
+				kmem_cache_free(btrfs_free_space_cachep, info);
+			}
 
-	if (!info->bitmap && info->offset <= offset &&
-	    info->offset + info->bytes >= offset + bytes) {
-		u64 old_start = info->offset;
-		/*
-		 * we're freeing space in the middle of the info,
-		 * this can happen during tree log replay
-		 *
-		 * first unlink the old info and then
-		 * insert it again after the hole we're creating
-		 */
-		unlink_free_space(ctl, info);
-		if (offset + bytes < info->offset + info->bytes) {
-			u64 old_end = info->offset + info->bytes;
+			offset += to_free;
+			bytes -= to_free;
+			goto again;
+		} else {
+			u64 old_end = info->bytes + info->offset;
 
-			info->offset = offset + bytes;
-			info->bytes = old_end - info->offset;
+			info->bytes = offset - info->offset;
 			ret = link_free_space(ctl, info);
 			WARN_ON(ret);
 			if (ret)
 				goto out_lock;
-		} else {
-			/* the hole we're creating ends at the end
-			 * of the info struct, just free the info
-			 */
-			kmem_cache_free(btrfs_free_space_cachep, info);
-		}
-		spin_unlock(&ctl->tree_lock);
 
-		/* step two, insert a new info struct to cover
-		 * anything before the hole
-		 */
-		ret = btrfs_add_free_space(block_group, old_start,
-					   offset - old_start);
-		WARN_ON(ret); /* -ENOMEM */
-		goto out;
+			/* Not enough bytes in this entry to satisfy us */
+			if (old_end < offset + bytes) {
+				bytes -= old_end - offset;
+				offset = old_end;
+				goto again;
+			} else if (old_end == offset + bytes) {
+				/* all done */
+				goto out_lock;
+			}
+			spin_unlock(&ctl->tree_lock);
+
+			ret = btrfs_add_free_space(block_group, offset + bytes,
+						   old_end - (offset + bytes));
+			WARN_ON(ret);
+			goto out;
+		}
 	}
 
 	ret = remove_from_bitmap(ctl, info, &offset, &bytes);
-- 
1.7.7.6

