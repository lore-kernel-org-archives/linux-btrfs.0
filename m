From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 02/16] Btrfs: fix space leak when skipping small extents during
 trimming
Date: Thu, 14 Jul 2011 11:16:18 +0800
Message-ID: <4E1E5F82.9040506@cn.fujitsu.com>
References: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1E5F59.5030208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

We're taking a free space extent out of the free space cache, trimming
it and then putting it back into the cache.

However for an extent that is smaller than the specified minimum length,
it's taken out but won't be put back, which causes space leak.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index bf0d615..901585d 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2463,6 +2463,7 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 	u64 bytes = 0;
 	u64 actually_trimmed;
 	int ret = 0;
+	int update_ret;
 
 	*trimmed = 0;
 
@@ -2486,6 +2487,7 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 		}
 
 		if (entry->bitmap) {
+			bytes = 0;
 			ret = search_bitmap(ctl, entry, &start, &bytes);
 			if (!ret) {
 				if (start >= end) {
@@ -2493,6 +2495,8 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 					break;
 				}
 				bytes = min(bytes, end - start);
+				if (bytes < minlen)
+					goto next;
 				bitmap_clear_bits(ctl, entry, start, bytes);
 				if (entry->bytes == 0)
 					free_bitmap(ctl, entry);
@@ -2506,33 +2510,29 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 		} else {
 			start = entry->offset;
 			bytes = min(entry->bytes, end - start);
+			if (bytes < minlen)
+				goto next;
 			unlink_free_space(ctl, entry);
 			kmem_cache_free(btrfs_free_space_cachep, entry);
 		}
 
 		spin_unlock(&ctl->tree_lock);
 
-		if (bytes >= minlen) {
-			int update_ret;
-			update_ret = btrfs_update_reserved_bytes(block_group,
-								 bytes, 1, 1);
+		update_ret = btrfs_update_reserved_bytes(block_group,
+							 bytes, 1, 1);
 
-			ret = btrfs_error_discard_extent(fs_info->extent_root,
-							 start,
-							 bytes,
-							 &actually_trimmed);
+		ret = btrfs_error_discard_extent(fs_info->extent_root, start,
+						 bytes, &actually_trimmed);
 
-			btrfs_add_free_space(block_group, start, bytes);
-			if (!update_ret)
-				btrfs_update_reserved_bytes(block_group,
-							    bytes, 0, 1);
+		btrfs_add_free_space(block_group, start, bytes);
+		if (!update_ret)
+			btrfs_update_reserved_bytes(block_group, bytes, 0, 1);
 
-			if (ret)
-				break;
-			*trimmed += actually_trimmed;
-		}
+		if (ret)
+			break;
+		*trimmed += actually_trimmed;
+next:
 		start += bytes;
-		bytes = 0;
 
 		if (fatal_signal_pending(current)) {
 			ret = -ERESTARTSYS;
-- 
1.7.3.1
