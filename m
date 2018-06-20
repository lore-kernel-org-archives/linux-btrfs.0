Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48957 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754097AbeFTMt1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:27 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7FA61AF55
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:26 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 24/34] btrfs: Remove fs_info from btrfs_alloc_chunk
Date: Wed, 20 Jun 2018 15:49:06 +0300
Message-Id: <1529498956-4241-25-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from trans since the function is always called
within a transaction.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 4 ++--
 fs/btrfs/volumes.c     | 7 +++----
 fs/btrfs/volumes.h     | 3 +--
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4c45d68179d4..ed38ccf1607c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4534,7 +4534,7 @@ void check_system_chunk(struct btrfs_trans_handle *trans,
 		 * the paths we visit in the chunk tree (they were already COWed
 		 * or created in the current transaction for example).
 		 */
-		ret = btrfs_alloc_chunk(trans, fs_info, flags);
+		ret = btrfs_alloc_chunk(trans, flags);
 	}
 
 	if (!ret) {
@@ -4636,7 +4636,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
 	 */
 	check_system_chunk(trans, fs_info, flags);
 
-	ret = btrfs_alloc_chunk(trans, fs_info, flags);
+	ret = btrfs_alloc_chunk(trans, flags);
 	trans->allocating_chunk = false;
 
 	spin_lock(&space_info->lock);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fefff9405884..4a444aa82ac3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5036,13 +5036,12 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
  * require modifying the chunk tree. This division is important for the
  * bootstrap process of adding storage to a seed btrfs.
  */
-int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
-		      struct btrfs_fs_info *fs_info, u64 type)
+int btrfs_alloc_chunk(struct btrfs_trans_handle *trans, u64 type)
 {
 	u64 chunk_offset;
 
-	lockdep_assert_held(&fs_info->chunk_mutex);
-	chunk_offset = find_next_chunk(fs_info);
+	lockdep_assert_held(&trans->fs_info->chunk_mutex);
+	chunk_offset = find_next_chunk(trans->fs_info);
 	return __btrfs_alloc_chunk(trans, chunk_offset, type);
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 5139ec8daf4c..df2d8bdf8c9a 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -396,8 +396,7 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info, u64 chunk_start,
 		     u64 physical, u64 **logical, int *naddrs, int *stripe_len);
 int btrfs_read_sys_array(struct btrfs_fs_info *fs_info);
 int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info);
-int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
-		      struct btrfs_fs_info *fs_info, u64 type);
+int btrfs_alloc_chunk(struct btrfs_trans_handle *trans, u64 type);
 void btrfs_mapping_init(struct btrfs_mapping_tree *tree);
 void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree);
 blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
-- 
2.7.4

