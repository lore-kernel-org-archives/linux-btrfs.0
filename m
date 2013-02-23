Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38021 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539Ab3BWXAD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Feb 2013 18:00:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1U9O4d-0000Zp-TC
	for linux-btrfs@vger.kernel.org; Sun, 24 Feb 2013 00:00:07 +0100
Received: from slice.seblu.net ([82.234.72.62])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Feb 2013 00:00:07 +0100
Received: from seblu by slice.seblu.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Feb 2013 00:00:07 +0100
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?B?U8OpYmFzdGllbiBMdXR0cmluZ2Vy?= <seblu@seblu.net>
Subject: Is my btrfs filesystem definitely dead?
Date: Sat, 23 Feb 2013 23:48:34 +0100
Message-ID: <kgbgvv$qvr$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, after a crash with linux 3.8.0, I'm unable to mount my btrfs root
filesystem. I tried with a archlinux rescue cd with a linux 3.7.5, but I
got the following errors:

First trying to fix the fs:

# btrfsck
usage: btrfsck dev
Btrfs v0.20-rc1
# btrfsck /dev/sdd2
checking extents
checking fs roots
checking root refs
[1]    1051 segmentation fault (core dumped)  btrfsck /dev/sdd2
# dmesg|grep 1051
[  956.804097] btrfsck[1051]: segfault at 7f563c319410 ip
00007f56307c4c25 sp 00007ffffa7fbdf0 error 4 in
libc-2.17.so[7f563074a000+1a4000]


Trying to mount the FS i got a OOPS.
# mount /dev/sdd2 /new_root
[   60.602232] device label bitumefs devid 1 transid 40042 /dev/sdd2
[   60.603629] btrfs: disk space caching is enabled
[   60.615642] Btrfs detected SSD devices, enabling SSD mode
[   60.769651] ------------[ cut here ]------------
[   60.769709] kernel BUG at fs/btrfs/free-space-cache.c:1553!
[   60.769764] invalid opcode: 0000 [#1] PREEMPT SMP
[   60.769833] Modules linked in: raid456 async_raid6_recov async_memcpy
async_pq raid6_pq async_xor xor async_tx md_mod coretemp kvm_intel
iTCO_wdt iTCO_vendor_support gpio_ich acpi_cpufreq i2c_i801 mei mperf
kvm lpc_ich pcspkr processor evdev microcode nfs lockd sunrpc fscache
ext4 crc16 jbd2 mbcache dm_snapshot dm_mod squashfs loop isofs btrfs
libcrc32c zlib_deflate sr_mod cdrom usb_storage sd_mod i915 video
i2c_algo_bit ahci uhci_hcd crc32c_intel drm_kms_helper libahci xhci_hcd
ehci_hcd r8169 mii drm usbcore usb_common i2c_core sata_mv libata
scsi_mod intel_agp intel_gtt button
[   60.770686] CPU 0
[   60.770712] Pid: 515, comm: mount Not tainted 3.7.5-1-ARCH #1
Gigabyte Technology Co., Ltd. H55N-USB3/H55N-USB3
[   60.772551] RIP: 0010:[<ffffffffa03cd59f>]  [<ffffffffa03cd59f>]
remove_from_bitmap+0x16f/0x180 [btrfs]
[   60.774452] RSP: 0018:ffff88010d231698  EFLAGS: 00010287
[   60.776343] RAX: 0000000000000000 RBX: ffff88010e8238c0 RCX:
ffff880110b433e4
[   60.778270] RDX: 00000002019d6000 RSI: 0000000000008000 RDI:
00000000000000c0
[   60.780211] RBP: ffff88010d2316e8 R08: ffff880110031fe8 R09:
0000000000007f40
[   60.782139] R10: 0000000000000000 R11: ffffffffa037b428 R12:
ffff88010d231710
[   60.784063] R13: ffff88010d231708 R14: ffff880110b433c0 R15:
0000000201c00000
[   60.785998] FS:  00007fbb73158780(0000) GS:ffff880117c00000(0000)
knlGS:0000000000000000
[   60.787971] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.789952] CR2: 00007fd73954ea30 CR3: 000000010fa26000 CR4:
00000000000007f0
[   60.791962] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   60.793991] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[   60.796043] Process mount (pid: 515, threadinfo ffff88010d230000,
task ffff88010f0938e0)
[   60.798148] Stack:
[   60.800233]  ffff88010d2318a3 ffff880110b433e4 0000000201b48000
0000000000021000
[   60.802404]  ffff88010d231748 ffff88010e8238c0 ffff880110b433c0
00000000fffffff5
[   60.804598]  ffff880110b433e4 ffff880111faa800 ffff88010d231748
ffffffffa03cf8f3
[   60.806813] Call Trace:
[   60.809009]  [<ffffffffa03cf8f3>] btrfs_remove_free_space+0x53/0x260
[btrfs]
[   60.811262]  [<ffffffffa038309f>]
btrfs_alloc_logged_file_extent+0x1bf/0x1e0 [btrfs]
[   60.813532]  [<ffffffffa036f1ea>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[   60.815815]  [<ffffffffa03c8990>] replay_one_extent+0x620/0x690 [btrfs]
[   60.818095]  [<ffffffffa03aca29>] ?
release_extent_buffer.isra.26+0xb9/0xe0 [btrfs]
[   60.820373]  [<ffffffffa03b30c3>] ? read_extent_buffer+0xc3/0x120 [btrfs]
[   60.822662]  [<ffffffffa03c9a1b>] replay_one_buffer+0x2db/0x3a0 [btrfs]
[   60.824982]  [<ffffffffa03b19bd>] ? alloc_extent_buffer+0x9d/0x490
[btrfs]
[   60.827336]  [<ffffffffa03c63e2>] walk_down_log_tree+0x212/0x400 [btrfs]
[   60.829689]  [<ffffffffa03c666d>] walk_log_tree+0x9d/0x1f0 [btrfs]
[   60.832043]  [<ffffffffa03cc9eb>] btrfs_recover_log_trees+0x21b/0x3a0
[btrfs]
[   60.834427]  [<ffffffffa03c9740>] ? replay_one_dir_item+0xf0/0xf0 [btrfs]
[   60.836830]  [<ffffffffa03929d7>] open_ctree+0x1587/0x1ba0 [btrfs]
[   60.839233]  [<ffffffff81255091>] ? disk_name+0x61/0xc0
[   60.841637]  [<ffffffffa036bae3>] btrfs_mount+0x633/0x770 [btrfs]
[   60.844056]  [<ffffffff8126a8f8>] ? ida_get_new_above+0x218/0x2a0
[   60.846488]  [<ffffffff81188163>] mount_fs+0x43/0x1b0
[   60.848896]  [<ffffffff81142e40>] ? __alloc_percpu+0x10/0x20
[   60.851296]  [<ffffffff811a2974>] vfs_kern_mount+0x74/0x110
[   60.853691]  [<ffffffff811a2ed4>] do_kern_mount+0x54/0x110
[   60.856083]  [<ffffffff811a4b55>] do_mount+0x315/0x8e0
[   60.858464]  [<ffffffff8113d776>] ? memdup_user+0x46/0x80
[   60.860833]  [<ffffffff8113d80b>] ? strndup_user+0x5b/0x80
[   60.863144]  [<ffffffff811a51ae>] sys_mount+0x8e/0xe0
[   60.865399]  [<ffffffff814c111d>] system_call_fastpath+0x1a/0x1f
[   60.867600] Code: 8e 0f 1f 00 31 c0 48 83 7b 20 00 75 d5 48 89 de 4c
89 f7 89 45 b0 e8 01 f8 ff ff 8b 45 b0 eb c2 0f 1f 40 00 b8 ea ff ff ff
eb b7 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66
[   60.872568] RIP  [<ffffffffa03cd59f>] remove_from_bitmap+0x16f/0x180
[btrfs]
[   60.874877]  RSP <ffff88010d231698>
[   60.877135] ---[ end trace fca18cc0fac23f5f ]---
[   60.879348] note: mount[515] exited with preempt_count 1
[   60.881522] BUG: scheduling while atomic: mount/515/0x10000002
[   60.883682] Modules linked in: raid456 async_raid6_recov async_memcpy
async_pq raid6_pq async_xor xor async_tx md_mod coretemp kvm_intel
iTCO_wdt iTCO_vendor_support gpio_ich acpi_cpufreq i2c_i801 mei mperf
kvm lpc_ich pcspkr processor evdev microcode nfs lockd sunrpc fscache
ext4 crc16 jbd2 mbcache dm_snapshot dm_mod squashfs loop isofs btrfs
libcrc32c zlib_deflate sr_mod cdrom usb_storage sd_mod i915 video
i2c_algo_bit ahci uhci_hcd crc32c_intel drm_kms_helper libahci xhci_hcd
ehci_hcd r8169 mii drm usbcore usb_common i2c_core sata_mv libata
scsi_mod intel_agp intel_gtt button
[   60.895808] Pid: 515, comm: mount Tainted: G      D      3.7.5-1-ARCH #1
[   60.898163] Call Trace:
[   60.900492]  [<ffffffff814b0a5c>] __schedule_bug+0x4d/0x59
[   60.902838]  [<ffffffff814b84da>] __schedule+0x8da/0x920
[   60.905164]  [<ffffffff81165f60>] ? alloc_pages_current+0xb0/0x120
[   60.907488]  [<ffffffff8108ae8a>] __cond_resched+0x2a/0x40
[   60.909787]  [<ffffffff814b859f>] _cond_resched+0x2f/0x40
[   60.912050]  [<ffffffff81148e2c>] unmap_single_vma+0x44c/0x870
[   60.914296]  [<ffffffff8112e570>] ? release_pages+0x1f0/0x230
[   60.916540]  [<ffffffff81149ab2>] unmap_vmas+0x52/0xa0
[   60.918757]  [<ffffffff81151a58>] exit_mmap+0x98/0x170
[   60.920949]  [<ffffffff810547a1>] mmput+0x61/0x120
[   60.923131]  [<ffffffff8105ce38>] exit_mm+0x108/0x130
[   60.925289]  [<ffffffff814b9535>] ? _raw_spin_unlock_irq+0x35/0x40
[   60.927464]  [<ffffffff8105cfba>] do_exit+0x15a/0x940
[   60.929616]  [<ffffffff814b04ef>] ? printk+0x4d/0x4f
[   60.931749]  [<ffffffff8105ad41>] ? kmsg_dump+0xc1/0xd0
[   60.933870]  [<ffffffff814baa7d>] oops_end+0x9d/0xe0
[   60.935985]  [<ffffffff81018ed8>] die+0x58/0x90
[   60.938074]  [<ffffffff814ba35b>] do_trap+0x6b/0x170
[   60.940163]  [<ffffffff81016465>] do_invalid_op+0x95/0xb0
[   60.942260]  [<ffffffffa03cd59f>] ? remove_from_bitmap+0x16f/0x180
[btrfs]
[   60.944357]  [<ffffffffa036edd9>] ? btrfs_set_path_blocking+0x39/0x80
[btrfs]
[   60.946456]  [<ffffffffa03745b4>] ? btrfs_search_slot+0x504/0x900 [btrfs]
[   60.948554]  [<ffffffffa03abb7c>] ? check_buffer_tree_ref+0x3c/0x50
[btrfs]
[   60.950668]  [<ffffffffa03abb7c>] ? check_buffer_tree_ref+0x3c/0x50
[btrfs]
[   60.952742]  [<ffffffff814c229e>] invalid_op+0x1e/0x30
[   60.954806]  [<ffffffffa037b428>] ?
cache_block_group.isra.46+0x2f8/0x3e0 [btrfs]
[   60.956917]  [<ffffffffa03cd59f>] ? remove_from_bitmap+0x16f/0x180
[btrfs]
[   60.959032]  [<ffffffffa03cd49d>] ? remove_from_bitmap+0x6d/0x180 [btrfs]
[   60.961138]  [<ffffffffa03cf8f3>] btrfs_remove_free_space+0x53/0x260
[btrfs]
[   60.963263]  [<ffffffffa038309f>]
btrfs_alloc_logged_file_extent+0x1bf/0x1e0 [btrfs]
[   60.965404]  [<ffffffffa036f1ea>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[   60.967554]  [<ffffffffa03c8990>] replay_one_extent+0x620/0x690 [btrfs]
[   60.969712]  [<ffffffffa03aca29>] ?
release_extent_buffer.isra.26+0xb9/0xe0 [btrfs]
[   60.971894]  [<ffffffffa03b30c3>] ? read_extent_buffer+0xc3/0x120 [btrfs]
[   60.973996]  [<ffffffffa03c9a1b>] replay_one_buffer+0x2db/0x3a0 [btrfs]
[   60.976020]  [<ffffffffa03b19bd>] ? alloc_extent_buffer+0x9d/0x490
[btrfs]
[   60.978012]  [<ffffffffa03c63e2>] walk_down_log_tree+0x212/0x400 [btrfs]
[   60.980004]  [<ffffffffa03c666d>] walk_log_tree+0x9d/0x1f0 [btrfs]
[   60.981989]  [<ffffffffa03cc9eb>] btrfs_recover_log_trees+0x21b/0x3a0
[btrfs]
[   60.983975]  [<ffffffffa03c9740>] ? replay_one_dir_item+0xf0/0xf0 [btrfs]
[   60.985972]  [<ffffffffa03929d7>] open_ctree+0x1587/0x1ba0 [btrfs]
[   60.987905]  [<ffffffff81255091>] ? disk_name+0x61/0xc0
[   60.989791]  [<ffffffffa036bae3>] btrfs_mount+0x633/0x770 [btrfs]
[   60.991621]  [<ffffffff8126a8f8>] ? ida_get_new_above+0x218/0x2a0
[   60.993400]  [<ffffffff81188163>] mount_fs+0x43/0x1b0
[   60.995114]  [<ffffffff81142e40>] ? __alloc_percpu+0x10/0x20
[   60.996809]  [<ffffffff811a2974>] vfs_kern_mount+0x74/0x110
[   60.998490]  [<ffffffff811a2ed4>] do_kern_mount+0x54/0x110
[   61.000155]  [<ffffffff811a4b55>] do_mount+0x315/0x8e0
[   61.001836]  [<ffffffff8113d776>] ? memdup_user+0x46/0x80
[   61.003506]  [<ffffffff8113d80b>] ? strndup_user+0x5b/0x80
[   61.005168]  [<ffffffff811a51ae>] sys_mount+0x8e/0xe0
[   61.006825]  [<ffffffff814c111d>] system_call_fastpath+0x1a/0x1f

Is there something I can do to fix my filesystem?

-- 
Sébastien "Seblu" Luttringer
https://www.seblu.net
GPG: 0x2072D77A

