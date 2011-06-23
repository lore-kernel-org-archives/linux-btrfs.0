From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] btrfs: fix inconsonant inode information
Date: Thu, 23 Jun 2011 15:27:13 +0800
Message-ID: <4E02EAD1.6050505@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Jim Schutt <jaschut@sandia.gov>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When iputting the inode, We may leave the delayed nodes if they have some
delayed items that have not been dealt with. So when the inode is read again,
we must look up the relative delayed node, and use the information in it to
initialize the inode. Or we will get inconsonant inode information, it may
cause that the same directory index number is allocated again, and hit the
following oops:

[ 5447.554187] err add delayed dir index item(name: pglog_0.965_0) into the
insertion tree of the delayed node(root id: 262, inode id: 258, errno: -17)
[ 5447.569766] ------------[ cut here ]------------
[ 5447.575361] kernel BUG at fs/btrfs/delayed-inode.c:1301!
[SNIP]
[ 5447.790721] Call Trace:
[ 5447.793191]  [<ffffffffa0641c4e>] btrfs_insert_dir_item+0x189/0x1bb [btrfs]
[ 5447.800156]  [<ffffffffa0651a45>] btrfs_add_link+0x12b/0x191 [btrfs]
[ 5447.806517]  [<ffffffffa0651adc>] btrfs_add_nondir+0x31/0x58 [btrfs]
[ 5447.812876]  [<ffffffffa0651d6a>] btrfs_create+0xf9/0x197 [btrfs]
[ 5447.818961]  [<ffffffff8111f840>] vfs_create+0x72/0x92
[ 5447.824090]  [<ffffffff8111fa8c>] do_last+0x22c/0x40b
[ 5447.829133]  [<ffffffff8112076a>] path_openat+0xc0/0x2ef
[ 5447.834438]  [<ffffffff810c58e2>] ? __perf_event_task_sched_out+0x24/0x44
[ 5447.841216]  [<ffffffff8103ecdd>] ? perf_event_task_sched_out+0x59/0x67
[ 5447.847846]  [<ffffffff81121a79>] do_filp_open+0x3d/0x87
[ 5447.853156]  [<ffffffff811e126c>] ? strncpy_from_user+0x43/0x4d
[ 5447.859072]  [<ffffffff8111f1f5>] ? getname_flags+0x2e/0x80
[ 5447.864636]  [<ffffffff8111f179>] ? do_getname+0x14b/0x173
[ 5447.870112]  [<ffffffff8111f1b7>] ? audit_getname+0x16/0x26
[ 5447.875682]  [<ffffffff8112b1ab>] ? spin_lock+0xe/0x10
[ 5447.880882]  [<ffffffff81112d39>] do_sys_open+0x69/0xae
[ 5447.886153]  [<ffffffff81112db1>] sys_open+0x20/0x22
[ 5447.891114]  [<ffffffff813b9aab>] system_call_fastpath+0x16/0x1b

Fix it by reusing the old delayed node.

Reported-by: Jim Schutt <jaschut@sandia.gov>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Tested-by: Jim Schutt <jaschut@sandia.gov>
---
 fs/btrfs/delayed-inode.c |  104 +++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/delayed-inode.h |    1 +
 fs/btrfs/inode.c         |   12 ++++-
 3 files changed, 91 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index f1cbd02..280755e 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -82,19 +82,16 @@ static inline struct btrfs_delayed_root *btrfs_get_delayed_root(
 	return root->fs_info->delayed_root;
 }
 
-static struct btrfs_delayed_node *btrfs_get_or_create_delayed_node(
-							struct inode *inode)
+static struct btrfs_delayed_node *btrfs_get_delayed_node(struct inode *inode)
 {
-	struct btrfs_delayed_node *node;
 	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
 	struct btrfs_root *root = btrfs_inode->root;
 	u64 ino = btrfs_ino(inode);
-	int ret;
+	struct btrfs_delayed_node *node;
 
-again:
 	node = ACCESS_ONCE(btrfs_inode->delayed_node);
 	if (node) {
-		atomic_inc(&node->refs);	/* can be accessed */
+		atomic_inc(&node->refs);
 		return node;
 	}
 
@@ -103,7 +100,9 @@ again:
 	if (node) {
 		if (btrfs_inode->delayed_node) {
 			spin_unlock(&root->inode_lock);
-			goto again;
+			BUG_ON(btrfs_inode->delayed_node != node);
+			atomic_inc(&node->refs);	/* can be accessed */
+			return node;
 		}
 		btrfs_inode->delayed_node = node;
 		atomic_inc(&node->refs);	/* can be accessed */
@@ -113,6 +112,23 @@ again:
 	}
 	spin_unlock(&root->inode_lock);
 
+	return NULL;
+}
+
+static struct btrfs_delayed_node *btrfs_get_or_create_delayed_node(
+							struct inode *inode)
+{
+	struct btrfs_delayed_node *node;
+	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
+	struct btrfs_root *root = btrfs_inode->root;
+	u64 ino = btrfs_ino(inode);
+	int ret;
+
+again:
+	node = btrfs_get_delayed_node(inode);
+	if (node)
+		return node;
+
 	node = kmem_cache_alloc(delayed_node_cache, GFP_NOFS);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
@@ -548,19 +564,6 @@ struct btrfs_delayed_item *__btrfs_next_delayed_item(
 	return next;
 }
 
-static inline struct btrfs_delayed_node *btrfs_get_delayed_node(
-							struct inode *inode)
-{
-	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
-	struct btrfs_delayed_node *delayed_node;
-
-	delayed_node = btrfs_inode->delayed_node;
-	if (delayed_node)
-		atomic_inc(&delayed_node->refs);
-
-	return delayed_node;
-}
-
 static inline struct btrfs_root *btrfs_get_fs_root(struct btrfs_root *root,
 						   u64 root_id)
 {
@@ -1404,8 +1407,7 @@ end:
 
 int btrfs_inode_delayed_dir_index_count(struct inode *inode)
 {
-	struct btrfs_delayed_node *delayed_node = BTRFS_I(inode)->delayed_node;
-	int ret = 0;
+	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(inode);
 
 	if (!delayed_node)
 		return -ENOENT;
@@ -1415,11 +1417,14 @@ int btrfs_inode_delayed_dir_index_count(struct inode *inode)
 	 * a new directory index is added into the delayed node and index_cnt
 	 * is updated now. So we needn't lock the delayed node.
 	 */
-	if (!delayed_node->index_cnt)
+	if (!delayed_node->index_cnt) {
+		btrfs_release_delayed_node(delayed_node);
 		return -EINVAL;
+	}
 
 	BTRFS_I(inode)->index_cnt = delayed_node->index_cnt;
-	return ret;
+	btrfs_release_delayed_node(delayed_node);
+	return 0;
 }
 
 void btrfs_get_delayed_items(struct inode *inode, struct list_head *ins_list,
@@ -1613,6 +1618,57 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 				      inode->i_ctime.tv_nsec);
 }
 
+int btrfs_fill_inode(struct inode *inode, u32 *rdev)
+{
+	struct btrfs_delayed_node *delayed_node;
+	struct btrfs_inode_item *inode_item;
+	struct btrfs_timespec *tspec;
+
+	delayed_node = btrfs_get_delayed_node(inode);
+	if (!delayed_node)
+		return -ENOENT;
+
+	mutex_lock(&delayed_node->mutex);
+	if (!delayed_node->inode_dirty) {
+		mutex_unlock(&delayed_node->mutex);
+		btrfs_release_delayed_node(delayed_node);
+		return -ENOENT;
+	}
+
+	inode_item = &delayed_node->inode_item;
+
+	inode->i_uid = btrfs_stack_inode_uid(inode_item);
+	inode->i_gid = btrfs_stack_inode_gid(inode_item);
+	btrfs_i_size_write(inode, btrfs_stack_inode_size(inode_item));
+	inode->i_mode = btrfs_stack_inode_mode(inode_item);
+	inode->i_nlink = btrfs_stack_inode_nlink(inode_item);
+	inode_set_bytes(inode, btrfs_stack_inode_nbytes(inode_item));
+	BTRFS_I(inode)->generation = btrfs_stack_inode_generation(inode_item);
+	BTRFS_I(inode)->sequence = btrfs_stack_inode_sequence(inode_item);
+	inode->i_rdev = 0;
+	*rdev = btrfs_stack_inode_rdev(inode_item);
+	BTRFS_I(inode)->flags = btrfs_stack_inode_flags(inode_item);
+
+	tspec = btrfs_inode_atime(inode_item);
+	inode->i_atime.tv_sec = btrfs_stack_timespec_sec(tspec);
+	inode->i_atime.tv_nsec = btrfs_stack_timespec_nsec(tspec);
+
+	tspec = btrfs_inode_mtime(inode_item);
+	inode->i_mtime.tv_sec = btrfs_stack_timespec_sec(tspec);
+	inode->i_mtime.tv_nsec = btrfs_stack_timespec_nsec(tspec);
+
+	tspec = btrfs_inode_ctime(inode_item);
+	inode->i_ctime.tv_sec = btrfs_stack_timespec_sec(tspec);
+	inode->i_ctime.tv_nsec = btrfs_stack_timespec_nsec(tspec);
+
+	inode->i_generation = BTRFS_I(inode)->generation;
+	BTRFS_I(inode)->index_cnt = (u64)-1;
+
+	mutex_unlock(&delayed_node->mutex);
+	btrfs_release_delayed_node(delayed_node);
+	return 0;
+}
+
 int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, struct inode *inode)
 {
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index d1a6a29..8d27af4 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -119,6 +119,7 @@ void btrfs_kill_delayed_inode_items(struct inode *inode);
 
 int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, struct inode *inode);
+int btrfs_fill_inode(struct inode *inode, u32 *rdev);
 
 /* Used for drop dead root */
 void btrfs_kill_all_delayed_nodes(struct btrfs_root *root);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5813dec..1d25a04 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2509,6 +2509,11 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	int maybe_acls;
 	u32 rdev;
 	int ret;
+	bool filled = false;
+
+	ret = btrfs_fill_inode(inode, &rdev);
+	if (!ret)
+		filled = true;
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
@@ -2520,6 +2525,10 @@ static void btrfs_read_locked_inode(struct inode *inode)
 		goto make_bad;
 
 	leaf = path->nodes[0];
+
+	if (filled)
+		goto cache_acl;
+
 	inode_item = btrfs_item_ptr(leaf, path->slots[0],
 				    struct btrfs_inode_item);
 	if (!leaf->map_token)
@@ -2556,7 +2565,7 @@ static void btrfs_read_locked_inode(struct inode *inode)
 
 	BTRFS_I(inode)->index_cnt = (u64)-1;
 	BTRFS_I(inode)->flags = btrfs_inode_flags(leaf, inode_item);
-
+cache_acl:
 	/*
 	 * try to precache a NULL acl entry for files that don't have
 	 * any xattrs or acls
@@ -2572,7 +2581,6 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	}
 
 	btrfs_free_path(path);
-	inode_item = NULL;
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
-- 
1.7.4
