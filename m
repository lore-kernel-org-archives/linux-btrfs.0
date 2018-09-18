Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33605 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbeIRPlP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 11:41:15 -0400
Received: by mail-wr1-f65.google.com with SMTP id v90-v6so1450025wrc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 03:09:22 -0700 (PDT)
From: Timofey Titovets <timofey.titovets@synesis.ru>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH RESEND] Btrfs: make should_defrag_range() understood compressed extents
Date: Tue, 18 Sep 2018 13:09:13 +0300
Message-Id: <20180918100913.31285-1-timofey.titovets@synesis.ru>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Timofey Titovets <nefelim4ag@gmail.com>

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
index a990a9045139..0a5ea1ccc89d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1142,7 +1142,7 @@ static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em)
 
 static int should_defrag_range(struct inode *inode, u64 start, u32 thresh,
 			       u64 *last_len, u64 *skip, u64 *defrag_end,
-			       int compress)
+			       int compress, int compress_type)
 {
 	struct extent_map *em;
 	int ret = 1;
@@ -1177,8 +1177,29 @@ static int should_defrag_range(struct inode *inode, u64 start, u32 thresh,
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
@@ -1477,7 +1498,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 
 		if (!should_defrag_range(inode, (u64)i << PAGE_SHIFT,
 					 extent_thresh, &last_len, &skip,
-					 &defrag_end, do_compress)){
+					 &defrag_end, do_compress,
+					 compress_type)){
 			unsigned long next;
 			/*
 			 * the should_defrag function tells us how much to skip
-- 
2.19.0
