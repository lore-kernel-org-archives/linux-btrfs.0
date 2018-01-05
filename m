Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:42198 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751409AbeAEIMY (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 5 Jan 2018 03:12:24 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/2] btrfs-progs: Make btrfs_alloc_chunk to handle block group creation
Date: Fri,  5 Jan 2018 16:12:12 +0800
Message-Id: <20180105081212.27175-3-wqu@suse.com>
In-Reply-To: <20180105081212.27175-1-wqu@suse.com>
References: <20180105081212.27175-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, chunk allocation is split into 2 parts:

1) Chunk allocation
   Handled by btrfs_alloc_chunk(), which will insert chunk and device
   extent items.

2) Block group allocation
   Handled by btrfs_make_block_group(), which will insert block group
   item and update space info.

However for chunk allocation, we don't really need to split these
operations as all btrfs_alloc_chunk() has btrfs_make_block_group()
followed.

So it's reasonable to merge btrfs_make_block_group() call into
btrfs_alloc_chunk() to save several lines, and provides the basis for
later btrfs_alloc_chunk() rework.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 convert/main.c |  4 ----
 extent-tree.c  | 10 ++--------
 mkfs/main.c    | 28 ----------------------------
 volumes.c      | 10 ++++++----
 4 files changed, 8 insertions(+), 44 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index 8ee858fb2d05..96a04eda5b18 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -915,10 +915,6 @@ static int make_convert_data_block_groups(struct btrfs_trans_handle *trans,
 					BTRFS_BLOCK_GROUP_DATA, true);
 			if (ret < 0)
 				break;
-			ret = btrfs_make_block_group(trans, fs_info, 0,
-					BTRFS_BLOCK_GROUP_DATA, cur, len);
-			if (ret < 0)
-				break;
 			cur += len;
 		}
 	}
diff --git a/extent-tree.c b/extent-tree.c
index 4231be11bd53..90e792a3fe62 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1910,15 +1910,9 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	                        space_info->flags, false);
 	if (ret == -ENOSPC) {
 		space_info->full = 1;
-		return 0;
+		return ret;
 	}
-
-	BUG_ON(ret);
-
-	ret = btrfs_make_block_group(trans, fs_info, 0, space_info->flags,
-				     start, num_bytes);
-	BUG_ON(ret);
-	return 0;
+	return ret;
 }
 
 static int update_block_group(struct btrfs_trans_handle *trans,
diff --git a/mkfs/main.c b/mkfs/main.c
index f8e27a7ec8b8..9377aa30f39d 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -97,12 +97,6 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 			error("no space to allocate data/metadata chunk");
 			goto err;
 		}
-		if (ret)
-			return ret;
-		ret = btrfs_make_block_group(trans, fs_info, 0,
-					     BTRFS_BLOCK_GROUP_METADATA |
-					     BTRFS_BLOCK_GROUP_DATA,
-					     chunk_start, chunk_size);
 		if (ret)
 			return ret;
 		allocation->mixed += chunk_size;
@@ -116,12 +110,7 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 		}
 		if (ret)
 			return ret;
-		ret = btrfs_make_block_group(trans, fs_info, 0,
-					     BTRFS_BLOCK_GROUP_METADATA,
-					     chunk_start, chunk_size);
 		allocation->metadata += chunk_size;
-		if (ret)
-			return ret;
 	}
 
 	root->fs_info->system_allocs = 0;
@@ -150,12 +139,7 @@ static int create_data_block_groups(struct btrfs_trans_handle *trans,
 		}
 		if (ret)
 			return ret;
-		ret = btrfs_make_block_group(trans, fs_info, 0,
-					     BTRFS_BLOCK_GROUP_DATA,
-					     chunk_start, chunk_size);
 		allocation->data += chunk_size;
-		if (ret)
-			return ret;
 	}
 
 err:
@@ -259,9 +243,6 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
-	ret = btrfs_make_block_group(trans, fs_info, 0,
-				     type, chunk_start, chunk_size);
-
 	type &= BTRFS_BLOCK_GROUP_TYPE_MASK;
 	if (type == BTRFS_BLOCK_GROUP_DATA) {
 		allocation->data += chunk_size;
@@ -1006,12 +987,7 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 				&chunk_start, &chunk_size, meta_type, false);
 		if (ret)
 			return ret;
-		ret = btrfs_make_block_group(trans, fs_info, 0,
-					     meta_type, chunk_start,
-					     chunk_size);
 		allocation->metadata += chunk_size;
-		if (ret)
-			return ret;
 		set_extent_dirty(&root->fs_info->free_space_cache,
 				 chunk_start, chunk_start + chunk_size - 1);
 	}
@@ -1023,11 +999,7 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 				&chunk_start, &size_of_data, data_type, false);
 	if (ret)
 		return ret;
-	ret = btrfs_make_block_group(trans, fs_info, 0,
-				     data_type, chunk_start, size_of_data);
 	allocation->data += size_of_data;
-	if (ret)
-		return ret;
 	set_extent_dirty(&root->fs_info->free_space_cache,
 			 chunk_start, chunk_start + size_of_data - 1);
 	return ret;
diff --git a/volumes.c b/volumes.c
index 89c2f952f5b3..7bcebc708190 100644
--- a/volumes.c
+++ b/volumes.c
@@ -845,10 +845,9 @@ error:
 				/ sizeof(struct btrfs_stripe) + 1)
 
 /*
- * Alloc a chunk, will insert dev extents, chunk item.
- * NOTE: This function will not insert block group item nor mark newly
- * allocated chunk available for later allocation.
- * Block group item and free space update is handled by btrfs_make_block_group()
+ * Alloc a chunk, will insert dev extents, chunk item, and insert new
+ * block group and update space info (so that extent allocator can use
+ * newly allocated chunk).
  *
  * @start:	return value of allocated chunk start bytenr.
  * @num_bytes:	return value of allocated chunk size
@@ -1168,6 +1167,9 @@ alloc_chunk:
 	}
 
 	kfree(chunk);
+
+	ret = btrfs_make_block_group(trans, info, 0, type, map->ce.start,
+				     map->ce.size);
 	return ret;
 
 out_chunk_map:
-- 
2.15.1

