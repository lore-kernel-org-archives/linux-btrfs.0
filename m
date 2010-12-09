From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2 3/5] Btrfs: Add helper __setup_root_post()
Date: Thu, 09 Dec 2010 17:10:32 +0800
Message-ID: <4D009D08.3090904@cn.fujitsu.com>
References: <4D009CD2.3060805@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D009CD2.3060805@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Eliminate duplicate code in btrfs_read_fs_root_no_radix() and
find_and_setup_root().

Also prepare for the next patch.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 33b6d45..ca20c6d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -987,14 +987,25 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
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
@@ -1005,12 +1016,7 @@ static int find_and_setup_root(struct btrfs_root *tree_root,
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
 
@@ -1111,8 +1117,6 @@ struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
 	struct btrfs_fs_info *fs_info = tree_root->fs_info;
 	struct btrfs_path *path;
 	struct extent_buffer *l;
-	u64 generation;
-	u32 blocksize;
 	int ret = 0;
 
 	root = kzalloc(sizeof(*root), GFP_NOFS);
@@ -1149,12 +1153,7 @@ struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
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

