Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65039 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab2FRRfG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jun 2012 13:35:06 -0400
Received: by qcro28 with SMTP id o28so3013918qcr.19
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2012 10:35:06 -0700 (PDT)
From: Andrew Mahone <andrew.mahone@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Andrew Mahone <andrew.mahone@gmail.com>
Subject: [PATCH] btrfs: ignore unfragmented file checks in defrag when compression enabled
Date: Mon, 18 Jun 2012 13:27:37 -0400
Message-Id: <1340040457-16249-2-git-send-email-andrew.mahone@gmail.com>
In-Reply-To: <1340040457-16249-1-git-send-email-andrew.mahone@gmail.com>
References: <1340040457-16249-1-git-send-email-andrew.mahone@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Inform should_defrag_range if BTRFS_DEFRAG_RANGE_COMPRESS is set. If so, skip
checks for adjacent extents and extent size when deciding whether to defrag,
as these can prevent an uncompressed and unfragmented file from being
compressed as requested.

Signed-off-by: Andrew Mahone <andrew.mahone@gmail.com>
---
 fs/btrfs/ioctl.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 24b776c..ac48d7f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -812,7 +812,7 @@ static int check_adjacent_extents(struct inode *inode, struct extent_map *em)
 
 static int should_defrag_range(struct inode *inode, u64 start, u64 len,
 			       int thresh, u64 *last_len, u64 *skip,
-			       u64 *defrag_end)
+			       u64 *defrag_end, int compress)
 {
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_map *em = NULL;
@@ -853,7 +853,7 @@ static int should_defrag_range(struct inode *inode, u64 start, u64 len,
 	}
 
 	/* If we have nothing to merge with us, just skip. */
-	if (check_adjacent_extents(inode, em)) {
+	if (!compress && check_adjacent_extents(inode, em)) {
 		ret = 0;
 		goto out;
 	}
@@ -861,7 +861,8 @@ static int should_defrag_range(struct inode *inode, u64 start, u64 len,
 	/*
 	 * we hit a real extent, if it is big don't bother defragging it again
 	 */
-	if ((*last_len == 0 || *last_len >= thresh) && em->len >= thresh)
+	if (!compress &&
+	    (*last_len == 0 || *last_len >= thresh) && em->len >= thresh)
 		ret = 0;
 
 out:
@@ -1143,7 +1144,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 
 		if (!should_defrag_range(inode, (u64)i << PAGE_CACHE_SHIFT,
 					 PAGE_CACHE_SIZE, extent_thresh,
-					 &last_len, &skip, &defrag_end)) {
+					 &last_len, &skip, &defrag_end,
+					 range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)) {
 			unsigned long next;
 			/*
 			 * the should_defrag function tells us how much to skip
-- 
1.7.10.2

