From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 18/20] btrfs: Don't BUG_ON insert errors in btrfs_alloc_dev_extent()
Date: Thu, 15 Sep 2011 10:34:57 -0700
Message-ID: <1316108099-5099-19-git-send-email-mfasheh@suse.de>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>, Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
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
index 53875ae..1f5c3b1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1008,7 +1008,8 @@ int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	key.type = BTRFS_DEV_EXTENT_KEY;
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
 				      sizeof(*extent));
-	BUG_ON(ret);
+	if (ret)
+		goto out;
 
 	leaf = path->nodes[0];
 	extent = btrfs_item_ptr(leaf, path->slots[0],
@@ -1023,6 +1024,7 @@ int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 
 	btrfs_set_dev_extent_length(leaf, extent, num_bytes);
 	btrfs_mark_buffer_dirty(leaf);
+out:
 	btrfs_free_path(path);
 	return ret;
 }
-- 
1.7.6

