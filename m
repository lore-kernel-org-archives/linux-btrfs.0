Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:55829 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047AbaLJNO5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 08:14:57 -0500
Received: from /spool/local
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 10 Dec 2014 18:44:55 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 49F18E0056
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 18:45:29 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sBADF4kO46923978
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 18:45:04 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sBADEp9Q000703
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 18:44:52 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [RFC PATCH V10 19/19] Btrfs: subpagesize-blocksize: btrfs_submit_direct_hook: Handle map_length < bio vector length
Date: Wed, 10 Dec 2014 18:44:21 +0530
Message-Id: <1418217261-17273-20-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1418217261-17273-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1418217261-17273-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpagesize-blocksize scenario, map_length can be less than the length of a
bio vector. Such a condition may cause btrfs_submit_direct_hook() to submit a
zero length bio. Fix this.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b236417..0f59c6c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7346,9 +7346,11 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	u64 file_offset = dip->logical_offset;
 	u64 submit_len = 0;
 	u64 map_length;
-	int nr_pages = 0;
+	u32 blocksize = root->sectorsize;
 	int ret = 0;
 	int async_submit = 0;
+	int nr_sectors;
+	int i;
 
 	map_length = orig_bio->bi_iter.bi_size;
 	ret = btrfs_map_block(root->fs_info, rw, start_sector << 9,
@@ -7378,9 +7380,12 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	atomic_inc(&dip->pending_bios);
 
 	while (bvec <= (orig_bio->bi_io_vec + orig_bio->bi_vcnt - 1)) {
-		if (unlikely(map_length < submit_len + bvec->bv_len ||
-		    bio_add_page(bio, bvec->bv_page, bvec->bv_len,
-				 bvec->bv_offset) < bvec->bv_len)) {
+		nr_sectors = bvec->bv_len >> inode->i_sb->s_blocksize_bits;
+		i = 0;
+next_block:
+		if (unlikely(map_length < submit_len + blocksize ||
+		    bio_add_page(bio, bvec->bv_page, blocksize,
+			    bvec->bv_offset + (i * blocksize)) < blocksize)) {
 			/*
 			 * inc the count before we submit the bio so
 			 * we know the end IO handler won't happen before
@@ -7401,7 +7406,6 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 			file_offset += submit_len;
 
 			submit_len = 0;
-			nr_pages = 0;
 
 			bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev,
 						  start_sector, GFP_NOFS);
@@ -7418,9 +7422,14 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
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

