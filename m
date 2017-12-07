Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49627 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755958AbdLGPtH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Dec 2017 10:49:07 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6A7E1AE16
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Dec 2017 15:49:06 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: sink writepage parameter to extent_write_cache_pages
Date: Thu,  7 Dec 2017 16:47:07 +0100
Message-Id: <61830b448cdd959b9039a54a95b60e0a01ad321c.1512661509.git.dsterba@suse.com>
In-Reply-To: <cover.1512661509.git.dsterba@suse.com>
References: <cover.1512661509.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function extent_write_cache_pages is modelled after
write_cache_pages which is a generic interface and the writepage
parameter makes sense there. In btrfs we know exactly which callback
we're going to use, so we can pass it directly.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 35f4869a90d5..47435256a8c3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3893,8 +3893,7 @@ int btree_write_cache_pages(struct address_space *mapping,
  * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
  * @mapping: address space structure to write
  * @wbc: subtract the number of written pages from *@wbc->nr_to_write
- * @writepage: function called for each page
- * @data: data passed to writepage function
+ * @data: data passed to __extent_writepage function
  *
  * If a page is already under I/O, write_cache_pages() skips it, even
  * if it's dirty.  This is desirable behaviour for memory-cleaning writeback,
@@ -3906,7 +3905,7 @@ int btree_write_cache_pages(struct address_space *mapping,
  */
 static int extent_write_cache_pages(struct address_space *mapping,
 			     struct writeback_control *wbc,
-			     writepage_t writepage, void *data)
+			     void *data)
 {
 	struct inode *inode = mapping->host;
 	int ret = 0;
@@ -3991,7 +3990,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
 				continue;
 			}
 
-			ret = (*writepage)(page, wbc, data);
+			ret = __extent_writepage(page, wbc, data);
 
 			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
 				unlock_page(page);
@@ -4122,7 +4121,7 @@ int extent_writepages(struct extent_io_tree *tree,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
 	};
 
-	ret = extent_write_cache_pages(mapping, wbc, __extent_writepage, &epd);
+	ret = extent_write_cache_pages(mapping, wbc, &epd);
 	flush_write_bio(&epd);
 	return ret;
 }
-- 
2.15.1

