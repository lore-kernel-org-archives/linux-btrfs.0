Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36778 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751401AbdGQSrX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jul 2017 14:47:23 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 25040AAB6
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Jul 2017 18:47:22 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: defrag: cleanup checking for compression status
Date: Mon, 17 Jul 2017 20:46:08 +0200
Message-Id: <478c34f701ea6ed1f028d96390586cffaa38f438.1500317040.git.dsterba@suse.com>
In-Reply-To: <cover.1500317040.git.dsterba@suse.com>
References: <cover.1500317040.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5d28d53e1b81..37226b13e289 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1286,6 +1286,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 	unsigned long cluster = max_cluster;
 	u64 new_align = ~((u64)SZ_128K - 1);
 	struct page **pages = NULL;
+	bool do_compress = range->flags & BTRFS_DEFRAG_RANGE_COMPRESS;
 
 	if (isize == 0)
 		return 0;
@@ -1293,7 +1294,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 	if (range->start >= isize)
 		return -EINVAL;
 
-	if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS) {
+	if (do_compress) {
 		if (range->compress_type > BTRFS_COMPRESS_TYPES)
 			return -EINVAL;
 		if (range->compress_type)
@@ -1373,8 +1374,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 
 		if (!should_defrag_range(inode, (u64)i << PAGE_SHIFT,
 					 extent_thresh, &last_len, &skip,
-					 &defrag_end, range->flags &
-					 BTRFS_DEFRAG_RANGE_COMPRESS)) {
+					 &defrag_end, do_compress)){
 			unsigned long next;
 			/*
 			 * the should_defrag function tells us how much to skip
@@ -1401,7 +1401,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		}
 
 		inode_lock(inode);
-		if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)
+		if (do_compress)
 			BTRFS_I(inode)->defrag_compress = compress_type;
 		ret = cluster_pages_for_defrag(inode, pages, i, cluster);
 		if (ret < 0) {
@@ -1449,7 +1449,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			filemap_flush(inode->i_mapping);
 	}
 
-	if ((range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)) {
+	if (do_compress) {
 		/* the filemap_flush will queue IO into the worker threads, but
 		 * we have to make sure the IO is actually started and that
 		 * ordered extents get created before we return
@@ -1471,7 +1471,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 	ret = defrag_count;
 
 out_ra:
-	if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS) {
+	if (do_compress) {
 		inode_lock(inode);
 		BTRFS_I(inode)->defrag_compress = BTRFS_COMPRESS_NONE;
 		inode_unlock(inode);
-- 
2.13.0

