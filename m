Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:49960 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab2KFQit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:49 -0500
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp4) (RZmta 30.22 OK)
	with ESMTP id 603df3oA6AsqHz for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:45 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 18/26] Btrfs: handle errors from btrfs_map_bio() everywhere
Date: Tue,  6 Nov 2012 17:38:36 +0100
Message-Id: <963c6b61589b892a7da1ee5fafa2c158007a7d8d.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

With the addition of the device replace procedure, it is possible
for btrfs_map_bio(READ) to report an error. This happens when the
specific mirror is requested which is located on the target disk,
and the copy operation has not yet copied this block. Hence the
block cannot be read and this error state is indicated by
returning EIO.
Some background information follows now. A new mirror is added
while the device replace procedure is running.
btrfs_get_num_copies() returns one more, and
btrfs_map_bio(GET_READ_MIRROR) adds one more mirror if a disk
location is involved that was already handled by the device
replace copy operation. The assigned mirror num is the highest
mirror number, e.g. the value 3 in case of RAID1.
If btrfs_map_bio() is invoked with mirror_num == 0 (i.e., select
any mirror), the copy on the target drive is never selected
because that disk shall be able to perform the write requests as
quickly as possible. The parallel execution of read requests would
only slow down the disk copy procedure. Second case is that
btrfs_map_bio() is called with mirror_num > 0. This is done from
the repair code only. In this case, the highest mirror num is
assigned to the target disk, since it is used last. And when this
mirror is not available because the copy procedure has not yet
handled this area, an error is returned. Everywhere in the code
the handling of such errors is added now.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/check-integrity.c | 15 +++++++++++++--
 fs/btrfs/compression.c     |  6 ++++--
 fs/btrfs/disk-io.c         | 44 +++++++++++++++++++++++++++-----------------
 fs/btrfs/extent_io.c       |  4 ----
 fs/btrfs/inode.c           | 27 ++++++++++++++++++++-------
 fs/btrfs/volumes.c         |  2 +-
 6 files changed, 65 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 8f9abed..badc6f1 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1585,6 +1585,18 @@ static int btrfsic_map_block(struct btrfsic_state *state, u64 bytenr, u32 len,
 	ret = btrfs_map_block(state->root->fs_info, READ,
 			      bytenr, &length, &multi, mirror_num);
 
+	if (ret) {
+		block_ctx_out->start = 0;
+		block_ctx_out->dev_bytenr = 0;
+		block_ctx_out->len = 0;
+		block_ctx_out->dev = NULL;
+		block_ctx_out->datav = NULL;
+		block_ctx_out->pagev = NULL;
+		block_ctx_out->mem_to_free = NULL;
+
+		return ret;
+	}
+
 	device = multi->stripes[0].dev;
 	block_ctx_out->dev = btrfsic_dev_state_lookup(device->bdev);
 	block_ctx_out->dev_bytenr = multi->stripes[0].physical;
@@ -1594,8 +1606,7 @@ static int btrfsic_map_block(struct btrfsic_state *state, u64 bytenr, u32 len,
 	block_ctx_out->pagev = NULL;
 	block_ctx_out->mem_to_free = NULL;
 
-	if (0 == ret)
-		kfree(multi);
+	kfree(multi);
 	if (NULL == block_ctx_out->dev) {
 		ret = -ENXIO;
 		printk(KERN_INFO "btrfsic: error, cannot lookup dev (#1)!\n");
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c6467aa..94ab2f8 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -687,7 +687,8 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
 			ret = btrfs_map_bio(root, READ, comp_bio,
 					    mirror_num, 0);
-			BUG_ON(ret); /* -ENOMEM */
+			if (ret)
+				bio_endio(comp_bio, ret);
 
 			bio_put(comp_bio);
 
@@ -712,7 +713,8 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	}
 
 	ret = btrfs_map_bio(root, READ, comp_bio, mirror_num, 0);
-	BUG_ON(ret); /* -ENOMEM */
+	if (ret)
+		bio_endio(comp_bio, ret);
 
 	bio_put(comp_bio);
 	return 0;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index bdf6345..dbe0434 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -852,11 +852,16 @@ static int __btree_submit_bio_done(struct inode *inode, int rw, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags,
 				 u64 bio_offset)
 {
+	int ret;
+
 	/*
 	 * when we're called for a write, we're already in the async
 	 * submission context.  Just jump into btrfs_map_bio
 	 */
-	return btrfs_map_bio(BTRFS_I(inode)->root, rw, bio, mirror_num, 1);
+	ret = btrfs_map_bio(BTRFS_I(inode)->root, rw, bio, mirror_num, 1);
+	if (ret)
+		bio_endio(bio, ret);
+	return ret;
 }
 
 static int check_async_write(struct inode *inode, unsigned long bio_flags)
@@ -878,7 +883,6 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 	int ret;
 
 	if (!(rw & REQ_WRITE)) {
-
 		/*
 		 * called for a read, do the setup so that checksum validation
 		 * can happen in the async kernel threads
@@ -886,26 +890,32 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 		ret = btrfs_bio_wq_end_io(BTRFS_I(inode)->root->fs_info,
 					  bio, 1);
 		if (ret)
-			return ret;
-		return btrfs_map_bio(BTRFS_I(inode)->root, rw, bio,
-				     mirror_num, 0);
+			goto out_w_error;
+		ret = btrfs_map_bio(BTRFS_I(inode)->root, rw, bio,
+				    mirror_num, 0);
 	} else if (!async) {
 		ret = btree_csum_one_bio(bio);
 		if (ret)
-			return ret;
-		return btrfs_map_bio(BTRFS_I(inode)->root, rw, bio,
-				     mirror_num, 0);
+			goto out_w_error;
+		ret = btrfs_map_bio(BTRFS_I(inode)->root, rw, bio,
+				    mirror_num, 0);
+	} else {
+		/*
+		 * kthread helpers are used to submit writes so that
+		 * checksumming can happen in parallel across all CPUs
+		 */
+		ret = btrfs_wq_submit_bio(BTRFS_I(inode)->root->fs_info,
+					  inode, rw, bio, mirror_num, 0,
+					  bio_offset,
+					  __btree_submit_bio_start,
+					  __btree_submit_bio_done);
 	}
 
-	/*
-	 * kthread helpers are used to submit writes so that checksumming
-	 * can happen in parallel across all CPUs
-	 */
-	return btrfs_wq_submit_bio(BTRFS_I(inode)->root->fs_info,
-				   inode, rw, bio, mirror_num, 0,
-				   bio_offset,
-				   __btree_submit_bio_start,
-				   __btree_submit_bio_done);
+	if (ret) {
+out_w_error:
+		bio_endio(bio, ret);
+	}
+	return ret;
 }
 
 #ifdef CONFIG_MIGRATION
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 82fab08..f4e8d3a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2464,10 +2464,6 @@ btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 	return bio;
 }
 
-/*
- * Since writes are async, they will only return -ENOMEM.
- * Reads can return the full range of I/O error conditions.
- */
 static int __must_check submit_one_bio(int rw, struct bio *bio,
 				       int mirror_num, unsigned long bio_flags)
 {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5172a62..90857c1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1586,7 +1586,12 @@ static int __btrfs_submit_bio_done(struct inode *inode, int rw, struct bio *bio,
 			  u64 bio_offset)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	return btrfs_map_bio(root, rw, bio, mirror_num, 1);
+	int ret;
+
+	ret = btrfs_map_bio(root, rw, bio, mirror_num, 1);
+	if (ret)
+		bio_endio(bio, ret);
+	return ret;
 }
 
 /*
@@ -1610,15 +1615,17 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 	if (!(rw & REQ_WRITE)) {
 		ret = btrfs_bio_wq_end_io(root->fs_info, bio, metadata);
 		if (ret)
-			return ret;
+			goto out;
 
 		if (bio_flags & EXTENT_BIO_COMPRESSED) {
-			return btrfs_submit_compressed_read(inode, bio,
-						    mirror_num, bio_flags);
+			ret = btrfs_submit_compressed_read(inode, bio,
+							   mirror_num,
+							   bio_flags);
+			goto out;
 		} else if (!skip_sum) {
 			ret = btrfs_lookup_bio_sums(root, inode, bio, NULL);
 			if (ret)
-				return ret;
+				goto out;
 		}
 		goto mapit;
 	} else if (!skip_sum) {
@@ -1626,15 +1633,21 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 		if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
 			goto mapit;
 		/* we're doing a write, do the async checksumming */
-		return btrfs_wq_submit_bio(BTRFS_I(inode)->root->fs_info,
+		ret = btrfs_wq_submit_bio(BTRFS_I(inode)->root->fs_info,
 				   inode, rw, bio, mirror_num,
 				   bio_flags, bio_offset,
 				   __btrfs_submit_bio_start,
 				   __btrfs_submit_bio_done);
+		goto out;
 	}
 
 mapit:
-	return btrfs_map_bio(root, rw, bio, mirror_num, 0);
+	ret = btrfs_map_bio(root, rw, bio, mirror_num, 0);
+
+out:
+	if (ret < 0)
+		bio_endio(bio, ret);
+	return ret;
 }
 
 /*
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 87051e8..9233219 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4440,7 +4440,7 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 
 	ret = btrfs_map_block(root->fs_info, rw, logical, &map_length, &bbio,
 			      mirror_num);
-	if (ret) /* -ENOMEM */
+	if (ret)
 		return ret;
 
 	total_devs = bbio->num_stripes;
-- 
1.8.0

