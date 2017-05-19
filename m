Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33799 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754058AbdESNiq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 09:38:46 -0400
Received: by mail-wm0-f66.google.com with SMTP id d127so18359918wmf.1
        for <linux-btrfs@vger.kernel.org>; Fri, 19 May 2017 06:38:45 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 1/3] Btrfs: lzo.c pr_debug() deflate->lzo
Date: Fri, 19 May 2017 16:38:33 +0300
Message-Id: <20170519133835.27843-2-nefelim4ag@gmail.com>
In-Reply-To: <20170519133835.27843-1-nefelim4ag@gmail.com>
References: <20170519133835.27843-1-nefelim4ag@gmail.com>
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

