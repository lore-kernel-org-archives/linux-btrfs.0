From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH V4] btrfs: implement delayed inode items operation
Date: Sun, 20 Mar 2011 20:33:34 -0400
Message-ID: <1300666966-sup-3510@think>
References: <4D8324DE.4010400@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	David Sterba <dave@jikos.cz>, Ito <t-itoh@jp.fujitsu.com>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D8324DE.4010400@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Miao Xie's message of 2011-03-18 05:24:46 -0400:
> Changelog V3 -> V4:
> - Fix nested lock, which is reported by Itaru Kitayama, by updating space cache
>   inodes in time.

I ran some tests on this and had trouble with my stress.sh script:

http://oss.oracle.com/~mason/stress.sh

I used:

stress.sh -n 50 -c <path to linux kernel git tree> /mnt

The git tree has all the .git files but no .o files.

The problem was that within about 20 minutes, the filesystem was
spending almost all of its time in balance_dirty_pages().  The problem
is that data writeback isn't complete until the endio handlers have
finished inserting metadata into the btree.

The v4 patch calls btrfs_btree_balance_dirty() from all the
btrfs_end_transaction variants, which means that the FS writeback code
waits for balance_dirty_pages(), which won't make progress until the FS
writeback code is done.

So I changed things to call the delayed inode balance function only from
inside btrfs_btree_balance_dirty(), which did resolve the stalls.  But
I found a few times that when I did rmmod btrfs, there would be delayed
inode objects leaked in the slab cache.  rmmod will try to destroy the
slab cache, which will fail because we haven't freed everything.

It looks like we have a race in btrfs_get_or_create_delayed_node, where
two concurrent callers can both create delayed nodes and then race on
adding it to the inode.

I also think that code is racing with the code that frees delayed nodes,
but haven't yet triggered my debugging printks to prove either one.

My current incremental patch is below, please take a look:

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 727d9a8..02e9390 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -32,7 +32,8 @@ int __init btrfs_delayed_inode_init(void)
 	delayed_node_cache = kmem_cache_create("delayed_node",
 					sizeof(struct btrfs_delayed_node),
 					0,
-					SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+					SLAB_RECLAIM_ACCOUNT |
+					SLAB_MEM_SPREAD | SLAB_DESTROY_BY_RCU,
 					NULL);
 	if (!delayed_node_cache)
 		return -ENOMEM;
@@ -90,22 +91,35 @@ static struct btrfs_delayed_node *btrfs_get_or_create_delayed_node(
 	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
 	struct btrfs_root *root = btrfs_inode->root;
 
-	if (btrfs_inode->delayed_node) {
-		node = btrfs_inode->delayed_node;
-		atomic_inc(&node->refs);	/* can be accessed */
-		return node;
+again:
+	rcu_read_lock();
+again_rcu:
+	node = btrfs_inode->delayed_node;
+	if (node) {
+		if (atomic_inc_not_zero(&node->refs)) {
+			rcu_read_unlock();
+			return node;
+		}
+printk("racing on node access!\n");
+		goto again_rcu;
 	}
+	rcu_read_unlock();
 
 	node = kmem_cache_alloc(delayed_node_cache, GFP_NOFS);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
 	btrfs_init_delayed_node(node, root->objectid, inode->i_ino);
 
-	btrfs_inode->delayed_node = node;
 	node->delayed_root = btrfs_get_delayed_root(root);
 	atomic_inc(&node->refs);	/* cached in the btrfs inode */
 	atomic_inc(&node->refs);	/* can be accessed */
 
+	if (cmpxchg(&BTRFS_I(inode)->delayed_node, NULL, node)) {
+		kmem_cache_free(delayed_node_cache, node);
+printk("racing on new node insertion!\n");
+		goto again;
+	}
+
 	return node;
 }
 
@@ -1167,7 +1181,7 @@ static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
 	nr = trans->blocks_used;
 
 	btrfs_end_transaction_dmeta(trans, root);
-	btrfs_btree_balance_dirty(root, nr);
+	__btrfs_btree_balance_dirty(root, nr);
 free_path:
 	btrfs_free_path(path);
 out:
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0f589b1..0c6c336 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2649,6 +2649,28 @@ void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr)
 		balance_dirty_pages_ratelimited_nr(
 				   root->fs_info->btree_inode->i_mapping, 1);
 	}
+	btrfs_balance_delayed_items(root);
+	return;
+}
+
+void __btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr)
+{
+	/*
+	 * looks as though older kernels can get into trouble with
+	 * this code, they end up stuck in balance_dirty_pages forever
+	 */
+	u64 num_dirty;
+	unsigned long thresh = 32 * 1024 * 1024;
+
+	if (current->flags & PF_MEMALLOC)
+		return;
+
+	num_dirty = root->fs_info->dirty_metadata_bytes;
+
+	if (num_dirty > thresh) {
+		balance_dirty_pages_ratelimited_nr(
+				   root->fs_info->btree_inode->i_mapping, 1);
+	}
 	return;
 }
 
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 07b20dc..aca35af 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -71,6 +71,7 @@ int btrfs_insert_dev_radix(struct btrfs_root *root,
 			   u64 block_start,
 			   u64 num_blocks);
 void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr);
+void __btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr);
 int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root);
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 void btrfs_mark_buffer_dirty_nonblocking(struct extent_buffer *buf);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6b238b2..ef240d8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4449,6 +4449,8 @@ void btrfs_dirty_inode(struct inode *inode)
 		}
 	}
 	btrfs_end_transaction(trans, root);
+	if (BTRFS_I(inode)->delayed_node)
+		btrfs_balance_delayed_items(root);
 }
 
 /*
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 31b328b..8f0ca33 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -483,8 +483,6 @@ int btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	ret = __btrfs_end_transaction(trans, root, 0, 1);
 	if (ret)
 		return ret;
-
-	btrfs_balance_delayed_items(root);
 	return 0;
 }
 
@@ -496,8 +494,6 @@ int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans,
 	ret = __btrfs_end_transaction(trans, root, 1, 1);
 	if (ret)
 		return ret;
-
-	btrfs_balance_delayed_items(root);
 	return 0;
 }
 
@@ -509,8 +505,6 @@ int btrfs_end_transaction_nolock(struct btrfs_trans_handle *trans,
 	ret = __btrfs_end_transaction(trans, root, 0, 0);
 	if (ret)
 		return ret;
-
-	btrfs_balance_delayed_items(root);
 	return 0;
 }
 
