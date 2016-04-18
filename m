Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37291 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbcDRIsN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 04:48:13 -0400
From: Anand Jain <anand.jain@oracle.com>
To: quwenruo@cn.fujitsu.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix btrfs_check_degradable() to free extent map
Date: Mon, 18 Apr 2016 16:47:51 +0800
Message-Id: <1460969271-7436-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1442801443-5132-2-git-send-email-quwenruo@cn.fujitsu.com>
References: <1442801443-5132-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am making the following changes...

--------------- 8< ----------------------
Free the extent map and realign the map_tree read_lock
to fix the following..

kernel: BUG btrfs_extent_map (Tainted: G    B          ): Objects remaining in btrfs_extent_map on __kmem_cache_shutdown()
kernel: -----------------------------------------------------------------------------
kernel: INFO: Slab 0xffffea0001e4ef80 objects=28 used=9 fp=0xffff8800793be1b0 flags=0x1fffe0000000080
kernel: CPU: 0 PID: 5397 Comm: modprobe Tainted: G    B           4.6.0-rc2asj+ #5
kernel: Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
kernel:  0000000000000086 00000000c6b0aa23 ffff880035f3bcf8 ffffffff8141b7e3
kernel:  ffffea0001e4ef80 ffff880036994a00 ffff880035f3bdd0 ffffffff81217310
kernel:  0000000000000020 ffff880035f3bde0 ffff880035f3bd90 656a624f00000000
kernel: Call Trace:
kernel:  [<ffffffff8141b7e3>] dump_stack+0x85/0xc2
kernel:  [<ffffffff81217310>] slab_err+0xb0/0xe0
kernel:  [<ffffffff8121c109>] ? __kmalloc+0x259/0x3a0
kernel:  [<ffffffff8121f34c>] ? __kmem_cache_shutdown+0x14c/0x380
kernel:  [<ffffffff8121f36b>] __kmem_cache_shutdown+0x16b/0x380
kernel:  [<ffffffff811de5fb>] kmem_cache_destroy+0x1fb/0x2b0
kernel:  [<ffffffffa055be55>] extent_map_exit+0x15/0x20 [btrfs]
kernel:  [<ffffffffa05d8012>] exit_btrfs_fs+0x27/0x1015 [btrfs]
kernel:  [<ffffffff811365e3>] SyS_delete_module+0x1b3/0x260
kernel:  [<ffffffff810036ba>] ? exit_to_usermode_loop+0x6a/0xc0
kernel:  [<ffffffff8100301b>] ? trace_hardirqs_on_thunk+0x1b/0x1d
kernel:  [<ffffffff816a023c>] entry_SYSCALL_64_fastpath+0x1f/0xbd
kernel: INFO: Object 0xffff8800793be240 @offset=576
kernel: INFO: Object 0xffff8800793be2d0 @offset=720
kernel: INFO: Object 0xffff8800793be3f0 @offset=1008
kernel: INFO: Object 0xffff8800793be480 @offset=1152
kernel: INFO: Object 0xffff8800793be7e0 @offset=2016
kernel: INFO: Object 0xffff8800793be870 @offset=2160
kernel: INFO: Object 0xffff8800793be900 @offset=2304
kernel: INFO: Object 0xffff8800793beab0 @offset=2736
kernel: INFO: Object 0xffff8800793bebd0 @offset=3024

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 91d094ae2a10..36398c9d34eb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7105,6 +7105,7 @@ int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags)
 
 	read_lock(&map_tree->map_tree.lock);
 	em = lookup_extent_mapping(&map_tree->map_tree, 0, (u64)(-1));
+	read_unlock(&map_tree->map_tree.lock);
 	/* No any chunk? Should be a huge bug */
 	if (!em) {
 		ret = -ENOENT;
@@ -7143,11 +7144,14 @@ int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags)
 		 * Alwasy search range [next_start, (u64)-1) to find the next
 		 * chunk map
 		 */
+		free_extent_map(em);
+		read_lock(&map_tree->map_tree.lock);
 		em = lookup_extent_mapping(&map_tree->map_tree, next_start,
 					   (u64)(-1) - next_start);
+		read_unlock(&map_tree->map_tree.lock);
 	}
 out:
-	read_unlock(&map_tree->map_tree.lock);
+	free_extent_map(em);
 	return ret;
 }
 
-- 
2.7.0

