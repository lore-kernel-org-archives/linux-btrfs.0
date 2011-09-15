From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 19/20] btrfs: Remove BUG_ON from __btrfs_alloc_chunk()
Date: Thu, 15 Sep 2011 10:34:58 -0700
Message-ID: <1316108099-5099-20-git-send-email-mfasheh@suse.de>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>, Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

We BUG_ON() error from add_extent_mapping(), but that error looks pretty
easy to bubble back up - as far as I can tell there have not been any
permanent modifications to fs state at that point.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/volumes.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1f5c3b1..50547f3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2515,8 +2515,9 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
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
1.7.6

