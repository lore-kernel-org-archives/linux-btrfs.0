Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:42464 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632AbbDDV2b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Apr 2015 17:28:31 -0400
Received: from mail-in-15-z2.arcor-online.net (mail-in-15-z2.arcor-online.net [151.189.8.32])
	by mx.arcor.de (Postfix) with ESMTP id 3lKB7x2Y2hzQPhH
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Apr 2015 23:28:29 +0200 (CEST)
Received: from mail-in-02.arcor-online.net (mail-in-02.arcor-online.net [151.189.21.42])
	by mail-in-15-z2.arcor-online.net (Postfix) with ESMTP id 5283C116525
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Apr 2015 23:28:29 +0200 (CEST)
Received: from [192.168.0.15] (ip-109-90-139-73.hsi11.unitymediagroup.de [109.90.139.73])
	(Authenticated sender: ochi@arcor.de)
	by mail-in-02.arcor-online.net (Postfix) with ESMTPA id 3lKB7x1FRRz1Smq
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Apr 2015 23:28:29 +0200 (CEST)
Message-ID: <5520577C.5070305@arcor.de>
Date: Sat, 04 Apr 2015 23:28:28 +0200
From: Ochi <ochi@arcor.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: kernel BUG at fs/btrfs/inode.c:3142
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

it seems like I triggered a bug after deleting some (actually all) 
subvolumes from a 2 TB backup volume (about 1.5 TB worth of data, around 
20 subvolumes, btrfs-cleaner took quite a long time), and running a 
"btrfs filesystem defrag ." within the volume afterwards, after cleaner 
seemed to have finished. I rebooted (had to reset because the shutdown 
process didn't finish) and tried the defrag again which immediately 
triggered the same bug.

dmesg:

[38016.025970] ------------[ cut here ]------------
[38016.025976] kernel BUG at fs/btrfs/inode.c:3142!
[38016.025978] invalid opcode: 0000 [#1] PREEMPT SMP
[38016.025980] Modules linked in: ses enclosure uas usb_storage 
nvidia_uvm(PO) fuse xt_addrtype xt_conntrack ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables bridge 
stp llc cfg80211 rfkill snd_hda_codec_hdmi ext4 crc16 mbcache jbd2 
snd_hda_codec_realtek iTCO_wdt snd_hda_codec_generic iTCO_vendor_support 
gpio_ich coretemp mousedev nvidia(PO) ppdev mxm_wmi evdev psmouse 
kvm_intel serio_raw mac_hid kvm winbond_cir i2c_i801 lpc_ich rc_core 
led_class tpm_tis drm tpm parport_pc acpi_cpufreq snd_hda_intel parport 
wmi snd_hda_controller processor snd_hda_codec button snd_hwdep snd_pcm 
e1000e snd_timer snd soundcore i7core_edac shpchp ptp pps_core edac_core 
i5500_temp sch_fq_codel asc7621 hwmon i2c_core nfs lockd
[38016.026011]  grace sunrpc fscache btrfs xor raid6_pq xts gf128mul 
algif_skcipher af_alg dm_crypt dm_mod ata_generic pata_acpi hid_generic 
usbhid hid sr_mod cdrom sd_mod pata_marvell atkbd libps2 crc32c_intel 
ahci libahci firewire_ohci libata ehci_pci uhci_hcd firewire_core 
crc_itu_t ehci_hcd scsi_mod usbcore usb_common i8042 serio
[38016.026029] CPU: 1 PID: 8534 Comm: btrfs-cleaner Tainted: P 
IO   3.19.2-1-ARCH #1
[38016.026031] Hardware name:                  /DX58SO, BIOS 
SOX5810J.86A.5599.2012.0529.2218 05/29/2012
[38016.026032] task: ffff8803206193e0 ti: ffff8800b49ec000 task.ti: 
ffff8800b49ec000
[38016.026034] RIP: 0010:[<ffffffffa035dea0>]  [<ffffffffa035dea0>] 
btrfs_orphan_add+0x1c0/0x1e0 [btrfs]
[38016.026049] RSP: 0018:ffff8800b49efc38  EFLAGS: 00010286
[38016.026051] RAX: 00000000ffffffe4 RBX: ffff8800cb1b7000 RCX: 
000000000000002d
[38016.026052] RDX: 0000000000010000 RSI: 0000000000010000 RDI: 
ffff8801f057e138
[38016.026053] RBP: ffff8800b49efc78 R08: 000000000001b9d0 R09: 
ffff88003251f3f0
[38016.026054] R10: ffff88032fc3c540 R11: ffffea0008d0c240 R12: 
ffff88001ab1bad0
[38016.026055] R13: ffff8800cacbef20 R14: ffff8800cb1b7458 R15: 
0000000000000001
[38016.026057] FS:  0000000000000000(0000) GS:ffff88032fc20000(0000) 
knlGS:0000000000000000
[38016.026058] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[38016.026059] CR2: 00007fcb1f50d090 CR3: 0000000001811000 CR4: 
00000000000007e0
[38016.026060] Stack:
[38016.026061]  ffff8800b49efc78 ffffffffa039f355 ffff8801f057e000 
ffff880313981800
[38016.026063]  ffff88003251f3f0 ffff88001ab1bad0 ffff88031d5eda00 
ffff880233fb7480
[38016.026065]  ffff8800b49efd08 ffffffffa0346c99 ffff88003251f3f8 
ffff88003251f470
[38016.026067] Call Trace:
[38016.026078]  [<ffffffffa039f355>] ? lookup_free_space_inode+0x45/0xf0 
[btrfs]
[38016.026087]  [<ffffffffa0346c99>] 
btrfs_remove_block_group+0x149/0x780 [btrfs]
[38016.026097]  [<ffffffffa03823db>] btrfs_remove_chunk+0x6fb/0x7e0 [btrfs]
[38016.026105]  [<ffffffffa0347519>] btrfs_delete_unused_bgs+0x249/0x270 
[btrfs]
[38016.026114]  [<ffffffffa034eae4>] cleaner_kthread+0x144/0x1a0 [btrfs]
[38016.026123]  [<ffffffffa034e9a0>] ? 
btrfs_destroy_pinned_extent+0xe0/0xe0 [btrfs]
[38016.026128]  [<ffffffff81091748>] kthread+0xd8/0xf0
[38016.026130]  [<ffffffff81091670>] ? kthread_create_on_node+0x1c0/0x1c0
[38016.026133]  [<ffffffff81562758>] ret_from_fork+0x58/0x90
[38016.026135]  [<ffffffff81091670>] ? kthread_create_on_node+0x1c0/0x1c0
[38016.026136] Code: 60 04 00 00 e9 b0 fe ff ff 66 90 89 45 c8 f0 41 80 
64 24 80 fd 4c 89 e7 e8 2e 14 fe ff 8b 45 c8 e9 1b ff ff ff 66 0f 1f 44 
00 00 <0f> 0b b8 f4 ff ff ff e9 10 ff ff ff 4c 89 f7 45 31 f6 e8 99 40
[38016.026156] RIP  [<ffffffffa035dea0>] btrfs_orphan_add+0x1c0/0x1e0 
[btrfs]
[38016.026164]  RSP <ffff8800b49efc38>
[38016.026167] ---[ end trace d42bede17d45ec34 ]---


btrfs fi df:

Data, single: total=1.02TiB, used=437.50MiB
System, DUP: total=8.00MiB, used=128.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=7.00GiB, used=1.02MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=4.00MiB, used=3.87MiB


BTW, it's interesting that 437 MB of data are used since there are no 
files left on the volume.

Please let me know how I can help you to debug this.


Best regards,
Sebastian
