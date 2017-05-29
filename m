Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35434 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdE2XSd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 19:18:33 -0400
Received: by mail-wm0-f67.google.com with SMTP id g15so21108750wmc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 29 May 2017 16:18:32 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v5 1/2] Btrfs: lzo.c - compressed data size must be less then input size
Date: Tue, 30 May 2017 02:18:04 +0300
Message-Id: <20170529231805.4797-2-nefelim4ag@gmail.com>
In-Reply-To: <20170529231805.4797-1-nefelim4ag@gmail.com>
References: <20170529231805.4797-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Logic already return error if compression
make data bigger, let's sync logic with zlib
and also return error if compressed size
are equal to input size

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/lzo.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index f48c8c14..f66691e0 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -229,8 +229,10 @@ static int lzo_compress_pages(struct list_head *ws,
 		in_len = min(bytes_left, PAGE_SIZE);
 	}

-	if (tot_out > tot_in)
+	if (tot_out >= tot_in) {
+		ret = -E2BIG;
 		goto out;
+	}

 	/* store the size of all chunks of compressed data */
 	cpage_out = kmap(pages[0]);
--
2.13.0
