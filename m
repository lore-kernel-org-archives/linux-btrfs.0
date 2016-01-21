Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58323 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759273AbcAUK1S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 05:27:18 -0500
Received: from localhost
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 21 Jan 2016 20:27:15 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id A10913578057
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:27:13 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u0LAQhs127197542
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:26:51 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u0LAQeLO014377
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:26:41 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: [PATCH V10 08/12] Btrfs: btrfs_submit_direct_hook: Handle map_length < bio vector length
Date: Thu, 21 Jan 2016 15:56:00 +0530
Message-Id: <1453371964-4917-9-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1453371964-4917-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1453371964-4917-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index d7bcf87..546bdb4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8255,9 +8255,11 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
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
@@ -8287,9 +8289,12 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	atomic_inc(&dip->pending_bios);
 
 	while (bvec <= (orig_bio->bi_io_vec + orig_bio->bi_vcnt - 1)) {
-		if (map_length < submit_len + bvec->bv_len ||
-		    bio_add_page(bio, bvec->bv_page, bvec->bv_len,
-				 bvec->bv_offset) < bvec->bv_len) {
+		nr_sectors = BTRFS_BYTES_TO_BLKS(root->fs_info, bvec->bv_len);
+		i = 0;
+next_block:
+		if (unlikely(map_length < submit_len + blocksize ||
+		    bio_add_page(bio, bvec->bv_page, blocksize,
+			    bvec->bv_offset + (i * blocksize)) < blocksize)) {
 			/*
 			 * inc the count before we submit the bio so
 			 * we know the end IO handler won't happen before
@@ -8310,7 +8315,6 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 			file_offset += submit_len;
 
 			submit_len = 0;
-			nr_pages = 0;
 
 			bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev,
 						  start_sector, GFP_NOFS);
@@ -8328,9 +8332,14 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
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

