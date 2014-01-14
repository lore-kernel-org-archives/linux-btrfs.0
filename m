Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37720 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaANQ0v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 11:26:51 -0500
Received: by mail-pb0-f46.google.com with SMTP id ma3so3438498pbc.33
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 08:26:50 -0800 (PST)
Received: from linux-b0ol.localdomain ([223.65.189.206])
        by mx.google.com with ESMTPSA id lh13sm2782922pab.4.2014.01.14.08.26.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2014 08:26:50 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: do not use extent commit root for sending
Date: Wed, 15 Jan 2014 00:26:42 +0800
Message-Id: <1389716803-2415-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Now we have kicked off transaction from btrfs send, it is not safe
that we use extent commit root to search.

I happended to catch this problem when running sending and snapshot
in my desktop.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
Changelog v1->v2:
	extent_from_logical() also search extent tree, we should also
	take care of that part.
---
 fs/btrfs/send.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 591063d..54665d4 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1142,7 +1142,7 @@ static int find_extent_clone(struct send_ctx *sctx,
 	int compressed;
 	u32 i;
 
-	tmp_path = alloc_path_for_send();
+	tmp_path = btrfs_alloc_path();
 	if (!tmp_path)
 		return -ENOMEM;
 
@@ -1225,7 +1225,7 @@ static int find_extent_clone(struct send_ctx *sctx,
 
 	extent_item_pos = logical - found_key.objectid;
 	ret = iterate_extent_inodes(sctx->send_root->fs_info,
-					found_key.objectid, extent_item_pos, 1,
+					found_key.objectid, extent_item_pos, 0,
 					__iterate_backrefs, backref_ctx);
 
 	if (ret < 0)
-- 
1.8.4

