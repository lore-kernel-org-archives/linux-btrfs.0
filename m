Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10067 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751462AbaF1Ldd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 07:33:33 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5SBXRDS021013
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 19:33:27 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 03/12] Btrfs: cleanup similar code of the buffered data data check and dio read data check
Date: Sat, 28 Jun 2014 19:34:53 +0800
Message-ID: <1403955302-22396-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
References: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 102 +++++++++++++++++++++++++------------------------------
 1 file changed, 47 insertions(+), 55 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 969fb22..962defb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2830,6 +2830,40 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 	return 0;
 }
 
+static int __readpage_endio_check(struct inode *inode,
+				  struct btrfs_io_bio *io_bio,
+				  int icsum, struct page *page,
+				  int pgoff, u64 start, size_t len)
+{
+	char *kaddr;
+	u32 csum_expected;
+	u32 csum = ~(u32)0;
+	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
+
+	csum_expected = *(((u32 *)io_bio->csum) + icsum);
+
+	kaddr = kmap_atomic(page);
+	csum = btrfs_csum_data(kaddr + pgoff, csum,  len);
+	btrfs_csum_final(csum, (char *)&csum);
+	if (csum != csum_expected)
+		goto zeroit;
+
+	kunmap_atomic(kaddr);
+	return 0;
+zeroit:
+	if (__ratelimit(&_rs))
+		btrfs_info(BTRFS_I(inode)->root->fs_info,
+			   "csum failed ino %llu off %llu csum %u expected csum %u",
+			   btrfs_ino(inode), start, csum, csum_expected);
+	memset(kaddr + pgoff, 1, len);
+	flush_dcache_page(page);
+	kunmap_atomic(kaddr);
+	if (csum_expected == 0)
+		return 0;
+	return -EIO;
+}
+
 /*
  * when reads are done, we need to check csums to verify the data is correct
  * if there's a match, we allow the bio to finish.  If not, the code in
@@ -2842,20 +2876,15 @@ static int btrfs_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	size_t offset = start - page_offset(page);
 	struct inode *inode = page->mapping->host;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
-	char *kaddr;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	u32 csum_expected;
-	u32 csum = ~(u32)0;
-	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
-	                              DEFAULT_RATELIMIT_BURST);
 
 	if (PageChecked(page)) {
 		ClearPageChecked(page);
-		goto good;
+		return 0;
 	}
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
-		goto good;
+		return 0;
 
 	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID &&
 	    test_range_bit(io_tree, start, end, EXTENT_NODATASUM, 1, NULL)) {
@@ -2865,28 +2894,8 @@ static int btrfs_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	}
 
 	phy_offset >>= inode->i_sb->s_blocksize_bits;
-	csum_expected = *(((u32 *)io_bio->csum) + phy_offset);
-
-	kaddr = kmap_atomic(page);
-	csum = btrfs_csum_data(kaddr + offset, csum,  end - start + 1);
-	btrfs_csum_final(csum, (char *)&csum);
-	if (csum != csum_expected)
-		goto zeroit;
-
-	kunmap_atomic(kaddr);
-good:
-	return 0;
-
-zeroit:
-	if (__ratelimit(&_rs))
-		btrfs_info(root->fs_info, "csum failed ino %llu off %llu csum %u expected csum %u",
-			btrfs_ino(page->mapping->host), start, csum, csum_expected);
-	memset(kaddr + offset, 1, end - start + 1);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr);
-	if (csum_expected == 0)
-		return 0;
-	return -EIO;
+	return __readpage_endio_check(inode, io_bio, phy_offset, page, offset,
+				      start, (size_t)(end - start + 1));
 }
 
 struct delayed_iput {
@@ -7079,41 +7088,24 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 	struct btrfs_dio_private *dip = bio->bi_private;
 	struct bio_vec *bvec;
 	struct inode *inode = dip->inode;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct bio *dio_bio;
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
-	u32 *csums = (u32 *)io_bio->csum;
 	u64 start;
+	int ret;
 	int i;
 
+	if (err || (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
+		goto skip_checksum;
+
 	start = dip->logical_offset;
 	bio_for_each_segment_all(bvec, bio, i) {
-		if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
-			struct page *page = bvec->bv_page;
-			char *kaddr;
-			u32 csum = ~(u32)0;
-			unsigned long flags;
-
-			local_irq_save(flags);
-			kaddr = kmap_atomic(page);
-			csum = btrfs_csum_data(kaddr + bvec->bv_offset,
-					       csum, bvec->bv_len);
-			btrfs_csum_final(csum, (char *)&csum);
-			kunmap_atomic(kaddr);
-			local_irq_restore(flags);
-
-			flush_dcache_page(bvec->bv_page);
-			if (csum != csums[i]) {
-				btrfs_err(root->fs_info, "csum failed ino %llu off %llu csum %u expected csum %u",
-					  btrfs_ino(inode), start, csum,
-					  csums[i]);
-				err = -EIO;
-			}
-		}
-
+		ret = __readpage_endio_check(inode, io_bio, i, bvec->bv_page,
+					     0, start, bvec->bv_len);
+		if (ret)
+			err = -EIO;
 		start += bvec->bv_len;
 	}
-
+skip_checksum:
 	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
 		      dip->logical_offset + dip->bytes - 1);
 	dio_bio = dip->dio_bio;
-- 
1.9.3

