Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51688 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752206AbdJIPWv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Oct 2017 11:22:51 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: enadolski@suse.de, bo.li.liu@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 2/3] btrfs: rename page offset parameter in submit_extent_page
Date: Mon,  9 Oct 2017 17:21:06 +0200
Message-Id: <5795bc0959216203333cb796d41aef777426ca6d.1507562199.git.dsterba@suse.com>
In-Reply-To: <cover.1507562199.git.dsterba@suse.com>
References: <cover.1507562199.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We're going to remove sector_t and will use 'offset', so this patch
frees the name.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 12ab19a4b93e..ea9ab934794b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2762,7 +2762,7 @@ static int merge_bio(struct extent_io_tree *tree, struct page *page,
 static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 			      struct writeback_control *wbc,
 			      struct page *page, sector_t sector,
-			      size_t size, unsigned long offset,
+			      size_t size, unsigned long pg_offset,
 			      struct block_device *bdev,
 			      struct bio **bio_ret,
 			      bio_end_io_t end_io_func,
@@ -2786,8 +2786,8 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 
 		if (prev_bio_flags != bio_flags || !contig ||
 		    force_bio_submit ||
-		    merge_bio(tree, page, offset, page_size, bio, bio_flags) ||
-		    bio_add_page(bio, page, page_size, offset) < page_size) {
+		    merge_bio(tree, page, pg_offset, page_size, bio, bio_flags) ||
+		    bio_add_page(bio, page, page_size, pg_offset) < page_size) {
 			ret = submit_one_bio(bio, mirror_num, prev_bio_flags);
 			if (ret < 0) {
 				*bio_ret = NULL;
@@ -2802,7 +2802,7 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 	}
 
 	bio = btrfs_bio_alloc(bdev, sector << 9);
-	bio_add_page(bio, page, page_size, offset);
+	bio_add_page(bio, page, page_size, pg_offset);
 	bio->bi_end_io = end_io_func;
 	bio->bi_private = tree;
 	bio->bi_write_hint = page->mapping->host->i_write_hint;
-- 
2.14.0

