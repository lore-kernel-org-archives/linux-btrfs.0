Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:35214 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab2JVTuW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 15:50:22 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id FayZW1xmtMrbGEEv (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 13:50:21 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fill the global reserve when unpinning space
Date: Mon, 22 Oct 2012 15:56:07 -0400
Message-ID: <1350935767-3191-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave gave me an image of a very full file system that would abort the
transaction because it ran out of space while committing the transaction.
This is because we would think there was plenty of room to create a snapshot
even though the global reserve was not full.  This happens because we
calculate the global reserve size before we unpin any space, so after we
unpin the space we allow reservations to occur even though we haven't
reserved all of the space for our global reserve.  Fix this by adding to the
global reserve while unpinning in order to make sure we always have enough
space to do our work.  With this patch we no longer end up with an aborted
transaction, we return ENOSPC properly to the person trying to create the
snapshot.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2136add..b765025 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4949,9 +4949,13 @@ static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_block_group_cache *cache = NULL;
+	struct btrfs_space_info *space_info;
+	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
 	u64 len;
+	bool readonly;
 
 	while (start <= end) {
+		readonly = false;
 		if (!cache ||
 		    start >= cache->key.objectid + cache->key.offset) {
 			if (cache)
@@ -4969,15 +4973,30 @@ static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
 		}
 
 		start += len;
+		space_info = cache->space_info;
 
-		spin_lock(&cache->space_info->lock);
+		spin_lock(&space_info->lock);
 		spin_lock(&cache->lock);
 		cache->pinned -= len;
-		cache->space_info->bytes_pinned -= len;
-		if (cache->ro)
-			cache->space_info->bytes_readonly += len;
+		space_info->bytes_pinned -= len;
+		if (cache->ro) {
+			space_info->bytes_readonly += len;
+			readonly = true;
+		}
 		spin_unlock(&cache->lock);
-		spin_unlock(&cache->space_info->lock);
+		if (!readonly) {
+			spin_lock(&global_rsv->lock);
+			if (!global_rsv->full) {
+				len = min(len, global_rsv->size -
+					  global_rsv->reserved);
+				global_rsv->reserved += len;
+				space_info->bytes_may_use += len;
+				if (global_rsv->reserved >= global_rsv->size)
+					global_rsv->full = 1;
+			}
+			spin_unlock(&global_rsv->lock);
+		}
+		spin_unlock(&space_info->lock);
 	}
 
 	if (cache)
-- 
1.7.7.6

