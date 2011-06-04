From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH v2 1/9] btrfs progs: fix extra metadata chunk allocation in --mixed case
Date: Sat,  4 Jun 2011 11:19:16 +0300
Message-ID: <1307175564-25355-2-git-send-email-slyfox@gentoo.org>
References: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Arne Jansen <sensille@gmx.net>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

When creating a mixed fs with mkfs, an extra metadata chunk got allocated.
This is because btrfs_reserve_extent calls do_chunk_alloc for METADATA,
which in turn wasn't able to find the proper space_info, as __find_space_info
did a hard compare of the flags. It is now sufficient for the space_info to
include the proper flag. This reflects the change done to the kernel code
to support mixed chunks.
Also for a subsequent chunk allocation (which should not be hit in the mkfs
case), the chunk is now created with the flags from the space_info instead
of the requested flags. A better solution would be to pull the full changeset
for the mixed case from the kernel into the user mode (or, even better, share
the code)

The additional chunk probably confused block_rsv calculation, which in turn
led to severeal ENOSPC Oopses.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 extent-tree.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index b2f9bb2..c6c77c6 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1718,41 +1718,41 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 
 		clear_extent_bits(block_group_cache, start, end,
 				  BLOCK_GROUP_DIRTY, GFP_NOFS);
 
 		cache = (struct btrfs_block_group_cache *)(unsigned long)ptr;
 		ret = write_one_cache_group(trans, root, path, cache);
 		BUG_ON(ret);
 	}
 	btrfs_free_path(path);
 	return 0;
 }
 
 static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 						  u64 flags)
 {
 	struct list_head *head = &info->space_info;
 	struct list_head *cur;
 	struct btrfs_space_info *found;
 	list_for_each(cur, head) {
 		found = list_entry(cur, struct btrfs_space_info, list);
-		if (found->flags == flags)
+		if (found->flags & flags)
 			return found;
 	}
 	return NULL;
 
 }
 
 static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 			     u64 total_bytes, u64 bytes_used,
 			     struct btrfs_space_info **space_info)
 {
 	struct btrfs_space_info *found;
 
 	found = __find_space_info(info, flags);
 	if (found) {
 		found->total_bytes += total_bytes;
 		found->bytes_used += bytes_used;
 		WARN_ON(found->total_bytes < found->bytes_used);
 		*space_info = found;
 		return 0;
 	}
@@ -1795,49 +1795,50 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	u64 start;
 	u64 num_bytes;
 	int ret;
 
 	space_info = __find_space_info(extent_root->fs_info, flags);
 	if (!space_info) {
 		ret = update_space_info(extent_root->fs_info, flags,
 					0, 0, &space_info);
 		BUG_ON(ret);
 	}
 	BUG_ON(!space_info);
 
 	if (space_info->full)
 		return 0;
 
 	thresh = div_factor(space_info->total_bytes, 7);
 	if ((space_info->bytes_used + space_info->bytes_pinned + alloc_bytes) <
 	    thresh)
 		return 0;
 
-	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes, flags);
+	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes,
+	                        space_info->flags);
 	if (ret == -ENOSPC) {
 		space_info->full = 1;
 		return 0;
 	}
 
 	BUG_ON(ret);
 
-	ret = btrfs_make_block_group(trans, extent_root, 0, flags,
+	ret = btrfs_make_block_group(trans, extent_root, 0, space_info->flags,
 		     BTRFS_FIRST_CHUNK_TREE_OBJECTID, start, num_bytes);
 	BUG_ON(ret);
 	return 0;
 }
 
 static int update_block_group(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      u64 bytenr, u64 num_bytes, int alloc,
 			      int mark_free)
 {
 	struct btrfs_block_group_cache *cache;
 	struct btrfs_fs_info *info = root->fs_info;
 	u64 total = num_bytes;
 	u64 old_val;
 	u64 byte_in_group;
 	u64 start;
 	u64 end;
 
 	/* block accounting for super block */
 	old_val = btrfs_super_bytes_used(&info->super_copy);
-- 
1.7.3.4

