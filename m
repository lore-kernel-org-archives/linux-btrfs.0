Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34717 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbeDXXk7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 19:40:59 -0400
Received: by mail-lf0-f66.google.com with SMTP id m13-v6so8614295lfc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 16:40:58 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 2/4] [RESEND] Btrfs: make should_defrag_range() understood compressed extents
Date: Wed, 25 Apr 2018 02:37:15 +0300
Message-Id: <20180424233717.31283-3-nefelim4ag@gmail.com>
In-Reply-To: <20180424233717.31283-1-nefelim4ag@gmail.com>
References: <20180424233717.31283-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 Both, defrag ioctl and autodefrag - call btrfs_defrag_file()
 for file defragmentation.

 Kernel default target extent size - 256KiB.
 Btrfs progs default - 32MiB.

 Both bigger then maximum size of compressed extent - 128KiB.
 That lead to rewrite all compressed data on disk.

 Fix that by check compression extents with different logic.

 As addition, make should_defrag_range() understood compressed extent type,
 if requested target compression are same as current extent compression type.
 Just don't recompress/rewrite extents.
 To avoid useless recompression of compressed extents.

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/ioctl.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 45a47d0891fc..b29ea1f0f621 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1008,7 +1008,7 @@ static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em)
 
 static int should_defrag_range(struct inode *inode, u64 start, u32 thresh,
 			       u64 *last_len, u64 *skip, u64 *defrag_end,
-			       int compress)
+			       int compress, int compress_type)
 {
 	struct extent_map *em;
 	int ret = 1;
@@ -1043,8 +1043,29 @@ static int should_defrag_range(struct inode *inode, u64 start, u32 thresh,
 	 * real extent, don't bother defragging it
 	 */
 	if (!compress && (*last_len == 0 || *last_len >= thresh) &&
-	    (em->len >= thresh || (!next_mergeable && !prev_mergeable)))
+	    (em->len >= thresh || (!next_mergeable && !prev_mergeable))) {
 		ret = 0;
+		goto out;
+	}
+
+
+	/*
+	 * Try not recompress compressed extents
+	 * thresh >= BTRFS_MAX_UNCOMPRESSED will lead to
+	 * recompress all compressed extents
+	 */
+	if (em->compress_type != 0 && thresh >= BTRFS_MAX_UNCOMPRESSED) {
+		if (!compress) {
+			if (em->len == BTRFS_MAX_UNCOMPRESSED)
+				ret = 0;
+		} else {
+			if (em->compress_type != compress_type)
+				goto out;
+			if (em->len == BTRFS_MAX_UNCOMPRESSED)
+				ret = 0;
+		}
+	}
+
 out:
 	/*
 	 * last_len ends up being a counter of how many bytes we've defragged.
@@ -1342,7 +1363,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 
 		if (!should_defrag_range(inode, (u64)i << PAGE_SHIFT,
 					 extent_thresh, &last_len, &skip,
-					 &defrag_end, do_compress)){
+					 &defrag_end, do_compress,
+					 compress_type)){
 			unsigned long next;
 			/*
 			 * the should_defrag function tells us how much to skip
-- 
2.15.1
