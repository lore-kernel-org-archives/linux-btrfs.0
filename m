Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48960 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754099AbeFTMt1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:27 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C6672AF62
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:26 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 25/34] btrfs: Remove fs_info from check_system_chunk
Date: Wed, 20 Jun 2018 15:49:07 +0300
Message-Id: <1529498956-4241-26-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from trans since the function is always called
within a transaction

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/extent-tree.c | 8 ++++----
 fs/btrfs/volumes.c     | 2 +-
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f6b37911f41d..6498abf8ba36 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2821,8 +2821,7 @@ int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
 int btrfs_start_write_no_snapshotting(struct btrfs_root *root);
 void btrfs_end_write_no_snapshotting(struct btrfs_root *root);
 void btrfs_wait_for_snapshot_creation(struct btrfs_root *root);
-void check_system_chunk(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, const u64 type);
+void check_system_chunk(struct btrfs_trans_handle *trans, const u64 type);
 u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 		       u64 start, u64 end);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ed38ccf1607c..57884cd72225 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4493,9 +4493,9 @@ static u64 get_profile_num_devs(struct btrfs_fs_info *fs_info, u64 type)
  * for allocating a chunk, otherwise if it's false, reserve space necessary for
  * removing a chunk.
  */
-void check_system_chunk(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u64 type)
+void check_system_chunk(struct btrfs_trans_handle *trans, u64 type)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_space_info *info;
 	u64 left;
 	u64 thresh;
@@ -4634,7 +4634,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
 	 * Check if we have enough space in SYSTEM chunk because we may need
 	 * to update devices.
 	 */
-	check_system_chunk(trans, fs_info, flags);
+	check_system_chunk(trans, flags);
 
 	ret = btrfs_alloc_chunk(trans, flags);
 	trans->allocating_chunk = false;
@@ -9459,7 +9459,7 @@ int btrfs_inc_block_group_ro(struct btrfs_fs_info *fs_info,
 	if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
 		alloc_flags = update_block_group_flags(fs_info, cache->flags);
 		mutex_lock(&fs_info->chunk_mutex);
-		check_system_chunk(trans, fs_info, alloc_flags);
+		check_system_chunk(trans, alloc_flags);
 		mutex_unlock(&fs_info->chunk_mutex);
 	}
 	mutex_unlock(&fs_info->ro_block_group_mutex);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4a444aa82ac3..36225e5b16e5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2827,7 +2827,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 	}
 	map = em->map_lookup;
 	mutex_lock(&fs_info->chunk_mutex);
-	check_system_chunk(trans, fs_info, map->type);
+	check_system_chunk(trans, map->type);
 	mutex_unlock(&fs_info->chunk_mutex);
 
 	/*
-- 
2.7.4

