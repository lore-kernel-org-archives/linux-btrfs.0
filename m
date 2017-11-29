Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:41090 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753558AbdK2JQS (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 29 Nov 2017 04:16:18 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/9] btrfs-progs: mkfs: Don't use custom chunk allocator for rootdir
Date: Wed, 29 Nov 2017 17:15:57 +0800
Message-Id: <20171129091604.2194-3-wqu@suse.com>
In-Reply-To: <20171129091604.2194-1-wqu@suse.com>
References: <20171129091604.2194-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove these custom chunk allocator for mkfs.
Use generic btrfs chunk allocator instead.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c | 62 -------------------------------------------------------------
 1 file changed, 62 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index a81718d1517d..716395c4b6b4 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -413,53 +413,6 @@ static char *parse_subvol_name(const char *input)
 	return strdup(input);
 }
 
-static int create_chunks(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root, u64 num_of_meta_chunks,
-			 u64 size_of_data,
-			 struct mkfs_allocation *allocation)
-{
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	u64 chunk_start;
-	u64 chunk_size;
-	u64 meta_type = BTRFS_BLOCK_GROUP_METADATA;
-	u64 data_type = BTRFS_BLOCK_GROUP_DATA;
-	u64 minimum_data_chunk_size = SZ_8M;
-	u64 i;
-	int ret;
-
-	for (i = 0; i < num_of_meta_chunks; i++) {
-		ret = btrfs_alloc_chunk(trans, fs_info,
-					&chunk_start, &chunk_size, meta_type);
-		if (ret)
-			return ret;
-		ret = btrfs_make_block_group(trans, fs_info, 0,
-					     meta_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-					     chunk_start, chunk_size);
-		allocation->metadata += chunk_size;
-		if (ret)
-			return ret;
-		set_extent_dirty(&root->fs_info->free_space_cache,
-				 chunk_start, chunk_start + chunk_size - 1);
-	}
-
-	if (size_of_data < minimum_data_chunk_size)
-		size_of_data = minimum_data_chunk_size;
-
-	ret = btrfs_alloc_data_chunk(trans, fs_info,
-				     &chunk_start, size_of_data, data_type, 0);
-	if (ret)
-		return ret;
-	ret = btrfs_make_block_group(trans, fs_info, 0,
-				     data_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-				     chunk_start, size_of_data);
-	allocation->data += size_of_data;
-	if (ret)
-		return ret;
-	set_extent_dirty(&root->fs_info->free_space_cache,
-			 chunk_start, chunk_start + size_of_data - 1);
-	return ret;
-}
-
 static int zero_output_file(int out_fd, u64 size)
 {
 	int loop_num;
@@ -1256,21 +1209,6 @@ raid_groups:
 	}
 
 	if (source_dir_set) {
-		trans = btrfs_start_transaction(root, 1);
-		BUG_ON(IS_ERR(trans));
-		ret = create_chunks(trans, root,
-				    num_of_meta_chunks, size_of_data,
-				    &allocation);
-		if (ret) {
-			error("unable to create chunks: %d", ret);
-			goto out;
-		}
-		ret = btrfs_commit_transaction(trans, root);
-		if (ret) {
-			error("transaction commit failed: %d", ret);
-			goto out;
-		}
-
 		if (subvol_name_set) {
 			u64 dirid, objectid;
 			struct btrfs_root *file_root;
-- 
2.15.0

