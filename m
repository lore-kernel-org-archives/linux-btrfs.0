From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't always do readahead
Date: Fri, 13 May 2011 10:34:38 -0400
Message-ID: <1305297278-2416-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Our readahead is sort of sloppy, and really isn't always needed.  For example if
ls is doing a stating ls (which is the default) it's going to stat in non-disk
order, so if say you have a directory with a stupid amount of files, readahead
is going to do nothing but waste time in the case of doing the stat.  Taking the
unconditional readahead out made my test go from 57 minutes to 36 minutes.  This
means that everywhere we do loop through the tree we want to make sure we do set
path->reada properly, so I went through and found all of the places where we
loop through the path and set reada to 1.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.c       |    2 --
 fs/btrfs/extent-tree.c |    3 ++-
 fs/btrfs/inode.c       |   14 ++++++++++++--
 fs/btrfs/relocation.c  |    6 ++++++
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index f7a0a64..f61c16c 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -48,8 +48,6 @@ struct btrfs_path *btrfs_alloc_path(void)
 {
 	struct btrfs_path *path;
 	path = kmem_cache_zalloc(btrfs_path_cachep, GFP_NOFS);
-	if (path)
-		path->reada = 1;
 	return path;
 }
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index edc1880..c38fd7a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -328,7 +328,7 @@ static int caching_kthread(void *data)
 	 */
 	path->skip_locking = 1;
 	path->search_commit_root = 1;
-	path->reada = 2;
+	path->reada = 1;
 
 	key.objectid = last;
 	key.offset = 0;
@@ -8500,6 +8500,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
+	path->reada = 1;
 
 	cache_gen = btrfs_super_cache_generation(&root->fs_info->super_copy);
 	if (cache_gen != 0 &&
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7746ed3..ca9d977 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4243,7 +4243,9 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 		filp->f_pos = 2;
 	}
 	path = btrfs_alloc_path();
-	path->reada = 2;
+	if (!path)
+		return -ENOMEM;
+	path->reada = 1;
 
 	btrfs_set_key_type(&key, key_type);
 	key.offset = filp->f_pos;
@@ -5044,7 +5046,15 @@ again:
 
 	if (!path) {
 		path = btrfs_alloc_path();
-		BUG_ON(!path);
+		if (!path) {
+			err = -ENOMEM;
+			goto out;
+		}
+		/*
+		 * Chances are we'll be called again, so go ahead and do
+		 * readahead
+		 */
+		path->reada = 1;
 	}
 
 	ret = btrfs_lookup_file_extent(trans, root, path,
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 09c30d3..5872b41 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -676,6 +676,8 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 		err = -ENOMEM;
 		goto out;
 	}
+	path1->reada = 1;
+	path2->reada = 2;
 
 	node = alloc_backref_node(cache);
 	if (!node) {
@@ -1996,6 +1998,7 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
+	path->reada = 1;
 
 	reloc_root = root->reloc_root;
 	root_item = &reloc_root->root_item;
@@ -3297,6 +3300,7 @@ static int find_data_references(struct reloc_control *rc,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
+	path->reada = 1;
 
 	root = read_fs_root(rc->extent_root->fs_info, ref_root);
 	if (IS_ERR(root)) {
@@ -3665,6 +3669,7 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
+	path->reada = 1;
 
 	ret = prepare_to_relocate(rc);
 	if (ret) {
@@ -4090,6 +4095,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
+	path->reada = -1;
 
 	key.objectid = BTRFS_TREE_RELOC_OBJECTID;
 	key.type = BTRFS_ROOT_ITEM_KEY;
-- 
1.7.2.3

