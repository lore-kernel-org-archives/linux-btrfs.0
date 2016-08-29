Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50052 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932820AbcH2Lm4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 07:42:56 -0400
Received: from localhost.localdomain (unknown [10.167.226.107])
        by cn.fujitsu.com (Postfix) with ESMTP id D66694056401
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 19:40:32 +0800 (CST)
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: add ENOSPC check for temporarily allocated btrfs_block_rsv
Date: Mon, 29 Aug 2016 19:36:32 +0800
Message-Id: <20160829113632.24193-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 56a9c59..602e410 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5552,6 +5552,9 @@ void btrfs_free_block_rsv(struct btrfs_root *root,
 	if (!rsv)
 		return;
 	btrfs_block_rsv_release(root, rsv, (u64)-1);
+
+	WARN_ON(rsv->size > 0);
+	WARN_ON(rsv->reserved > 0);
 	kfree(rsv);
 }
 
-- 
2.9.0



