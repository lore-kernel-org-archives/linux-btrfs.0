From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 09/35] btrfs: find_and_setup_root error push-up
Date: Wed, 21 Mar 2012 21:11:13 -0400
Message-ID: <20120322011134.234712384@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

find_and_setup_root BUGs when it encounters an error from
btrfs_find_last_root, which can occur if a path can't be allocated.

This patch pushes it up to its callers where it is already handled.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d52ec11..155c4e3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1197,10 +1197,10 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
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
@@ -1213,7 +1213,8 @@ static int find_and_setup_root(struct btrfs_root *tree_root,
 				   &root->root_item, &root->root_key);
 	if (ret > 0)
 		return -ENOENT;
-	BUG_ON(ret);
+	else if (ret < 0)
+		return ret;
 
 	generation = btrfs_root_generation(&root->root_item);
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
-- 
1.7.9



