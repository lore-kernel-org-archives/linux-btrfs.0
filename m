Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21455 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbcGLAeE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 20:34:04 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: fix panic in balance due to EIO
Date: Mon, 11 Jul 2016 17:37:00 -0700
Message-Id: <1468283820-25471-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During build_backref_tree(), if we fail to read a btree node,
we can eventually run into BUG_ON(cache->nr_nodes) that we put
in backref_cache_cleanup(), meaning we have at least one
memory leak.

This frees the backref_node that we allocate at the very beginning of build_backref_tree().

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/relocation.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 0477dca..f00267a 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1135,6 +1135,8 @@ out:
 	btrfs_free_path(path1);
 	btrfs_free_path(path2);
 	if (err) {
+		int orig_free = 0;
+
 		while (!list_empty(&useless)) {
 			lower = list_entry(useless.next,
 					   struct backref_node, list);
@@ -1171,8 +1173,13 @@ out:
 			lower = list_entry(useless.next,
 					   struct backref_node, list);
 			list_del_init(&lower->list);
+			if (lower == node)
+				orig_free = 1;
 			free_backref_node(cache, lower);
 		}
+
+		if (!orig_free)
+			free_backref_node(cache, node);
 		return ERR_PTR(err);
 	}
 	ASSERT(!node || !node->detached);
-- 
2.5.5

