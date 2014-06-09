Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50751 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbaFIDFB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Jun 2014 23:05:01 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s59350LN026523
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Jun 2014 03:05:01 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s5934xiY017177
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Jun 2014 03:05:00 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s5934wYI001005
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Jun 2014 03:04:59 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] Btrfs: fix leaf corruption after __btrfs_drop_extents
Date: Mon,  9 Jun 2014 11:04:49 +0800
Message-Id: <1402283089-10416-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Several reports about leaf corruption has been floating on the list, one of them
points to __btrfs_drop_extents(), and we find that the leaf becomes corrupted
after __btrfs_drop_extents(), it's really a rare case but it does exist.

The problem turns out to be btrfs_next_leaf() called in __btrfs_drop_extents().

So in btrfs_next_leaf(), we release the current path to re-search the last key of
the leaf for locating next leaf, and we've taken it into account that there might
be balance operations between leafs during this 'unlock and re-lock' dance, so
we check the path again and advance it if there are now more items available.
But things are a bit different if that last key happens to be removed and balance
gets a bigger key as the last one, and btrfs_search_slot will return it with
ret > 0, IOW, nothing change in this leaf except the new last key, then we think
we're okay because there is no more item balanced in, fine, we thinks we can
go to the next leaf.

However, we should return that bigger key, otherwise we deserve leaf corruption,
for example, in endio, skipping that key means that __btrfs_drop_extents() thinks
it has dropped all extent matched the required range and finish_ordered_io can
safely insert a new extent, but it actually doesn't and ends up a leaf
corruption.

One may be asking that why our locking on extent io tree doesn't work as
expected, ie. it should avoid this kind of race situation.  But in
__btrfs_drop_extents(), we don't always find extents which are included within
our locking range, IOW, extents can start before our searching start, in this
case locking on extent io tree doesn't protect us from the race.

This takes the special case into account.

Reviewed-by: Filipe Manana <fdmanana@gmail.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: 
   Put an explanation about locking on extent io tree not helping avoid the race
   into the commit log.  And a Reviewed-by tag.

 fs/btrfs/ctree.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 1bcfcdb..bbb256c 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5736,6 +5736,24 @@ again:
 		ret = 0;
 		goto done;
 	}
+	/*
+	 * So the above check misses one case:
+	 * - after releasing the path above, someone has removed the item that
+	 *   used to be at the very end of the block, and balance between leafs
+	 *   gets another one with bigger key.offset to replace it.
+	 *
+	 * This one should be returned as well, or we can get leaf corruption
+	 * later(esp. in __btrfs_drop_extents()).
+	 *
+	 * And a bit more explanation about this check,
+	 * with ret > 0, the key isn't found, the path points to the slot
+	 * where it should be inserted, so the path->slots[0] item must be the
+	 * bigger one.
+	 */
+	if (nritems > 0 && ret > 0 && path->slots[0] == nritems - 1) {
+		ret = 0;
+		goto done;
+	}
 
 	while (level < BTRFS_MAX_LEVEL) {
 		if (!path->nodes[level]) {
-- 
1.8.1.4

