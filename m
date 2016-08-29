Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:35729 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752918AbcH2Pwj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 11:52:39 -0400
Received: by mail-qk0-f179.google.com with SMTP id v123so142063740qkh.2
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 08:52:39 -0700 (PDT)
Message-ID: <1472485953.3290.0.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: Mon, 29 Aug 2016 12:52:33 -0300
In-Reply-To: <57C426AB.3020607@cn.fujitsu.com>
References: <1471023419.16857.9.camel@gmail.com>
         <57C426AB.3020607@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

I just have the problem again. Now, it happens during the lunch time
when the machine was idle. Only the system processes were running. It
was not the first time that I saw this problem just after lunch when
the machine stayed idle for a long period (+- 1h). 

Here is the information requested:

/sys/fs/btrfs/$UUID/allocation/data

./bytes_may_use
0
./bytes_pinned
0
./bytes_reserved
0
./bytes_used
36128374784
./disk_total
37589352448
./disk_used
36128374784
./flags
1
./total_bytes
37589352448
./total_bytes_pinned
20339560448
./single/total_bytes
37589352448
./single/used_bytes
36128374784

/sys/fs/btrfs/$UUID/allocation/metadata

./bytes_may_use
84974452736
./bytes_pinned
0
./bytes_reserved
0
./bytes_used
977354752
./disk_total
4294967296
./disk_used
1954709504
./flags
4
./total_bytes
2147483648
./total_bytes_pinned
-57851904
./dup/total_bytes
2147483648
./dup/used_bytes
977354752

# btrfs fi usage /
Overall:
    Device size:		   1.26TiB
    Device allocated:		  39.07GiB
    Device unallocated:		   1.22TiB
    Device missing:		     0.00B
    Used:			  35.29GiB
    Free (estimated):		   1.22TiB	(min: 625.93GiB)
    Data ratio:			      1.00
    Metadata ratio:		      2.00
    Global reserve:		 320.00MiB	(used: 0.00B)

Data,single: Size:35.01GiB, Used:33.47GiB
   /dev/sda6	  35.01GiB

Metadata,DUP: Size:2.00GiB, Used:932.00MiB
   /dev/sda6	   4.00GiB

System,DUP: Size:32.00MiB, Used:16.00KiB
   /dev/sda6	  64.00MiB

Unallocated:
   /dev/sda6	   1.22TiB

# btrfs fi df /
Data, single: total=35.01GiB, used=33.47GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=2.00GiB, used=932.09MiB
GlobalReserve, single: total=320.00MiB, used=0.0

I also saw the following information in `journalctl`:

Ago 29 10:25:33 ronanarraes-osd kernel: ------------[ cut here ]-------
-----
Ago 29 10:25:33 ronanarraes-osd kernel: WARNING: CPU: 4 PID: 30424 at
../fs/btrfs/extent-tree.c:4303
btrfs_free_reserved_data_space_noquota+0xfe/0x110 [btrfs]
Ago 29 10:25:33 ronanarraes-osd kernel: Modules linked in: fuse
nf_log_ipv6 xt_pkttype nf_log_ipv4 nf_log_common xt_LOG xt_limit
af_packet iscsi_ibft iscsi_boot_sysfs msr ip6t_REJECT nf_reject_ipv6
xt_tcpudp nf_
Ago 29 10:25:33 ronanarraes-osd kernel:  mei_wdt sysimgblt
iTCO_vendor_support i2c_i801 tpm_infineon tpm_tis tpm ioatdma
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel
aes_x86_64 lrw sparse_keymap
Ago 29 10:25:33 ronanarraes-osd kernel: CPU: 4 PID: 30424 Comm:
kworker/u65:1 Tainted: P           O    4.7.1-1-default #1
Ago 29 10:25:33 ronanarraes-osd kernel: Hardware name: Hewlett-Packard
HP Z820 Workstation/158B, BIOS J63 v03.65 12/19/2013
Ago 29 10:25:33 ronanarraes-osd kernel: Workqueue: writeback wb_workfn
(flush-btrfs-1)
Ago 29 10:25:33 ronanarraes-osd kernel:  0000000000000000
ffffffff81393104 0000000000000000 0000000000000000
Ago 29 10:25:33 ronanarraes-osd kernel:  ffffffff8107ca1e
ffff88100027c800 0000000000001000 ffff88082ff06400
Ago 29 10:25:33 ronanarraes-osd kernel:  ffff88100c7af784
0000000000001000 ffff8805bd60f6cc ffffffffa025098e
Ago 29 10:25:33 ronanarraes-osd kernel: Call Trace:
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffff8102ed5e>]
dump_trace+0x5e/0x320
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffff8102f12c>]
show_stack_log_lvl+0x10c/0x180
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffff8102fe41>]
show_stack+0x21/0x40
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffff81393104>]
dump_stack+0x5c/0x78
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffff8107ca1e>]
__warn+0xbe/0xe0
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffffa025098e>]
btrfs_free_reserved_data_space_noquota+0xfe/0x110 [btrfs]
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffffa026d036>]
btrfs_clear_bit_hook+0x296/0x380 [btrfs]
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffffa028a755>]
clear_state_bit+0x55/0x1d0 [btrfs]
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffffa028aa0d>]
__clear_extent_bit+0x13d/0x3f0 [btrfs]
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffffa028b8d2>]
extent_clear_unlock_delalloc+0x62/0x280 [btrfs]
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffffa0273722>]
run_delalloc_nocow+0x962/0xba0 [btrfs]
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffffa0273cbf>]
run_delalloc_range+0x35f/0x3b0 [btrfs]
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffffa028c090>]
writepage_delalloc.isra.40+0x100/0x170 [btrfs]
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffffa028e9d3>]
__extent_writepage+0xc3/0x340 [btrfs]
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffffa028ee8b>]
extent_write_cache_pages.isra.36.constprop.53+0x23b/0x350 [btrfs]
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffffa028f4fe>]
extent_writepages+0x4e/0x60 [btrfs]
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffff8123c64d>]
__writeback_single_inode+0x3d/0x3b0
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffff8123ce8a>]
writeback_sb_inodes+0x20a/0x440
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffff8123d147>]
__writeback_inodes_wb+0x87/0xb0
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffff8123d49d>]
wb_writeback+0x28d/0x330
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffff8123dbe2>]
wb_workfn+0x222/0x3f0
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffff810950ed>]
process_one_work+0x1ed/0x4e0
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffff81095427>]
worker_thread+0x47/0x4c0
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffff8109affd>]
kthread+0xbd/0xe0
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffff816bb71f>]
ret_from_fork+0x1f/0x40
Ago 29 10:25:33 ronanarraes-osd kernel: DWARF2 unwinder stuck at
ret_from_fork+0x1f/0x40
Ago 29 10:25:33 ronanarraes-osd kernel: 
Ago 29 10:25:33 ronanarraes-osd kernel: Leftover inexact backtrace:
Ago 29 10:25:33 ronanarraes-osd kernel:  [<ffffffff8109af40>] ?
kthread_worker_fn+0x170/0x170

Ago 29 10:34:51 ronanarraes-osd kernel: ------------[ cut here ]-------
-----
Ago 29 10:34:51 ronanarraes-osd kernel: WARNING: CPU: 6 PID: 27335 at
../fs/btrfs/inode.c:9306 btrfs_destroy_inode+0x23f/0x2b0 [btrfs]
Ago 29 10:34:51 ronanarraes-osd kernel: Modules linked in: fuse
nf_log_ipv6 xt_pkttype nf_log_ipv4 nf_log_common xt_LOG xt_limit
af_packet iscsi_ibft iscsi_boot_sysfs msr ip6t_REJECT nf_reject_ipv6
xt_tcpudp nf_
Ago 29 10:34:51 ronanarraes-osd kernel:  mei_wdt sysimgblt
iTCO_vendor_support i2c_i801 tpm_infineon tpm_tis tpm ioatdma
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel
aes_x86_64 lrw sparse_keymap
Ago 29 10:34:51 ronanarraes-osd kernel: CPU: 6 PID: 27335 Comm: Cache2
I/O Tainted: P        W  O    4.7.1-1-default #1
Ago 29 10:34:51 ronanarraes-osd kernel: Hardware name: Hewlett-Packard
HP Z820 Workstation/158B, BIOS J63 v03.65 12/19/2013
Ago 29 10:34:51 ronanarraes-osd kernel:  0000000000000000
ffffffff81393104 0000000000000000 0000000000000000
Ago 29 10:34:51 ronanarraes-osd kernel:  ffffffff8107ca1e
0000000000000000 ffff88071b592a80 ffff881000221800
Ago 29 10:34:51 ronanarraes-osd kernel:  0000000000000000
ffff88071b592a80 00000000ffffff9c ffffffffa027dabf
Ago 29 10:34:51 ronanarraes-osd kernel: Call Trace:
Ago 29 10:34:51 ronanarraes-osd kernel:  [<ffffffff8102ed5e>]
dump_trace+0x5e/0x320
Ago 29 10:34:51 ronanarraes-osd kernel:  [<ffffffff8102f12c>]
show_stack_log_lvl+0x10c/0x180
Ago 29 10:34:51 ronanarraes-osd kernel:  [<ffffffff8102fe41>]
show_stack+0x21/0x40
Ago 29 10:34:51 ronanarraes-osd kernel:  [<ffffffff81393104>]
dump_stack+0x5c/0x78
Ago 29 10:34:51 ronanarraes-osd kernel:  [<ffffffff8107ca1e>]
__warn+0xbe/0xe0
Ago 29 10:34:51 ronanarraes-osd kernel:  [<ffffffffa027dabf>]
btrfs_destroy_inode+0x23f/0x2b0 [btrfs]
Ago 29 10:34:51 ronanarraes-osd kernel:  [<ffffffff8121f6d1>]
do_unlinkat+0x131/0x310
Ago 29 10:34:51 ronanarraes-osd kernel:  [<ffffffff816bb4f6>]
entry_SYSCALL_64_fastpath+0x1e/0xa8
Ago 29 10:34:51 ronanarraes-osd kernel: DWARF2 unwinder stuck at
entry_SYSCALL_64_fastpath+0x1e/0xa8
Ago 29 10:34:51 ronanarraes-osd kernel: 
Ago 29 10:34:51 ronanarraes-osd kernel: Leftover inexact backtrace:
Ago 29 10:34:51 ronanarraes-osd kernel: ---[ end trace 5774bd3049f78a61
]---

Ago 29 11:21:19 ronanarraes-osd kernel: ------------[ cut here ]-------
-----
Ago 29 11:21:19 ronanarraes-osd kernel: WARNING: CPU: 18 PID: 16759 at
../fs/btrfs/extent-tree.c:4303
btrfs_free_reserved_data_space_noquota+0xfe/0x110 [btrfs]
Ago 29 11:21:19 ronanarraes-osd kernel: Modules linked in: fuse
nf_log_ipv6 xt_pkttype nf_log_ipv4 nf_log_common xt_LOG xt_limit
af_packet iscsi_ibft iscsi_boot_sysfs msr ip6t_REJECT nf_reject_ipv6
xt_tcpudp nf_
Ago 29 11:21:19 ronanarraes-osd kernel:  mei_wdt sysimgblt
iTCO_vendor_support i2c_i801 tpm_infineon tpm_tis tpm ioatdma
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel
aes_x86_64 lrw sparse_keymap
Ago 29 11:21:19 ronanarraes-osd kernel: CPU: 18 PID: 16759 Comm:
kworker/u65:2 Tainted: P        W  O    4.7.1-1-default #1
Ago 29 11:21:19 ronanarraes-osd kernel: Hardware name: Hewlett-Packard
HP Z820 Workstation/158B, BIOS J63 v03.65 12/19/2013
Ago 29 11:21:19 ronanarraes-osd kernel: Workqueue: writeback wb_workfn
(flush-btrfs-1)
Ago 29 11:21:19 ronanarraes-osd kernel:  0000000000000000
ffffffff81393104 0000000000000000 0000000000000000
Ago 29 11:21:19 ronanarraes-osd kernel:  ffffffff8107ca1e
ffff881000221800 0000000000001000 ffff88082ff06400
Ago 29 11:21:19 ronanarraes-osd kernel:  ffff8807b11b6784
0000000000001000 ffff8806acb1f73c ffffffffa025098e
Ago 29 11:21:19 ronanarraes-osd kernel: Call Trace:
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffff8102ed5e>]
dump_trace+0x5e/0x320
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffff8102f12c>]
show_stack_log_lvl+0x10c/0x180
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffff8102fe41>]
show_stack+0x21/0x40
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffff81393104>]
dump_stack+0x5c/0x78
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffff8107ca1e>]
__warn+0xbe/0xe0
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffffa025098e>]
btrfs_free_reserved_data_space_noquota+0xfe/0x110 [btrfs]
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffffa026d036>]
btrfs_clear_bit_hook+0x296/0x380 [btrfs]
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffffa028a755>]
clear_state_bit+0x55/0x1d0 [btrfs]
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffffa028aa0d>]
__clear_extent_bit+0x13d/0x3f0 [btrfs]
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffffa028b8d2>]
extent_clear_unlock_delalloc+0x62/0x280 [btrfs]
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffffa0272c19>]
cow_file_range+0x299/0x440 [btrfs]
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffffa0273cf2>]
run_delalloc_range+0x392/0x3b0 [btrfs]
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffffa028c090>]
writepage_delalloc.isra.40+0x100/0x170 [btrfs]
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffffa028e9d3>]
__extent_writepage+0xc3/0x340 [btrfs]
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffffa028ee8b>]
extent_write_cache_pages.isra.36.constprop.53+0x23b/0x350 [btrfs]
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffffa028f4fe>]
extent_writepages+0x4e/0x60 [btrfs]
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffff8123c64d>]
__writeback_single_inode+0x3d/0x3b0
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffff8123ce8a>]
writeback_sb_inodes+0x20a/0x440
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffff8123d147>]
__writeback_inodes_wb+0x87/0xb0
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffff8123d49d>]
wb_writeback+0x28d/0x330
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffff8123dbe2>]
wb_workfn+0x222/0x3f0
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffff810950ed>]
process_one_work+0x1ed/0x4e0
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffff81095427>]
worker_thread+0x47/0x4c0
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffff8109affd>]
kthread+0xbd/0xe0
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffff816bb71f>]
ret_from_fork+0x1f/0x40
Ago 29 11:21:19 ronanarraes-osd kernel: DWARF2 unwinder stuck at
ret_from_fork+0x1f/0x40
Ago 29 11:21:19 ronanarraes-osd kernel: 
Ago 29 11:21:19 ronanarraes-osd kernel: Leftover inexact backtrace:
Ago 29 11:21:19 ronanarraes-osd kernel:  [<ffffffff8109af40>] ?
kthread_worker_fn+0x170/0x170
Ago 29 11:21:19 ronanarraes-osd kernel: ---[ end trace 5774bd3049f78a62
]---

Ago 29 12:06:07 ronanarraes-osd kernel: ------------[ cut here ]-------
-----
Ago 29 12:06:07 ronanarraes-osd kernel: WARNING: CPU: 3 PID: 27335 at
../fs/btrfs/inode.c:9306 btrfs_destroy_inode+0x23f/0x2b0 [btrfs]
Ago 29 12:06:07 ronanarraes-osd kernel: Modules linked in: fuse
nf_log_ipv6 xt_pkttype nf_log_ipv4 nf_log_common xt_LOG xt_limit
af_packet iscsi_ibft iscsi_boot_sysfs msr ip6t_REJECT nf_reject_ipv6
xt_tcpudp nf_
Ago 29 12:06:07 ronanarraes-osd kernel:  mei_wdt sysimgblt
iTCO_vendor_support i2c_i801 tpm_infineon tpm_tis tpm ioatdma
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel
aes_x86_64 lrw sparse_keymap
Ago 29 12:06:07 ronanarraes-osd kernel: CPU: 3 PID: 27335 Comm: Cache2
I/O Tainted: P        W  O    4.7.1-1-default #1
Ago 29 12:06:07 ronanarraes-osd kernel: Hardware name: Hewlett-Packard
HP Z820 Workstation/158B, BIOS J63 v03.65 12/19/2013
Ago 29 12:06:07 ronanarraes-osd kernel:  0000000000000000
ffffffff81393104 0000000000000000 0000000000000000
Ago 29 12:06:07 ronanarraes-osd kernel:  ffffffff8107ca1e
0000000000000000 ffff88071b5eeb00 ffff881000221800
Ago 29 12:06:07 ronanarraes-osd kernel:  0000000000000000
ffff88071b5eeb00 00000000ffffff9c ffffffffa027dabf
Ago 29 12:06:07 ronanarraes-osd kernel: Call Trace:
Ago 29 12:06:07 ronanarraes-osd kernel:  [<ffffffff8102ed5e>]
dump_trace+0x5e/0x320
Ago 29 12:06:07 ronanarraes-osd kernel:  [<ffffffff8102f12c>]
show_stack_log_lvl+0x10c/0x180
Ago 29 12:06:07 ronanarraes-osd kernel:  [<ffffffff8102fe41>]
show_stack+0x21/0x40
Ago 29 12:06:07 ronanarraes-osd kernel:  [<ffffffff81393104>]
dump_stack+0x5c/0x78
Ago 29 12:06:07 ronanarraes-osd kernel:  [<ffffffff8107ca1e>]
__warn+0xbe/0xe0
Ago 29 12:06:07 ronanarraes-osd kernel:  [<ffffffffa027dabf>]
btrfs_destroy_inode+0x23f/0x2b0 [btrfs]
Ago 29 12:06:07 ronanarraes-osd kernel:  [<ffffffff8121f6d1>]
do_unlinkat+0x131/0x310
Ago 29 12:06:07 ronanarraes-osd kernel:  [<ffffffff816bb4f6>]
entry_SYSCALL_64_fastpath+0x1e/0xa8
Ago 29 12:06:07 ronanarraes-osd kernel: DWARF2 unwinder stuck at
entry_SYSCALL_64_fastpath+0x1e/0xa8
Ago 29 12:06:07 ronanarraes-osd kernel: 
Ago 29 12:06:07 ronanarraes-osd kernel: Leftover inexact backtrace:
Ago 29 12:06:07 ronanarraes-osd kernel: ---[ end trace 5774bd3049f78a63
]---

Best regards,
Ronan Arraes
