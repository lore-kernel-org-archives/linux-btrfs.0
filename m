Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57108 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728015AbeGQIST (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 04:18:19 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 31D23ACF0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jul 2018 07:47:01 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: extent-tree: Check if the newly reserved tree block is already in use
Date: Tue, 17 Jul 2018 15:46:58 +0800
Message-Id: <20180717074658.22331-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
For certain fuzzed btrfs image, if we create any csum data, it would
cause the following kernel warning and deadlock when trying to update
csum tree:
------
[  278.113360] WARNING: CPU: 1 PID: 41 at fs/btrfs/locking.c:230 btrfs_tree_lock+0x3e2/0x400
[  278.113737] CPU: 1 PID: 41 Comm: kworker/u4:1 Not tainted 4.18.0-rc1+ #8
[  278.113745] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  278.113753] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[  278.113761] RIP: 0010:btrfs_tree_lock+0x3e2/0x400
[  278.113762] Code: 00 48 c7 40 08 00 00 00 00 48 8b 45 d0 65 48 33 04 25 28 00 00 00 75 20 48 81 c4 a0 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b e9 d4 fc ff ff 0f 0b e9 61 ff ff ff e8 ab f4 87 ff 90 66 2e
[  278.113818] RSP: 0018:ffff8801f407f488 EFLAGS: 00010246
[  278.113865] Call Trace:
[  278.113936]  btrfs_alloc_tree_block+0x39f/0x770
[  278.113988]  __btrfs_cow_block+0x285/0x9e0
[  278.114029]  btrfs_cow_block+0x191/0x2e0
[  278.114035]  btrfs_search_slot+0x492/0x1160
[  278.114146]  btrfs_lookup_csum+0xec/0x280
[  278.114182]  btrfs_csum_file_blocks+0x2be/0xa60
[  278.114232]  add_pending_csums+0xaf/0xf0
[  278.114238]  btrfs_finish_ordered_io+0x74b/0xc90
[  278.114281]  finish_ordered_fn+0x15/0x20
[  278.114285]  normal_work_helper+0xf6/0x500
[  278.114305]  btrfs_endio_write_helper+0x12/0x20
[  278.114310]  process_one_work+0x302/0x770
[  278.114315]  worker_thread+0x81/0x6d0
[  278.114321]  kthread+0x180/0x1d0
[  278.114334]  ret_from_fork+0x35/0x40
[  278.114339] ---[ end trace 2e85051acb5f6dc1 ]---
------

[CAUSE]
The fuzzed image has corrupted EXTENT_ITEM for csum tree root:
------
extent tree key (EXTENT_TREE ROOT_ITEM 0)
	item 4 key (29364224 METADATA_ITEM 0) itemoff 3857 itemsize 33
		refs 1 gen 6 flags TREE_BLOCK
		tree block skinny level 0
		tree block backref root UUID_TREE
	item 5 key (29376512 UNKNOWN.0 0) itemoff 3824 itemsize 33
		    ^^^^^^^^^^^^^^^^^^^^ Corrupted METADATA_ITEM
	item 6 key (29380608 METADATA_ITEM 0) itemoff 3791 itemsize 33
		refs 1 gen 4 flags TREE_BLOCK
		tree block skinny level 0
		tree block backref root DATA_RELOC_TREE

checksum tree key (CSUM_TREE ROOT_ITEM 0)
leaf 29376512 items 0 free space 3995 generation 4 owner CSUM_TREE
     ^^^^^^^^ bytenr matches above item.
------

So when btrfs_alloc_tree_blocks() calls btrfs_reserve_extent(), since
there is not METADATA_ITEM/EXTENT_ITEM for bytenr 29376512, btrfs thinks
it's free space, and reserve it.

However in fact it's already been used by csum tree, and later
btrfs_init_new_buffer() will try to call btrfs_tree_lock(), whose
WARN_ON() detects lock nest on the same extent buffer.

Finally the wait_event() on the eb->read/write_lock_wq will never exit
since we're holding the lock by ourselves and deadlock.

[FIX]
The fix here is to ensure at least the reserved extent buffer is not
cached.
Any used extent buffer should be cached in the global radix tree
(fs_info->buffer_radix).

So before calling btrfs_init_new_buffer() in btrfs_alloc_tree_block(),
we call find_extent_buffer() explicitly to verify it's not used by
ourselves.

Please note this is just a basic check, it is not and will never be as
good as btrfs check on detecting extent tree corruption, but at least we
won't dead lock so easily.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=200405
Reported-by: Xu Wen <wen.xu@gatech.edu>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3578fa5b30ef..782dd96b7c5e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8435,6 +8435,20 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out_unuse;
 
+	/*
+	 * Newly allocated tree block should never be cached in radix tree,
+	 * Or we have a corrupted extent tree.
+	 */
+	buf = find_extent_buffer(fs_info, ins.objectid);
+	if (buf) {
+		btrfs_err_rl(fs_info,
+	"tree block %llu is already in use, extent tree may be corrupted",
+			     ins.objectid);
+		ret = -EUCLEAN;
+		free_extent_buffer(buf);
+		goto out_unuse;
+	}
+
 	buf = btrfs_init_new_buffer(trans, root, ins.objectid, level);
 	if (IS_ERR(buf)) {
 		ret = PTR_ERR(buf);
-- 
2.18.0

