From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 27/35] btrfs: Remove BUG_ON from __btrfs_alloc_chunk()
Date: Wed, 21 Mar 2012 21:11:31 -0400
Message-ID: <20120322011136.785328415@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>, Mark Fasheh <mfasheh@suse.de>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We BUG_ON() error from add_extent_mapping(), but that error looks pretty
easy to bubble back up - as far as I can tell there have not been any
permanent modifications to fs state at that point.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/volumes.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8d4b7d4..8bf19e1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3327,8 +3327,9 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	write_lock(&em_tree->lock);
 	ret = add_extent_mapping(em_tree, em);
 	write_unlock(&em_tree->lock);
-	BUG_ON(ret);
 	free_extent_map(em);
+	if (ret)
+		goto error;
 
 	ret = btrfs_make_block_group(trans, extent_root, 0, type,
 				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-- 
1.7.9



