Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:49158 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab3BFSvr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2013 13:51:47 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id D63159A03E1
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Feb 2013 11:51:46 -0700 (MST)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id urQIsezSCbqJ4FDd (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 06 Feb 2013 11:51:46 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: rework the overcommit logic to be based on the total size
Date: Wed, 6 Feb 2013 13:58:39 -0500
Message-ID: <1360177119-10614-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

People have been complaining about random ENOSPC errors that will clear up
after a umount or just a given amount of time.  Chris was able to reproduce
this with stress.sh and lots of processes and so was I.  Basically the
overcommit stuff would really let us get out of hand, in my tests I saw up
to 30 gigs of outstanding reservations with only 2 gigs total of metadata
space.  This usually worked out fine but with so much outstanding
reservation the flushing stuff short circuits to make sure we don't hang
forever flushing when we really need ENOSPC.  Plus we allocate chunks in
order to alleviate the pressure, but this doesn't actually help us since we
only use the non-allocated area in our over commit logic.

So instead of basing overcommit on the amount of non-allocated space,
instead just do it based on how much total space we have, and then limit it
to the non-allocated space in case we are short on space to spill over into.
This allows us to have the same performance as well as no longer giving
random ENOSPC.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 11ffa16..981130b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3677,6 +3677,7 @@ static int can_overcommit(struct btrfs_root *root,
 	u64 rsv_size = 0;
 	u64 avail;
 	u64 used;
+	u64 to_add;
 
 	used = space_info->bytes_used + space_info->bytes_reserved +
 		space_info->bytes_pinned + space_info->bytes_readonly;
@@ -3710,17 +3711,25 @@ static int can_overcommit(struct btrfs_root *root,
 		       BTRFS_BLOCK_GROUP_RAID10))
 		avail >>= 1;
 
+	to_add = space_info->total_bytes;
+
 	/*
 	 * If we aren't flushing all things, let us overcommit up to
 	 * 1/2th of the space. If we can flush, don't let us overcommit
 	 * too much, let it overcommit up to 1/8 of the space.
 	 */
 	if (flush == BTRFS_RESERVE_FLUSH_ALL)
-		avail >>= 3;
+		to_add >>= 3;
 	else
-		avail >>= 1;
+		to_add >>= 1;
+
+	/*
+	 * Limit the overcommit to the amount of free space we could possibly
+	 * allocate for chunks.
+	 */
+	to_add = min(avail, to_add);
 
-	if (used + bytes < space_info->total_bytes + avail)
+	if (used + bytes < space_info->total_bytes + to_add)
 		return 1;
 	return 0;
 }
-- 
1.7.7.6

