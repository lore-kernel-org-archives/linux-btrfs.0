Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55460 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731154AbeGSLsD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 07:48:03 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EF442ACAA
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 11:05:22 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/7] btrfs: unify end_io callbacks of async_submit_bio
Date: Thu, 19 Jul 2018 13:05:16 +0200
Message-Id: <1600b5085d70b33f1363e773e4aeb2002a1bcad8.1531996240.git.dsterba@suse.com>
In-Reply-To: <cover.1531996240.git.dsterba@suse.com>
References: <cover.1531996240.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The end_io callbacks passed to btrfs_wq_submit_bio
(btrfs_submit_bio_done and btree_submit_bio_done) are effectively the
same code, there's no point to do the indirection. Export
btrfs_submit_bio_done and call it directly.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c   | 28 +++-------------------------
 fs/btrfs/disk-io.h   |  5 +++--
 fs/btrfs/extent_io.h |  3 ---
 fs/btrfs/inode.c     |  8 +++-----
 4 files changed, 9 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2e7932c753b2..c2d1c66edc49 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -108,7 +108,6 @@ struct async_submit_bio {
 	void *private_data;
 	struct bio *bio;
 	extent_submit_bio_start_t *submit_bio_start;
-	extent_submit_bio_done_t *submit_bio_done;
 	int mirror_num;
 	/*
 	 * bio_offset is optional, can be used if the pages in the bio
@@ -775,7 +774,7 @@ static void run_one_async_done(struct btrfs_work *work)
 		return;
 	}
 
-	async->submit_bio_done(async->private_data, async->bio, async->mirror_num);
+	btrfs_submit_bio_done(async->private_data, async->bio, async->mirror_num);
 }
 
 static void run_one_async_free(struct btrfs_work *work)
@@ -789,8 +788,7 @@ static void run_one_async_free(struct btrfs_work *work)
 blk_status_t btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags,
 				 u64 bio_offset, void *private_data,
-				 extent_submit_bio_start_t *submit_bio_start,
-				 extent_submit_bio_done_t *submit_bio_done)
+				 extent_submit_bio_start_t *submit_bio_start)
 {
 	struct async_submit_bio *async;
 
@@ -802,7 +800,6 @@ blk_status_t btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	async->bio = bio;
 	async->mirror_num = mirror_num;
 	async->submit_bio_start = submit_bio_start;
-	async->submit_bio_done = submit_bio_done;
 
 	btrfs_init_work(&async->work, btrfs_worker_helper, run_one_async_start,
 			run_one_async_done, run_one_async_free);
@@ -845,24 +842,6 @@ static blk_status_t btree_submit_bio_start(void *private_data, struct bio *bio,
 	return btree_csum_one_bio(bio);
 }
 
-static blk_status_t btree_submit_bio_done(void *private_data, struct bio *bio,
-					    int mirror_num)
-{
-	struct inode *inode = private_data;
-	blk_status_t ret;
-
-	/*
-	 * when we're called for a write, we're already in the async
-	 * submission context.  Just jump into btrfs_map_bio
-	 */
-	ret = btrfs_map_bio(btrfs_sb(inode->i_sb), bio, mirror_num, 1);
-	if (ret) {
-		bio->bi_status = ret;
-		bio_endio(bio);
-	}
-	return ret;
-}
-
 static int check_async_write(struct btrfs_inode *bi)
 {
 	if (atomic_read(&bi->sync_writers))
@@ -905,8 +884,7 @@ static blk_status_t btree_submit_bio_hook(void *private_data, struct bio *bio,
 		 */
 		ret = btrfs_wq_submit_bio(fs_info, bio, mirror_num, 0,
 					  bio_offset, private_data,
-					  btree_submit_bio_start,
-					  btree_submit_bio_done);
+					  btree_submit_bio_start);
 	}
 
 	if (ret)
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 1a3d277b027b..4cccba22640f 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -120,8 +120,9 @@ blk_status_t btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 blk_status_t btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 			int mirror_num, unsigned long bio_flags,
 			u64 bio_offset, void *private_data,
-			extent_submit_bio_start_t *submit_bio_start,
-			extent_submit_bio_done_t *submit_bio_done);
+			extent_submit_bio_start_t *submit_bio_start);
+blk_status_t btrfs_submit_bio_done(void *private_data, struct bio *bio,
+			  int mirror_num);
 int btrfs_write_tree_block(struct extent_buffer *buf);
 void btrfs_wait_tree_block_writeback(struct extent_buffer *buf);
 int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 48f1ee9ad379..129fc4ab30ac 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -92,9 +92,6 @@ typedef	blk_status_t (extent_submit_bio_hook_t)(void *private_data, struct bio *
 typedef blk_status_t (extent_submit_bio_start_t)(void *private_data,
 		struct bio *bio, u64 bio_offset);
 
-typedef blk_status_t (extent_submit_bio_done_t)(void *private_data,
-		struct bio *bio, int mirror_num);
-
 struct extent_io_ops {
 	/*
 	 * The following callbacks must be allways defined, the function
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 36b323b27dbf..0899ab54cd06 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1952,7 +1952,7 @@ static blk_status_t btrfs_submit_bio_start(void *private_data, struct bio *bio,
  * At IO completion time the cums attached on the ordered extent record
  * are inserted into the btree
  */
-static blk_status_t btrfs_submit_bio_done(void *private_data, struct bio *bio,
+blk_status_t btrfs_submit_bio_done(void *private_data, struct bio *bio,
 			  int mirror_num)
 {
 	struct inode *inode = private_data;
@@ -2025,8 +2025,7 @@ static blk_status_t btrfs_submit_bio_hook(void *private_data, struct bio *bio,
 		/* we're doing a write, do the async checksumming */
 		ret = btrfs_wq_submit_bio(fs_info, bio, mirror_num, bio_flags,
 					  bio_offset, inode,
-					  btrfs_submit_bio_start,
-					  btrfs_submit_bio_done);
+					  btrfs_submit_bio_start);
 		goto out;
 	} else if (!skip_sum) {
 		ret = btrfs_csum_one_bio(inode, bio, 0, 0);
@@ -8290,8 +8289,7 @@ static inline blk_status_t btrfs_submit_dio_bio(struct bio *bio,
 	if (write && async_submit) {
 		ret = btrfs_wq_submit_bio(fs_info, bio, 0, 0,
 					  file_offset, inode,
-					  btrfs_submit_bio_start_direct_io,
-					  btrfs_submit_bio_done);
+					  btrfs_submit_bio_start_direct_io);
 		goto err;
 	} else if (write) {
 		/*
-- 
2.18.0

