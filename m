Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57530 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756731AbbCMTMu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 15:12:50 -0400
Received: from pps.filterd (m0004347 [127.0.0.1])
	by m0004347.ppops.net (8.14.5/8.14.5) with SMTP id t2DJBrXr006258
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2015 12:12:49 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0004347.ppops.net with ESMTP id 1t45r8g0jf-20
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2015 12:12:49 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: account for the correct number of extents for delalloc reservations
Date: Fri, 13 Mar 2015 15:12:23 -0400
Message-ID: <1426273943-27013-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Direct IO can easily pass in an buffer that is greater than
BTRFS_MAX_EXTENT_SIZE, so take this into account when reserving extents in the
delalloc reservation code.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0e9b3b2..3ac3fef 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5136,7 +5136,11 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	num_bytes = ALIGN(num_bytes, root->sectorsize);
 
 	spin_lock(&BTRFS_I(inode)->lock);
-	BTRFS_I(inode)->outstanding_extents++;
+	nr_extents = (unsigned)div64_u64(num_bytes +
+					 BTRFS_MAX_EXTENT_SIZE - 1,
+					 BTRFS_MAX_EXTENT_SIZE);
+	BTRFS_I(inode)->outstanding_extents += nr_extents;
+	nr_extents = 0;
 
 	if (BTRFS_I(inode)->outstanding_extents >
 	    BTRFS_I(inode)->reserved_extents)
-- 
1.9.3

