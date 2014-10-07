Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:45777 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaJFXtS (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 6 Oct 2014 19:49:18 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: don't ignore compressed bio write errors
Date: Tue,  7 Oct 2014 01:48:26 +0100
Message-Id: <1412642906-16640-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Our compressed bio write end callback was essentially ignoring the error
parameter. When a write error happens, it must pass a value of 0 to the
inode's write_page_end_io_hook callback, SetPageError on the respective
pages and set AS_EIO in the inode's mapping flags, so that a call to
filemap_fdatawait_range() / filemap_fdatawait() can find out that errors
happened (we surely don't want silent failures on fsync for example).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/compression.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index eeee138..9f0e882 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -224,16 +224,19 @@ out:
  * Clear the writeback bits on all of the file
  * pages for a compressed write
  */
-static noinline void end_compressed_writeback(struct inode *inode, u64 start,
-					      unsigned long ram_size)
+static noinline void end_compressed_writeback(struct inode *inode,
+					      const struct compressed_bio *cb)
 {
-	unsigned long index = start >> PAGE_CACHE_SHIFT;
-	unsigned long end_index = (start + ram_size - 1) >> PAGE_CACHE_SHIFT;
+	unsigned long index = cb->start >> PAGE_CACHE_SHIFT;
+	unsigned long end_index = (cb->start + cb->len - 1) >> PAGE_CACHE_SHIFT;
 	struct page *pages[16];
 	unsigned long nr_pages = end_index - index + 1;
 	int i;
 	int ret;
 
+	if (cb->errors)
+		mapping_set_error(inode->i_mapping, -EIO);
+
 	while (nr_pages > 0) {
 		ret = find_get_pages_contig(inode->i_mapping, index,
 				     min_t(unsigned long,
@@ -244,6 +247,8 @@ static noinline void end_compressed_writeback(struct inode *inode, u64 start,
 			continue;
 		}
 		for (i = 0; i < ret; i++) {
+			if (cb->errors)
+				SetPageError(pages[i]);
 			end_page_writeback(pages[i]);
 			page_cache_release(pages[i]);
 		}
@@ -287,10 +292,11 @@ static void end_compressed_bio_write(struct bio *bio, int err)
 	tree->ops->writepage_end_io_hook(cb->compressed_pages[0],
 					 cb->start,
 					 cb->start + cb->len - 1,
-					 NULL, 1);
+					 NULL,
+					 err ? 0 : 1);
 	cb->compressed_pages[0]->mapping = NULL;
 
-	end_compressed_writeback(inode, cb->start, cb->len);
+	end_compressed_writeback(inode, cb);
 	/* note, our inode could be gone now */
 
 	/*
-- 
1.9.1

