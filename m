From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 14/66] btrfs: find_and_setup_root error push-up
Date: Mon, 24 Oct 2011 21:02:50 -0400
Message-ID: <20111025010852.175360336@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 find_and_setup_root BUGs when it encounters an error from
 btrfs_find_last_root, which can occur if a path can't be allocated.

 This patch pushes it up to its callers where it is already handled.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1117,10 +1117,10 @@ static int __setup_root(u32 nodesize, u3
 	return 0;
 }
 
-static int find_and_setup_root(struct btrfs_root *tree_root,
-			       struct btrfs_fs_info *fs_info,
-			       u64 objectid,
-			       struct btrfs_root *root)
+static int __must_check find_and_setup_root(struct btrfs_root *tree_root,
+					    struct btrfs_fs_info *fs_info,
+					    u64 objectid,
+					    struct btrfs_root *root)
 {
 	int ret;
 	u32 blocksize;
@@ -1133,7 +1133,8 @@ static int find_and_setup_root(struct bt
 				   &root->root_item, &root->root_key);
 	if (ret > 0)
 		return -ENOENT;
-	BUG_ON(ret);
+	else if (ret < 0)
+		return ret;
 
 	generation = btrfs_root_generation(&root->root_item);
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));


