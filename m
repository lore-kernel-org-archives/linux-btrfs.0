Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32792 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755379AbcKBDZq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Nov 2016 23:25:46 -0400
Received: by mail-pf0-f195.google.com with SMTP id a136so405502pfa.0
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Nov 2016 20:25:46 -0700 (PDT)
From: Nick Terrell <nickrterrell@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nick Terrell <nickrterrell@gmail.com>
Subject: [PATCH] btrfs: Call kunmap if zlib_inflateInit2 fails
Date: Tue,  1 Nov 2016 20:25:27 -0700
Message-Id: <20161102032527.62311-1-nickrterrell@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If zlib_inflateInit2 fails, the input page is never unmapped.
Add a call to kunmap when it fails.

Signed-off-by: Nick Terrell <nickrterrell@gmail.com>
---
 fs/btrfs/zlib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 88d274e..30e19c9 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -250,6 +250,7 @@ static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
 
 	if (Z_OK != zlib_inflateInit2(&workspace->strm, wbits)) {
 		printk(KERN_WARNING "BTRFS: inflateInit failed\n");
+		kunmap(pages_in[page_in_index]);
 		return -EIO;
 	}
 	while (workspace->strm.total_in < srclen) {
-- 
2.7.4

