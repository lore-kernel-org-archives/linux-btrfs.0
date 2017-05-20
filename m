Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34032 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756326AbdETQuL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 May 2017 12:50:11 -0400
Received: by mail-lf0-f66.google.com with SMTP id q24so2172252lfb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 20 May 2017 09:50:10 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v2 2/2] Btrfs: compression must free at least PAGE_SIZE
Date: Sat, 20 May 2017 19:49:53 +0300
Message-Id: <20170520164953.7344-3-nefelim4ag@gmail.com>
In-Reply-To: <20170520164953.7344-1-nefelim4ag@gmail.com>
References: <20170520164953.7344-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs already skip store of data where compression didn't free at least one byte.
So make logic better and make check that compression free at least one PAGE_SIZE,
because in another case it useless to store this data compressed

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/lzo.c  | 5 ++++-
 fs/btrfs/zlib.c | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index bd0b0938..7f38bc3c 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -229,8 +229,11 @@ static int lzo_compress_pages(struct list_head *ws,
 		in_len = min(bytes_left, PAGE_SIZE);
 	}

-	if (tot_out > tot_in)
+	/* Compression must save at least one PAGE_SIZE */
+	if (tot_out + PAGE_SIZE => tot_in) {
+		ret = -E2BIG;
 		goto out;
+	}

 	/* store the size of all chunks of compressed data */
 	cpage_out = kmap(pages[0]);
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 135b1082..2b04259b 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -191,7 +191,8 @@ static int zlib_compress_pages(struct list_head *ws,
 		goto out;
 	}

-	if (workspace->strm.total_out >= workspace->strm.total_in) {
+	/* Compression must save at least one PAGE_SIZE */
+	if (workspace->strm.total_out + PAGE_SIZE >= workspace->strm.total_in) {
 		ret = -E2BIG;
 		goto out;
 	}
--
2.13.0
