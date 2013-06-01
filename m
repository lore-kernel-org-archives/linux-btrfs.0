Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www17.your-server.de ([213.133.104.17]:59468 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab3FAJqJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Jun 2013 05:46:09 -0400
Message-ID: <1370079470.29224.3.camel@localhost.localdomain>
Subject: [PATCH] Btrfs: Cocci spatch "memdup.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:37:50 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/btrfs/send.c b/fs/btrfs/send.c
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3429,10 +3429,9 @@ static int __find_xattr(int num, struct
 	    strncmp(name, ctx->name, name_len) == 0) {
 		ctx->found_idx = num;
 		ctx->found_data_len = data_len;
-		ctx->found_data = kmalloc(data_len, GFP_NOFS);
+		ctx->found_data = kmemdup(data, data_len, GFP_NOFS);
 		if (!ctx->found_data)
 			return -ENOMEM;
-		memcpy(ctx->found_data, data, data_len);
 		return 1;
 	}
 	return 0;


