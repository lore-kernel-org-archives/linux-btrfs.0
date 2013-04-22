Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:39551 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3DVNNw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 09:13:52 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 874359A0406
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 07:13:50 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id ytDZQ0diaKhnDoRB (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 07:13:49 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: use REQ_META for all metadata IO
Date: Mon, 22 Apr 2013 09:13:47 -0400
Message-ID: <1366636427-2112-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need to tag metadata io with REQ_META to avoid priority inversion when using
io throttling cqroups.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent_io.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 617b577..2107a06 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2684,7 +2684,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 				   struct page *page,
 				   get_extent_t *get_extent,
 				   struct bio **bio, int mirror_num,
-				   unsigned long *bio_flags)
+				   unsigned long *bio_flags, int rw)
 {
 	struct inode *inode = page->mapping->host;
 	u64 start = page_offset(page);
@@ -2830,7 +2830,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 		}
 
 		pnr -= page->index;
-		ret = submit_extent_page(READ, tree, page,
+		ret = submit_extent_page(rw, tree, page,
 					 sector, disk_io_size, pg_offset,
 					 bdev, bio, pnr,
 					 end_bio_extent_readpage, mirror_num,
@@ -2863,7 +2863,7 @@ int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 	int ret;
 
 	ret = __extent_read_full_page(tree, page, get_extent, &bio, mirror_num,
-				      &bio_flags);
+				      &bio_flags, READ);
 	if (bio)
 		ret = submit_one_bio(READ, bio, mirror_num, bio_flags);
 	return ret;
@@ -3287,7 +3287,7 @@ static int write_one_eb(struct extent_buffer *eb,
 	u64 offset = eb->start;
 	unsigned long i, num_pages;
 	unsigned long bio_flags = 0;
-	int rw = (epd->sync_io ? WRITE_SYNC : WRITE);
+	int rw = (epd->sync_io ? WRITE_SYNC : WRITE) | REQ_META;
 	int ret = 0;
 
 	clear_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
@@ -3724,14 +3724,14 @@ int extent_readpages(struct extent_io_tree *tree,
 			continue;
 		for (i = 0; i < nr; i++) {
 			__extent_read_full_page(tree, pagepool[i], get_extent,
-					&bio, 0, &bio_flags);
+					&bio, 0, &bio_flags, READ);
 			page_cache_release(pagepool[i]);
 		}
 		nr = 0;
 	}
 	for (i = 0; i < nr; i++) {
 		__extent_read_full_page(tree, pagepool[i], get_extent,
-					&bio, 0, &bio_flags);
+					&bio, 0, &bio_flags, READ);
 		page_cache_release(pagepool[i]);
 	}
 
@@ -4703,7 +4703,8 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 			ClearPageError(page);
 			err = __extent_read_full_page(tree, page,
 						      get_extent, &bio,
-						      mirror_num, &bio_flags);
+						      mirror_num, &bio_flags,
+						      READ | REQ_META);
 			if (err)
 				ret = err;
 		} else {
@@ -4712,7 +4713,8 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	}
 
 	if (bio) {
-		err = submit_one_bio(READ, bio, mirror_num, bio_flags);
+		err = submit_one_bio(READ | REQ_META, bio, mirror_num,
+				     bio_flags);
 		if (err)
 			return err;
 	}
-- 
1.7.7.6

