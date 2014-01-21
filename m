Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36999 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaAUTSg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 14:18:36 -0500
Received: by mail-pd0-f173.google.com with SMTP id y10so5034721pdj.32
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jan 2014 11:18:35 -0800 (PST)
From: Justin Maggard <jmaggard10@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard10@gmail.com>
Subject: [PATCH] btrfs: fix defrag 32-bit integer overflow
Date: Tue, 21 Jan 2014 11:18:29 -0800
Message-Id: <1390331909-7476-1-git-send-email-jmaggard10@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When defragging a very large file, the cluster variable can wrap its 32-bit
signed int type and become negative, which eventually gets passed to
btrfs_force_ra() as a very large unsigned long value.  On 32-bit platforms,
this eventually results in an Oops from the SLAB allocator.

Change the cluster and max_cluster signed int variables to unsigned long to
match the readahead functions.  This also allows the min() comparison in
btrfs_defrag_file() to work as intended.
---
 fs/btrfs/ioctl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 21da576..22e9837 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1011,7 +1011,7 @@ out:
 static int cluster_pages_for_defrag(struct inode *inode,
 				    struct page **pages,
 				    unsigned long start_index,
-				    int num_pages)
+				    unsigned long num_pages)
 {
 	unsigned long file_end;
 	u64 isize = i_size_read(inode);
@@ -1169,8 +1169,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 	int defrag_count = 0;
 	int compress_type = BTRFS_COMPRESS_ZLIB;
 	int extent_thresh = range->extent_thresh;
-	int max_cluster = (256 * 1024) >> PAGE_CACHE_SHIFT;
-	int cluster = max_cluster;
+	unsigned long max_cluster = (256 * 1024) >> PAGE_CACHE_SHIFT;
+	unsigned long cluster = max_cluster;
 	u64 new_align = ~((u64)128 * 1024 - 1);
 	struct page **pages = NULL;
 
-- 
1.7.9.5

