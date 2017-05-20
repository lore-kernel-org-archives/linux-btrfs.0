Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35718 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756320AbdETQuK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 May 2017 12:50:10 -0400
Received: by mail-lf0-f65.google.com with SMTP id 99so2167266lfu.2
        for <linux-btrfs@vger.kernel.org>; Sat, 20 May 2017 09:50:09 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v2 1/2] Btrfs: lzo.c pr_debug() deflate->lzo
Date: Sat, 20 May 2017 19:49:52 +0300
Message-Id: <20170520164953.7344-2-nefelim4ag@gmail.com>
In-Reply-To: <20170520164953.7344-1-nefelim4ag@gmail.com>
References: <20170520164953.7344-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/lzo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index f48c8c14..bd0b0938 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -141,7 +141,7 @@ static int lzo_compress_pages(struct list_head *ws,
 		ret = lzo1x_1_compress(data_in, in_len, workspace->cbuf,
 				       &out_len, workspace->mem);
 		if (ret != LZO_E_OK) {
-			pr_debug("BTRFS: deflate in loop returned %d\n",
+			pr_debug("BTRFS: lzo in loop returned %d\n",
 			       ret);
 			ret = -EIO;
 			goto out;
--
2.13.0
