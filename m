Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48955 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753202AbeFTMt1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:27 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 393A1AEC7
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:26 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 23/34] btrfs: Remove fs_info from do_chunk_alloc
Date: Wed, 20 Jun 2018 15:49:05 +0300
Message-Id: <1529498956-4241-24-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is always called with a valid transaction handle from
where fs_info can be referenced. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 229cb3a229b0..4c45d68179d4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -66,8 +66,7 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				     struct btrfs_delayed_ref_node *node,
 				     struct btrfs_delayed_extent_op *extent_op);
-static int do_chunk_alloc(struct btrfs_trans_handle *trans,
-			  struct btrfs_fs_info *fs_info, u64 flags,
+static int do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
 			  int force);
 static int find_next_key(struct btrfs_path *path, int level,
 			 struct btrfs_key *key);
@@ -4272,7 +4271,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 			if (IS_ERR(trans))
 				return PTR_ERR(trans);
 
-			ret = do_chunk_alloc(trans, fs_info, alloc_target,
+			ret = do_chunk_alloc(trans, alloc_target,
 					     CHUNK_ALLOC_NO_FORCE);
 			btrfs_end_transaction(trans);
 			if (ret < 0) {
@@ -4556,9 +4555,10 @@ void check_system_chunk(struct btrfs_trans_handle *trans,
  *    - return 1 if it successfully allocates a chunk,
  *    - return errors including -ENOSPC otherwise.
  */
-static int do_chunk_alloc(struct btrfs_trans_handle *trans,
-			  struct btrfs_fs_info *fs_info, u64 flags, int force)
+static int do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
+			  int force)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_space_info *space_info;
 	int wait_for_alloc = 0;
 	int ret = 0;
@@ -4967,7 +4967,7 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 			ret = PTR_ERR(trans);
 			break;
 		}
-		ret = do_chunk_alloc(trans, fs_info,
+		ret = do_chunk_alloc(trans,
 				     btrfs_metadata_alloc_profile(fs_info),
 				     CHUNK_ALLOC_NO_FORCE);
 		btrfs_end_transaction(trans);
@@ -7808,8 +7808,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 				goto out;
 			}
 
-			ret = do_chunk_alloc(trans, fs_info, flags,
-					     CHUNK_ALLOC_FORCE);
+			ret = do_chunk_alloc(trans, flags, CHUNK_ALLOC_FORCE);
 
 			/*
 			 * If we can't allocate a new chunk we've already looped
@@ -9435,7 +9434,7 @@ int btrfs_inc_block_group_ro(struct btrfs_fs_info *fs_info,
 	 */
 	alloc_flags = update_block_group_flags(fs_info, cache->flags);
 	if (alloc_flags != cache->flags) {
-		ret = do_chunk_alloc(trans, fs_info, alloc_flags,
+		ret = do_chunk_alloc(trans, alloc_flags,
 				     CHUNK_ALLOC_FORCE);
 		/*
 		 * ENOSPC is allowed here, we may have enough space
@@ -9452,8 +9451,7 @@ int btrfs_inc_block_group_ro(struct btrfs_fs_info *fs_info,
 	if (!ret)
 		goto out;
 	alloc_flags = get_alloc_profile(fs_info, cache->space_info->flags);
-	ret = do_chunk_alloc(trans, fs_info, alloc_flags,
-			     CHUNK_ALLOC_FORCE);
+	ret = do_chunk_alloc(trans, alloc_flags, CHUNK_ALLOC_FORCE);
 	if (ret < 0)
 		goto out;
 	ret = inc_block_group_ro(cache, 0);
@@ -9475,7 +9473,7 @@ int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans,
 {
 	u64 alloc_flags = get_alloc_profile(fs_info, type);
 
-	return do_chunk_alloc(trans, fs_info, alloc_flags, CHUNK_ALLOC_FORCE);
+	return do_chunk_alloc(trans, alloc_flags, CHUNK_ALLOC_FORCE);
 }
 
 /*
-- 
2.7.4

