From: Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 1/7] btrfs: don't BUG_ON btrfs_alloc_path() errors
Date: Thu, 14 Jul 2011 15:00:07 -0700
Message-ID: <1310680807-13360-2-git-send-email-mfasheh@suse.com>
References: <1310680807-13360-1-git-send-email-mfasheh@suse.com>
Cc: chris.mason@oracle.com, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310680807-13360-1-git-send-email-mfasheh@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes many callers of btrfs_alloc_path() which BUG_ON allocation
failure. All the sites that are fixed in this patch were checked by me to
be fairly trivial to fix because of at least one of two criteria:

 - Callers of the function catch errors from it already so bubbling the
   error up will be handled.
 - Callers of the function might BUG_ON any nonzero return code in which
   case there is no behavior changed (but we still got to remove a BUG_ON)

The following functions were updated:

btrfs_lookup_extent, alloc_reserved_tree_block, btrfs_remove_block_group,
btrfs_lookup_csums_range, btrfs_csum_file_blocks, btrfs_mark_extent_written,
btrfs_inode_by_name, btrfs_new_inode, btrfs_symlink,
insert_reserved_file_extent, and run_delalloc_nocow

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/extent-tree.c |   12 +++++++++---
 fs/btrfs/file-item.c   |    7 +++++--
 fs/btrfs/file.c        |    3 ++-
 fs/btrfs/inode.c       |   18 +++++++++++++-----
 4 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 71cd456..aa91773 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -667,7 +667,9 @@ int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len)
 	struct btrfs_path *path;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
+
 	key.objectid = start;
 	key.offset = len;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
@@ -5494,7 +5496,8 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	u32 size = sizeof(*extent_item) + sizeof(*block_info) + sizeof(*iref);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
@@ -7162,7 +7165,10 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	spin_unlock(&cluster->refill_lock);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	inode = lookup_free_space_inode(root, block_group, path);
 	if (!IS_ERR(inode)) {
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 90d4ee5..f92ff0e 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -282,7 +282,8 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 	u16 csum_size = btrfs_super_csum_size(&root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	if (search_commit) {
 		path->skip_locking = 1;
@@ -672,7 +673,9 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 		btrfs_super_csum_size(&root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
+
 	sector_sum = sums->sums;
 again:
 	next_offset = (u64)-1;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index fa4ef18..23d1d81 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -855,7 +855,8 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 	btrfs_drop_extent_cache(inode, start, end - 1, 0);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 again:
 	recow = 0;
 	split = start;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3601f0a..8be7d7a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1070,7 +1070,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	u64 ino = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	nolock = is_free_space_inode(root, inode);
 
@@ -1644,7 +1645,8 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	int ret;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	path->leave_spinning = 1;
 
@@ -3713,7 +3715,8 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 	int ret = 0;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(dir), name,
 				    namelen, 0);
@@ -4438,7 +4441,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	int owner;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return ERR_PTR(-ENOMEM);
 
 	inode = new_inode(root->fs_info->sb);
 	if (!inode) {
@@ -7194,7 +7198,11 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path) {
+		err = -ENOMEM;
+		drop_inode = 1;
+		goto out_unlock;
+	}
 	key.objectid = btrfs_ino(inode);
 	key.offset = 0;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_DATA_KEY);
-- 
1.7.5.3


>From 1e5063d093b5f024ae35bf835ca07463de2c1a1f Mon Sep 17 00:00:00 2001
From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 12 Jul 2011 10:46:06 -0700
Subject: [PATCH 2/7] btrfs: Don't BUG_ON alloc_path errors in
 replay_one_buffer()

The two ->process_func call sites in tree-log.c which were ignoring a return
code have also been updated to gracefully exit as well.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/tree-log.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4ce8a9f..f3cacc0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1617,7 +1617,8 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 		return 0;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	nritems = btrfs_header_nritems(eb);
 	for (i = 0; i < nritems; i++) {
@@ -1723,7 +1724,9 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 			return -ENOMEM;
 
 		if (*level == 1) {
-			wc->process_func(root, next, wc, ptr_gen);
+			ret = wc->process_func(root, next, wc, ptr_gen);
+			if (ret)
+				return ret;
 
 			path->slots[*level]++;
 			if (wc->free) {
@@ -1788,8 +1791,11 @@ static noinline int walk_up_log_tree(struct btrfs_trans_handle *trans,
 				parent = path->nodes[*level + 1];
 
 			root_owner = btrfs_header_owner(parent);
-			wc->process_func(root, path->nodes[*level], wc,
+			ret = wc->process_func(root, path->nodes[*level], wc,
 				 btrfs_header_generation(path->nodes[*level]));
+			if (ret)
+				return ret;
+
 			if (wc->free) {
 				struct extent_buffer *next;
 
-- 
1.7.5.3


>From 0eb0e19cde6f01397ef8c0e094e44beb75c62a1e Mon Sep 17 00:00:00 2001
From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 12 Jul 2011 16:44:10 -0700
Subject: [PATCH 3/7] btrfs: Don't BUG_ON alloc_path errors in
 btrfs_truncate_inode_items

I moved the path allocation up a few lines to the top of the function so
that we couldn't get into the state where we've dropped delayed items and
the extent cache but fail due to -ENOMEM.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/inode.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8be7d7a..a0faf7d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3172,6 +3172,11 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 
 	BUG_ON(new_size > 0 && min_type != BTRFS_EXTENT_DATA_KEY);
 
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	path->reada = -1;
+
 	if (root->ref_cows || root == root->fs_info->tree_root)
 		btrfs_drop_extent_cache(inode, new_size & (~mask), (u64)-1, 0);
 
@@ -3184,10 +3189,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	if (min_type == 0 && root == BTRFS_I(inode)->root)
 		btrfs_kill_delayed_inode_items(inode);
 
-	path = btrfs_alloc_path();
-	BUG_ON(!path);
-	path->reada = -1;
-
 	key.objectid = ino;
 	key.offset = (u64)-1;
 	key.type = (u8)-1;
-- 
1.7.5.3


>From 1748f843a0190ef4332d03a64263f383af72682b Mon Sep 17 00:00:00 2001
From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 12 Jul 2011 11:25:31 -0700
Subject: [PATCH 4/7] btrfs: Don't BUG_ON alloc_path errors in
 btrfs_read_locked_inode

btrfs_iget() also needed an update so that errors from btrfs_locked_inode()
are caught and bubbled back up.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/inode.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a0faf7d..8882999 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2518,7 +2518,9 @@ static void btrfs_read_locked_inode(struct inode *inode)
 		filled = true;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		goto make_bad;
+
 	path->leave_spinning = 1;
 	memcpy(&location, &BTRFS_I(inode)->location, sizeof(location));
 
@@ -3973,6 +3975,7 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *new)
 {
 	struct inode *inode;
+	int bad_inode = 0;
 
 	inode = btrfs_iget_locked(s, location->objectid, root);
 	if (!inode)
@@ -3982,10 +3985,19 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 		BTRFS_I(inode)->root = root;
 		memcpy(&BTRFS_I(inode)->location, location, sizeof(*location));
 		btrfs_read_locked_inode(inode);
-		inode_tree_add(inode);
-		unlock_new_inode(inode);
-		if (new)
-			*new = 1;
+		if (!is_bad_inode(inode)) {
+			inode_tree_add(inode);
+			unlock_new_inode(inode);
+			if (new)
+				*new = 1;
+		} else {
+			bad_inode = 1;
+		}
+	}
+
+	if (bad_inode) {
+		iput(inode);
+		inode = ERR_PTR(-ESTALE);
 	}
 
 	return inode;
-- 
1.7.5.3


>From 17e9f796bd92cddec17d781c459376f82340fa44 Mon Sep 17 00:00:00 2001
From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 12 Jul 2011 11:10:23 -0700
Subject: [PATCH 5/7] btrfs: Don't BUG_ON alloc_path errors in btrfs_balance()

Dealing with this seems trivial - the only caller of btrfs_balance() is
btrfs_ioctl() which passes the error code directly back to userspace. There
also isn't much state to unwind (if I'm wrong about this point, we can
always safely move the allocation to the top of btrfs_balance() anyway).

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/volumes.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 19450bc..530a2fc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2061,8 +2061,10 @@ int btrfs_balance(struct btrfs_root *dev_root)
 
 	/* step two, relocate all the chunks */
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
-
+	if (!path) {
+		ret = -ENOMEM;
+		goto error;
+	}
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.offset = (u64)-1;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
-- 
1.7.5.3


>From 8d6e94d8d1f2fd4ebff60c3b950041a9ef2dd53b Mon Sep 17 00:00:00 2001
From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 12 Jul 2011 10:57:59 -0700
Subject: [PATCH 6/7] btrfs: Don't BUG_ON alloc_path errors in find_next_chunk

I also removed the BUG_ON from error return of find_next_chunk in
init_first_rw_device(). It turns out that the only caller of
init_first_rw_device() also BUGS on any nonzero return so no actual behavior
change has occurred here.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/volumes.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 530a2fc..90d956c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1037,7 +1037,8 @@ static noinline int find_next_chunk(struct btrfs_root *root,
 	struct btrfs_key found_key;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	key.objectid = objectid;
 	key.offset = (u64)-1;
@@ -2663,7 +2664,8 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 
 	ret = find_next_chunk(fs_info->chunk_root,
 			      BTRFS_FIRST_CHUNK_TREE_OBJECTID, &chunk_offset);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 
 	alloc_profile = BTRFS_BLOCK_GROUP_METADATA |
 			(fs_info->metadata_alloc_profile &
-- 
1.7.5.3


>From 85ded46308ddb0ecda85c7f42efbcd3f0611908a Mon Sep 17 00:00:00 2001
From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 13 Jul 2011 10:59:59 -0700
Subject: [PATCH 7/7] btrfs: don't BUG_ON allocation errors in
 btrfs_drop_snapshot

In addition to properly handling allocation failure from btrfs_alloc_path, I
also fixed up the kzalloc error handling code immediately below it.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/extent-tree.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index aa91773..a016590 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6268,10 +6268,14 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	int level;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	wc = kzalloc(sizeof(*wc), GFP_NOFS);
-	BUG_ON(!wc);
+	if (!wc) {
+		btrfs_free_path(path);
+		return -ENOMEM;
+	}
 
 	trans = btrfs_start_transaction(tree_root, 0);
 	BUG_ON(IS_ERR(trans));
-- 
1.7.5.3

