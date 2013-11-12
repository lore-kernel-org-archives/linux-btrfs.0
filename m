Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60594 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3KLHtP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 02:49:15 -0500
Message-ID: <1384242552.7516.9.camel@hsew-frn.HIPERSCAN>
Subject: invalid opcode: 0000 [#1] SMP
From: Franziska =?ISO-8859-1?Q?N=E4pelt?=
	<franziska.naepelt@hiperscan.com>
Reply-To: franziska.naepelt@hiperscan.com
To: linux-btrfs@vger.kernel.org
Date: Tue, 12 Nov 2013 08:49:12 +0100
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

we are using a btrfs RAID 1 with four 2TB hard drives (WD Caviar green) on a Debian 7.2 with Kernel 3.11.6

Now we had an 'invalid opcode: 0000 [#1] SMP' when a sector fails in messages log.
After that, access over smb and nfs wasn't possible.
A restart solved the problem of inaccesibility.

log in messages:

Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.945880] BTRFS info (device sdg): csum failed ino 11700795 off 360448 csum 3250055067 private 1008662906
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.945884] BTRFS info (device sdg): csum failed ino 11700795 off 131072 csum 2566472073 private 1949667351
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.945929] BTRFS info (device sdg): csum failed ino 11700795 off 364544 csum 3977526881 private 949084760
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.945950] BTRFS info (device sdg): csum failed ino 11700795 off 139264 csum 2566472073 private 3294336991
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.945954] BTRFS info (device sdg): csum failed ino 11700795 off 368640 csum 1287367442 private 1423326887
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.945975] BTRFS info (device sdg): csum failed ino 11700795 off 372736 csum 1674667735 private 1579678479
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.945978] BTRFS info (device sdg): csum failed ino 11700795 off 143360 csum 2566472073 private 2107203283
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.945998] BTRFS info (device sdg): csum failed ino 11700795 off 147456 csum 2566472073 private 1411772010
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.946003] BTRFS info (device sdg): csum failed ino 11700795 off 376832 csum 3220301978 private 4038459134
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.946026] BTRFS info (device sdg): csum failed ino 11700795 off 380928 csum 1998835358 private 4082683787
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.958038] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.959432] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.959914] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.960342] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.960755] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.961174] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.961591] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.962013] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.962395] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.962832] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.963215] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.963668] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.964079] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.964495] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.964913] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.965329] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.965745] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.966164] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.966547] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.966989] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.967424] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.967829] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.968245] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.968664] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.969079] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.969111] ------------[ cut here ]------------
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.969167] invalid opcode: 0000 [#1] SMP 
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.969195] Modules linked in: xts gf128mul tun parport_pc ppdev lp parport pci_stub vboxpci(O) vboxnetadp(O) cpufreq_powersave vboxnetflt(O) cpufreq_userspace cpufreq_stats cpufreq_conservative vboxdrv(O) binfmt_misc fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc ext2 dm_crypt loop firewire_sbp2 iTCO_wdt iTCO_vendor_support snd_hda_codec_hdmi coretemp kvm_intel kvm snd_hda_intel radeon snd_hda_codec ttm drm_kms_helper drm snd_hwdep i2c_algo_bit psmouse i7core_edac lpc_ich ehci_pci edac_core acpi_cpufreq mfd_core i2c_i801 snd_pcm i2c_core snd_page_alloc evdev snd_timer snd microcode mperf pcspkr mxm_wmi serio_raw soundcore asus_atk0110 processor button thermal_sys wmi ext4 crc16 jbd2 mbcache btrfs xor zlib_deflate raid6_pq libcrc32c dm_mod raid1 md_mod sg sd_mod crc_t10dif hid_generic usbhid hid crc32c_intel firewire_ohci sata_sil firewire_core crc_itu_t r8169 mii ahci libahci libata scsi_mod uhci_hcd ehci_hcd xhci_hcd usbcore usb_common
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.969741] CPU: 0 PID: 2553 Comm: btrfs-endio-3 Tainted: G           O 3.11.6 #1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.969770] Hardware name: System manufacturer System Product Name/SABERTOOTH X58, BIOS 1304    08/02/2011
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.969807] task: ffff88062290a080 ti: ffff88002626c000 task.ti: ffff88002626c000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.969836] RIP: 0010:[<ffffffffa01d8e58>]  [<ffffffffa01d8e58>] end_bio_extent_readpage+0x519/0x767 [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.969887] RSP: 0018:ffff88002626dd78  EFLAGS: 00010202
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.969909] RAX: 0000000000000000 RBX: 0000000000017000 RCX: 0000000000000000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.969936] RDX: ffff8803f46f92b0 RSI: ffff8803f46f92c0 RDI: ffff8801406f78dc
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.969964] RBP: ffffea000e016068 R08: 0000000781c00000 R09: 0000000000000000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.969992] R10: 0000000000000000 R11: ffff8801a8ae5bc0 R12: ffff880041ee26c0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970019] R13: ffff880072451c60 R14: ffff8801406f78dc R15: 0000000000000002
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970047] FS:  0000000000000000(0000) GS:ffff88063fc00000(0000) knlGS:0000000000000000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970078] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970100] CR2: 000000000041d1d0 CR3: 000000000160b000 CR4: 00000000000027f0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970127] Stack:
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970137]  ffff8803f46f92b0 ffff8801406f7a50 ffff880072451bd0 ffff8801406f7a50
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970173]  0000000000017fff fffffffb00000000 ffff8801406f78b0 ffff8801406f78f0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970208]  ffff880072451c50 ffff8801406f78b0 ffff88062290a080 ffff8803f46f92b0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970243] Call Trace:
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970265]  [<ffffffffa01e4f16>] ? worker_loop+0x175/0x4af [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970300]  [<ffffffffa01e4da1>] ? btrfs_queue_worker+0x27a/0x27a [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970336]  [<ffffffffa01e4da1>] ? btrfs_queue_worker+0x27a/0x27a [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970365]  [<ffffffff8104f375>] ? kthread+0x81/0x89
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970386]  [<ffffffff8104f2f4>] ? __kthread_parkme+0x5d/0x5d
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970411]  [<ffffffff81371f2c>] ? ret_from_fork+0x7c/0xb0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970433]  [<ffffffff8104f2f4>] ? __kthread_parkme+0x5d/0x5d
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970456] Code: 24 28 41 c7 44 24 30 01 00 00 00 41 be 12 00 00 00 41 89 44 24 28 eb 53 41 83 7c 24 30 00 74 1f 8b 4c 24 28 41 39 4c 24 28 74 02 <0f> 0b 41 c7 44 24 30 00 00 00 00 41 c7 44 24 28 00 00 00 00 8b 
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.970740]  RSP <ffff88002626dd78>
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974450] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974454] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974456] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974458] btrfs csum failed ino 11700795 extent 16170745856 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974460] ---[ end trace 8d0b4ddf6f1304e5 ]---
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974474] btrfs csum failed ino 11700795 extent 16170745856 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974509] btrfs csum failed ino 11700795 extent 16170799104 csum 3010692976 wanted 684650397 mirror 1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974515] ------------[ cut here ]------------
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974516] invalid opcode: 0000 [#2] SMP 
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974535] Modules linked in: xts gf128mul tun parport_pc ppdev lp parport pci_stub vboxpci(O) vboxnetadp(O) cpufreq_powersave vboxnetflt(O) cpufreq_userspace cpufreq_stats cpufreq_conservative vboxdrv(O) binfmt_misc fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc ext2 dm_crypt loop firewire_sbp2 iTCO_wdt iTCO_vendor_support snd_hda_codec_hdmi coretemp kvm_intel kvm snd_hda_intel radeon snd_hda_codec ttm drm_kms_helper drm snd_hwdep i2c_algo_bit psmouse i7core_edac lpc_ich ehci_pci edac_core acpi_cpufreq mfd_core i2c_i801 snd_pcm i2c_core snd_page_alloc evdev snd_timer snd microcode mperf pcspkr mxm_wmi serio_raw soundcore asus_atk0110 processor button thermal_sys wmi ext4 crc16 jbd2 mbcache btrfs xor zlib_deflate raid6_pq libcrc32c dm_mod raid1 md_mod sg sd_mod crc_t10dif hid_generic usbhid hid crc32c_intel firewire_ohci sata_sil firewire_core crc_itu_t r8169 mii ahci libahci libata scsi_mod uhci_hcd ehci_hcd xhci_hcd usbcore usb_common
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974541] CPU: 5 PID: 2555 Comm: btrfs-endio-4 Tainted: G      D    O 3.11.6 #1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974541] Hardware name: System manufacturer System Product Name/SABERTOOTH X58, BIOS 1304    08/02/2011
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974542] task: ffff880624a8d100 ti: ffff88007248a000 task.ti: ffff88007248a000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974553] RIP: 0010:[<ffffffffa01d8e58>]  [<ffffffffa01d8e58>] end_bio_extent_readpage+0x519/0x767 [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974554] RSP: 0018:ffff88007248bd78  EFLAGS: 00010202
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974555] RAX: 0000000000000000 RBX: 000000000001a000 RCX: 0000000000000000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974555] RDX: ffff880229f6fd30 RSI: ffff880229f6fd40 RDI: ffff8801406f78dc
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974556] RBP: ffffea00069c2320 R08: 0000000781c00000 R09: 0000000000000000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974556] R10: 0000000000000000 R11: ffff88063fcace00 R12: ffff880041ee2580
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974557] R13: ffff88026e918760 R14: ffff8801406f78dc R15: 0000000000000002
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974559] FS:  0000000000000000(0000) GS:ffff88063fca0000(0000) knlGS:0000000000000000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974559] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974560] CR2: ffffffffff600400 CR3: 000000000160b000 CR4: 00000000000027e0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974560] Stack:
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974562]  ffff880229f6fd30 ffff8801406f7a50 ffff88026e9186d0 ffff8801406f7a50
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974563]  000000000001afff fffffffb00000000 ffff8801406f78b0 ffff8801406f78f0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974564]  ffff88026e918750 ffff8801406f78b0 ffff880624a8d100 ffff880229f6fd30
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974565] Call Trace:
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974575]  [<ffffffffa01e4f16>] ? worker_loop+0x175/0x4af [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974585]  [<ffffffffa01e4da1>] ? btrfs_queue_worker+0x27a/0x27a [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974595]  [<ffffffffa01e4da1>] ? btrfs_queue_worker+0x27a/0x27a [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974597]  [<ffffffff8104f375>] ? kthread+0x81/0x89
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974599]  [<ffffffff8104f2f4>] ? __kthread_parkme+0x5d/0x5d
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974600]  [<ffffffff81371f2c>] ? ret_from_fork+0x7c/0xb0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974601]  [<ffffffff8104f2f4>] ? __kthread_parkme+0x5d/0x5d
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974611] Code: 24 28 41 c7 44 24 30 01 00 00 00 41 be 12 00 00 00 41 89 44 24 28 eb 53 41 83 7c 24 30 00 74 1f 8b 4c 24 28 41 39 4c 24 28 74 02 <0f> 0b 41 c7 44 24 30 00 00 00 00 41 c7 44 24 28 00 00 00 00 8b 
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974621]  RSP <ffff88007248bd78>
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974622] ---[ end trace 8d0b4ddf6f1304e6 ]---
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974629] ------------[ cut here ]------------
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974632] invalid opcode: 0000 [#3] SMP 
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974661] Modules linked in: xts gf128mul tun parport_pc ppdev lp parport pci_stub vboxpci(O) vboxnetadp(O) cpufreq_powersave vboxnetflt(O) cpufreq_userspace cpufreq_stats cpufreq_conservative vboxdrv(O) binfmt_misc fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc ext2 dm_crypt loop firewire_sbp2 iTCO_wdt iTCO_vendor_support snd_hda_codec_hdmi coretemp kvm_intel kvm snd_hda_intel radeon snd_hda_codec ttm drm_kms_helper drm snd_hwdep i2c_algo_bit psmouse i7core_edac lpc_ich ehci_pci edac_core acpi_cpufreq mfd_core i2c_i801 snd_pcm i2c_core snd_page_alloc evdev snd_timer snd microcode mperf pcspkr mxm_wmi serio_raw soundcore asus_atk0110 processor button thermal_sys wmi ext4 crc16 jbd2 mbcache btrfs xor zlib_deflate raid6_pq libcrc32c dm_mod raid1 md_mod sg sd_mod crc_t10dif hid_generic usbhid hid crc32c_intel firewire_ohci sata_sil firewire_core crc_itu_t r8169 mii ahci libahci libata scsi_mod uhci_hcd ehci_hcd xhci_hcd usbcore usb_common
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974669] CPU: 6 PID: 2565 Comm: btrfs-endio-5 Tainted: G      D    O 3.11.6 #1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974670] Hardware name: System manufacturer System Product Name/SABERTOOTH X58, BIOS 1304    08/02/2011
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974671] task: ffff880624d5d750 ti: ffff8800a857c000 task.ti: ffff8800a857c000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974686] RIP: 0010:[<ffffffffa01d8e58>]  [<ffffffffa01d8e58>] end_bio_extent_readpage+0x519/0x767 [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974687] RSP: 0018:ffff8800a857dd78  EFLAGS: 00010202
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974688] RAX: 0000000000000000 RBX: 0000000000019000 RCX: 0000000000000000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974689] RDX: ffff8803f46f9190 RSI: ffff8803f46f91a0 RDI: ffff8801406f78dc
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974690] RBP: ffffea000e3e91c0 R08: 0000000781c00000 R09: 0000000000000000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974691] R10: 0000000000000000 R11: 0000000000000004 R12: ffff880041ee2640
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974692] R13: ffff88026e918260 R14: ffff8801406f78dc R15: 0000000000000002
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974694] FS:  0000000000000000(0000) GS:ffff88063fcc0000(0000) knlGS:0000000000000000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974695] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974696] CR2: ffffffffff600400 CR3: 00000001dafef000 CR4: 00000000000027e0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974696] Stack:
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974698]  ffff8803f46f9190 ffff8801406f7a50 ffff88026e9181d0 ffff8801406f7a50
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974701]  0000000000019fff fffffffb00000000 ffff8801406f78b0 ffff8801406f78f0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974703]  ffff88026e918250 ffff8801406f78b0 ffff880624d5d750 ffff8803f46f9190
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974703] Call Trace:
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974718]  [<ffffffffa01e4f16>] ? worker_loop+0x175/0x4af [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974732]  [<ffffffffa01e4da1>] ? btrfs_queue_worker+0x27a/0x27a [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974746]  [<ffffffffa01e4da1>] ? btrfs_queue_worker+0x27a/0x27a [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974749]  [<ffffffff8104f375>] ? kthread+0x81/0x89
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974751]  [<ffffffff8104f2f4>] ? __kthread_parkme+0x5d/0x5d
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974753]  [<ffffffff81371f2c>] ? ret_from_fork+0x7c/0xb0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974754]  [<ffffffff8104f2f4>] ? __kthread_parkme+0x5d/0x5d
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974770] Code: 24 28 41 c7 44 24 30 01 00 00 00 41 be 12 00 00 00 41 89 44 24 28 eb 53 41 83 7c 24 30 00 74 1f 8b 4c 24 28 41 39 4c 24 28 74 02 <0f> 0b 41 c7 44 24 30 00 00 00 00 41 c7 44 24 28 00 00 00 00 8b 
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974784]  RSP <ffff8800a857dd78>
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974785] ---[ end trace 8d0b4ddf6f1304e7 ]---
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974789] ------------[ cut here ]------------
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974791] invalid opcode: 0000 [#4] SMP 
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974809] Modules linked in: xts gf128mul tun parport_pc ppdev lp parport pci_stub vboxpci(O) vboxnetadp(O) cpufreq_powersave vboxnetflt(O) cpufreq_userspace cpufreq_stats cpufreq_conservative vboxdrv(O) binfmt_misc fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc ext2 dm_crypt loop firewire_sbp2 iTCO_wdt iTCO_vendor_support snd_hda_codec_hdmi coretemp kvm_intel kvm snd_hda_intel radeon snd_hda_codec ttm drm_kms_helper drm snd_hwdep i2c_algo_bit psmouse i7core_edac lpc_ich ehci_pci edac_core acpi_cpufreq mfd_core i2c_i801 snd_pcm i2c_core snd_page_alloc evdev snd_timer snd microcode mperf pcspkr mxm_wmi serio_raw soundcore asus_atk0110 processor button thermal_sys wmi ext4 crc16 jbd2 mbcache btrfs xor zlib_deflate raid6_pq libcrc32c dm_mod raid1 md_mod sg sd_mod crc_t10dif hid_generic usbhid hid crc32c_intel firewire_ohci sata_sil firewire_core crc_itu_t r8169 mii ahci libahci libata scsi_mod uhci_hcd ehci_hcd xhci_hcd usbcore usb_common
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974815] CPU: 4 PID: 2546 Comm: btrfs-endio-2 Tainted: G      D    O 3.11.6 #1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974815] Hardware name: System manufacturer System Product Name/SABERTOOTH X58, BIOS 1304    08/02/2011
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974816] task: ffff8803e0c23040 ti: ffff880052bc4000 task.ti: ffff880052bc4000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974827] RIP: 0010:[<ffffffffa01d8e58>]  [<ffffffffa01d8e58>] end_bio_extent_readpage+0x519/0x767 [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974827] RSP: 0018:ffff880052bc5d78  EFLAGS: 00010202
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974828] RAX: 0000000000000000 RBX: 000000000001c000 RCX: 0000000000000000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974829] RDX: ffff880440c153d0 RSI: ffff880440c153e0 RDI: ffff8801406f78dc
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974829] RBP: ffffea00094e4d50 R08: 0000000781c00000 R09: 0000000000000000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974830] R10: 0000000000000000 R11: ffff88063fc8ce00 R12: ffff880041ee2500
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974830] R13: ffff880141bd1220 R14: ffff8801406f78dc R15: 0000000000000002
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974831] FS:  0000000000000000(0000) GS:ffff88063fc80000(0000) knlGS:0000000000000000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974832] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974833] CR2: 0000000001a83ff0 CR3: 000000000160b000 CR4: 00000000000027e0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974833] Stack:
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974834]  ffff880440c153d0 ffff8801406f7a50 ffff880141bd1190 ffff8801406f7a50
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974836]  000000000001cfff fffffffb00000000 ffff8801406f78b0 ffff8801406f78f0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974837]  ffff880141bd1210 ffff8801406f78b0 ffff8803e0c23040 ffff880440c153d0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974837] Call Trace:
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974848]  [<ffffffffa01e4f16>] ? worker_loop+0x175/0x4af [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974858]  [<ffffffffa01e4da1>] ? btrfs_queue_worker+0x27a/0x27a [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974868]  [<ffffffffa01e4da1>] ? btrfs_queue_worker+0x27a/0x27a [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974869]  [<ffffffff8104f375>] ? kthread+0x81/0x89
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974871]  [<ffffffff8104f2f4>] ? __kthread_parkme+0x5d/0x5d
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974872]  [<ffffffff81371f2c>] ? ret_from_fork+0x7c/0xb0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974874]  [<ffffffff8104f2f4>] ? __kthread_parkme+0x5d/0x5d
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974883] Code: 24 28 41 c7 44 24 30 01 00 00 00 41 be 12 00 00 00 41 89 44 24 28 eb 53 41 83 7c 24 30 00 74 1f 8b 4c 24 28 41 39 4c 24 28 74 02 <0f> 0b 41 c7 44 24 30 00 00 00 00 41 c7 44 24 28 00 00 00 00 8b 
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974893]  RSP <ffff880052bc5d78>
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.974894] ---[ end trace 8d0b4ddf6f1304e8 ]---
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.975000] ------------[ cut here ]------------
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.978061] invalid opcode: 0000 [#5] SMP 
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.979577] Modules linked in: xts gf128mul tun parport_pc ppdev lp parport pci_stub vboxpci(O) vboxnetadp(O) cpufreq_powersave vboxnetflt(O) cpufreq_userspace cpufreq_stats cpufreq_conservative vboxdrv(O) binfmt_misc fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc ext2 dm_crypt loop firewire_sbp2 iTCO_wdt iTCO_vendor_support snd_hda_codec_hdmi coretemp kvm_intel kvm snd_hda_intel radeon snd_hda_codec ttm drm_kms_helper drm snd_hwdep i2c_algo_bit psmouse i7core_edac lpc_ich ehci_pci edac_core acpi_cpufreq mfd_core i2c_i801 snd_pcm i2c_core snd_page_alloc evdev snd_timer snd microcode mperf pcspkr mxm_wmi serio_raw soundcore asus_atk0110 processor button thermal_sys wmi ext4 crc16 jbd2 mbcache btrfs xor zlib_deflate raid6_pq libcrc32c dm_mod raid1 md_mod sg sd_mod crc_t10dif hid_generic usbhid hid crc32c_intel firewire_ohci sata_sil firewire_core crc_itu_t r8169 mii ahci libahci libata scsi_mod uhci_hcd ehci_hcd xhci_hcd usbcore usb_common
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.992129] CPU: 2 PID: 1233 Comm: btrfs-endio-2 Tainted: G      D    O 3.11.6 #1
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.993661] Hardware name: System manufacturer System Product Name/SABERTOOTH X58, BIOS 1304    08/02/2011
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.995203] task: ffff88062168f810 ti: ffff8800ad5ce000 task.ti: ffff8800ad5ce000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.996744] RIP: 0010:[<ffffffffa01d8e58>]  [<ffffffffa01d8e58>] end_bio_extent_readpage+0x519/0x767 [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.998299] RSP: 0018:ffff8800ad5cfd78  EFLAGS: 00010202
Nov  7 01:38:17 hsad-srv-03 kernel: [1521231.999838] RAX: 0000000000000000 RBX: 0000000000018000 RCX: 0000000000000000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.001384] RDX: ffff8803f46f91f0 RSI: ffff8803f46f9200 RDI: ffff8801406f78dc
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.002934] RBP: ffffea000e3ef0e8 R08: 0000000781c00000 R09: 0000000000000000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.004482] R10: 0000000000000000 R11: ffff8801d8b724c0 R12: ffff880041ee2680
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.006032] R13: ffff8802d3f1de20 R14: ffff8801406f78dc R15: 0000000000000002
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.007572] FS:  0000000000000000(0000) GS:ffff88063fc40000(0000) knlGS:0000000000000000
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.009113] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.010645] CR2: ffffffffff600400 CR3: 00000001dafef000 CR4: 00000000000027e0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.012391] Stack:
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.014292]  ffff8803f46f91f0 ffff8801406f7a50 ffff8802d3f1dd90 ffff8801406f7a50
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.016241]  0000000000018fff fffffffb00000000 ffff8801406f78b0 ffff8801406f78f0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.018191]  ffff8802d3f1de10 ffff8801406f78b0 ffff88062168f810 ffff8803f46f91f0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.020140] Call Trace:
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.022074]  [<ffffffffa01e4f16>] ? worker_loop+0x175/0x4af [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.024030]  [<ffffffffa01e4da1>] ? btrfs_queue_worker+0x27a/0x27a [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.026016]  [<ffffffffa01e4da1>] ? btrfs_queue_worker+0x27a/0x27a [btrfs]
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.027968]  [<ffffffff8104f375>] ? kthread+0x81/0x89
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.029918]  [<ffffffff8104f2f4>] ? __kthread_parkme+0x5d/0x5d
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.031872]  [<ffffffff81371f2c>] ? ret_from_fork+0x7c/0xb0
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.033822]  [<ffffffff8104f2f4>] ? __kthread_parkme+0x5d/0x5d
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.035721] Code: 24 28 41 c7 44 24 30 01 00 00 00 41 be 12 00 00 00 41 89 44 24 28 eb 53 41 83 7c 24 30 00 74 1f 8b 4c 24 28 41 39 4c 24 28 74 02 <0f> 0b 41 c7 44 24 30 00 00 00 00 41 c7 44 24 28 00 00 00 00 8b 
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.041712]  RSP <ffff8800ad5cfd78>
Nov  7 01:38:17 hsad-srv-03 kernel: [1521232.043684] ---[ end trace 8d0b4ddf6f1304e9 ]---

SmartMail from 07 Nov 2013 01:52:42 +0100:

This email was generated by the smartd daemon running on:

   host name: hsad-srv-03
  DNS domain: hiperscan.com
  NIS domain: (none)

The following warning/error was logged by the smartd daemon:

Device: /dev/sde [SAT], 1 Currently unreadable (pending) sectors


For details see host's SYSLOG.

You can also use the smartctl utility for further investigation.
Another email message will be sent in 24 hours if the problem persists.


best regards
Franziska





