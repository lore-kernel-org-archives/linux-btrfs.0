Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16503 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbaCRMFB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Mar 2014 08:05:01 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2IC4u1r001918
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Mar 2014 20:04:57 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] Btrfs-progs: fsck: don't free @seen cache until we finish searching
Date: Tue, 18 Mar 2014 20:02:42 +0800
Message-Id: <1395144167-775-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@seen cache is used to avoid iterating same block more than once, and
we can not free them until we have finished searching.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index d1cafe1..c0b7f8c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3892,12 +3892,6 @@ static int run_next_block(struct btrfs_trans_handle *trans,
 		remove_cache_extent(nodes, cache);
 		free(cache);
 	}
-	cache = lookup_cache_extent(seen, bytenr, size);
-	if (cache) {
-		remove_cache_extent(seen, cache);
-		free(cache);
-	}
-
 	cache = lookup_cache_extent(extent_cache, bytenr, size);
 	if (cache) {
 		struct extent_record *rec;
@@ -5914,6 +5908,7 @@ out:
 	free_device_cache_tree(&dev_cache);
 	free_block_group_tree(&block_group_cache);
 	free_device_extent_tree(&dev_extent_cache);
+	free_extent_cache_tree(&seen);
 	return ret;
 }
 
-- 
1.9.0

