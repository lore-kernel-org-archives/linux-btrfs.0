From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] btrfs: fix arguments to btrfs_wait_on_page_writeback_range
Date: Wed, 30 Sep 2009 21:59:20 +0200
Message-ID: <20090930195920.GA16396@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

wait_on_page_writeback_range/btrfs_wait_on_page_writeback_range takes
a pagecache offset, not a byte offset into the file.  Shift the arguments
around to wait for the correct range

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/btrfs/disk-io.c
===================================================================
--- linux-2.6.orig/fs/btrfs/disk-io.c	2009-09-30 13:54:10.101028559 -0300
+++ linux-2.6/fs/btrfs/disk-io.c	2009-09-30 13:55:25.396005824 -0300
@@ -829,7 +829,9 @@ int btrfs_write_tree_block(struct extent
 int btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
 {
 	return btrfs_wait_on_page_writeback_range(buf->first_page->mapping,
-				  buf->start, buf->start + buf->len - 1);
+				  buf->start >> PAGE_CACHE_SHIFT,
+				  (buf->start + buf->len - 1) >>
+				   PAGE_CACHE_SHIFT);
 }
 
 struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
