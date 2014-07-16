Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44620 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965331AbaGPOrp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 10:47:45 -0400
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 17 Jul 2014 00:47:44 +1000
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [9.190.235.152])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 12688357805B
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 00:47:41 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6GEOvnS2818498
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 00:24:57 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6GEleYK007611
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 00:47:40 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V4 08/12] Btrfs: subpagesize-blocksize: Compute and look up csums based on sectorsized blocks.
Date: Wed, 16 Jul 2014 20:16:06 +0530
Message-Id: <1405521970-8119-9-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1405521970-8119-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1405521970-8119-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Checksums are applicable to sectorsize units. The current code uses
bio->bv_len units to compute and look up checksums. This works on machines
where sectorsize == PAGE_CACHE_SIZE. This patch makes the checksum
computation and look up code to work with sectorsize units.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/file-item.c | 85 ++++++++++++++++++++++++++++++++--------------------
 fs/btrfs/inode.c     | 24 ++++++++++-----
 2 files changed, 68 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 9d84658..16deb87 100644
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
 	disk_bytenr = (u64)bio->bi_sector << 9;
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
+
 		while (count--) {
-			disk_bytenr += bvec->bv_len;
-			offset += bvec->bv_len;
-			bio_index++;
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
@@ -468,41 +479,49 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
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
 
-			bytes_left = bio->bi_size - total_bytes;
+		nr_sectors = (bvec->bv_len + root->sectorsize - 1)
+			>> root->fs_info->sb->s_blocksize_bits;
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
+				bytes_left = bio->bi_size - total_bytes;
+
+				sums = kzalloc(btrfs_ordered_sum_size(root, bytes_left),
+					GFP_NOFS);
+				BUG_ON(!sums); /* -ENOMEM */
+				sums->len = bytes_left;
+				ordered = btrfs_lookup_ordered_extent(inode, offset);
+				BUG_ON(!ordered); /* Logic error */
+				sums->bytenr = ((u64)bio->bi_sector << 9) +
+					total_bytes;
+				index = 0;
+			}
 
-			sums = kzalloc(btrfs_ordered_sum_size(root, bytes_left),
-				       GFP_NOFS);
-			BUG_ON(!sums); /* -ENOMEM */
-			sums->len = bytes_left;
-			ordered = btrfs_lookup_ordered_extent(inode, offset);
-			BUG_ON(!ordered); /* Logic error */
-			sums->bytenr = ((u64)bio->bi_sector << 9) +
-				       total_bytes;
-			index = 0;
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
index 42ab0e4..c755e1c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2824,7 +2824,9 @@ static int btrfs_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	char *kaddr;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u32 csum_expected;
-	u32 csum = ~(u32)0;
+	u32 csum;
+	int nr_sectors;
+	int i;
 	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
 	                              DEFAULT_RATELIMIT_BURST);
 
@@ -2843,14 +2845,20 @@ static int btrfs_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 		return 0;
 	}
 
-	phy_offset >>= inode->i_sb->s_blocksize_bits;
-	csum_expected = *(((u32 *)io_bio->csum) + phy_offset);
-
 	kaddr = kmap_atomic(page);
-	csum = btrfs_csum_data(kaddr + offset, csum,  end - start + 1);
-	btrfs_csum_final(csum, (char *)&csum);
-	if (csum != csum_expected)
-		goto zeroit;
+	nr_sectors = (end - start + 1) >> root->fs_info->sb->s_blocksize_bits;
+	for (i = 0; i < nr_sectors; i++) {
+		csum = ~(u32)0;
+		phy_offset >>= inode->i_sb->s_blocksize_bits;
+		csum_expected = *(((u32 *)io_bio->csum) + phy_offset);
+		csum = btrfs_csum_data(kaddr + offset, csum, root->sectorsize);
+		btrfs_csum_final(csum, (char *)&csum);
+		if (csum != csum_expected)
+			goto zeroit;
+		phy_offset += root->sectorsize;
+		offset += root->sectorsize;
+	}
+
 
 	kunmap_atomic(kaddr);
 good:
-- 
1.8.3.1

