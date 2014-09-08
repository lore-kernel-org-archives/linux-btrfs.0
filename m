Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:56779 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbaIHOPK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Sep 2014 10:15:10 -0400
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 8 Sep 2014 19:45:08 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 24A94E0023
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Sep 2014 19:47:30 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay05.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s88EFWUV5767580
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Sep 2014 19:45:32 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s88EF4rF022974
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Sep 2014 19:45:05 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V6 08/15] Btrfs: subpagesize-blocksize: Compute and look up csums based on sectorsized blocks.
Date: Mon,  8 Sep 2014 19:44:19 +0530
Message-Id: <1410185666-23308-9-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1410185666-23308-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1410185666-23308-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Checksums are applicable to sectorsize units. The current code uses
bio->bv_len units to compute and look up checksums. This works on machines
where sectorsize == PAGE_CACHE_SIZE. This patch makes the checksum
computation and look up code to work with sectorsize units.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/file-item.c | 87 ++++++++++++++++++++++++++++++++--------------------
 fs/btrfs/inode.c     | 53 +++++++++++++++++++++-----------
 2 files changed, 89 insertions(+), 51 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 54c84da..000418a 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -172,6 +172,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	u64 item_start_offset = 0;
 	u64 item_last_offset = 0;
 	u64 disk_bytenr;
+	u64 page_bytes_left;
 	u32 diff;
 	int nblocks;
 	int bio_index = 0;
@@ -220,6 +221,8 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	disk_bytenr = (u64)bio->bi_iter.bi_sector << 9;
 	if (dio)
 		offset = logical_offset;
+
+	page_bytes_left = bvec->bv_len;
 	while (bio_index < bio->bi_vcnt) {
 		if (!dio)
 			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
@@ -243,7 +246,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 				if (BTRFS_I(inode)->root->root_key.objectid ==
 				    BTRFS_DATA_RELOC_TREE_OBJECTID) {
 					set_extent_bits(io_tree, offset,
-						offset + bvec->bv_len - 1,
+						offset + root->sectorsize - 1,
 						EXTENT_NODATASUM, GFP_NOFS);
 				} else {
 					btrfs_info(BTRFS_I(inode)->root->fs_info,
@@ -281,11 +284,17 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 found:
 		csum += count * csum_size;
 		nblocks -= count;
-		bio_index += count;
+
 		while (count--) {
-			disk_bytenr += bvec->bv_len;
-			offset += bvec->bv_len;
-			bvec++;
+			disk_bytenr += root->sectorsize;
+			offset += root->sectorsize;
+			page_bytes_left -= root->sectorsize;
+			if (!page_bytes_left) {
+				bio_index++;
+				bvec++;
+				page_bytes_left = bvec->bv_len;
+			}
+
 		}
 	}
 	btrfs_free_path(path);
@@ -442,6 +451,8 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 	struct bio_vec *bvec = bio->bi_io_vec;
 	int bio_index = 0;
 	int index;
+	int nr_sectors;
+	int i;
 	unsigned long total_bytes = 0;
 	unsigned long this_sum_bytes = 0;
 	u64 offset;
@@ -469,41 +480,51 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 		if (!contig)
 			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
 
-		if (offset >= ordered->file_offset + ordered->len ||
-		    offset < ordered->file_offset) {
-			unsigned long bytes_left;
-			sums->len = this_sum_bytes;
-			this_sum_bytes = 0;
-			btrfs_add_ordered_sum(inode, ordered, sums);
-			btrfs_put_ordered_extent(ordered);
+		data = kmap_atomic(bvec->bv_page);
 
-			bytes_left = bio->bi_iter.bi_size - total_bytes;
 
-			sums = kzalloc(btrfs_ordered_sum_size(root, bytes_left),
-				       GFP_NOFS);
-			BUG_ON(!sums); /* -ENOMEM */
-			sums->len = bytes_left;
-			ordered = btrfs_lookup_ordered_extent(inode, offset);
-			BUG_ON(!ordered); /* Logic error */
-			sums->bytenr = ((u64)bio->bi_iter.bi_sector << 9) +
-				       total_bytes;
-			index = 0;
+		nr_sectors = (bvec->bv_len + root->sectorsize - 1)
+			>> root->fs_info->sb->s_blocksize_bits;
+
+
+		for (i = 0; i < nr_sectors; i++) {
+			if (offset >= ordered->file_offset + ordered->len ||
+				offset < ordered->file_offset) {
+				unsigned long bytes_left;
+				sums->len = this_sum_bytes;
+				this_sum_bytes = 0;
+				btrfs_add_ordered_sum(inode, ordered, sums);
+				btrfs_put_ordered_extent(ordered);
+
+				bytes_left = bio->bi_iter.bi_size - total_bytes;
+
+				sums = kzalloc(btrfs_ordered_sum_size(root, bytes_left),
+					GFP_NOFS);
+				BUG_ON(!sums); /* -ENOMEM */
+				sums->len = bytes_left;
+				ordered = btrfs_lookup_ordered_extent(inode, offset);
+				BUG_ON(!ordered); /* Logic error */
+				sums->bytenr = ((u64)bio->bi_iter.bi_sector << 9) +
+					total_bytes;
+				index = 0;
+			}
+
+			sums->sums[index] = ~(u32)0;
+			sums->sums[index]
+				= btrfs_csum_data(data + bvec->bv_offset + (i * root->sectorsize),
+						sums->sums[index],
+						root->sectorsize);
+			btrfs_csum_final(sums->sums[index],
+					(char *)(sums->sums + index));
+			index++;
+			offset += root->sectorsize;
+			this_sum_bytes += root->sectorsize;
+			total_bytes += root->sectorsize;
 		}
 
-		data = kmap_atomic(bvec->bv_page);
-		sums->sums[index] = ~(u32)0;
-		sums->sums[index] = btrfs_csum_data(data + bvec->bv_offset,
-						    sums->sums[index],
-						    bvec->bv_len);
 		kunmap_atomic(data);
-		btrfs_csum_final(sums->sums[index],
-				 (char *)(sums->sums + index));
 
 		bio_index++;
-		index++;
-		total_bytes += bvec->bv_len;
-		this_sum_bytes += bvec->bv_len;
-		offset += bvec->bv_len;
 		bvec++;
 	}
 	this_sum_bytes = 0;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2ffb4df..ae5d459 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7116,37 +7116,54 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct bio *dio_bio;
 	u32 *csums = (u32 *)dip->csum;
+	int index = 0;
+	int nr_sectors;
 	u64 start;
-	int i;
+	int i, j;
+
+	if (err || !(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
+		goto unlock;
 
 	start = dip->logical_offset;
 	bio_for_each_segment_all(bvec, bio, i) {
-		if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
-			struct page *page = bvec->bv_page;
-			char *kaddr;
-			u32 csum = ~(u32)0;
-			unsigned long flags;
+		struct page *page = bvec->bv_page;
+		char *kaddr;
+		u32 csum;
+		unsigned long flags;
+
+		local_irq_save(flags);
+		kaddr = kmap_atomic(page);
+
+		nr_sectors = bvec->bv_len >> inode->i_sb->s_blocksize_bits;
 
-			local_irq_save(flags);
-			kaddr = kmap_atomic(page);
-			csum = btrfs_csum_data(kaddr + bvec->bv_offset,
-					       csum, bvec->bv_len);
+		for (j = 0; j < nr_sectors; j++) {
+			csum = ~(u32)0;
+			csum = btrfs_csum_data(kaddr + bvec->bv_offset
+					+ (root->sectorsize * j),
+					csum, root->sectorsize);
 			btrfs_csum_final(csum, (char *)&csum);
-			kunmap_atomic(kaddr);
-			local_irq_restore(flags);
 
-			flush_dcache_page(bvec->bv_page);
-			if (csum != csums[i]) {
-				btrfs_err(root->fs_info, "csum failed ino %llu off %llu csum %u expected csum %u",
-					  btrfs_ino(inode), start, csum,
-					  csums[i]);
+			if (csum != csums[index]) {
+				btrfs_err(root->fs_info,
+					"csum failed ino %llu off %llu csum %u expected csum %u",
+					btrfs_ino(inode), start, csum,
+					csums[index]);
 				err = -EIO;
+				break;
 			}
+
+			start += root->sectorsize;
+			index++;
 		}
 
-		start += bvec->bv_len;
+		kunmap_atomic(kaddr);
+		local_irq_restore(flags);
+		flush_dcache_page(bvec->bv_page);
+		if (err)
+			break;
 	}
 
+unlock:
 	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
 		      dip->logical_offset + dip->bytes - 1);
 	dio_bio = dip->dio_bio;
-- 
1.8.3.1

