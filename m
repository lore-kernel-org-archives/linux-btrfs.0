Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:37062 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932287AbdHWRXt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 13:23:49 -0400
Received: by mail-wr0-f194.google.com with SMTP id 72so84612wrc.4
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 10:23:48 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [RFC PATCH] Btrfs: clear_dirty only on pages in compression range
Date: Wed, 23 Aug 2017 20:23:29 +0300
Message-Id: <20170823172329.5794-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At now while compressing data range code touch dirty
page status on whole range on each 128kb iteration, that's costs time

As we care only about page status in range that will be compressed
in current iteration, let's touch dirty status only for actual
compression range

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2b92478fe7ec..cb7779b08aaf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -449,6 +449,7 @@ static noinline void compress_file_range(struct inode *inode,
 	u64 num_bytes;
 	u64 blocksize = fs_info->sectorsize;
 	u64 actual_end;
+	u64 compress_range_end;
 	u64 isize = i_size_read(inode);
 	int ret = 0;
 	struct page **pages = NULL;
@@ -500,6 +501,8 @@ static noinline void compress_file_range(struct inode *inode,
 	num_bytes = max(blocksize,  num_bytes);
 	total_in = 0;
 	ret = 0;
+	compress_range_end = start + min_t(u64, BTRFS_MAX_UNCOMPRESSED,
+					   end - start);

 	/*
 	 * we do compression for mount -o compress and when the
@@ -528,7 +531,8 @@ static noinline void compress_file_range(struct inode *inode,
 		 * If the compression fails for any reason, we set the pages
 		 * dirty again later on.
 		 */
-		extent_range_clear_dirty_for_io(inode, start, end);
+		extent_range_clear_dirty_for_io(inode, start,
+						compress_range_end);
 		redirty = 1;
 		ret = btrfs_compress_pages(compress_type,
 					   inode->i_mapping, start,
@@ -667,7 +671,7 @@ static noinline void compress_file_range(struct inode *inode,
 		/* unlocked later on in the async handlers */

 	if (redirty)
-		extent_range_redirty_for_io(inode, start, end);
+		extent_range_redirty_for_io(inode, start, compress_range_end);
 	add_async_extent(async_cow, start, end - start + 1, 0, NULL, 0,
 			 BTRFS_COMPRESS_NONE);
 	*num_added += 1;
--
2.14.1
