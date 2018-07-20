Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49950 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387881AbeGTR1D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 13:27:03 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 632C1AD55
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 16:37:57 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 7/7] btrfs: Remove fs_info from btrfs_finish_chunk_alloc
Date: Fri, 20 Jul 2018 19:37:53 +0300
Message-Id: <1532104673-28311-8-git-send-email-nborisov@suse.com>
In-Reply-To: <1532104673-28311-1-git-send-email-nborisov@suse.com>
References: <1532104673-28311-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed transaction handle.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c |  5 ++---
 fs/btrfs/volumes.c     | 10 +++++-----
 fs/btrfs/volumes.h     |  6 ++----
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fd109bfd528d..7469fc7e3f1a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10023,7 +10023,7 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 					sizeof(item));
 		if (ret)
 			btrfs_abort_transaction(trans, ret);
-		ret = btrfs_finish_chunk_alloc(trans, fs_info, key.objectid,
+		ret = btrfs_finish_chunk_alloc(trans, key.objectid,
 					       key.offset);
 		if (ret)
 			btrfs_abort_transaction(trans, ret);
@@ -10595,8 +10595,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		 * Btrfs_remove_chunk will abort the transaction if things go
 		 * horribly wrong.
 		 */
-		ret = btrfs_remove_chunk(trans, fs_info,
-					 block_group->key.objectid);
+		ret = btrfs_remove_chunk(trans, block_group->key.objectid);
 
 		if (ret) {
 			if (trimming)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7376c83708e4..418843b8f8e8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2708,9 +2708,9 @@ static struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,
 	return em;
 }
 
-int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
-		       struct btrfs_fs_info *fs_info, u64 chunk_offset)
+int btrfs_remove_chunk(struct btrfs_trans_handle *trans, u64 chunk_offset)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct extent_map *em;
 	struct map_lookup *map;
 	u64 dev_extent_len = 0;
@@ -2850,7 +2850,7 @@ static int btrfs_relocate_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 	 * step two, delete the device extents and the
 	 * chunk tree entries
 	 */
-	ret = btrfs_remove_chunk(trans, fs_info, chunk_offset);
+	ret = btrfs_remove_chunk(trans, chunk_offset);
 	btrfs_end_transaction(trans);
 	return ret;
 }
@@ -4834,9 +4834,9 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
-				struct btrfs_fs_info *fs_info,
-				u64 chunk_offset, u64 chunk_size)
+			     u64 chunk_offset, u64 chunk_size)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct btrfs_root *chunk_root = fs_info->chunk_root;
 	struct btrfs_key key;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 69a028058c43..049619176831 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -462,10 +462,8 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info,
 unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 				    u64 logical);
 int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
-				struct btrfs_fs_info *fs_info,
-				u64 chunk_offset, u64 chunk_size);
-int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
-		       struct btrfs_fs_info *fs_info, u64 chunk_offset);
+			     u64 chunk_offset, u64 chunk_size);
+int btrfs_remove_chunk(struct btrfs_trans_handle *trans, u64 chunk_offset);
 
 static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
 				      int index)
-- 
2.7.4

