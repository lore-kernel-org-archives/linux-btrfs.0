Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19982 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbbAGJVb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jan 2015 04:21:31 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t079LUDa027910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 Jan 2015 09:21:31 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id t079LU3j007543
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 Jan 2015 09:21:30 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id t079LT4V006437
	for <linux-btrfs@vger.kernel.org>; Wed, 7 Jan 2015 09:21:30 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] Btrfs: use asynchronous submit for large DIO io in single profile
Date: Wed,  7 Jan 2015 17:21:12 +0800
Message-Id: <1420622472-9656-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 1ae399382512 ("Btrfs: do not use async submit for small DIO io's")
benefits small DIO io's.

However, if we're owning the SINGLE profile, this also affects large DIO io's
since in that case, map_length is (chunk_length - bio's offset_in_chunk),
it's farily large so that it's very likely to be larger than a large bio's
size, which avoids asynchronous submit.
For instance, if we have a 512k bio, the efforts of calculating (512k/4k=128)
checksums will be taken by the DIO task.

This adds a limit 'BTRFS_STRIPE_LEN' to decide if it's small enough to avoid
asynchronous submit.

Still, in this case we don't need to split the bio and can submit it directly.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e687bb0..c640d7e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7792,6 +7792,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	int nr_pages = 0;
 	int ret;
 	int async_submit = 0;
+	u64 alloc_profile;
 
 	map_length = orig_bio->bi_iter.bi_size;
 	ret = btrfs_map_block(root->fs_info, rw, start_sector << 9,
@@ -7799,15 +7800,26 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	if (ret)
 		return -EIO;
 
+	alloc_profile = btrfs_get_alloc_profile(root, 1);
+
 	if (map_length >= orig_bio->bi_iter.bi_size) {
 		bio = orig_bio;
 		dip->flags |= BTRFS_DIO_ORIG_BIO_SUBMITTED;
+
+		/*
+		 * In the case of 'single' profile, the above check is very
+		 * likely to be true as map_length is (chunk_length - offset),
+		 * so checking BTRFS_STRIPE_LEN here.
+		 */
+		if ((alloc_profile & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
+		    orig_bio->bi_iter.bi_size >= BTRFS_STRIPE_LEN)
+			async_submit = 1;
+
 		goto submit;
 	}
 
 	/* async crcs make it difficult to collect full stripe writes. */
-	if (btrfs_get_alloc_profile(root, 1) &
-	    (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6))
+	if (alloc_profile & (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6))
 		async_submit = 0;
 	else
 		async_submit = 1;
-- 
1.8.1.4

