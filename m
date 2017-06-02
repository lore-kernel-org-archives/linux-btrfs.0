Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.univention.de ([82.198.197.8]:32364 "EHLO
        mail.univention.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751391AbdFBKIp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jun 2017 06:08:45 -0400
From: Philipp Hahn <hahn@univention.de>
To: linux-btrfs@vger.kernel.org
Cc: Philipp Hahn <hahn@univention.de>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/2] btrfs-progs: Check nritems under-/overflow
Date: Fri,  2 Jun 2017 12:08:14 +0200
Message-Id: <3354a7145d7f33ee34f41f1422c03093bf35c644.1496397503.git.hahn@univention.de>
In-Reply-To: <cover.1496397503.git.hahn@univention.de>
References: <cover.1496397503.git.hahn@univention.de>
In-Reply-To: <cover.1496397503.git.hahn@univention.de>
References: <20170529181900.GV14523@twin.jikos.cz> <cover.1496397503.git.hahn@univention.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

711a0b48683b71d61caffbd67a90ec8db5412675 is incomplete and missed some
cases, where 'nritems' is outside its valid range, e.g.
- insert_ptr(): inserting into an already full node
- copy_for_split(): splitting more items than contained
- btrfs_del_ptr(): deleting one item from an already empty node (*)
- btrfs_del_items(): deleting more items than contained.

Use BUG_ON() checks to get more useful error messages in case those
cases happen.

(Here is the debug data from my corrupted file system triggering *:)
> (gdb) bt
> #3  btrfs_del_ptr (root=root@entry=0x6fcfa0, path=path@entry=0x7fffffffd7d0, level=level@entry=0, slot=<optimized out>) at ctree.c:2607
> #4  0x00000000004516a1 in repair_btree (corrupt_blocks=0x7fffffffd970, root=0x6fcfa0) at cmds-check.c:3847
> #5  check_fs_root (root=root@entry=0x6fcfa0, root_cache=root_cache@entry=0x7fffffffde60, wc=wc@entry=0x7fffffffdbb0) at cmds-check.c:4009
> #6  0x000000000045da04 in check_fs_roots (root_cache=0x7fffffffde60, root=0x6e2770) at cmds-check.c:4115
> #7  cmd_check (argc=<optimized out>, argv=<optimized out>) at cmds-check.c:13079
> #8  0x000000000040aae9 in main (argc=4, argv=0x7fffffffdfa8) at btrfs.c:302

> (gdb) frame 4
> #4  0x00000000004516a1 in repair_btree (corrupt_blocks=0x7fffffffd970, root=0x6fcfa0) at cmds-check.c:3847
> 3847                    ret = btrfs_del_ptr(root, &path, level, path.slots[level]);

> (gdb) info locals
> corrupt = 0x52b2dd0
> key = {objectid = 78229979136, type = 168 '\250', offset = 16384}
> ret = <optimized out>
> trans = 0x8f0ac0
> path = {nodes = {0xd8ac7d0, 0xd8ccc50, 0x6bf010, 0x0, 0x0, 0x0, 0x0, 0x0}, slots = {0, 417, 232, 0, 0, 0, 0, 0}, reada = 0 '\000', lowest_level = 0 '\000', search_for_split = 0 '\000', skip_check_block = 0 '\000'}
> cache = 0x52b2dd0
> level = 0

Signed-off-by: Philipp Hahn <hahn@univention.de>
---
 ctree.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/ctree.c b/ctree.c
index 201f671..c5af7f6 100644
--- a/ctree.c
+++ b/ctree.c
@@ -1485,8 +1485,7 @@ static int insert_ptr(struct btrfs_trans_handle *trans, struct btrfs_root
 	nritems = btrfs_header_nritems(lower);
 	if (slot > nritems)
 		BUG();
-	if (nritems == BTRFS_NODEPTRS_PER_BLOCK(root))
-		BUG();
+	BUG_ON(nritems >= BTRFS_NODEPTRS_PER_BLOCK(root));
 	if (slot < nritems) {
 		/* shift the items */
 		memmove_extent_buffer(lower,
@@ -1967,7 +1966,8 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
 	int wret;
 	struct btrfs_disk_key disk_key;
 
-	nritems = nritems - mid;
+	BUG_ON(mid > nritems);
+	nritems -= mid;
 	btrfs_set_header_nritems(right, nritems);
 	data_copy_size = btrfs_item_end_nr(l, mid) - leaf_data_end(root, l);
 
@@ -2604,6 +2604,7 @@ int btrfs_del_ptr(struct btrfs_root *root, struct btrfs_path *path,
 	int ret = 0;
 
 	nritems = btrfs_header_nritems(parent);
+	BUG_ON(nritems == 0);
 	if (slot < nritems -1) {
 		/* shift the items */
 		memmove_extent_buffer(parent,
@@ -2678,7 +2679,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		dsize += btrfs_item_size_nr(leaf, slot + i);
 
 	nritems = btrfs_header_nritems(leaf);
-
+	BUG_ON(nritems < nr);
 	if (slot + nr < nritems) {
 		int data_end = leaf_data_end(root, leaf);
 
-- 
2.11.0

