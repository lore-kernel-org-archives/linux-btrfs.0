Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:50881 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbaGCHA4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 03:00:56 -0400
Message-ID: <53B4FFA5.4060608@hiperscan.com>
Date: Thu, 03 Jul 2014 09:00:53 +0200
From: Florian Stuelpner <florian.stuelpner@hiperscan.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: System freeze caused by  fs/btrfs/super.c:259
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

2 days ago our server was frozen.
Can anyone tell me what happened with my btrfs?
Should I create a bug report or is this a known issue?

Our specifications are:
- kernel version: 3.15.2
- distribution: debian 7.5
- 2 btrfs-pools (RAID 1) with  2x3TB and 4x2TB

we get the first error messages at 22:48:

Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009695] ------------[ cut 
here ]------------
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009716] WARNING: CPU: 6 PID: 
2494 at fs/btrfs/super.c:259 __btrfs_abort_transaction+0x46/0xf8 [btrfs]()
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009718] Modules linked in: 
xts gf128mul tun parport_pc ppdev lp parport bnep rfcomm bluetooth 
rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) 
cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_conservative 
binfmt_misc fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache 
sunrpc ext2 dm_crypt hwmon_vid loop firewire_sbp2 snd_hda_codec_hdmi 
snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm 
iTCO_wdt iTCO_vendor_support snd_timer joydev psmouse snd evdev coretemp 
kvm_intel radeon kvm ttm acpi_cpufreq drm_kms_helper mxm_wmi processor 
microcode drm pcspkr wmi i2c_i801 i2c_algo_bit soundcore i2c_core 
serio_raw lpc_ich mfd_core i7core_edac edac_core ehci_pci thermal_sys 
asus_atk0110 button ext4 crc16 jbd2 mbcache btrfs xor raid6_pq dm_mod 
raid1 md_mod sg sd_mod crct10dif_generic crc_t10dif crct10dif_common 
hid_generic usbhid hid crc32c_intel r8169 mii firewire_ohci 
firewire_core crc_itu_t sata_sil ahci libahci sata_mv libata scsi_mod u
Jul  1 22:44:28 hsad-srv-03 kernel: hci_hcd xhci_hcd ehci_hcd usbcore 
usb_common
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009759] CPU: 6 PID: 2494 
Comm: btrfs-transacti Tainted: G           O  3.15.2 #1
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009760] Hardware name: 
System manufacturer System Product Name/SABERTOOTH X58, BIOS 1304 08/02/2011
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009761] 0000000000000000 
0000000000000009 ffffffff8138b56a ffff88061c2e7d48
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009763] ffffffff81039583 
ffff880622e2f000 ffffffffa01c4123 0000000000172a20
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009765] 00000000ffffffe4 
ffff88061efa3000 ffff8800172c4c00 ffffffffa0243a80
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009767] Call Trace:
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009771] [<ffffffff8138b56a>] 
? dump_stack+0x41/0x51
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009774] [<ffffffff81039583>] 
? warn_slowpath_common+0x78/0x90
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009782] [<ffffffffa01c4123>] 
? __btrfs_abort_transaction+0x46/0xf8 [btrfs]
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009785] [<ffffffff81039633>] 
? warn_slowpath_fmt+0x45/0x4a
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009792] [<ffffffffa01c4123>] 
? __btrfs_abort_transaction+0x46/0xf8 [btrfs]
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009801] [<ffffffffa01d888d>] 
? btrfs_run_delayed_refs+0x9c/0x17e [btrfs]
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009812] [<ffffffffa01e5bce>] 
? btrfs_commit_transaction+0x392/0x887 [btrfs]
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009815] [<ffffffff8106661f>] 
? bit_waitqueue+0x82/0x82
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009826] [<ffffffffa01e4154>] 
? transaction_kthread+0xf4/0x1ac [btrfs]
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009836] [<ffffffffa01e4060>] 
? open_ctree+0x1b30/0x1b30 [btrfs]
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009846] [<ffffffffa01e4060>] 
? open_ctree+0x1b30/0x1b30 [btrfs]
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009852] [<ffffffff81051dd2>] 
? kthread+0x99/0xa1
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009854] [<ffffffff81051d39>] 
? __kthread_parkme+0x59/0x59
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009856] [<ffffffff813944bc>] 
? ret_from_fork+0x7c/0xb0
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009858] [<ffffffff81051d39>] 
? __kthread_parkme+0x59/0x59
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009859] ---[ end trace 
2b7eba103ecfc19e ]---
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009865] BTRFS info (device 
sdk): forced readonly
Jul  1 22:44:28 hsad-srv-03 kernel: [101279.009867] BTRFS warning 
(device sdk): Skipping commit of aborted transaction.

After that there are many errors. The last messages:

Jul  2 00:14:19 hsad-srv-03 kernel: [106667.979906] Code: 08 c3 48 8b 07 
48 39 f8 74 1c 48 8b 16 48 8b 4f 08 48 89 70 08 48 89 06 48 89 11 48 89 
4a 08 48 89 3f 48 89 7f 08 c3 66 83 07 01 <c3> f0 ff 47 34 c3 48 8b 87 
60 fe ff ff 48 85 c0 74 09 80 bf 68
Jul  2 00:14:24 hsad-srv-03 dhcpd: DHCPREQUEST for 192.168.2.222 from 
08:00:27:c5:1c:b9 (HSAD-SRV-V02) via eth0
Jul  2 00:14:24 hsad-srv-03 dhcpd: DHCPACK on 192.168.2.222 to 
08:00:27:c5:1c:b9 (HSAD-SRV-V02) via eth0
Jul  2 00:14:43 hsad-srv-03 dhcpd: DHCPREQUEST for 192.168.2.40 from 
08:00:27:8c:b9:8e via eth0
Jul  2 00:14:43 hsad-srv-03 dhcpd: DHCPACK on 192.168.2.40 to 
08:00:27:8c:b9:8e via eth0
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965910] Modules linked in: 
xts gf128mul tun parport_pc ppdev lp parport bnep rfcomm bluetooth 
rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) 
cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_conservative 
binfmt_misc fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache 
sunrpc ext2 dm_crypt hwmon_vid loop firewire_sbp2 snd_hda_codec_hdmi 
snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm 
iTCO_wdt iTCO_vendor_support snd_timer joydev psmouse snd evdev coretemp 
kvm_intel radeon kvm ttm acpi_cpufreq drm_kms_helper mxm_wmi processor 
microcode drm pcspkr wmi i2c_i801 i2c_algo_bit soundcore i2c_core 
serio_raw lpc_ich mfd_core i7core_edac edac_core ehci_pci thermal_sys 
asus_atk0110 button ext4 crc16 jbd2 mbcache btrfs xor raid6_pq dm_mod 
raid1 md_mod sg sd_mod crct10dif_generic crc_t10dif crct10dif_common 
hid_generic usbhid hid crc32c_intel r8169 mii firewire_ohci 
firewire_core crc_itu_t sata_sil ahci libahci sata_mv libata scsi_mod u
Jul  2 00:14:47 hsad-srv-03 kernel: hci_hcd xhci_hcd ehci_hcd usbcore 
usb_common
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965958] CPU: 3 PID: 9335 
Comm: btrfs Tainted: G        W  O  3.15.2 #1
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965959] Hardware name: 
System manufacturer System Product Name/SABERTOOTH X58, BIOS 1304 08/02/2011
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965961] task: 
ffff88002c4be090 ti: ffff88003f9d4000 task.ti: ffff88003f9d4000
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965962] RIP: 
0010:[<ffffffff81069bfe>]  [<ffffffff81069bfe>] do_raw_spin_lock+0x9/0x23
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965966] RSP: 
0018:ffff88003f9d7a50  EFLAGS: 00000286
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965968] RAX: 
00000000887e887e RBX: 000000000000b876 RCX: 0000000000000078
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965969] RDX: 
000000000000887d RSI: 000002a4e6fb5000 RDI: ffff880172317570
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965970] RBP: 
00000000ffffffe2 R08: 0000000000000000 R09: ffff88063fc72e80
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965971] R10: 
ffff88063fc72e80 R11: ffff88063fc72e80 R12: 0000000000000282
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965972] R13: 
0000000000000000 R14: 00000000ffffffe2 R15: ffffffffffffffe2
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965974] FS: 
00007f0e64f20840(0000) GS:ffff88063fc60000(0000) knlGS:0000000000000000
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965975] CS:  0010 DS: 0000 
ES: 0000 CR0: 000000008005003b
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965976] CR2: 
0000000000fbec30 CR3: 000000035cf0a000 CR4: 00000000000027e0
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965977] Stack:
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965978] ffffffffa021f3b3 
ffff88063fc72e80 ffff88003f9d7aa8 00000000ffffffe2
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965980] ffff880172317000 
ffff88003f9d7aa8 ffffffffa021f44a ffff88061b6a1800
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965982] ffffffffa0223187 
0000000000000000 ffff880172317578 ffff8802ba27d438
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965983] Call Trace:
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.965999] [<ffffffffa021f3b3>] 
? __del_reloc_root+0x2f/0xb4 [btrfs]
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966010] [<ffffffffa021f44a>] 
? free_reloc_roots+0x12/0x1c [btrfs]
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966021] [<ffffffffa0223187>] 
? merge_reloc_roots+0x165/0x1ca [btrfs]
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966032] [<ffffffffa02237fd>] 
? relocate_block_group+0x455/0x4cd [btrfs]
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966043] [<ffffffffa02239c4>] 
? btrfs_relocate_block_group+0x14f/0x267 [btrfs]
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966054] [<ffffffffa0203106>] 
? btrfs_relocate_chunk.isra.58+0x59/0x5fb [btrfs]
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966057] [<ffffffff810a4b5b>] 
? delayacct_end+0x73/0x7e
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966068] [<ffffffffa0210b84>] 
? btrfs_set_lock_blocking_rw+0xc9/0xdd [btrfs]
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966075] [<ffffffffa01c5751>] 
? btrfs_item_key_to_cpu+0x12/0x30 [btrfs]
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966086] [<ffffffffa01f816f>] 
? btrfs_get_token_64+0x76/0xc6 [btrfs]
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966097] [<ffffffffa01ff13d>] 
? release_extent_buffer+0x9d/0xa4 [btrfs]
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966108] [<ffffffffa02050a6>] 
? btrfs_shrink_device+0x1f8/0x35e [btrfs]
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966120] [<ffffffffa0207422>] 
? btrfs_rm_device+0x2a0/0x692 [btrfs]
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966131] [<ffffffffa020ee58>] 
? btrfs_ioctl+0xa4a/0x206e [btrfs]
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966133] [<ffffffff810e4bc4>] 
? handle_mm_fault+0x200/0x839
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966135] [<ffffffff81117d3c>] 
? user_path_at_empty+0x7b/0xa8
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966138] [<ffffffff81392354>] 
? __do_page_fault+0x33a/0x3e0
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966140] [<ffffffff811194a8>] 
? do_vfs_ioctl+0x3ed/0x436
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966142] [<ffffffff8110f978>] 
? SYSC_newstat+0x25/0x2d
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966144] [<ffffffff8111953a>] 
? SyS_ioctl+0x49/0x77
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966146] [<ffffffff8138f9a2>] 
? page_fault+0x22/0x30
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966148] [<ffffffff81394562>] 
? system_call_fastpath+0x16/0x1b
Jul  2 00:14:47 hsad-srv-03 kernel: [106695.966149] Code: 0f 39 d0 0f 94 
c0 0f b6 c0 c3 31 c0 48 81 ff f8 f2 38 81 72 0c 31 c0 48 81 ff 5e f6 38 
81 0f 92 c0 c3 b8 00 00 01 00 f0 0f c1 07 <89> c2 c1 ea 10 66 39 c2 74 
0c 66 8b 07 66 39 d0 74 04 f3 90 eb

After that the system was frozen. There was no responding of Keyboard Input.

Best regards,
Florian
