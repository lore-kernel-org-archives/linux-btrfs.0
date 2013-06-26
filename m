Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:43815 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3FZO2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 10:28:25 -0400
Received: by mail-lb0-f172.google.com with SMTP id v20so1532693lbc.31
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jun 2013 07:28:23 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 26 Jun 2013 16:28:23 +0200
Message-ID: <CAOEw3RZjcyY7LzM7QRx=swubkK-qMGVwK3Y-Fc4uhSaqgW2jFQ@mail.gmail.com>
Subject: Btrfs segfault while trying to reproduce defrag bug
From: =?ISO-8859-2?Q?Ond=F8ej_Kunc?= <kunc88@gmail.com>
To: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

I was trying to reproduce defrag bug to create testcase, which can
check if patch https://patchwork.kernel.org/patch/2782621/ helps to
mitigiate this bug https://bugzilla.kernel.org/show_bug.cgi?id=59451.

But I think, that I discovered another bug, or this is the cause of
it, because the second stacktrace is very similar to previous problem.
I'm sending trace just for your information ... now I'm going to try
it with the patch.

I was trying to do simultaneously this:

btrfs device delete /dev/md3

find -xdev -type f -exec btrfs fi defrag -clzo '{}' \;

And later I run this: (previous actions did not finish yet)
find -xdev -type f -exec btrfs fi defrag -czlib '{}' \;

Best Regards

Ondrej

Hope this will help to find exact cause of that problem.

[235525.791962] ------------[ cut here ]------------
[235525.795731] kernel BUG at
/build/linux-eHaf39/linux-3.9.6/fs/btrfs/relocation.c:4404!
[235525.799553] invalid opcode: 0000 [#1] SMP
[235525.803395] Modules linked in: netconsole configfs fuse ufs qnx4
hfsplus hfs minix ntfs vfat msdos fat jfs xfs reiserfs ext3 jbd ext2
efivars iptable_filter ip_tables x_tables nfsd auth_rpcgss nfs_acl nfs
lockd dns_resolver fscache sunrpc loop raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx mperf coretemp kvm_intel kvm
snd_pcm snd_page_alloc snd_timer radeon crc32c_intel
ghash_clmulni_intel aesni_intel aes_x86_64 ablk_helper cryptd snd xts
ttm lrw gf128mul soundcore drm_kms_helper psmouse drm iTCO_wdt
iTCO_vendor_support i2c_algo_bit i2c_core lpc_ich microcode pcspkr
i7core_edac serio_raw mfd_core hpilo processor edac_core button hpwdt
acpi_power_meter joydev evdev ext4 crc16 jbd2 mbcache btrfs xor
zlib_deflate raid6_pq crc32c libcrc32c dm_mod raid1 md_mod sd_mod
crc_t10dif hid_generic usbhid hid sg uhci_hcd ehci_pci ehci_hcd
thermal thermal_sys usbcore usb_common bnx2 mpt2sas raid_class
scsi_transport_sas hpsa scsi_mod [last unloaded: configfs]
[235525.838839] CPU 3
[235525.838878] Pid: 22288, comm: btrfs Not tainted 3.9-1-amd64 #1
Debian 3.9.6-1 HP ProLiant DL380 G7
[235525.848158] RIP: 0010:[<ffffffffa023e633>]  [<ffffffffa023e633>]
btrfs_reloc_cow_block+0xe8/0x1af [btrfs]
[235525.852977] RSP: 0018:ffff88008c4638b8  EFLAGS: 00010287
[235525.857747] RAX: ffff8807af940ac0 RBX: ffff8811700cb800 RCX:
ffff88109f05d120
[235525.862531] RDX: 0000031c9d931000 RSI: ffff8811700cb800 RDI:
0000001175f94000
[235525.867280] RBP: 0000000000000004 R08: 0000000000001000 R09:
0000031c9d931000
[235525.872024] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff88109f05d120
[235525.876748] R13: ffffea003d1ce800 R14: ffff880d79e8d300 R15:
ffff880587bb6800
[235525.881440] FS:  00007f5296e74760(0000) GS:ffff88121f860000(0000)
knlGS:0000000000000000
[235525.886154] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[235525.890863] CR2: 00007f4e284458e0 CR3: 000000008100d000 CR4:
00000000000007e0
[235525.895613] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[235525.900458] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[235525.905087] Process btrfs (pid: 22288, threadinfo
ffff88008c462000, task ffff880c4b83a830)
[235525.909763] Stack:
[235525.914389]  ffff880a4187c630 00000000a01e6493 ffff880a4187c630
ffff8811700cb800
[235525.919100]  ffff88109f05d120 ffff880d79e8d300 ffff880a4187c630
0000000000000000
[235525.923779]  0000000000000000 ffffffffa01e66a6 0000000000000004
0000031c80000000
[235525.928422] Call Trace:
[235525.932996]  [<ffffffffa01e66a6>] ? __btrfs_cow_block+0x1de/0x381 [btrfs]
[235525.937594]  [<ffffffffa01e696b>] ? btrfs_cow_block+0xe7/0x13b [btrfs]
[235525.942150]  [<ffffffffa01e9687>] ? btrfs_search_slot+0x251/0x556 [btrfs]
[235525.946667]  [<ffffffffa01f1249>] ? can_overcommit+0x9a/0xe7 [btrfs]
[235525.951144]  [<ffffffffa023a98b>] ? do_relocation+0x100/0x3e5 [btrfs]
[235525.955574]  [<ffffffffa023963f>] ?
calcu_metadata_size.isra.33+0x9c/0xb4 [btrfs]
[235525.959988]  [<ffffffffa01ec330>] ? block_rsv_add_bytes+0x1b/0x49 [btrfs]
[235525.964372]  [<ffffffffa023d193>] ? relocate_tree_blocks+0x2d8/0x485 [btrfs]
[235525.968723]  [<ffffffffa01e5c10>] ? btrfs_release_path+0x38/0x53 [btrfs]
[235525.973031]  [<ffffffffa023dc39>] ? relocate_block_group+0x237/0x4eb [btrfs]
[235525.977356]  [<ffffffffa023e033>] ?
btrfs_relocate_block_group+0x146/0x26d [btrfs]
[235525.981702]  [<ffffffffa021f67a>] ?
btrfs_relocate_chunk.isra.57+0x50/0x3f6 [btrfs]
[235525.986051]  [<ffffffffa01e40ed>] ? btrfs_item_key_to_cpu+0x12/0x30 [btrfs]
[235525.990383]  [<ffffffffa0214e67>] ? btrfs_get_token_64+0x76/0xc6 [btrfs]
[235525.994701]  [<ffffffffa0217669>] ?
release_extent_buffer.isra.19+0x90/0x97 [btrfs]
[235525.999090]  [<ffffffffa02218aa>] ? btrfs_shrink_device+0x1f8/0x35e [btrfs]
[235526.003527]  [<ffffffffa0224380>] ? btrfs_rm_device+0x2b8/0x690 [btrfs]
[235526.007965]  [<ffffffffa022a634>] ? btrfs_ioctl+0x8ec/0x1870 [btrfs]
[235526.012341]  [<ffffffff810e0fac>] ? handle_mm_fault+0x1f1/0x238
[235526.016675]  [<ffffffff8138a038>] ? __do_page_fault+0x32d/0x3cb
[235526.020893]  [<ffffffff8111729f>] ? vfs_ioctl+0x1b/0x25
[235526.025140]  [<ffffffff81117ac0>] ? do_vfs_ioctl+0x3e8/0x42a
[235526.029132]  [<ffffffff81117b4f>] ? sys_ioctl+0x4d/0x7a
[235526.033005]  [<ffffffff8138c1a9>] ? system_call_fastpath+0x16/0x1b
[235526.036781] Code: e8 75 11 be 30 11 00 00 48 c7 c7 56 03 26 a0 e8
b2 ec df e0 48 63 c5 49 8b 16 49 8b 44 c7 28 48 39 50 18 74 08 48 39
50 20 74 02 <0f> 0b 48 89 c7 48 89 04 24 e8 be bc ff ff 4c 89 e7 e8 5e
a4 ff
[235526.044707] RIP  [<ffffffffa023e633>]
btrfs_reloc_cow_block+0xe8/0x1af [btrfs]
[235526.048479]  RSP <ffff88008c4638b8>
[235526.067280] ---[ end trace 25d51b936b37cc50 ]---
[235896.880643] ------------[ cut here ]------------
[235896.884227] kernel BUG at
/build/linux-eHaf39/linux-3.9.6/fs/btrfs/relocation.c:4391!
[235896.887936] invalid opcode: 0000 [#2] SMP
[235896.891505] Modules linked in: netconsole configfs fuse ufs qnx4
hfsplus hfs minix ntfs vfat msdos fat jfs xfs reiserfs ext3 jbd ext2
efivars iptable_filter ip_tables x_tables nfsd auth_rpcgss nfs_acl nfs
lockd dns_resolver fscache sunrpc loop raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx mperf coretemp kvm_intel kvm
snd_pcm snd_page_alloc snd_timer radeon crc32c_intel
ghash_clmulni_intel aesni_intel aes_x86_64 ablk_helper cryptd snd xts
ttm lrw gf128mul soundcore drm_kms_helper psmouse drm iTCO_wdt
iTCO_vendor_support i2c_algo_bit i2c_core lpc_ich microcode pcspkr
i7core_edac serio_raw mfd_core hpilo processor edac_core button hpwdt
acpi_power_meter joydev evdev ext4 crc16 jbd2 mbcache btrfs xor
zlib_deflate raid6_pq crc32c libcrc32c dm_mod raid1 md_mod sd_mod
crc_t10dif hid_generic usbhid hid sg uhci_hcd ehci_pci ehci_hcd
thermal thermal_sys usbcore usb_common bnx2 mpt2sas raid_class
scsi_transport_sas hpsa scsi_mod [last unloaded: configfs]
[235896.924753] CPU 3
[235896.924793] Pid: 14094, comm: btrfs-endio-wri Tainted: G      D
  3.9-1-amd64 #1 Debian 3.9.6-1 HP ProLiant DL380 G7
[235896.933503] RIP: 0010:[<ffffffffa023e592>]  [<ffffffffa023e592>]
btrfs_reloc_cow_block+0x47/0x1af [btrfs]
[235896.937999] RSP: 0018:ffff88007438b9b0  EFLAGS: 00010246
[235896.942418] RAX: ffff8811c9e0e000 RBX: ffff8811c9e4d000 RCX:
ffff8800b4e0ddc0
[235896.946890] RDX: ffff8809d1126cb0 RSI: ffff8811c9e4d000 RDI:
ffff880b19ce2770
[235896.951331] RBP: ffff8800b4e0ddc0 R08: ffff88007438ba38 R09:
ffff8809d1126d88
[235896.955741] R10: 0000000000001000 R11: 0000160000000000 R12:
ffff8800b4e0ddc0
[235896.960139] R13: ffff880b19ce2770 R14: ffff8809d1126cb0 R15:
ffff880587bb6800
[235896.964551] FS:  0000000000000000(0000) GS:ffff88121f860000(0000)
knlGS:0000000000000000
[235896.969018] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[235896.973482] CR2: 000000000261a698 CR3: 000000000160c000 CR4:
00000000000007e0
[235896.977997] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[235896.982488] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[235896.986935] Process btrfs-endio-wri (pid: 14094, threadinfo
ffff88007438a000, task ffff8810415e7100)
[235896.991451] Stack:
[235896.995916]  ffff880b19ce2770 ffffffffa01e6493 ffff880b19ce2770
ffff8811c9e4d000
[235897.000523]  ffff8800b4e0ddc0 ffff8809d1126cb0 ffff880b19ce2770
0000000000000000
[235897.005115]  0000000000000000 ffffffffa01e66a6 ffff880000000002
000002f880000000
[235897.009720] Call Trace:
[235897.014410]  [<ffffffffa01e6493>] ? update_ref_for_cow+0x224/0x259 [btrfs]
[235897.019028]  [<ffffffffa01e66a6>] ? __btrfs_cow_block+0x1de/0x381 [btrfs]
[235897.023626]  [<ffffffffa01e696b>] ? btrfs_cow_block+0xe7/0x13b [btrfs]
[235897.028203]  [<ffffffffa01e9687>] ? btrfs_search_slot+0x251/0x556 [btrfs]
[235897.032768]  [<ffffffff810fa603>] ? kmem_cache_free+0x40/0x7d
[235897.037348]  [<ffffffffa01f97ba>] ?
btrfs_lookup_file_extent+0x33/0x38 [btrfs]
[235897.041967]  [<ffffffffa021275a>] ? __btrfs_drop_extents+0x134/0x84f [btrfs]
[235897.046598]  [<ffffffffa01feb62>] ? btrfs_buffer_uptodate+0x3b/0x4f [btrfs]
[235897.051234]  [<ffffffff810fc1fc>] ? kmem_cache_alloc+0x8c/0xfd
[235897.055895]  [<ffffffffa021373a>] ? btrfs_drop_extents+0x63/0x81 [btrfs]
[235897.060591]  [<ffffffffa020c912>] ?
relink_extent_backref+0x29e/0x631 [btrfs]
[235897.065307]  [<ffffffffa0204d88>] ? record_extent_backrefs+0x4c/0x8c [btrfs]
[235897.069916]  [<ffffffffa020d31c>] ?
btrfs_finish_ordered_io+0x677/0x75b [btrfs]
[235897.074422]  [<ffffffffa0225e7e>] ? worker_loop+0x171/0x4a7 [btrfs]
[235897.078876]  [<ffffffffa0225d0d>] ? btrfs_queue_worker+0x26f/0x26f [btrfs]
[235897.083300]  [<ffffffff8105776d>] ? kthread+0x7d/0x85
[235897.087708]  [<ffffffff810576f0>] ? __kthread_parkme+0x59/0x59
[235897.092120]  [<ffffffff8138c0fc>] ? ret_from_fork+0x7c/0xb0
[235897.096481]  [<ffffffff810576f0>] ? __kthread_parkme+0x59/0x59
[235897.100802] Code: 10 4c 8b b8 98 10 00 00 4d 85 ff 0f 84 73 01 00
00 41 80 bf c0 05 00 00 01 49 89 d6 49 89 cc 75 0c 48 83 be d7 01 00
00 f7 75 02 <0f> 0b 4d 8b ae d0 00 00 00 4c 89 ef e8 e5 ab ff ff 48 bf
00 00
[235897.110054] RIP  [<ffffffffa023e592>]
btrfs_reloc_cow_block+0x47/0x1af [btrfs]
[235897.114383]  RSP <ffff88007438b9b0>
[235897.118606] ---[ end trace 25d51b936b37cc51 ]---

--
Ondøej Kunc
