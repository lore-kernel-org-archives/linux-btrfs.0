Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.microon.de ([37.252.125.21]:37986 "EHLO gattino.microon.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751155Ab3KDVg7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 16:36:59 -0500
From: Valentina Giusti <valentina.giusti@microon.de>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/9] btrfs: remove unused variable from find_free_extent
Date: Mon,  4 Nov 2013 22:34:24 +0100
Message-Id: <1383600869-10085-5-git-send-email-valentina.giusti@microon.de>
In-Reply-To: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
References: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The variable found_uncached_bg in find_free_extent is not used since commit
285ff5af6ce358e73f53b55c9efadd4335f4c2ff
(Btrfs: remove the ideal caching code)

Signed-off-by: Valentina Giusti <valentina.giusti@microon.de>
---
 fs/btrfs/extent-tree.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d58bef1..a6e2e33 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6131,7 +6131,6 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
 	int index = __get_raid_index(flags);
 	int alloc_type = (flags & BTRFS_BLOCK_GROUP_DATA) ?
 		RESERVE_ALLOC_NO_ACCOUNT : RESERVE_ALLOC;
-	bool found_uncached_bg = false;
 	bool failed_cluster_refill = false;
 	bool failed_alloc = false;
 	bool use_cluster = true;
@@ -6249,7 +6248,6 @@ search:
 have_block_group:
 		cached = block_group_cache_done(block_group);
 		if (unlikely(!cached)) {
-			found_uncached_bg = true;
 			ret = cache_block_group(block_group, 0);
 			BUG_ON(ret < 0);
 			ret = 0;
-- 
1.7.10.4

