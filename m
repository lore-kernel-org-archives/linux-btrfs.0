Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48960 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753906AbeFTMtY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:24 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 56492AE90
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:23 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 13/34] btrfs: Remove fs_info from btrfs_make_block_group
Date: Wed, 20 Jun 2018 15:48:55 +0300
Message-Id: <1529498956-4241-14-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is always called with a valid transaction handle from
where we can reference the fs_info. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       | 4 ++--
 fs/btrfs/extent-tree.c | 4 ++--
 fs/btrfs/volumes.c     | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 118346aceea9..907c14786680 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2716,8 +2716,8 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info);
 int btrfs_read_block_groups(struct btrfs_fs_info *info);
 int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr);
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
-			   struct btrfs_fs_info *fs_info, u64 bytes_used,
-			   u64 type, u64 chunk_offset, u64 size);
+			   u64 bytes_used, u64 type, u64 chunk_offset,
+			   u64 size);
 void btrfs_add_raid_kobjects(struct btrfs_fs_info *fs_info);
 struct btrfs_trans_handle *btrfs_start_trans_remove_block_group(
 				struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index cf54cd48c75d..95da427a66ea 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10207,10 +10207,10 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 	trans->can_flush_pending_bgs = can_flush_pending_bgs;
 }
 
-int btrfs_make_block_group(struct btrfs_trans_handle *trans,
-			   struct btrfs_fs_info *fs_info, u64 bytes_used,
+int btrfs_make_block_group(struct btrfs_trans_handle *trans, u64 bytes_used,
 			   u64 type, u64 chunk_offset, u64 size)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_block_group_cache *cache;
 	int ret;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e034ad9e23b4..4f376463fdd4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4898,7 +4898,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	refcount_inc(&em->refs);
 	write_unlock(&em_tree->lock);
 
-	ret = btrfs_make_block_group(trans, info, 0, type, start, num_bytes);
+	ret = btrfs_make_block_group(trans, 0, type, start, num_bytes);
 	if (ret)
 		goto error_del_extent;
 
@@ -5173,7 +5173,7 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 		/*
 		 * There could be two corrupted data stripes, we need
 		 * to loop retry in order to rebuild the correct data.
-		 * 
+		 *
 		 * Fail a stripe at a time on every retry except the
 		 * stripe under reconstruction.
 		 */
-- 
2.7.4

