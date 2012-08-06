Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:38478 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab2HFTle (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Aug 2012 15:41:34 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id 5EB7CJhT3Gy3HAoh (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 06 Aug 2012 13:41:33 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: increase the size of the free space cache
Date: Mon, 6 Aug 2012 15:46:38 -0400
Message-ID: <1344282398-1453-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Arne was complaining about the space cache having mismatching generation
numbers when debugging a deadlock.  This is because we can run out of space
in our preallocated range for our space cache if you have a pretty
fragmented amount of space in your pinned space.  So just increase the
amount of space we preallocate for space cache so we can be sure to have
enough space.  This will only really affect data ranges since their the only
chunks that end up larger than 256MB.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 45c69c4..55d33b8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3007,17 +3007,16 @@ again:
 	}
 	spin_unlock(&block_group->lock);
 
-	num_pages = (int)div64_u64(block_group->key.offset, 1024 * 1024 * 1024);
+	/*
+	 * Try to preallocate enough space based on how big the block group is.
+	 * Keep in mind this has to include any pinned space which could end up
+	 * taking up quite a bit since it's not folded into the other space
+	 * cache.
+	 */
+	num_pages = (int)div64_u64(block_group->key.offset, 256 * 1024 * 1024);
 	if (!num_pages)
 		num_pages = 1;
 
-	/*
-	 * Just to make absolutely sure we have enough space, we're going to
-	 * preallocate 12 pages worth of space for each block group.  In
-	 * practice we ought to use at most 8, but we need extra space so we can
-	 * add our header and have a terminator between the extents and the
-	 * bitmaps.
-	 */
 	num_pages *= 16;
 	num_pages *= PAGE_CACHE_SIZE;
 
-- 
1.7.7.6

