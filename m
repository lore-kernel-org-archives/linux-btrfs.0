Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755951AbdLGPtF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Dec 2017 10:49:05 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2F716AE1B
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Dec 2017 15:49:04 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: sink flush_fn to extent_write_cache_pages
Date: Thu,  7 Dec 2017 16:47:05 +0100
Message-Id: <be0d653c10a2f84b538f003a19eb33d33f68d78f.1512661509.git.dsterba@suse.com>
In-Reply-To: <cover.1512661509.git.dsterba@suse.com>
References: <cover.1512661509.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers pass the same value flush_write_bio.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fd1a2ff1e96d..35f4869a90d5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3906,8 +3906,7 @@ int btree_write_cache_pages(struct address_space *mapping,
  */
 static int extent_write_cache_pages(struct address_space *mapping,
 			     struct writeback_control *wbc,
-			     writepage_t writepage, void *data,
-			     void (*flush_fn)(void *))
+			     writepage_t writepage, void *data)
 {
 	struct inode *inode = mapping->host;
 	int ret = 0;
@@ -3971,7 +3970,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
 			 * mapping
 			 */
 			if (!trylock_page(page)) {
-				flush_fn(data);
+				flush_write_bio(data);
 				lock_page(page);
 			}
 
@@ -3982,7 +3981,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
 
 			if (wbc->sync_mode != WB_SYNC_NONE) {
 				if (PageWriteback(page))
-					flush_fn(data);
+					flush_write_bio(data);
 				wait_on_page_writeback(page);
 			}
 
@@ -4123,8 +4122,7 @@ int extent_writepages(struct extent_io_tree *tree,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
 	};
 
-	ret = extent_write_cache_pages(mapping, wbc, __extent_writepage, &epd,
-				       flush_write_bio);
+	ret = extent_write_cache_pages(mapping, wbc, __extent_writepage, &epd);
 	flush_write_bio(&epd);
 	return ret;
 }
-- 
2.15.1

