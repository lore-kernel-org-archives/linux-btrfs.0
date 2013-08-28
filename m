Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:33174 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab3H1Pkx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Aug 2013 11:40:53 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 2E6FC3886A3
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Aug 2013 17:40:49 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
Subject: btrfs device delete missing -> kernel BUG at  fs/btrfs/relocation.c:1055!
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 28 Aug 2013 17:40:49 +0200
From: Tomasz Chmielewski <tch@virtall.com>
Message-ID: <0ce5885cea6d25abb00e393355d86a00@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just tried to remove a broken disk, which ended in segmentation fault 
and kernel BUG.

Any advice what to do next? This is on 3.11.0-rc7.

# btrfs device delete missing /home
(after a few minutes)
Segmentation fault

# btrfs fi show
Label: 'test-btrfs'  uuid: 60f1759c-45f6-4484-9f60-66a4e9bbf2b6
         Total devices 3 FS bytes used 1.19TB
         devid    4 size 2.56TB used 0.00 path /dev/sda4
         devid    3 size 2.56TB used 1.19TB path /dev/sdb4
         *** Some devices missing

Btrfs v0.20-rc1-324-g650e656

[  262.810201] device label crawler-btrfs devid 3 transid 97972 
/dev/sdb4
[  262.810685] btrfs: allowing degraded mounts
[  262.810739] btrfs: force zlib compression
[  262.810789] btrfs: disk space caching is enabled
[  262.901838] btrfs: bdev (null) errs: wr 0, rd 2, flush 0, corrupt 0, 
gen 0
[  552.010306] btrfs: relocating block group 3955761348608 flags 17
[  926.802956] btrfs: found 2364 extents
[ 1171.285213] btrfs: found 2084 extents
[ 1304.978086] btrfs: relocating block group 3954687606784 flags 17
[ 1457.655947] btrfs: found 6491 extents
[ 1488.556627] ------------[ cut here ]------------
[ 1488.556683] kernel BUG at fs/btrfs/relocation.c:1055!
[ 1488.556735] invalid opcode: 0000 [#1] SMP
[ 1488.556866] Modules linked in: tun cpufreq_powersave cpufreq_ondemand 
cpufreq_conservative cpufreq_stats ipv6 btrfs zlib_deflate ext3 jbd loop 
ehci_pci ehci_hcd pcspkr i2c_i801 lpc_ich i2c_core mfd_core acpi_cpufreq 
mperf button video ext4 crc16 jbd2 mbcache freq_table aacraid 3w_9xxx 
3w_xxxx raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor 
async_tx xor raid6_pq raid1 raid0 sata_nv sata_sil sata_via sg sd_mod 
ahci libahci libata scsi_mod r8169 mii
[ 1488.559137] CPU: 1 PID: 4563 Comm: btrfs Not tainted 3.11.0-rc7 #1
[ 1488.559243] Hardware name: System manufacturer System Product 
Name/P8H67-M PRO, BIOS 1106 10/17/2011
[ 1488.559408] task: ffff8808040416e0 ti: ffff8807f9e22000 task.ti: 
ffff8807f9e22000
[ 1488.559569] RIP: 0010:[<ffffffffa035f729>]  [<ffffffffa035f729>] 
build_backref_tree+0xb10/0xe91 [btrfs]
[ 1488.559793] RSP: 0018:ffff8807f9e23928  EFLAGS: 00010246
[ 1488.559898] RAX: ffff8807f9e23900 RBX: ffff8807f9e239a0 RCX: 
ffff8807ffd73d50
[ 1488.560006] RDX: ffff8807f9e239a0 RSI: ffff8807ffd73d40 RDI: 
ffff880813fa0700
[ 1488.560113] RBP: ffff8807f9e23a18 R08: ffff880813fa0780 R09: 
0000000000001000
[ 1488.560221] R10: 0000000000001000 R11: 0000160000000000 R12: 
0000000000000000
[ 1488.560329] R13: ffff8807ffd73d50 R14: ffff8807f9e239b0 R15: 
ffff880800620800
[ 1488.560437] FS:  00007f3c96d2a740(0000) GS:ffff88083fa40000(0000) 
knlGS:0000000000000000
[ 1488.560599] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1488.560703] CR2: 00007f5c7209d680 CR3: 00000007e867c000 CR4: 
00000000000407e0
[ 1488.560810] Stack:
[ 1488.560908]  0000000000000000 ffff880813fa0300 ffff880813fa0700 
ffff8807ffd73aa0
[ 1488.561230]  ffff880800620924 ffff880800620924 ffff880800620920 
ffff880800620820
[ 1488.561552]  ffff88080fb6b1b0 ffff88080fb6b000 ffff880813fa0e80 
ffff8807f9e239a0
[ 1488.561874] Call Trace:
[ 1488.561988]  [<ffffffffa036027c>] relocate_tree_blocks+0x1c0/0x544 
[btrfs]
[ 1488.562103]  [<ffffffffa0303fdb>] ? btrfs_release_path+0x6b/0x8a 
[btrfs]
[ 1488.562222]  [<ffffffffa0361423>] relocate_block_group+0x23f/0x503 
[btrfs]
[ 1488.562340]  [<ffffffffa0361834>] 
btrfs_relocate_block_group+0x14d/0x281 [btrfs]
[ 1488.562514]  [<ffffffffa0341124>] 
btrfs_relocate_chunk.isra.66+0x58/0x60e [btrfs]
[ 1488.562686]  [<ffffffffa034e39c>] ? 
btrfs_set_lock_blocking_rw+0x89/0xb5 [btrfs]
[ 1488.562853]  [<ffffffffa0303ee9>] ? btrfs_set_path_blocking+0x23/0x54 
[btrfs]
[ 1488.562968]  [<ffffffffa030871a>] ? btrfs_search_slot+0x718/0x772 
[btrfs]
[ 1488.563088]  [<ffffffffa033d432>] ? free_extent_buffer+0x77/0x7c 
[btrfs]
[ 1488.563208]  [<ffffffffa034383b>] btrfs_shrink_device+0x23c/0x3a5 
[btrfs]
[ 1488.563327]  [<ffffffffa034688c>] btrfs_rm_device+0x292/0x68f [btrfs]
[ 1488.563445]  [<ffffffffa034cceb>] btrfs_ioctl+0x918/0x18f9 [btrfs]
[ 1488.563554]  [<ffffffff81164636>] ? avc_has_perm_flags+0x32/0xf7
[ 1488.563663]  [<ffffffff8102e937>] ? __do_page_fault+0x34f/0x3f3
[ 1488.563772]  [<ffffffff810fd6fd>] vfs_ioctl+0x21/0x34
[ 1488.563877]  [<ffffffff810fdf4f>] do_vfs_ioctl+0x3b1/0x3f4
[ 1488.563984]  [<ffffffff810fdfe4>] SyS_ioctl+0x52/0x82
[ 1488.564091]  [<ffffffff8137dad2>] system_call_fastpath+0x16/0x1b
[ 1488.564195] Code: 60 71 fd 49 89 40 50 49 89 40 58 49 8b 40 58 4d 89 
68 58 49 83 c0 50 4d 89 45 00 49 89 45 08 4c 89 28 e9 aa 00 00 00 a8 10 
75 02 <0f> 0b 83 e0 01 41 39 c4 74 02 0f 0b 45 85 e4 75 32 49 8b 70 18
[ 1488.567049] RIP  [<ffffffffa035f729>] build_backref_tree+0xb10/0xe91 
[btrfs]
[ 1488.567207]  RSP <ffff8807f9e23928>
[ 1488.567325] ---[ end trace 1c4992d3332e9f0f ]---



-- 
Tomasz Chmielewski

