From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 14/65] btrfs: btrfs_update_root error push-up
Date: Mon, 03 Oct 2011 23:22:44 -0400
Message-ID: <20111004032301.528363434@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_update_root BUG's when it can't alloc a path, yet it can recover
 from a search error. This patch returns -ENOMEM instead.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/root-tree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -93,7 +93,9 @@ int btrfs_update_root(struct btrfs_trans
 	unsigned long ptr;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
+
 	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
 	if (ret < 0)
 		goto out;



