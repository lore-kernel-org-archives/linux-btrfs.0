Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42718 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752897AbcIHHNT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 03:13:19 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 5C7BA4026B52
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Sep 2016 15:13:08 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v13 12/15] btrfs: relocation: Enhance error handling to avoid BUG_ON
Date: Thu,  8 Sep 2016 15:13:01 +0800
Message-Id: <20160908071304.25616-13-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160908071304.25616-1-quwenruo@cn.fujitsu.com>
References: <20160908071304.25616-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since the introduce of btrfs dedupe tree, it's possible that balance can
race with dedupe disabling.

When this happens, dedupe_enabled will make btrfs_get_fs_root() return
PTR_ERR(-ENOENT).
But due to a bug in error handling branch, when this happens
backref_cache->nr_nodes is increased but the node is neither added to
backref_cache or nr_nodes decreased.
Causing BUG_ON() in backref_cache_cleanup()

[ 2611.668810] ------------[ cut here ]------------
[ 2611.669946] kernel BUG at
/home/sat/ktest/linux/fs/btrfs/relocation.c:243!
[ 2611.670572] invalid opcode: 0000 [#1] SMP
[ 2611.686797] Call Trace:
[ 2611.687034]  [<ffffffffa01f71d3>]
btrfs_relocate_block_group+0x1b3/0x290 [btrfs]
[ 2611.687706]  [<ffffffffa01cc177>]
btrfs_relocate_chunk.isra.40+0x47/0xd0 [btrfs]
[ 2611.688385]  [<ffffffffa01cdb12>] btrfs_balance+0xb22/0x11e0 [btrfs]
[ 2611.688966]  [<ffffffffa01d9611>] btrfs_ioctl_balance+0x391/0x3a0
[btrfs]
[ 2611.689587]  [<ffffffffa01ddaf0>] btrfs_ioctl+0x1650/0x2290 [btrfs]
[ 2611.690145]  [<ffffffff81171cda>] ? lru_cache_add+0x3a/0x80
[ 2611.690647]  [<ffffffff81171e4c>] ?
lru_cache_add_active_or_unevictable+0x4c/0xc0
[ 2611.691310]  [<ffffffff81193f04>] ? handle_mm_fault+0xcd4/0x17f0
[ 2611.691842]  [<ffffffff811da423>] ? cp_new_stat+0x153/0x180
[ 2611.692342]  [<ffffffff8119913d>] ? __vma_link_rb+0xfd/0x110
[ 2611.692842]  [<ffffffff81199209>] ? vma_link+0xb9/0xc0
[ 2611.693303]  [<ffffffff811e7e81>] do_vfs_ioctl+0xa1/0x5a0
[ 2611.693781]  [<ffffffff8104e024>] ? __do_page_fault+0x1b4/0x400
[ 2611.694310]  [<ffffffff811e83c1>] SyS_ioctl+0x41/0x70
[ 2611.694758]  [<ffffffff816dfc6e>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 2611.695331] Code: ff 48 8b 45 bf 49 83 af a8 05 00 00 01 49 89 87 a0
05 00 00 e9 2e fd ff ff b8 f4 ff ff ff e9 e4 fb ff ff 0f 0b 0f 0b 0f 0b
0f 0b <0f> 0b 0f 0b 41 89 c6 e9 b8 fb ff ff e8 9e a6 e8 e0 4c 89 e7 44
[ 2611.697870] RIP  [<ffffffffa01f6fc1>]
relocate_block_group+0x741/0x7a0 [btrfs]
[ 2611.698818]  RSP <ffff88002a81fb30>

This patch will call remove_backref_node() in error handling branch, and
cache the returned -ENOENT in relocate_tree_block() and continue
balancing.

Reported-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 6e8086a..6ae287f 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -888,6 +888,13 @@ again:
 		root = read_fs_root(rc->extent_root->fs_info, key.offset);
 		if (IS_ERR(root)) {
 			err = PTR_ERR(root);
+			/*
+			 * Don't forget to cleanup current node.
+			 * As it may not be added to backref_cache but nr_node
+			 * increased.
+			 * This will cause BUG_ON() in backref_cache_cleanup().
+			 */
+			remove_backref_node(&rc->backref_cache, cur);
 			goto out;
 		}
 
@@ -2999,14 +3006,21 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 	}
 
 	rb_node = rb_first(blocks);
-	while (rb_node) {
+	for (rb_node = rb_first(blocks); rb_node; rb_node = rb_next(rb_node)) {
 		block = rb_entry(rb_node, struct tree_block, rb_node);
 
 		node = build_backref_tree(rc, &block->key,
 					  block->level, block->bytenr);
 		if (IS_ERR(node)) {
+			/*
+			 * The root(dedupe tree yet) of the tree block is
+			 * going to be freed and can't be reached.
+			 * Just skip it and continue balancing.
+			 */
+			if (PTR_ERR(node) == -ENOENT)
+				continue;
 			err = PTR_ERR(node);
-			goto out;
+			break;
 		}
 
 		ret = relocate_tree_block(trans, rc, node, &block->key,
@@ -3014,11 +3028,9 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 		if (ret < 0) {
 			if (ret != -EAGAIN || rb_node == rb_first(blocks))
 				err = ret;
-			goto out;
+			break;
 		}
-		rb_node = rb_next(rb_node);
 	}
-out:
 	err = finish_pending_nodes(trans, rc, path, err);
 
 out_free_path:
-- 
2.9.3



