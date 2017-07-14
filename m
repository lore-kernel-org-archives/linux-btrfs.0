Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54235 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751003AbdGNSba (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 14:31:30 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6D113AAC5
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 18:31:29 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: cleanup types storing REQ_*
Date: Fri, 14 Jul 2017 20:30:16 +0200
Message-Id: <f5fdca4f7c4b0412ec38333fa801eb75695b0966.1500056930.git.dsterba@suse.com>
In-Reply-To: <cover.1500056930.git.dsterba@suse.com>
References: <cover.1500056930.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unify types of local variables and parameters that store various
REQ_* values to unsigned int.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 14 ++++++++------
 fs/btrfs/inode.c     |  2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2e6f69908303..537811c3c9d0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2755,7 +2755,8 @@ static int merge_bio(struct extent_io_tree *tree, struct page *page,
 
 }
 
-static int submit_extent_page(int op, int op_flags, struct extent_io_tree *tree,
+static int submit_extent_page(unsigned int op, unsigned int op_flags,
+			      struct extent_io_tree *tree,
 			      struct writeback_control *wbc,
 			      struct page *page, sector_t sector,
 			      size_t size, unsigned long offset,
@@ -2875,7 +2876,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 			 get_extent_t *get_extent,
 			 struct extent_map **em_cached,
 			 struct bio **bio, int mirror_num,
-			 unsigned long *bio_flags, int read_flags,
+			 unsigned long *bio_flags, unsigned int read_flags,
 			 u64 *prev_em_start)
 {
 	struct inode *inode = page->mapping->host;
@@ -3161,7 +3162,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 				   struct page *page,
 				   get_extent_t *get_extent,
 				   struct bio **bio, int mirror_num,
-				   unsigned long *bio_flags, int read_flags)
+				   unsigned long *bio_flags,
+				   unsigned int read_flags)
 {
 	struct inode *inode = page->mapping->host;
 	struct btrfs_ordered_extent *ordered;
@@ -3308,7 +3310,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 				 struct extent_page_data *epd,
 				 loff_t i_size,
 				 unsigned long nr_written,
-				 int write_flags, int *nr_ret)
+				 unsigned int write_flags, int *nr_ret)
 {
 	struct extent_io_tree *tree = epd->tree;
 	u64 start = page_offset(page);
@@ -3462,7 +3464,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	size_t pg_offset = 0;
 	loff_t i_size = i_size_read(inode);
 	unsigned long end_index = i_size >> PAGE_SHIFT;
-	int write_flags = 0;
+	unsigned int write_flags = 0;
 	unsigned long nr_written = 0;
 
 	if (wbc->sync_mode == WB_SYNC_ALL)
@@ -3711,7 +3713,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 	unsigned long i, num_pages;
 	unsigned long bio_flags = 0;
 	unsigned long start, end;
-	int write_flags = (epd->sync_io ? REQ_SYNC : 0) | REQ_META;
+	unsigned int write_flags = (epd->sync_io ? REQ_SYNC : 0) | REQ_META;
 	int ret = 0;
 
 	clear_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5d3c6ac960fd..3512ac9cfd24 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7991,7 +7991,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 	struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
 	struct bio *bio;
 	int isector;
-	int read_mode = 0;
+	unsigned int read_mode = 0;
 	int segs;
 	int ret;
 
-- 
2.13.0

