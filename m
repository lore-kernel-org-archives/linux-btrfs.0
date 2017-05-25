Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36389 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761841AbdEYSMo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 14:12:44 -0400
Received: by mail-wm0-f68.google.com with SMTP id k15so53738913wmh.3
        for <linux-btrfs@vger.kernel.org>; Thu, 25 May 2017 11:12:44 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v4 2/2] Btrfs: compression must free at least one sector size
Date: Thu, 25 May 2017 21:12:20 +0300
Message-Id: <20170525181220.24692-3-nefelim4ag@gmail.com>
In-Reply-To: <20170525181220.24692-1-nefelim4ag@gmail.com>
References: <20170525181220.24692-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs already skip store of data where compression didn't
free at least one byte. Let's make logic better and make check
that compression free at least one sector size
because in another case it useless to store this data compressed

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/lzo.c  | 9 ++++++++-
 fs/btrfs/zlib.c | 7 ++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index bd0b0938..4aafae6f 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -26,6 +26,7 @@
 #include <linux/bio.h>
 #include <linux/lzo.h>
 #include "compression.h"
+#include "ctree.h"

 #define LZO_LEN	4

@@ -99,6 +100,7 @@ static int lzo_compress_pages(struct list_head *ws,
 	int nr_pages = 0;
 	struct page *in_page = NULL;
 	struct page *out_page = NULL;
+	u32 sectorsize;
 	unsigned long bytes_left;
 	unsigned long len = *total_out;
 	unsigned long nr_dest_pages = *out_pages;
@@ -229,8 +231,13 @@ static int lzo_compress_pages(struct list_head *ws,
 		in_len = min(bytes_left, PAGE_SIZE);
 	}

-	if (tot_out > tot_in)
+	/* Compression must save at least one sectorsize */
+	sectorsize = btrfs_inode_sectorsize(mapping->host);
+
+	if (tot_out + sectorsize > tot_in) {
+		ret = -E2BIG;
 		goto out;
+	}

 	/* store the size of all chunks of compressed data */
 	cpage_out = kmap(pages[0]);
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 135b1082..f9957248 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -31,6 +31,7 @@
 #include <linux/pagemap.h>
 #include <linux/bio.h>
 #include "compression.h"
+#include "ctree.h"

 struct workspace {
 	z_stream strm;
@@ -86,6 +87,7 @@ static int zlib_compress_pages(struct list_head *ws,
 	int nr_pages = 0;
 	struct page *in_page = NULL;
 	struct page *out_page = NULL;
+	u32 sectorsize;
 	unsigned long bytes_left;
 	unsigned long len = *total_out;
 	unsigned long nr_dest_pages = *out_pages;
@@ -191,7 +193,10 @@ static int zlib_compress_pages(struct list_head *ws,
 		goto out;
 	}

-	if (workspace->strm.total_out >= workspace->strm.total_in) {
+	/* Compression must save at least one sectorsize */
+	sectorsize = btrfs_inode_sectorsize(mapping->host);
+
+	if (workspace->strm.total_out + sectorsize > workspace->strm.total_in) {
 		ret = -E2BIG;
 		goto out;
 	}
--
2.13.0
