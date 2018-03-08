Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56874 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932537AbeCHOgR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:36:17 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6E5FCAE19
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:36:16 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 22/22] btrfs: rename submit callbacks and drop double underscores
Date: Thu,  8 Mar 2018 15:33:56 +0100
Message-Id: <fe83a54ccc2ba9dcfb2b4c39af1ae35ebd5c8902.1520518877.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c |  8 ++++----
 fs/btrfs/inode.c   | 23 +++++++++++------------
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f24522a6f36f..e112708e3e9b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -805,7 +805,7 @@ static blk_status_t btree_csum_one_bio(struct bio *bio)
 	return errno_to_blk_status(ret);
 }
 
-static blk_status_t __btree_submit_bio_start(void *private_data, struct bio *bio,
+static blk_status_t btree_submit_bio_start(void *private_data, struct bio *bio,
 					     u64 bio_offset)
 {
 	/*
@@ -815,7 +815,7 @@ static blk_status_t __btree_submit_bio_start(void *private_data, struct bio *bio
 	return btree_csum_one_bio(bio);
 }
 
-static blk_status_t __btree_submit_bio_done(void *private_data, struct bio *bio,
+static blk_status_t btree_submit_bio_done(void *private_data, struct bio *bio,
 					    int mirror_num)
 {
 	struct inode *inode = private_data;
@@ -875,8 +875,8 @@ static blk_status_t btree_submit_bio_hook(void *private_data, struct bio *bio,
 		 */
 		ret = btrfs_wq_submit_bio(fs_info, bio, mirror_num, 0,
 					  bio_offset, private_data,
-					  __btree_submit_bio_start,
-					  __btree_submit_bio_done);
+					  btree_submit_bio_start,
+					  btree_submit_bio_done);
 	}
 
 	if (ret)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5cfba8be73be..16c6e2fe3b58 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1921,7 +1921,7 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
  * At IO completion time the cums attached on the ordered extent record
  * are inserted into the btree
  */
-static blk_status_t __btrfs_submit_bio_start(void *private_data, struct bio *bio,
+static blk_status_t btrfs_submit_bio_start(void *private_data, struct bio *bio,
 				    u64 bio_offset)
 {
 	struct inode *inode = private_data;
@@ -1940,7 +1940,7 @@ static blk_status_t __btrfs_submit_bio_start(void *private_data, struct bio *bio
  * At IO completion time the cums attached on the ordered extent record
  * are inserted into the btree
  */
-static blk_status_t __btrfs_submit_bio_done(void *private_data, struct bio *bio,
+static blk_status_t btrfs_submit_bio_done(void *private_data, struct bio *bio,
 			  int mirror_num)
 {
 	struct inode *inode = private_data;
@@ -2013,8 +2013,8 @@ static blk_status_t btrfs_submit_bio_hook(void *private_data, struct bio *bio,
 		/* we're doing a write, do the async checksumming */
 		ret = btrfs_wq_submit_bio(fs_info, bio, mirror_num, bio_flags,
 					  bio_offset, inode,
-					  __btrfs_submit_bio_start,
-					  __btrfs_submit_bio_done);
+					  btrfs_submit_bio_start,
+					  btrfs_submit_bio_done);
 		goto out;
 	} else if (!skip_sum) {
 		ret = btrfs_csum_one_bio(inode, bio, 0, 0);
@@ -8268,7 +8268,7 @@ static void btrfs_endio_direct_write(struct bio *bio)
 	bio_put(bio);
 }
 
-static blk_status_t __btrfs_submit_bio_start_direct_io(void *private_data,
+static blk_status_t btrfs_submit_bio_start_direct_io(void *private_data,
 				    struct bio *bio, u64 offset)
 {
 	struct inode *inode = private_data;
@@ -8349,9 +8349,8 @@ static inline blk_status_t btrfs_lookup_and_bind_dio_csum(struct inode *inode,
 	return 0;
 }
 
-static inline blk_status_t
-__btrfs_submit_dio_bio(struct bio *bio, struct inode *inode, u64 file_offset,
-		       int async_submit)
+static inline blk_status_t btrfs_submit_dio_bio(struct bio *bio,
+		struct inode *inode, u64 file_offset, int async_submit)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_dio_private *dip = bio->bi_private;
@@ -8374,8 +8373,8 @@ __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode, u64 file_offset,
 	if (write && async_submit) {
 		ret = btrfs_wq_submit_bio(fs_info, bio, 0, 0,
 					  file_offset, inode,
-					  __btrfs_submit_bio_start_direct_io,
-					  __btrfs_submit_bio_done);
+					  btrfs_submit_bio_start_direct_io,
+					  btrfs_submit_bio_done);
 		goto err;
 	} else if (write) {
 		/*
@@ -8461,7 +8460,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip)
 		 */
 		atomic_inc(&dip->pending_bios);
 
-		status = __btrfs_submit_dio_bio(bio, inode, file_offset,
+		status = btrfs_submit_dio_bio(bio, inode, file_offset,
 						async_submit);
 		if (status) {
 			bio_put(bio);
@@ -8481,7 +8480,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip)
 	} while (submit_len > 0);
 
 submit:
-	status = __btrfs_submit_dio_bio(bio, inode, file_offset, async_submit);
+	status = btrfs_submit_dio_bio(bio, inode, file_offset, async_submit);
 	if (!status)
 		return 0;
 
-- 
2.16.2

