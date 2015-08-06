Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:37299 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbbHFKME (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Aug 2015 06:12:04 -0400
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 6 Aug 2015 15:42:02 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 60BAD1258018
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2015 15:45:09 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t76ABxVK40697990
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Aug 2015 15:41:59 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t76AAeQa021336
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Aug 2015 15:40:42 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: [PATCH 08/11] Btrfs: btrfs_submit_direct_hook: Handle map_length < bio vector length
Date: Thu,  6 Aug 2015 15:40:16 +0530
Message-Id: <1438855819-4328-9-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1438855819-4328-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1438855819-4328-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpagesize-blocksize scenario, map_length can be less than the length of a
bio vector. Such a condition may cause btrfs_submit_direct_hook() to submit a
zero length bio. Fix this by comparing map_length against block size rather
than with bv_len.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dad76ef..1acee74 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8110,9 +8110,11 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	u64 file_offset = dip->logical_offset;
 	u64 submit_len = 0;
 	u64 map_length;
-	int nr_pages = 0;
-	int ret;
+	u32 blocksize = root->sectorsize;
 	int async_submit = 0;
+	int nr_sectors;
+	int ret;
+	int i;
 
 	map_length = orig_bio->bi_iter.bi_size;
 	ret = btrfs_map_block(root->fs_info, rw, start_sector << 9,
@@ -8142,9 +8144,12 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	atomic_inc(&dip->pending_bios);
 
 	while (bvec <= (orig_bio->bi_io_vec + orig_bio->bi_vcnt - 1)) {
-		if (map_length < submit_len + bvec->bv_len ||
-		    bio_add_page(bio, bvec->bv_page, bvec->bv_len,
-				 bvec->bv_offset) < bvec->bv_len) {
+		nr_sectors = bvec->bv_len >> inode->i_blkbits;
+		i = 0;
+next_block:
+		if (unlikely(map_length < submit_len + blocksize ||
+		    bio_add_page(bio, bvec->bv_page, blocksize,
+			    bvec->bv_offset + (i * blocksize)) < blocksize)) {
 			/*
 			 * inc the count before we submit the bio so
 			 * we know the end IO handler won't happen before
@@ -8165,7 +8170,6 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 			file_offset += submit_len;
 
 			submit_len = 0;
-			nr_pages = 0;
 
 			bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev,
 						  start_sector, GFP_NOFS);
@@ -8183,9 +8187,14 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 				bio_put(bio);
 				goto out_err;
 			}
+
+			goto next_block;
 		} else {
-			submit_len += bvec->bv_len;
-			nr_pages++;
+			submit_len += blocksize;
+			if (--nr_sectors) {
+				i++;
+				goto next_block;
+			}
 			bvec++;
 		}
 	}
-- 
2.1.0

