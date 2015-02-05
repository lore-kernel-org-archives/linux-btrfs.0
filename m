Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demeter.krystal.co.uk ([77.72.0.226]:59820 "EHLO
	demeter.krystal.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbbBEDfL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 22:35:11 -0500
Received: from host86-146-212-58.range86-146.btcentralplus.com ([86.146.212.58]:55266 helo=[192.168.1.40])
	by demeter.krystal.co.uk with esmtpsa (TLSv1:DHE-RSA-CAMELLIA256-SHA:256)
	(Exim 4.84)
	(envelope-from <ktg@ctac.me.uk>)
	id 1YJCoT-002T9i-0z
	for linux-btrfs@vger.kernel.org; Thu, 05 Feb 2015 03:09:05 +0000
Message-ID: <54D2DEBF.1080404@ctac.me.uk>
Date: Thu, 05 Feb 2015 03:08:47 +0000
From: Chris Baker <ktg@ctac.me.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: kernel BUG at fs/btrfs/inode.c:3123!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This report also filed on Bugzilla on kernel.org per instructions on 
btrfs Wiki, ID: 92771

Circumstances

Bug appeared during a btrfs send operation, from a Sata system drive to 
a USB 3 connected portable drive.

The bug occurred around 7GB into a 500GB transfer.

The USB disk is encrypted AES-256 via cryptsetup. Originally setup and 
formatted 26-Oct-14 on whatever the latest Arch linux & btrfs tools were 
at that point,  the original snap copy was stored via btrfs send, approx 
500GB.

Today the disk was reattached for the first time since October, the old 
snap was deleted with:

     sudo btrfs subvolume delete -c usb_snap

Immediately after a new send was started with:

     sudo btrfs send sever_snap | sudo btrfs receive usb_snap

I note that my Google-fu found 2 other recent reports mentioning 
fs/btrfs/inode.c:3123! to linux-btrfs:
* Tomasz Chmielewski on 20 Dec 2014
* Fengguang Wu on 10 Oct 2014

I could not see these on Bugzilla, hence my report. I apologise if my 
search skills failed me, I could not see any resolution.

$ uname -a
Linux ts140a 3.18.5-1-ARCH #1 SMP PREEMPT Fri Jan 30 07:31:50 CET 2015 
x86_64 GNU/Linux
$ btrfs --version
Btrfs v3.18.1
$ btrfs fi show
Btrfs v3.18.1
$ btrfs fi df /media/secureUSB/
Data, single: total=273.01GiB, used=7.05GiB
System, DUP: total=8.00MiB, used=48.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=2.00GiB, used=66.28MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=32.00MiB, used=0.00B

[18312.185891] usb 4-4: new SuperSpeed USB device number 2 using xhci_hcd
[18312.200213] usb-storage 4-4:1.0: USB Mass Storage device detected
[18312.200299] scsi host7: usb-storage 4-4:1.0
[18315.223903] scsi 7:0:0:0: Direct-Access     HitachiG ST               
0000 PQ: 0 ANSI: 6
[18317.245534] sd 7:0:0:0: [sdc] 1953523708 512-byte logical blocks: 
(1.00 TB/931 GiB)
[18317.245799] sd 7:0:0:0: [sdc] Write Protect is off
[18317.245804] sd 7:0:0:0: [sdc] Mode Sense: 27 00 00 00
[18317.246023] sd 7:0:0:0: [sdc] No Caching mode page found
[18317.246733] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[18317.359178]  sdc: sdc1 sdc2 sdc3
[18317.360056] sd 7:0:0:0: [sdc] Attached SCSI disk
[24727.038743] BTRFS: device label CARD Rescue Disk devid 1 transid 351 
/dev/dm-0
[24727.228345] BTRFS info (device dm-0): disk space caching is enabled
[25088.256677] ------------[ cut here ]------------
[25088.257101] kernel BUG at fs/btrfs/inode.c:3123!
[25088.257503] invalid opcode: 0000 [#1] PREEMPT SMP
[25088.257943] Modules linked in: dm_crypt algif_skcipher af_alg dm_mod 
cfg80211 rfkill coretemp hwmon intel_rapl x86_pkg_temp_thermal 
intel_powerclamp kvm_intel btrfs xor snd_hda_codec_realtek 
snd_hda_codec_generic kvm snd_hda_intel snd_hda_controller raid6_pq 
crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel 
snd_hda_codec aesni_intel aes_x86_64 lrw snd_hwdep snd_pcm gf128mul 
snd_timer ppdev evdev glue_helper iTCO_wdt iTCO_vendor_support psmouse 
mac_hid ablk_helper i915 drm_kms_helper drm cryptd serio_raw pcspkr 
tpm_tis intel_gtt tpm e1000e i2c_i801 i2c_algo_bit i2c_core mei_me mei 
ptp snd soundcore thermal wmi ie31200_edac edac_core video fan lpc_ich 
parport_pc shpchp parport battery button pps_core processor sch_fq_codel 
ext4 crc16 mbcache jbd2 uas usb_storage sr_mod cdrom sd_mod atkbd
[25088.264996]  libps2 ahci libahci libata xhci_pci ehci_pci scsi_mod 
xhci_hcd ehci_hcd usbcore usb_common i8042 serio
[25088.265918] CPU: 3 PID: 24953 Comm: btrfs-cleaner Not tainted 
3.18.5-1-ARCH #1
[25088.266549] Hardware name: LENOVO ThinkServer TS140/ThinkServer 
TS140, BIOS FBKT82AUS 04/02/2014
[25088.267318] task: ffff880101cc64a0 ti: ffff880013620000 task.ti: 
ffff880013620000
[25088.267972] RIP: 0010:[<ffffffffa066a6d0>]  [<ffffffffa066a6d0>] 
btrfs_orphan_add+0x1c0/0x1e0 [btrfs]
[25088.268797] RSP: 0018:ffff880013623c38  EFLAGS: 00010286
[25088.269258] RAX: 00000000ffffffe4 RBX: ffff880402564000 RCX: 
0000000000000085
[25088.284983] RDX: 0000000000040000 RSI: 0000000000040000 RDI: 
ffff8803ffd51138
[25088.300825] RBP: ffff880013623c78 R08: 000000000001b2a0 R09: 
ffff880103ee02d0
[25088.316749] R10: ffff88041eb9be10 R11: ffffea000dfc1740 R12: 
ffff8800ce9d58e0
[25088.332206] R13: ffff880400e3c840 R14: ffff880402564458 R15: 
0000000000000001
[25088.347278] FS:  0000000000000000(0000) GS:ffff88041eb80000(0000) 
knlGS:0000000000000000
[25088.376992] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25088.392231] CR2: 00007faa7d857000 CR3: 0000000001811000 CR4: 
00000000001407e0
[25088.407565] Stack:
[25088.422398]  ffff880013623c78 ffffffffa06ab595 ffff8803ffd51000 
ffff880402dbe000
[25088.452291]  ffff880103ee02d0 0000000000000001 ffff8800ce9d58e0 
ffff8800139e4600
[25088.482088]  ffff880013623d08 ffffffffa0653655 ffff880103ee02d8 
ffff880103ee0350
[25088.511893] Call Trace:
[25088.526267]  [<ffffffffa06ab595>] ? lookup_free_space_inode+0x45/0xf0 
[btrfs]
[25088.540940]  [<ffffffffa0653655>] 
btrfs_remove_block_group+0x145/0x540 [btrfs]
[25088.569257]  [<ffffffffa068e839>] btrfs_remove_chunk+0x709/0x820 [btrfs]
[25088.583683]  [<ffffffffa0653c6e>] btrfs_delete_unused_bgs+0x21e/0x250 
[btrfs]
[25088.597927]  [<ffffffffa065b254>] cleaner_kthread+0x154/0x1b0 [btrfs]
[25088.611956]  [<ffffffffa065b100>] ? 
btrfs_destroy_pinned_extent+0xe0/0xe0 [btrfs]
[25088.639203]  [<ffffffff81090e3a>] kthread+0xea/0x100
[25088.652771]  [<ffffffff81090d50>] ? kthread_create_on_node+0x1c0/0x1c0
[25088.666254]  [<ffffffff815552fc>] ret_from_fork+0x7c/0xb0
[25088.679401]  [<ffffffff81090d50>] ? kthread_create_on_node+0x1c0/0x1c0
[25088.692562] Code: 60 04 00 00 e9 b0 fe ff ff 66 90 89 45 c8 f0 41 80 
64 24 80 fd 4c 89 e7 e8 0e 16 fe ff 8b 45 c8 e9 1b ff ff ff 66 0f 1f 44 
00 00 <0f> 0b b8 f4 ff ff ff e9 10 ff ff ff 4c 89 f7 45 31 f6 e8 69 a2
[25088.733126] RIP  [<ffffffffa066a6d0>] btrfs_orphan_add+0x1c0/0x1e0 
[btrfs]
[25088.746891]  RSP <ffff880013623c38>
[25088.778367] ---[ end trace 2ea2e74ef404d7c8 ]---

