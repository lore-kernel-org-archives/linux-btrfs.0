Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56386 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754601AbeBGP4H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 10:56:07 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 49DD7ADD3
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 15:56:06 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 13/14] btrfs: Remove fs_info argument from btrfs_update_commit_device_bytes_used
Date: Wed,  7 Feb 2018 17:55:49 +0200
Message-Id: <1518018950-31456-14-git-send-email-nborisov@suse.com>
In-Reply-To: <1518018950-31456-1-git-send-email-nborisov@suse.com>
References: <1518018950-31456-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We already pass the btrfs_transaction which references fs_info so no
need to pass the later as an argument. Also use the opportunity to
shorten transaction->trans. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c |  2 +-
 fs/btrfs/volumes.c     | 10 +++++-----
 fs/btrfs/volumes.h     |  3 +--
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index abee26b269a1..b8dbe4e88631 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2245,7 +2245,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	       sizeof(*fs_info->super_copy));
 
 	btrfs_update_commit_device_size(fs_info);
-	btrfs_update_commit_device_bytes_used(fs_info, cur_trans);
+	btrfs_update_commit_device_bytes_used(cur_trans);
 
 	clear_bit(BTRFS_FS_LOG1_ERR, &fs_info->flags);
 	clear_bit(BTRFS_FS_LOG2_ERR, &fs_info->flags);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 71f9abd44f21..c61fef86538d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5229,7 +5229,7 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 		/*
 		 * There could be two corrupted data stripes, we need
 		 * to loop retry in order to rebuild the correct data.
-		 * 
+		 *
 		 * Fail a stripe at a time on every retry except the
 		 * stripe under reconstruction.
 		 */
@@ -7387,20 +7387,20 @@ void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info)
 }
 
 /* Must be invoked during the transaction commit */
-void btrfs_update_commit_device_bytes_used(struct btrfs_fs_info *fs_info,
-					struct btrfs_transaction *transaction)
+void btrfs_update_commit_device_bytes_used(struct btrfs_transaction *trans)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct extent_map *em;
 	struct map_lookup *map;
 	struct btrfs_device *dev;
 	int i;
 
-	if (list_empty(&transaction->pending_chunks))
+	if (list_empty(&trans->pending_chunks))
 		return;
 
 	/* In order to kick the device replace finish process */
 	mutex_lock(&fs_info->chunk_mutex);
-	list_for_each_entry(em, &transaction->pending_chunks, list) {
+	list_for_each_entry(em, &trans->pending_chunks, list) {
 		map = em->map_lookup;
 
 		for (i = 0; i < map->num_stripes; i++) {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index ca6640445a88..8692b40036d6 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -569,8 +569,7 @@ static inline enum btrfs_raid_types btrfs_bg_flags_to_raid_index(u64 flags)
 }
 
 void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info);
-void btrfs_update_commit_device_bytes_used(struct btrfs_fs_info *fs_info,
-					struct btrfs_transaction *transaction);
+void btrfs_update_commit_device_bytes_used(struct btrfs_transaction *trans);
 
 struct list_head *btrfs_get_fs_uuids(void);
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
-- 
2.7.4

