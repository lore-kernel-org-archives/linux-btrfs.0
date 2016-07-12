Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36357 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbcGLR0o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 13:26:44 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>
Subject: [PATCH v2] Btrfs: fix panic in balance due to EIO
Date: Tue, 12 Jul 2016 10:29:37 -0700
Message-Id: <1468344577-8684-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1468283820-25471-1-git-send-email-bo.li.liu@oracle.com>
References: <1468283820-25471-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During build_backref_tree(), if we fail to read a btree node,
we can eventually run into BUG_ON(cache->nr_nodes) that we put
in backref_cache_cleanup(), meaning we have at least one
memory leak.

This frees the backref_node that we's allocated at the very
beginning of build_backref_tree().

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: Set node to NULL if we know it'll be freed.

 fs/btrfs/relocation.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 9732919..535314a 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1171,8 +1171,12 @@ out:
 			lower = list_entry(useless.next,
 					   struct backref_node, list);
 			list_del_init(&lower->list);
+			if (lower == node)
+				node = NULL;
 			free_backref_node(cache, lower);
 		}
+
+		free_backref_node(cache, node);
 		return ERR_PTR(err);
 	}
 	ASSERT(!node || !node->detached);
-- 
2.5.5

