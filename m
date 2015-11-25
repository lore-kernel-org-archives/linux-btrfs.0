Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49203 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbbKYW7k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 17:59:40 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tAPMxdb9000599
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2015 22:59:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id tAPMxd1j027047
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2015 22:59:39 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id tAPMxdoA023006
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2015 22:59:39 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] Btrfs: improve performance on dbench
Date: Wed, 25 Nov 2015 14:59:07 -0800
Message-Id: <1448492347-6103-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kent Overstreet posted some dbench test numbers in the announcement of
bcachefs[1], in which btrfs's performance is much worse than that of
ext4 and xfs, especially in the case of multiple threads.

This difference can be observed on fast storage, I ran 'dbench -t10 64'
with 1.6T NVMe disk,
Processor: Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz
Memory:    504G

I took time to dig it a bit, perf shows that in the case of multiple
threads we spend most of cpu cycles on spin_lock_irqsave() and
spin_unlock_irqrestore() pair, which is called by wait_event() in btree
locking.

72.84%    72.84%  dbench           [kernel.vmlinux]            [k] native_queued_spin_lock_slowpath
	     |
	     ---native_queued_spin_lock_slowpath
		|
		|--71.64%-- _raw_spin_lock_irqsave
		|          |
		|          |--52.17%-- prepare_to_wait_event
		|          |          |
		|          |          |--94.33%-- btrfs_tree_lock
		|          |          |          |
		|          |          |          |--99.10%-- btrfs_lock_root_node
		|          |          |          |          btrfs_search_slot
		|          |          |          |          |
		|          |          |          |          |--26.44%-- btrfs_lookup_dir_item
		|          |          |          |          |          |
		|          |          |          |          |          |--99.31%-- __btrfs_unlink_inode

Having serious contention on btree lock can also be proved by another fact,
that is, if you use subvolume instead of directory for each dbench client,
the test number in the case of multiple threads will be considerably nice,
for 64 clients,

Throughput 5904.71 MB/sec  64 clients  64 procs  max_latency=816.715 ms

I did a few things to avoid waiting for blocking writers and readers:

1) Use path->leave_spinning=1 as much as possible, this leaves us holding
   spinning lock after searching btree.

2) Find out the cases that we don't have to take blocking lock, for example,
   we don't need blocking lock when parent node has more than 1/4 items it
   can hold.

3) Avoid unnecessary "goto again", eg. on btree root level,
   just update write_lock_level if we already hold BTRFS_WRITE_LOCK.

4) Remove btrfs_set_path_blocking() in btrfs_clear_path_blocking(), this
   contributes to a large part of improved numbers, this function is
   introduced to avoid lockdep warning, but after I turned lockdep on,
   xfstests didn't report about such a warning.

5) Make btrfs_search_forward to use non-sleepable function to find eb, this
   fixes a deadlock with previous changes.

Here is the end results for 64 clients, with vanilla 4.2, btrfs runs 15x faster
but with higher latency.

                   tput(MB/sec)         max_latency(ms)
xfs                 2742.93                21.855
ext4                7182.92                19.053
btrfs+subvol w/o    5904.71               816.715
btrfs+dir w/o        122.778              718.674
*btrfs+dir w        1715.77              1366.981

I've marked it as RFC since I'm not confident on the lockdep part.

Any comments are welcome!

[1]: https://lkml.org/lkml/2015/8/21/22

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.c     | 79 +++++++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/dir-item.c  |  1 +
 fs/btrfs/file-item.c |  3 +-
 fs/btrfs/file.c      |  7 ++++-
 fs/btrfs/inode-map.c |  2 ++
 fs/btrfs/inode.c     |  3 ++
 fs/btrfs/orphan.c    |  2 ++
 fs/btrfs/root-tree.c |  1 +
 fs/btrfs/xattr.c     |  2 ++
 9 files changed, 84 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5b8e235..a27dbae 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -87,7 +87,6 @@ noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
 		else if (held_rw == BTRFS_READ_LOCK)
 			held_rw = BTRFS_READ_LOCK_BLOCKING;
 	}
-	btrfs_set_path_blocking(p);
 
 	for (i = BTRFS_MAX_LEVEL - 1; i >= 0; i--) {
 		if (p->nodes[i] && p->locks[i]) {
@@ -2536,8 +2535,16 @@ setup_nodes_for_search(struct btrfs_trans_handle *trans,
 
 		if (*write_lock_level < level + 1) {
 			*write_lock_level = level + 1;
-			btrfs_release_path(p);
-			goto again;
+
+			ASSERT(p->locks[level] == BTRFS_WRITE_LOCK ||
+			       p->locks[level] == BTRFS_READ_LOCK);
+
+			/* if it's not root node or the lock is not WRTIE_LOCK */
+			if ((level < BTRFS_MAX_LEVEL - 1 && p->nodes[level + 1]) ||
+			    p->locks[level] != BTRFS_WRITE_LOCK) {
+				btrfs_release_path(p);
+				goto again;
+			}
 		}
 
 		btrfs_set_path_blocking(p);
@@ -2555,10 +2562,32 @@ setup_nodes_for_search(struct btrfs_trans_handle *trans,
 		   BTRFS_NODEPTRS_PER_BLOCK(root) / 2) {
 		int sret;
 
+		if (btrfs_header_nritems(b) > BTRFS_NODEPTRS_PER_BLOCK(root) / 4) {
+			ret = 0;
+			goto done;
+		}
+
+		/*
+		 * If this is a root node with more than 1 items, then don't
+		 * balance at all since it's totally unnecessay.
+		 */
+		if (level < BTRFS_MAX_LEVEL - 1 && !p->nodes[level + 1] &&
+		    btrfs_header_nritems(b) != 1) {
+			ret = 0;
+			goto done;
+		}
+
 		if (*write_lock_level < level + 1) {
 			*write_lock_level = level + 1;
-			btrfs_release_path(p);
-			goto again;
+			ASSERT(p->locks[level] == BTRFS_WRITE_LOCK ||
+			       p->locks[level] == BTRFS_READ_LOCK);
+
+			/* if it's not root node or the lock is not WRTIE_LOCK */
+			if ((level < BTRFS_MAX_LEVEL - 1 && p->nodes[level + 1]) ||
+			    p->locks[level] != BTRFS_WRITE_LOCK) {
+				btrfs_release_path(p);
+				goto again;
+			}
 		}
 
 		btrfs_set_path_blocking(p);
@@ -2851,8 +2880,15 @@ cow_done:
 			if (slot == 0 && ins_len &&
 			    write_lock_level < level + 1) {
 				write_lock_level = level + 1;
-				btrfs_release_path(p);
-				goto again;
+				ASSERT(p->locks[level] == BTRFS_WRITE_LOCK ||
+				       p->locks[level] == BTRFS_READ_LOCK);
+
+				/* if it's not root node or the lock is not WRTIE_LOCK */
+				if ((level < BTRFS_MAX_LEVEL - 1 && p->nodes[level + 1]) ||
+				    p->locks[level] != BTRFS_WRITE_LOCK) {
+					btrfs_release_path(p);
+					goto again;
+				}
 			}
 
 			unlock_up(p, level, lowest_unlock,
@@ -5130,6 +5166,8 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 	int level;
 	int ret = 1;
 	int keep_locks = path->keep_locks;
+	u64 blocknr;
+	u64 blockgen;
 
 	path->keep_locks = 1;
 again:
@@ -5197,16 +5235,31 @@ find_next_key:
 			ret = 0;
 			goto out;
 		}
-		btrfs_set_path_blocking(path);
-		cur = read_node_slot(root, cur, slot);
-		BUG_ON(!cur); /* -ENOMEM */
 
-		btrfs_tree_read_lock(cur);
+		unlock_up(path, level, 1, 0, NULL);
+
+		blocknr = btrfs_node_blockptr(cur, slot);
+		blockgen = btrfs_node_ptr_generation(cur, slot);
+		cur = btrfs_find_tree_block(root->fs_info, blocknr);
+		if (cur && btrfs_buffer_uptodate(cur, blockgen, 1) > 0) {
+			int tmp;
+			tmp = btrfs_tree_read_lock_atomic(cur);
+			if (!tmp) {
+				btrfs_set_path_blocking(path);
+				btrfs_tree_read_lock(cur);
+				btrfs_clear_path_blocking(path, cur, BTRFS_READ_LOCK);
+			}
+		} else {
+			btrfs_set_path_blocking(path);
+			cur = read_node_slot(root, cur, slot);
+			BUG_ON(!cur); /* -ENOMEM */
+
+			btrfs_tree_read_lock(cur);
+			btrfs_clear_path_blocking(path, cur, BTRFS_READ_LOCK);
+		}
 
 		path->locks[level - 1] = BTRFS_READ_LOCK;
 		path->nodes[level - 1] = cur;
-		unlock_up(path, level, 1, 0, NULL);
-		btrfs_clear_path_blocking(path, NULL, 0);
 	}
 out:
 	path->keep_locks = keep_locks;
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 1752625..b9ff277 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -228,6 +228,7 @@ int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
+	path->leave_spinning = 1;
 
 	key.objectid = dir;
 	key.type = BTRFS_DIR_ITEM_KEY;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 58ece65..3877cd8 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -704,6 +704,7 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
+	path->leave_spinning = 1;
 again:
 	next_offset = (u64)-1;
 	found_next = 0;
@@ -834,10 +835,8 @@ insert:
 	} else {
 		ins_size = csum_size;
 	}
-	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, root, path, &file_key,
 				      ins_size);
-	path->leave_spinning = 0;
 	if (ret < 0)
 		goto fail_unlock;
 	if (WARN_ON(ret != 0))
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 977e715..3669f61 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -715,12 +715,15 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	int update_refs;
 	int found = 0;
 	int leafs_visited = 0;
+	int old_spinning = path->leave_spinning;
 
 	if (drop_cache)
 		btrfs_drop_extent_cache(inode, start, end - 1, 0);
 
-	if (start >= BTRFS_I(inode)->disk_i_size && !replace_extent)
+	if (start >= BTRFS_I(inode)->disk_i_size && !replace_extent) {
 		modify_tree = 0;
+		path->leave_spinning = 1;
+	}
 
 	update_refs = (test_bit(BTRFS_ROOT_REF_COWS, &root->state) ||
 		       root == root->fs_info->tree_root);
@@ -809,6 +812,7 @@ next_slot:
 		search_start = max(key.offset, start);
 		if (recow || !modify_tree) {
 			modify_tree = -1;
+			path->leave_spinning = 0;
 			btrfs_release_path(path);
 			continue;
 		}
@@ -1011,6 +1015,7 @@ delete_extent_item:
 		btrfs_release_path(path);
 	if (drop_end)
 		*drop_end = found ? min(end, extent_end) : end;
+	path->leave_spinning = old_spinning;
 	return ret;
 }
 
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 767a605..f4c414a 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -528,6 +528,8 @@ static int btrfs_find_highest_objectid(struct btrfs_root *root, u64 *objectid)
 	if (!path)
 		return -ENOMEM;
 
+	path->leave_spinning = 1;
+
 	search_key.objectid = BTRFS_LAST_FREE_OBJECTID;
 	search_key.type = -1;
 	search_key.offset = (u64)-1;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 994490d..f0ba959 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5347,6 +5347,7 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 	if (!path)
 		return -ENOMEM;
 
+	path->leave_spinning = 1;
 	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(dir), name,
 				    namelen, 0);
 	if (IS_ERR(di))
@@ -6027,6 +6028,8 @@ static int btrfs_set_inode_index_count(struct inode *inode)
 	if (!path)
 		return -ENOMEM;
 
+	path->leave_spinning = 1;
+
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
diff --git a/fs/btrfs/orphan.c b/fs/btrfs/orphan.c
index 47767d5..9e0046f 100644
--- a/fs/btrfs/orphan.c
+++ b/fs/btrfs/orphan.c
@@ -33,6 +33,7 @@ int btrfs_insert_orphan_item(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
+	path->leave_spinning = 1;
 
 	ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
 
@@ -54,6 +55,7 @@ int btrfs_del_orphan_item(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
+	path->leave_spinning = 1;
 
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 	if (ret < 0)
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 7cf8509..2d40568 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -147,6 +147,7 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
+	path->leave_spinning = 1;
 
 	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
 	if (ret < 0) {
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 1fcd7b6..ba387b0 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -46,6 +46,7 @@ ssize_t __btrfs_getxattr(struct inode *inode, const char *name,
 	if (!path)
 		return -ENOMEM;
 
+	path->leave_spinning = 1;
 	/* lookup the xattr by name */
 	di = btrfs_lookup_xattr(NULL, root, path, btrfs_ino(inode), name,
 				strlen(name), 0);
@@ -105,6 +106,7 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 	path->skip_release_on_error = 1;
+	path->leave_spinning = 1;
 
 	if (!value) {
 		di = btrfs_lookup_xattr(trans, root, path, btrfs_ino(inode),
-- 
2.5.0

