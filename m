From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [PATCH 3.0-rc3] btrfs: fix oops on failure path
Date: Sun, 19 Jun 2011 18:53:28 +0800
Message-ID: <BANLkTimrzmLdgg6NN_vU-Q6Euh1sE8SNNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I hit this BTRFS oops [1] in 3.0-rc3, clearly due to filesystem corruption.

If lookup_extent_backref fails, path->nodes[0] reasonably could be
null, so look before leaping [2].

Chris, if happy, can you squeeze this into the drop for -rc4 please?

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

--- [1]

leaf free space ret -1678719553, leaf data size 3995, used 1678723548 nritems 60
parent transid verify failed on 113373184 wanted 31 found 13951
leaf free space ret -1678719553, leaf data size 3995, used 1678723548 nritems 60
leaf free space ret -1678719553, leaf data size 3995, used 1678723548 nritems 60
leaf free space ret -1678719553, leaf data size 3995, used 1678723548 nritems 60
leaf free space ret -1678719553, leaf data size 3995, used 1678723548 nritems 60
BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
IP: [<ffffffff8122d8e8>] btrfs_print_leaf+0x28/0x810
PGD 206386067 PUD 20639e067 PMD 0
Oops: 0000 [#1] SMP
CPU 2
Modules linked in: binfmt_misc kvm_intel kvm microcode arc4 uvcvideo
videodev v4l2_compat_ioctl32 i915 mei(C) iwlagn drm_kms_helper
mac80211 drm i2c_algo_bit video sdhci_pci sdhci mmc_core usb_storage

Pid: 1526, comm: rm Tainted: G         C  3.0.0-rc3-340c+ #4 Dell Inc.
Latitude E5420/0H5TG2
RIP: 0010:[<ffffffff8122d8e8>]  [<ffffffff8122d8e8>] btrfs_print_leaf+0x28/0x810
RSP: 0018:ffff8802063f7ab8  EFLAGS: 00010286
RAX: 00000000fffffffb RBX: ffff88022dc5de10 RCX: 000000000000af74
RDX: 0000000000000008 RSI: 0000000000000000 RDI: ffff880223f5b000
RBP: ffff8802063f7b48 R08: ffffffff81259152 R09: 0000000000000001
R10: 00000000fffffffb R11: 000000020562a000 R12: 0000000000000005
R13: ffff8802063f7fd8 R14: 0000000000000000 R15: 0000000000001000
FS:  00007f95c55b3720(0000) GS:ffff88022ec40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000030 CR3: 00000002063ac000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rm (pid: 1526, threadinfo ffff8802063f6000, task ffff880210a15da0)
Stack:
 0000000000001000 ffff8802063f7c00 0000000006bb0000 ffffffff8125a124
 ffff880223f5b000 0000000000001000 ffff8802063f7b48 ffff88022dc5de10
 0000000006bb0000 00000000001000a8 ffff8802063f7b00 ffff880210bb8360
Call Trace:
 [<ffffffff8125a124>] ? set_extent_dirty+0x24/0x30
 [<ffffffff812261f2>] __btrfs_free_extent+0x672/0x720
 [<ffffffff8121bf60>] ? btrfs_del_leaf+0xd0/0x100
 [<ffffffff81228ac9>] run_clustered_refs+0x379/0x840
 [<ffffffff81279b00>] ? btrfs_find_ref_cluster+0x60/0x190
 [<ffffffff81229050>] btrfs_run_delayed_refs+0xc0/0x200
 [<ffffffff8123a558>] __btrfs_end_transaction+0x88/0x250
 [<ffffffff8123a780>] btrfs_end_transaction+0x10/0x20
 [<ffffffff81244420>] btrfs_evict_inode+0x180/0x210
 [<ffffffff8110dd2b>] evict+0x7b/0x150
 [<ffffffff8110df25>] iput+0xd5/0x1a0
 [<ffffffff81103964>] do_unlinkat+0x104/0x1d0
 [<ffffffff8112b88b>] ? fsnotify_find_inode_mark+0x2b/0x40
 [<ffffffff810f4561>] ? filp_close+0x61/0x90
 [<ffffffff81104c5d>] sys_unlinkat+0x1d/0x40
 [<ffffffff8165f0fb>] system_call_fastpath+0x16/0x1b
Code: 00 00 00 55 48 89 e5 48 81 ec 90 00 00 00 48 89 5d d8 4c 89 6d
e8 4c 89 65 e0 4c 89 75 f0 4c 89 7d f8 65 4c 8b 2c 25 c8 b5 00 00
 8b 46 30 49 81 ed d8 1f 00 00 48 89 f3 41 ff 45 1c 48 ba 00
RIP  [<ffffffff8122d8e8>] btrfs_print_leaf+0x28/0x810
 RSP <ffff8802063f7ab8>
CR2: 0000000000000030

--- [2]

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b42efc2..1848f8f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4454,7 +4454,8 @@ static int __btrfs_free_extent(struct
btrfs_trans_handle *trans,
 			extent_slot = path->slots[0];
 		}
 	} else {
-		btrfs_print_leaf(extent_root, path->nodes[0]);
+		if (path->nodes[0])
+			btrfs_print_leaf(extent_root, path->nodes[0]);
 		WARN_ON(1);
 		printk(KERN_ERR "btrfs unable to find ref byte nr %llu "
 		       "parent %llu root %llu  owner %llu offset %llu\n",
-- 
Daniel J Blueman
