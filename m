Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:53226 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751256AbbINL4G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 07:56:06 -0400
Received: from rc.speed47.net (nginx [192.168.80.2])
	by box.speed47.net (Postfix) with ESMTP id 8F73B25A6
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2015 13:46:35 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 14 Sep 2015 13:46:35 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: linux-btrfs@vger.kernel.org
Subject: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on rebalance
Message-ID: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello btrfs-aholics,

I've been experiencing repetitive "kernel BUG" occurences in the past 
few days trying to balance a raid5 filesystem after adding a new drive.
It occurs on both 4.2.0 and 4.1.7, using 4.2 userspace tools.

The raid5 setup was 2x4T drives (created 3 days ago to upgrade smoothly 
from mdadm/ext4 to btrfs), then I added a 3rd drive and tried to 
balance.
metadata is in raid1.

root@nas:~# uname -a
Linux nas 4.1.7-040107-generic #201509131330 SMP Sun Sep 13 17:32:28 UTC 
2015 x86_64 x86_64 x86_64 GNU/Linux

(and also
Linux version 4.2.0-7-generic (buildd@lgw01-60) (gcc version 5.2.1 
20150825 (Ubuntu 5.2.1-15ubuntu5) ) #7-Ubuntu SMP Tue Sep 1 16:43:10 UTC 
2015 (Ubuntu 4.2.0-7.7-generic 4.2.0)
)

root@nas:~# btrfs --version
btrfs-progs v4.2

root@nas:~# btrfs fi show
Label: 'tank'  uuid: 6bec1608-d9c0-453e-87eb-8b8663c9010d
         Total devices 3 FS bytes used 2.66TiB
         devid    1 size 2.73TiB used 2.50TiB path 
/dev/mapper/luks-WDC_WD30EFRX-68EUZN0_WD-WCC4N2STUCVR
         devid    2 size 2.73TiB used 2.50TiB path 
/dev/mapper/luks-WDC_WD30EFRX-68EUZN0_WD-WCC4N2DVRDXF
         devid    4 size 2.73TiB used 190.03GiB path 
/dev/mapper/luks-WDC_WD30EZRX-00MMMB0_WD-WCAWZ3013164

btrfs-progs v4.2

root@nas:~# btrfs fi df /tank/
Data, RAID5: total=2.67TiB, used=2.65TiB
System, RAID1: total=32.00MiB, used=384.00KiB
Metadata, RAID1: total=6.00GiB, used=4.38GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

root@nas:~# btrfs fi usage /tank/
WARNING: RAID56 detected, not implemented
Overall:
     Device size:                   8.19TiB
     Device allocated:             12.06GiB
     Device unallocated:            8.17TiB
     Device missing:                  0.00B
     Used:                          8.76GiB
     Free (estimated):                0.00B      (min: 8.00EiB)
     Data ratio:                       0.00
     Metadata ratio:                   2.00
     Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID5: Size:2.67TiB, Used:2.65TiB
    /dev/dm-1       2.49TiB
    /dev/dm-2       2.49TiB
    /dev/mapper/luks-WDC_WD30EZRX-00MMMB0_WD-WCAWZ3013164         
184.00GiB

Metadata,RAID1: Size:6.00GiB, Used:4.38GiB
    /dev/dm-1       3.00GiB
    /dev/dm-2       3.00GiB
    /dev/mapper/luks-WDC_WD30EZRX-00MMMB0_WD-WCAWZ3013164           
6.00GiB

System,RAID1: Size:32.00MiB, Used:384.00KiB
    /dev/dm-2      32.00MiB
    /dev/mapper/luks-WDC_WD30EZRX-00MMMB0_WD-WCAWZ3013164          
32.00MiB

Unallocated:
    /dev/dm-1     239.52GiB
    /dev/dm-2     239.49GiB
    /dev/mapper/luks-WDC_WD30EZRX-00MMMB0_WD-WCAWZ3013164           
2.54TiB


Each drive had LUKS configured on them (directly on /dev/sdX, no 
partition), then the resulting virtual drive is directly used as a btrfs 
device.


root@nas:~# time btrfs balance start /tank


Segmentation fault

real    750m55.550s

with the following kernel BUG in the log :


nas kernel: [17863.907793] ------------[ cut here ]------------
nas kernel: [17863.907833] kernel BUG at 
/build/linux-4dBub_/linux-4.2.0/fs/btrfs/extent-tree.c:1833!
nas kernel: [17863.907857] invalid opcode: 0000 [#1] SMP
nas kernel: [17863.907877] Modules linked in: xts gf128mul drbg 
ansi_cprng xt_multiport xt_comment xt_conntrack xt_nat xt_tcpudp 
nfnetlink_queue nfnetlink_log nfne
nas kernel: [17863.908264] CPU: 1 PID: 17379 Comm: btrfs Not tainted 
4.2.0-7-generic #7-Ubuntu
nas kernel: [17863.908281] Hardware name: ASUS All Series/H87I-PLUS, 
BIOS 1005 01/06/2014
nas kernel: [17863.908297] task: ffff880036184c80 ti: ffff8800507f4000 
task.ti: ffff8800507f4000
nas kernel: [17863.908314] RIP: 0010:[<ffffffffc0311ab6>]  
[<ffffffffc0311ab6>] insert_inline_extent_backref+0xc6/0xd0 [btrfs]
nas kernel: [17863.908349] RSP: 0018:ffff8800507f7698  EFLAGS: 00010293
nas kernel: [17863.908362] RAX: 0000000000000000 RBX: 0000000000000001 
RCX: 0000000000000001
nas kernel: [17863.908378] RDX: ffff880000000000 RSI: 0000000000000001 
RDI: 0000000000000000
nas kernel: [17863.908394] RBP: ffff8800507f7718 R08: 0000000000004000 
R09: ffff8800507f7598
nas kernel: [17863.908410] R10: 0000000000000000 R11: 0000000000000003 
R12: ffff8800c5c65000
nas kernel: [17863.908427] R13: 00000307b70ac000 R14: 0000000000000000 
R15: ffff880108d5c630
nas kernel: [17863.908443] FS:  00007f9300a7d900(0000) 
GS:ffff88011fb00000(0000) knlGS:0000000000000000
nas kernel: [17863.908461] CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
nas kernel: [17863.908475] CR2: 00007f0a351c6000 CR3: 0000000118c0d000 
CR4: 00000000000406e0
nas kernel: [17863.908491] Stack:
nas kernel: [17863.908496]  00000307b70ac000 0000000000000d0b 
0000000000000001 0000000000000000
nas kernel: [17863.908516]  0000030600000001 ffffffff811cf4ca 
0000000000000000 ffffffffc030550a
nas kernel: [17863.908535]  0000000000270026 00000000000035d7 
ffff88001fdd95c0 ffff8800927ae000
nas kernel: [17863.908555] Call Trace:
nas kernel: [17863.908564]  [<ffffffff811cf4ca>] ? 
kmem_cache_alloc+0x1ca/0x200
nas kernel: [17863.908582]  [<ffffffffc030550a>] ? 
btrfs_alloc_path+0x1a/0x20 [btrfs]
nas kernel: [17863.908601]  [<ffffffffc0311f98>] 
__btrfs_inc_extent_ref.isra.52+0x98/0x250 [btrfs]
nas kernel: [17863.908623]  [<ffffffffc031757a>] 
__btrfs_run_delayed_refs+0xc4a/0x1050 [btrfs]
nas kernel: [17863.908643]  [<ffffffffc030f980>] ? 
add_pinned_bytes+0x70/0x80 [btrfs]
nas kernel: [17863.908662]  [<ffffffffc0318087>] ? 
walk_up_proc+0xd7/0x4a0 [btrfs]
nas kernel: [17863.908681]  [<ffffffffc031a5be>] 
btrfs_run_delayed_refs.part.73+0x6e/0x270 [btrfs]
nas kernel: [17863.908702]  [<ffffffffc031a7d5>] 
btrfs_run_delayed_refs+0x15/0x20 [btrfs]
nas kernel: [17863.908723]  [<ffffffffc032e38a>] 
btrfs_should_end_transaction+0x5a/0x60 [btrfs]
nas kernel: [17863.908744]  [<ffffffffc0318dad>] 
btrfs_drop_snapshot+0x43d/0x820 [btrfs]
nas kernel: [17863.908765]  [<ffffffffc0328c00>] ? 
btrfs_get_fs_root+0x30/0x80 [btrfs]
nas kernel: [17863.908787]  [<ffffffffc03813c2>] 
merge_reloc_roots+0xd2/0x240 [btrfs]
nas kernel: [17863.908808]  [<ffffffffc038178a>] 
relocate_block_group+0x25a/0x690 [btrfs]
nas kernel: [17863.908829]  [<ffffffffc0381d8a>] 
btrfs_relocate_block_group+0x1ca/0x2c0 [btrfs]
nas kernel: [17863.909470]  [<ffffffffc03564de>] 
btrfs_relocate_chunk.isra.39+0x3e/0xb0 [btrfs]
nas kernel: [17863.910108]  [<ffffffffc0357847>] 
__btrfs_balance+0x4c7/0x8b0 [btrfs]
nas kernel: [17863.910748]  [<ffffffffc0357ec0>] 
btrfs_balance+0x290/0x610 [btrfs]
nas kernel: [17863.911406]  [<ffffffffc0364014>] ? 
btrfs_ioctl_balance+0x274/0x3c0 [btrfs]
nas kernel: [17863.912065]  [<ffffffffc0363f09>] 
btrfs_ioctl_balance+0x169/0x3c0 [btrfs]
nas kernel: [17863.912734]  [<ffffffffc03658d8>] 
btrfs_ioctl+0x548/0x26d0 [btrfs]
nas kernel: [17863.913398]  [<ffffffff811c5f12>] ? 
alloc_pages_vma+0xc2/0x230
nas kernel: [17863.914014]  [<ffffffff81185d6b>] ? 
lru_cache_add_active_or_unevictable+0x2b/0xa0
nas kernel: [17863.914651]  [<ffffffff811a6d25>] ? 
handle_mm_fault+0xbc5/0x16a0
nas kernel: [17863.915260]  [<ffffffff811aa4dd>] ? 
__vma_link_rb+0xfd/0x110
nas kernel: [17863.915841]  [<ffffffff811aa5a9>] ? vma_link+0xb9/0xc0
nas kernel: [17863.916427]  [<ffffffff811fffd5>] 
do_vfs_ioctl+0x285/0x470
nas kernel: [17863.916970]  [<ffffffff810630a4>] ? 
__do_page_fault+0x1b4/0x400
nas kernel: [17863.917528]  [<ffffffff81200239>] SyS_ioctl+0x79/0x90
nas kernel: [17863.918037]  [<ffffffff817b6cf2>] 
entry_SYSCALL_64_fastpath+0x16/0x75
nas kernel: [17863.918564] Code: 45 10 49 89 d9 48 8b 55 c8 4c 89 34 24 
4c 89 e9 4c 89 fe 4c 89 e7 48 89 44 24 10 8b 45 28 89 44 24 08 e8 fe d6 
ff ff 31 c0 eb bb <
nas kernel: [17863.919683] RIP  [<ffffffffc0311ab6>] 
insert_inline_extent_backref+0xc6/0xd0 [btrfs]
nas kernel: [17863.920202]  RSP <ffff8800507f7698>
nas kernel: [17863.922890] ---[ end trace f9b514d72fc0a628 ]---


I downgraded to 4.1.7 just in case, and got the same thing after a 
couple hours :


nas kernel: [47155.229661] ------------[ cut here ]------------
nas kernel: [47155.229670] WARNING: CPU: 1 PID: 9145 at 
/home/kernel/COD/linux/fs/btrfs/delayed-ref.c:475 
update_existing_ref+0x18b/0x1e0 [btrfs]()
nas kernel: [47155.229671] Modules linked in: ufs qnx4 hfsplus hfs minix 
ntfs msdos jfs xfs libcrc32c xts gf128mul xt_multiport xt_comment 
xt_conntrack xt_nat xt_t
nas kernel: [47155.229704] CPU: 1 PID: 9145 Comm: btrfs Tainted: P       
  W  OE   4.1.7-040107-generic #201509131330
nas kernel: [47155.229705] Hardware name: ASUS All Series/H87I-PLUS, 
BIOS 1005 01/06/2014
nas kernel: [47155.229706]  ffffffffc0381b30 ffff880103eff658 
ffffffff817d0ee3 0000000000000000
nas kernel: [47155.229707]  0000000000000000 ffff880103eff698 
ffffffff81079c3a 0000000000001000
nas kernel: [47155.229708]  ffff88009c3806e0 ffff88009a96a428 
ffff88009a96a3c0 ffff8800a3064420
nas kernel: [47155.229710] Call Trace:
nas kernel: [47155.229713]  [<ffffffff817d0ee3>] dump_stack+0x45/0x57
nas kernel: [47155.229714]  [<ffffffff81079c3a>] 
warn_slowpath_common+0x8a/0xc0
nas kernel: [47155.229715]  [<ffffffff81079d2a>] 
warn_slowpath_null+0x1a/0x20
nas kernel: [47155.229723]  [<ffffffffc0349cdb>] 
update_existing_ref+0x18b/0x1e0 [btrfs]
nas kernel: [47155.229730]  [<ffffffffc034a0cb>] 
add_delayed_tree_ref+0xeb/0x1a0 [btrfs]
nas kernel: [47155.229737]  [<ffffffffc034accc>] 
btrfs_add_delayed_tree_ref+0x10c/0x180 [btrfs]
nas kernel: [47155.229744]  [<ffffffffc02e6610>] 
btrfs_free_extent+0xe0/0x140 [btrfs]
nas kernel: [47155.229750]  [<ffffffffc02d3735>] ? 
btrfs_release_path+0x25/0xb0 [btrfs]
nas kernel: [47155.229757]  [<ffffffffc02e6958>] 
do_walk_down+0x2e8/0x940 [btrfs]
nas kernel: [47155.229763]  [<ffffffffc02e3b82>] ? 
walk_down_proc+0x2e2/0x310 [btrfs]
nas kernel: [47155.229771]  [<ffffffffc02fc68d>] ? 
join_transaction.isra.14+0xfd/0x410 [btrfs]
nas kernel: [47155.229777]  [<ffffffffc02e7076>] 
walk_down_tree+0xc6/0x100 [btrfs]
nas kernel: [47155.229784]  [<ffffffffc02eaa4a>] 
btrfs_drop_snapshot+0x41a/0x880 [btrfs]
nas kernel: [47155.229792]  [<ffffffffc034cb00>] ? 
should_ignore_root.part.15+0x50/0x50 [btrfs]
nas kernel: [47155.229800]  [<ffffffffc0351d49>] 
merge_reloc_roots+0xd9/0x240 [btrfs]
nas kernel: [47155.229807]  [<ffffffffc0352119>] 
relocate_block_group+0x269/0x670 [btrfs]
nas kernel: [47155.229814]  [<ffffffffc03526f6>] 
btrfs_relocate_block_group+0x1d6/0x2e0 [btrfs]
nas kernel: [47155.229822]  [<ffffffffc0325cbe>] 
btrfs_relocate_chunk.isra.38+0x3e/0xc0 [btrfs]
nas kernel: [47155.229830]  [<ffffffffc03270a4>] 
__btrfs_balance+0x4e4/0x8b0 [btrfs]
nas kernel: [47155.229838]  [<ffffffffc032781a>] 
btrfs_balance+0x3aa/0x680 [btrfs]
nas kernel: [47155.229846]  [<ffffffffc033086b>] ? 
btrfs_ioctl_balance+0x29b/0x520 [btrfs]
nas kernel: [47155.229853]  [<ffffffffc0330734>] 
btrfs_ioctl_balance+0x164/0x520 [btrfs]
nas kernel: [47155.229860]  [<ffffffffc03355f7>] 
btrfs_ioctl+0x597/0x2b30 [btrfs]
nas kernel: [47155.229862]  [<ffffffff811d2ad5>] ? 
alloc_pages_vma+0xb5/0x200
nas kernel: [47155.229864]  [<ffffffff81191a3b>] ? 
lru_cache_add_active_or_unevictable+0x2b/0xa0
nas kernel: [47155.229865]  [<ffffffff811b280c>] ? 
handle_mm_fault+0xbac/0x17e0
nas kernel: [47155.229866]  [<ffffffff811b6a08>] ? 
__vma_link_rb+0xc8/0xf0
nas kernel: [47155.229867]  [<ffffffff8120ce68>] 
do_vfs_ioctl+0x2f8/0x510
nas kernel: [47155.229869]  [<ffffffff81066f76>] ? 
__do_page_fault+0x1b6/0x450
nas kernel: [47155.229870]  [<ffffffff8120d101>] SyS_ioctl+0x81/0xa0
nas kernel: [47155.229871]  [<ffffffff81067240>] ? 
do_page_fault+0x30/0x80
nas kernel: [47155.229873]  [<ffffffff817d8ab2>] 
system_call_fastpath+0x16/0x75
nas kernel: [47155.229874] ---[ end trace e4064ae1c7878a22 ]---


and 2 seconds later :


nas kernel: [47157.228137] ------------[ cut here ]------------
nas kernel: [47157.228190] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent-tree.c:2248!
nas kernel: [47157.228259] invalid opcode: 0000 [#1] SMP
nas kernel: [47157.228301] Modules linked in: ufs qnx4 hfsplus hfs minix 
ntfs msdos jfs xfs libcrc32c xts gf128mul xt_multiport xt_comment 
xt_conntrack xt_nat xt_t
nas kernel: [47157.229656] CPU: 0 PID: 9145 Comm: btrfs Tainted: P       
  W  OE   4.1.7-040107-generic #201509131330
nas kernel: [47157.229741] Hardware name: ASUS All Series/H87I-PLUS, 
BIOS 1005 01/06/2014
nas kernel: [47157.229807] task: ffff88011a8cd080 ti: ffff880103efc000 
task.ti: ffff880103efc000
nas kernel: [47157.229875] RIP: 0010:[<ffffffffc02e8251>]  
[<ffffffffc02e8251>] __btrfs_run_delayed_refs+0x11a1/0x1230 [btrfs]
nas kernel: [47157.229998] RSP: 0018:ffff880103eff7c8  EFLAGS: 00010202
nas kernel: [47157.230048] RAX: 0000000000000001 RBX: 0000000000000000 
RCX: 00000000000001e1
nas kernel: [47157.230113] RDX: ffff8800c61ad000 RSI: ffff8800c6adaed0 
RDI: ffff8800c6adaec8
nas kernel: [47157.230179] RBP: ffff880103eff8f8 R08: 0000000000000000 
R09: 00000001802e002c
nas kernel: [47157.230244] R10: ffffffffc02e75d3 R11: 0000000000000d0a 
R12: ffff880056f0c9f8
nas kernel: [47157.230310] R13: 000003cdf0f80000 R14: ffff8800c6adae60 
R15: 0000000000000000
nas kernel: [47157.230377] FS:  00007f5f63146900(0000) 
GS:ffff88011fa00000(0000) knlGS:0000000000000000
nas kernel: [47157.230451] CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
nas kernel: [47157.230504] CR2: 00007f6126ad5000 CR3: 00000000041be000 
CR4: 00000000000406f0
nas kernel: [47157.230569] Stack:
nas kernel: [47157.230590]  0000000000000001 0000000000000000 
0000042000000001 0000000000000001
nas kernel: [47157.230669]  0000000000000000 0000000000000cf6 
ffff88009a930480 00000000000020ae
nas kernel: [47157.230748]  0000000203eff838 0000000000004000 
ffff88009a930480 ffff88009a930480
nas kernel: [47157.230827] Call Trace:
nas kernel: [47157.230882]  [<ffffffffc02ec483>] 
btrfs_run_delayed_refs.part.66+0x73/0x270 [btrfs]
nas kernel: [47157.230975]  [<ffffffffc02ec697>] 
btrfs_run_delayed_refs+0x17/0x20 [btrfs]
nas kernel: [47157.231065]  [<ffffffffc02fd169>] 
btrfs_should_end_transaction+0x49/0x60 [btrfs]
nas kernel: [47157.231155]  [<ffffffffc02eaaa2>] 
btrfs_drop_snapshot+0x472/0x880 [btrfs]
nas kernel: [47157.231251]  [<ffffffffc034cb00>] ? 
should_ignore_root.part.15+0x50/0x50 [btrfs]
nas kernel: [47157.231347]  [<ffffffffc0351d49>] 
merge_reloc_roots+0xd9/0x240 [btrfs]
nas kernel: [47157.231433]  [<ffffffffc0352119>] 
relocate_block_group+0x269/0x670 [btrfs]
nas kernel: [47157.231521]  [<ffffffffc03526f6>] 
btrfs_relocate_block_group+0x1d6/0x2e0 [btrfs]
nas kernel: [47157.231618]  [<ffffffffc0325cbe>] 
btrfs_relocate_chunk.isra.38+0x3e/0xc0 [btrfs]
nas kernel: [47157.231714]  [<ffffffffc03270a4>] 
__btrfs_balance+0x4e4/0x8b0 [btrfs]
nas kernel: [47157.231799]  [<ffffffffc032781a>] 
btrfs_balance+0x3aa/0x680 [btrfs]
nas kernel: [47157.231885]  [<ffffffffc033086b>] ? 
btrfs_ioctl_balance+0x29b/0x520 [btrfs]
nas kernel: [47157.231974]  [<ffffffffc0330734>] 
btrfs_ioctl_balance+0x164/0x520 [btrfs]
nas kernel: [47157.232062]  [<ffffffffc03355f7>] 
btrfs_ioctl+0x597/0x2b30 [btrfs]
nas kernel: [47157.232125]  [<ffffffff811d2ad5>] ? 
alloc_pages_vma+0xb5/0x200
nas kernel: [47157.232183]  [<ffffffff81191a3b>] ? 
lru_cache_add_active_or_unevictable+0x2b/0xa0
nas kernel: [47157.232253]  [<ffffffff811b280c>] ? 
handle_mm_fault+0xbac/0x17e0
nas kernel: [47157.232311]  [<ffffffff811b6a08>] ? 
__vma_link_rb+0xc8/0xf0
nas kernel: [47157.232365]  [<ffffffff8120ce68>] 
do_vfs_ioctl+0x2f8/0x510
nas kernel: [47157.232421]  [<ffffffff81066f76>] ? 
__do_page_fault+0x1b6/0x450
nas kernel: [47157.232477]  [<ffffffff8120d101>] SyS_ioctl+0x81/0xa0
nas kernel: [47157.232527]  [<ffffffff81067240>] ? 
do_page_fault+0x30/0x80
nas kernel: [47157.232584]  [<ffffffff817d8ab2>] 
system_call_fastpath+0x16/0x75
nas kernel: [47157.232640] Code: 48 c7 c7 68 e4 37 c0 e8 de 1a d9 c0 e9 
55 f0 ff ff 0f 0b be ba 00 00 00 48 c7 c7 68 e4 37 c0 e8 c6 1a d9 c0 e9 
4d f1 ff ff 0f 0b <
nas kernel: [47157.232977] RIP  [<ffffffffc02e8251>] 
__btrfs_run_delayed_refs+0x11a1/0x1230 [btrfs]
nas kernel: [47157.233072]  RSP <ffff880103eff7c8>
nas kernel: [47157.256409] ---[ end trace e4064ae1c7878a23 ]---

When it happens, the system is obviously unstable and I can't umount or 
reboot (without the sysreq keys, that is).
When I do reboot, the filesystem is still mountable and remotely seems 
OK (didn't try a scrub yet). This is reproductible on my side, and I'm 
willing do help you debug this!
I can attach the complete dmesg if necessary.

If you need me to try more stuff or dump more information to help 
debugging, just ask!

Thanks,

Stéphane.


