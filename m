Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46450 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934096AbdBQSG3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 13:06:29 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 69316ABCC
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 18:06:28 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/5] btrfs: use predefined limits for calculating maximum number of pages for compression
Date: Fri, 17 Feb 2017 19:05:58 +0100
Message-Id: <0e48bca3ab8fe6062c54e6caf846f3799740f3b6.1487354456.git.dsterba@suse.com>
In-Reply-To: <cover.1487354456.git.dsterba@suse.com>
References: <cover.1487354456.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bc547608ff1a..9533a516bace 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -432,8 +432,6 @@ static noinline void compress_file_range(struct inode *inode,
 	unsigned long nr_pages;
 	unsigned long total_compressed = 0;
 	unsigned long total_in = 0;
-	unsigned long max_compressed = SZ_128K;
-	unsigned long max_uncompressed = SZ_128K;
 	int i;
 	int will_compress;
 	int compress_type = fs_info->compress_type;
@@ -445,7 +443,9 @@ static noinline void compress_file_range(struct inode *inode,
 again:
 	will_compress = 0;
 	nr_pages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
-	nr_pages = min_t(unsigned long, nr_pages, SZ_128K / PAGE_SIZE);
+	BUILD_BUG_ON((BTRFS_MAX_COMPRESSED % PAGE_SIZE) != 0);
+	nr_pages = min_t(unsigned long, nr_pages,
+			BTRFS_MAX_COMPRESSED / PAGE_SIZE);
 
 	/*
 	 * we don't want to send crud past the end of i_size through
@@ -470,7 +470,8 @@ static noinline void compress_file_range(struct inode *inode,
 	   (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
 		goto cleanup_and_bail_uncompressed;
 
-	total_compressed = min(total_compressed, max_uncompressed);
+	total_compressed = min_t(unsigned long, total_compressed,
+			BTRFS_MAX_UNCOMPRESSED);
 	num_bytes = ALIGN(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
 	total_in = 0;
@@ -509,7 +510,7 @@ static noinline void compress_file_range(struct inode *inode,
 					   &nr_pages,
 					   &total_in,
 					   &total_compressed,
-					   max_compressed);
+					   BTRFS_MAX_COMPRESSED);
 
 		if (!ret) {
 			unsigned long offset = total_compressed &
-- 
2.10.1

