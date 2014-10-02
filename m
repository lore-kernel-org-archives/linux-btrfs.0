Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbaJBQuI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:50:08 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0F779AAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:50:07 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 05/14] btrfs: use enum for wq endio metadata type
Date: Thu,  2 Oct 2014 18:50:06 +0200
Message-Id: <bfebd8b5441755f228ad02273682d675d3335123.1412264873.git.dsterba@suse.cz>
In-Reply-To: <cover.1412264871.git.dsterba@suse.cz>
References: <cover.1412264871.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The enum exists but is not consistently used.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/compression.c | 11 +++++++----
 fs/btrfs/disk-io.c     | 14 +++-----------
 fs/btrfs/disk-io.h     |  4 ++--
 fs/btrfs/inode.c       |  3 ++-
 4 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index eeee13842cd0..d3220d31d3cb 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -388,7 +388,8 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 			 * freed before we're done setting it up
 			 */
 			atomic_inc(&cb->pending_bios);
-			ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
+			ret = btrfs_bio_wq_end_io(root->fs_info, bio,
+					BTRFS_WQ_ENDIO_DATA);
 			BUG_ON(ret); /* -ENOMEM */
 
 			if (!skip_sum) {
@@ -419,7 +420,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	}
 	bio_get(bio);
 
-	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
+	ret = btrfs_bio_wq_end_io(root->fs_info, bio, BTRFS_WQ_ENDIO_DATA);
 	BUG_ON(ret); /* -ENOMEM */
 
 	if (!skip_sum) {
@@ -668,7 +669,8 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 		    PAGE_CACHE_SIZE) {
 			bio_get(comp_bio);
 
-			ret = btrfs_bio_wq_end_io(root->fs_info, comp_bio, 0);
+			ret = btrfs_bio_wq_end_io(root->fs_info, comp_bio,
+					BTRFS_WQ_ENDIO_DATA);
 			BUG_ON(ret); /* -ENOMEM */
 
 			/*
@@ -706,7 +708,8 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	}
 	bio_get(comp_bio);
 
-	ret = btrfs_bio_wq_end_io(root->fs_info, comp_bio, 0);
+	ret = btrfs_bio_wq_end_io(root->fs_info, comp_bio,
+			BTRFS_WQ_ENDIO_DATA);
 	BUG_ON(ret); /* -ENOMEM */
 
 	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9b2a741370b7..d7cb58ed2946 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -82,7 +82,7 @@ struct end_io_wq {
 	void *private;
 	struct btrfs_fs_info *info;
 	int error;
-	int metadata;
+	enum btrfs_wq_endio_type metadata;
 	struct list_head list;
 	struct btrfs_work work;
 };
@@ -733,16 +733,8 @@ static void end_workqueue_bio(struct bio *bio, int err)
 	btrfs_queue_work(wq, &end_io_wq->work);
 }
 
-/*
- * For the metadata arg you want
- *
- * 0 - if data
- * 1 - if normal metadta
- * 2 - if writing to the free space cache area
- * 3 - raid parity work
- */
 int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
-			int metadata)
+			enum btrfs_wq_endio_type metadata)
 {
 	struct end_io_wq *end_io_wq;
 
@@ -930,7 +922,7 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 		 * can happen in the async kernel threads
 		 */
 		ret = btrfs_bio_wq_end_io(BTRFS_I(inode)->root->fs_info,
-					  bio, 1);
+					  bio, BTRFS_WQ_ENDIO_METADATA);
 		if (ret)
 			goto out_w_error;
 		ret = btrfs_map_bio(BTRFS_I(inode)->root, rw, bio,
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 14d06ee1e143..84da438fd9a3 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -25,7 +25,7 @@
 #define BTRFS_SUPER_MIRROR_MAX	 3
 #define BTRFS_SUPER_MIRROR_SHIFT 12
 
-enum {
+enum btrfs_wq_endio_type {
 	BTRFS_WQ_ENDIO_DATA = 0,
 	BTRFS_WQ_ENDIO_METADATA = 1,
 	BTRFS_WQ_ENDIO_FREE_SPACE = 2,
@@ -120,7 +120,7 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
 u32 btrfs_csum_data(char *data, u32 seed, size_t len);
 void btrfs_csum_final(u32 crc, char *result);
 int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
-			int metadata);
+			enum btrfs_wq_endio_type metadata);
 int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 			int rw, struct bio *bio, int mirror_num,
 			unsigned long bio_flags, u64 bio_offset,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 344a322eb386..b1e388dea7b8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7721,7 +7721,8 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 	bio_get(bio);
 
 	if (!write) {
-		ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
+		ret = btrfs_bio_wq_end_io(root->fs_info, bio,
+				BTRFS_WQ_ENDIO_DATA);
 		if (ret)
 			goto err;
 	}
-- 
1.8.4.5

