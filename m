Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50096 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdHRS7l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 14:59:41 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7IIxfFk029125
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 18:59:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7IIxe5i004463
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 18:59:40 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7IIxea8031386
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 18:59:40 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove unnecessary skip_sum
Date: Fri, 18 Aug 2017 11:58:04 -0600
Message-Id: <20170818175804.29677-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that we can get inode from dip->inode, it's not necessary to pass
skip_sum from callers.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f4a48d8..91e701c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8424,8 +8424,7 @@ static inline blk_status_t btrfs_lookup_and_bind_dio_csum(struct inode *inode,
 }
 
 static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
-					 u64 file_offset, int skip_sum,
-					 int async_submit)
+					 u64 file_offset, int async_submit)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_dio_private *dip = bio->bi_private;
@@ -8443,7 +8442,7 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 			goto err;
 	}
 
-	if (skip_sum)
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
 		goto map;
 
 	if (write && async_submit) {
@@ -8473,8 +8472,7 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 	return ret;
 }
 
-static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
-				    int skip_sum)
+static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip)
 {
 	struct inode *inode = dip->inode;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
@@ -8537,7 +8535,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 		 */
 		atomic_inc(&dip->pending_bios);
 
-		ret = __btrfs_submit_dio_bio(bio, inode, file_offset, skip_sum,
+		ret = __btrfs_submit_dio_bio(bio, inode, file_offset,
 					     async_submit);
 		if (ret) {
 			bio_put(bio);
@@ -8557,8 +8555,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 	} while (submit_len > 0);
 
 submit:
-	ret = __btrfs_submit_dio_bio(bio, inode, file_offset, skip_sum,
-				     async_submit);
+	ret = __btrfs_submit_dio_bio(bio, inode, file_offset, async_submit);
 	if (!ret)
 		return 0;
 
@@ -8583,12 +8580,9 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 	struct btrfs_dio_private *dip = NULL;
 	struct bio *bio = NULL;
 	struct btrfs_io_bio *io_bio;
-	int skip_sum;
 	bool write = (bio_op(dio_bio) == REQ_OP_WRITE);
 	int ret = 0;
 
-	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
-
 	bio = btrfs_bio_clone(dio_bio);
 
 	dip = kzalloc(sizeof(*dip), GFP_NOFS);
@@ -8631,7 +8625,7 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 			dio_data->unsubmitted_oe_range_end;
 	}
 
-	ret = btrfs_submit_direct_hook(dip, skip_sum);
+	ret = btrfs_submit_direct_hook(dip);
 	if (!ret)
 		return;
 
-- 
2.9.4

