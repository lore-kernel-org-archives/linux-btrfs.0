Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gremlin.yadt.co.uk ([149.255.108.98]:59549 "EHLO
	gremlin.yadt.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab3JFTRD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Oct 2013 15:17:03 -0400
Received: from localhost (localhost [127.0.0.1])
	by gremlin.yadt.co.uk (Postfix) with ESMTP id 2949B1A7DA
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Oct 2013 20:11:53 +0100 (BST)
Received: from gremlin.yadt.co.uk ([127.0.0.1])
	by localhost (gremlin.yadt.co.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kv8G46GdueXl for <linux-btrfs@vger.kernel.org>;
	Sun,  6 Oct 2013 20:11:49 +0100 (BST)
Date: Sun, 6 Oct 2013 20:11:49 +0100
From: David Taylor <davidt-linux-btrfs@yadt.co.uk>
To: Linux Btrfs Mailing List <linux-btrfs@vger.kernel.org>
Subject: defrag - kernel BUG at fs/btrfs/locking.c:264!
Message-ID: <20131006191149.GA16097@yadt.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Whilst running a recursive defrag with -czlib (to compress some files copied when I forgot
to mount the filesystem with -o compress=zlib), I encountered the BUG below.  The
btrfs defrag command then hung, as did other attempts to use the filesystem.  Shortly afterwards
the entire system locked up.  I think I have encountered this twice now, but the first time
the system locked up whilst I was out and I was unable to check dmesg.

This is on linux-3.12-rc3 with up-to-date git btrfs-progs.  I'm also using the 'experimental'
dedup-syscall git branch of bedup.

[ 7815.359821] ------------[ cut here ]------------
[ 7815.361458] WARNING: CPU: 3 PID: 3640 at fs/btrfs/locking.c:46 btrfs_set_lock_blocking_rw+0x6c/0xdc [btrfs]()
[ 7815.362981] Modules linked in: parport_pc bnep rfcomm ppdev bluetooth rfkill sp5100_tco i2c_piix4 edac_mce_amd edac_core ehci_pci ohci_pci ohci_hcd ehci_hcd serio_raw k10temp evdev acpi_cpufreq asus_atk0110 processor lp parport loop btrfs crc32c libcrc32c ext4 crc16 jbd2 mbcache raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid0 multipath linear raid1 raid10 md_mod dm_mod sd_mod sr_mod crc_t10dif crct10dif_common cdrom ata_generic ahci pata_jmicron libahci firewire_ohci xhci_hcd firewire_core libata crc_itu_t scsi_mod usbcore usb_common nouveau mxm_wmi video i2c_algo_bit ttm drm_kms_helper r8169 mii drm i2c_core thermal_sys wmi button
[ 7815.368026] CPU: 3 PID: 3640 Comm: btrfs Not tainted 3.12.0-rc3-yadt #1
[ 7815.369613] Hardware name: System manufacturer System Product Name/M4A89GTD-PRO/USB3, BIOS 1703    11/16/2010
[ 7815.371176]  0000000000000000 ffffffff8136c8ad 0000000000000000 ffffffff8103612b
[ 7815.372759]  ffffffffa03d3820 ffff8801604a71e0 ffff8801604a71e0 0000000000000001
[ 7815.374424]  ffff880225766000 ffffffffa03d3820 0000000000000000 ffff8801604a71e0
[ 7815.376026] Call Trace:
[ 7815.377665]  [<ffffffff8136c8ad>] ? dump_stack+0x41/0x51
[ 7815.379313]  [<ffffffff8103612b>] ? warn_slowpath_common+0x74/0x89
[ 7815.380962]  [<ffffffffa03d3820>] ? btrfs_set_lock_blocking_rw+0x6c/0xdc [btrfs]
[ 7815.382661]  [<ffffffffa03d3820>] ? btrfs_set_lock_blocking_rw+0x6c/0xdc [btrfs]
[ 7815.384332]  [<ffffffffa038dc4c>] ? btrfs_realloc_node+0xd0/0x371 [btrfs]
[ 7815.386001]  [<ffffffffa038a4e5>] ? btrfs_node_key_to_cpu+0x12/0x30 [btrfs]
[ 7815.387677]  [<ffffffffa03bb0de>] ? btrfs_defrag_leaves+0x232/0x2e4 [btrfs]
[ 7815.389359]  [<ffffffffa03aafb6>] ? btrfs_defrag_root+0x54/0xb6 [btrfs]
[ 7815.391009]  [<ffffffffa03d0c17>] ? btrfs_ioctl_defrag+0x75/0x140 [btrfs]
[ 7815.392627]  [<ffffffffa03d18fa>] ? btrfs_ioctl+0x822/0x2030 [btrfs]
[ 7815.394162]  [<ffffffff810c7ff6>] ? get_page+0x9/0x25
[ 7815.395650]  [<ffffffff810c802c>] ? __lru_cache_add+0x1a/0x38
[ 7815.397124]  [<ffffffff810dc8fb>] ? handle_mm_fault+0x881/0x8a6
[ 7815.398575]  [<ffffffff81373559>] ? __do_page_fault+0x348/0x3e8
[ 7815.400053]  [<ffffffff8110e542>] ? do_filp_open+0x2b/0x6f
[ 7815.401510]  [<ffffffff8110f63f>] ? vfs_ioctl+0x1b/0x28
[ 7815.402985]  [<ffffffff8110fe0b>] ? do_vfs_ioctl+0x3ab/0x3ee
[ 7815.404405]  [<ffffffff8110fe9c>] ? SyS_ioctl+0x4e/0x7a
[ 7815.405822]  [<ffffffff81375622>] ? system_call_fastpath+0x16/0x1b
[ 7815.407231] ---[ end trace 66d49a7250b29fb0 ]---
[ 7815.408697] ------------[ cut here ]------------
[ 7815.410077] kernel BUG at fs/btrfs/locking.c:264!
[ 7815.411528] invalid opcode: 0000 [#1] SMP
[ 7815.412935] Modules linked in: parport_pc bnep rfcomm ppdev bluetooth rfkill sp5100_tco i2c_piix4 edac_mce_amd edac_core ehci_pci ohci_pci ohci_hcd ehci_hcd serio_raw k10temp evdev acpi_cpufreq asus_atk0110 processor lp parport loop btrfs crc32c libcrc32c ext4 crc16 jbd2 mbcache raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid0 multipath linear raid1 raid10 md_mod dm_mod sd_mod sr_mod crc_t10dif crct10dif_common cdrom ata_generic ahci pata_jmicron libahci firewire_ohci xhci_hcd firewire_core libata crc_itu_t scsi_mod usbcore usb_common nouveau mxm_wmi video i2c_algo_bit ttm drm_kms_helper r8169 mii drm i2c_core thermal_sys wmi button
[ 7815.417766] CPU: 3 PID: 3640 Comm: btrfs Tainted: G        W    3.12.0-rc3-yadt #1
[ 7815.419259] Hardware name: System manufacturer System Product Name/M4A89GTD-PRO/USB3, BIOS 1703    11/16/2010
[ 7815.420845] task: ffff88022565e7b0 ti: ffff880044268000 task.ti: ffff880044268000
[ 7815.422373] RIP: 0010:[<ffffffffa03d371b>]  [<ffffffffa03d371b>] btrfs_assert_tree_locked+0x7/0xa [btrfs]
[ 7815.424003] RSP: 0018:ffff880044269c08  EFLAGS: 00010246
[ 7815.425580] RAX: 0000000000000000 RBX: ffff8801604a71e0 RCX: 0000000000000007
[ 7815.427161] RDX: 0000000000000006 RSI: 00000000ffffffff RDI: ffff8801604a71e0
[ 7815.428746] RBP: ffff8801604a71e0 R08: 0000000000000000 R09: 0000000000000000
[ 7815.430279] R10: ffff880200000000 R11: 000000000001205c R12: 0000000000000001
[ 7815.431762] R13: ffff880225766000 R14: 0000000000000000 R15: 0000000000000000
[ 7815.433189] FS:  00007f878c9ed780(0000) GS:ffff88022fcc0000(0000) knlGS:0000000000000000
[ 7815.434700] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 7815.436201] CR2: 000000000275d868 CR3: 000000002b9f0000 CR4: 00000000000007e0
[ 7815.437696] Stack:
[ 7815.439139]  ffffffffa03d3831 0000000000000000 ffff8801604a71e0 0000000000000000
[ 7815.440600]  ffffffffa038dc4c 0000000000000002 ffff880044269cff ffffffffa038a4e5
[ 7815.442090]  0000100000000002 010000000000003c 0000000000000000 ffff8801492da5b0
[ 7815.443544] Call Trace:
[ 7815.445105]  [<ffffffffa03d3831>] ? btrfs_set_lock_blocking_rw+0x7d/0xdc [btrfs]
[ 7815.446645]  [<ffffffffa038dc4c>] ? btrfs_realloc_node+0xd0/0x371 [btrfs]
[ 7815.448177]  [<ffffffffa038a4e5>] ? btrfs_node_key_to_cpu+0x12/0x30 [btrfs]
[ 7815.449675]  [<ffffffffa03bb0de>] ? btrfs_defrag_leaves+0x232/0x2e4 [btrfs]
[ 7815.451194]  [<ffffffffa03aafb6>] ? btrfs_defrag_root+0x54/0xb6 [btrfs]
[ 7815.452743]  [<ffffffffa03d0c17>] ? btrfs_ioctl_defrag+0x75/0x140 [btrfs]
[ 7815.454292]  [<ffffffffa03d18fa>] ? btrfs_ioctl+0x822/0x2030 [btrfs]
[ 7815.455784]  [<ffffffff810c7ff6>] ? get_page+0x9/0x25
[ 7815.457263]  [<ffffffff810c802c>] ? __lru_cache_add+0x1a/0x38
[ 7815.458725]  [<ffffffff810dc8fb>] ? handle_mm_fault+0x881/0x8a6
[ 7815.460183]  [<ffffffff81373559>] ? __do_page_fault+0x348/0x3e8
[ 7815.461676]  [<ffffffff8110e542>] ? do_filp_open+0x2b/0x6f
[ 7815.463131]  [<ffffffff8110f63f>] ? vfs_ioctl+0x1b/0x28
[ 7815.464610]  [<ffffffff8110fe0b>] ? do_vfs_ioctl+0x3ab/0x3ee
[ 7815.466023]  [<ffffffff8110fe9c>] ? SyS_ioctl+0x4e/0x7a
[ 7815.467450]  [<ffffffff81375622>] ? system_call_fastpath+0x16/0x1b
[ 7815.468867] Code: fa ff ff 65 48 8b 04 25 80 b9 00 00 8b 80 2c 02 00 00 89 43 50 48 83 c4 30 5b 5d 41 5c 41 5d 41 5e 41 5f c3 8b 47 54 85 c0 75 02 <0f> 0b c3 55 53 8b 6f 5c 48 89 fb 83 fd 01 7e 02 0f 0b e8 e2 ff
[ 7815.470615] RIP  [<ffffffffa03d371b>] btrfs_assert_tree_locked+0x7/0xa [btrfs]
[ 7815.472213]  RSP <ffff880044269c08>
[ 7815.479107] ---[ end trace 66d49a7250b29fb1 ]---

-- 
David Taylor
