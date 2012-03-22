From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 22/35] btrfs: Dont BUG_ON errors in __finish_chunk_alloc()
Date: Wed, 21 Mar 2012 21:11:26 -0400
Message-ID: <20120322011136.087168770@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>, Mark Fasheh <mfasheh@suse.de>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

All callers of __finish_chunk_alloc() BUG_ON() return value, so it's trivial
for us to always bubble up any errors caught in __finish_chunk_alloc() to be
caught there.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/volumes.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 43778b5..023aae0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3417,16 +3417,18 @@ static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
 	key.offset = chunk_offset;
 
 	ret = btrfs_insert_item(trans, chunk_root, &key, chunk, item_size);
-	BUG_ON(ret);
 
-	if (map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
+	if (ret == 0 && map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
+		/*
+		 * TODO: Cleanup of inserted chunk root in case of
+		 * failure.
+		 */
 		ret = btrfs_add_system_chunk(chunk_root, &key, chunk,
 					     item_size);
-		BUG_ON(ret);
 	}
 
 	kfree(chunk);
-	return 0;
+	return ret;
 }
 
 /*
-- 
1.7.9



