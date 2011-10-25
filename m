From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 45/66] btrfs: ->submit_bio_hook error push-up
Date: Mon, 24 Oct 2011 21:03:21 -0400
Message-ID: <20111025010855.729047125@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
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
 fs/btrfs/extent_io.c |   33 +++++++++++++++++++++++----------
 fs/btrfs/inode.c     |    3 ++-
 3 files changed, 28 insertions(+), 14 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -811,9 +811,9 @@ static int btree_submit_bio_hook(struct
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
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1888,6 +1888,7 @@ static void end_bio_extent_writepage(str
 				uptodate = (err == 0);
 				continue;
 			}
+			BUG_ON(ret < 0);
 		}
 
 		if (!uptodate) {
@@ -1980,6 +1981,7 @@ static void end_bio_extent_readpage(stru
 				uncache_state(&cached);
 				continue;
 			}
+			BUG_ON(ret < 0);
 		}
 
 		if (uptodate) {
@@ -2034,8 +2036,8 @@ btrfs_bio_alloc(struct block_device *bde
 	return bio;
 }
 
-static int submit_one_bio(int rw, struct bio *bio, int mirror_num,
-			  unsigned long bio_flags)
+static int __must_check submit_one_bio(int rw, struct bio *bio,
+				       int mirror_num, unsigned long bio_flags)
 {
 	int ret = 0;
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -2105,6 +2107,7 @@ static int submit_extent_page(int rw, st
 		    bio_add_page(bio, page, page_size, offset) < page_size) {
 			ret = submit_one_bio(rw, bio, mirror_num,
 					     prev_bio_flags);
+			BUG_ON(ret < 0);
 			bio = NULL;
 		} else {
 			return 0;
@@ -2125,8 +2128,10 @@ static int submit_extent_page(int rw, st
 
 	if (bio_ret)
 		*bio_ret = bio;
-	else
+	else {
 		ret = submit_one_bio(rw, bio, mirror_num, bio_flags);
+		BUG_ON(ret < 0);
+	}
 
 	return ret;
 }
@@ -2349,8 +2354,10 @@ int extent_read_full_page(struct extent_
 
 	ret = __extent_read_full_page(tree, page, get_extent, &bio, 0,
 				      &bio_flags);
-	if (bio)
+	if (bio) {
 		ret = submit_one_bio(READ, bio, 0, bio_flags);
+		BUG_ON(ret < 0);
+	}
 	return ret;
 }
 
@@ -2752,10 +2759,12 @@ retry:
 static void flush_epd_write_bio(struct extent_page_data *epd)
 {
 	if (epd->bio) {
+		int ret;
 		if (epd->sync_io)
-			submit_one_bio(WRITE_SYNC, epd->bio, 0, 0);
+			ret = submit_one_bio(WRITE_SYNC, epd->bio, 0, 0);
 		else
-			submit_one_bio(WRITE, epd->bio, 0, 0);
+			ret = submit_one_bio(WRITE, epd->bio, 0, 0);
+		BUG_ON(ret < 0);
 		epd->bio = NULL;
 	}
 }
@@ -2871,8 +2880,10 @@ int extent_readpages(struct extent_io_tr
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
 
@@ -3704,8 +3715,10 @@ int read_extent_buffer_pages(struct exte
 		}
 	}
 
-	if (bio)
-		submit_one_bio(READ, bio, mirror_num, bio_flags);
+	if (bio) {
+		err = submit_one_bio(READ, bio, mirror_num, bio_flags);
+		BUG_ON(err < 0);
+	}
 
 	if (ret || !wait)
 		return ret;
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1488,7 +1488,8 @@ static int btrfs_submit_bio_hook(struct
 		metadata = 2;
 
 	ret = btrfs_bio_wq_end_io(root->fs_info, bio, metadata);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 
 	if (!(rw & REQ_WRITE)) {
 		if (bio_flags & EXTENT_BIO_COMPRESSED) {


