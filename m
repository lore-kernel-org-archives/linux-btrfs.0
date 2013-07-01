Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eta.wiserhosting.co.uk ([85.92.82.55]:56259 "EHLO
	eta.wiserhosting.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab3GBAFI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 20:05:08 -0400
Received: from cpc4-ando6-2-0-cust161.15-1.cable.virginmedia.com ([81.100.34.162]:37687 helo=[172.16.100.144])
	by eta.wiserhosting.co.uk with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.80)
	(envelope-from <pete@petezilla.co.uk>)
	id 1Utmzz-0007ET-Dj
	for linux-btrfs@vger.kernel.org; Mon, 01 Jul 2013 23:55:07 +0100
Message-ID: <51D2091E.9010800@petezilla.co.uk>
Date: Mon, 01 Jul 2013 23:56:30 +0100
From: Peter Chant <pete@petezilla.co.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Hardware failure or btrfs issue?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sirs,

my recently slowing file system is now going read only after trying a 
defrag or other operation.  I'm wondering whether this is the result of 
a hardware failure or a btrfs or some other issue.  Output of dmesg:

   127.750401] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  127.750494] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[  127.750590] Process btrfs-cleaner (pid: 1346, threadinfo 
ffff8800687ec000, task ffff88006d742a00)
[  127.750704] Stack:
[  127.750733]  ffff880068024c38 ffff88006a9a0438 ffff8800687ede48 
ffff880069928800
[  127.750850]  ffff88006d742a00 ffff88006d742a00 ffff88006d742a00 
0000000000000000
[  127.750968]  ffff8800687edeb8 ffffffff812b8c29 ffff880069928800 
0000000000000000
[  127.751085] Call Trace:
[  127.751122]  [<ffffffff812b8c29>] cleaner_kthread+0xa9/0x120
[  127.751200]  [<ffffffff812b8b80>] ? write_dev_flush.part.107+0xc0/0xc0
[  127.751289]  [<ffffffff81069450>] kthread+0xc0/0xd0
[  127.751354]  [<ffffffff81069390>] ? kthread_create_on_node+0x130/0x130
[  127.751444]  [<ffffffff816976dc>] ret_from_fork+0x7c/0xb0
[  127.751516]  [<ffffffff81069390>] ? kthread_create_on_node+0x130/0x130
[  127.751602] Code: 44 28 3f 85 c0 7f 83 31 d2 31 f6 4c 89 ff e8 f7 c5 
fe ff eb 84 0f 1f 44 00 00 48 83 c4 18 31 c0 5b 41 5c 41 5d 41 5e 41 5f 
5d c3 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 66 66 66 66 90 48
[  127.752207] RIP  [<ffffffff812c1611>] 
btrfs_clean_old_snapshots+0x131/0x140
[  127.752305]  RSP <ffff8800687ede38>
[  127.752371] ---[ end trace cc41fa39a41b468e ]---
[  127.862825] btrfs: corrupt leaf, bad key order: 
block=2837196627968,root=1, slot=121
[  127.862938] ------------[ cut here ]------------
[  127.863009] WARNING: at fs/btrfs/super.c:255 
__btrfs_abort_transaction+0xdf/0x100()
[  127.863110] Hardware name: System Product Name
[  127.863171] btrfs: Transaction aborted
[  127.863222] Modules linked in: usblp pl2303 usbserial hid_generic 
usbhid hid usb_storage lp ppdev parport_pc parport snd_hda_codec_via 
sp5100_tco acpi_cpufreq mperf freq_table kvm_amd kvm evdev radeon ttm 
drm_kms_helper psmouse drm serio_raw agpgart i2c_algo_bit microcode 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc i2c_piix4 
snd_timer snd atl1e ohci_hcd via_rhine i2c_core shpchp soundcore 
ehci_pci ehci_hcd mii wmi k10temp asus_atk0110 processor thermal_sys 
hwmon button
[  127.864073] Pid: 1347, comm: btrfs-transacti Tainted: G D      3.9.3 #1
[  127.864167] Call Trace:
[  127.864204]  [<ffffffff8104614f>] warn_slowpath_common+0x7f/0xc0
[  127.864285]  [<ffffffff81046246>] warn_slowpath_fmt+0x46/0x50
[  127.864370]  [<ffffffff812962ef>] __btrfs_abort_transaction+0xdf/0x100
[  127.864460]  [<ffffffff812a71f2>] __btrfs_free_extent+0x242/0x870
[  127.864543]  [<ffffffff813046bc>] ? btrfs_merge_delayed_refs+0x1fc/0x3c0
[  127.870518]  [<ffffffff812ab59b>] run_clustered_refs+0x50b/0xc40
[  127.876503]  [<ffffffff81303813>] ? find_ref_head+0x83/0xf0
[  127.882501]  [<ffffffff812af6b0>] btrfs_run_delayed_refs+0xe0/0x570
[  127.882503]  [<ffffffff812bfb9a>] btrfs_commit_transaction+0xea/0xad0
[  127.882505]  [<ffffffff81069b90>] ? finish_wait+0x80/0x80
[  127.882513]  [<ffffffff812b8605>] transaction_kthread+0x1a5/0x220
[  127.882517]  [<ffffffff812b8460>] ? 
btree_readpage_end_io_hook+0x2a0/0x2a0
[  127.882520]  [<ffffffff81069450>] kthread+0xc0/0xd0
[  127.882521]  [<ffffffff81069390>] ? kthread_create_on_node+0x130/0x130
[  127.882523]  [<ffffffff816976dc>] ret_from_fork+0x7c/0xb0
[  127.882524]  [<ffffffff81069390>] ? kthread_create_on_node+0x130/0x130
[  127.882525] ---[ end trace cc41fa39a41b468f ]---
[  127.882527] BTRFS error (device sdb) in __btrfs_free_extent:5394: IO 
failure
[  127.882528] btrfs: run_one_delayed_ref returned -5
[  127.882529] BTRFS error (device sdb) in btrfs_run_delayed_refs:2565: 
IO failure

Not that I've done anything other than a cursory check but it looks like 
the read only data is fine.

Pete

