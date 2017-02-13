Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41611 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752273AbdBMJee (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:34 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5CE76ABD3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:33 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 14/29] btrfs: remove unused parameter from submit_extent_page
Date: Mon, 13 Feb 2017 10:34:04 +0100
Message-Id: <ac49126de7d3f5dbdea72584f46befd549d084f4.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This used to hold number of maximum pages to allocate, but this is now
limited by BIO_MAX_PAGES.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9df6ed30de00..00f3be5c4f2d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2759,7 +2759,6 @@ static int submit_extent_page(int op, int op_flags, struct extent_io_tree *tree,
 			      size_t size, unsigned long offset,
 			      struct block_device *bdev,
 			      struct bio **bio_ret,
-			      unsigned long max_pages,
 			      bio_end_io_t end_io_func,
 			      int mirror_num,
 			      unsigned long prev_bio_flags,
@@ -3063,7 +3062,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 		pnr -= page->index;
 		ret = submit_extent_page(REQ_OP_READ, read_flags, tree, NULL,
 					 page, sector, disk_io_size, pg_offset,
-					 bdev, bio, pnr,
+					 bdev, bio,
 					 end_bio_extent_readpage, mirror_num,
 					 *bio_flags,
 					 this_bio_flag,
@@ -3434,7 +3433,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 
 		ret = submit_extent_page(REQ_OP_WRITE, write_flags, tree, wbc,
 					 page, sector, iosize, pg_offset,
-					 bdev, &epd->bio, max_nr,
+					 bdev, &epd->bio,
 					 end_bio_extent_writepage,
 					 0, 0, 0, false);
 		if (ret) {
@@ -3751,7 +3750,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 		set_page_writeback(p);
 		ret = submit_extent_page(REQ_OP_WRITE, write_flags, tree, wbc,
 					 p, offset >> 9, PAGE_SIZE, 0, bdev,
-					 &epd->bio, -1,
+					 &epd->bio,
 					 end_bio_extent_buffer_writepage,
 					 0, epd->bio_flags, bio_flags, false);
 		epd->bio_flags = bio_flags;
-- 
2.10.1

