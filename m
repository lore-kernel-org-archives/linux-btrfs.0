Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:51436 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab3ALOrr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Jan 2013 09:47:47 -0500
Message-ID: <50F17790.3080606@adc-wiedemann.de>
Date: Sat, 12 Jan 2013 15:47:44 +0100
From: Lars Weber <Lars.Weber@adc-wiedemann.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: kernel BUG at fs/btrfs/inode.c:3865!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

i got this message while i was running a balance, after adding the two 
smaller disks.
But it seems that the Bug was triggered from a java process working on 
that disk?!

After the Bug message the balance process was blocked.
There was no further process or diskload from that process.

I had to reset the system.
[   10.072178] Btrfs loaded
[   10.072750] device fsid 51b929a2-163f-4b47-8ac4-038670e80676 devid 3 
transid 26081 /dev/sdc
[   10.073757] btrfs: disk space caching is enabled
[   10.074134] btrfs: failed to read the system array on sdc
[   10.074400] btrfs: open_ctree failed

But after a manual mount everything was "fine" again:
[  104.990461] device fsid 51b929a2-163f-4b47-8ac4-038670e80676 devid 1 
transid 26081 /dev/sdb
[  105.407555] device fsid 51b929a2-163f-4b47-8ac4-038670e80676 devid 2 
transid 26081 /dev/sdd
[  105.810686] device fsid 51b929a2-163f-4b47-8ac4-038670e80676 devid 3 
transid 26081 /dev/sdc
[  117.531293] device fsid 51b929a2-163f-4b47-8ac4-038670e80676 devid 1 
transid 26081 /dev/sdb
[  117.532602] btrfs: disk space caching is enabled
[  120.927683] btrfs: unlinked 1 orphans
[  120.945804] btrfs: continuing balance
[  144.562543] btrfs: relocating block group 214777724928 flags 1
[  149.250326] btrfs: unlinked 2 orphans

Maybe this informations can help you to make the btrfs more stable - i 
really like the features :-)

Kind regards
Lars


btrfs balance start dconvert=raid1 mconvert=raid1 /data/

uname -a
Linux n40l 3.7.1 #1 SMP Mon Dec 31 09:55:24 CET 2012 x86_64 GNU/Linux

btrfs fi show
Label: none  uuid: 51b929a2-163f-4b47-8ac4-038670e80676
     Total devices 3 FS bytes used 2.14TB
     devid    3 size 1.36TB used 1.22TB path /dev/sdc
     devid    2 size 1.36TB used 1.22TB path /dev/sdd
     devid    1 size 2.73TB used 1.78TB path /dev/sdb

Btrfs v0.20-rc1-37-g91d9eec

[125072.382549] btrfs: relocating block group 214777724928 flags 1
[125109.399900] btrfs: found 185 extents
[125124.476225] btrfs: found 185 extents
[125128.126892] ------------[ cut here ]------------
[125128.130251] kernel BUG at fs/btrfs/inode.c:3865!
[125128.133866] invalid opcode: 0000 [#1] SMP
[125128.137439] Modules linked in: ip6table_filter ip6_tables 
ebtable_nat ebtables ipt_REJECT xt_tcpudp iptable_filter ip_tables 
x_tables bridge stp llc nfsd nfs_acl auth_rpcgss nfs fscache lockd 
sunrpc btrfs zlib_deflate crc32c libcrc32c ext2 loop radeon evdev ttm 
drm_kms_helper drm snd_pcm snd_timer snd soundcore snd_page_alloc 
amd64_edac_mod k10temp edac_core tpm_tis sp5100_tco tpm processor 
i2c_piix4 i2c_algo_bit edac_mce_amd button tpm_bios pcspkr i2c_core 
kvm_amd kvm shpchp thermal_sys microcode ext4 mbcache jbd2 crc16 dm_mod 
sd_mod crc_t10dif ohci_hcd ahci libahci libata tg3 libphy scsi_mod 
ehci_hcd usbcore usb_common
[125128.157060] CPU 0
[125128.157100] Pid: 6850, comm: java Not tainted 3.7.1 #1 HP ProLiant 
MicroServer
[125128.165237] RIP: 0010:[<ffffffffa03e5e89>]  [<ffffffffa03e5e89>] 
btrfs_evict_inode+0x202/0x2dc [btrfs]
[125128.169520] RSP: 0018:ffff880050547df8  EFLAGS: 00010286
[125128.173785] RAX: 00000000ffffffe4 RBX: ffff88004fc7a5f8 RCX: 
000000000000df3e
[125128.178091] RDX: 000000000b690b69 RSI: ffff88000f947848 RDI: 
ffff88000f947890
[125128.182425] RBP: ffff880037c0f800 R08: 000000000000011a R09: 
ffff88005b13c598
[125128.186756] R10: ffff88005b13c598 R11: ffff88005b13c598 R12: 
ffff88005b13c598
[125128.191111] R13: ffff880073b15540 R14: 0000000000020000 R15: 
ffff880072518140
[125128.195498] FS:  00007fe624bbf700(0000) GS:ffff880077c00000(0000) 
knlGS:0000000000000000
[125128.199936] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[125128.204367] CR2: 00007fe62b929028 CR3: 00000000747fb000 CR4: 
00000000000007f0
[125128.208852] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[125128.213325] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[125128.217781] Process java (pid: 6850, threadinfo ffff880050546000, 
task ffff8800131dd140)
[125128.222310] Stack:
[125128.226746]  ffff880050547df0 0000000000000000 0000000000000000 
ffff88004fc7a5f8
[125128.231282]  ffff88004fc7a6f8 ffffffffa0428440 dead000000100100 
ffff88004fc3a800
[125128.235783]  ffff880074b8f890 ffffffff81123c45 ffff88004fc3a800 
ffff88006bc5d0c0
[125128.240281] Call Trace:
[125128.244734]  [<ffffffff81123c45>] ? evict+0xa3/0x158
[125128.249244]  [<ffffffff81121c44>] ? dentry_kill+0x150/0x16e
[125128.253851]  [<ffffffff811222d9>] ? dput+0xed/0xf9
[125128.258361]  [<ffffffff81111d8c>] ? __fput+0x196/0x1ae
[125128.262865]  [<ffffffff8105a0c7>] ? task_work_run+0x7f/0x96
[125128.267384]  [<ffffffff8100f563>] ? do_notify_resume+0x56/0x67
[125128.271891]  [<ffffffff8105a185>] ? task_work_add+0x47/0x4e
[125128.276405]  [<ffffffff813938a2>] ? int_signal+0x12/0x17
[125128.280963] Code: ff ff 83 f8 e4 75 4f 48 8b 85 e8 01 00 00 48 89 da 
48 89 ee 4c 89 e7 48 05 90 01 00 00 49 89 44 24 40 e8 cb 9f ff ff 85 c0 
74 04 <0f> 0b eb fe 49 8b 44 24 28 48 89 ee 4c 89 e7 48 89 44 24 08 e8
[125128.290503] RIP  [<ffffffffa03e5e89>] btrfs_evict_inode+0x202/0x2dc 
[btrfs]
[125128.295170]  RSP <ffff880050547df8>
[125128.316881] ---[ end trace 9a9c4f2a5cfda34a ]---

