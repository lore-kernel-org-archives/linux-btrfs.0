From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: don't be as agressive with delalloc metadata reservations
 V2
Date: Mon, 18 Jul 2011 14:14:06 -0400
Message-ID: <4E2477EE.4090701@redhat.com>
References: <1311012712-24828-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311012712-24828-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/18/2011 02:11 PM, Josef Bacik wrote:
> Currently we reserve enough space to COW an entirely full btree for every extent
> we have reserved for an inode.  This _sucks_, because you only need to COW once,
> and then everybody else is ok.  Unfortunately we don't know we'll all be able to
> get into the same transaction so that's what we have had to do.  But the global
> reserve holds a reservation large enough to cover a large percentage of all the
> metadata currently in the fs.  So all we really need to account for is any new
> blocks that we may allocate.  So fix this by
> 
> 1) Passing to btrfs_alloc_free_block() wether this is a new block or a COW
> block.  If it is a COW block we use the global reserve, if not we use the
> trans->block_rsv.
> 2) Reduce the amount of space we reserve.  Since we don't need to account for
> cow'ing the tree we can just keep track of new blocks to reserve, which greatly
> reduces the reservation amount.
> 
> This makes my basic random write test go from 3 mb/s to 75 mb/s.  I've tested
> this with my horrible ENOSPC test and it seems to work out fine.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
> V1->V2:
> -fix a problem reported by Liubo, we need to make sure that we move bytes
> over for any new extents we may add to the extent tree so we don't get a bunch
> of warnings.
> -fix the global reserve to reserve 50% of the metadata space currently used.

Argh helps if I actually send the updated patch, sorry!


---
 fs/btrfs/ctree.c       |   10 +++++-----
 fs/btrfs/ctree.h       |    5 ++---
 fs/btrfs/disk-io.c     |    3 ++-
 fs/btrfs/extent-tree.c |   31 ++++++++++++++++++++++++-------
 fs/btrfs/ioctl.c       |    2 +-
 5 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 2e66786..fbd48e9 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -206,7 +206,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,

 	cow = btrfs_alloc_free_block(trans, root, buf->len, 0,
 				     new_root_objectid, &disk_key, level,
-				     buf->start, 0);
+				     buf->start, 0, 1);
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);

@@ -412,7 +412,7 @@ static noinline int __btrfs_cow_block(struct
btrfs_trans_handle *trans,

 	cow = btrfs_alloc_free_block(trans, root, buf->len, parent_start,
 				     root->root_key.objectid, &disk_key,
-				     level, search_start, empty_size);
+				     level, search_start, empty_size, 0);
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);

@@ -1985,7 +1985,7 @@ static noinline int insert_new_root(struct
btrfs_trans_handle *trans,

 	c = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
 				   root->root_key.objectid, &lower_key,
-				   level, root->node->start, 0);
+				   level, root->node->start, 0, 1);
 	if (IS_ERR(c))
 		return PTR_ERR(c);

@@ -2112,7 +2112,7 @@ static noinline int split_node(struct
btrfs_trans_handle *trans,

 	split = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
 					root->root_key.objectid,
-					&disk_key, level, c->start, 0);
+					&disk_key, level, c->start, 0, 1);
 	if (IS_ERR(split))
 		return PTR_ERR(split);

@@ -2937,7 +2937,7 @@ again:

 	right = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
 					root->root_key.objectid,
-					&disk_key, 0, l->start, 0);
+					&disk_key, 0, l->start, 0, 1);
 	if (IS_ERR(right))
 		return PTR_ERR(right);

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3ba4d5f..1accb56 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2135,8 +2135,7 @@ static inline bool btrfs_mixed_space_info(struct
btrfs_space_info *space_info)
 static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
 						 unsigned num_items)
 {
-	return (root->leafsize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) *
-		3 * num_items;
+	return root->leafsize * 3 * num_items;
 }

 void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
@@ -2161,7 +2160,7 @@ struct extent_buffer
*btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root, u32 blocksize,
 					u64 parent, u64 root_objectid,
 					struct btrfs_disk_key *key, int level,
-					u64 hint, u64 empty_size);
+					u64 hint, u64 empty_size, int new_block);
 void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct extent_buffer *buf,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 234a084..0245cad 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1143,7 +1143,8 @@ static struct btrfs_root *alloc_log_tree(struct
btrfs_trans_handle *trans,
 	root->ref_cows = 0;

 	leaf = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
-				      BTRFS_TREE_LOG_OBJECTID, NULL, 0, 0, 0);
+				      BTRFS_TREE_LOG_OBJECTID, NULL, 0, 0, 0,
+				      1);
 	if (IS_ERR(leaf)) {
 		kfree(root);
 		return ERR_CAST(leaf);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2e0f87b..1011bcb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3779,7 +3779,7 @@ static u64 calc_global_metadata_size(struct
btrfs_fs_info *fs_info)

 	num_bytes = (data_used >> fs_info->sb->s_blocksize_bits) *
 		    csum_size * 2;
-	num_bytes += div64_u64(data_used + meta_used, 50);
+	num_bytes += div_factor(data_used + meta_used, 5);

 	if (num_bytes * 3 > meta_used)
 		num_bytes = div64_u64(meta_used, 3);
@@ -5552,10 +5552,17 @@ int btrfs_alloc_reserved_file_extent(struct
btrfs_trans_handle *trans,
 				     u64 root_objectid, u64 owner,
 				     u64 offset, struct btrfs_key *ins)
 {
+	struct btrfs_block_rsv *block_rsv = get_block_rsv(trans, root);
+	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
 	int ret;

 	BUG_ON(root_objectid == BTRFS_TREE_LOG_OBJECTID);
-
+	if (block_rsv != global_rsv) {
+		u64 num_bytes = btrfs_calc_trans_metadata_size(root, 1);
+		ret = btrfs_block_rsv_migrate(block_rsv, global_rsv,
+					      num_bytes);
+		WARN_ON(ret);
+	}
 	ret = btrfs_add_delayed_data_ref(trans, ins->objectid, ins->offset,
 					 0, root_objectid, owner, offset,
 					 BTRFS_ADD_DELAYED_EXTENT, NULL);
@@ -5661,13 +5668,23 @@ struct extent_buffer
*btrfs_init_new_buffer(struct btrfs_trans_handle *trans,

 static struct btrfs_block_rsv *
 use_block_rsv(struct btrfs_trans_handle *trans,
-	      struct btrfs_root *root, u32 blocksize)
+	      struct btrfs_root *root, u32 blocksize, int new_block)
 {
-	struct btrfs_block_rsv *block_rsv;
+	struct btrfs_block_rsv *block_rsv = NULL;
 	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
 	int ret;

-	block_rsv = get_block_rsv(trans, root);
+	if (root->ref_cows) {
+		if (new_block)
+			block_rsv = trans->block_rsv;
+		else
+			block_rsv = global_rsv;
+	} else {
+		block_rsv = root->block_rsv;
+	}
+
+	if (!block_rsv)
+		block_rsv = &root->fs_info->empty_block_rsv;

 	if (block_rsv->size == 0) {
 		ret = reserve_metadata_bytes(trans, root, block_rsv,
@@ -5726,7 +5743,7 @@ struct extent_buffer
*btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root, u32 blocksize,
 					u64 parent, u64 root_objectid,
 					struct btrfs_disk_key *key, int level,
-					u64 hint, u64 empty_size)
+					u64 hint, u64 empty_size, int new_block)
 {
 	struct btrfs_key ins;
 	struct btrfs_block_rsv *block_rsv;
@@ -5735,7 +5752,7 @@ struct extent_buffer
*btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 	int ret;


-	block_rsv = use_block_rsv(trans, root, blocksize);
+	block_rsv = use_block_rsv(trans, root, blocksize, new_block);
 	if (IS_ERR(block_rsv))
 		return ERR_CAST(block_rsv);

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fd252ff..39fb634 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -352,7 +352,7 @@ static noinline int create_subvol(struct btrfs_root
*root,
 	}

 	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
-				      0, objectid, NULL, 0, 0, 0);
+				      0, objectid, NULL, 0, 0, 0, 1);
 	if (IS_ERR(leaf)) {
 		ret = PTR_ERR(leaf);
 		goto fail;
-- 
1.7.5.2

