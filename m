Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:42114 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756412AbdLOV2F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 16:28:05 -0500
Received: by mail-wr0-f195.google.com with SMTP id s66so9150860wrc.9
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 13:28:05 -0800 (PST)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH] Btrfs: allow btrfs_defrag_file() uncompress files on defragmentation
Date: Sat, 16 Dec 2017 00:27:21 +0300
Message-Id: <20171215212721.19866-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently defrag ioctl only support compress files with specified
compression type. Allow set compression type to none, while call defrag.

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/btrfs_inode.h |  1 +
 fs/btrfs/inode.c       |  4 ++--
 fs/btrfs/ioctl.c       | 17 ++++++++++-------
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 63f0ccc92a71..9eb0c92ee4b4 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -187,6 +187,7 @@ struct btrfs_inode {
 	 * different from prop_compress and takes precedence if set
 	 */
 	unsigned defrag_compress;
+	unsigned change_compress;
 
 	struct btrfs_delayed_node *delayed_node;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 46df5e2a64e7..7af8f1784788 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -412,8 +412,8 @@ static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)
 	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
 		return 1;
 	/* defrag ioctl */
-	if (BTRFS_I(inode)->defrag_compress)
-		return 1;
+	if (BTRFS_I(inode)->change_compress)
+		return BTRFS_I(inode)->defrag_compress;
 	/* bad compression ratios */
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
 		return 0;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 12d4fa5d6dec..b777c8f53153 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1276,7 +1276,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 	unsigned long cluster = max_cluster;
 	u64 new_align = ~((u64)SZ_128K - 1);
 	struct page **pages = NULL;
-	bool do_compress = range->flags & BTRFS_DEFRAG_RANGE_COMPRESS;
+	bool change_compress = range->flags & BTRFS_DEFRAG_RANGE_COMPRESS;
 
 	if (isize == 0)
 		return 0;
@@ -1284,11 +1284,10 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 	if (range->start >= isize)
 		return -EINVAL;
 
-	if (do_compress) {
+	if (change_compress) {
 		if (range->compress_type > BTRFS_COMPRESS_TYPES)
 			return -EINVAL;
-		if (range->compress_type)
-			compress_type = range->compress_type;
+		compress_type = range->compress_type;
 	}
 
 	if (extent_thresh == 0)
@@ -1363,7 +1362,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 
 		if (!should_defrag_range(inode, (u64)i << PAGE_SHIFT,
 					 extent_thresh, &last_len, &skip,
-					 &defrag_end, do_compress,
+					 &defrag_end, change_compress,
 					 compress_type)){
 			unsigned long next;
 			/*
@@ -1392,8 +1391,11 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		}
 
 		inode_lock(inode);
-		if (do_compress)
+		if (change_compress) {
+			BTRFS_I(inode)->change_compress = change_compress;
 			BTRFS_I(inode)->defrag_compress = compress_type;
+		}
+
 		ret = cluster_pages_for_defrag(inode, pages, i, cluster);
 		if (ret < 0) {
 			inode_unlock(inode);
@@ -1449,8 +1451,9 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 	ret = defrag_count;
 
 out_ra:
-	if (do_compress) {
+	if (change_compress) {
 		inode_lock(inode);
+		BTRFS_I(inode)->change_compress = 0;
 		BTRFS_I(inode)->defrag_compress = BTRFS_COMPRESS_NONE;
 		inode_unlock(inode);
 	}
-- 
2.15.1

