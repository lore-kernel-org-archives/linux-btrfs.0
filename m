Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56910 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754324AbbCQUiL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 16:38:11 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t2HKYEqk032552
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 13:38:10 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1t6tm688aq-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 13:38:10 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/4] Btrfs: account merges/splits properly
Date: Tue, 17 Mar 2015 16:38:00 -0400
Message-ID: <1426624683-3085-2-git-send-email-jbacik@fb.com>
In-Reply-To: <1426624683-3085-1-git-send-email-jbacik@fb.com>
References: <1426624683-3085-1-git-send-email-jbacik@fb.com>
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
reservations.  The same problem existed for splits, we'd think we only need 3
extents when creating the hole but in reality we need 4.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/inode.c | 57 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 97b601b..bb74a41 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1542,30 +1542,17 @@ static void btrfs_split_extent_hook(struct inode *inode,
 		u64 new_size;
 
 		/*
-		 * We need the largest size of the remaining extent to see if we
-		 * need to add a new outstanding extent.  Think of the following
-		 * case
-		 *
-		 * [MEAX_EXTENT_SIZEx2 - 4k][4k]
-		 *
-		 * The new_size would just be 4k and we'd think we had enough
-		 * outstanding extents for this if we only took one side of the
-		 * split, same goes for the other direction.  We need to see if
-		 * the larger size still is the same amount of extents as the
-		 * original size, because if it is we need to add a new
-		 * outstanding extent.  But if we split up and the larger size
-		 * is less than the original then we are good to go since we've
-		 * already accounted for the extra extent in our original
-		 * accounting.
+		 * See the explanation in btrfs_merge_extent_hook, the same
+		 * applies here, just in reverse.
 		 */
 		new_size = orig->end - split + 1;
-		if ((split - orig->start) > new_size)
-			new_size = split - orig->start;
-
-		num_extents = div64_u64(size + BTRFS_MAX_EXTENT_SIZE - 1,
+		num_extents = div64_u64(new_size + BTRFS_MAX_EXTENT_SIZE - 1,
 					BTRFS_MAX_EXTENT_SIZE);
-		if (div64_u64(new_size + BTRFS_MAX_EXTENT_SIZE - 1,
-			      BTRFS_MAX_EXTENT_SIZE) < num_extents)
+		new_size = split - orig->start;
+		num_extents += div64_u64(new_size + BTRFS_MAX_EXTENT_SIZE - 1,
+					BTRFS_MAX_EXTENT_SIZE);
+		if (div64_u64(size + BTRFS_MAX_EXTENT_SIZE - 1,
+			      BTRFS_MAX_EXTENT_SIZE) >= num_extents)
 			return;
 	}
 
@@ -1591,9 +1578,6 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 	if (!(other->state & EXTENT_DELALLOC))
 		return;
 
-	old_size = other->end - other->start + 1;
-	if (old_size < (new->end - new->start + 1))
-		old_size = (new->end - new->start + 1);
 	if (new->start > other->start)
 		new_size = new->end - other->start + 1;
 	else
@@ -1608,13 +1592,32 @@ static void btrfs_merge_extent_hook(struct inode *inode,
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

