From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 13/65] btrfs: find_and_setup_root error push-up
Date: Mon, 03 Oct 2011 23:22:43 -0400
Message-ID: <20111004032301.414085548@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 find_and_setup_root BUGs when it encounters an error from
 btrfs_find_last_root, which can occur if a path can't be allocated.

 This patch pushes it up to its callers where it is already handled.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1130,7 +1130,8 @@ static int find_and_setup_root(struct bt
 				   &root->root_item, &root->root_key);
 	if (ret > 0)
 		return -ENOENT;
-	BUG_ON(ret);
+	else if (ret < 0)
+		return ret;
 
 	generation = btrfs_root_generation(&root->root_item);
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));



