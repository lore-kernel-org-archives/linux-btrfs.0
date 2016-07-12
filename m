Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30919 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932645AbcGLBt5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 21:49:57 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: change BUG_ON()'s to ASSERT()'s in backref_cache_cleanup()
Date: Mon, 11 Jul 2016 18:52:57 -0700
Message-Id: <1468288377-10971-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since it is just an in-memory building of the backrefs of several
btree blocks, nothing is fatal other than memory leaks, so this
changes BUG_ON()'s to ASSERT()'s.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/relocation.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 0477dca..9732919 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -235,12 +235,12 @@ static void backref_cache_cleanup(struct backref_cache *cache)
 	cache->last_trans = 0;
 
 	for (i = 0; i < BTRFS_MAX_LEVEL; i++)
-		BUG_ON(!list_empty(&cache->pending[i]));
-	BUG_ON(!list_empty(&cache->changed));
-	BUG_ON(!list_empty(&cache->detached));
-	BUG_ON(!RB_EMPTY_ROOT(&cache->rb_root));
-	BUG_ON(cache->nr_nodes);
-	BUG_ON(cache->nr_edges);
+		ASSERT(list_empty(&cache->pending[i]));
+	ASSERT(list_empty(&cache->changed));
+	ASSERT(list_empty(&cache->detached));
+	ASSERT(RB_EMPTY_ROOT(&cache->rb_root));
+	ASSERT(!cache->nr_nodes);
+	ASSERT(!cache->nr_edges);
 }
 
 static struct backref_node *alloc_backref_node(struct backref_cache *cache)
-- 
2.5.5

