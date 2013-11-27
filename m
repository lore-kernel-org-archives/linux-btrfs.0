Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:44330 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3K0OoE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Nov 2013 09:44:04 -0500
Received: by mail-pb0-f52.google.com with SMTP id uo5so10528902pbc.11
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2013 06:44:03 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: guihc.fnst@cn.fujitsu.com
Subject: [PATCH] Btrfs-progs: chunk-recover: use right size when allocating chunk root node
Date: Wed, 27 Nov 2013 22:43:56 +0800
Message-Id: <1385563436-2598-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

When allocating chunk root node, we should use nodesize rather than sectorsize,
this will casue regression when making other nodesize choice.(for example 16k size now)

Reported-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 chunk-recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index bcde39e..ef96921 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1034,7 +1034,7 @@ static int __rebuild_chunk_root(struct btrfs_trans_handle *trans,
 	disk_key.type = BTRFS_DEV_ITEM_KEY;
 	disk_key.offset = min_devid;
 
-	cow = btrfs_alloc_free_block(trans, root, root->sectorsize,
+	cow = btrfs_alloc_free_block(trans, root, root->nodesize,
 				     BTRFS_CHUNK_TREE_OBJECTID,
 				     &disk_key, 0, 0, 0);
 	btrfs_set_header_bytenr(cow, cow->start);
-- 
1.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
