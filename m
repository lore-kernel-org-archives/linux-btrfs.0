Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:34967 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdIKVGs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 17:06:48 -0400
Received: by mail-wr0-f180.google.com with SMTP id m18so17043361wrm.2
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 14:06:48 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v2] Btrfs: clear_dirty only on pages in compression range
Date: Tue, 12 Sep 2017 00:06:37 +0300
Message-Id: <20170911210637.24510-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At now while compressing data range code touch dirty
page status on whole range on each BTRFS_MAX_UNCOMPRESSED (128kb)
iteration, that's costs time

As we care only about page status in range that will be compressed
in current iteration, let's touch dirty status only for actual
compression range

v1 -> v2:
 - Make that more obviously and more safeprone

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/inode.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 17ad018da0a2..8229a000c538 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -449,6 +449,7 @@ static noinline void compress_file_range(struct inode *inode,
 	u64 num_bytes;
 	u64 blocksize = fs_info->sectorsize;
 	u64 actual_end;
+	u64 current_end;
 	u64 isize = i_size_read(inode);
 	int ret = 0;
 	struct page **pages = NULL;
@@ -498,6 +499,10 @@ static noinline void compress_file_range(struct inode *inode,
 			BTRFS_MAX_UNCOMPRESSED);
 	num_bytes = ALIGN(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
+	if (end - start > BTRFS_MAX_UNCOMPRESSED)
+		current_end = start + BTRFS_MAX_UNCOMPRESSED;
+	else
+		current_end = end;
 	total_in = 0;
 	ret = 0;

@@ -506,7 +511,7 @@ static noinline void compress_file_range(struct inode *inode,
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (inode_need_compress(inode, start, end)) {
+	if (inode_need_compress(inode, start, current_end)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {
@@ -528,7 +533,7 @@ static noinline void compress_file_range(struct inode *inode,
 		 * If the compression fails for any reason, we set the pages
 		 * dirty again later on.
 		 */
-		extent_range_clear_dirty_for_io(inode, start, end);
+		extent_range_clear_dirty_for_io(inode, start, current_end);
 		redirty = 1;
 		ret = btrfs_compress_pages(compress_type,
 					   inode->i_mapping, start,
@@ -667,7 +672,7 @@ static noinline void compress_file_range(struct inode *inode,
 		/* unlocked later on in the async handlers */

 	if (redirty)
-		extent_range_redirty_for_io(inode, start, end);
+		extent_range_redirty_for_io(inode, start, current_end);
 	add_async_extent(async_cow, start, end - start + 1, 0, NULL, 0,
 			 BTRFS_COMPRESS_NONE);
 	*num_added += 1;
--
2.14.1
