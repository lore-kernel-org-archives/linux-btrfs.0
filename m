Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:29650 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbaBXMOx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 07:14:53 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1OBv4nY022660
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 19:57:06 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fsck: fix wrong return value in check_block()
Date: Mon, 24 Feb 2014 19:55:14 +0800
Message-Id: <1393242914-21867-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We found btrfsck will output backrefs mismatch while the filesystem
is defenitely ok.

The problem is that check_block() don't return right value,which
makes btrfsck won't walk all tree blocks thus we don't get a consistent
filesystem, we will fail to check extent refs etc.

Reported-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index a2afae6..253569f 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2477,7 +2477,7 @@ static int check_block(struct btrfs_trans_handle *trans,
 	struct cache_extent *cache;
 	struct btrfs_key key;
 	enum btrfs_tree_block_status status;
-	int ret = 1;
+	int ret = 0;
 	int level;
 
 	cache = lookup_cache_extent(extent_cache, buf->start, buf->len);
-- 
1.9.0

