From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [2.6.38-rc6] create->rebalance->mount crash...
Date: Thu, 24 Feb 2011 20:48:22 +0800
Message-ID: <4D665396.2040105@cn.fujitsu.com>
References: <AANLkTik-WE+1FYAE6D--fN9GJpThCXwxgejiOsiTk_3k@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Miao Xie <miaox@cn.fujitsu.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik-WE+1FYAE6D--fN9GJpThCXwxgejiOsiTk_3k@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/24/2011 04:13 PM, Daniel J Blueman wrote:
> When creating a filesystem (single or redundant) with BTRFS and
> subsequently executing a balance [1], we see a kernel oops at the next
> mount [2].
> 

Hi, Daniel,

After digging this, I've come up with a patch on this, would you please test
it on your box?  Hopes that this is helpful, Thanks.

From: Liu Bo <liubo2009@cn.fujitsu.com>

[PATCH] btrfs: fix OOPS of empty filesystem after balance

btrfs will exclude unused block groups via a thread.
When a empty filesystem is balanced, the block group with tag "DATA" may be dropped,
and after umount, this will lead to OOPS when we mount it again.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 100e409..4749ab0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3856,10 +3856,14 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 	spin_unlock(&block_rsv->lock);
 }
 
-static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
+static int init_global_block_rsv(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *space_info;
 
+	space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA);
+	if (!space_info)
+		return -EAGAIN;
+
 	space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM);
 	fs_info->chunk_block_rsv.space_info = space_info;
 	fs_info->chunk_block_rsv.priority = 10;
@@ -3884,6 +3888,8 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
 	btrfs_add_durable_block_rsv(fs_info, &fs_info->delalloc_block_rsv);
 
 	update_global_block_rsv(fs_info);
+
+	return 0;
 }
 
 static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
@@ -8514,7 +8520,13 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 			set_block_group_ro(cache);
 	}
 
-	init_global_block_rsv(info);
+again:
+	ret = init_global_block_rsv(info);
+	if (ret == -EAGAIN) {
+		update_space_info(info, BTRFS_BLOCK_GROUP_DATA, 0, 0,
+				  &space_info);
+		goto again;
+	}
 	ret = 0;
 error:
 	btrfs_free_path(path);
-- 
1.6.5.2



> Thanks,
>   Daniel
> 
> --- [1]
> 
> # mkfs.btrfs /dev/sdb
> # mount /dev/sdb /store
> # btrfs filesystem balance /store
> # umount /store
> 
> --- [2]
> 
> # mount /dev/sdb /store
> Killed
> # dmesg
> device fsid bc4a5f28339d255f-6eccdd738ea4f0ac devid 1 transid 13 /dev/sdb
> btrfs: relocating block group 29360128 flags 36
> btrfs: found 2 extents
> btrfs: relocating block group 20971520 flags 34
> btrfs allocation failed flags 34, wanted 4096
> space_info has 0 free, is not full
> space_info total=12582912, used=4096, pinned=0, reserved=0, may_use=0,
> readonly=12578816
> block group 20971520 has 8388608 bytes, 4096 used 0 pinned 0 reserved
> entry offset 20975616, bytes 8384512, bitmap no
> block group has cluster?: no
> 1 blocks of free space at or bigger than bytes is
> block group 0 has 4194304 bytes, 0 used 0 pinned 0 reserved
> entry offset 131072, bytes 4063232, bitmap no
> block group has cluster?: no
> 1 blocks of free space at or bigger than bytes is
> btrfs: relocating block group 12582912 flags 1
> btrfs: relocating block group 4194304 flags 4
> device fsid bc4a5f28339d255f-6eccdd738ea4f0ac devid 1 transid 30 /dev/sdb
> BUG: unable to handle kernel NULL pointer dereference at 00000000000000b0
> IP: [<ffffffff81037cc9>] __ticket_spin_lock+0x9/0x20
> PGD 305e2c067 PUD 305732067 PMD 0
> Oops: 0002 [#1] SMP
> last sysfs file: /sys/devices/virtual/bdi/btrfs-4/uevent
> CPU 1
> Modules linked in: lp i7core_edac ioatdma edac_core parport psmouse
> dca serio_raw joydev raid10 raid456 async_raid6_recov async_pq usbhid
> hid raid6_pq async_xor xor async_memcpy async_tx ahci libahci raid1
> raid0 multipath e1000e linear btrfs zlib_deflate libcrc32c
> 
> Pid: 1013, comm: mount Tainted: G        W   2.6.38-020638rc6-generic
> #201102220910 Supermicro X8STi/X8STi
> RIP: 0010:[<ffffffff81037cc9>]  [<ffffffff81037cc9>] __ticket_spin_lock+0x9/0x20
> RSP: 0018:ffff880303be5a18  EFLAGS: 00010246
> RAX: 0000000000000100 RBX: 00000000000000b0 RCX: ffff880305ed5750
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 00000000000000b0
> RBP: ffff880303be5a18 R08: ffff8803056e62e8 R09: ffff880303be58c0
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000004 R14: ffff8803056e4140 R15: ffff8803056e4000
> FS:  00007f78247707e0(0000) GS:ffff8800df480000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000000000b0 CR3: 0000000303e85000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process mount (pid: 1013, threadinfo ffff880303be4000, task ffff880305710000)
> Stack:
>  ffff880303be5a28 ffffffff815ace4e ffff880303be5a68 ffffffffa00231af
>  ffff880304b56000 ffff8803056e4000 ffff8803056e6298 ffff880305ed5700
>  ffff8803056e4140 ffff8803056e4000 ffff880303be5aa8 ffffffffa00232b7
> Call Trace:
>  [<ffffffff815ace4e>] _raw_spin_lock+0xe/0x20
>  [<ffffffffa00231af>] calc_global_metadata_size+0x4f/0x120 [btrfs]
>  [<ffffffffa00232b7>] update_global_block_rsv+0x37/0xe0 [btrfs]
>  [<ffffffffa0023efb>] init_global_block_rsv+0xcb/0xe0 [btrfs]
>  [<ffffffffa002a9df>] btrfs_read_block_groups+0x37f/0x4d0 [btrfs]
>  [<ffffffff815ace4e>] ? _raw_spin_lock+0xe/0x20
>  [<ffffffffa003780d>] open_ctree+0x10cd/0x1480 [btrfs]
>  [<ffffffff812d8716>] ? vsnprintf+0x186/0x530
>  [<ffffffff8116081c>] ? set_anon_super+0x7c/0x120
>  [<ffffffffa001624e>] btrfs_fill_super+0x7e/0x140 [btrfs]
>  [<ffffffff81161cd8>] ? sget+0x238/0x260
>  [<ffffffff812d5b0f>] ? strlcpy+0x4f/0x70
>  [<ffffffffa001790b>] btrfs_mount+0x31b/0x3b0 [btrfs]
>  [<ffffffff811611fa>] vfs_kern_mount+0x8a/0x200
>  [<ffffffff81161463>] do_kern_mount+0x53/0xb0
>  [<ffffffff8117da7a>] do_new_mount+0x7a/0xb0
>  [<ffffffff8117e148>] do_mount+0x188/0x1d0
>  [<ffffffff8117e21f>] sys_mount+0x8f/0xd0
>  [<ffffffff8100c002>] system_call_fastpath+0x16/0x1b
> Code: ff 48 c7 c2 fe 7a 03 81 48 c7 c1 01 7b 03 81 e9 fe fe ff ff 90
> 90 90 90 90 90 90 90 90 90 90 90 90 90 55 b8 00 01 00 00 48 89 e5 <f0>
> 66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6 c9 c3 66 0f 1f 44
> RIP  [<ffffffff81037cc9>] __ticket_spin_lock+0x9/0x20
>  RSP <ffff880303be5a18>
> CR2: 00000000000000b0
> ---[ end trace a7919e7f17c0a728 ]---

