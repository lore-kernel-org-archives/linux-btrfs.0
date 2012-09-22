Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44263 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab2IVIq7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Sep 2012 04:46:59 -0400
Received: by vbbff1 with SMTP id ff1so4663707vbb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Sep 2012 01:46:58 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 22 Sep 2012 10:46:58 +0200
Message-ID: <CAJtJjvvuwGT_LRya2C=7SQ99HpTnm6fj=hGwa2L0iGDN0bkrJQ@mail.gmail.com>
Subject: BTRFS Volume with defect Disk
From: Harald Weber <harald.h.weber@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I have a btrfs with 4 disks. One is now defect.
When I try to mount the Volume in degraded mode my debian kernel
3.2.0-3-amd64 crashes (See at the botom).
Then i disconnected the defect drive an could mount the Volume in degraded mode.
But the comman mentioned in the btrfs wiki "btrfs device delete
missing /mnt/data/" resulted in "ERROR: error removing the device
'missing' - Invalid argument"

What can i do?

Thanks
Harald


Kernel crash:


[   70.714877] device fsid d527b2b9-11bc-4340-a676-b84a09731938 devid
2 transid 58802 /dev/sdc1
[   71.180771] btrfs: allowing degraded mounts
[  176.432549] btrfs: relocating block group 3741751181312 flags 9
[  176.977944] parent transid verify failed on 4546132668416 wanted
58638 found 24205
[  176.977950] parent transid verify failed on 4546132668416 wanted
58638 found 24205
[  176.977955] parent transid verify failed on 4546132668416 wanted
58638 found 24205
[  176.977960] parent transid verify failed on 4546132668416 wanted
58638 found 24205
[  176.977963] parent transid verify failed on 4546132668416 wanted
58638 found 24205
[  176.977966] ------------[ cut here ]------------
[  176.977989] WARNING: at
/build/buildd-linux_3.2.23-1-amd64-zj7gxu/linux-3.2.23/fs/btrfs/extent-tree.c:4771
__btrfs_free_extent+0x293/0x5c8 [btrfs]()
[  176.977992] Hardware name: P35-DS3
[  176.977993] Modules linked in: ip6table_filter ip6_tables
iptable_filter ip_tables ebtable_nat ebtables x_tables loop kvm_intel
kvm snd_hda_codec_realtek snd_hda_intel snd_hda_codec nouveau mxm_wmi
wmi video snd_hwdep snd_pcm ttm snd_page_alloc drm_kms_helper drm
i2c_algo_bit iTCO_wdt parport_pc snd_timer snd soundcore i2c_i801
i2c_core iTCO_vendor_support parport acpi_cpufreq mperf pcspkr
coretemp joydev psmouse button processor evdev thermal_sys serio_raw
ext4 crc16 jbd2 mbcache btrfs crc32c libcrc32c zlib_deflate dm_mod sg
sd_mod crc_t10dif usb_storage ata_generic usbhid hid uas pata_jmicron
ahci libahci uhci_hcd floppy ehci_hcd libata scsi_mod r8169 mii
usbcore usb_common [last unloaded: scsi_wait_scan]
[  176.978036] Pid: 2444, comm: btrfs Not tainted 3.2.0-3-amd64 #1
[  176.978038] Call Trace:
[  176.978042]  [<ffffffff81046901>] ? warn_slowpath_common+0x78/0x8c
[  176.978051]  [<ffffffffa0158ce0>] ? __btrfs_free_extent+0x293/0x5c8 [btrfs]
[  176.978060]  [<ffffffffa015bfdd>] ? run_clustered_refs+0x672/0x6aa [btrfs]
[  176.978069]  [<ffffffffa015bfc9>] ? run_clustered_refs+0x65e/0x6aa [btrfs]
[  176.978078]  [<ffffffffa015c0de>] ? btrfs_run_delayed_refs+0xc9/0x176 [btrfs]
[  176.978082]  [<ffffffff8134a1b0>] ? mutex_lock+0xd/0x2d
[  176.978093]  [<ffffffffa0169176>] ?
btrfs_commit_transaction+0xb2/0x6f9 [btrfs]
[  176.978096]  [<ffffffff8105f5f3>] ? add_wait_queue+0x3c/0x3c
[  176.978106]  [<ffffffffa0168aba>] ?
join_transaction.isra.24+0x5a/0x1f3 [btrfs]
[  176.978117]  [<ffffffffa0169bd5>] ? start_transaction+0x1ed/0x242 [btrfs]
[  176.978127]  [<ffffffffa0197f35>] ? prepare_to_relocate+0xa5/0xb2 [btrfs]
[  176.978138]  [<ffffffffa019c6dc>] ? relocate_block_group+0x3d/0x4e6 [btrfs]
[  176.978149]  [<ffffffffa017418f>] ?
btrfs_start_delalloc_inodes+0xea/0x1af [btrfs]
[  176.978151]  [<ffffffff8134470d>] ? printk+0x43/0x48
[  176.978153]  [<ffffffff81036457>] ? should_resched+0x5/0x23
[  176.978163]  [<ffffffffa019ccc4>] ?
btrfs_relocate_block_group+0x13f/0x267 [btrfs]
[  176.978174]  [<ffffffffa0183c09>] ?
btrfs_relocate_chunk.isra.44+0x4e/0x4d8 [btrfs]
[  176.978185]  [<ffffffffa018605e>] ? btrfs_shrink_device+0x1fe/0x33e [btrfs]
[  176.978187]  [<ffffffff81036457>] ? should_resched+0x5/0x23
[  176.978198]  [<ffffffffa01878fc>] ? btrfs_rm_device+0x21d/0x5b1 [btrfs]
[  176.978200]  [<ffffffff81036457>] ? should_resched+0x5/0x23
[  176.978211]  [<ffffffffa018c841>] ? btrfs_ioctl+0x71d/0xe1c [btrfs]
[  176.978213]  [<ffffffff8134dc6d>] ? do_page_fault+0x2fc/0x337
[  176.978217]  [<ffffffff81106911>] ? do_vfs_ioctl+0x459/0x49a
[  176.978220]  [<ffffffff810d4ee9>] ? do_brk+0x22d/0x280
[  176.978222]  [<ffffffff8110699d>] ? sys_ioctl+0x4b/0x72
[  176.978224]  [<ffffffff8134fc92>] ? system_call_fastpath+0x16/0x1b
[  176.978226] ---[ end trace 38356f4ae639f7ff ]---
[  176.978228] btrfs unable to find ref byte nr 4546122170368 parent 0
root 2  owner 0 offset 0
[  176.978244] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[  176.978254] IP: [<ffffffffa01824e9>]
map_private_extent_buffer+0xf/0xec [btrfs]
[  176.978271] PGD 118d6d067 PUD 118d39067 PMD 0
[  176.978279] Oops: 0000 [#1] SMP
[  176.978286] CPU 1
[  176.978289] Modules linked in: ip6table_filter ip6_tables
iptable_filter ip_tables ebtable_nat ebtables x_tables loop kvm_intel
kvm snd_hda_codec_realtek snd_hda_intel snd_hda_codec nouveau mxm_wmi
wmi video snd_hwdep snd_pcm ttm snd_page_alloc drm_kms_helper drm
i2c_algo_bit iTCO_wdt parport_pc snd_timer snd soundcore i2c_i801
i2c_core iTCO_vendor_support parport acpi_cpufreq mperf pcspkr
coretemp joydev psmouse button processor evdev thermal_sys serio_raw
ext4 crc16 jbd2 mbcache btrfs crc32c libcrc32c zlib_deflate dm_mod sg
sd_mod crc_t10dif usb_storage ata_generic usbhid hid uas pata_jmicron
ahci libahci uhci_hcd floppy ehci_hcd libata scsi_mod r8169 mii
usbcore usb_common [last unloaded: scsi_wait_scan]
[  176.978423]
[  176.978427] Pid: 2444, comm: btrfs Tainted: G        W
3.2.0-3-amd64 #1 Gigabyte Technology Co., Ltd. P35-DS3/P35-DS3
[  176.978438] RIP: 0010:[<ffffffffa01824e9>]  [<ffffffffa01824e9>]
map_private_extent_buffer+0xf/0xec [btrfs]
[  176.978455] RSP: 0018:ffff880118d3d7e8  EFLAGS: 00010296
[  176.978460] RAX: 0000000000000000 RBX: ffff880118d3d818 RCX: ffff880118d3d818
[  176.978466] RDX: 0000000000000004 RSI: 000000000000007a RDI: 0000000000000000
[  176.978471] RBP: 0000000000000065 R08: ffff880118d3d820 R09: ffff880118d3d828
[  176.978477] R10: 000000000000007a R11: 0000000000000004 R12: 000000000000007a
[  176.978482] R13: 0000000000000000 R14: ffff880117b72800 R15: 0000000000000000
[  176.978488] FS:  00007f0202fe7760(0000) GS:ffff88011fc80000(0000)
knlGS:0000000000000000
[  176.978494] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  176.978499] CR2: 0000000000000000 CR3: 0000000118d6a000 CR4: 00000000000006e0
[  176.978504] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  176.978510] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  176.978516] Process btrfs (pid: 2444, threadinfo ffff880118d3c000,
task ffff880119a96080)
[  176.978521] Stack:
[  176.978524]  0000000000000000 ffffffff8134470d 0000000000000000
0000000000000000
[  176.978534]  0000000000000065 ffffffffa017a779 0000000000000000
0000042279ff4000
[  176.978545]  0000000000000000 0000000000000002 ffff88011894beb0
00000000fffffffb
[  176.978556] Call Trace:
[  176.978560]  [<ffffffff8134470d>] ? printk+0x43/0x48
[  176.978575]  [<ffffffffa017a779>] ? btrfs_item_size+0x2c/0x61 [btrfs]
[  176.978587]  [<ffffffffa0158d20>] ? __btrfs_free_extent+0x2d3/0x5c8 [btrfs]
[  176.978601]  [<ffffffffa015bfdd>] ? run_clustered_refs+0x672/0x6aa [btrfs]
[  176.978614]  [<ffffffffa015bfc9>] ? run_clustered_refs+0x65e/0x6aa [btrfs]
[  176.978627]  [<ffffffffa015c0de>] ? btrfs_run_delayed_refs+0xc9/0x176 [btrfs]
[  176.978633]  [<ffffffff8134a1b0>] ? mutex_lock+0xd/0x2d
[  176.978647]  [<ffffffffa0169176>] ?
btrfs_commit_transaction+0xb2/0x6f9 [btrfs]
[  176.978654]  [<ffffffff8105f5f3>] ? add_wait_queue+0x3c/0x3c
[  176.978667]  [<ffffffffa0168aba>] ?
join_transaction.isra.24+0x5a/0x1f3 [btrfs]
[  176.978682]  [<ffffffffa0169bd5>] ? start_transaction+0x1ed/0x242 [btrfs]
[  176.978696]  [<ffffffffa0197f35>] ? prepare_to_relocate+0xa5/0xb2 [btrfs]
[  176.978710]  [<ffffffffa019c6dc>] ? relocate_block_group+0x3d/0x4e6 [btrfs]
[  176.978726]  [<ffffffffa017418f>] ?
btrfs_start_delalloc_inodes+0xea/0x1af [btrfs]
[  176.978732]  [<ffffffff8134470d>] ? printk+0x43/0x48
[  176.978737]  [<ffffffff81036457>] ? should_resched+0x5/0x23
[  176.978751]  [<ffffffffa019ccc4>] ?
btrfs_relocate_block_group+0x13f/0x267 [btrfs]
[  176.978766]  [<ffffffffa0183c09>] ?
btrfs_relocate_chunk.isra.44+0x4e/0x4d8 [btrfs]
[  176.978781]  [<ffffffffa018605e>] ? btrfs_shrink_device+0x1fe/0x33e [btrfs]
[  176.978788]  [<ffffffff81036457>] ? should_resched+0x5/0x23
[  176.978802]  [<ffffffffa01878fc>] ? btrfs_rm_device+0x21d/0x5b1 [btrfs]
[  176.978807]  [<ffffffff81036457>] ? should_resched+0x5/0x23
[  176.978822]  [<ffffffffa018c841>] ? btrfs_ioctl+0x71d/0xe1c [btrfs]
[  176.978828]  [<ffffffff8134dc6d>] ? do_page_fault+0x2fc/0x337
[  176.978833]  [<ffffffff81106911>] ? do_vfs_ioctl+0x459/0x49a
[  176.978839]  [<ffffffff810d4ee9>] ? do_brk+0x22d/0x280
[  176.978845]  [<ffffffff8110699d>] ? sys_ioctl+0x4b/0x72
[  176.978850]  [<ffffffff8134fc92>] ? system_call_fastpath+0x16/0x1b
[  176.978855] Code: 00 00 e8 19 cc ff ff 48 81 c4 88 00 00 00 44 89
e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 55 49 89 d3 49 89 f2 53 48 89 cb
48 83 ec 18 <48> 8b 2f 81 e5 ff 0f 00 00 48 8d 04 2e 48 8d 54 10 ff 48
89 c6
[  176.978952] RIP  [<ffffffffa01824e9>]
map_private_extent_buffer+0xf/0xec [btrfs]
[  176.978969]  RSP <ffff880118d3d7e8>
[  176.978972] CR2: 0000000000000000
[  176.978976] ---[ end trace 38356f4ae639f800 ]---
