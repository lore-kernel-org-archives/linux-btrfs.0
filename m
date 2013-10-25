Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11645 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab3JYKzY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 06:55:24 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r9PAtN2e016788
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 18:55:23 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: use 'u64' rather than 'int' to get extent's generation
Date: Fri, 25 Oct 2013 18:52:08 +0800
Message-Id: <1382698328-7557-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We define a 'int' to get extent's generation by mistake,fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a945374..c166740 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3260,7 +3260,7 @@ static int add_tree_block(struct reloc_control *rc,
 	struct rb_node *rb_node;
 	u32 item_size;
 	int level = -1;
-	int generation;
+	u64 generation;
 
 	eb =  path->nodes[0];
 	item_size = btrfs_item_size_nr(eb, path->slots[0]);
-- 
1.8.3.1

