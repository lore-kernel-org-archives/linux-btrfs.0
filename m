Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.palepurple.co.uk ([89.16.183.188]:45523 "EHLO
	mail.palepurple.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbbGZOgE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jul 2015 10:36:04 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.palepurple.co.uk (Postfix) with ESMTP id 595798287
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Jul 2015 15:29:31 +0100 (BST)
Received: from mail.palepurple.co.uk ([127.0.0.1])
	by localhost (mail.palepurple.co.uk [127.0.0.50]) (amavisd-new, port 10024)
	with ESMTP id pyLdR9wGNSUM for <linux-btrfs@vger.kernel.org>;
	Sun, 26 Jul 2015 15:29:20 +0100 (BST)
Received: from [192.168.0.6] (97e41746.skybroadband.com [151.228.23.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: david@codepoets.co.uk)
	by mail.palepurple.co.uk (Postfix) with ESMTPSA id 8CF6781A0
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Jul 2015 15:29:20 +0100 (BST)
From: David Goodwin <david@codepoets.co.uk>
Subject: oops - fs/btrfs/extent-tree.c:2025 - kernel 4.2.0-rc3 -
 __btrfs_inc_extent_ref:2025: errno=-17 Object already exists
To: linux-btrfs@vger.kernel.org
Message-ID: <55B4EF0E.6070307@codepoets.co.uk>
Date: Sun, 26 Jul 2015 15:30:38 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Filesystem was being balanced with :

btrfs balance start -dusage=55 -musage=55 $filesystem

when this happened :

------------[ cut here ]------------
WARNING: CPU: 2 PID: 31502 at fs/btrfs/extent-tree.c:2025 
__btrfs_inc_extent_ref.isra.51+0x210/0x280 [btrfs]()
BTRFS: Transaction aborted (error -17)
Modules linked in: xt_multiport nf_log_ipv4 nf_log_common xt_LOG 
xt_tcpudp iptable_filter ip_tables x_tables ppdev evdev kvm_amd wctdm(O) 
serio_raw kvm snd_hda_codec_realtek pcspkr edac_mce_amd 
snd_hda_codec_generic dahdi(O) radeon edac_core k10temp 
snd_hda_codec_hdmi crc_ccitt ttm snd_hda_intel drm_kms_helper 
snd_hda_codec drm snd_hda_core i2c_algo_bit snd_hwdep wmi snd_pcm 
parport_pc 8250_fintek asus_atk0110 parport tpm_tis snd_timer 
acpi_cpufreq sp5100_tco tpm snd i2c_piix4 processor button soundcore 
i2c_core shpchp thermal_sys loop fuse autofs4 crc32c_generic btrfs xor 
raid6_pq sg usb_storage sd_mod ata_generic ohci_pci ahci pata_atiixp 
libahci xhci_pci libata ohci_hcd ehci_pci xhci_hcd ehci_hcd scsi_mod 
r8169 usbcore mii usb_common
CPU: 2 PID: 31502 Comm: kworker/u16:1 Tainted: G           O 
4.2.0-rc3-dg1 #1
Hardware name: System manufacturer System Product Name/M5A88-M, BIOS 
1101    03/16/2012
Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
  0000000000000000 ffffffffa02b98a7 ffffffff81540a6f ffff880107383b28
  ffffffff8106dfa1 ffff88040c955800 ffff8801003612f8 ffff8800441bfda0
  00000a6f8acba000 0000000000003fa4 ffffffff8106e01a ffffffffa02bbc48
Call Trace:
  [<ffffffff81540a6f>] ? dump_stack+0x40/0x50
  [<ffffffff8106dfa1>] ? warn_slowpath_common+0x81/0xb0
  [<ffffffff8106e01a>] ? warn_slowpath_fmt+0x4a/0x50
  [<ffffffffa0222390>] ? __btrfs_inc_extent_ref.isra.51+0x210/0x280 [btrfs]
  [<ffffffffa0229e1f>] ? __btrfs_run_delayed_refs+0xd1f/0x10a0 [btrfs]
  [<ffffffff8101cc65>] ? sched_clock+0x5/0x10
  [<ffffffff811bd0c2>] ? __sb_start_write+0x42/0xe0
  [<ffffffffa022e26a>] ? btrfs_run_delayed_refs.part.73+0x6a/0x280 [btrfs]
  [<ffffffffa022e518>] ? delayed_ref_async_start+0x78/0x90 [btrfs]
  [<ffffffffa026eb6c>] ? normal_work_helper+0xbc/0x260 [btrfs]
  [<ffffffff81084e01>] ? process_one_work+0x151/0x3d0
  [<ffffffff81085805>] ? worker_thread+0x65/0x470
  [<ffffffff8154226d>] ? __schedule+0x28d/0x8a0
  [<ffffffff810857a0>] ? rescuer_thread+0x310/0x310
  [<ffffffff8108ac23>] ? kthread+0xd3/0xf0
  [<ffffffff8108ab50>] ? kthread_create_on_node+0x180/0x180
  [<ffffffff8154699f>] ? ret_from_fork+0x3f/0x70
  [<ffffffff8108ab50>] ? kthread_create_on_node+0x180/0x180
---[ end trace cc878b7b9dc6406e ]---
BTRFS: error (device sdc1) in __btrfs_inc_extent_ref:2025: errno=-17 
Object already exists
BTRFS info (device sdc1): forced readonly
BTRFS: error (device sdc1) in btrfs_run_delayed_refs:2781: errno=-17 
Object already exists

mount options:

kernel: vanilla 4.2.0-rc3

root@apple:~# btrfs check --repair /dev/sdc1
enabling repair mode
Checking filesystem on /dev/sdc1
UUID: 56805391-52a7-4621-bc83-6622e59e1e63
checking extents
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 1495257949968 bytes used err is 0
total csum bytes: 1449666724
total tree bytes: 10806792192
total fs tree bytes: 8529129472
total extent tree bytes: 543883264
btree space waste bytes: 2367868291
file data blocks allocated: 1644889620480
  referenced 1580747583488
btrfs-progs v4.0


root@apple:~# btrfs fi sh /backup/
Label: 'BACKUP2'  uuid: 56805391-52a7-4621-bc83-6622e59e1e63
     Total devices 2 FS bytes used 1.36TiB
     devid    1 size 2.73TiB used 1.46TiB path /dev/sda1
     devid    2 size 2.73TiB used 1.46TiB path /dev/sdc1

btrfs-progs v4.0

root@apple:~# btrfs fi us /backup/
WARNING: MIXED blockgroups not handled
Overall:
     Device size:           5.46TiB
     Device allocated:           5.85TiB
     Device unallocated:          16.00EiB
     Device missing:             0.00B
     Used:               5.44TiB
     Free (estimated):           8.00EiB    (min: 8.00EiB)
     Data ratio:                  2.00
     Metadata ratio:              2.00
     Global reserve:         512.00MiB    (used: 0.00B)

Data+Metadata,RAID1: Size:1.46TiB, Used:1.36TiB
    /dev/sda1       1.46TiB
    /dev/sdc1       1.46TiB

System,RAID1: Size:64.00MiB, Used:232.00KiB
    /dev/sda1      64.00MiB
    /dev/sdc1      64.00MiB

Unallocated:
    /dev/sda1       1.27TiB
    /dev/sdc1       1.27TiB

mount | grep sda1 :

/dev/sda1 on /backup type btrfs 
(rw,noatime,compress=lzo,space_cache,autodefrag,subvolid=5,subvol=/)


