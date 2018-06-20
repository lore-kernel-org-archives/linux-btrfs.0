Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43396 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754002AbeFTO4b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 10:56:31 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w5KEnuG0010181
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 07:56:30 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2jqnjwghd9-3
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 07:56:30 -0700
From: Chris Mason <clm@fb.com>
To: <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs: don't clean dirty pages during buffered writes
Date: Wed, 20 Jun 2018 07:56:11 -0700
Message-ID: <20180620145612.1644763-2-clm@fb.com>
In-Reply-To: <20180620145612.1644763-1-clm@fb.com>
References: <20180620145612.1644763-1-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During buffered writes, we follow this basic series of steps:

again:
	lock all the pages
	wait for writeback on all the pages
	Take the extent range lock
	wait for ordered extents on the whole range
	clean all the pages

	if (copy_from_user_in_atomic() hits a fault) {
		drop our locks
		goto again;
	}

	dirty all the pages
	release all the locks

The extra waiting, cleaning and locking are there to make sure we don't
modify pages in flight to the drive, after they've been crc'd.

If some of the pages in the range were already dirty when the write
began, and we need to goto again, we create a window where a dirty page
has been cleaned and unlocked.  It may be reclaimed before we're able to
lock it again, which means we'll read the old contents off the drive and
lose any modifications that had been pending writeback.

We don't actually need to clean the pages.  All of the other locking in
place makes sure we don't start IO on the pages, so we can just leave
them dirty for the duration of the write.

Fixes: 73d59314e6ed (the original btrfs merge)
Signed-off-by: Chris Mason <clm@fb.com>
---
 fs/btrfs/file.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f660ba1..89ec4d2 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -534,6 +534,15 @@ int btrfs_dirty_pages(struct inode *inode, struct page **pages,
 
 	end_of_last_block = start_pos + num_bytes - 1;
 
+	/*
+	 * the pages may have already been dirty, clear out old accounting
+	 * so we can set things up properly
+	 */
+	clear_extent_bit(&BTRFS_I(inode)->io_tree, start_pos, end_of_last_block,
+			 EXTENT_DIRTY | EXTENT_DELALLOC |
+			 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 0, 0,
+			 cached);
+
 	if (!btrfs_is_free_space_inode(BTRFS_I(inode))) {
 		if (start_pos >= isize &&
 		    !(BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC)) {
@@ -1504,18 +1513,27 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 		}
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
-		clear_extent_bit(&inode->io_tree, start_pos, last_pos,
-				 EXTENT_DIRTY | EXTENT_DELALLOC |
-				 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
-				 0, 0, cached_state);
+
 		*lockstart = start_pos;
 		*lockend = last_pos;
 		ret = 1;
 	}
 
+	/*
+	 * It's possible the pages are dirty right now, but we don't want
+	 * to clean them yet because copy_from_user may catch a page fault
+	 * and we might have to fall back to one page at a time.  If that
+	 * happens, we'll unlock these pages and we'd have a window where
+	 * reclaim could sneak in and drop the once-dirty page on the floor
+	 * without writing it.
+	 *
+	 * We have the pages locked and the extent range locked, so there's
+	 * no way someone can start IO on any dirty pages in this range.
+	 *
+	 * we'll call btrfs_dirty_pages() later on, and that will flip around
+	 * delalloc bits and dirty the pages as required.
+	 */
 	for (i = 0; i < num_pages; i++) {
-		if (clear_page_dirty_for_io(pages[i]))
-			account_page_redirty(pages[i]);
 		set_page_extent_mapped(pages[i]);
 		WARN_ON(!PageLocked(pages[i]));
 	}
-- 
2.9.5

