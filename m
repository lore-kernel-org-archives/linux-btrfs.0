Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59286 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbbFAPY7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 11:24:59 -0400
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 2 Jun 2015 01:24:58 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 4327F2BB004D
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2015 01:24:55 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t51FOlNv54460636
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Jun 2015 01:24:55 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t51FOMdk027966
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Jun 2015 01:24:22 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, bo.li.liu@oracle.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [RFC PATCH V11 18/21] Btrfs: subpagesize-blocksize: btrfs_submit_direct_hook: Handle map_length < bio vector length
Date: Mon,  1 Jun 2015 20:52:53 +0530
Message-Id: <1433172176-8742-19-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpagesize-blocksize scenario, map_length can be less than the length of a
bio vector. Such a condition may cause btrfs_submit_direct_hook() to submit a
zero length bio. Fix this.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 03faff0..1684339 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8193,9 +8193,11 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
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
@@ -8225,9 +8227,12 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	atomic_inc(&dip->pending_bios);
 
 	while (bvec <= (orig_bio->bi_io_vec + orig_bio->bi_vcnt - 1)) {
-		if (map_length < submit_len + bvec->bv_len ||
-		    bio_add_page(bio, bvec->bv_page, bvec->bv_len,
-				 bvec->bv_offset) < bvec->bv_len) {
+		nr_sectors = bvec->bv_len >> inode->i_sb->s_blocksize_bits;
+		i = 0;
+next_block:
+		if (unlikely(map_length < submit_len + blocksize ||
+		    bio_add_page(bio, bvec->bv_page, blocksize,
+			    bvec->bv_offset + (i * blocksize)) < blocksize)) {
 			/*
 			 * inc the count before we submit the bio so
 			 * we know the end IO handler won't happen before
@@ -8248,7 +8253,6 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 			file_offset += submit_len;
 
 			submit_len = 0;
-			nr_pages = 0;
 
 			bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev,
 						  start_sector, GFP_NOFS);
@@ -8266,9 +8270,14 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
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

