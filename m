From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [RFC PATCH 2/2] Btrfs: introduce free space cluster for each node
Date: Thu, 08 Sep 2011 16:18:09 +0800
Message-ID: <4E687A41.8080101@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduce free space cluster for each node in the b+tree. An=
d
we also simplify the fill method and the space allocation of the cluste=
r:
- Allocate free space cluster for each node
- Allocate the free space extent (>=3D256KB, split a large extent or ge=
t the
  contiguous blocks from the bitmaps) from the block group cache and ca=
che
  it in the cluster, instead of moving the free space entry from the bl=
ock
  group cache to the cluster directly. By this way, we just manage a ex=
tent
  in the cluster.
- When doing the tree block allocation, we can get the space just by sp=
lit
  the extent in the parent's cluster. By this way, we can allocate the =
tree
  block concurrently and also can store the child nodes/leaves into the
  contiguous blocks.

Beside that, we modify the source of the space cache to make it fit the=
 above
change. When we write out the information of the free space, we also wr=
ite out
the extent information in the clusters. And when we load the free space
information, we will try to merge the free space fragment at first, bec=
ause the
extent in the clusters is small, and may merge them to be a large one.
(Before applying this patch, we build the free space tree by the cached=
 information
directly. I think we needn't worry about the compatibility. At the wors=
t, we may
create lots of small extents which may be merge into a large one, but i=
t will not
break the use of Btrfs.=A3=A9

We did some performance test for this patch, we find it works well, and=
 make the
small file performance grow up.

The sequential write performance of the small file:
N_files		N_threads	File Size	Before		After
10240		8		2KB(Inline)	2.2055MB/s	4.1779MB/s
10240		8		4KB		1.001MB/s	1.1893MB/s

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.c            |   28 ++-
 fs/btrfs/ctree.h            |   50 +++-
 fs/btrfs/disk-io.c          |    2 +-
 fs/btrfs/extent-tree.c      |  107 +++++---
 fs/btrfs/extent_io.c        |    7 +-
 fs/btrfs/extent_io.h        |    3 +
 fs/btrfs/free-space-cache.c |  667 ++++++++++++++++-------------------=
--------
 fs/btrfs/free-space-cache.h |   13 +
 fs/btrfs/inode-map.c        |    1 +
 fs/btrfs/inode.c            |   25 +-
 fs/btrfs/ioctl.c            |    2 +-
 fs/btrfs/tree-log.c         |    7 +
 12 files changed, 419 insertions(+), 493 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 011cab3..1d3edd8 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -238,7 +238,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *tran=
s,
 	else
 		btrfs_node_key(buf, &disk_key, 0);
=20
-	cow =3D btrfs_alloc_free_block(trans, root, buf->len, 0,
+	cow =3D btrfs_alloc_free_block(trans, root, buf->len, NULL, 0,
 				     new_root_objectid, &disk_key, level,
 				     buf->start, 0);
 	if (IS_ERR(cow))
@@ -444,9 +444,10 @@ static noinline int __btrfs_cow_block(struct btrfs=
_trans_handle *trans,
 	} else
 		parent_start =3D 0;
=20
-	cow =3D btrfs_alloc_free_block(trans, root, buf->len, parent_start,
-				     root->root_key.objectid, &disk_key,
-				     level, search_start, empty_size);
+	cow =3D btrfs_alloc_free_block(trans, root, buf->len, parent,
+				     parent_start, root->root_key.objectid,
+				     &disk_key, level, search_start,
+				     empty_size);
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);
=20
@@ -467,6 +468,10 @@ static noinline int __btrfs_cow_block(struct btrfs=
_trans_handle *trans,
 			    (unsigned long)btrfs_header_fsid(cow),
 			    BTRFS_FSID_SIZE);
=20
+	WARN_ON(cow->cluster);
+	cow->cluster =3D buf->cluster;
+	buf->cluster =3D NULL;
+
 	update_ref_for_cow(trans, root, buf, cow, &last_ref);
=20
 	if (root->ref_cows)
@@ -2070,7 +2075,7 @@ static noinline int insert_new_root(struct btrfs_=
trans_handle *trans,
 	else
 		btrfs_node_key(lower, &lower_key, 0);
=20
-	c =3D btrfs_alloc_free_block(trans, root, root->nodesize, 0,
+	c =3D btrfs_alloc_free_block(trans, root, root->nodesize, NULL, 0,
 				   root->root_key.objectid, &lower_key,
 				   level, root->node->start, 0);
 	if (IS_ERR(c))
@@ -2170,6 +2175,7 @@ static noinline int split_node(struct btrfs_trans=
_handle *trans,
 {
 	struct extent_buffer *c;
 	struct extent_buffer *split;
+	struct extent_buffer *parent =3D NULL;
 	struct btrfs_disk_key disk_key;
 	int mid;
 	int ret;
@@ -2197,9 +2203,12 @@ static noinline int split_node(struct btrfs_tran=
s_handle *trans,
 	mid =3D (c_nritems + 1) / 2;
 	btrfs_node_key(c, &disk_key, mid);
=20
-	split =3D btrfs_alloc_free_block(trans, root, root->nodesize, 0,
-					root->root_key.objectid,
-					&disk_key, level, c->start, 0);
+	if (level + 1 < BTRFS_MAX_LEVEL)
+		parent =3D path->nodes[level + 1];
+
+	split =3D btrfs_alloc_free_block(trans, root, root->nodesize, parent,=
 0,
+				       root->root_key.objectid,
+				       &disk_key, level, c->start, 0);
 	if (IS_ERR(split))
 		return PTR_ERR(split);
=20
@@ -2951,7 +2960,8 @@ again:
 	else
 		btrfs_item_key(l, &disk_key, mid);
=20
-	right =3D btrfs_alloc_free_block(trans, root, root->leafsize, 0,
+	right =3D btrfs_alloc_free_block(trans, root, root->leafsize,
+					path->nodes[1], 0,
 					root->root_key.objectid,
 					&disk_key, 0, l->start, 0);
 	if (IS_ERR(right))
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c364d50..8c33a74 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -789,14 +789,9 @@ struct btrfs_block_rsv {
  */
 struct btrfs_free_cluster {
 	spinlock_t lock;
-	spinlock_t refill_lock;
-	struct rb_root root;
+	struct mutex refill_lock;
=20
-	/* largest extent in this cluster */
-	u64 max_size;
-
-	/* first extent starting offset */
-	u64 window_start;
+	struct btrfs_free_space *info;
=20
 	struct btrfs_block_group_cache *block_group;
 	/*
@@ -2156,7 +2151,9 @@ u64 btrfs_find_block_group(struct btrfs_root *roo=
t,
 			   u64 search_start, u64 search_hint, int owner);
 struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle=
 *trans,
 					struct btrfs_root *root, u32 blocksize,
-					u64 parent, u64 root_objectid,
+					struct extent_buffer *parent,
+					u64 parent_start,
+					u64 root_objectid,
 					struct btrfs_disk_key *key, int level,
 					u64 hint, u64 empty_size);
 void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
@@ -2175,12 +2172,37 @@ int btrfs_alloc_logged_file_extent(struct btrfs=
_trans_handle *trans,
 				   struct btrfs_root *root,
 				   u64 root_objectid, u64 owner, u64 offset,
 				   struct btrfs_key *ins);
-int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
-				  struct btrfs_root *root,
-				  u64 num_bytes, u64 min_alloc_size,
-				  u64 empty_size, u64 hint_byte,
-				  u64 search_end, struct btrfs_key *ins,
-				  u64 data);
+int __btrfs_reserve_extent(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   u64 num_bytes, u64 min_alloc_size,
+			   u64 empty_size, u64 hint_byte,
+			   u64 search_end, struct btrfs_key *ins,
+			   u64 data, struct btrfs_free_cluster *cluster);
+static inline int btrfs_reserve_extent_data(struct btrfs_trans_handle =
*trans,
+					    struct btrfs_root *root,
+					    u64 num_bytes, u64 min_alloc_size,
+					    u64 empty_size, u64 hint_byte,
+					    u64 search_end,
+					    struct btrfs_key *ins)
+{
+	return __btrfs_reserve_extent(trans, root, num_bytes, min_alloc_size,
+				      empty_size, hint_byte, search_end, ins,
+				      1, NULL);
+}
+
+static inline int btrfs_reserve_extent_mdata(struct btrfs_trans_handle=
 *trans,
+					     struct btrfs_root *root,
+					     u64 num_bytes, u64 min_alloc_size,
+					     u64 empty_size, u64 hint_byte,
+					     u64 search_end,
+					     struct btrfs_key *ins,
+					     struct btrfs_free_cluster *cluster)
+{
+	return __btrfs_reserve_extent(trans, root, num_bytes, min_alloc_size,
+				      empty_size, hint_byte, search_end, ins,
+				      0, cluster);
+}
+
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root =
*root,
 		  struct extent_buffer *buf, int full_backref);
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root =
*root,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 07b3ac6..951a57f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1171,7 +1171,7 @@ static struct btrfs_root *alloc_log_tree(struct b=
trfs_trans_handle *trans,
 	 */
 	root->ref_cows =3D 0;
=20
-	leaf =3D btrfs_alloc_free_block(trans, root, root->leafsize, 0,
+	leaf =3D btrfs_alloc_free_block(trans, root, root->leafsize, NULL, 0,
 				      BTRFS_TREE_LOG_OBJECTID, NULL, 0, 0, 0);
 	if (IS_ERR(leaf)) {
 		kfree(root);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 80d6148..43cc5c4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4672,6 +4672,8 @@ void btrfs_free_tree_block(struct btrfs_trans_han=
dle *trans,
 	struct btrfs_block_group_cache *cache =3D NULL;
 	int ret;
=20
+	btrfs_free_extent_cluster(buf);
+
 	if (root->root_key.objectid !=3D BTRFS_TREE_LOG_OBJECTID) {
 		ret =3D btrfs_add_delayed_tree_ref(trans, buf->start, buf->len,
 						parent, root->root_key.objectid,
@@ -4853,8 +4855,10 @@ enum btrfs_loop_type {
 	LOOP_FIND_IDEAL =3D 0,
 	LOOP_CACHING_NOWAIT =3D 1,
 	LOOP_CACHING_WAIT =3D 2,
-	LOOP_ALLOC_CHUNK =3D 3,
-	LOOP_NO_EMPTY_SIZE =3D 4,
+	LOOP_RECLAIM_CLUSTERS =3D 3,
+	LOOP_RECLAIM_ALL_CLUSTERS =3D 4,
+	LOOP_ALLOC_CHUNK =3D 5,
+	LOOP_NO_EMPTY_SIZE =3D 6,
 };
=20
 /*
@@ -4870,7 +4874,8 @@ static noinline int find_free_extent(struct btrfs=
_trans_handle *trans,
 				     u64 num_bytes, u64 empty_size,
 				     u64 search_start, u64 search_end,
 				     u64 hint_byte, struct btrfs_key *ins,
-				     u64 data)
+				     u64 data,
+				     struct btrfs_free_cluster *cluster)
 {
 	int ret =3D 0;
 	struct btrfs_root *root =3D orig_root->fs_info->extent_root;
@@ -4912,9 +4917,12 @@ static noinline int find_free_extent(struct btrf=
s_trans_handle *trans,
 		allowed_chunk_alloc =3D 1;
=20
 	if (data & BTRFS_BLOCK_GROUP_METADATA && use_cluster) {
-		last_ptr =3D &root->fs_info->meta_alloc_cluster;
+		if (cluster)
+			last_ptr =3D cluster;
+		else
+			last_ptr =3D &root->fs_info->meta_alloc_cluster;
 		if (!btrfs_test_opt(root, SSD))
-			empty_cluster =3D 64 * 1024;
+			empty_cluster =3D 256 * 1024;
 	}
=20
 	if ((data & BTRFS_BLOCK_GROUP_DATA) && use_cluster &&
@@ -4925,7 +4933,7 @@ static noinline int find_free_extent(struct btrfs=
_trans_handle *trans,
 	if (last_ptr) {
 		spin_lock(&last_ptr->lock);
 		if (last_ptr->block_group)
-			hint_byte =3D last_ptr->window_start;
+			hint_byte =3D last_ptr->info->offset;
 		spin_unlock(&last_ptr->lock);
 	}
=20
@@ -5043,6 +5051,13 @@ have_block_group:
 		if (unlikely(block_group->ro))
 			goto loop;
=20
+
+		if (loop =3D=3D LOOP_RECLAIM_CLUSTERS) {
+			btrfs_reclaim_extent_clusters(block_group,
+						      empty_cluster * 2);
+		} else if (loop =3D=3D LOOP_RECLAIM_ALL_CLUSTERS)
+			btrfs_reclaim_extent_clusters(block_group, 0);
+
 		spin_lock(&block_group->free_space_ctl->tree_lock);
 		if (cached &&
 		    block_group->free_space_ctl->free_space <
@@ -5066,7 +5081,7 @@ have_block_group:
 			 * the refill lock keeps out other
 			 * people trying to start a new cluster
 			 */
-			spin_lock(&last_ptr->refill_lock);
+			mutex_lock(&last_ptr->refill_lock);
 			if (last_ptr->block_group &&
 			    (last_ptr->block_group->ro ||
 			    !block_group_bits(last_ptr->block_group, data))) {
@@ -5078,7 +5093,7 @@ have_block_group:
 						 num_bytes, search_start);
 			if (offset) {
 				/* we have a block, we're done */
-				spin_unlock(&last_ptr->refill_lock);
+				mutex_unlock(&last_ptr->refill_lock);
 				goto checks;
 			}
=20
@@ -5097,7 +5112,7 @@ have_block_group:
 				block_group =3D last_ptr->block_group;
 				btrfs_get_block_group(block_group);
 				spin_unlock(&last_ptr->lock);
-				spin_unlock(&last_ptr->refill_lock);
+				mutex_unlock(&last_ptr->refill_lock);
=20
 				last_ptr_loop =3D 1;
 				search_start =3D block_group->key.objectid;
@@ -5123,7 +5138,7 @@ refill_cluster:
 			/* allocate a cluster in this block group */
 			ret =3D btrfs_find_space_cluster(trans, root,
 					       block_group, last_ptr,
-					       offset, num_bytes,
+					       search_start, num_bytes,
 					       empty_cluster + empty_size);
 			if (ret =3D=3D 0) {
 				/*
@@ -5135,12 +5150,12 @@ refill_cluster:
 						  search_start);
 				if (offset) {
 					/* we found one, proceed */
-					spin_unlock(&last_ptr->refill_lock);
+					mutex_unlock(&last_ptr->refill_lock);
 					goto checks;
 				}
 			} else if (!cached && loop > LOOP_CACHING_NOWAIT
 				   && !failed_cluster_refill) {
-				spin_unlock(&last_ptr->refill_lock);
+				mutex_unlock(&last_ptr->refill_lock);
=20
 				failed_cluster_refill =3D true;
 				wait_block_group_cache_progress(block_group,
@@ -5155,7 +5170,7 @@ refill_cluster:
 			 * to use, and go to the next block group
 			 */
 			btrfs_return_cluster_to_free_space(NULL, last_ptr);
-			spin_unlock(&last_ptr->refill_lock);
+			mutex_unlock(&last_ptr->refill_lock);
 			goto loop;
 		}
=20
@@ -5197,9 +5212,11 @@ checks:
 		ins->objectid =3D search_start;
 		ins->offset =3D num_bytes;
=20
-		if (offset < search_start)
+		if (offset < search_start) {
 			btrfs_add_free_space(block_group, offset,
 					     search_start - offset);
+			offset =3D search_start;
+		}
 		BUG_ON(offset > search_start);
=20
 		ret =3D btrfs_update_reserved_bytes(block_group, num_bytes, 1,
@@ -5210,13 +5227,6 @@ checks:
 		}
=20
 		/* we are all good, lets return */
-		ins->objectid =3D search_start;
-		ins->offset =3D num_bytes;
-
-		if (offset < search_start)
-			btrfs_add_free_space(block_group, offset,
-					     search_start - offset);
-		BUG_ON(offset > search_start);
 		btrfs_put_block_group(block_group);
 		break;
 loop:
@@ -5236,6 +5246,12 @@ loop:
 	 * LOOP_CACHING_NOWAIT, search partially cached block groups, kicking
 	 *			caching kthreads as we move along
 	 * LOOP_CACHING_WAIT, search everything, and wait if our bg is cachin=
g
+	 * LOOP_RECLAIM_CLUSTERS, reclaim free space from some clusters, and
+	 *			  by this way, we may find enough continuous
+	 *			  space to fill the cluster, and then search
+	 *			  the free space again.
+	 * LOOP_RECLAIM_ALL_CLUSTERS, reclaim free space from all the cluster=
s,
+	 *			      and then search again.
 	 * LOOP_ALLOC_CHUNK, force a chunk allocation and try again
 	 * LOOP_NO_EMPTY_SIZE, set empty_size and empty_cluster to 0 and try
 	 *			again
@@ -5362,12 +5378,12 @@ again:
 	up_read(&info->groups_sem);
 }
=20
-int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root,
-			 u64 num_bytes, u64 min_alloc_size,
-			 u64 empty_size, u64 hint_byte,
-			 u64 search_end, struct btrfs_key *ins,
-			 u64 data)
+int __btrfs_reserve_extent(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   u64 num_bytes, u64 min_alloc_size,
+			   u64 empty_size, u64 hint_byte,
+			   u64 search_end, struct btrfs_key *ins,
+			   u64 data, struct btrfs_free_cluster *cluster)
 {
 	int ret;
 	u64 search_start =3D 0;
@@ -5386,7 +5402,7 @@ again:
 	WARN_ON(num_bytes < root->sectorsize);
 	ret =3D find_free_extent(trans, root, num_bytes, empty_size,
 			       search_start, search_end, hint_byte,
-			       ins, data);
+			       ins, data, cluster);
=20
 	if (ret =3D=3D -ENOSPC && num_bytes > min_alloc_size) {
 		num_bytes =3D num_bytes >> 1;
@@ -5741,13 +5757,15 @@ static void unuse_block_rsv(struct btrfs_block_=
rsv *block_rsv, u32 blocksize)
  */
 struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle=
 *trans,
 					struct btrfs_root *root, u32 blocksize,
-					u64 parent, u64 root_objectid,
+					struct extent_buffer *parent,
+					u64 parent_start, u64 root_objectid,
 					struct btrfs_disk_key *key, int level,
 					u64 hint, u64 empty_size)
 {
 	struct btrfs_key ins;
 	struct btrfs_block_rsv *block_rsv;
 	struct extent_buffer *buf;
+	struct btrfs_free_cluster *cluster =3D NULL;
 	u64 flags =3D 0;
 	int ret;
=20
@@ -5756,8 +5774,19 @@ struct extent_buffer *btrfs_alloc_free_block(str=
uct btrfs_trans_handle *trans,
 	if (IS_ERR(block_rsv))
 		return ERR_CAST(block_rsv);
=20
-	ret =3D btrfs_reserve_extent(trans, root, blocksize, blocksize,
-				   empty_size, hint, (u64)-1, &ins, 0);
+	/*
+	 * We needn't worry about allocation failure, because if failed,
+	 * we will use the default metadata cluster in fs_info
+	 */
+	if (parent && !parent->cluster)
+		parent->cluster =3D btrfs_alloc_free_cluster();
+
+	if (parent)
+		cluster =3D parent->cluster;
+
+	ret =3D btrfs_reserve_extent_mdata(trans, root, blocksize, blocksize,
+					 empty_size, hint, (u64)-1, &ins,
+					 cluster);
 	if (ret) {
 		unuse_block_rsv(block_rsv, blocksize);
 		return ERR_PTR(ret);
@@ -5768,11 +5797,11 @@ struct extent_buffer *btrfs_alloc_free_block(st=
ruct btrfs_trans_handle *trans,
 	BUG_ON(IS_ERR(buf));
=20
 	if (root_objectid =3D=3D BTRFS_TREE_RELOC_OBJECTID) {
-		if (parent =3D=3D 0)
-			parent =3D ins.objectid;
+		if (parent_start =3D=3D 0)
+			parent_start =3D ins.objectid;
 		flags |=3D BTRFS_BLOCK_FLAG_FULL_BACKREF;
 	} else
-		BUG_ON(parent > 0);
+		BUG_ON(parent_start > 0);
=20
 	if (root_objectid !=3D BTRFS_TREE_LOG_OBJECTID) {
 		struct btrfs_delayed_extent_op *extent_op;
@@ -5788,7 +5817,7 @@ struct extent_buffer *btrfs_alloc_free_block(stru=
ct btrfs_trans_handle *trans,
 		extent_op->is_data =3D 0;
=20
 		ret =3D btrfs_add_delayed_tree_ref(trans, ins.objectid,
-					ins.offset, parent, root_objectid,
+					ins.offset, parent_start, root_objectid,
 					level, BTRFS_ADD_DELAYED_EXTENT,
 					extent_op);
 		BUG_ON(ret);
@@ -7231,18 +7260,18 @@ int btrfs_remove_block_group(struct btrfs_trans=
_handle *trans,
=20
 	/* make sure this block group isn't part of an allocation cluster */
 	cluster =3D &root->fs_info->data_alloc_cluster;
-	spin_lock(&cluster->refill_lock);
+	mutex_lock(&cluster->refill_lock);
 	btrfs_return_cluster_to_free_space(block_group, cluster);
-	spin_unlock(&cluster->refill_lock);
+	mutex_unlock(&cluster->refill_lock);
=20
 	/*
 	 * make sure this block group isn't part of a metadata
 	 * allocation cluster
 	 */
 	cluster =3D &root->fs_info->meta_alloc_cluster;
-	spin_lock(&cluster->refill_lock);
+	mutex_lock(&cluster->refill_lock);
 	btrfs_return_cluster_to_free_space(block_group, cluster);
-	spin_unlock(&cluster->refill_lock);
+	mutex_unlock(&cluster->refill_lock);
=20
 	path =3D btrfs_alloc_path();
 	if (!path) {
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d418164..78196f2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -17,6 +17,7 @@
 #include "compat.h"
 #include "ctree.h"
 #include "btrfs_inode.h"
+#include "free-space-cache.h"
=20
 static struct kmem_cache *extent_state_cache;
 static struct kmem_cache *extent_buffer_cache;
@@ -2988,6 +2989,7 @@ static struct extent_buffer *__alloc_extent_buffe=
r(struct extent_io_tree *tree,
 	spin_unlock_irqrestore(&leak_lock, flags);
 #endif
 	atomic_set(&eb->refs, 1);
+	eb->cluster =3D NULL;
=20
 	return eb;
 }
@@ -3827,7 +3829,10 @@ out:
 	spin_unlock(&tree->buffer_lock);
=20
 	/* at this point we can safely release the extent buffer */
-	if (atomic_read(&eb->refs) =3D=3D 0)
+	if (atomic_read(&eb->refs) =3D=3D 0) {
+		btrfs_free_extent_cluster(eb);
 		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
+	}
 	return ret;
 }
+
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 7b2f0c3..8ee8953 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -146,6 +146,9 @@ struct extent_buffer {
 	 * to unlock
 	 */
 	wait_queue_head_t read_lock_wq;
+
+	/* Used for the node to allocate space for its children */
+	struct btrfs_free_cluster *cluster;
 };
=20
 static inline void extent_set_compress_type(unsigned long *bio_flags,
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e555899..e540e77 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -31,9 +31,15 @@
 #define MAX_CACHE_BYTES_PER_GIG	(32 * 1024)
=20
 static struct kmem_cache *btrfs_free_space_cachep;
+static struct kmem_cache *btrfs_free_cluster_cachep;
=20
 static int link_free_space(struct btrfs_free_space_ctl *ctl,
 			   struct btrfs_free_space *info);
+static bool try_merge_free_space(struct btrfs_free_space_ctl *ctl,
+				 struct btrfs_free_space *info,
+				 bool update_stat);
+static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
+			      struct btrfs_free_space *info, bool update_stat);
=20
 int __init free_space_cache_init(void)
 {
@@ -43,6 +49,14 @@ int __init free_space_cache_init(void)
 	if (!btrfs_free_space_cachep)
 		return -ENOMEM;
=20
+	btrfs_free_cluster_cachep =3D kmem_cache_create("extent_clusters",
+			sizeof(struct btrfs_free_cluster), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,	NULL);
+	if (!btrfs_free_cluster_cachep) {
+		kmem_cache_destroy(btrfs_free_space_cachep);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
=20
@@ -50,6 +64,8 @@ void free_space_cache_exit(void)
 {
 	if (btrfs_free_space_cachep)
 		kmem_cache_destroy(btrfs_free_space_cachep);
+	if (btrfs_free_cluster_cachep)
+		kmem_cache_destroy(btrfs_free_cluster_cachep);
 }
=20
 static struct inode *__lookup_free_space_inode(struct btrfs_root *root=
,
@@ -397,11 +413,32 @@ int __load_free_space_cache(struct btrfs_root *ro=
ot, struct inode *inode,
=20
 			if (entry->type =3D=3D BTRFS_FREE_SPACE_EXTENT) {
 				spin_lock(&ctl->tree_lock);
+				if (try_merge_free_space(ctl, e, true))
+					goto link;
+
+				ret =3D insert_into_bitmap(ctl, e, true);
+				if (ret < 0) {
+					spin_unlock(&ctl->tree_lock);
+					printk(KERN_ERR "Inserting into bitmap "
+					       "failed, dumping\n");
+					kmem_cache_free(btrfs_free_space_cachep,
+							e);
+					kunmap(page);
+					unlock_page(page);
+					page_cache_release(page);
+					goto free_cache;
+				} else if (ret) {
+					ret =3D 0;
+					goto next_entry;
+				}
+link:
 				ret =3D link_free_space(ctl, e);
 				spin_unlock(&ctl->tree_lock);
 				if (ret) {
 					printk(KERN_ERR "Duplicate entries in "
 					       "free space cache, dumping\n");
+					kmem_cache_free(btrfs_free_space_cachep,
+							e);
 					kunmap(page);
 					unlock_page(page);
 					page_cache_release(page);
@@ -425,6 +462,9 @@ int __load_free_space_cache(struct btrfs_root *root=
, struct inode *inode,
 				if (ret) {
 					printk(KERN_ERR "Duplicate entries in "
 					       "free space cache, dumping\n");
+					kfree(e->bitmap);
+					kmem_cache_free(
+						btrfs_free_space_cachep, e);
 					kunmap(page);
 					unlock_page(page);
 					page_cache_release(page);
@@ -432,7 +472,7 @@ int __load_free_space_cache(struct btrfs_root *root=
, struct inode *inode,
 				}
 				list_add_tail(&e->list, &bitmaps);
 			}
-
+next_entry:
 			num_entries--;
 			offset +=3D sizeof(struct btrfs_free_space_entry);
 			if (offset + sizeof(struct btrfs_free_space_entry) >=3D
@@ -676,7 +716,8 @@ int __btrfs_write_out_cache(struct btrfs_root *root=
, struct inode *inode,
 		while (node && !next_page) {
 			struct btrfs_free_space *e;
=20
-			e =3D rb_entry(node, struct btrfs_free_space, offset_index);
+			e =3D rb_entry(node, struct btrfs_free_space,
+				     offset_index);
 			entries++;
=20
 			entry->offset =3D cpu_to_le64(e->offset);
@@ -689,10 +730,39 @@ int __btrfs_write_out_cache(struct btrfs_root *ro=
ot, struct inode *inode,
 				entry->type =3D BTRFS_FREE_SPACE_EXTENT;
 			}
 			node =3D rb_next(node);
-			if (!node && cluster) {
-				node =3D rb_first(&cluster->root);
+			offset +=3D sizeof(struct btrfs_free_space_entry);
+			if (offset + sizeof(struct btrfs_free_space_entry) >=3D
+			    PAGE_CACHE_SIZE)
+				next_page =3D true;
+			entry++;
+		}
+
+		/*
+		 * We want to write the extent in the cluster to our free space
+		 * cache.
+		 */
+		while (cluster && !next_page) {
+			struct btrfs_free_space *e;
+
+			e =3D cluster->info;
+			if (!e || !e->bytes)
+				break;
+
+			entries++;
+
+			entry->offset =3D cpu_to_le64(e->offset);
+			entry->bytes =3D cpu_to_le64(e->bytes);
+			entry->type =3D BTRFS_FREE_SPACE_EXTENT;
+
+			if (list_is_last(&cluster->block_group_list,
+					 &block_group->cluster_list))
 				cluster =3D NULL;
-			}
+			else
+				cluster =3D list_entry(
+						cluster->block_group_list.next,
+						struct btrfs_free_cluster,
+						block_group_list);
+
 			offset +=3D sizeof(struct btrfs_free_space_entry);
 			if (offset + sizeof(struct btrfs_free_space_entry) >=3D
 			    PAGE_CACHE_SIZE)
@@ -1125,19 +1195,30 @@ static void unlink_free_space(struct btrfs_free=
_space_ctl *ctl,
 	ctl->free_space -=3D info->bytes;
 }
=20
+static int __link_free_space(struct btrfs_free_space_ctl *ctl,
+			     struct btrfs_free_space *info)
+{
+	int ret;
+
+	ret =3D tree_insert_offset(&ctl->free_space_offset, info->offset,
+				 &info->offset_index, (info->bitmap !=3D NULL));
+	if (ret)
+		return ret;
+	ctl->free_extents++;
+	return 0;
+}
+
 static int link_free_space(struct btrfs_free_space_ctl *ctl,
 			   struct btrfs_free_space *info)
 {
-	int ret =3D 0;
+	int ret;
=20
 	BUG_ON(!info->bitmap && !info->bytes);
-	ret =3D tree_insert_offset(&ctl->free_space_offset, info->offset,
-				 &info->offset_index, (info->bitmap !=3D NULL));
+	ret =3D __link_free_space(ctl, info);
 	if (ret)
 		return ret;
=20
 	ctl->free_space +=3D info->bytes;
-	ctl->free_extents++;
 	return ret;
 }
=20
@@ -1212,7 +1293,7 @@ static void bitmap_clear_bits(struct btrfs_free_s=
pace_ctl *ctl,
=20
 static void bitmap_set_bits(struct btrfs_free_space_ctl *ctl,
 			    struct btrfs_free_space *info, u64 offset,
-			    u64 bytes)
+			    u64 bytes, bool update_stat)
 {
 	unsigned long start, count;
=20
@@ -1223,7 +1304,8 @@ static void bitmap_set_bits(struct btrfs_free_spa=
ce_ctl *ctl,
 	bitmap_set(info->bitmap, start, count);
=20
 	info->bytes +=3D bytes;
-	ctl->free_space +=3D bytes;
+	if (update_stat)
+		ctl->free_space +=3D bytes;
 }
=20
 static int search_bitmap(struct btrfs_free_space_ctl *ctl,
@@ -1394,7 +1476,7 @@ again:
=20
 static u64 add_bytes_to_bitmap(struct btrfs_free_space_ctl *ctl,
 			       struct btrfs_free_space *info, u64 offset,
-			       u64 bytes)
+			       u64 bytes, bool update_stat)
 {
 	u64 bytes_to_set =3D 0;
 	u64 end;
@@ -1403,7 +1485,7 @@ static u64 add_bytes_to_bitmap(struct btrfs_free_=
space_ctl *ctl,
=20
 	bytes_to_set =3D min(end - offset, bytes);
=20
-	bitmap_set_bits(ctl, info, offset, bytes_to_set);
+	bitmap_set_bits(ctl, info, offset, bytes_to_set, update_stat);
=20
 	return bytes_to_set;
=20
@@ -1451,10 +1533,9 @@ static struct btrfs_free_space_op free_space_op =
=3D {
 };
=20
 static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
-			      struct btrfs_free_space *info)
+			      struct btrfs_free_space *info, bool update_stat)
 {
 	struct btrfs_free_space *bitmap_info;
-	struct btrfs_block_group_cache *block_group =3D NULL;
 	int added =3D 0;
 	u64 bytes, offset, bytes_added;
 	int ret;
@@ -1465,49 +1546,7 @@ static int insert_into_bitmap(struct btrfs_free_=
space_ctl *ctl,
 	if (!ctl->op->use_bitmap(ctl, info))
 		return 0;
=20
-	if (ctl->op =3D=3D &free_space_op)
-		block_group =3D ctl->private;
 again:
-	/*
-	 * Since we link bitmaps right into the cluster we need to see if we
-	 * have a cluster here, and if so and it has our bitmap we need to ad=
d
-	 * the free space to that bitmap.
-	 */
-	if (block_group && !list_empty(&block_group->cluster_list)) {
-		struct btrfs_free_cluster *cluster;
-		struct rb_node *node;
-		struct btrfs_free_space *entry;
-
-		cluster =3D list_entry(block_group->cluster_list.next,
-				     struct btrfs_free_cluster,
-				     block_group_list);
-		spin_lock(&cluster->lock);
-		node =3D rb_first(&cluster->root);
-		if (!node) {
-			spin_unlock(&cluster->lock);
-			goto no_cluster_bitmap;
-		}
-
-		entry =3D rb_entry(node, struct btrfs_free_space, offset_index);
-		if (!entry->bitmap) {
-			spin_unlock(&cluster->lock);
-			goto no_cluster_bitmap;
-		}
-
-		if (entry->offset =3D=3D offset_to_bitmap(ctl, offset)) {
-			bytes_added =3D add_bytes_to_bitmap(ctl, entry,
-							  offset, bytes);
-			bytes -=3D bytes_added;
-			offset +=3D bytes_added;
-		}
-		spin_unlock(&cluster->lock);
-		if (!bytes) {
-			ret =3D 1;
-			goto out;
-		}
-	}
-
-no_cluster_bitmap:
 	bitmap_info =3D tree_search_offset(ctl, offset_to_bitmap(ctl, offset)=
,
 					 1, 0);
 	if (!bitmap_info) {
@@ -1515,7 +1554,8 @@ no_cluster_bitmap:
 		goto new_bitmap;
 	}
=20
-	bytes_added =3D add_bytes_to_bitmap(ctl, bitmap_info, offset, bytes);
+	bytes_added =3D add_bytes_to_bitmap(ctl, bitmap_info, offset, bytes,
+					  update_stat);
 	bytes -=3D bytes_added;
 	offset +=3D bytes_added;
 	added =3D 0;
@@ -1533,6 +1573,12 @@ new_bitmap:
 		info =3D NULL;
 		goto again;
 	} else {
+		if (current->flags & PF_MEMALLOC) {
+			printk(KERN_INFO "Alloc memory when reclaim "
+			       "the pages\n");
+			return 0;
+		}
+
 		spin_unlock(&ctl->tree_lock);
=20
 		/* no pre-allocated info, allocate a new one */
@@ -1635,7 +1681,7 @@ int __btrfs_add_free_space(struct btrfs_free_spac=
e_ctl *ctl,
 	 * extent then we know we're going to have to allocate a new extent, =
so
 	 * before we do that see if we need to drop this into a bitmap
 	 */
-	ret =3D insert_into_bitmap(ctl, info);
+	ret =3D insert_into_bitmap(ctl, info, true);
 	if (ret < 0) {
 		goto out;
 	} else if (ret) {
@@ -1829,36 +1875,50 @@ __btrfs_return_cluster_to_free_space(
 {
 	struct btrfs_free_space_ctl *ctl =3D block_group->free_space_ctl;
 	struct btrfs_free_space *entry;
-	struct rb_node *node;
+	int ret =3D 0;
=20
 	spin_lock(&cluster->lock);
-	if (cluster->block_group !=3D block_group)
+	if (cluster->block_group !=3D block_group) {
+		spin_unlock(&cluster->lock);
 		goto out;
+	}
=20
 	cluster->block_group =3D NULL;
-	cluster->window_start =3D 0;
+
+	entry =3D cluster->info;
+	cluster->info =3D NULL;
+
 	list_del_init(&cluster->block_group_list);
+	spin_unlock(&cluster->lock);
=20
-	node =3D rb_first(&cluster->root);
-	while (node) {
-		bool bitmap;
+	if (!entry)
+		goto out;
=20
-		entry =3D rb_entry(node, struct btrfs_free_space, offset_index);
-		node =3D rb_next(&entry->offset_index);
-		rb_erase(&entry->offset_index, &cluster->root);
-
-		bitmap =3D (entry->bitmap !=3D NULL);
-		if (!bitmap)
-			try_merge_free_space(ctl, entry, false);
-		tree_insert_offset(&ctl->free_space_offset,
-				   entry->offset, &entry->offset_index, bitmap);
+	if (!entry->bytes) {
+		kmem_cache_free(btrfs_free_space_cachep, entry);
+		goto out;
 	}
-	cluster->root =3D RB_ROOT;
=20
+	if (try_merge_free_space(ctl, entry, false))
+		goto link;
+
+	ret =3D insert_into_bitmap(ctl, entry, false);
+	if (ret < 0)
+		goto out;
+	else if (ret) {
+		ret =3D 0;
+		goto out;
+	}
+link:
+	ret =3D __link_free_space(ctl, entry);
+	if (ret) {
+		kmem_cache_free(btrfs_free_space_cachep, entry);
+		printk(KERN_ERR "Duplicate entries in free space cache, "
+				"dumping\n");
+	}
 out:
-	spin_unlock(&cluster->lock);
 	btrfs_put_block_group(block_group);
-	return 0;
+	return ret;
 }
=20
 void __btrfs_remove_free_space_cache_locked(struct btrfs_free_space_ct=
l *ctl)
@@ -1889,29 +1949,58 @@ void __btrfs_remove_free_space_cache(struct btr=
fs_free_space_ctl *ctl)
 	spin_unlock(&ctl->tree_lock);
 }
=20
-void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *blo=
ck_group)
+static void __btrfs_reclaim_extent_clusters(
+				struct btrfs_block_group_cache *block_group,
+				u64 to_reclaim)
 {
-	struct btrfs_free_space_ctl *ctl =3D block_group->free_space_ctl;
 	struct btrfs_free_cluster *cluster;
 	struct list_head *head;
+	u64 bytes;
+	bool reclaim_all =3D (to_reclaim =3D=3D 0);
=20
-	spin_lock(&ctl->tree_lock);
 	while ((head =3D block_group->cluster_list.next) !=3D
 	       &block_group->cluster_list) {
 		cluster =3D list_entry(head, struct btrfs_free_cluster,
 				     block_group_list);
=20
 		WARN_ON(cluster->block_group !=3D block_group);
+
+		bytes =3D cluster->info->bytes;
 		__btrfs_return_cluster_to_free_space(block_group, cluster);
+
+		if (!reclaim_all) {
+			if (to_reclaim > bytes)
+				to_reclaim -=3D bytes;
+			else {
+				to_reclaim =3D 0;
+				break;
+			}
+		}
+
 		if (need_resched()) {
-			spin_unlock(&ctl->tree_lock);
+			spin_unlock(&block_group->free_space_ctl->tree_lock);
 			cond_resched();
-			spin_lock(&ctl->tree_lock);
+			spin_lock(&block_group->free_space_ctl->tree_lock);
 		}
 	}
+}
+
+void btrfs_reclaim_extent_clusters(struct btrfs_block_group_cache *blo=
ck_group,
+				   u64 to_reclaim)
+{
+	spin_lock(&block_group->free_space_ctl->tree_lock);
+	__btrfs_reclaim_extent_clusters(block_group, to_reclaim);
+	spin_unlock(&block_group->free_space_ctl->tree_lock);
+}
+
+void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *blo=
ck_group)
+{
+	struct btrfs_free_space_ctl *ctl =3D block_group->free_space_ctl;
+
+	spin_lock(&ctl->tree_lock);
+	__btrfs_reclaim_extent_clusters(block_group, 0);
 	__btrfs_remove_free_space_cache_locked(ctl);
 	spin_unlock(&ctl->tree_lock);
-
 }
=20
 u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_g=
roup,
@@ -1991,30 +2080,6 @@ int btrfs_return_cluster_to_free_space(
 	return ret;
 }
=20
-static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *blo=
ck_group,
-				   struct btrfs_free_cluster *cluster,
-				   struct btrfs_free_space *entry,
-				   u64 bytes, u64 min_start)
-{
-	struct btrfs_free_space_ctl *ctl =3D block_group->free_space_ctl;
-	int err;
-	u64 search_start =3D cluster->window_start;
-	u64 search_bytes =3D bytes;
-	u64 ret =3D 0;
-
-	search_start =3D min_start;
-	search_bytes =3D bytes;
-
-	err =3D search_bitmap(ctl, entry, &search_start, &search_bytes);
-	if (err)
-		return 0;
-
-	ret =3D search_start;
-	__bitmap_clear_bits(ctl, entry, ret, bytes);
-
-	return ret;
-}
-
 /*
  * given a cluster, try to allocate 'bytes' from it, returns 0
  * if it couldn't find anything suitably large, or a logical disk offs=
et
@@ -2025,56 +2090,26 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block=
_group_cache *block_group,
 			     u64 min_start)
 {
 	struct btrfs_free_space_ctl *ctl =3D block_group->free_space_ctl;
-	struct btrfs_free_space *entry =3D NULL;
-	struct rb_node *node;
 	u64 ret =3D 0;
=20
 	spin_lock(&cluster->lock);
-	if (bytes > cluster->max_size)
-		goto out;
-
 	if (cluster->block_group !=3D block_group)
 		goto out;
=20
-	node =3D rb_first(&cluster->root);
-	if (!node)
+	/*
+	 * If we set ->block_group, it means we have filled this cluster,
+	 * and ->info also has been set. So we needn't check ->info is
+	 * NULL or not now.
+	 */
+	if (bytes > cluster->info->bytes)
 		goto out;
=20
-	entry =3D rb_entry(node, struct btrfs_free_space, offset_index);
-	while(1) {
-		if (entry->bytes < bytes ||
-		    (!entry->bitmap && entry->offset < min_start)) {
-			node =3D rb_next(&entry->offset_index);
-			if (!node)
-				break;
-			entry =3D rb_entry(node, struct btrfs_free_space,
-					 offset_index);
-			continue;
-		}
-
-		if (entry->bitmap) {
-			ret =3D btrfs_alloc_from_bitmap(block_group,
-						      cluster, entry, bytes,
-						      min_start);
-			if (ret =3D=3D 0) {
-				node =3D rb_next(&entry->offset_index);
-				if (!node)
-					break;
-				entry =3D rb_entry(node, struct btrfs_free_space,
-						 offset_index);
-				continue;
-			}
-		} else {
-			ret =3D entry->offset;
-
-			entry->offset +=3D bytes;
-			entry->bytes -=3D bytes;
-		}
+	if (min_start >=3D cluster->info->offset + cluster->info->bytes)
+		goto out;
=20
-		if (entry->bytes =3D=3D 0)
-			rb_erase(&entry->offset_index, &cluster->root);
-		break;
-	}
+	ret =3D cluster->info->offset;
+	cluster->info->offset +=3D bytes;
+	cluster->info->bytes -=3D bytes;
 out:
 	spin_unlock(&cluster->lock);
=20
@@ -2082,260 +2117,12 @@ out:
 		return 0;
=20
 	spin_lock(&ctl->tree_lock);
-
 	ctl->free_space -=3D bytes;
-	if (entry->bytes =3D=3D 0) {
-		ctl->free_extents--;
-		if (entry->bitmap) {
-			kfree(entry->bitmap);
-			ctl->total_bitmaps--;
-			ctl->op->recalc_thresholds(ctl);
-		}
-		kmem_cache_free(btrfs_free_space_cachep, entry);
-	}
-
 	spin_unlock(&ctl->tree_lock);
=20
 	return ret;
 }
=20
-static int btrfs_bitmap_cluster(struct btrfs_block_group_cache *block_=
group,
-				struct btrfs_free_space *entry,
-				struct btrfs_free_cluster *cluster,
-				u64 offset, u64 bytes, u64 min_bytes)
-{
-	struct btrfs_free_space_ctl *ctl =3D block_group->free_space_ctl;
-	unsigned long next_zero;
-	unsigned long i;
-	unsigned long search_bits;
-	unsigned long total_bits;
-	unsigned long found_bits;
-	unsigned long start =3D 0;
-	unsigned long total_found =3D 0;
-	int ret;
-	bool found =3D false;
-
-	i =3D offset_to_bit(entry->offset, block_group->sectorsize,
-			  max_t(u64, offset, entry->offset));
-	search_bits =3D bytes_to_bits(bytes, block_group->sectorsize);
-	total_bits =3D bytes_to_bits(min_bytes, block_group->sectorsize);
-
-again:
-	found_bits =3D 0;
-	for (i =3D find_next_bit(entry->bitmap, BITS_PER_BITMAP, i);
-	     i < BITS_PER_BITMAP;
-	     i =3D find_next_bit(entry->bitmap, BITS_PER_BITMAP, i + 1)) {
-		next_zero =3D find_next_zero_bit(entry->bitmap,
-					       BITS_PER_BITMAP, i);
-		if (next_zero - i >=3D search_bits) {
-			found_bits =3D next_zero - i;
-			break;
-		}
-		i =3D next_zero;
-	}
-
-	if (!found_bits)
-		return -ENOSPC;
-
-	if (!found) {
-		start =3D i;
-		found =3D true;
-	}
-
-	total_found +=3D found_bits;
-
-	if (cluster->max_size < found_bits * block_group->sectorsize)
-		cluster->max_size =3D found_bits * block_group->sectorsize;
-
-	if (total_found < total_bits) {
-		i =3D find_next_bit(entry->bitmap, BITS_PER_BITMAP, next_zero);
-		if (i - start > total_bits * 2) {
-			total_found =3D 0;
-			cluster->max_size =3D 0;
-			found =3D false;
-		}
-		goto again;
-	}
-
-	cluster->window_start =3D start * block_group->sectorsize +
-		entry->offset;
-	rb_erase(&entry->offset_index, &ctl->free_space_offset);
-	ret =3D tree_insert_offset(&cluster->root, entry->offset,
-				 &entry->offset_index, 1);
-	BUG_ON(ret);
-
-	return 0;
-}
-
-/*
- * This searches the block group for just extents to fill the cluster =
with.
- */
-static noinline int
-setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
-			struct btrfs_free_cluster *cluster,
-			struct list_head *bitmaps, u64 offset, u64 bytes,
-			u64 min_bytes)
-{
-	struct btrfs_free_space_ctl *ctl =3D block_group->free_space_ctl;
-	struct btrfs_free_space *first =3D NULL;
-	struct btrfs_free_space *entry =3D NULL;
-	struct btrfs_free_space *prev =3D NULL;
-	struct btrfs_free_space *last;
-	struct rb_node *node;
-	u64 window_start;
-	u64 window_free;
-	u64 max_extent;
-	u64 max_gap =3D 128 * 1024;
-
-	entry =3D tree_search_offset(ctl, offset, 0, 1);
-	if (!entry)
-		return -ENOSPC;
-
-	/*
-	 * We don't want bitmaps, so just move along until we find a normal
-	 * extent entry.
-	 */
-	while (entry->bitmap) {
-		if (list_empty(&entry->list))
-			list_add_tail(&entry->list, bitmaps);
-		node =3D rb_next(&entry->offset_index);
-		if (!node)
-			return -ENOSPC;
-		entry =3D rb_entry(node, struct btrfs_free_space, offset_index);
-	}
-
-	window_start =3D entry->offset;
-	window_free =3D entry->bytes;
-	max_extent =3D entry->bytes;
-	first =3D entry;
-	last =3D entry;
-	prev =3D entry;
-
-	while (window_free <=3D min_bytes) {
-		node =3D rb_next(&entry->offset_index);
-		if (!node)
-			return -ENOSPC;
-		entry =3D rb_entry(node, struct btrfs_free_space, offset_index);
-
-		if (entry->bitmap) {
-			if (list_empty(&entry->list))
-				list_add_tail(&entry->list, bitmaps);
-			continue;
-		}
-
-		/*
-		 * we haven't filled the empty size and the window is
-		 * very large.  reset and try again
-		 */
-		if (entry->offset - (prev->offset + prev->bytes) > max_gap ||
-		    entry->offset - window_start > (min_bytes * 2)) {
-			first =3D entry;
-			window_start =3D entry->offset;
-			window_free =3D entry->bytes;
-			last =3D entry;
-			max_extent =3D entry->bytes;
-		} else {
-			last =3D entry;
-			window_free +=3D entry->bytes;
-			if (entry->bytes > max_extent)
-				max_extent =3D entry->bytes;
-		}
-		prev =3D entry;
-	}
-
-	cluster->window_start =3D first->offset;
-
-	node =3D &first->offset_index;
-
-	/*
-	 * now we've found our entries, pull them out of the free space
-	 * cache and put them into the cluster rbtree
-	 */
-	do {
-		int ret;
-
-		entry =3D rb_entry(node, struct btrfs_free_space, offset_index);
-		node =3D rb_next(&entry->offset_index);
-		if (entry->bitmap)
-			continue;
-
-		rb_erase(&entry->offset_index, &ctl->free_space_offset);
-		ret =3D tree_insert_offset(&cluster->root, entry->offset,
-					 &entry->offset_index, 0);
-		BUG_ON(ret);
-	} while (node && entry !=3D last);
-
-	cluster->max_size =3D max_extent;
-
-	return 0;
-}
-
-/*
- * This specifically looks for bitmaps that may work in the cluster, w=
e assume
- * that we have already failed to find extents that will work.
- */
-static noinline int
-setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
-		     struct btrfs_free_cluster *cluster,
-		     struct list_head *bitmaps, u64 offset, u64 bytes,
-		     u64 min_bytes)
-{
-	struct btrfs_free_space_ctl *ctl =3D block_group->free_space_ctl;
-	struct btrfs_free_space *entry;
-	struct rb_node *node;
-	int ret =3D -ENOSPC;
-
-	if (ctl->total_bitmaps =3D=3D 0)
-		return -ENOSPC;
-
-	/*
-	 * First check our cached list of bitmaps and see if there is an entr=
y
-	 * here that will work.
-	 */
-	list_for_each_entry(entry, bitmaps, list) {
-		if (entry->bytes < min_bytes)
-			continue;
-		ret =3D btrfs_bitmap_cluster(block_group, entry, cluster, offset,
-					   bytes, min_bytes);
-		if (!ret)
-			return 0;
-	}
-
-	/*
-	 * If we do have entries on our list and we are here then we didn't f=
ind
-	 * anything, so go ahead and get the next entry after the last entry =
in
-	 * this list and start the search from there.
-	 */
-	if (!list_empty(bitmaps)) {
-		entry =3D list_entry(bitmaps->prev, struct btrfs_free_space,
-				   list);
-		node =3D rb_next(&entry->offset_index);
-		if (!node)
-			return -ENOSPC;
-		entry =3D rb_entry(node, struct btrfs_free_space, offset_index);
-		goto search;
-	}
-
-	entry =3D tree_search_offset(ctl, offset_to_bitmap(ctl, offset), 0, 1=
);
-	if (!entry)
-		return -ENOSPC;
-
-search:
-	node =3D &entry->offset_index;
-	do {
-		entry =3D rb_entry(node, struct btrfs_free_space, offset_index);
-		node =3D rb_next(&entry->offset_index);
-		if (!entry->bitmap)
-			continue;
-		if (entry->bytes < min_bytes)
-			continue;
-		ret =3D btrfs_bitmap_cluster(block_group, entry, cluster, offset,
-					   bytes, min_bytes);
-	} while (ret && node);
-
-	return ret;
-}
-
 /*
  * here we try to find a cluster of blocks in a block group.  The goal
  * is to find at least bytes free and up to empty_size + bytes free.
@@ -2351,11 +2138,12 @@ int btrfs_find_space_cluster(struct btrfs_trans=
_handle *trans,
 			     u64 offset, u64 bytes, u64 empty_size)
 {
 	struct btrfs_free_space_ctl *ctl =3D block_group->free_space_ctl;
-	struct list_head bitmaps;
-	struct btrfs_free_space *entry, *tmp;
+	struct btrfs_free_space *entry, *info;
 	u64 min_bytes;
 	int ret;
=20
+	BUG_ON(cluster->info);
+
 	/* for metadata, allow allocates with more holes */
 	if (btrfs_test_opt(root, SSD_SPREAD)) {
 		min_bytes =3D bytes + empty_size;
@@ -2369,9 +2157,16 @@ int btrfs_find_space_cluster(struct btrfs_trans_=
handle *trans,
 			min_bytes =3D max(bytes, (bytes + empty_size) >> 1);
 		else
 			min_bytes =3D max(bytes, (bytes + empty_size) >> 4);
+		min_bytes =3D max(min_bytes, (u64)256 * 1024);
 	} else
 		min_bytes =3D max(bytes, (bytes + empty_size) >> 2);
=20
+	min_bytes =3D round_up(min_bytes, root->sectorsize);
+
+	info =3D kmem_cache_zalloc(btrfs_free_space_cachep, GFP_NOFS);
+	if (!info)
+		return -ENOMEM;
+
 	spin_lock(&ctl->tree_lock);
=20
 	/*
@@ -2380,6 +2175,7 @@ int btrfs_find_space_cluster(struct btrfs_trans_h=
andle *trans,
 	 */
 	if (ctl->free_space < min_bytes) {
 		spin_unlock(&ctl->tree_lock);
+		kmem_cache_free(btrfs_free_space_cachep, info);
 		return -ENOSPC;
 	}
=20
@@ -2388,26 +2184,44 @@ int btrfs_find_space_cluster(struct btrfs_trans=
_handle *trans,
 	/* someone already found a cluster, hooray */
 	if (cluster->block_group) {
 		ret =3D 0;
+		kmem_cache_free(btrfs_free_space_cachep, info);
 		goto out;
 	}
=20
-	INIT_LIST_HEAD(&bitmaps);
-	ret =3D setup_cluster_no_bitmap(block_group, cluster, &bitmaps, offse=
t,
-				      bytes, min_bytes);
-	if (ret)
-		ret =3D setup_cluster_bitmap(block_group, cluster, &bitmaps,
-					   offset, bytes, min_bytes);
+	bytes =3D min_bytes;
+	entry =3D find_free_space(ctl, &offset, &min_bytes);
+	if (!entry) {
+		ret =3D -ENOSPC;
+		kmem_cache_free(btrfs_free_space_cachep, info);
+		goto out;
+	}
=20
-	/* Clear our temporary list */
-	list_for_each_entry_safe(entry, tmp, &bitmaps, list)
-		list_del_init(&entry->list);
+	BUG_ON(min_bytes < bytes);
=20
-	if (!ret) {
-		atomic_inc(&block_group->count);
-		list_add_tail(&cluster->block_group_list,
-			      &block_group->cluster_list);
-		cluster->block_group =3D block_group;
+	ret =3D 0;
+	if (entry->bitmap) {
+		__bitmap_clear_bits(ctl, entry, offset, bytes);
+		if (!entry->bytes)
+			free_bitmap(ctl, entry);
+	} else {
+		__unlink_free_space(ctl, entry);
+		entry->offset +=3D bytes;
+		entry->bytes -=3D bytes;
+		if (!entry->bytes)
+			kmem_cache_free(btrfs_free_space_cachep, entry);
+		else
+			__link_free_space(ctl, entry);
 	}
+
+	info->offset =3D offset;
+	info->bytes =3D bytes;
+
+	cluster->info =3D info;
+
+	atomic_inc(&block_group->count);
+	list_add_tail(&cluster->block_group_list,
+		      &block_group->cluster_list);
+	cluster->block_group =3D block_group;
 out:
 	spin_unlock(&cluster->lock);
 	spin_unlock(&ctl->tree_lock);
@@ -2421,11 +2235,10 @@ out:
 void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster)
 {
 	spin_lock_init(&cluster->lock);
-	spin_lock_init(&cluster->refill_lock);
-	cluster->root =3D RB_ROOT;
-	cluster->max_size =3D 0;
+	mutex_init(&cluster->refill_lock);
 	INIT_LIST_HEAD(&cluster->block_group_list);
 	cluster->block_group =3D NULL;
+	cluster->info =3D NULL;
 }
=20
 int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group=
,
@@ -2665,3 +2478,27 @@ int btrfs_write_out_ino_cache(struct btrfs_root =
*root,
 	iput(inode);
 	return ret;
 }
+
+struct btrfs_free_cluster *btrfs_alloc_free_cluster(void)
+{
+	struct btrfs_free_cluster *cluster;
+
+	cluster =3D kmem_cache_zalloc(btrfs_free_cluster_cachep, GFP_NOFS);
+	if (!cluster)
+		return NULL;
+
+	btrfs_init_free_cluster(cluster);
+	return cluster;
+}
+
+void btrfs_release_free_cluster(struct btrfs_free_cluster *cluster)
+{
+	/* return the free space in the cluster to the space cache. */
+	mutex_lock(&cluster->refill_lock);
+	btrfs_return_cluster_to_free_space(NULL, cluster);
+	mutex_unlock(&cluster->refill_lock);
+
+	/* free the cluster. */
+	kmem_cache_free(btrfs_free_cluster_cachep, cluster);
+}
+
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index c27ccba..1f7e75c 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -34,6 +34,7 @@ struct btrfs_free_space_ctl {
 	int extents_thresh;
 	int free_extents;
 	int total_bitmaps;
+	int total_clusters;
 	int unit;
 	u64 start;
 	struct btrfs_free_space_op *op;
@@ -113,4 +114,16 @@ int btrfs_return_cluster_to_free_space(
 			       struct btrfs_free_cluster *cluster);
 int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group=
,
 			   u64 *trimmed, u64 start, u64 end, u64 minlen);
+void btrfs_reclaim_extent_clusters(struct btrfs_block_group_cache *blo=
ck_group,
+				   u64 to_reclaim);
+struct btrfs_free_cluster *btrfs_alloc_free_cluster(void);
+void btrfs_release_free_cluster(struct btrfs_free_cluster *cluster);
+static inline void btrfs_free_extent_cluster(struct extent_buffer *eb)
+{
+	if (!eb->cluster)
+		return;
+
+	btrfs_release_free_cluster(eb->cluster);
+	eb->cluster =3D NULL;
+}
 #endif
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index b4087e0..d501c1f 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -457,6 +457,7 @@ again:
 	spin_unlock(&root->cache_lock);
=20
 	spin_lock(&ctl->tree_lock);
+	WARN_ON(ctl->total_clusters);
 	prealloc =3D sizeof(struct btrfs_free_space) * ctl->free_extents;
 	prealloc =3D ALIGN(prealloc, PAGE_CACHE_SIZE);
 	prealloc +=3D ctl->total_bitmaps * PAGE_CACHE_SIZE;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7a9e01f..38a5da9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -51,7 +51,6 @@
 #include "tree-log.h"
 #include "compression.h"
 #include "locking.h"
-#include "free-space-cache.h"
 #include "inode-map.h"
=20
 struct btrfs_iget_args {
@@ -623,11 +622,10 @@ retry:
 		trans =3D btrfs_join_transaction(root);
 		BUG_ON(IS_ERR(trans));
 		trans->block_rsv =3D &root->fs_info->delalloc_block_rsv;
-		ret =3D btrfs_reserve_extent(trans, root,
-					   async_extent->compressed_size,
-					   async_extent->compressed_size,
-					   0, alloc_hint,
-					   (u64)-1, &ins, 1);
+		ret =3D btrfs_reserve_extent_data(trans, root,
+						async_extent->compressed_size,
+						async_extent->compressed_size,
+						0, alloc_hint, (u64)-1, &ins);
 		btrfs_end_transaction(trans, root);
=20
 		if (ret) {
@@ -828,9 +826,9 @@ static noinline int cow_file_range(struct inode *in=
ode,
 		unsigned long op;
=20
 		cur_alloc_size =3D disk_num_bytes;
-		ret =3D btrfs_reserve_extent(trans, root, cur_alloc_size,
-					   root->sectorsize, 0, alloc_hint,
-					   (u64)-1, &ins, 1);
+		ret =3D btrfs_reserve_extent_data(trans, root, cur_alloc_size,
+						root->sectorsize, 0, alloc_hint,
+						(u64)-1, &ins);
 		BUG_ON(ret);
=20
 		em =3D alloc_extent_map();
@@ -5409,8 +5407,8 @@ static struct extent_map *btrfs_new_extent_direct=
(struct inode *inode,
 	trans->block_rsv =3D &root->fs_info->delalloc_block_rsv;
=20
 	alloc_hint =3D get_extent_allocation_hint(inode, start, len);
-	ret =3D btrfs_reserve_extent(trans, root, len, root->sectorsize, 0,
-				   alloc_hint, (u64)-1, &ins, 1);
+	ret =3D btrfs_reserve_extent_data(trans, root, len, root->sectorsize,=
 0,
+					alloc_hint, (u64)-1, &ins);
 	if (ret) {
 		em =3D ERR_PTR(ret);
 		goto out;
@@ -7276,8 +7274,9 @@ static int __btrfs_prealloc_file_range(struct ino=
de *inode, int mode,
 			}
 		}
=20
-		ret =3D btrfs_reserve_extent(trans, root, num_bytes, min_size,
-					   0, *alloc_hint, (u64)-1, &ins, 1);
+		ret =3D btrfs_reserve_extent_data(trans, root, num_bytes,
+						min_size, 0, *alloc_hint,
+						(u64)-1, &ins);
 		if (ret) {
 			if (own_trans)
 				btrfs_end_transaction(trans, root);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 970977a..808203c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -347,7 +347,7 @@ static noinline int create_subvol(struct btrfs_root=
 *root,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
=20
-	leaf =3D btrfs_alloc_free_block(trans, root, root->leafsize,
+	leaf =3D btrfs_alloc_free_block(trans, root, root->leafsize, NULL,
 				      0, objectid, NULL, 0, 0, 0);
 	if (IS_ERR(leaf)) {
 		ret =3D PTR_ERR(leaf);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 786639f..21d08e2 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -25,6 +25,7 @@
 #include "print-tree.h"
 #include "compat.h"
 #include "tree-log.h"
+#include "free-space-cache.h"
=20
 /* magic values for the inode_only field in btrfs_log_inode:
  *
@@ -1763,6 +1764,8 @@ static noinline int walk_down_log_tree(struct btr=
fs_trans_handle *trans,
 				ret =3D btrfs_free_reserved_extent(root,
 							 bytenr, blocksize);
 				BUG_ON(ret);
+
+				btrfs_free_extent_cluster(next);
 			}
 			free_extent_buffer(next);
 			continue;
@@ -1832,6 +1835,8 @@ static noinline int walk_up_log_tree(struct btrfs=
_trans_handle *trans,
 						path->nodes[*level]->start,
 						path->nodes[*level]->len);
 				BUG_ON(ret);
+
+				btrfs_free_extent_cluster(next);
 			}
 			free_extent_buffer(path->nodes[*level]);
 			path->nodes[*level] =3D NULL;
@@ -1900,6 +1905,8 @@ static int walk_log_tree(struct btrfs_trans_handl=
e *trans,
 			ret =3D btrfs_free_reserved_extent(log, next->start,
 							 next->len);
 			BUG_ON(ret);
+
+			btrfs_free_extent_cluster(next);
 		}
 	}
=20
--=20
1.7.4
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
