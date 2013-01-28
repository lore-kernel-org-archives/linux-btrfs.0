Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:43187 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab3A1G0F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 01:26:05 -0500
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: lev@zadarastorage.com, sensille@gmx.net
Subject: [PATCH] Btrfs: fix EDQUOT handling in btrfs_delalloc_reserve_metadata
Date: Mon, 28 Jan 2013 07:26:00 +0100
Message-Id: <1359354360-604-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs_qgroup_reserve returned a failure, we were missing a counter
operation for BTRFS_I(inode)->outstanding_extents++, leading to warning
messages about outstanding extents and space_info->bytes_may_use != 0.
Additionally, the error handling code didn't take into account that we
dropped the inode lock which might require more cleanup.

Luckily, all the cleanup code we need is already there and can be shared
with reserve_metadata_bytes, which is exactly what this patch does.

Reported-by: Lev Vainblat <lev@zadarastorage.com>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/extent-tree.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 85b8454..61da9d0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4534,7 +4534,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	unsigned nr_extents = 0;
 	int extra_reserve = 0;
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
-	int ret;
+	int ret = 0;
 	bool delalloc_lock = true;
 
 	/* If we are a free space inode we need to not flush since we will be in
@@ -4579,20 +4579,18 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	csum_bytes = BTRFS_I(inode)->csum_bytes;
 	spin_unlock(&BTRFS_I(inode)->lock);
 
-	if (root->fs_info->quota_enabled) {
+	if (root->fs_info->quota_enabled)
 		ret = btrfs_qgroup_reserve(root, num_bytes +
 					   nr_extents * root->leafsize);
-		if (ret) {
-			spin_lock(&BTRFS_I(inode)->lock);
-			calc_csum_metadata_size(inode, num_bytes, 0);
-			spin_unlock(&BTRFS_I(inode)->lock);
-			if (delalloc_lock)
-				mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
-			return ret;
-		}
-	}
 
-	ret = reserve_metadata_bytes(root, block_rsv, to_reserve, flush);
+	/*
+	 * ret != 0 here means the qgroup reservation failed, we go straight to
+	 * the shared error handling then.
+	 */
+	if (ret == 0)
+		ret = reserve_metadata_bytes(root, block_rsv,
+					     to_reserve, flush);
+
 	if (ret) {
 		u64 to_free = 0;
 		unsigned dropped;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
