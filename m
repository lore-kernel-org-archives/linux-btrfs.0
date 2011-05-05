From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs progs: fix extra metadata chunk allocation in --mixed case
Date: Thu,  5 May 2011 16:16:12 +0200
Message-ID: <1304604972-31585-1-git-send-email-sensille@gmx.net>
Cc: josef@redhat.com
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

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
@@ -1735,7 +1735,7 @@ static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 	struct btrfs_space_info *found;
 	list_for_each(cur, head) {
 		found = list_entry(cur, struct btrfs_space_info, list);
-		if (found->flags == flags)
+		if (found->flags & flags)
 			return found;
 	}
 	return NULL;
@@ -1812,7 +1812,8 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	    thresh)
 		return 0;
 
-	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes, flags);
+	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes,
+	                        space_info->flags);
 	if (ret == -ENOSPC) {
 		space_info->full = 1;
 		return 0;
@@ -1820,7 +1821,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 
 	BUG_ON(ret);
 
-	ret = btrfs_make_block_group(trans, extent_root, 0, flags,
+	ret = btrfs_make_block_group(trans, extent_root, 0, space_info->flags,
 		     BTRFS_FIRST_CHUNK_TREE_OBJECTID, start, num_bytes);
 	BUG_ON(ret);
 	return 0;
-- 
1.7.3.4

