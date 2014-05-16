Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35920 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096AbaEPSwR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 14:52:17 -0400
Received: by mail-wi0-f170.google.com with SMTP id bs8so2614783wib.1
        for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 11:52:15 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix leak of block group cache objects
Date: Fri, 16 May 2014 20:52:01 +0100
Message-Id: <1400269921-17141-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The change titled:

     "Btrfs: fix broken free space cache after the system crashed"

can increment a block group cache object twice in find_free_extent() and
never decrement it twice, resulting in a memory leak.

This is easy to reproduce by having kmemleak enabled and the following
steps:

    mkfs.btrfs -f /dev/sdd
    mount /dev/sdd /mnt
    umount /mnt
    rmmod btrfs

    cat /sys/kernel/debug/kmemleak
    unreferenced object 0xffff8802089249d8 (size 512):
      comm "mount", pid 6826, jiffies 4306001111 (age 3065.636s)
      hex dump (first 32 bytes):
        00 00 c0 01 00 00 00 00 c0 00 00 00 40 00 00 00  ............@...
        00 00 c0 01 00 00 00 00 00 00 01 00 00 00 00 00  ................
      backtrace:
        [<ffffffff816ab3b6>] kmemleak_alloc+0x26/0x50
        [<ffffffff8119447d>] kmem_cache_alloc_trace+0x11d/0x1e0
        [<ffffffffa02a369c>] btrfs_create_block_group_cache+0x3c/0x160 [btrfs]
        [<ffffffffa02adf07>] btrfs_read_block_groups+0x1d7/0x650 [btrfs]
        [<ffffffffa02bc800>] open_ctree+0x16a0/0x20c0 [btrfs]
        [<ffffffffa0293321>] btrfs_mount+0x6b1/0x980 [btrfs]
        [<ffffffff811aa9c0>] mount_fs+0x20/0xe0
        [<ffffffff811c76f3>] vfs_kern_mount+0x73/0x170
        [<ffffffff811ca046>] do_mount+0x206/0xb20
        [<ffffffff811cac4e>] SyS_mount+0x8e/0xe0
        [<ffffffff816c8492>] system_call_fastpath+0x16/0x1b
        [<ffffffffffffffff>] 0xffffffffffffffff
    unreferenced object 0xffff8802019571d0 (size 128):
      comm "mount", pid 6826, jiffies 4306001111 (age 3065.684s)
      hex dump (first 32 bytes):
        4d 06 4d 06 ad 4e ad de ff ff ff ff 00 00 00 00  M.M..N..........
        ff ff ff ff ff ff ff ff 90 0d 36 a0 ff ff ff ff  ..........6.....
      backtrace:
        [<ffffffff816ab3b6>] kmemleak_alloc+0x26/0x50
        [<ffffffff8119447d>] kmem_cache_alloc_trace+0x11d/0x1e0
        [<ffffffffa02a36be>] btrfs_create_block_group_cache+0x5e/0x160 [btrfs]
        [<ffffffffa02adf07>] btrfs_read_block_groups+0x1d7/0x650 [btrfs]
        [<ffffffffa02bc800>] open_ctree+0x16a0/0x20c0 [btrfs]
        [<ffffffffa0293321>] btrfs_mount+0x6b1/0x980 [btrfs]
        [<ffffffff811aa9c0>] mount_fs+0x20/0xe0
        [<ffffffff811c76f3>] vfs_kern_mount+0x73/0x170
        [<ffffffff811ca046>] do_mount+0x206/0xb20
        [<ffffffff811cac4e>] SyS_mount+0x8e/0xe0
        [<ffffffff816c8492>] system_call_fastpath+0x16/0x1b
        [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

Note: this only affects Chris' integration branch.

 fs/btrfs/extent-tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index eb0760f..0bad610 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6456,6 +6456,8 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
 			} else {
 				index = get_block_group_index(block_group);
 				btrfs_grab_block_group(block_group, delalloc);
+				/* compensate get by btrfs_grab_block_group() */
+				btrfs_put_block_group(block_group);
 				goto have_block_group;
 			}
 		} else if (block_group) {
-- 
1.9.1

