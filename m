Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:60748 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbbJRMGc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Oct 2015 08:06:32 -0400
Received: from /spool/local
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Sun, 18 Oct 2015 22:06:30 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 6B1B42CE8050
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 23:06:28 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9IC6KPp60096524
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 23:06:28 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9IC5sfT029463
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 23:05:56 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V6 08/13] Btrfs: btrfs_submit_direct_hook: Handle map_length < bio vector length
Date: Sun, 18 Oct 2015 17:34:58 +0530
Message-Id: <1445169903-13915-9-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1445169903-13915-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1445169903-13915-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index 8a79e53..1826603 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8150,9 +8150,11 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
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
@@ -8182,9 +8184,12 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
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
@@ -8205,7 +8210,6 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 			file_offset += submit_len;
 
 			submit_len = 0;
-			nr_pages = 0;
 
 			bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev,
 						  start_sector, GFP_NOFS);
@@ -8223,9 +8227,14 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
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

