Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57974 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaJIOTr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Oct 2014 10:19:47 -0400
Date: Thu, 9 Oct 2014 16:19:44 +0200
From: Petr Janecek <janecek@ucw.cz>
To: linux-btrfs@vger.kernel.org
Subject: btrfs balance segfault, kernel BUG at fs/btrfs/extent-tree.c:7727
Message-ID: <20141009141944.GA11525@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

  I have trouble finishing btrfs balance on five disk raid10 fs.
I added a disk to 4x3TB raid10 fs and run "btrfs balance start
/mnt/b3", which segfaulted after few hours, probably because of the BUG
below. "btrfs check" does not find any errors, both before the balance
and after reboot (the fs becomes un-umountable).

This was second attempt of balance run, the first one ended the same,
see Comment 10 on bugzilla https://bugzilla.kernel.org/show_bug.cgi?id=64961

There are ~7.5M files on /mnt/b3; one subvolume with 4.8M files has been
snapshot 85 times.

root@fs0:~# uname -a
Linux fs0 3.17.0 #10 SMP Mon Oct 6 11:31:13 CEST 2014 x86_64 GNU/Linux
root@fs0:~# btrfs fi show /mnt/b3
Label: 'BTR3'  uuid: f181dd81-c219-44fc-b113-3a8cfd0d3295
	Total devices 5 FS bytes used 2.35TiB
	devid    1 size 2.73TiB used 1.05TiB path /dev/sde
	devid    2 size 2.73TiB used 1.05TiB path /dev/sdf
	devid    3 size 2.73TiB used 1.05TiB path /dev/sdg
	devid    4 size 2.73TiB used 1.05TiB path /dev/sdh
	devid    5 size 3.64TiB used 524.03GiB path /dev/sdp

Btrfs v3.16
root@fs0:~# btrfs fi df /mnt/b3
Data, RAID10: total=2.34TiB, used=2.34TiB
System, RAID1: total=32.00MiB, used=304.00KiB
Metadata, RAID1: total=15.00GiB, used=13.75GiB
unknown, single: total=512.00MiB, used=496.00KiB


[22717.728944] BTRFS info (device sdp): relocating block group 2777799458816 flags 65
[22735.276539] BTRFS info (device sdp): found 60187 extents
[22744.233882] ------------[ cut here ]------------
[22744.238559] WARNING: CPU: 0 PID: 4211 at fs/btrfs/extent-tree.c:876 btrfs_lookup_extent_info+0x292/0x30a [btrfs]()
[22744.248953] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc xfs libcrc32c loop raid10 md_mod iTCO_wdt x86_pkg_temp_thermal coretemp kvm_intel kvm crc32_pclmul ghash_clmulni_intel iTCO_vendor_support aesni_intel aes_x86_64 ablk_helper cryptd lrw gf128mul glue_helper lpc_ich mfd_core i2c_i801 i2c_core pcspkr psmouse evdev microcode serio_raw battery ipmi_si ipmi_msghandler video tpm_tis tpm button acpi_cpufreq processor ie31200_edac edac_core btrfs xor raid6_pq sg sd_mod uas usb_storage hid_generic usbhid hid ahci libahci mpt2sas raid_class libata scsi_transport_sas crc32c_intel ehci_pci e1000e ehci_hcd ptp pps_core scsi_mod thermal fan thermal_sys usbcore usb_common
[22744.312827] CPU: 0 PID: 4211 Comm: btrfs Not tainted 3.17.0 #10
[22744.318770] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.0a 06/08/2012
[22744.326475]  0000000000000000 0000000000000009 ffffffff813a6a46 0000000000000000
[22744.333983]  ffffffff8103b591 0000000000000000 ffffffffc0593cc4 ffff88027beef380
[22744.341503]  ffff88028da8ff50 0000000000000000 0000000000000000 ffff880136d1a000
[22744.349019] Call Trace:
[22744.351493]  [<ffffffff813a6a46>] ? dump_stack+0x41/0x51
[22744.356827]  [<ffffffff8103b591>] ? warn_slowpath_common+0x78/0x90
[22744.363037]  [<ffffffffc0593cc4>] ? btrfs_lookup_extent_info+0x292/0x30a [btrfs]
[22744.370471]  [<ffffffffc0593cc4>] ? btrfs_lookup_extent_info+0x292/0x30a [btrfs]
[22744.377912]  [<ffffffffc059438f>] ? walk_down_proc+0xaf/0x1e3 [btrfs]
[22744.384373]  [<ffffffff8110bc2a>] ? kmem_cache_alloc+0x91/0x104
[22744.390321]  [<ffffffffc05965b8>] ? walk_down_tree+0x40/0xa9 [btrfs]
[22744.396706]  [<ffffffffc0598f3e>] ? btrfs_drop_snapshot+0x2c4/0x656 [btrfs]
[22744.403702]  [<ffffffffc05e6297>] ? merge_reloc_roots+0xf0/0x1ca [btrfs]
[22744.410434]  [<ffffffffc05e6972>] ? relocate_block_group+0x445/0x4bd [btrfs]
[22744.417520]  [<ffffffffc05e6b39>] ? btrfs_relocate_block_group+0x14f/0x267 [btrfs]
[22744.425138]  [<ffffffffc05c56b7>] ? btrfs_relocate_chunk.isra.58+0x58/0x5e2 [btrfs]
[22744.432862]  [<ffffffffc0586786>] ? btrfs_item_key_to_cpu+0x12/0x30 [btrfs]
[22744.439851]  [<ffffffffc05ba695>] ? btrfs_get_token_64+0x76/0xc6 [btrfs]
[22744.446590]  [<ffffffffc05c190b>] ? release_extent_buffer+0x9d/0xa4 [btrfs]
[22744.453585]  [<ffffffffc05c8186>] ? btrfs_balance+0x9b0/0xb9d [btrfs]
[22744.460064]  [<ffffffffc05cf646>] ? btrfs_ioctl_balance+0x21a/0x297 [btrfs]
[22744.467057]  [<ffffffffc05d2462>] ? btrfs_ioctl+0x10f4/0x20a5 [btrfs]
[22744.473531]  [<ffffffff81121b9e>] ? path_openat+0x233/0x4c5
[22744.479129]  [<ffffffff81030620>] ? __do_page_fault+0x339/0x3df
[22744.485072]  [<ffffffff810f2b9c>] ? __vma_link_rb+0x58/0x73
[22744.490668]  [<ffffffff810f2c22>] ? vma_link+0x6b/0x8a
[22744.495824]  [<ffffffff811237f8>] ? do_vfs_ioctl+0x3ec/0x435
[22744.501509]  [<ffffffff8105b9e0>] ? vtime_account_user+0x35/0x40
[22744.507539]  [<ffffffff8112388a>] ? SyS_ioctl+0x49/0x77
[22744.512781]  [<ffffffff813aafac>] ? tracesys+0x7e/0xe2
[22744.517935]  [<ffffffff813ab00b>] ? tracesys+0xdd/0xe2
[22744.523092] ---[ end trace fac5e12cd6384894 ]---
22744.527735] ------------[ cut here ]------------
[22744.532378] kernel BUG at fs/btrfs/extent-tree.c:7727!
[22744.537532] invalid opcode: 0000 [#1] SMP 
[22744.541684] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc xfs libcrc32c loop raid10 md_mod iTCO_wdt x86_pkg_temp_thermal coretemp kvm_intel kvm crc32_pclmul ghash_clmulni_intel iTCO_vendor_support aesni_intel aes_x86_64 ablk_helper cryptd lrw gf128mul glue_helper lpc_ich mfd_core i2c_i801 i2c_core pcspkr psmouse evdev microcode serio_raw battery ipmi_si ipmi_msghandler video tpm_tis tpm button acpi_cpufreq processor ie31200_edac edac_core btrfs xor raid6_pq sg sd_mod uas usb_storage hid_generic usbhid hid ahci libahci mpt2sas raid_class libata scsi_transport_sas crc32c_intel ehci_pci e1000e ehci_hcd ptp pps_core scsi_mod thermal fan thermal_sys usbcore usb_common
[22744.605414] CPU: 0 PID: 4211 Comm: btrfs Tainted: G        W      3.17.0 #10
[22744.612491] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.0a 06/08/2012
[22744.620185] task: ffff8800d265b2d0 ti: ffff8802c7608000 task.ti: ffff8802c7608000
[22744.627707] RIP: 0010:[<ffffffffc05943a5>]  [<ffffffffc05943a5>] walk_down_proc+0xc5/0x1e3 [btrfs]
[22744.636726] RSP: 0018:ffff8802c760b908  EFLAGS: 00010246
[22744.647531] RAX: 0000000000000000 RBX: ffff88018b980e70 RCX: 0000000000000007
[22744.654697] RDX: 0000000000000056 RSI: ffff88028da8ff50 RDI: ffff8800373d9400
[22744.661853] RBP: ffff88027beef380 R08: 0000000000000000 R09: 000000000000bd96
[22744.669010] R10: 0000000000000000 R11: 000000000000bd96 R12: 0000000000000002
[22744.676176] R13: ffff880136d1a000 R14: ffff88040d51e400 R15: 0000000000000002
[22744.683333] FS:  00007fa1217c9880(0000) GS:ffff88041fc00000(0000) knlGS:0000000000000000
[22744.691460] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[22744.697222] CR2: 00007f1f93f9c020 CR3: 000000011869a000 CR4: 00000000001407f0
[22744.704380] Stack:
[22744.706416]  ffff88040d51e450 ffffffff8110bc2a 0000000000000000 ffff8803325a8d40
[22744.713927]  0000000000000001 ffff88027beef380 0000000000000002 ffff88040d51e400
[22744.721449]  ffff8803325a8d40 ffff8803325a8d40 ffff880136d1a000 ffffffffc05965b8
[22744.728961] Call Trace:
[22744.731430]  [<ffffffff8110bc2a>] ? kmem_cache_alloc+0x91/0x104
[22744.737373]  [<ffffffffc05965b8>] ? walk_down_tree+0x40/0xa9 [btrfs]
[22744.743751]  [<ffffffffc0598f3e>] ? btrfs_drop_snapshot+0x2c4/0x656 [btrfs]
[22744.750744]  [<ffffffffc05e6297>] ? merge_reloc_roots+0xf0/0x1ca [btrfs]
[22744.757469]  [<ffffffffc05e6972>] ? relocate_block_group+0x445/0x4bd [btrfs]
[22744.764546]  [<ffffffffc05e6b39>] ? btrfs_relocate_block_group+0x14f/0x267 [btrfs]
[22744.772156]  [<ffffffffc05c56b7>] ? btrfs_relocate_chunk.isra.58+0x58/0x5e2 [btrfs]
[22744.779854]  [<ffffffffc0586786>] ? btrfs_item_key_to_cpu+0x12/0x30 [btrfs]
[22744.786840]  [<ffffffffc05ba695>] ? btrfs_get_token_64+0x76/0xc6 [btrfs]
[22744.793574]  [<ffffffffc05c190b>] ? release_extent_buffer+0x9d/0xa4 [btrfs]
[22744.800567]  [<ffffffffc05c8186>] ? btrfs_balance+0x9b0/0xb9d [btrfs]
[22744.807039]  [<ffffffffc05cf646>] ? btrfs_ioctl_balance+0x21a/0x297 [btrfs]
[22744.814030]  [<ffffffffc05d2462>] ? btrfs_ioctl+0x10f4/0x20a5 [btrfs]
[22744.820488]  [<ffffffff81121b9e>] ? path_openat+0x233/0x4c5
[22744.826085]  [<ffffffff81030620>] ? __do_page_fault+0x339/0x3df
[22744.832028]  [<ffffffff810f2b9c>] ? __vma_link_rb+0x58/0x73
[22744.837616]  [<ffffffff810f2c22>] ? vma_link+0x6b/0x8a
[22744.842772]  [<ffffffff811237f8>] ? do_vfs_ioctl+0x3ec/0x435
[22744.848446]  [<ffffffff8105b9e0>] ? vtime_account_user+0x35/0x40
[22744.854470]  [<ffffffff8112388a>] ? SyS_ioctl+0x49/0x77
[22744.859711]  [<ffffffff813aafac>] ? tracesys+0x7e/0xe2
[22744.864866]  [<ffffffff813ab00b>] ? tracesys+0xdd/0xe2
[22744.870020] Code: 00 00 00 4c 89 f9 4c 89 ee 48 89 04 24 48 8b 13 e8 a3 f6 ff ff 83 f8 f4 75 02 0f 0b 85 c0 0f 85 16 01 00 00 4b 83 3c fe 00 75 02 <0f> 0b 41 83 be 94 00 00 00 01 49 63 c4 75 41 49 83 3c c6 01 0f 
[22744.890261] RIP  [<ffffffffc05943a5>] walk_down_proc+0xc5/0x1e3 [btrfs]
[22744.896924]  RSP <ffff8802c760b908>
[22744.900871] ---[ end trace fac5e12cd6384895 ]---


