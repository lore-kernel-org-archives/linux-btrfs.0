Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37378 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753004AbaG2JW0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 05:22:26 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6T9MM9u002825
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 17:22:22 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 02/12] Btrfs: load checksum data once when submitting a direct read io
Date: Tue, 29 Jul 2014 17:24:00 +0800
Message-ID: <1406625850-32168-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1406625850-32168-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1406625850-32168-1-git-send-email-miaox@cn.fujitsu.com>

The current code would load checksum data for several times when we split
a whole direct read io because of the limit of the raid stripe, it would
make us search the csum tree for several times. In fact, it just wasted time,
and made the contention of the csum tree root be more serious. This patch
improves this problem by loading the data at once.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- Remove the __GFP_ZERO flag in btrfs_submit_direct because it would trigger
  a WARNing. It is reported by Filipe David Manana, Thanks.
---
 fs/btrfs/btrfs_inode.h |  1 -
 fs/btrfs/ctree.h       |  3 +--
 fs/btrfs/extent_io.c   | 13 +++++++++++--
 fs/btrfs/file-item.c   | 14 ++------------
 fs/btrfs/inode.c       | 38 +++++++++++++++++++++-----------------
 5 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index a0cf3e5..b69bf7e 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -263,7 +263,6 @@ struct btrfs_dio_private {
 
 	/* dio_bio came from fs/direct-io.c */
 	struct bio *dio_bio;
-	u8 csum[0];
 };
 
 /*
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index be91397..40e9938 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3739,8 +3739,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
 			  struct bio *bio, u32 *dst);
 int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
-			      struct btrfs_dio_private *dip, struct bio *bio,
-			      u64 logical_offset);
+			      struct bio *bio, u64 logical_offset);
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     u64 objectid, u64 pos,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 23398ad..0fb63c4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2617,9 +2617,18 @@ btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 
 struct bio *btrfs_bio_clone(struct bio *bio, gfp_t gfp_mask)
 {
-	return bio_clone_bioset(bio, gfp_mask, btrfs_bioset);
-}
+	struct btrfs_io_bio *btrfs_bio;
+	struct bio *new;
 
+	new = bio_clone_bioset(bio, gfp_mask, btrfs_bioset);
+	if (new) {
+		btrfs_bio = btrfs_io_bio(new);
+		btrfs_bio->csum = NULL;
+		btrfs_bio->csum_allocated = NULL;
+		btrfs_bio->end_io = NULL;
+	}
+	return bio;
+}
 
 /* this also allocates from the btrfs_bioset */
 struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index f46cfe4..cf1b94f 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -299,19 +299,9 @@ int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
 }
 
 int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
-			      struct btrfs_dio_private *dip, struct bio *bio,
-			      u64 offset)
+			      struct bio *bio, u64 offset)
 {
-	int len = (bio->bi_iter.bi_sector << 9) - dip->disk_bytenr;
-	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
-	int ret;
-
-	len >>= inode->i_sb->s_blocksize_bits;
-	len *= csum_size;
-
-	ret = __btrfs_lookup_bio_sums(root, inode, bio, offset,
-				      (u32 *)(dip->csum + len), 1);
-	return ret;
+	return __btrfs_lookup_bio_sums(root, inode, bio, offset, NULL, 1);
 }
 
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 548489e..fd88126 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7081,7 +7081,8 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 	struct inode *inode = dip->inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct bio *dio_bio;
-	u32 *csums = (u32 *)dip->csum;
+	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+	u32 *csums = (u32 *)io_bio->csum;
 	u64 start;
 	int i;
 
@@ -7123,6 +7124,9 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 	if (err)
 		clear_bit(BIO_UPTODATE, &dio_bio->bi_flags);
 	dio_end_io(dio_bio, err);
+
+	if (io_bio->end_io)
+		io_bio->end_io(io_bio, err);
 	bio_put(bio);
 }
 
@@ -7261,13 +7265,20 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 		ret = btrfs_csum_one_bio(root, inode, bio, file_offset, 1);
 		if (ret)
 			goto err;
-	} else if (!skip_sum) {
-		ret = btrfs_lookup_bio_sums_dio(root, inode, dip, bio,
+	} else {
+		/*
+		 * We have loaded all the csum data we need when we submit
+		 * the first bio, so skip it.
+		 */
+		if (dip->logical_offset != file_offset)
+			goto map;
+
+		/* Load all csum data at once. */
+		ret = btrfs_lookup_bio_sums_dio(root, inode, dip->orig_bio,
 						file_offset);
 		if (ret)
 			goto err;
 	}
-
 map:
 	ret = btrfs_map_bio(root, rw, bio, 0, async_submit);
 err:
@@ -7288,7 +7299,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	u64 submit_len = 0;
 	u64 map_length;
 	int nr_pages = 0;
-	int ret = 0;
+	int ret;
 	int async_submit = 0;
 
 	map_length = orig_bio->bi_iter.bi_size;
@@ -7392,11 +7403,10 @@ static void btrfs_submit_direct(int rw, struct bio *dio_bio,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_dio_private *dip;
 	struct bio *io_bio;
+	struct btrfs_io_bio *btrfs_bio;
 	int skip_sum;
-	int sum_len;
 	int write = rw & REQ_WRITE;
 	int ret = 0;
-	u16 csum_size;
 
 	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
@@ -7406,16 +7416,7 @@ static void btrfs_submit_direct(int rw, struct bio *dio_bio,
 		goto free_ordered;
 	}
 
-	if (!skip_sum && !write) {
-		csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
-		sum_len = dio_bio->bi_iter.bi_size >>
-			inode->i_sb->s_blocksize_bits;
-		sum_len *= csum_size;
-	} else {
-		sum_len = 0;
-	}
-
-	dip = kmalloc(sizeof(*dip) + sum_len, GFP_NOFS);
+	dip = kmalloc(sizeof(*dip), GFP_NOFS);
 	if (!dip) {
 		ret = -ENOMEM;
 		goto free_io_bio;
@@ -7441,6 +7442,9 @@ static void btrfs_submit_direct(int rw, struct bio *dio_bio,
 	if (!ret)
 		return;
 
+	btrfs_bio = btrfs_io_bio(io_bio);
+	if (btrfs_bio->end_io)
+		btrfs_bio->end_io(btrfs_bio, ret);
 free_io_bio:
 	bio_put(io_bio);
 
-- 
1.9.3

