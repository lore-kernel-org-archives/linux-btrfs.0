Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45945 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaLQUNC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 15:13:02 -0500
Received: by mail-wi0-f170.google.com with SMTP id bs8so18194491wib.5
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 12:13:00 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 6/8] Track the size of the chunk created
Date: Wed, 17 Dec 2014 21:14:10 +0100
Message-Id: <1418847252-14184-7-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
References: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Track the size of the chunk during the filesystem creation. These information
are printed in a next patch.

Signed-off-by: Goffredo Baroncelli
---
 mkfs.c | 54 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 11 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 70c88ea..2d7b2ca 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -57,7 +57,16 @@ struct directory_name_entry {
 	struct list_head list;
 };
 
-static int make_root_dir(struct btrfs_root *root, int mixed)
+struct block_group_allocation {
+	u64 data;
+	u64 metadata;
+	u64 mixed;
+	u64 system;
+};
+
+
+static int make_root_dir(struct btrfs_root *root, int mixed,
+				struct block_group_allocation *allocation)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key location;
@@ -74,6 +83,7 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 				     BTRFS_BLOCK_GROUP_SYSTEM,
 				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     0, BTRFS_MKFS_SYSTEM_GROUP_SIZE);
+	allocation->system += BTRFS_MKFS_SYSTEM_GROUP_SIZE;
 	BUG_ON(ret);
 
 	if (mixed) {
@@ -92,8 +102,8 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 					     BTRFS_BLOCK_GROUP_DATA,
 					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
+		allocation->mixed += chunk_size;
 		BUG_ON(ret);
-		printf("Created a data/metadata chunk of size %llu\n", chunk_size);
 	} else {
 		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
 					&chunk_start, &chunk_size,
@@ -107,6 +117,7 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 					     BTRFS_BLOCK_GROUP_METADATA,
 					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
+		allocation->metadata += chunk_size;
 		BUG_ON(ret);
 	}
 
@@ -128,6 +139,7 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 					     BTRFS_BLOCK_GROUP_DATA,
 					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
+		allocation->data += chunk_size;
 		BUG_ON(ret);
 	}
 
@@ -187,7 +199,9 @@ static void recow_roots(struct btrfs_trans_handle *trans,
 }
 
 static int create_one_raid_group(struct btrfs_trans_handle *trans,
-			      struct btrfs_root *root, u64 type)
+			      struct btrfs_root *root, u64 type,
+			      struct block_group_allocation *allocation)
+
 {
 	u64 chunk_start;
 	u64 chunk_size;
@@ -203,6 +217,18 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 	ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
 				     type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     chunk_start, chunk_size);
+	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == BTRFS_BLOCK_GROUP_DATA)
+		allocation->data += chunk_size;
+	else if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == BTRFS_BLOCK_GROUP_METADATA)
+		allocation->metadata += chunk_size;
+	else if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == BTRFS_BLOCK_GROUP_SYSTEM)
+		allocation->system += chunk_size;
+	else if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) ==
+			(BTRFS_BLOCK_GROUP_METADATA|BTRFS_BLOCK_GROUP_DATA))
+		allocation->mixed += chunk_size;
+	else
+		BUG_ON(1);
+
 	BUG_ON(ret);
 	return ret;
 }
@@ -210,7 +236,8 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 static int create_raid_groups(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root, u64 data_profile,
 			      int data_profile_opt, u64 metadata_profile,
-			      int mixed)
+			      int mixed,
+			      struct block_group_allocation *allocation)
 {
 	u64 num_devices = btrfs_super_num_devices(root->fs_info->super_copy);
 	int ret;
@@ -220,21 +247,21 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 
 		ret = create_one_raid_group(trans, root,
 					    BTRFS_BLOCK_GROUP_SYSTEM |
-					    metadata_profile);
+					    metadata_profile, allocation);
 		BUG_ON(ret);
 
 		if (mixed)
 			meta_flags |= BTRFS_BLOCK_GROUP_DATA;
 
 		ret = create_one_raid_group(trans, root, meta_flags |
-					    metadata_profile);
+					    metadata_profile, allocation);
 		BUG_ON(ret);
 
 	}
 	if (!mixed && num_devices > 1 && data_profile) {
 		ret = create_one_raid_group(trans, root,
 					    BTRFS_BLOCK_GROUP_DATA |
-					    data_profile);
+					    data_profile, allocation);
 		BUG_ON(ret);
 	}
 	recow_roots(trans, root);
@@ -920,7 +947,8 @@ static int open_target(char *output_name)
 
 static int create_chunks(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root, u64 num_of_meta_chunks,
-			 u64 size_of_data)
+			 u64 size_of_data,
+			 struct block_group_allocation *allocation)
 {
 	u64 chunk_start;
 	u64 chunk_size;
@@ -937,6 +965,7 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 		ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
 					     meta_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
+		allocation->metadata += chunk_size;
 		BUG_ON(ret);
 		set_extent_dirty(&root->fs_info->free_space_cache,
 				 chunk_start, chunk_start + chunk_size - 1, 0);
@@ -951,6 +980,7 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 	ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
 				     data_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     chunk_start, size_of_data);
+	allocation->data += size_of_data;
 	BUG_ON(ret);
 	set_extent_dirty(&root->fs_info->free_space_cache,
 			 chunk_start, chunk_start + size_of_data - 1, 0);
@@ -1283,6 +1313,7 @@ int main(int ac, char **av)
 	char estr[100];
 	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
 	u64 features = DEFAULT_MKFS_FEATURES;
+	struct block_group_allocation allocation = { 0 };
 
 	while(1) {
 		int c;
@@ -1593,7 +1624,7 @@ int main(int ac, char **av)
 	}
 	root->fs_info->alloc_start = alloc_start;
 
-	ret = make_root_dir(root, mixed);
+	ret = make_root_dir(root, mixed, &allocation);
 	if (ret) {
 		fprintf(stderr, "failed to setup the root directory\n");
 		exit(1);
@@ -1649,7 +1680,7 @@ raid_groups:
 	if (!source_dir_set) {
 		ret = create_raid_groups(trans, root, data_profile,
 				 data_profile_opt, metadata_profile,
-				 mixed);
+				 mixed, &allocation);
 		BUG_ON(ret);
 	}
 
@@ -1666,7 +1697,8 @@ raid_groups:
 	if (source_dir_set) {
 		trans = btrfs_start_transaction(root, 1);
 		ret = create_chunks(trans, root,
-				    num_of_meta_chunks, size_of_data);
+				    num_of_meta_chunks, size_of_data,
+				    &allocation);
 		BUG_ON(ret);
 		btrfs_commit_transaction(trans, root);
 
-- 
2.1.3

