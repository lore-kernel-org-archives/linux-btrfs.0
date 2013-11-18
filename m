Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:53615 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3KRHPB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Nov 2013 02:15:01 -0500
Message-ID: <1384758899.14833.10.camel@hsew-frn.HIPERSCAN>
Subject: btrfs goes read only after balance
From: Franziska =?ISO-8859-1?Q?N=E4pelt?=
	<franziska.naepelt@hiperscan.com>
Reply-To: franziska.naepelt@hiperscan.com
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Mon, 18 Nov 2013 08:14:59 +0100
Content-Type: text/plain; charset="ISO-8859-15"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everybody,
we are using a btrfs RAID 1 with four 2TB hard drives (WD Caviar green
and one Red) on a Debian 7.2 with Kernel 3.12.0

Last week I replaced a broken Harddrive with btrfs replace ...

After that I wanted to balance the filesystem and get a
'Speicherzugriffsfehler' (Segmentation fault). After that I want to
reboot the system and nothing happens, it hangs at a btrfs stack trace.

After a hard reset, the filesystem is mounted read only. I don't know
how to get the filesystem rw ...

/var/log/messages from balance:

 Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402337] ------------[ cut
here ]------------
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402353] WARNING: CPU: 2 PID:
3621 at fs/btrfs/super.c:255 __btrfs_abort_transaction+0x4a/0xfc
[btrfs]()
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402355] Modules linked in:
xts gf128mul tun parport_pc ppdev lp pci_stub parport vboxpci(O)
vboxnetadp(O) vboxnetflt(O) vboxdrv(O) cpufreq_powersave
cpufreq_userspace cpufreq_stats cpufreq_conservative binfmt_misc fuse
nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc ext2
dm_crypt loop firewire_sbp2 snd_hda_codec_hdmi snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer snd soundcore
coretemp kvm_intel kvm radeon acpi_cpufreq iTCO_wdt psmouse ttm
iTCO_vendor_support drm_kms_helper drm i2c_algo_bit mxm_wmi evdev
processor serio_raw pcspkr i2c_i801 ehci_pci i2c_core lpc_ich
asus_atk0110 wmi button thermal_sys i7core_edac microcode mfd_core
edac_core ext4 crc16 jbd2 mbcache btrfs xor raid6_pq libcrc32c dm_mod
raid1 md_mod sg sd_mod crct10dif_generic crc_t10dif crct10dif_common
hid_generic usbhid hid crc32c_intel firewire_ohci sata_sil firewire_core
crc_itu_t r8169 mii uhci_hcd ehci_hcd ahci libahci xhci_hcd libata
usbcore scsi_mod usb_common
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402393] CPU: 2 PID: 3621
Comm: btrfs Tainted: G           O 3.12.0 #1
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402394] Hardware name:
System manufacturer System Product Name/SABERTOOTH X58, BIOS 1304
08/02/2011
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402395]  0000000000000000
0000000000000009 ffffffff81376a93 ffff8801611178c8
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402398]  ffffffff8103738f
ffff8802c7d7fef0 ffffffffa01b0940 ffff880285a3cf80
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402399]  00000000ffffffe4
ffff8806254c8000 ffff8802c7d7fef0 ffffffffa022c8e0
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402402] Call Trace:
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402406]
[<ffffffff81376a93>] ? dump_stack+0x41/0x51
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402409]
[<ffffffff8103738f>] ? warn_slowpath_common+0x78/0x90
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402415]
[<ffffffffa01b0940>] ? __btrfs_abort_transaction+0x4a/0xfc [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402418]
[<ffffffff8103743f>] ? warn_slowpath_fmt+0x45/0x4a
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402427]
[<ffffffffa01c0ea0>] ? run_clustered_refs+0xa74/0xa79 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402434]
[<ffffffffa01b0940>] ? __btrfs_abort_transaction+0x4a/0xfc [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402442]
[<ffffffffa01c3f97>] ? btrfs_run_delayed_refs+0x239/0x3ab [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402445]
[<ffffffff810593c4>] ? should_resched+0x5/0x23
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402447]
[<ffffffff813784b2>] ? mutex_lock+0x9/0x25
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402457]
[<ffffffffa01d11e1>] ? btrfs_commit_transaction+0x6b/0x843 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402468]
[<ffffffffa020cac6>] ? btrfs_update_reloc_root+0x97/0xa8 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402475]
[<ffffffffa022652e>] ? prepare_to_merge+0x1a5/0x1bc [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402485]
[<ffffffffa020d58b>] ? relocate_block_group+0x468/0x4eb [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402495]
[<ffffffffa020d751>] ? btrfs_relocate_block_group+0x143/0x26a [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402506]
[<ffffffffa01ee006>] ? btrfs_relocate_chunk.isra.59+0x59/0x5fb [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402516]
[<ffffffffa01fb012>] ? btrfs_set_lock_blocking_rw+0xc9/0xdb [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402523]
[<ffffffffa01b1525>] ? btrfs_item_key_to_cpu+0x12/0x30 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402530]
[<ffffffffa01b9188>] ? btrfs_previous_item+0x62/0xa2 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402540]
[<ffffffffa01e33e3>] ? btrfs_get_token_64+0x76/0xc6 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402551]
[<ffffffffa01e5e29>] ? release_extent_buffer+0x90/0x97 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402561]
[<ffffffffa01f0a8c>] ? btrfs_balance+0x980/0xb44 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402572]
[<ffffffffa01f6ac9>] ? btrfs_ioctl_balance+0x21a/0x296 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402582]
[<ffffffffa01f991f>] ? btrfs_ioctl+0xf3d/0x1eaa [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402585]
[<ffffffff810df62a>] ? handle_mm_fault+0x22c/0x8aa
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402587]
[<ffffffff8137d866>] ? __do_page_fault+0x349/0x3d7
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402589]
[<ffffffff810e3505>] ? vma_link+0x6e/0x8c
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402591]
[<ffffffff8111327e>] ? vfs_ioctl+0x1e/0x31
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402593]
[<ffffffff81113a55>] ? do_vfs_ioctl+0x3ae/0x3f0
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402595]
[<ffffffff81113ae5>] ? SyS_ioctl+0x4e/0x7d
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402597]
[<ffffffff8137f9e2>] ? system_call_fastpath+0x16/0x1b
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402598] ---[ end trace
3279208d33d06c4d ]---
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402601] BTRFS info (device
sdg): forced readonly
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402687] ------------[ cut
here ]------------

Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402744] invalid opcode: 0000
[#1] SMP 
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.402766] Modules linked in:
xts gf128mul tun parport_pc ppdev lp pci_stub parport vboxpci(O)
vboxnetadp(O) vboxnetflt(O) vboxdrv(O) cpufreq_powersave
cpufreq_userspace cpufreq_stats cpufreq_conservative binfmt_misc fuse
nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc ext2
dm_crypt loop firewire_sbp2 snd_hda_codec_hdmi snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer snd soundcore
coretemp kvm_intel kvm radeon acpi_cpufreq iTCO_wdt psmouse ttm
iTCO_vendor_support drm_kms_helper drm i2c_algo_bit mxm_wmi evdev
processor serio_raw pcspkr i2c_i801 ehci_pci i2c_core lpc_ich
asus_atk0110 wmi button thermal_sys i7core_edac microcode mfd_core
edac_core ext4 crc16 jbd2 mbcache btrfs xor raid6_pq libcrc32c dm_mod
raid1 md_mod sg sd_mod crct10dif_generic crc_t10dif crct10dif_common
hid_generic usbhid hid crc32c_intel firewire_ohci sata_sil firewire_core
crc_itu_t r8169 mii uhci_hcd ehci_hcd ahci libahci xhci_hcd libata
usbcore scsi_mod usb_common
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403331] CPU: 2 PID: 3621
Comm: btrfs Tainted: G        W  O 3.12.0 #1
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403359] Hardware name:
System manufacturer System Product Name/SABERTOOTH X58, BIOS 1304
08/02/2011
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403397] task:
ffff8806121b8770 ti: ffff880161116000 task.ti: ffff880161116000
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403428] RIP:
0010:[<ffffffffa020cc52>]  [<ffffffffa020cc52>] merge_reloc_root
+0x17b/0x406 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403476] RSP:
0018:ffff880161117968  EFLAGS: 00010206
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403498] RAX:
ffffffffffffffe2 RBX: ffff8802ba89dc70 RCX: 0000000000000002
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403527] RDX:
0000000000000001 RSI: 0000000000000000 RDI: ffff88007d3a2000
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403556] RBP:
ffff880431656000 R08: ffff8803b93ad050 R09: 000000000000002a
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403584] R10:
0000000000001b42 R11: 000000000000b5be R12: ffff88007d3a2000
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403613] R13:
ffff8801611179e7 R14: ffff880431656458 R15: ffff880259fa4000
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403642] FS:
00007f67be4fb840(0000) GS:ffff88063fc40000(0000) knlGS:0000000000000000
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403675] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403698] CR2:
0000000000b2000c CR3: 00000001f74f8000 CR4: 00000000000027e0
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403727] Stack:
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403736]  00000000fffffffb
ffff880625efc000 ffff880625efc810 0000000000000282
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403773]  0000000000000000
ffffffffffffffe2 0000e000c7d7fef0 ffff8804316560fc
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403810]  ffff880285a3cea8
00000003a01d1c8a 0000000000049c03 ffff8801611179c0
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403847] Call Trace:
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403869]
[<ffffffffa020cfbc>] ? merge_reloc_roots+0xdf/0x246 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403905]
[<ffffffffa020d596>] ? relocate_block_group+0x473/0x4eb [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403943]
[<ffffffffa020d751>] ? btrfs_relocate_block_group+0x143/0x26a [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.403983]
[<ffffffffa01ee006>] ? btrfs_relocate_chunk.isra.59+0x59/0x5fb [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.404024]
[<ffffffffa01fb012>] ? btrfs_set_lock_blocking_rw+0xc9/0xdb [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.404059]
[<ffffffffa01b1525>] ? btrfs_item_key_to_cpu+0x12/0x30 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.404093]
[<ffffffffa01b9188>] ? btrfs_previous_item+0x62/0xa2 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.404130]
[<ffffffffa01e33e3>] ? btrfs_get_token_64+0x76/0xc6 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.404167]
[<ffffffffa01e5e29>] ? release_extent_buffer+0x90/0x97 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.404205]
[<ffffffffa01f0a8c>] ? btrfs_balance+0x980/0xb44 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.404241]
[<ffffffffa01f6ac9>] ? btrfs_ioctl_balance+0x21a/0x296 [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.404278]
[<ffffffffa01f991f>] ? btrfs_ioctl+0xf3d/0x1eaa [btrfs]
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.404305]
[<ffffffff810df62a>] ? handle_mm_fault+0x22c/0x8aa
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.404330]
[<ffffffff8137d866>] ? __do_page_fault+0x349/0x3d7
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.404356]
[<ffffffff810e3505>] ? vma_link+0x6e/0x8c
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.404378]
[<ffffffff8111327e>] ? vfs_ioctl+0x1e/0x31
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.404400]
[<ffffffff81113a55>] ? do_vfs_ioctl+0x3ae/0x3f0
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.404424]
[<ffffffff81113ae5>] ? SyS_ioctl+0x4e/0x7d
Nov 18 06:59:46 hsad-srv-03 kernel: [158311.404447]
[<ffffffff8137f9e2>] ? system_call_fastpath+0x16/0x1b

/var/log/messages after reboot:

Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747344] ------------[ cut
here ]------------
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747361] WARNING: CPU: 3 PID:
2296 at fs/btrfs/super.c:255 __btrfs_abort_transaction+0x4a/0xfc
[btrfs]()
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747365] BTRFS info (device
sdg): forced readonly
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747368] Modules linked in:
tun pci_stub vboxpci(O) parport_pc ppdev vboxnetadp(O) lp parport
vboxnetflt(O) vboxdrv(O) cpufreq_powersave cpufreq_userspace
cpufreq_stats cpufreq_conservative binfmt_misc fuse nfsd auth_rpcgss
oid_registry nfs_acl nfs lockd fscache sunrpc ext2 dm_crypt loop
firewire_sbp2 iTCO_wdt radeon iTCO_vendor_support snd_hda_codec_hdmi
coretemp kvm_intel kvm ttm drm_kms_helper drm snd_hda_intel
snd_hda_codec i2c_algo_bit psmouse i2c_i801 pcspkr snd_hwdep i2c_core
joydev serio_raw i7core_edac mxm_wmi evdev lpc_ich edac_core
asus_atk0110 mfd_core acpi_cpufreq ehci_pci processor wmi thermal_sys
snd_pcm snd_page_alloc snd_timer snd soundcore microcode button ext4
crc16 jbd2 mbcache btrfs xor raid6_pq libcrc32c dm_mod raid1 md_mod sg
sd_mod crct10dif_generic crc_t10dif crct10dif_common hid_generic usbhid
hid crc32c_intel firewire_ohci r8169 firewire_core mii crc_itu_t
sata_sil uhci_hcd xhci_hcd ehci_hcd ahci usbcore libahci usb_common
libata scsi_mod
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747406] CPU: 3 PID: 2296
Comm: btrfs-transacti Tainted: G           O 3.12.0 #1
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747407] Hardware name: System
manufacturer System Product Name/SABERTOOTH X58, BIOS 1304    08/02/2011
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747409]  0000000000000000
0000000000000009 ffffffff81376a93 ffff880615e45ce8
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747411]  ffffffff8103738f
ffff8806175cfb30 ffffffffa01b0940 ffff8806175d0f80
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747413]  00000000ffffffe4
ffff880624f5f800 ffff8806175cfb30 ffffffffa022c8e0
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747415] Call Trace:
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747420]
[<ffffffff81376a93>] ? dump_stack+0x41/0x51
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747422]
[<ffffffff8103738f>] ? warn_slowpath_common+0x78/0x90
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747429]
[<ffffffffa01b0940>] ? __btrfs_abort_transaction+0x4a/0xfc [btrfs]
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747432]
[<ffffffff8103743f>] ? warn_slowpath_fmt+0x45/0x4a
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747439]
[<ffffffffa01b0940>] ? __btrfs_abort_transaction+0x4a/0xfc [btrfs]
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747448]
[<ffffffffa01c3f97>] ? btrfs_run_delayed_refs+0x239/0x3ab [btrfs]
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747451]
[<ffffffff810593c4>] ? should_resched+0x5/0x23
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747454]
[<ffffffff813784b2>] ? mutex_lock+0x9/0x25
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747464]
[<ffffffffa01d124d>] ? btrfs_commit_transaction+0xd7/0x843 [btrfs]
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747474]
[<ffffffffa01ca7fc>] ? transaction_kthread+0xf4/0x191 [btrfs]
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747483]
[<ffffffffa01ca708>] ? try_to_freeze_unsafe+0x30/0x30 [btrfs]
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747493]
[<ffffffffa01ca708>] ? try_to_freeze_unsafe+0x30/0x30 [btrfs]
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747495]
[<ffffffff810506e1>] ? kthread+0x81/0x89
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747497]
[<ffffffff81050660>] ? __kthread_parkme+0x5d/0x5d
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747499]
[<ffffffff8137f93c>] ? ret_from_fork+0x7c/0xb0
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747501]
[<ffffffff81050660>] ? __kthread_parkme+0x5d/0x5d
Nov 18 07:37:09 hsad-srv-03 kernel: [  626.747503] ---[ end trace
a52efce52d07a868 ]---

What is wrong with our filesystem?

best regards,
Franziska



