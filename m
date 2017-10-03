Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:51713 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751874AbdJCPHH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Oct 2017 11:07:07 -0400
Received: by mail-lf0-f67.google.com with SMTP id m142so6294093lfg.8
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Oct 2017 08:07:07 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 2/4] Btrfs: clear_dirty only on pages only in compression range
Date: Tue,  3 Oct 2017 18:06:02 +0300
Message-Id: <20171003150604.19596-3-nefelim4ag@gmail.com>
In-Reply-To: <20171003150604.19596-1-nefelim4ag@gmail.com>
References: <20171003150604.19596-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need to call extent_range_clear_dirty_for_io()
on compression range to prevent application from changing
page content, while pages compressing.

but "(end - start)" can be much (up to 1024 times) bigger
then compression range (BTRFS_MAX_UNCOMPRESSED), so optimize that
by calculating compression range for
that loop iteration, and flip bits only on that range

v1 -> v2:
 - Make that more obviously and more safeprone

v2 -> v3:
 - Rebased on:
   Btrfs: compress_file_range() remove dead variable num_bytes
 - Update change log
 - Add comments

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/inode.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 237df8fdf7b8..b6e81bd650ea 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -460,6 +460,7 @@ static noinline void compress_file_range(struct inode *inode,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 blocksize = fs_info->sectorsize;
 	u64 actual_end;
+	u64 current_end;
 	u64 isize = i_size_read(inode);
 	int ret = 0;
 	struct page **pages = NULL;
@@ -505,6 +506,21 @@ static noinline void compress_file_range(struct inode *inode,
 	   (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
 		goto cleanup_and_bail_uncompressed;

+	/*
+	 * We need to call extent_range_clear_dirty_for_io()
+	 * on compression range to prevent application from changing
+	 * page content, while pages compressing.
+	 *
+	 * but (end - start) can be much (up to 1024 times) bigger
+	 * then compression range, so optimize that
+	 * by calculating compression range for
+	 * that iteration, and flip bits only on that range
+	 */
+	if (end - start > BTRFS_MAX_UNCOMPRESSED)
+		current_end = start + BTRFS_MAX_UNCOMPRESSED;
+	else
+		current_end = end;
+
 	total_compressed = min_t(unsigned long, total_compressed,
 			BTRFS_MAX_UNCOMPRESSED);
 	total_in = 0;
@@ -515,7 +531,7 @@ static noinline void compress_file_range(struct inode *inode,
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (inode_need_compress(inode, start, end)) {
+	if (inode_need_compress(inode, start, current_end)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {
@@ -530,14 +546,15 @@ static noinline void compress_file_range(struct inode *inode,

 		/*
 		 * we need to call clear_page_dirty_for_io on each
-		 * page in the range.  Otherwise applications with the file
-		 * mmap'd can wander in and change the page contents while
+		 * page in compression the range.
+		 * Otherwise applications with the file mmap'd
+		 * can wander in and change the page contents while
 		 * we are compressing them.
 		 *
 		 * If the compression fails for any reason, we set the pages
 		 * dirty again later on.
 		 */
-		extent_range_clear_dirty_for_io(inode, start, end);
+		extent_range_clear_dirty_for_io(inode, start, current_end);
 		redirty = 1;

 		/* Compression level is applied here and only here */
@@ -678,7 +695,7 @@ static noinline void compress_file_range(struct inode *inode,
 		/* unlocked later on in the async handlers */

 	if (redirty)
-		extent_range_redirty_for_io(inode, start, end);
+		extent_range_redirty_for_io(inode, start, current_end);
 	add_async_extent(async_cow, start, end - start + 1, 0, NULL, 0,
 			 BTRFS_COMPRESS_NONE);
 	*num_added += 1;
--
2.14.2
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
