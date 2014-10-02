Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaJBQtu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:49:50 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A6BBDAAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:49:49 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 01/14] btrfs: defrag, use unsigned type for extent thresh
Date: Thu,  2 Oct 2014 18:49:49 +0200
Message-Id: <aab110abcbbf06b5d52d9974b4a72d3c7cd38537.1412264872.git.dsterba@suse.cz>
In-Reply-To: <cover.1412264871.git.dsterba@suse.cz>
References: <cover.1412264871.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed type mismatches the ioctl structure, all extent calculations are
done on unsigned types.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0ff212757b95..87a7267a6bb2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -885,7 +885,7 @@ out_unlock:
  * file you want to defrag, we return 0 to let you know to skip this
  * part of the file
  */
-static int check_defrag_in_cache(struct inode *inode, u64 offset, int thresh)
+static int check_defrag_in_cache(struct inode *inode, u64 offset, u32 thresh)
 {
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_map *em = NULL;
@@ -920,7 +920,7 @@ static int check_defrag_in_cache(struct inode *inode, u64 offset, int thresh)
  */
 static int find_new_extents(struct btrfs_root *root,
 			    struct inode *inode, u64 newer_than,
-			    u64 *off, int thresh)
+			    u64 *off, u32 thresh)
 {
 	struct btrfs_path *path;
 	struct btrfs_key min_key;
@@ -1029,7 +1029,7 @@ static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em)
 	return ret;
 }
 
-static int should_defrag_range(struct inode *inode, u64 start, int thresh,
+static int should_defrag_range(struct inode *inode, u64 start, u32 thresh,
 			       u64 *last_len, u64 *skip, u64 *defrag_end,
 			       int compress)
 {
@@ -1259,7 +1259,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 	int ret;
 	int defrag_count = 0;
 	int compress_type = BTRFS_COMPRESS_ZLIB;
-	int extent_thresh = range->extent_thresh;
+	u32 extent_thresh = range->extent_thresh;
 	unsigned long max_cluster = (256 * 1024) >> PAGE_CACHE_SHIFT;
 	unsigned long cluster = max_cluster;
 	u64 new_align = ~((u64)128 * 1024 - 1);
-- 
1.8.4.5

