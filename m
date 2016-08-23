Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59396 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754518AbcHWKnn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 06:43:43 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A64CAAD6F
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 10:26:25 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 06/13] btrfs-progs: mkfs: return errors from block group creation functions
Date: Tue, 23 Aug 2016 12:25:10 +0200
Message-Id: <1471947917-5324-7-git-send-email-dsterba@suse.com>
In-Reply-To: <1471947917-5324-1-git-send-email-dsterba@suse.com>
References: <1471947917-5324-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No more BUG_ONs, we don't care about cleanup as the filesystem is
supposed to be marked as partial.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 mkfs.c | 75 ++++++++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 48 insertions(+), 27 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index ee5a30daff54..b2baf47bb595 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -79,7 +79,8 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     0, BTRFS_MKFS_SYSTEM_GROUP_SIZE);
 	allocation->system += BTRFS_MKFS_SYSTEM_GROUP_SIZE;
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 
 	if (mixed) {
 		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
@@ -90,13 +91,15 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 			error("no space to allocate data/metadata chunk");
 			goto err;
 		}
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 		ret = btrfs_make_block_group(trans, root, 0,
 					     BTRFS_BLOCK_GROUP_METADATA |
 					     BTRFS_BLOCK_GROUP_DATA,
 					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 		allocation->mixed += chunk_size;
 	} else {
 		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
@@ -106,17 +109,19 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 			error("no space to allocate metadata chunk");
 			goto err;
 		}
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 		ret = btrfs_make_block_group(trans, root, 0,
 					     BTRFS_BLOCK_GROUP_METADATA,
 					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
 		allocation->metadata += chunk_size;
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 	}
 
 	root->fs_info->system_allocs = 0;
-	btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root);
 
 err:
 	return ret;
@@ -138,13 +143,15 @@ static int create_data_block_groups(struct btrfs_trans_handle *trans,
 			error("no space to allocate data chunk");
 			goto err;
 		}
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 		ret = btrfs_make_block_group(trans, root, 0,
 					     BTRFS_BLOCK_GROUP_DATA,
 					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
 		allocation->data += chunk_size;
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 	}
 
 err:
@@ -226,23 +233,29 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 		error("not enough free space to allocate chunk");
 		exit(1);
 	}
-	BUG_ON(ret);
+	if (ret)
+		return ret;
+
 	ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
 				     type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     chunk_start, chunk_size);
-	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == BTRFS_BLOCK_GROUP_DATA)
+
+	type &= BTRFS_BLOCK_GROUP_TYPE_MASK;
+	if (type == BTRFS_BLOCK_GROUP_DATA) {
 		allocation->data += chunk_size;
-	else if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == BTRFS_BLOCK_GROUP_METADATA)
+	} else if (type == BTRFS_BLOCK_GROUP_METADATA) {
 		allocation->metadata += chunk_size;
-	else if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == BTRFS_BLOCK_GROUP_SYSTEM)
+	} else if (type == BTRFS_BLOCK_GROUP_SYSTEM) {
 		allocation->system += chunk_size;
-	else if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) ==
-			(BTRFS_BLOCK_GROUP_METADATA|BTRFS_BLOCK_GROUP_DATA))
+	} else if (type ==
+			(BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA)) {
 		allocation->mixed += chunk_size;
-	else
-		BUG_ON(1);
+	} else {
+		error("unrecognized profile type: 0x%llx",
+				(unsigned long long)type);
+		ret = -EINVAL;
+	}
 
-	BUG_ON(ret);
 	return ret;
 }
 
@@ -259,21 +272,24 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 		ret = create_one_raid_group(trans, root,
 					    BTRFS_BLOCK_GROUP_SYSTEM |
 					    metadata_profile, allocation);
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 
 		if (mixed)
 			meta_flags |= BTRFS_BLOCK_GROUP_DATA;
 
 		ret = create_one_raid_group(trans, root, meta_flags |
 					    metadata_profile, allocation);
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 
 	}
 	if (!mixed && data_profile) {
 		ret = create_one_raid_group(trans, root,
 					    BTRFS_BLOCK_GROUP_DATA |
 					    data_profile, allocation);
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 	}
 	recow_roots(trans, root);
 
@@ -290,7 +306,8 @@ static int create_data_reloc_tree(struct btrfs_trans_handle *trans,
 	int ret;
 
 	ret = btrfs_copy_root(trans, root, root->node, &tmp, objectid);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 
 	memcpy(&root_item, &root->root_item, sizeof(root_item));
 	btrfs_set_root_bytenr(&root_item, tmp->start);
@@ -303,8 +320,8 @@ static int create_data_reloc_tree(struct btrfs_trans_handle *trans,
 	location.offset = 0;
 	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
 				&location, &root_item);
-	BUG_ON(ret);
-	return 0;
+
+	return ret;
 }
 
 static void print_usage(int ret)
@@ -968,12 +985,14 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 	for (i = 0; i < num_of_meta_chunks; i++) {
 		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
 					&chunk_start, &chunk_size, meta_type);
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 		ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
 					     meta_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
 		allocation->metadata += chunk_size;
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 		set_extent_dirty(&root->fs_info->free_space_cache,
 				 chunk_start, chunk_start + chunk_size - 1, 0);
 	}
@@ -983,12 +1002,14 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_alloc_data_chunk(trans, root->fs_info->extent_root,
 				     &chunk_start, size_of_data, data_type, 0);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 	ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
 				     data_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     chunk_start, size_of_data);
 	allocation->data += size_of_data;
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 	set_extent_dirty(&root->fs_info->free_space_cache,
 			 chunk_start, chunk_start + size_of_data - 1, 0);
 	return ret;
-- 
2.7.1

