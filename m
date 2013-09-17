Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:41201 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab3IQOtE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 10:49:04 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id CC0B37C0645
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 08:49:03 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id YwmoGACE2qXmoOEt (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 08:49:03 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Revert "Btrfs: rework the overcommit logic to be based on the total size"
Date: Tue, 17 Sep 2013 10:49:01 -0400
Message-ID: <1379429341-3103-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit 70afa3998c9baed4186df38988246de1abdab56d.  It is causing
performance issues and wasn't actually correct.  There were problems with the
way we flushed delalloc and that was the real cause of the early enospc.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2f03181..07f7f69 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3925,7 +3925,6 @@ static int can_overcommit(struct btrfs_root *root,
 	u64 space_size;
 	u64 avail;
 	u64 used;
-	u64 to_add;
 
 	used = space_info->bytes_used + space_info->bytes_reserved +
 		space_info->bytes_pinned + space_info->bytes_readonly;
@@ -3959,25 +3958,17 @@ static int can_overcommit(struct btrfs_root *root,
 		       BTRFS_BLOCK_GROUP_RAID10))
 		avail >>= 1;
 
-	to_add = space_info->total_bytes;
-
 	/*
 	 * If we aren't flushing all things, let us overcommit up to
 	 * 1/2th of the space. If we can flush, don't let us overcommit
 	 * too much, let it overcommit up to 1/8 of the space.
 	 */
 	if (flush == BTRFS_RESERVE_FLUSH_ALL)
-		to_add >>= 3;
+		avail >>= 3;
 	else
-		to_add >>= 1;
-
-	/*
-	 * Limit the overcommit to the amount of free space we could possibly
-	 * allocate for chunks.
-	 */
-	to_add = min(avail, to_add);
+		avail >>= 1;
 
-	if (used + bytes < space_info->total_bytes + to_add)
+	if (used + bytes < space_info->total_bytes + avail)
 		return 1;
 	return 0;
 }
-- 
1.7.7.6

