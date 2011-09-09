From: jeffm@suse.com
Subject: [patch v3 23/23] btrfs: Push up ->submit_bio_hook failures
Date: Thu, 08 Sep 2011 20:23:03 -0400
Message-ID: <20110909002734.290256661@suse.com>
References: <20110909002240.141223014@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: btrfs list <linux-btrfs@vger.kernel.org>
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
 fs/btrfs/extent_io.c |   29 +++++++++++++++++++++--------
 fs/btrfs/inode.c     |    3 ++-
 3 files changed, 26 insertions(+), 12 deletions(-)

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
@@ -1693,6 +1693,7 @@ static void end_bio_extent_writepage(str
 				uptodate = (err == 0);
 				continue;
 			}
+			BUG_ON(ret < 0);
 		}
 
 		if (!uptodate) {
@@ -1785,6 +1786,7 @@ static void end_bio_extent_readpage(stru
 				uncache_state(&cached);
 				continue;
 			}
+			BUG_ON(ret < 0);
 		}
 
 		if (uptodate) {
@@ -1910,6 +1912,7 @@ static int submit_extent_page(int rw, st
 		    bio_add_page(bio, page, page_size, offset) < page_size) {
 			ret = submit_one_bio(rw, bio, mirror_num,
 					     prev_bio_flags);
+			BUG_ON(ret < 0);
 			bio = NULL;
 		} else {
 			return 0;
@@ -1930,8 +1933,10 @@ static int submit_extent_page(int rw, st
 
 	if (bio_ret)
 		*bio_ret = bio;
-	else
+	else {
 		ret = submit_one_bio(rw, bio, mirror_num, bio_flags);
+		BUG_ON(ret < 0);
+	}
 
 	return ret;
 }
@@ -2154,8 +2159,10 @@ int extent_read_full_page(struct extent_
 
 	ret = __extent_read_full_page(tree, page, get_extent, &bio, 0,
 				      &bio_flags);
-	if (bio)
+	if (bio) {
 		ret = submit_one_bio(READ, bio, 0, bio_flags);
+		BUG_ON(ret < 0);
+	}
 	return ret;
 }
 
@@ -2553,10 +2560,12 @@ retry:
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
@@ -2672,8 +2681,10 @@ int extent_readpages(struct extent_io_tr
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
 
@@ -3505,8 +3516,10 @@ int read_extent_buffer_pages(struct exte
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


