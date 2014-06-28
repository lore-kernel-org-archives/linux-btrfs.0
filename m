Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4680 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751835AbaF1Lde (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 07:33:34 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5SBXSGg021017
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 19:33:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 04/12] Btrfs: do file data check by sub-bio's self
Date: Sat, 28 Jun 2014 19:34:54 +0800
Message-ID: <1403955302-22396-5-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
References: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Direct IO splits the original bio to several sub-bios because of the limit of
raid stripe, and the filesystem will wait for all sub-bios and then run final
end io process.

But it was very hard to implement the data repair when dio read failure happens,
because at the final end io function, we didn't know which mirror the data was
read from. So in order to implement the data repair, we have to move the file data
check in the final end io function to the sub-bio end io function, in which we can
get the mirror number of the device we access. This patch did this work as the
first step of the direct io data repair implementation.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |   9 +++++
 fs/btrfs/extent_io.c   |   2 +-
 fs/btrfs/inode.c       | 100 ++++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/volumes.h     |   5 ++-
 4 files changed, 87 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 7e9f53b..e82014f 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -245,8 +245,11 @@ static inline int btrfs_inode_in_log(struct inode *inode, u64 generation)
 	return 0;
 }
 
+#define BTRFS_DIO_ORIG_BIO_SUBMITTED	0x1
+
 struct btrfs_dio_private {
 	struct inode *inode;
+	unsigned long flags;
 	u64 logical_offset;
 	u64 disk_bytenr;
 	u64 bytes;
@@ -263,6 +266,12 @@ struct btrfs_dio_private {
 
 	/* dio_bio came from fs/direct-io.c */
 	struct bio *dio_bio;
+
+	/*
+	 * The original bio may be splited to several sub-bios, this is
+	 * done during endio of sub-bios
+	 */
+	int (*subio_endio)(struct inode *, struct btrfs_io_bio *);
 };
 
 /*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a389820..5ac43b4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2469,7 +2469,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		struct inode *inode = page->mapping->host;
 
 		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
-			 "mirror=%lu\n", (u64)bio->bi_iter.bi_sector, err,
+			 "mirror=%u\n", (u64)bio->bi_iter.bi_sector, err,
 			 io_bio->mirror_num);
 		tree = &BTRFS_I(inode)->io_tree;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 962defb..8e39645 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7083,29 +7083,40 @@ unlock_err:
 	return ret;
 }
 
-static void btrfs_endio_direct_read(struct bio *bio, int err)
+static int btrfs_subio_endio_read(struct inode *inode,
+				  struct btrfs_io_bio *io_bio)
 {
-	struct btrfs_dio_private *dip = bio->bi_private;
 	struct bio_vec *bvec;
-	struct inode *inode = dip->inode;
-	struct bio *dio_bio;
-	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
 	u64 start;
-	int ret;
 	int i;
+	int ret;
+	int err = 0;
 
-	if (err || (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
-		goto skip_checksum;
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
+		return 0;
 
-	start = dip->logical_offset;
-	bio_for_each_segment_all(bvec, bio, i) {
+	start = io_bio->logical;
+	bio_for_each_segment_all(bvec, &io_bio->bio, i) {
 		ret = __readpage_endio_check(inode, io_bio, i, bvec->bv_page,
 					     0, start, bvec->bv_len);
 		if (ret)
 			err = -EIO;
 		start += bvec->bv_len;
 	}
-skip_checksum:
+
+	return err;
+}
+
+static void btrfs_endio_direct_read(struct bio *bio, int err)
+{
+	struct btrfs_dio_private *dip = bio->bi_private;
+	struct inode *inode = dip->inode;
+	struct bio *dio_bio;
+	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+
+	if (!err && (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED))
+		err = btrfs_subio_endio_read(inode, io_bio);
+
 	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
 		      dip->logical_offset + dip->bytes - 1);
 	dio_bio = dip->dio_bio;
@@ -7182,6 +7193,7 @@ static int __btrfs_submit_bio_start_direct_io(struct inode *inode, int rw,
 static void btrfs_end_dio_bio(struct bio *bio, int err)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
+	int ret;
 
 	if (err) {
 		btrfs_err(BTRFS_I(dip->inode)->root->fs_info,
@@ -7189,6 +7201,13 @@ static void btrfs_end_dio_bio(struct bio *bio, int err)
 		      btrfs_ino(dip->inode), bio->bi_rw,
 		      (unsigned long long)bio->bi_iter.bi_sector,
 		      bio->bi_iter.bi_size, err);
+	} else if (dip->subio_endio) {
+		ret = dip->subio_endio(dip->inode, btrfs_io_bio(bio));
+		if (ret)
+			err = ret;
+	}
+
+	if (err) {
 		dip->errors = 1;
 
 		/*
@@ -7219,6 +7238,38 @@ static struct bio *btrfs_dio_bio_alloc(struct block_device *bdev,
 	return btrfs_bio_alloc(bdev, first_sector, nr_vecs, gfp_flags);
 }
 
+static inline int btrfs_lookup_and_bind_dio_csum(struct btrfs_root *root,
+						 struct inode *inode,
+						 struct btrfs_dio_private *dip,
+						 struct bio *bio,
+						 u64 file_offset)
+{
+	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+	struct btrfs_io_bio *orig_io_bio = btrfs_io_bio(dip->orig_bio);
+	int ret;
+
+	/*
+	 * We load all the csum data we need when we submit
+	 * the first bio to reduce the csum tree search and
+	 * contention.
+	 */
+	if (dip->logical_offset == file_offset) {
+		ret = btrfs_lookup_bio_sums_dio(root, inode, dip->orig_bio,
+						file_offset);
+		if (ret)
+			return ret;
+	}
+
+	if (bio == dip->orig_bio)
+		return 0;
+
+	file_offset -= dip->logical_offset;
+	file_offset >>= inode->i_sb->s_blocksize_bits;
+	io_bio->csum = (u8 *)(((u32 *)orig_io_bio->csum) + file_offset);
+
+	return 0;
+}
+
 static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 					 int rw, u64 file_offset, int skip_sum,
 					 int async_submit)
@@ -7258,16 +7309,8 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 		if (ret)
 			goto err;
 	} else {
-		/*
-		 * We have loaded all the csum data we need when we submit
-		 * the first bio, so skip it.
-		 */
-		if (dip->logical_offset != file_offset)
-			goto map;
-
-		/* Load all csum data at once. */
-		ret = btrfs_lookup_bio_sums_dio(root, inode, dip->orig_bio,
-						file_offset);
+		ret = btrfs_lookup_and_bind_dio_csum(root, inode, dip, bio,
+						     file_offset);
 		if (ret)
 			goto err;
 	}
@@ -7302,6 +7345,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 
 	if (map_length >= orig_bio->bi_iter.bi_size) {
 		bio = orig_bio;
+		dip->flags |= BTRFS_DIO_ORIG_BIO_SUBMITTED;
 		goto submit;
 	}
 
@@ -7318,6 +7362,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 
 	bio->bi_private = dip;
 	bio->bi_end_io = btrfs_end_dio_bio;
+	btrfs_io_bio(bio)->logical = file_offset;
 	atomic_inc(&dip->pending_bios);
 
 	while (bvec <= (orig_bio->bi_io_vec + orig_bio->bi_vcnt - 1)) {
@@ -7352,6 +7397,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 				goto out_err;
 			bio->bi_private = dip;
 			bio->bi_end_io = btrfs_end_dio_bio;
+			btrfs_io_bio(bio)->logical = file_offset;
 
 			map_length = orig_bio->bi_iter.bi_size;
 			ret = btrfs_map_block(root->fs_info, rw,
@@ -7408,7 +7454,7 @@ static void btrfs_submit_direct(int rw, struct bio *dio_bio,
 		goto free_ordered;
 	}
 
-	dip = kmalloc(sizeof(*dip), GFP_NOFS);
+	dip = kzalloc(sizeof(*dip), GFP_NOFS);
 	if (!dip) {
 		ret = -ENOMEM;
 		goto free_io_bio;
@@ -7420,21 +7466,23 @@ static void btrfs_submit_direct(int rw, struct bio *dio_bio,
 	dip->bytes = dio_bio->bi_iter.bi_size;
 	dip->disk_bytenr = (u64)dio_bio->bi_iter.bi_sector << 9;
 	io_bio->bi_private = dip;
-	dip->errors = 0;
 	dip->orig_bio = io_bio;
 	dip->dio_bio = dio_bio;
 	atomic_set(&dip->pending_bios, 0);
+	btrfs_bio = btrfs_io_bio(io_bio);
+	btrfs_bio->logical = file_offset;
 
-	if (write)
+	if (write) {
 		io_bio->bi_end_io = btrfs_endio_direct_write;
-	else
+	} else {
 		io_bio->bi_end_io = btrfs_endio_direct_read;
+		dip->subio_endio = btrfs_subio_endio_read;
+	}
 
 	ret = btrfs_submit_direct_hook(rw, dip, skip_sum);
 	if (!ret)
 		return;
 
-	btrfs_bio = btrfs_io_bio(io_bio);
 	if (btrfs_bio->end_io)
 		btrfs_bio->end_io(btrfs_bio, ret);
 free_io_bio:
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 2aaa00c..cd31de1 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -167,8 +167,9 @@ struct btrfs_fs_devices {
  */
 typedef void (btrfs_io_bio_end_io_t) (struct btrfs_io_bio *bio, int err);
 struct btrfs_io_bio {
-	unsigned long mirror_num;
-	unsigned long stripe_index;
+	unsigned int mirror_num;
+	unsigned int stripe_index;
+	u64 logical;
 	u8 *csum;
 	u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
 	u8 *csum_allocated;
-- 
1.9.3

