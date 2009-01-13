From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Warning and BUG with btrfs and corrupted image
Date: Tue, 13 Jan 2009 15:21:47 +0100
Message-ID: <20090113142147.GE16333@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

when mounting an intentionally corrupted btrfs filesystem i get the
following warning and bug message. The image can be found here
www.cccmz.de/~snakebyte/btrfs.2.img.bck.bz2

[  297.406152] device fsid e14cf01de423381a-4bd40b603870018a <6>devid
2147483649 transid 9 /dev/loop0
[  297.411937] ------------[ cut here ]------------
[  297.412207] WARNING: at fs/btrfs/disk-io.c:805
read_tree_block+0x4c/0x58()
[  297.412348] Hardware name: System Name
[  297.412485] Modules linked in:
[  297.412684] Pid: 5144, comm: mount Tainted: G        W
2.6.29-rc1-00195-g1df11ad #200
[  297.412872] Call Trace:
[  297.413027]  [<c0123a8d>] warn_slowpath+0x79/0x8f
[  297.413251]  [<c013413d>] ? wake_bit_function+0x0/0x48
[  297.413395]  [<c013f692>] ? print_lock_contention_bug+0x11/0xb2
[  297.413575]  [<c04ad9b6>] ? btrfs_num_copies+0x20/0xba
[  297.413716]  [<c07c6b0e>] ? _spin_unlock+0x2c/0x41
[  297.413869]  [<c04ada46>] ? btrfs_num_copies+0xb0/0xba
[  297.414007]  [<c048f4b5>] ? btree_read_extent_buffer_pages+0x7f/0x95
[  297.414204]  [<c048f7f8>] read_tree_block+0x4c/0x58
[  297.414339]  [<c049264a>] open_ctree+0xa51/0xeff
[  297.414493]  [<c01cc814>] ? disk_name+0x2a/0x6c
[  297.414624]  [<c050d6e7>] ? strlcpy+0x17/0x48
[  297.414770]  [<c047b7e5>] btrfs_get_sb+0x20c/0x3d3
[  297.414913]  [<c017888e>] ? kstrdup+0x2f/0x51
[  297.415110]  [<c0191558>] vfs_kern_mount+0x40/0x7b
[  297.415242]  [<c01915e1>] do_kern_mount+0x37/0xbf
[  297.415401]  [<c01a2c78>] do_mount+0x5cc/0x609
[  297.415533]  [<c07c6db3>] ? lock_kernel+0x19/0x8c
[  297.415679]  [<c01a2d0b>] ? sys_mount+0x56/0xa0
[  297.415809]  [<c01a2d1e>] sys_mount+0x69/0xa0
[  297.415961]  [<c0102ea1>] sysenter_do_call+0x12/0x31
[  297.416145] ---[ end trace 4eaa2a86a8e2da24 ]---
[  297.416621] BUG: unable to handle kernel NULL pointer dereference at
000001f4
[  297.416915] IP: [<c01addd2>] bio_get_nr_vecs+0xf/0x3f
[  297.417199] *pde = 00000000 
[  297.417398] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[  297.417706] last sysfs file: /sys/block/ram9/range
[  297.417908] Modules linked in:
[  297.418086] 
[  297.418161] Pid: 5144, comm: mount Tainted: G        W
(2.6.29-rc1-00195-g1df11ad #200) System Name
[  297.418161] EIP: 0060:[<c01addd2>] EFLAGS: 00010246 CPU: 0
[  297.418161] EIP is at bio_get_nr_vecs+0xf/0x3f
[  297.418161] EAX: 00000000 EBX: 00000000 ECX: c12fe0c0 EDX: c48b8040
[  297.418161] ESI: 00000100 EDI: 00000000 EBP: cb38bc68 ESP: cb38bc44
[  297.418161]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  297.418161] Process mount (pid: 5144, ti=cb38b000 task=c14e0000
task.ti=cb38b000)
[  297.418161] Stack:
[  297.418161]  c04a7ed6 00000001 c12fe0c0 c48b8040 00000000 00001000
cb38bda4 00000000
[  297.418161]  c82f31c0 cb38bd40 c04a9af4 0000e028 00000000 00001000
00000000 c807c3e0
[  297.418161]  cb38bda8 ffffe3fb c04aaf4a 00000000 00000000 00000000
cf53c3f0 00000fff
[  297.418161] Call Trace:
[  297.418161]  [<c04a7ed6>] ? submit_extent_page+0xea/0x190
[  297.418161]  [<c04a9af4>] ? __extent_read_full_page+0x61d/0x6a0
[  297.418161]  [<c04aaf4a>] ? end_bio_extent_readpage+0x0/0x205
[  297.418161]  [<c0491123>] ? btree_get_extent+0x0/0x16c
[  297.418161]  [<c04a8467>] ? test_range_bit+0xd5/0xdf
[  297.418161]  [<c04aa4c7>] ? read_extent_buffer_pages+0x274/0x3aa
[  297.418161]  [<c07c6b0e>] ? _spin_unlock+0x2c/0x41
[  297.418161]  [<c04acda8>] ? alloc_extent_buffer+0x296/0x348
[  297.418161]  [<c048f477>] ? btree_read_extent_buffer_pages+0x41/0x95
[  297.418161]  [<c0491123>] ? btree_get_extent+0x0/0x16c
[  297.418161]  [<c048f7da>] ? read_tree_block+0x2e/0x58
[  297.418161]  [<c0492712>] ? open_ctree+0xb19/0xeff
[  297.418161]  [<c050d6e7>] ? strlcpy+0x17/0x48
[  297.418161]  [<c047b7e5>] ? btrfs_get_sb+0x20c/0x3d3
[  297.418161]  [<c017888e>] ? kstrdup+0x2f/0x51
[  297.418161]  [<c0191558>] ? vfs_kern_mount+0x40/0x7b
[  297.418161]  [<c01915e1>] ? do_kern_mount+0x37/0xbf
[  297.418161]  [<c01a2c78>] ? do_mount+0x5cc/0x609
[  297.418161]  [<c07c6db3>] ? lock_kernel+0x19/0x8c
[  297.418161]  [<c01a2d0b>] ? sys_mount+0x56/0xa0
[  297.418161]  [<c01a2d1e>] ? sys_mount+0x69/0xa0
[  297.418161]  [<c0102ea1>] ? sysenter_do_call+0x12/0x31
[  297.418161] Code: 39 45 e8 7c a4 8b 45 e4 e8 81 ec ff ff 89 f8 e8 c8
ec ff ff 83 c4 20 5b 5e 5f 5d c3 55 89 e5 0f 1f 44 00 00 8b 80 bc 00 00
00 5d <8b> 88 f4 01 00 00 8b 81 fc 01 00 00 0f b7 91 06 02 00 00 0f b7 
[  297.418161] EIP: [<c01addd2>] bio_get_nr_vecs+0xf/0x3f SS:ESP
0068:cb38bc44
[  297.432666] ---[ end trace 4eaa2a86a8e2da25 ]---


The BUG occurs here:

(gdb) l *(bio_get_nr_vecs+0xf)
0xc01addd2 is in bio_get_nr_vecs (include/linux/blkdev.h:785).
780					  struct request *, int,
rq_end_io_fn *);
781	extern void blk_unplug(struct request_queue *q);
782	
783	static inline struct request_queue *bdev_get_queue(struct
block_device *bdev)
784	{
785		return bdev->bd_disk->queue;
786	}
787	
788	static inline void blk_run_backing_dev(struct backing_dev_info
*bdi,
789					       struct page *page)


Greetings, Eric

ps: seems the btrfs entry in MAINTAINERS is missing
