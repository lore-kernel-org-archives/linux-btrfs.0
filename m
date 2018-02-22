Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:58354 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752509AbeBVGrp (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 22 Feb 2018 01:47:45 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v3 3/9] btrfs-progs: Make btrfs_alloc_chunk to handle block group creation
Date: Thu, 22 Feb 2018 14:47:27 +0800
Message-Id: <20180222064733.12126-4-wqu@suse.com>
In-Reply-To: <20180222064733.12126-1-wqu@suse.com>
References: <20180222064733.12126-1-wqu@suse.com>
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
 mkfs/main.c    | 19 -------------------
 volumes.c      | 10 ++++++----
 4 files changed, 8 insertions(+), 35 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index b2444bb2ff21..240d3aa46db9 100644
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
index b085ab0352b3..bccd83d1bae6 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1909,15 +1909,9 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
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
 
 static int update_block_group(struct btrfs_root *root,
diff --git a/mkfs/main.c b/mkfs/main.c
index 15a271ce4dcb..7c32381d0854 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -88,12 +88,6 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
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
@@ -107,12 +101,7 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
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
@@ -141,12 +130,7 @@ static int create_data_block_groups(struct btrfs_trans_handle *trans,
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
@@ -250,9 +234,6 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
-	ret = btrfs_make_block_group(trans, fs_info, 0,
-				     type, chunk_start, chunk_size);
-
 	type &= BTRFS_BLOCK_GROUP_TYPE_MASK;
 	if (type == BTRFS_BLOCK_GROUP_DATA) {
 		allocation->data += chunk_size;
diff --git a/volumes.c b/volumes.c
index 9ee4650351c3..a9dc8c939dc5 100644
--- a/volumes.c
+++ b/volumes.c
@@ -837,10 +837,9 @@ error:
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
@@ -1159,6 +1158,9 @@ alloc_chunk:
 	}
 
 	kfree(chunk);
+
+	ret = btrfs_make_block_group(trans, info, 0, type, map->ce.start,
+				     map->ce.size);
 	return ret;
 
 out_chunk_map:
-- 
2.16.2

