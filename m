Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:52644 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaALNim (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 08:38:42 -0500
Received: by mail-pb0-f48.google.com with SMTP id md12so2135pbc.35
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jan 2014 05:38:42 -0800 (PST)
Received: from linux-b0ol.localdomain ([223.65.51.231])
        by mx.google.com with ESMTPSA id jn12sm30944540pbd.37.2014.01.12.05.38.40
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Jan 2014 05:38:41 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Btrfs: fix missing skinny metadata check in scrub_stripe()
Date: Sun, 12 Jan 2014 21:38:32 +0800
Message-Id: <1389533914-2272-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1389533914-2272-1-git-send-email-wangshilong1991@gmail.com>
References: <1389533914-2272-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Check if we support skinny metadata firstly and fix to use
right type to search.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 7806e2c..e0677e4 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2373,8 +2373,11 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			scrub_blocked_if_needed(fs_info);
 		}
 
+		if (btrfs_fs_incompat(fs_info, SKINNY_METADATA))
+			key.type = BTRFS_METADATA_ITEM_KEY;
+		else
+			key.type = BTRFS_EXTENT_ITEM_KEY;
 		key.objectid = logical;
-		key.type = BTRFS_EXTENT_ITEM_KEY;
 		key.offset = (u64)-1;
 
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-- 
1.8.4

