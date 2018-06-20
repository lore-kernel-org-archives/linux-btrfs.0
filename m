Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48963 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752901AbeFTMtY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:24 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 99521AEC7
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:23 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 14/34] btrfs: Remove fs_info from btrfs_remove_block_group
Date: Wed, 20 Jun 2018 15:48:56 +0300
Message-Id: <1529498956-4241-15-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is always called with a valid transaction handle from
where we can reference fs_info. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/extent-tree.c | 4 ++--
 fs/btrfs/volumes.c     | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 907c14786680..f6b37911f41d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2723,8 +2723,7 @@ struct btrfs_trans_handle *btrfs_start_trans_remove_block_group(
 				struct btrfs_fs_info *fs_info,
 				const u64 chunk_offset);
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info, u64 group_start,
-			     struct extent_map *em);
+			     u64 group_start, struct extent_map *em);
 void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info);
 void btrfs_get_block_group_trimming(struct btrfs_block_group_cache *cache);
 void btrfs_put_block_group_trimming(struct btrfs_block_group_cache *cache);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 95da427a66ea..93dc421723ed 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10300,9 +10300,9 @@ static void clear_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 }
 
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info, u64 group_start,
-			     struct extent_map *em)
+			     u64 group_start, struct extent_map *em)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_path *path;
 	struct btrfs_block_group_cache *block_group;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4f376463fdd4..fefff9405884 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2883,7 +2883,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	ret = btrfs_remove_block_group(trans, fs_info, chunk_offset, em);
+	ret = btrfs_remove_block_group(trans, chunk_offset, em);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out;
-- 
2.7.4

