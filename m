Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:41369 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3IQPDA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 11:03:00 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id CAC5F7C069F
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 09:02:59 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id CgQDfqH5TDCIL2Gp (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 09:02:59 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove space_info->reservation_progress
Date: Tue, 17 Sep 2013 11:02:57 -0400
Message-ID: <1379430177-5746-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This isn't used for anything anymore, just remove it.

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.h       |    9 ---------
 fs/btrfs/extent-tree.c |    3 ---
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 36490b9..0506f40 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1118,15 +1118,6 @@ struct btrfs_space_info {
 	 */
 	struct percpu_counter total_bytes_pinned;
 
-	/*
-	 * we bump reservation progress every time we decrement
-	 * bytes_reserved.  This way people waiting for reservations
-	 * know something good has happened and they can check
-	 * for progress.  The number here isn't to be trusted, it
-	 * just shows reclaim activity
-	 */
-	unsigned long reservation_progress;
-
 	unsigned int full:1;	/* indicates that we cannot allocate any more
 				   chunks for this space */
 	unsigned int chunk_alloc:1;	/* set if we are allocating a chunk */
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 88c6db6..d58bef1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4456,7 +4456,6 @@ static void block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
 			space_info->bytes_may_use -= num_bytes;
 			trace_btrfs_space_reservation(fs_info, "space_info",
 					space_info->flags, num_bytes, 0);
-			space_info->reservation_progress++;
 			spin_unlock(&space_info->lock);
 		}
 	}
@@ -4657,7 +4656,6 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 		sinfo->bytes_may_use -= num_bytes;
 		trace_btrfs_space_reservation(fs_info, "space_info",
 				      sinfo->flags, num_bytes, 0);
-		sinfo->reservation_progress++;
 		block_rsv->reserved = block_rsv->size;
 		block_rsv->full = 1;
 	}
@@ -5437,7 +5435,6 @@ static int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
 			space_info->bytes_readonly += num_bytes;
 		cache->reserved -= num_bytes;
 		space_info->bytes_reserved -= num_bytes;
-		space_info->reservation_progress++;
 	}
 	spin_unlock(&cache->lock);
 	spin_unlock(&space_info->lock);
-- 
1.7.7.6

