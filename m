Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35146 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab3HSSJC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Aug 2013 14:09:02 -0400
Received: by mail-wg0-f50.google.com with SMTP id m15so3833353wgh.29
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Aug 2013 11:09:01 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [RFC PATCH] Btrfs: fix memory leak of orphan block rsv
Date: Mon, 19 Aug 2013 19:08:45 +0100
Message-Id: <1376935725-27427-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When adding orphans to an inode's root, we start a transaction for
that root that when ended in several places such as for example
extent-tree.c:btrfs_remove_block_group(), inode.c:btrfs_unlink() and
inode.c:btrfs_evict_node(), doesn't result in a commit, that is,
inode.c:btrfs_orphan_commit_root() doesn't get called (via
transaction.c:commit_fs_roots()).

The respective inode will end up being called by inode.c:btrfs_evict_node()
(via the VFS). So my likely dirty hack, after some debugging, of
freeing the orphan block rsv in btrfs_evict_inode() if its not being
used by other tasks, seems to fix the leak without failing xfstests
so far. But this is unlikely to be a correct solution without causing
issues elsewhere.

This commit also changes calls to btrfs_orphan_del() which grabbed the
root's orphan_block_rsv without acquiring the orphan_lock first (confront
with btrfs_orphan_commit_root(), which acquires the lock before getting
and setting the root's orphan_block_rsv).

This issue is simple to reproduce and observe if kmemleak is enabled.
Two simple ways to reproduce it:

** 1

$ mkfs.btrfs -f /dev/loop0
$ mount /dev/loop0 /mnt/btrfs
$ btrfs balance start /mnt/btrfs
$ umount /mnt/btrfs

** 2

$ mkfs.btrfs -f /dev/loop0
$ mount /dev/loop0 /mnt/btrfs
$ touch /mnt/btrfs/foobar
$ rm -f /mnt/btrfs/foobar
$ umount /mnt/btrfs

After a while, kmemleak reports the leak:

$ cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff880402b13e00 (size 128):
  comm "btrfs", pid 19621, jiffies 4341648183 (age 70057.844s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 fc c6 b1 04 88 ff ff 04 00 04 00 ad 4e ad de  .............N..
  backtrace:
    [<ffffffff817275a6>] kmemleak_alloc+0x26/0x50
    [<ffffffff8117832b>] kmem_cache_alloc_trace+0xeb/0x1d0
    [<ffffffffa04db499>] btrfs_alloc_block_rsv+0x39/0x70 [btrfs]
    [<ffffffffa04f8bad>] btrfs_orphan_add+0x13d/0x1b0 [btrfs]
    [<ffffffffa04e2b13>] btrfs_remove_block_group+0x143/0x500 [btrfs]
    [<ffffffffa0518158>] btrfs_relocate_chunk.isra.63+0x618/0x790 [btrfs]
    [<ffffffffa051bc27>] btrfs_balance+0x8f7/0xe90 [btrfs]
    [<ffffffffa05240a0>] btrfs_ioctl_balance+0x250/0x550 [btrfs]
    [<ffffffffa05269ca>] btrfs_ioctl+0xdfa/0x25f0 [btrfs]
    [<ffffffff8119c936>] do_vfs_ioctl+0x96/0x570
    [<ffffffff8119cea1>] SyS_ioctl+0x91/0xb0
    [<ffffffff81750242>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

This affects btrfs-next, revision be8e3cd00d7293dd177e3f8a4a1645ce09ca3acb
(Btrfs: separate out tests into their own directory).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ctree.h       |    1 +
 fs/btrfs/extent-tree.c |    1 +
 fs/btrfs/inode.c       |   36 +++++++++++++++++++++++++++++-------
 3 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7c93d9f..da3ac13 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1153,6 +1153,7 @@ struct btrfs_block_rsv {
 	u64 reserved;
 	struct btrfs_space_info *space_info;
 	spinlock_t lock;
+	atomic_t count;
 	unsigned short full;
 	unsigned short type;
 	unsigned short failfast;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 32639f2..3ecee8e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4500,6 +4500,7 @@ struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root,
 	btrfs_init_block_rsv(block_rsv, type);
 	block_rsv->space_info = __find_space_info(fs_info,
 						  BTRFS_BLOCK_GROUP_METADATA);
+	atomic_set(&block_rsv->count, 0);
 	return block_rsv;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b67b81a..459ffe2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2870,8 +2870,13 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 		return;
 	}
 
-	block_rsv = root->orphan_block_rsv;
-	root->orphan_block_rsv = NULL;
+	if (root->orphan_block_rsv &&
+	    atomic_dec_and_test(&root->orphan_block_rsv->count)) {
+		block_rsv = root->orphan_block_rsv;
+		root->orphan_block_rsv = NULL;
+	} else {
+		block_rsv = NULL;
+	}
 	spin_unlock(&root->orphan_lock);
 
 	if (root->orphan_item_inserted &&
@@ -2918,6 +2923,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 		btrfs_free_block_rsv(root, block_rsv);
 		block_rsv = NULL;
 	}
+	atomic_inc(&root->orphan_block_rsv->count);
 
 	if (!test_and_set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 			      &BTRFS_I(inode)->runtime_flags)) {
@@ -2991,6 +2997,9 @@ static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
 	int ret = 0;
 
 	spin_lock(&root->orphan_lock);
+	if (trans)
+		trans->block_rsv = root->orphan_block_rsv;
+
 	if (test_and_clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 			       &BTRFS_I(inode)->runtime_flags))
 		delete_item = 1;
@@ -4520,12 +4529,10 @@ void btrfs_evict_inode(struct inode *inode)
 	 * Errors here aren't a big deal, it just means we leave orphan items
 	 * in the tree.  They will be cleaned up on the next mount.
 	 */
-	if (ret == 0) {
-		trans->block_rsv = root->orphan_block_rsv;
+	if (ret == 0)
 		btrfs_orphan_del(trans, inode);
-	} else {
+	else
 		btrfs_orphan_del(NULL, inode);
-	}
 
 	trans->block_rsv = &root->fs_info->trans_block_rsv;
 	if (!(root == root->fs_info->tree_root ||
@@ -4535,6 +4542,22 @@ void btrfs_evict_inode(struct inode *inode)
 	btrfs_end_transaction(trans, root);
 	btrfs_btree_balance_dirty(root);
 no_delete:
+
+	spin_lock(&root->orphan_lock);
+	if (root->orphan_block_rsv &&
+	    atomic_dec_and_test(&root->orphan_block_rsv->count)) {
+		rsv = root->orphan_block_rsv;
+		root->orphan_block_rsv = NULL;
+	} else {
+		rsv = NULL;
+	}
+	spin_unlock(&root->orphan_lock);
+
+	if (rsv) {
+		WARN_ON(rsv->size > 0);
+		btrfs_free_block_rsv(root, rsv);
+	}
+
 	btrfs_remove_delayed_node(inode);
 	clear_inode(inode);
 	return;
@@ -7650,7 +7673,6 @@ static int btrfs_truncate(struct inode *inode)
 	}
 
 	if (ret == 0 && inode->i_nlink > 0) {
-		trans->block_rsv = root->orphan_block_rsv;
 		ret = btrfs_orphan_del(trans, inode);
 		if (ret)
 			err = ret;
-- 
1.7.9.5

