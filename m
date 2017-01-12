Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:31904 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750850AbdALQKB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 11:10:01 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0CG9nUa010774
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 16:09:50 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] Btrfs: clean up btrfs_ordered_update_i_size
Date: Thu, 12 Jan 2017 08:16:17 -0800
Message-Id: <1484237777-19389-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we have a good helper entry_end, use it for ordered extent.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2:
Remove 'ASSERT' that is not true anymore after patch
"Btrfs: fix btrfs_ordered_update_i_size to update disk_i_size properly"

 fs/btrfs/ordered-data.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 35277c5..aead604 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -1040,25 +1040,25 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 		/* We treat this entry as if it doesn't exist */
 		if (test_bit(BTRFS_ORDERED_UPDATED_ISIZE, &test->flags))
 			continue;
-		if (test->file_offset + test->len <= disk_i_size)
+
+		if (entry_end(test) <= disk_i_size)
 			break;
 		if (test->file_offset >= i_size)
 			break;
-		if (entry_end(test) > disk_i_size) {
-			/*
-			 * we don't update disk_i_size now, so record this
-			 * undealt i_size. Or we will not know the real
-			 * i_size.
-			 */
-			if (test->outstanding_isize < offset)
-				test->outstanding_isize = offset;
-			if (ordered &&
-			    ordered->outstanding_isize >
-			    test->outstanding_isize)
-				test->outstanding_isize =
-						ordered->outstanding_isize;
-			goto out;
-		}
+
+		/*
+		 * we don't update disk_i_size now, so record this
+		 * undealt i_size. Or we will not know the real
+		 * i_size.
+		 */
+		if (test->outstanding_isize < offset)
+			test->outstanding_isize = offset;
+		if (ordered &&
+		    ordered->outstanding_isize >
+		    test->outstanding_isize)
+			test->outstanding_isize =
+					ordered->outstanding_isize;
+		goto out;
 	}
 	new_i_size = min_t(u64, offset, i_size);
 
-- 
2.5.5

