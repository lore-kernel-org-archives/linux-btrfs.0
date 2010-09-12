From: Jaswinder Singh Rajput <jaswinder@infradead.org>
Subject: [PATCH] Btrfs: Remove useless condition
Date: Sun, 12 Sep 2010 16:32:20 +0530
Message-ID: <1284289340.2650.2.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


if (ret) is useless as it will be never NULL as in previous statement
we are setting ret = prev for !ret

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
---
 fs/btrfs/ordered-data.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index e56c72b..7b04008 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -154,8 +154,7 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
 	ret = __tree_search(root, file_offset, &prev);
 	if (!ret)
 		ret = prev;
-	if (ret)
-		tree->last = ret;
+	tree->last = ret;
 	return ret;
 }
 
-- 
1.7.2.2



