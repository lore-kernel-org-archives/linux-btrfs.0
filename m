Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:47508 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab3CJXm6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 19:42:58 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] fs: btrfs: Replaced calls to kmalloc and memcpy with kmemdup
Date: Sat,  9 Mar 2013 14:42:10 +0200
Message-Id: <1362832930-7114-1-git-send-email-gheorghiuandru@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replaced calls to kmalloc followed by memcpy with single call to kmemdup.
This patch was found using coccicheck.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 fs/btrfs/send.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index f7a8b86..f1e1e34 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3429,10 +3429,9 @@ static int __find_xattr(int num, struct btrfs_key *di_key,
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
-- 
1.7.9.5

