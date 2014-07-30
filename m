Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:39424 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbaG3Umj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 16:42:39 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: clm@fb.com
Cc: jbacik@fb.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Remove certain calls for releasing page cache
Date: Wed, 30 Jul 2014 16:42:34 -0400
Message-Id: <1406752954-26158-1-git-send-email-xerofoify@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes the lines for releasing the page cache in certain
files as this may aid in perfomance with writes in the compression
rountines of btrfs. Please note that this patch has not been tested
on my own hardware due to no compression based btrfs volumes of my
own.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 fs/btrfs/compression.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 1daea0b..b55b0e1 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1,4 +1,5 @@
 /*
+	
  * Copyright (C) 2008 Oracle.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -246,7 +247,6 @@ static noinline void end_compressed_writeback(struct inode *inode, u64 start,
 		}
 		for (i = 0; i < ret; i++) {
 			end_page_writeback(pages[i]);
-			page_cache_release(pages[i]);
 		}
 		nr_pages -= ret;
 		index += ret;
@@ -293,21 +293,6 @@ static void end_compressed_bio_write(struct bio *bio, int err)
 
 	end_compressed_writeback(inode, cb->start, cb->len);
 	/* note, our inode could be gone now */
-
-	/*
-	 * release the compressed pages, these came from alloc_page and
-	 * are not attached to the inode at all
-	 */
-	index = 0;
-	for (index = 0; index < cb->nr_pages; index++) {
-		page = cb->compressed_pages[index];
-		page->mapping = NULL;
-		page_cache_release(page);
-	}
-
-	/* finally free the cb struct */
-	kfree(cb->compressed_pages);
-	kfree(cb);
 out:
 	bio_put(bio);
 }
-- 
1.9.1

