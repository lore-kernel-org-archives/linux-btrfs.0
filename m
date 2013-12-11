Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:37208 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3LKXk6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 18:40:58 -0500
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <sekharan@us.ibm.com>;
	Wed, 11 Dec 2013 16:40:58 -0700
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 8178E19D803E
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 16:40:49 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08028.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rBBLd2iB7799126
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 22:39:02 +0100
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rBBNetFw031646
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 16:40:56 -0700
From: Chandra Seetharaman <sekharan@us.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 5/7] btrfs: subpagesize-blocksize: handle checksum calculations properly
Date: Wed, 11 Dec 2013 17:38:40 -0600
Message-Id: <1386805122-23972-6-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With subpagesize-blocksize, the IO is done in pages but checksums are
calculated in blocks.

This patch makes sure the checksums are calculated, stored, and verfied
from proper indexes in the page.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/btrfs/file-item.c | 45 ++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/inode.c     | 26 ++++++++++++++++++++------
 2 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 6f38488..d75bda3 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -175,14 +175,16 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	u32 diff;
 	int nblocks;
 	int bio_index = 0;
-	int count;
+	int count, bvec_count;
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
+	unsigned int blocks_per_bvec;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
 	nblocks = bio->bi_size >> inode->i_sb->s_blocksize_bits;
+	blocks_per_bvec =  bvec->bv_len >> inode->i_sb->s_blocksize_bits;
 	if (!dst) {
 		if (nblocks * csum_size > BTRFS_BIO_INLINE_CSUM_SIZE) {
 			btrfs_bio->csum_allocated = kmalloc(nblocks * csum_size,
@@ -221,8 +223,10 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	if (dio)
 		offset = logical_offset;
 	while (bio_index < bio->bi_vcnt) {
+		bvec_count = 0;
 		if (!dio)
 			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+same_bvec:
 		count = btrfs_find_ordered_sum(inode, offset, disk_bytenr,
 					       (u32 *)csum, nblocks);
 		if (count)
@@ -281,12 +285,26 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 found:
 		csum += count * csum_size;
 		nblocks -= count;
-		while (count--) {
+		while (count >= blocks_per_bvec) {
+			count -= blocks_per_bvec;
 			disk_bytenr += bvec->bv_len;
 			offset += bvec->bv_len;
 			bio_index++;
 			bvec++;
 		}
+			
+		if (count) {
+			while (count--) {
+				bvec_count++;
+				disk_bytenr += inode->i_sb->s_blocksize;
+				offset += inode->i_sb->s_blocksize;
+			}
+			if (bvec_count == blocks_per_bvec) {
+				bio_index++;
+				bvec++;
+			} else
+				goto same_bvec;
+		}
 	}
 	btrfs_free_path(path);
 	return 0;
@@ -444,7 +462,8 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 	int index;
 	unsigned long total_bytes = 0;
 	unsigned long this_sum_bytes = 0;
-	u64 offset;
+	u64 offset, pg_offset;
+	size_t csum_size;
 
 	WARN_ON(bio->bi_vcnt <= 0);
 	sums = kzalloc(btrfs_ordered_sum_size(root, bio->bi_size), GFP_NOFS);
@@ -489,17 +508,25 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 			index = 0;
 		}
 
+		if ((inode->i_sb->s_blocksize) < bvec->bv_len)
+			csum_size = inode->i_sb->s_blocksize;
+		else
+			csum_size = bvec->bv_len;
 		data = kmap_atomic(bvec->bv_page);
-		sums->sums[index] = ~(u32)0;
-		sums->sums[index] = btrfs_csum_data(data + bvec->bv_offset,
+		pg_offset = bvec->bv_offset;
+		while (pg_offset < bvec->bv_offset + bvec->bv_len) {
+			sums->sums[index] = ~(u32)0;
+			sums->sums[index] = btrfs_csum_data(data + pg_offset,
 						    sums->sums[index],
-						    bvec->bv_len);
+						    csum_size);
+			btrfs_csum_final(sums->sums[index],
+					(char *)(sums->sums + index));
+			index++;
+			pg_offset += csum_size;
+		}
 		kunmap_atomic(data);
-		btrfs_csum_final(sums->sums[index],
-				 (char *)(sums->sums + index));
 
 		bio_index++;
-		index++;
 		total_bytes += bvec->bv_len;
 		this_sum_bytes += bvec->bv_len;
 		offset += bvec->bv_len;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c0c18ca..a87d0d0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2781,6 +2781,7 @@ static int btrfs_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u32 csum_expected;
 	u32 csum = ~(u32)0;
+	u64 total_len, csum_len, csum_index;
 	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
 	                              DEFAULT_RATELIMIT_BURST);
 
@@ -2799,14 +2800,27 @@ static int btrfs_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 		return 0;
 	}
 
-	phy_offset >>= inode->i_sb->s_blocksize_bits;
-	csum_expected = *(((u32 *)io_bio->csum) + phy_offset);
+	total_len = end - start + 1;
+	if (inode->i_sb->s_blocksize < PAGE_CACHE_SIZE)
+		csum_len = inode->i_sb->s_blocksize;
+	else
+		csum_len = end - start + 1;
+
+	csum_index = phy_offset >> inode->i_sb->s_blocksize_bits;
 
 	kaddr = kmap_atomic(page);
-	csum = btrfs_csum_data(kaddr + offset, csum,  end - start + 1);
-	btrfs_csum_final(csum, (char *)&csum);
-	if (csum != csum_expected)
-		goto zeroit;
+	while (total_len > 0) {
+		csum_expected = *(((u32 *)io_bio->csum) + csum_index);
+		csum = ~(u32)0;
+		csum = btrfs_csum_data(kaddr + offset, csum, csum_len);
+		btrfs_csum_final(csum, (char *)&csum);
+		if (csum != csum_expected)
+			goto zeroit;
+		offset += csum_len;
+		total_len -= csum_len;
+		csum_index += 1;
+		phy_offset += csum_len;
+	}
 
 	kunmap_atomic(kaddr);
 good:
-- 
1.7.12.4

