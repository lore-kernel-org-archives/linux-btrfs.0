Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33099 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681AbbCQPDz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 11:03:55 -0400
Received: from pps.filterd (m0004347 [127.0.0.1])
	by m0004347.ppops.net (8.14.5/8.14.5) with SMTP id t2HEpM1r006478
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 08:03:54 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0004347.ppops.net with ESMTP id 1t6nck06n3-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 08:03:54 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: account merges properly
Date: Tue, 17 Mar 2015 11:03:51 -0400
Message-ID: <1426604631-7412-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My fix

Btrfs: fix merge delalloc logic

only fixed half of the problems, it didn't fix the case where we have two large
extents on either side and then join them together with a new small extent.  We
need to instead keep track of how many extents we have accounted for with each
side of the new extent, and then see how many extents we need for the new large
extent.  If they match then we know we need to keep our reservation, otherwise
we need to drop our reservation.  This shows up with a case like this

[BTRFS_MAX_EXTENT_SIZE+4K][4K HOLE][BTRFS_MAX_EXTENT_SIZE+4K]

Previously the logic would have said that the number extents required for the
new size (3) is larger than the number of extents required for the largest side
(2) therefore we need to keep our reservation.  But this isn't the case, since
both sides require a reservation of 2 which leads to 4 for the whole range
currently reserved, but we only need 3, so we need to drop one of the
reservations.  This fixes the last accounting problem.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
-Same as the v2 of "Btrfs: fix merge delalloc logic" except it was rebased onto
Chris's integration branch as an incremental to keep the history clean.

 fs/btrfs/inode.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 97b601b..af4a492 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1591,9 +1591,6 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 	if (!(other->state & EXTENT_DELALLOC))
 		return;
 
-	old_size = other->end - other->start + 1;
-	if (old_size < (new->end - new->start + 1))
-		old_size = (new->end - new->start + 1);
 	if (new->start > other->start)
 		new_size = new->end - other->start + 1;
 	else
@@ -1608,13 +1605,32 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 	}
 
 	/*
-	 * If we grew by another max_extent, just return, we want to keep that
-	 * reserved amount.
+	 * We have to add up either side to figure out how many extents were
+	 * accounted for before we merged into one big extent.  If the number of
+	 * extents we accounted for is <= the amount we need for the new range
+	 * then we can return, otherwise drop.  Think of it like this
+	 *
+	 * [ 4k][MAX_SIZE]
+	 *
+	 * So we've grown the extent by a MAX_SIZE extent, this would mean we
+	 * need 2 outstanding extents, on one side we have 1 and the other side
+	 * we have 1 so they are == and we can return.  But in this case
+	 *
+	 * [MAX_SIZE+4k][MAX_SIZE+4k]
+	 *
+	 * Each range on their own accounts for 2 extents, but merged together
+	 * they are only 3 extents worth of accounting, so we need to drop in
+	 * this case.
 	 */
+	old_size = other->end - other->start + 1;
 	num_extents = div64_u64(old_size + BTRFS_MAX_EXTENT_SIZE - 1,
 				BTRFS_MAX_EXTENT_SIZE);
+	old_size = new->end - new->start + 1;
+	num_extents += div64_u64(old_size + BTRFS_MAX_EXTENT_SIZE - 1,
+				 BTRFS_MAX_EXTENT_SIZE);
+
 	if (div64_u64(new_size + BTRFS_MAX_EXTENT_SIZE - 1,
-		      BTRFS_MAX_EXTENT_SIZE) > num_extents)
+		      BTRFS_MAX_EXTENT_SIZE) >= num_extents)
 		return;
 
 	spin_lock(&BTRFS_I(inode)->lock);
-- 
1.8.3.1

