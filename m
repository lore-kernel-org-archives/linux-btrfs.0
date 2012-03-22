From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 13/35] btrfs: ->submit_bio_hook error push-up
Date: Wed, 21 Mar 2012 21:11:17 -0400
Message-ID: <20120322011134.786231282@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This pushes failures from the submit_bio_hook callbacks,
btrfs_submit_bio_hook and btree_submit_bio_hook into the callers, including
callers of submit_one_bio where it catches the failures with BUG_ON.

It also pushes up through the ->readpage_io_failed_hook to
end_bio_extent_writepage where the error is already caught with BUG_ON.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c   |    6 +++---
 fs/btrfs/extent_io.c |   37 ++++++++++++++++++++++++++-----------
 fs/btrfs/inode.c     |    3 ++-
 3 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 155c4e3..2e4428b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -847,9 +847,9 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 {
 	int ret;
 
-	ret = btrfs_bio_wq_end_io(BTRFS_I(inode)->root->fs_info,
-					  bio, 1);
-	BUG_ON(ret);
+	ret = btrfs_bio_wq_end_io(BTRFS_I(inode)->root->fs_info, bio, 1);
+	if (ret)
+		return ret;
 
 	if (!(rw & REQ_WRITE)) {
 		/*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c342e92..8368baa 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2199,6 +2199,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 		/* Writeback already completed */
 		if (ret == 0)
 			return 1;
+		BUG_ON(ret < 0);
 	}
 
 	if (!uptodate) {
@@ -2351,6 +2352,7 @@ error_handled:
 				if (ret == 0)
 					goto error_handled;
 			}
+			BUG_ON(ret < 0);
 		}
 
 		if (uptodate) {
@@ -2402,8 +2404,8 @@ btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 	return bio;
 }
 
-static int submit_one_bio(int rw, struct bio *bio, int mirror_num,
-			  unsigned long bio_flags)
+static int __must_check submit_one_bio(int rw, struct bio *bio,
+				       int mirror_num, unsigned long bio_flags)
 {
 	int ret = 0;
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -2474,6 +2476,7 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 		    bio_add_page(bio, page, page_size, offset) < page_size) {
 			ret = submit_one_bio(rw, bio, mirror_num,
 					     prev_bio_flags);
+			BUG_ON(ret < 0);
 			bio = NULL;
 		} else {
 			return 0;
@@ -2494,8 +2497,10 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 
 	if (bio_ret)
 		*bio_ret = bio;
-	else
+	else {
 		ret = submit_one_bio(rw, bio, mirror_num, bio_flags);
+		BUG_ON(ret < 0);
+	}
 
 	return ret;
 }
@@ -2707,8 +2712,10 @@ int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 
 	ret = __extent_read_full_page(tree, page, get_extent, &bio, mirror_num,
 				      &bio_flags);
-	if (bio)
+	if (bio) {
 		ret = submit_one_bio(READ, bio, mirror_num, bio_flags);
+		BUG_ON(ret < 0);
+	}
 	return ret;
 }
 
@@ -3126,10 +3133,14 @@ retry:
 static void flush_epd_write_bio(struct extent_page_data *epd)
 {
 	if (epd->bio) {
+		int rw = WRITE;
+		int ret;
+
 		if (epd->sync_io)
-			submit_one_bio(WRITE_SYNC, epd->bio, 0, 0);
-		else
-			submit_one_bio(WRITE, epd->bio, 0, 0);
+			rw = WRITE_SYNC;
+
+		ret = submit_one_bio(rw, epd->bio, 0, 0);
+		BUG_ON(ret < 0);
 		epd->bio = NULL;
 	}
 }
@@ -3245,8 +3256,10 @@ int extent_readpages(struct extent_io_tree *tree,
 		page_cache_release(page);
 	}
 	BUG_ON(!list_empty(pages));
-	if (bio)
-		submit_one_bio(READ, bio, 0, bio_flags);
+	if (bio) {
+		int ret = submit_one_bio(READ, bio, 0, bio_flags);
+		BUG_ON(ret < 0);
+	}
 	return 0;
 }
 
@@ -4075,8 +4088,10 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 		}
 	}
 
-	if (bio)
-		submit_one_bio(READ, bio, mirror_num, bio_flags);
+	if (bio) {
+		err = submit_one_bio(READ, bio, mirror_num, bio_flags);
+		BUG_ON(err < 0);
+	}
 
 	if (ret || wait != WAIT_COMPLETE)
 		return ret;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ad1e88d..5394bdb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1488,7 +1488,8 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 		metadata = 2;
 
 	ret = btrfs_bio_wq_end_io(root->fs_info, bio, metadata);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 
 	if (!(rw & REQ_WRITE)) {
 		if (bio_flags & EXTENT_BIO_COMPRESSED) {
-- 
1.7.9



