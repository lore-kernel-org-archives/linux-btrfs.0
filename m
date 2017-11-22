Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:37046 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751613AbdKVJDs (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 22 Nov 2017 04:03:48 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 01/11] btrfs-progs: lowmem check: Fix regression which screws up extent allocator
Date: Wed, 22 Nov 2017 17:03:15 +0800
Message-Id: <20171122090325.29458-2-wqu@suse.com>
In-Reply-To: <20171122090325.29458-1-wqu@suse.com>
References: <20171122090325.29458-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
Commit 723427d7e6b7 ("btrfs-progs: check: change the way lowmem mode traverses
metadata") introduces a regression which could make some fsck self test
case to fail.

For fsck test case 004-no-dir-item, btrfs check --mode=lowmem --repair
can cause BUG_ON() with ret = -17 (-EEXIST) when committing transaction.

The problem happens with the following backtrace:

./btrfs(+0x22045)[0x555d0dade045]
./btrfs(+0x2216f)[0x555d0dade16f]
./btrfs(+0x29df1)[0x555d0dae5df1]
./btrfs(+0x2a142)[0x555d0dae6142]
./btrfs(btrfs_alloc_free_block+0x78)[0x555d0dae6202]
./btrfs(__btrfs_cow_block+0x177)[0x555d0dad00a2]
./btrfs(btrfs_cow_block+0x116)[0x555d0dad05a8]
./btrfs(commit_tree_roots+0x91)[0x555d0db1fd4f]
./btrfs(btrfs_commit_transaction+0x18c)[0x555d0db20100]
./btrfs(btrfs_fix_super_size+0x190)[0x555d0db005a4]
./btrfs(btrfs_fix_device_and_super_size+0x177)[0x555d0db00771]
./btrfs(cmd_check+0x1757)[0x555d0db4f6ab]
./btrfs(main+0x138)[0x555d0dace5dd]
/usr/lib/libc.so.6(__libc_start_main+0xea)[0x7fa5e4613f6a]
./btrfs(_start+0x2a)[0x555d0dacddda]

The bug is triggered by that, extent allocator considers range [29360128,
29376512) is free and allocate it.
However when inserting EXTENT_ITEM, btrfs finds there is already one
tree block (fs tree root), returning -EEXIST and causing later BUG_ON().

[CAUSE]
The cause is in repair mode, lowmem check always pins all metadata
blocks.
However pinned metadata blocks will be unpin when transaction commits,
and will be marked as *FREE* space.

So later extent allocator will consider such range free and allocate
them wrongly.

[FIX]
Don't pin metadata blocks without valid reason or preparation (like
discard all free space cache to re-calculate free space on next write).

Fixes: 723427d7e6b7 ("btrfs-progs: check: change the way lowmem mode traverses metadata")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-check.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index a93ac2c88a38..644ee084cb8e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6623,8 +6623,6 @@ out:
 	return ret;
 }
 
-static int pin_metadata_blocks(struct btrfs_fs_info *fs_info);
-
 /*
  * Iterate all items in the tree and call check_inode_item() to check.
  *
@@ -13306,8 +13304,6 @@ out:
 	return err;
 }
 
-static int pin_metadata_blocks(struct btrfs_fs_info *fs_info);
-
 /*
  * Low memory usage version check_chunks_and_extents.
  */
@@ -13326,12 +13322,6 @@ static int check_chunks_and_extents_v2(struct btrfs_fs_info *fs_info)
 	root = fs_info->fs_root;
 
 	if (repair) {
-		/* pin every tree block to avoid extent overwrite */
-		ret = pin_metadata_blocks(fs_info);
-		if (ret) {
-			error("failed to pin metadata blocks");
-			return ret;
-		}
 		trans = btrfs_start_transaction(fs_info->extent_root, 1);
 		if (IS_ERR(trans)) {
 			error("failed to start transaction before check");
-- 
2.15.0

