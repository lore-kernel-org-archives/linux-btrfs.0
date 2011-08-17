From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: [PATCH] btrfs: fix warning in iput for bad-inode
Date: Wed, 17 Aug 2011 22:56:19 +0400
Message-ID: <20110817185619.4660.78543.stgit@localhost6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

iput() shouldn't be called for inodes in I_NEW state,
lets call __destroy_inode() and btrfs_destroy_inode() instead

[    1.871723] WARNING: at fs/inode.c:1309 iput+0x1d9/0x200()
[    1.873722] Modules linked in:
[    1.873722] Pid: 1, comm: swapper Tainted: G        W   3.1.0-rc2-zurg #58
[    1.875722] Call Trace:
[    1.875722]  [<ffffffff8113cb99>] ? iput+0x1d9/0x200
[    1.876722]  [<ffffffff81044c3a>] warn_slowpath_common+0x7a/0xb0
[    1.877722]  [<ffffffff81044c85>] warn_slowpath_null+0x15/0x20
[    1.879722]  [<ffffffff8113cb99>] iput+0x1d9/0x200
[    1.879722]  [<ffffffff81295cf4>] btrfs_iget+0x1c4/0x450
[    1.881721]  [<ffffffff812b7e6b>] ? btrfs_tree_read_unlock_blocking+0x3b/0x60
[    1.882721]  [<ffffffff8111769a>] ? kmem_cache_free+0x2a/0x160
[    1.883721]  [<ffffffff812966f3>] btrfs_lookup_dentry+0x413/0x490
[    1.885721]  [<ffffffff8103b1e1>] ? get_parent_ip+0x11/0x50
[    1.886720]  [<ffffffff81296781>] btrfs_lookup+0x11/0x30
[    1.887720]  [<ffffffff8112de50>] d_alloc_and_lookup+0x40/0x80
[    1.888720]  [<ffffffff8113ac10>] ? d_lookup+0x30/0x50
[    1.889720]  [<ffffffff811301a8>] do_lookup+0x288/0x370
[    1.890720]  [<ffffffff8103b1e1>] ? get_parent_ip+0x11/0x50
[    1.891720]  [<ffffffff81132210>] do_last+0xe0/0x910
[    1.892720]  [<ffffffff81132b4d>] path_openat+0xcd/0x3a0
[    1.893719]  [<ffffffff813bab4b>] ? wait_for_xmitr+0x3b/0xa0
[    1.895719]  [<ffffffff8131c50a>] ? put_dec_full+0x5a/0xb0
[    1.896719]  [<ffffffff813babdb>] ? serial8250_console_putchar+0x2b/0x40
[    1.897719]  [<ffffffff81132e7d>] do_filp_open+0x3d/0xa0
[    1.898719]  [<ffffffff8103b1e1>] ? get_parent_ip+0x11/0x50
[    1.899718]  [<ffffffff8103b1e1>] ? get_parent_ip+0x11/0x50
[    1.900718]  [<ffffffff816e80fd>] ? sub_preempt_count+0x9d/0xd0
[    1.902718]  [<ffffffff8112a09d>] open_exec+0x2d/0xf0
[    1.903718]  [<ffffffff8112aaaf>] do_execve_common.isra.32+0x12f/0x340
[    1.906717]  [<ffffffff8112acd6>] do_execve+0x16/0x20
[    1.907717]  [<ffffffff8100af02>] sys_execve+0x42/0x70
[    1.908717]  [<ffffffff816ed968>] kernel_execve+0x68/0xd0
[    1.909717]  [<ffffffff816d828e>] ? run_init_process+0x1e/0x20
[    1.911717]  [<ffffffff816d831e>] init_post+0x8e/0xc0
[    1.912716]  [<ffffffff81cb8c79>] kernel_init+0x13d/0x13d
[    1.913716]  [<ffffffff816ed8f4>] kernel_thread_helper+0x4/0x10
[    1.914716]  [<ffffffff81cb8b3c>] ? start_kernel+0x33f/0x33f
[    1.915716]  [<ffffffff816ed8f0>] ? gs_change+0xb/0xb

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 fs/btrfs/inode.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 15fceef..3e949bd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3952,7 +3952,6 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *new)
 {
 	struct inode *inode;
-	int bad_inode = 0;
 
 	inode = btrfs_iget_locked(s, location->objectid, root);
 	if (!inode)
@@ -3968,15 +3967,12 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			if (new)
 				*new = 1;
 		} else {
-			bad_inode = 1;
+			__destroy_inode(inode);
+			btrfs_destroy_inode(inode);
+			inode = ERR_PTR(-ESTALE);
 		}
 	}
 
-	if (bad_inode) {
-		iput(inode);
-		inode = ERR_PTR(-ESTALE);
-	}
-
 	return inode;
 }
 

