Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33471 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751403AbdETSky (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 May 2017 14:40:54 -0400
Received: by mail-lf0-f67.google.com with SMTP id m18so2283129lfj.0
        for <linux-btrfs@vger.kernel.org>; Sat, 20 May 2017 11:40:53 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v3 1/2] Btrfs: lzo.c pr_debug() deflate->lzo
Date: Sat, 20 May 2017 21:40:38 +0300
Message-Id: <20170520184039.31362-2-nefelim4ag@gmail.com>
In-Reply-To: <20170520184039.31362-1-nefelim4ag@gmail.com>
References: <20170520184039.31362-1-nefelim4ag@gmail.com>
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
