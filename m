Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33642 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdESNiq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 09:38:46 -0400
Received: by mail-wm0-f66.google.com with SMTP id b84so2534608wmh.0
        for <linux-btrfs@vger.kernel.org>; Fri, 19 May 2017 06:38:46 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 2/3] Btrfs: lzo compression must free at least PAGE_SIZE
Date: Fri, 19 May 2017 16:38:34 +0300
Message-Id: <20170519133835.27843-3-nefelim4ag@gmail.com>
In-Reply-To: <20170519133835.27843-1-nefelim4ag@gmail.com>
References: <20170519133835.27843-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If data compression didn't free at least one PAGE_SIZE, it useless to store that compressed extent

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/lzo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index bd0b0938..637ef1b0 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -207,7 +207,7 @@ static int lzo_compress_pages(struct list_head *ws,
 		}
 
 		/* we're making it bigger, give up */
-		if (tot_in > 8192 && tot_in < tot_out) {
+		if (tot_in > 8192 && tot_in < tot_out + PAGE_SIZE) {
 			ret = -E2BIG;
 			goto out;
 		}
-- 
2.13.0

