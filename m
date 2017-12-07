Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49610 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754387AbdLGPtD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Dec 2017 10:49:03 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F3FB5AE12
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Dec 2017 15:49:01 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: merge two flush_write_bio helpers
Date: Thu,  7 Dec 2017 16:47:03 +0100
Message-Id: <35c579c8ffc850039be08da0b72e410cdc80016e.1512661509.git.dsterba@suse.com>
In-Reply-To: <cover.1512661509.git.dsterba@suse.com>
References: <cover.1512661509.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

flush_epd_write_bio is same as flush_write_bio, no point having two such
functions. Merge them to flush_write_bio. The 'noinline' attribute is
removed as it does not have any meaning.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 16ae832bdb5d..fd1a2ff1e96d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -138,7 +138,8 @@ static void add_extent_changeset(struct extent_state *state, unsigned bits,
 	BUG_ON(ret < 0);
 }
 
-static noinline void flush_write_bio(void *data);
+static void flush_write_bio(void *data);
+
 static inline struct btrfs_fs_info *
 tree_fs_info(struct extent_io_tree *tree)
 {
@@ -4039,8 +4040,10 @@ static int extent_write_cache_pages(struct address_space *mapping,
 	return ret;
 }
 
-static void flush_epd_write_bio(struct extent_page_data *epd)
+static void flush_write_bio(void *data)
 {
+	struct extent_page_data *epd = data;
+
 	if (epd->bio) {
 		int ret;
 
@@ -4050,12 +4053,6 @@ static void flush_epd_write_bio(struct extent_page_data *epd)
 	}
 }
 
-static noinline void flush_write_bio(void *data)
-{
-	struct extent_page_data *epd = data;
-	flush_epd_write_bio(epd);
-}
-
 int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
 			  struct writeback_control *wbc)
 {
@@ -4069,7 +4066,7 @@ int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
 
 	ret = __extent_writepage(page, wbc, &epd);
 
-	flush_epd_write_bio(&epd);
+	flush_write_bio(&epd);
 	return ret;
 }
 
@@ -4110,7 +4107,7 @@ int extent_write_locked_range(struct extent_io_tree *tree, struct inode *inode,
 		start += PAGE_SIZE;
 	}
 
-	flush_epd_write_bio(&epd);
+	flush_write_bio(&epd);
 	return ret;
 }
 
@@ -4128,7 +4125,7 @@ int extent_writepages(struct extent_io_tree *tree,
 
 	ret = extent_write_cache_pages(mapping, wbc, __extent_writepage, &epd,
 				       flush_write_bio);
-	flush_epd_write_bio(&epd);
+	flush_write_bio(&epd);
 	return ret;
 }
 
-- 
2.15.1

