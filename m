Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.univention.de ([82.198.197.8]:3363 "EHLO
        mail.univention.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752863AbdEORAa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 13:00:30 -0400
From: Philipp Hahn <hahn@univention.de>
To: linux-btrfs@vger.kernel.org
Cc: Philipp Hahn <hahn@univention.de>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCHv2] btrfs-progs: Fix slot >= nritems
Date: Mon, 15 May 2017 19:00:23 +0200
Message-Id: <946106b46c17df4ea274b1d93832a8084ce2c290.1494867576.git.hahn@univention.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Running "btrfsck --repair /dev/sdd2" crashed as it can happen in
(corrupted) file systems, that slot > nritems:
> (gdb) bt full
> #0  0x00007ffff7020e71 in __memmove_sse2_unaligned_erms () from /lib/x86_64-linux-gnu/libc.so.6
> #1  0x0000000000438764 in btrfs_del_ptr (trans=<optimized out>, root=0x6e4fe0, path=0x1d17880, level=0, slot=7)
>     at ctree.c:2611
>         parent = 0xcd96980
>         nritems = <optimized out>
>         __func__ = "btrfs_del_ptr"
> #2  0x0000000000421b15 in repair_btree (corrupt_blocks=<optimized out>, root=<optimized out>) at cmds-check.c:3539
>         key = {objectid = 77990592512, type = 168 '\250', offset = 16384}
>         trans = 0x8f48c0
>         path = 0x1d17880
>         level = 0
> #3  check_fs_root (wc=<optimized out>, root_cache=<optimized out>, root=<optimized out>) at cmds-check.c:3703
>         corrupt = 0x1d17880
>         corrupt_blocks = {root = {rb_node = 0x6e80c60}}
>         path = {nodes = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, slots = {0, 0, 0, 0, 0, 0, 0, 0}, locks = {0, 0,
>             0, 0, 0, 0, 0, 0}, reada = 0, lowest_level = 0, search_for_split = 0, skip_check_block = 0}
>         nrefs = {bytenr = {271663104, 271646720, 560021504, 0, 0, 0, 0, 0}, refs = {1, 1, 1, 0, 0, 0, 0, 0}}
>         wret = 215575372
>         root_node = {cache = {rb_node = {__rb_parent_color = 0, rb_right = 0x0, rb_left = 0x0}, objectid = 0,
>             start = 0, size = 0}, root_cache = {root = {rb_node = 0x0}}, inode_cache = {root = {
>               rb_node = 0x781c80}}, current = 0x819530, refs = 0}
>         status = 215575372
>         rec = 0x1
> #4  check_fs_roots (root_cache=0xcd96b6d, root=<optimized out>) at cmds-check.c:3809
>         path = {nodes = {0x6eed90, 0x6a2f40, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, slots = {18, 2, 0, 0, 0, 0, 0, 0},
>           locks = {0, 0, 0, 0, 0, 0, 0, 0}, reada = 0, lowest_level = 0, search_for_split = 0,
>           skip_check_block = 0}
>         key = {objectid = 323, type = 132 '\204', offset = 18446744073709551615}
>         wc = {shared = {root = {rb_node = 0x0}}, nodes = {0x0, 0x0, 0x7fffffffe428, 0x0, 0x0, 0x0, 0x0, 0x0},
>           active_node = 2, root_level = 2}
>         leaf = 0x6e4fe0
>         tmp_root = 0x6e4fe0
> #5  0x00000000004287c3 in cmd_check (argc=215575372, argv=0x1d17880) at cmds-check.c:11521
>         root_cache = {root = {rb_node = 0x98c2940}}
>         info = 0x6927b0
>         bytenr = 6891440
>         tree_root_bytenr = 0
>         uuidbuf = "f65ff1a1-76ef-456e-beb5-c6c3841e7534"
>         num = 215575372
>         readonly = 218080104
>         qgroups_repaired = 0
> #6  0x000000000040a41f in main (argc=3, argv=0x7fffffffebe8) at btrfs.c:243
>         cmd = 0x689868
>         bname = <optimized out>
>         ret = <optimized out>

in that case the count of remaining items (nritems - slot - 1) gets
negative. That is then casted to (unsigned long len), which leads to the
observed crash.

Change the tests before the move to handle only the non-corrupted case,
were slow < nritems.

This does not fix the corruption, but allows btrfsck to finish without
crashing.

Signed-off-by: Philipp Hahn <hahn@univention.de>
---
 ctree.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/ctree.c b/ctree.c
index 02c7180..798bde9 100644
--- a/ctree.c
+++ b/ctree.c
@@ -1487,7 +1487,8 @@ static int insert_ptr(struct btrfs_trans_handle *trans, struct btrfs_root
 		BUG();
 	if (nritems == BTRFS_NODEPTRS_PER_BLOCK(root))
 		BUG();
-	if (slot != nritems) {
+	if (slot < nritems) {
+		/* shift the items */
 		memmove_extent_buffer(lower,
 			      btrfs_node_key_ptr_offset(slot + 1),
 			      btrfs_node_key_ptr_offset(slot),
@@ -2249,7 +2250,7 @@ split:
 
 	nritems = btrfs_header_nritems(leaf);
 
-	if (slot != nritems) {
+	if (slot < nritems) {
 		/* shift the items */
 		memmove_extent_buffer(leaf, btrfs_item_nr_offset(slot + 1),
 			      btrfs_item_nr_offset(slot),
@@ -2500,7 +2501,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	slot = path->slots[0];
 	BUG_ON(slot < 0);
 
-	if (slot != nritems) {
+	if (slot < nritems) {
 		unsigned int old_data = btrfs_item_end_nr(leaf, slot);
 
 		if (old_data < data_end) {
@@ -2603,7 +2604,8 @@ int btrfs_del_ptr(struct btrfs_root *root, struct btrfs_path *path,
 	int ret = 0;
 
 	nritems = btrfs_header_nritems(parent);
-	if (slot != nritems -1) {
+	if (slot < nritems -1) {
+		/* shift the items */
 		memmove_extent_buffer(parent,
 			      btrfs_node_key_ptr_offset(slot),
 			      btrfs_node_key_ptr_offset(slot + 1),
-- 
2.11.0

