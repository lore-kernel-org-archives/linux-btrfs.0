Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33681 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753377AbdESNir (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 09:38:47 -0400
Received: by mail-wm0-f68.google.com with SMTP id b84so2534647wmh.0
        for <linux-btrfs@vger.kernel.org>; Fri, 19 May 2017 06:38:47 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 3/3] Btrfs: zlib compression must free at least PAGE_SIZE
Date: Fri, 19 May 2017 16:38:35 +0300
Message-Id: <20170519133835.27843-4-nefelim4ag@gmail.com>
In-Reply-To: <20170519133835.27843-1-nefelim4ag@gmail.com>
References: <20170519133835.27843-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If data compression didn't free at least one PAGE_SIZE, it useless to store that compressed extent

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/zlib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 135b1082..7c3c27e6 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -134,7 +134,7 @@ static int zlib_compress_pages(struct list_head *ws,
 		/* we're making it bigger, give up */
 		if (workspace->strm.total_in > 8192 &&
 		    workspace->strm.total_in <
-		    workspace->strm.total_out) {
+		    workspace->strm.total_out + PAGE_SIZE) {
 			ret = -E2BIG;
 			goto out;
 		}
-- 
2.13.0

