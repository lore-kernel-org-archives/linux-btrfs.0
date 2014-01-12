Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:57644 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaALNik (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 08:38:40 -0500
Received: by mail-pb0-f43.google.com with SMTP id rq2so6269678pbb.30
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jan 2014 05:38:40 -0800 (PST)
Received: from linux-b0ol.localdomain ([223.65.51.231])
        by mx.google.com with ESMTPSA id jn12sm30944540pbd.37.2014.01.12.05.38.37
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Jan 2014 05:38:39 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not use extent commit root for sending
Date: Sun, 12 Jan 2014 21:38:31 +0800
Message-Id: <1389533914-2272-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Now we have kicked off transaction from btrfs send, it is not safe
that we use extent commit root to search.

I happended to catch this problem when running sending and snapshot
in my desktop.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 591063d..e159df1 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1225,7 +1225,7 @@ static int find_extent_clone(struct send_ctx *sctx,
 
 	extent_item_pos = logical - found_key.objectid;
 	ret = iterate_extent_inodes(sctx->send_root->fs_info,
-					found_key.objectid, extent_item_pos, 1,
+					found_key.objectid, extent_item_pos, 0,
 					__iterate_backrefs, backref_ctx);
 
 	if (ret < 0)
-- 
1.8.4

