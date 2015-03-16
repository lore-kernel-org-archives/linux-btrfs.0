Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16816 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933155AbbCPUaz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Mar 2015 16:30:55 -0400
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t2GKRXvl017229
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2015 13:30:54 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1t65a1g8fv-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2015 13:30:54 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix merge delalloc logic V2
Date: Mon, 16 Mar 2015 16:30:50 -0400
Message-ID: <1426537850-24861-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My patch to properly count outstanding extents wrt MAX_EXTENT_SIZE introduced a
regression when joining two large areas.  We need to take into account both
sides of the merge to figure out if we're good with our current
outstanding_extents count or if we need to drop it.  For example if you merge
two slightly larger than MAX_EXTENT size extents the accounting would
incorrectly think we needed 4 outstanding extents when in fact we'd only need 3.
Thanks,

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V1->V2: fixed another corner case where we join two large ranges

 fs/btrfs/inode.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 91a87f5..af4a492 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1591,8 +1591,10 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 	if (!(other->state & EXTENT_DELALLOC))
 		return;
 
-	old_size = other->end - other->start + 1;
-	new_size = old_size + (new->end - new->start + 1);
+	if (new->start > other->start)
+		new_size = new->end - other->start + 1;
+	else
+		new_size = other->end - new->start + 1;
 
 	/* we're not bigger than the max, unreserve the space and go */
 	if (new_size <= BTRFS_MAX_EXTENT_SIZE) {
@@ -1603,13 +1605,32 @@ static void btrfs_merge_extent_hook(struct inode *inode,
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
1.9.3

