From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/5] btrfs: Add helper __setup_root_post()
Date: Mon, 29 Nov 2010 16:03:22 +0800
Message-ID: <4CF35E4A.1060206@cn.fujitsu.com>
References: <4CF35E17.6050705@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CF35E17.6050705@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

This eliminates duplicate code in find_and_setup_root() and
btrfs_read_fs_root_no_radix().

(Prepare for the next patch)

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b40dfe4..fb650e0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -959,14 +959,25 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	return 0;
 }
 
+static void __setup_root_post(struct btrfs_root *root)
+{
+	u32 blocksize;
+	u64 generation;
+
+	generation = btrfs_root_generation(&root->root_item);
+	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
+	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
+				     blocksize, generation);
+	BUG_ON(!root->node);
+	root->commit_root = btrfs_root_node(root);
+}
+
 static int find_and_setup_root(struct btrfs_root *tree_root,
 			       struct btrfs_fs_info *fs_info,
 			       u64 objectid,
 			       struct btrfs_root *root)
 {
 	int ret;
-	u32 blocksize;
-	u64 generation;
 
 	__setup_root(tree_root->nodesize, tree_root->leafsize,
 		     tree_root->sectorsize, tree_root->stripesize,
@@ -977,12 +988,7 @@ static int find_and_setup_root(struct btrfs_root *tree_root,
 		return -ENOENT;
 	BUG_ON(ret);
 
-	generation = btrfs_root_generation(&root->root_item);
-	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
-	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
-				     blocksize, generation);
-	BUG_ON(!root->node);
-	root->commit_root = btrfs_root_node(root);
+	__setup_root_post(root);
 	return 0;
 }
 
@@ -1083,8 +1089,6 @@ struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
 	struct btrfs_fs_info *fs_info = tree_root->fs_info;
 	struct btrfs_path *path;
 	struct extent_buffer *l;
-	u64 generation;
-	u32 blocksize;
 	int ret = 0;
 
 	root = kzalloc(sizeof(*root), GFP_NOFS);
@@ -1121,12 +1125,7 @@ struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
 		return ERR_PTR(ret);
 	}
 
-	generation = btrfs_root_generation(&root->root_item);
-	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
-	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
-				     blocksize, generation);
-	root->commit_root = btrfs_root_node(root);
-	BUG_ON(!root->node);
+	__setup_root_post(root);
 out:
 	if (location->objectid != BTRFS_TREE_LOG_OBJECTID)
 		root->ref_cows = 1;
-- 
1.6.3

