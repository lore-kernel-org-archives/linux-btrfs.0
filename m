Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54240 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751003AbdGNSbd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 14:31:33 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BBB3DAAC5
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 18:31:31 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: merge REQ_OP and REQ_ flags to one parameter in submit_extent_page
Date: Fri, 14 Jul 2017 20:30:18 +0200
Message-Id: <41a3f2a7c0622bd0e93b4c59c31defdd9c4b0466.1500056930.git.dsterba@suse.com>
In-Reply-To: <cover.1500056930.git.dsterba@suse.com>
References: <cover.1500056930.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function submit_extent_page has 15(!) parameters right now, op and
op_flags are effectively one value stored to bio::bi_opf, no need to
pass them separately. So it's 14 parameters now.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 537811c3c9d0..9f44b82b7f1a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2755,8 +2755,10 @@ static int merge_bio(struct extent_io_tree *tree, struct page *page,
 
 }
 
-static int submit_extent_page(unsigned int op, unsigned int op_flags,
-			      struct extent_io_tree *tree,
+/*
+ * @opf:	bio REQ_OP_* and REQ_* flags as one value
+ */
+static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 			      struct writeback_control *wbc,
 			      struct page *page, sector_t sector,
 			      size_t size, unsigned long offset,
@@ -2802,7 +2804,7 @@ static int submit_extent_page(unsigned int op, unsigned int op_flags,
 	bio_add_page(bio, page, page_size, offset);
 	bio->bi_end_io = end_io_func;
 	bio->bi_private = tree;
-	bio_set_op_attrs(bio, op, op_flags);
+	bio->bi_opf = opf;
 	if (wbc) {
 		wbc_init_bio(wbc, bio);
 		wbc_account_io(wbc, page, page_size);
@@ -3057,7 +3059,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 			continue;
 		}
 
-		ret = submit_extent_page(REQ_OP_READ, read_flags, tree, NULL,
+		ret = submit_extent_page(REQ_OP_READ | read_flags, tree, NULL,
 					 page, sector, disk_io_size, pg_offset,
 					 bdev, bio,
 					 end_bio_extent_readpage, mirror_num,
@@ -3426,7 +3428,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 			       page->index, cur, end);
 		}
 
-		ret = submit_extent_page(REQ_OP_WRITE, write_flags, tree, wbc,
+		ret = submit_extent_page(REQ_OP_WRITE | write_flags, tree, wbc,
 					 page, sector, iosize, pg_offset,
 					 bdev, &epd->bio,
 					 end_bio_extent_writepage,
@@ -3743,7 +3745,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 
 		clear_page_dirty_for_io(p);
 		set_page_writeback(p);
-		ret = submit_extent_page(REQ_OP_WRITE, write_flags, tree, wbc,
+		ret = submit_extent_page(REQ_OP_WRITE | write_flags, tree, wbc,
 					 p, offset >> 9, PAGE_SIZE, 0, bdev,
 					 &epd->bio,
 					 end_bio_extent_buffer_writepage,
-- 
2.13.0

