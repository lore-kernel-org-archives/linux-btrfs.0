Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34360 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab3JGLGb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 07:06:31 -0400
Received: by mail-wi0-f181.google.com with SMTP id ex4so4609645wid.2
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2013 04:06:30 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix memory leaks on transaction commit failure
Date: Mon,  7 Oct 2013 12:04:28 +0100
Message-Id: <1381143868-4302-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Structures of the types tree_mod_elem and qgroup_update are allocated
during transaction commit but were not being released if the call to
btrfs_run_delayed_items() returned an error.

Stack trace reported by kmemleak:

unreferenced object 0xffff880679f0b398 (size 128):
  comm "umount", pid 21508, jiffies 4295967793 (age 36718.112s)
  hex dump (first 32 bytes):
    60 b5 f0 79 06 88 ff ff 00 00 00 00 00 00 00 00  `..y............
    00 00 00 00 00 00 00 00 50 1c 00 00 00 00 00 00  ........P.......
  backtrace:
    [<ffffffff81742d26>] kmemleak_alloc+0x26/0x50
    [<ffffffff811889c2>] kmem_cache_alloc_trace+0x112/0x200
    [<ffffffffa046f2d3>] tree_mod_log_insert_key.constprop.45+0x93/0x150 [btrfs]
    [<ffffffffa04720f9>] __btrfs_cow_block+0x299/0x4f0 [btrfs]
    [<ffffffffa0472510>] btrfs_cow_block+0x120/0x1f0 [btrfs]
    [<ffffffffa0476679>] btrfs_search_slot+0x449/0x930 [btrfs]
    [<ffffffffa048eecf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
    [<ffffffffa04eb49c>] __btrfs_update_delayed_inode+0x1c/0x1d0 [btrfs]
    [<ffffffffa04eb9e2>] __btrfs_run_delayed_items+0x162/0x1e0 [btrfs]
    [<ffffffffa04eba63>] btrfs_delayed_inode_exit+0x3/0x20 [btrfs]
    [<ffffffffa0499c63>] btrfs_commit_transaction+0x203/0xa50 [btrfs]
    [<ffffffffa046b519>] btrfs_sync_fs+0x69/0x110 [btrfs]
    [<ffffffff811cb210>] __sync_filesystem+0x30/0x60
    [<ffffffff811cb2bb>] sync_filesystem+0x4b/0x70
    [<ffffffff8119ce7b>] generic_shutdown_super+0x3b/0xf0
    [<ffffffff8119cfc6>] kill_anon_super+0x16/0x30
unreferenced object 0xffff880677e0dd88 (size 32):
  comm "umount", pid 21508, jiffies 4295967793 (age 36718.112s)
  hex dump (first 32 bytes):
    78 75 11 a9 06 88 ff ff 00 c0 e0 77 06 88 ff ff  xu.........w....
    40 c3 a2 70 06 88 ff ff 00 00 00 00 00 00 00 00  @..p............
  backtrace:
    [<ffffffff81742d26>] kmemleak_alloc+0x26/0x50
    [<ffffffff811889c2>] kmem_cache_alloc_trace+0x112/0x200
    [<ffffffffa04fa54f>] btrfs_qgroup_record_ref+0xf/0x90 [btrfs]
    [<ffffffffa04e1914>] btrfs_add_delayed_tree_ref+0xf4/0x170 [btrfs]
    [<ffffffffa048518a>] btrfs_free_tree_block+0x9a/0x220 [btrfs]
    [<ffffffffa0472163>] __btrfs_cow_block+0x303/0x4f0 [btrfs]
    [<ffffffffa0472510>] btrfs_cow_block+0x120/0x1f0 [btrfs]
    [<ffffffffa0476679>] btrfs_search_slot+0x449/0x930 [btrfs]
    [<ffffffffa048eecf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
    [<ffffffffa04eb49c>] __btrfs_update_delayed_inode+0x1c/0x1d0 [btrfs]
    [<ffffffffa04eb9e2>] __btrfs_run_delayed_items+0x162/0x1e0 [btrfs]
    [<ffffffffa04eba63>] btrfs_delayed_inode_exit+0x3/0x20 [btrfs]
    [<ffffffffa0499c63>] btrfs_commit_transaction+0x203/0xa50 [btrfs]
    [<ffffffffa046b519>] btrfs_sync_fs+0x69/0x110 [btrfs]
    [<ffffffff811cb210>] __sync_filesystem+0x30/0x60
    [<ffffffff811cb2bb>] sync_filesystem+0x4b/0x70

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/transaction.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a213baf..277fe81 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1600,15 +1600,19 @@ static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
 	int ret;
 
 	ret = btrfs_run_delayed_items(trans, root);
-	if (ret)
-		return ret;
-
 	/*
 	 * running the delayed items may have added new refs. account
 	 * them now so that they hinder processing of more delayed refs
 	 * as little as possible.
 	 */
-	btrfs_delayed_refs_qgroup_accounting(trans, root->fs_info);
+	if (ret) {
+		btrfs_delayed_refs_qgroup_accounting(trans, root->fs_info);
+		return ret;
+	}
+
+	ret = btrfs_delayed_refs_qgroup_accounting(trans, root->fs_info);
+	if (ret)
+		return ret;
 
 	/*
 	 * rename don't use btrfs_join_transaction, so, once we
-- 
1.7.9.5

