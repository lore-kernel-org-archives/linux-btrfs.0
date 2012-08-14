Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:33555 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab2HNURK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 16:17:10 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id dhLHZXXhcFB2VmhN (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 14:17:09 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not allocate chunks as agressively
Date: Tue, 14 Aug 2012 16:22:18 -0400
Message-ID: <1344975738-1415-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swinging this pendulum back the other way.  We've been allocating chunks up
to 2% of the disk no matter how much we actually have allocated.  So instead
fix this calculation to only allocate chunks if we have more than 80% of the
space available allocated.  Please test this as it will likely cause all
sorts of ENOSPC problems to pop up suddenly.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ce494b9..eaf1a9e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3487,7 +3487,8 @@ static int should_alloc_chunk(struct btrfs_root *root,
 	 * and purposes it's used space.  Don't worry about locking the
 	 * global_rsv, it doesn't change except when the transaction commits.
 	 */
-	num_allocated += global_rsv->size;
+	if (sinfo->flags & BTRFS_BLOCK_GROUP_METADATA)
+		num_allocated += global_rsv->size;
 
 	/*
 	 * in limited mode, we want to have some free space up to
@@ -3501,15 +3502,8 @@ static int should_alloc_chunk(struct btrfs_root *root,
 		if (num_bytes - num_allocated < thresh)
 			return 1;
 	}
-	thresh = btrfs_super_total_bytes(root->fs_info->super_copy);
 
-	/* 256MB or 2% of the FS */
-	thresh = max_t(u64, 256 * 1024 * 1024, div_factor_fine(thresh, 2));
-	/* system chunks need a much small threshold */
-	if (sinfo->flags & BTRFS_BLOCK_GROUP_SYSTEM)
-		thresh = 32 * 1024 * 1024;
-
-	if (num_bytes > thresh && sinfo->bytes_used < div_factor(num_bytes, 8))
+	if (num_allocated + alloc_bytes < div_factor(num_bytes, 8))
 		return 0;
 	return 1;
 }
-- 
1.7.7.6

