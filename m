Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35802 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756794AbbCMTMz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 15:12:55 -0400
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t2DJ8RRa024951
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2015 12:12:55 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1t45feg393-7
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2015 12:12:55 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix merge delalloc logic
Date: Fri, 13 Mar 2015 15:12:08 -0400
Message-ID: <1426273928-26909-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My patch to properly count outstanding extents wrt MAX_EXTENT_SIZE introduced a
regression when re-dirtying already dirty areas.  We have logic in split to make
sure we are taking the largest space into account but didn't have it for merge,
so it was sometimes making us think we were turning a tiny extent into a huge
extent, when in reality we already had a huge extent and needed to use the other
side in our logic.  This fixes the regression that was reported by a user on
list.  Thanks,

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 91a87f5..97b601b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1592,7 +1592,12 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 		return;
 
 	old_size = other->end - other->start + 1;
-	new_size = old_size + (new->end - new->start + 1);
+	if (old_size < (new->end - new->start + 1))
+		old_size = (new->end - new->start + 1);
+	if (new->start > other->start)
+		new_size = new->end - other->start + 1;
+	else
+		new_size = other->end - new->start + 1;
 
 	/* we're not bigger than the max, unreserve the space and go */
 	if (new_size <= BTRFS_MAX_EXTENT_SIZE) {
-- 
1.9.3

