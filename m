From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [3.0-rc1] kernel BUG at fs/btrfs/relocation.c:4285!
Date: Wed, 01 Jun 2011 15:44:48 +0800
Message-ID: <4DE5EDF0.4030601@cn.fujitsu.com>
References: <4DE43607.2090105@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@Oracle.COM>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DE43607.2090105@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/31/2011 08:27 AM, Tsutomu Itoh wrote:
> The panic occurred when 'btrfs fi bal /test5' was executed.
> 
> /test5 is as follows:
> # mount -o space_cache,compress=lzo /dev/sdc3 /test5
> #
> # btrfs fi sh /dev/sdc3
> Label: none  uuid: 38ec48b2-a64b-4225-8cc6-5eb08024dc64
>         Total devices 5 FS bytes used 7.87MB
>         devid    1 size 10.00GB used 2.02GB path /dev/sdc3
>         devid    2 size 15.01GB used 3.00GB path /dev/sdc5
>         devid    3 size 15.01GB used 3.00GB path /dev/sdc6
>         devid    4 size 20.01GB used 2.01GB path /dev/sdc7
>         devid    5 size 10.00GB used 2.01GB path /dev/sdc8
> 
> Btrfs v0.19-50-ge6bd18d
> # btrfs fi df /test5
> Data, RAID0: total=10.00GB, used=3.52MB
> Data: total=8.00MB, used=1.60MB
> System, RAID1: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=1.00GB, used=216.00KB
> Metadata: total=8.00MB, used=0.00
> 

Hi, Itoh san, 

I've come up with a patch aiming to fix this bug.
The problems is that the inode allocator stores one inode cache per root,
which is at least not good for relocation tree, cause we only find
new inode number from fs tree or file tree (subvol/snapshot).

I've tested with your run.sh and it works well on my box, so you can try this:

===
based on 3.0, commit d6c0cb379c5198487e4ac124728cbb2346d63b1f
===
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 0009705..ebc2a7b 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -372,6 +372,10 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	int prealloc;
 	bool retry = false;
 
+	if (root->root_key.objectid != BTRFS_FS_TREE_OBJECTID &&
+	    root->root_key.objectid < BTRFS_FIRST_FREE_OBJECTID)
+		return 0;
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;



thanks,
liubo

> ---
> Tsutomu
> 
> ============================================================
> 
> <6>device fsid 25424ba6b248ec38-64dc2480b05ec68c devid 5 transid 4 /dev/sdc8
> <6>device fsid 25424ba6b248ec38-64dc2480b05ec68c devid 1 transid 7 /dev/sdc3
> <6>btrfs: enabling disk space caching
> <6>btrfs: use lzo compression
> <6>device fsid 69423c117ae771dd-c275f966f982cf84 devid 1 transid 7 /dev/sdd4
> <6>btrfs: disk space caching is enabled
> <6>btrfs: relocating block group 1103101952 flags 9
> <6>btrfs: found 318 extents
> <0>------------[ cut here ]------------
> <2>kernel BUG at fs/btrfs/relocation.c:4285!
> <0>invalid opcode: 0000 [#1] SMP
> <4>CPU 1
> <4>Modules linked in: btrfs autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table m
> perf ipv6 zlib_deflate libcrc32c ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parpor
> t_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp i3000_edac edac_core ex
> t4 mbcache jbd2 sd_mod crc_t10dif sr_mod cdrom megaraid_sas pata_acpi ata_generic ata_piix floppy [last
> unloaded: btrfs]
> <4>Pid: 6173, comm: btrfs Not tainted 3.0.0-rc1btrfs-test #1 FUJITSU-SV      PRIMERGY            /D2399
> <4>RIP: 0010:[<ffffffffa049308c>]  [<ffffffffa049308c>] btrfs_reloc_cow_block+0x22c/0x270 [btrfs]
> <4>RSP: 0018:ffff8801514236a8  EFLAGS: 00010246
> <4>RAX: ffff8801930dc000 RBX: ffff8801936f5800 RCX: ffff880163241d60
> <4>RDX: ffff88016325dd18 RSI: ffff8801931a3000 RDI: ffff8801632fb3e0
> <4>RBP: ffff880151423708 R08: ffff880151423784 R09: 0100000000000000
> <4>R10: 0000000000000000 R11: ffff880163224d58 R12: ffff8801931a3000
> <4>R13: ffff88016325dd18 R14: ffff8801632fb3e0 R15: 0000000000000000
> <4>FS:  00007f41577ce740(0000) GS:ffff88019fd00000(0000) knlGS:0000000000000000
> <4>CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> <4>CR2: 00000000010afb80 CR3: 000000015142e000 CR4: 00000000000006e0
> <4>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> <4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> <4>Process btrfs (pid: 6173, threadinfo ffff880151422000, task ffff880151997580)
> <0>Stack:
> <4> ffff88016325dd18 ffff8801632fb3e0 ffff880151423708 ffffffffa042b2ed
> <4> 0000000000000000 0000000000000001 ffff880151423708 ffff8801931a3000
> <4> ffff880163241d60 ffff88016325dd18 ffff8801632fb3e0 0000000000000000
> <0>Call Trace:
> <4> [<ffffffffa042b2ed>] ? update_ref_for_cow+0x22d/0x330 [btrfs]
> <4> [<ffffffffa042b841>] __btrfs_cow_block+0x451/0x5e0 [btrfs]
> <4> [<ffffffffa042badb>] btrfs_cow_block+0x10b/0x250 [btrfs]
> <4> [<ffffffffa0431c67>] btrfs_search_slot+0x557/0x870 [btrfs]
> <4> [<ffffffffa042a252>] ? generic_bin_search+0x1f2/0x210 [btrfs]
> <4> [<ffffffffa04447bf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
> <4> [<ffffffffa04557c2>] btrfs_update_inode+0xc2/0x140 [btrfs]
> <4> [<ffffffffa0444fbc>] btrfs_save_ino_cache+0x7c/0x200 [btrfs]
> <4> [<ffffffffa044c5ad>] commit_fs_roots+0xad/0x180 [btrfs]
> <4> [<ffffffffa044d555>] btrfs_commit_transaction+0x385/0x7d0 [btrfs]
> <4> [<ffffffff81081e00>] ? wake_up_bit+0x40/0x40
> <4> [<ffffffffa048f4bf>] prepare_to_relocate+0xdf/0xf0 [btrfs]
> <4> [<ffffffffa0496121>] relocate_block_group+0x41/0x600 [btrfs]
> <4> [<ffffffff814baa6e>] ? mutex_lock+0x1e/0x50
> <4> [<ffffffffa044bc59>] ? btrfs_clean_old_snapshots+0xa9/0x150 [btrfs]
> <4> [<ffffffffa0496893>] btrfs_relocate_block_group+0x1b3/0x2e0 [btrfs]
> <4> [<ffffffffa0480060>] ? btrfs_tree_unlock+0x50/0x50 [btrfs]
> <4> [<ffffffffa047549b>] btrfs_relocate_chunk+0x8b/0x680 [btrfs]
> <4> [<ffffffffa042a04d>] ? btrfs_set_path_blocking+0x3d/0x50 [btrfs]
> <4> [<ffffffffa046ee68>] ? read_extent_buffer+0xd8/0x1d0 [btrfs]
> <4> [<ffffffffa0432e71>] ? btrfs_previous_item+0xb1/0x150 [btrfs]
> <4> [<ffffffffa046ee68>] ? read_extent_buffer+0xd8/0x1d0 [btrfs]
> <4> [<ffffffffa04766aa>] btrfs_balance+0x20a/0x2a0 [btrfs]
> <4> [<ffffffffa047f85c>] btrfs_ioctl+0x54c/0xcb0 [btrfs]
> <4> [<ffffffff8112277b>] ? handle_mm_fault+0x15b/0x270
> <4> [<ffffffff814bf5f8>] ? do_page_fault+0x1e8/0x470
> <4> [<ffffffff81163dda>] do_vfs_ioctl+0x9a/0x540
> <4> [<ffffffff81164321>] sys_ioctl+0xa1/0xb0
> <4> [<ffffffff814c3a02>] system_call_fastpath+0x16/0x1b
> <0>Code: 8b 76 10 e8 b7 35 da e0 4c 8b 45 b0 41 80 48 71 20 48 8b 4d b8 8b 45 c0 e9 52 ff ff ff 48 83 be 0f 01 00 00 f7 0f 85 22 fe ff ff <0f> 0b eb fe 49 3b 50 20 0f 84 02 ff ff ff 0f 0b 0f 1f 40 00 eb
> <1>RIP  [<ffffffffa049308c>] btrfs_reloc_cow_block+0x22c/0x270 [btrfs]
> <4> RSP <ffff8801514236a8>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

