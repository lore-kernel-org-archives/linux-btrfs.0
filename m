Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62090 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758867Ab3IECki (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Sep 2013 22:40:38 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r852eZQ4014035
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Sep 2013 10:40:35 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 3/5] btrfs-progs: missing tree-freeing statements added
Date: Thu, 5 Sep 2013 10:38:56 +0800
Message-Id: <1378348738-14451-4-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1378348738-14451-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1378348738-14451-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The seen cache_tree in run_next_block freed.
Originally, this "missing" causes memory leaks, reported by valgrind.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-check.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 6cbd5a6..0cba4cc 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3595,6 +3595,11 @@ static int run_next_block(struct btrfs_root *root,
 		remove_cache_extent(nodes, cache);
 		free(cache);
 	}
+	cache = lookup_cache_extent(seen, bytenr, size);
+	if (cache) {
+		remove_cache_extent(seen, cache);
+		free(cache);
+	}
 
 	/* fixme, get the real parent transid */
 	buf = read_tree_block(root, bytenr, size, 0);
-- 
1.8.0.1

