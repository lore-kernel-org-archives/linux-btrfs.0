From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 26/35] btrfs: Dont BUG_ON insert errors in btrfs_alloc_dev_extent()
Date: Wed, 21 Mar 2012 21:11:30 -0400
Message-ID: <20120322011136.647631092@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>, Mark Fasheh <mfasheh@suse.de>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The only caller of btrfs_alloc_dev_extent() is __btrfs_alloc_chunk() which
already bugs on any error returned. We can remove the BUG_ON's in
btrfs_alloc_dev_extent() then since __btrfs_alloc_chunk() will "catch" them
anyway.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/volumes.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 023aae0..8d4b7d4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1075,7 +1075,8 @@ int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	key.type = BTRFS_DEV_EXTENT_KEY;
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
 				      sizeof(*extent));
-	BUG_ON(ret);
+	if (ret)
+		goto out;
 
 	leaf = path->nodes[0];
 	extent = btrfs_item_ptr(leaf, path->slots[0],
@@ -1090,6 +1091,7 @@ int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 
 	btrfs_set_dev_extent_length(leaf, extent, num_bytes);
 	btrfs_mark_buffer_dirty(leaf);
+out:
 	btrfs_free_path(path);
 	return ret;
 }
-- 
1.7.9



