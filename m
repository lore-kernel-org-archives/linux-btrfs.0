Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:43899 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3FRTpB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Jun 2013 15:45:01 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4049D7C06A3
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Jun 2013 13:45:01 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id A9q9GRPkuZLkTDRt (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 18 Jun 2013 13:45:00 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: move btrfs_truncate_page to btrfs_cont_expand instead of btrfs_truncate V2
Date: Tue, 18 Jun 2013 15:44:58 -0400
Message-ID: <1371584698-10921-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This has plagued us forever and I'm so over working around it.  When we truncate
down to a non-page aligned offset we will call btrfs_truncate_page to zero out
the end of the page and write it back to disk, this will keep us from exposing
stale data if we truncate back up from that point.  The problem with this is it
requires data space to do this, and people don't really expect to get ENOSPC
from truncate() for these sort of things.  This also tends to bite the orphan
cleanup stuff too which keeps people from mounting.  To get around this we can
just move this into btrfs_cont_expand() to make sure if we are truncating up
from a non-page size aligned i_size we will zero out the rest of this page so
that we don't expose stale data.  This will give ENOSPC if you try to truncate()
up or if you try to write past the end of isize, which is much more reasonable.
This fixes xfstests generic/083 failing to mount because of the orphan cleanup
failing.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2:
-we need to call btrfs_truncate_page in fallocate()
-we need to zero the page in readpage endio

 fs/btrfs/extent_io.c |   11 ++++++++++-
 fs/btrfs/file.c      |   21 +++++++++++++++------
 fs/btrfs/inode.c     |   15 ++++++++++-----
 3 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 03ca3ab..a83d701 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2477,11 +2477,12 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		struct extent_state *cached = NULL;
 		struct extent_state *state;
 		struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+		struct inode *inode = page->mapping->host;
 
 		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
 			 "mirror=%lu\n", (u64)bio->bi_sector, err,
 			 io_bio->mirror_num);
-		tree = &BTRFS_I(page->mapping->host)->io_tree;
+		tree = &BTRFS_I(inode)->io_tree;
 
 		/* We always issue full-page reads, but if some block
 		 * in a page fails to read, blk_update_request() will
@@ -2555,6 +2556,14 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
 
 		if (uptodate) {
+			loff_t i_size = i_size_read(inode);
+			pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
+			unsigned offset;
+
+			/* Zero out the end if this page straddles i_size */
+			offset = i_size & (PAGE_CACHE_SIZE-1);
+			if (page->index == end_index && offset)
+				zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 			SetPageUptodate(page);
 		} else {
 			ClearPageUptodate(page);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 185af15..5ffde56 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2173,12 +2173,6 @@ static long btrfs_fallocate(struct file *file, int mode,
 			goto out_reserve_fail;
 	}
 
-	/*
-	 * wait for ordered IO before we have any locks.  We'll loop again
-	 * below with the locks held.
-	 */
-	btrfs_wait_ordered_range(inode, alloc_start, alloc_end - alloc_start);
-
 	mutex_lock(&inode->i_mutex);
 	ret = inode_newsize_ok(inode, alloc_end);
 	if (ret)
@@ -2189,8 +2183,23 @@ static long btrfs_fallocate(struct file *file, int mode,
 					alloc_start);
 		if (ret)
 			goto out;
+	} else {
+		/*
+		 * If we are fallocating from the end of the file onward we
+		 * need to zero out the end of the page if i_size lands in the
+		 * middle of a page.
+		 */
+		ret = btrfs_truncate_page(inode, inode->i_size, 0, 0);
+		if (ret)
+			goto out;
 	}
 
+	/*
+	 * wait for ordered IO before we have any locks.  We'll loop again
+	 * below with the locks held.
+	 */
+	btrfs_wait_ordered_range(inode, alloc_start, alloc_end - alloc_start);
+
 	locked_end = alloc_end - 1;
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3dbfee9..ecf8b5b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4253,6 +4253,15 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 	u64 hole_size;
 	int err = 0;
 
+	/*
+	 * If our size started in the middle of a page we need to zero out the
+	 * rest of the page before we expand the i_size, otherwise we could
+	 * expose stale data.
+	 */
+	err = btrfs_truncate_page(inode, oldsize, 0, 0);
+	if (err)
+		return err;
+
 	if (size <= hole_start)
 		return 0;
 
@@ -7590,16 +7599,12 @@ static int btrfs_truncate(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *rsv;
-	int ret;
+	int ret = 0;
 	int err = 0;
 	struct btrfs_trans_handle *trans;
 	u64 mask = root->sectorsize - 1;
 	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
 
-	ret = btrfs_truncate_page(inode, inode->i_size, 0, 0);
-	if (ret)
-		return ret;
-
 	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
 	btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
 
-- 
1.7.7.6

