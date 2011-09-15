From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 05/20] btrfs: Don't BUG_ON errors in __finish_chunk_alloc()
Date: Thu, 15 Sep 2011 10:34:44 -0700
Message-ID: <1316108099-5099-6-git-send-email-mfasheh@suse.de>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>,
	Mark Fasheh <mfasheh@suse.de>, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

All callers of __finish_chunk_alloc() BUG_ON() return value, so it's trivial
for us to always bubble up any errors caught in __finish_chunk_alloc() to be
caught there.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/volumes.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 53875ae..5d166c2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2600,16 +2600,13 @@ static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
 	key.offset = chunk_offset;
 
 	ret = btrfs_insert_item(trans, chunk_root, &key, chunk, item_size);
-	BUG_ON(ret);
-
-	if (map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
+	if (ret == 0 && map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		ret = btrfs_add_system_chunk(trans, chunk_root, &key, chunk,
 					     item_size);
-		BUG_ON(ret);
 	}
 
 	kfree(chunk);
-	return 0;
+	return ret;
 }
 
 /*
-- 
1.7.6

