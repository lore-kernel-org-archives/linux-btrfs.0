Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.54]:37424 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964934Ab3GCSnp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 14:43:45 -0400
Received: from 139.24.34.95.customer.cdi.no ([95.34.24.139]:38498 helo=[10.0.0.6])
	by smtp.domeneshop.no with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <lists@skagestad.org>)
	id 1UuRuG-0002sw-PP
	for linux-btrfs@vger.kernel.org; Wed, 03 Jul 2013 20:35:56 +0200
Message-ID: <51D46F04.6010301@skagestad.org>
Date: Wed, 03 Jul 2013 20:35:48 +0200
From: =?ISO-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Scrub causes oom after removal of failed disk (linux 3.10)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi btrfs devs,

I have a btrfs raid10 array consisting of 2TB drives.

I added a new drive to the array, then balanced.
The balance failed after ~50GB was moved to the new drive.
The balance fixed lots of errors according to dmesg.

Server rebooted

The newly added drive were no longer detected as a btrfs disk.
The array was then mounted -o recovery
I ran btrfs dev del missing, and everything seemed to be fine.

After this I ran a scrub on the array.
The scrub was soon stopped by the oom-killer.

After another reboot I started a new scrub.
About 3TB into the scrub over 10 GB of memory was being consumed.
The scrub had then fixed roughly 3,000,000 errors.

Canceling the scrub and resuming it frees the 10 GB of memory.

I'm assuming this is not expected behavior.
If I can help in any way please let me know.

dmesg from the failed balance:

[68190.748909] btrfs csum failed ino 1512 extent 1540228509696 csum 
2089345036 wanted 864794082 mirror 1
[68190.809090] BUG: unable to handle kernel paging request at 
ffff87fe167a32c0
[68190.814638] IP: [<ffffffffa0272287>] repair_io_failure+0x117/0x230 
[btrfs]
[68190.820709] PGD 0
[68190.826781] Oops: 0000 [#1] SMP
[68190.833090] Modules linked in: xfs ip6table_filter ip6_tables 
ebtable_nat ebtables ipt_MASQUERADE ipt_REJECT xt_CHECKSUM sch_prio 
bridge stp llc dm_crypt xt_state iptable_filter xt_CLASSIFY xt_tcpudp 
xt_DSCP iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables intel_powerclamp 
kvm_intel kvm psmouse serio_raw microcode lpc_ich ppdev parport_pc 
w83627ehf hwmon_vid coretemp nfsd nfs_acl auth_rpcgss nfs lp fscache 
lockd parport sunrpc btrfs zlib_deflate libcrc32c raid10 raid1 raid0 
multipath linear raid456 async_pq async_xor xor async_memcpy 
async_raid6_recov raid6_pq async_tx hid_generic usbhid hid ast ttm 
drm_kms_helper crc32_pclmul ghash_clmulni_intel drm aesni_intel 
ablk_helper cryptd lrw i2c_algo_bit gf128mul sysimgblt glue_helper 
sysfillrect aes_x86_64 syscopyarea e1000e mpt2sas ahci ptp libahci 
scsi_transport_sas pps_core raid_class video
[68190.926164] CPU: 3 PID: 16472 Comm: btrfs-endio-8 Not tainted 3.10.0+ #11
[68190.941478] Hardware name: To be filled by O.E.M. To be filled by 
O.E.M./P8B-X series, BIOS 2107 05/04/2012
[68190.957876] task: ffff880125fe1740 ti: ffff8802cb6ee000 task.ti: 
ffff8802cb6ee000
[68190.974836] RIP: 0010:[<ffffffffa0272287>] [<ffffffffa0272287>] 
repair_io_failure+0x117/0x230 [btrfs]
[68190.992754] RSP: 0018:ffff8802cb6efca8  EFLAGS: 00010287
[68191.010933] RAX: fffffffa43a60fe8 RBX: 0000000000001000 RCX: 
0000019e1ce5e000
[68191.029830] RDX: ffff8803d2d422a0 RSI: ffff8802cb6efcc0 RDI: 
ffff8803dd444be0
[68191.049014] RBP: ffff8802cb6efd18 R08: 0000000000000000 R09: 
0000000000000000
[68191.068584] R10: ffffffffc2d195ff R11: 0000000000003fb5 R12: 
ffff880416adc000
[68191.088446] R13: 00000929834ae000 R14: 00000000c2d19600 R15: 
ffff8803db4c5910
[68191.108648] FS:  0000000000000000(0000) GS:ffff88042fcc0000(0000) 
knlGS:0000000000000000
[68191.129491] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[68191.150587] CR2: ffff87fe167a32c0 CR3: 0000000001c0c000 CR4: 
00000000001427e0
[68191.172318] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[68191.194339] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[68191.216403] Stack:
[68191.238415]  000000000006c000 ffffea0005becf40 0000000000002000 
ffff8803d2d422a0
[68191.261527]  ffff880200000000 ffffffff00000000 ffff8802cb6efcd8 
ffff8802cb6efcd8
[68191.285026]  ffff8802cb6efd18 000000000006c000 ffff8802137488a0 
ffffea0005becf40
[68191.308855] Call Trace:
[68191.332739]  [<ffffffffa0272bdf>] end_bio_extent_readpage+0x78f/0x7f0 
[btrfs]
[68191.357675]  [<ffffffff811a38ad>] bio_endio+0x1d/0x30
[68191.382816]  [<ffffffffa024cf41>] end_workqueue_fn+0x41/0x50 [btrfs]
[68191.408455]  [<ffffffffa02822d8>] worker_loop+0x148/0x520 [btrfs]
[68191.434422]  [<ffffffff816902c7>] ? __schedule+0x3d7/0x800
[68191.460669]  [<ffffffffa0282190>] ? btrfs_queue_worker+0x320/0x320 
[btrfs]
[68191.487415]  [<ffffffff81064410>] kthread+0xc0/0xd0
[68191.514246]  [<ffffffff81064350>] ? kthread_create_on_node+0x130/0x130
[68191.541603]  [<ffffffff81699f1c>] ret_from_fork+0x7c/0xb0
[68191.569187]  [<ffffffff81064350>] ? kthread_create_on_node+0x130/0x130
[68191.597279] Code: a0 e8 4e c1 00 00 85 c0 0f 85 b6 00 00 00 48 8b 55 
a8 44 3b 72 2c 0f 85 e8 00 00 00 45 8d 56 ff 4d 63 d2 4b 8d 04 52 48 c1 
e0 03 <4c> 8b 6c 02 38 49 c1 ed 09 4d 89 2f 48 8b 7d a8 4c 8b 64 07 30
[68191.657235] RIP  [<ffffffffa0272287>] repair_io_failure+0x117/0x230 
[btrfs]
[68191.687689]  RSP <ffff8802cb6efca8>
[68191.718273] CR2: ffff87fe167a32c0
[68191.870900] ---[ end trace ad5eb9d56280bbe5 ]---
[68191.870902] BUG: unable to handle kernel paging request at 
ffff87f6dfa7da60
[68191.870910] IP: [<ffffffffa0272287>] repair_io_failure+0x117/0x230 
[btrfs]
[68191.870911] PGD 0
[68191.870912] Oops: 0000 [#2] SMP
[68191.870992] Modules linked in: xfs ip6table_filter ip6_tables 
ebtable_nat ebtables ipt_MASQUERADE ipt_REJECT xt_CHECKSUM sch_prio 
bridge stp llc dm_crypt xt_state iptable_filter xt_CLASSIFY xt_tcpudp 
xt_DSCP iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables intel_powerclamp 
kvm_intel kvm psmouse serio_raw microcode lpc_ich ppdev parport_pc 
w83627ehf hwmon_vid coretemp nfsd nfs_acl auth_rpcgss nfs lp fscache 
lockd parport sunrpc btrfs zlib_deflate libcrc32c raid10 raid1 raid0 
multipath linear raid456 async_pq async_xor xor async_memcpy 
async_raid6_recov raid6_pq async_tx hid_generic usbhid hid ast ttm 
drm_kms_helper crc32_pclmul ghash_clmulni_intel drm aesni_intel 
ablk_helper cryptd lrw i2c_algo_bit gf128mul sysimgblt glue_helper 
sysfillrect aes_x86_64 syscopyarea e1000e mpt2sas ahci ptp libahci 
scsi_transport_sas pps_core raid_class video
[68191.871005] CPU: 7 PID: 16470 Comm: btrfs-endio-7 Tainted: G D      
3.10.0+ #11
[68191.871006] Hardware name: To be filled by O.E.M. To be filled by 
O.E.M./P8B-X series, BIOS 2107 05/04/2012
[68191.871006] task: ffff880125fe5d00 ti: ffff88038a644000 task.ti: 
ffff88038a644000
[68191.871057] RIP: 0010:[<ffffffffa0272287>] [<ffffffffa0272287>] 
repair_io_failure+0x117/0x230 [btrfs]
[68191.871058] RSP: 0018:ffff88038a645ca8  EFLAGS: 00010287
[68191.871059] RAX: fffffff45a38b7e8 RBX: 0000000000001000 RCX: 
0000019e1ce5e000
[68191.871059] RDX: ffff8802856f2240 RSI: ffff88038a645cc0 RDI: 
ffff8803dd444be0
[68191.871060] RBP: ffff88038a645d18 R08: 0000000000000000 R09: 
0000000000000000
[68191.871060] R10: ffffffff83c25cff R11: 0000000000003fb5 R12: 
ffff880416adc000
[68191.871060] R13: 00000929834ae000 R14: 0000000083c25d00 R15: 
ffff88010ff61610
[68191.871061] FS:  0000000000000000(0000) GS:ffff88042fdc0000(0000) 
knlGS:0000000000000000
[68191.871062] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[68191.871062] CR2: ffff87f6dfa7da60 CR3: 0000000001c0c000 CR4: 
00000000001427e0
[68191.871063] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[68191.871067] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[68191.871069] Stack:
[68191.871085]  000000000006a000 ffffea0005becec0 0000000000002000 
ffff8802856f2240
[68191.871092]  ffff880300000000 ffffffff00000000 ffff88038a645cd8 
ffff88038a645cd8
[68191.871101]  ffff88038a645d18 000000000006a000 ffff8803b78652a0 
ffffea0005becec0
[68191.871101] Call Trace:
[68191.871131]  [<ffffffffa0272bdf>] end_bio_extent_readpage+0x78f/0x7f0 
[btrfs]
[68191.871144]  [<ffffffff8104f86a>] ? del_timer_sync+0x5a/0x70
[68191.871168]  [<ffffffff811a38ad>] bio_endio+0x1d/0x30
[68191.871204]  [<ffffffffa024cf41>] end_workqueue_fn+0x41/0x50 [btrfs]
[68191.871314]  [<ffffffffa02822d8>] worker_loop+0x148/0x520 [btrfs]
[68191.871316]  [<ffffffff816902c7>] ? __schedule+0x3d7/0x800
[68191.871344]  [<ffffffffa0282190>] ? btrfs_queue_worker+0x320/0x320 
[btrfs]
[68191.871353]  [<ffffffff81064410>] kthread+0xc0/0xd0
[68191.871361]  [<ffffffff81064350>] ? kthread_create_on_node+0x130/0x130
[68191.871362]  [<ffffffff81699f1c>] ret_from_fork+0x7c/0xb0
[68191.871369]  [<ffffffff81064350>] ? kthread_create_on_node+0x130/0x130
[68191.871381] Code: a0 e8 4e c1 00 00 85 c0 0f 85 b6 00 00 00 48 8b 55 
a8 44 3b 72 2c 0f 85 e8 00 00 00 45 8d 56 ff 4d 63 d2 4b 8d 04 52 48 c1 
e0 03 <4c> 8b 6c 02 38 49 c1 ed 09 4d 89 2f 48 8b 7d a8 4c 8b 64 07 30
[68191.871387] RIP  [<ffffffffa0272287>] repair_io_failure+0x117/0x230 
[btrfs]
[68191.871387]  RSP <ffff88038a645ca8>
[68191.871388] CR2: ffff87f6dfa7da60
[68191.871389] ---[ end trace ad5eb9d56280bbe6 ]---
[68194.333317] repair_io_failure: 12926 callbacks suppressed
[68194.333410] BUG: unable to handle kernel paging request at 
ffff87ff35fe1480
[68194.333439] IP: [<ffffffffa0272287>] repair_io_failure+0x117/0x230 
[btrfs]
[68194.333440] PGD 0
[68194.333441] Oops: 0000 [#3] SMP
[68194.333464] Modules linked in: xfs ip6table_filter ip6_tables 
ebtable_nat ebtables ipt_MASQUERADE ipt_REJECT xt_CHECKSUM sch_prio 
bridge stp llc dm_crypt xt_state iptable_filter xt_CLASSIFY xt_tcpudp 
xt_DSCP iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables intel_powerclamp 
kvm_intel kvm psmouse serio_raw microcode lpc_ich ppdev parport_pc 
w83627ehf hwmon_vid coretemp nfsd nfs_acl auth_rpcgss nfs lp fscache 
lockd parport sunrpc btrfs zlib_deflate libcrc32c raid10 raid1 raid0 
multipath linear raid456 async_pq async_xor xor async_memcpy 
async_raid6_recov raid6_pq async_tx hid_generic usbhid hid ast ttm 
drm_kms_helper crc32_pclmul ghash_clmulni_intel drm aesni_intel 
ablk_helper cryptd lrw i2c_algo_bit gf128mul sysimgblt glue_helper 
sysfillrect aes_x86_64 syscopyarea e1000e mpt2sas ahci ptp libahci 
scsi_transport_sas pps_core raid_class video
[68194.333469] CPU: 7 PID: 16461 Comm: btrfs-endio-6 Tainted: G D      
3.10.0+ #11
[68194.333470] Hardware name: To be filled by O.E.M. To be filled by 
O.E.M./P8B-X series, BIOS 2107 05/04/2012
[68194.333470] task: ffff8804165fae80 ti: ffff88021d67e000 task.ti: 
ffff88021d67e000
[68194.333479] RIP: 0010:[<ffffffffa0272287>] [<ffffffffa0272287>] 
repair_io_failure+0x117/0x230 [btrfs]
[68194.333480] RSP: 0018:ffff88021d67fca8  EFLAGS: 00010287
[68194.333481] RAX: fffffffcb08ee7e8 RBX: 0000000000001000 RCX: 
0000019e1ce5e000
[68194.333482] RDX: ffff8802856f2c60 RSI: ffff88021d67fcc0 RDI: 
ffff8803dd444be0
[68194.333482] RBP: ffff88021d67fd18 R08: 0000000000000000 R09: 
0000000000000000
[68194.333483] R10: ffffffffdcb09eff R11: 0000000000003fb5 R12: 
ffff880416adc000
[68194.333484] R13: 00000929834ae000 R14: 00000000dcb09f00 R15: 
ffff88010ff60510
[68194.333485] FS:  0000000000000000(0000) GS:ffff88042fdc0000(0000) 
knlGS:0000000000000000
[68194.333485] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[68194.333486] CR2: ffff87ff35fe1480 CR3: 0000000001c0c000 CR4: 
00000000001427e0
[68194.333486] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[68194.333487] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[68194.333487] Stack:
[68194.333489]  000000000007b000 ffffea000ecb4300 0000000000002000 
ffff8802856f2c60
[68194.333491]  ffff880200000000 ffffffff00000000 ffff88021d67fcd8 
ffff88021d67fcd8
[68194.333492]  ffff88021d67fd18 000000000007b000 ffff88015964caa0 
ffffea000ecb4300
[68194.333492] Call Trace:
[68194.333502]  [<ffffffffa0272bdf>] end_bio_extent_readpage+0x78f/0x7f0 
[btrfs]
[68194.333506]  [<ffffffff8104f86a>] ? del_timer_sync+0x5a/0x70
[68194.333508]  [<ffffffff811a38ad>] bio_endio+0x1d/0x30
[68194.333516]  [<ffffffffa024cf41>] end_workqueue_fn+0x41/0x50 [btrfs]
[68194.333524]  [<ffffffffa02822d8>] worker_loop+0x148/0x520 [btrfs]
[68194.333527]  [<ffffffff816902c7>] ? __schedule+0x3d7/0x800
[68194.333535]  [<ffffffffa0282190>] ? btrfs_queue_worker+0x320/0x320 
[btrfs]
[68194.333538]  [<ffffffff81064410>] kthread+0xc0/0xd0
[68194.333540]  [<ffffffff81064350>] ? kthread_create_on_node+0x130/0x130
[68194.333542]  [<ffffffff81699f1c>] ret_from_fork+0x7c/0xb0
[68194.333544]  [<ffffffff81064350>] ? kthread_create_on_node+0x130/0x130
[68194.333558] Code: a0 e8 4e c1 00 00 85 c0 0f 85 b6 00 00 00 48 8b 55 
a8 44 3b 72 2c 0f 85 e8 00 00 00 45 8d 56 ff 4d 63 d2 4b 8d 04 52 48 c1 
e0 03 <4c> 8b 6c 02 38 49 c1 ed 09 4d 89 2f 48 8b 7d a8 4c 8b 64 07 30
[68194.333565] RIP  [<ffffffffa0272287>] repair_io_failure+0x117/0x230 
[btrfs]
[68194.333565]  RSP <ffff88021d67fca8>
[68194.333566] CR2: ffff87ff35fe1480
[68194.333567] ---[ end trace ad5eb9d56280bbe7 ]---
[68194.333569] BUG: unable to handle kernel paging request at 
ffff87fc5cadb020
[68194.337640] btrfs_readpage_end_io_hook: 12879 callbacks suppressed
[68194.337654] IP: [<ffffffffa0272287>] repair_io_failure+0x117/0x230 
[btrfs]
[68194.337656] BTRFS info (device dm-12): csum failed ino 342 off 
4614377472 csum 2483052358 private 3782833900
[68194.337656] PGD 0
[68194.337658] Oops: 0000 [#4] SMP
[68194.340552] BTRFS info (device dm-12): csum failed ino 342 off 
4614381568 csum 2495312110 private 2642267845
[68194.340569] Modules linked in: xfs ip6table_filter ip6_tables 
ebtable_nat ebtables ipt_MASQUERADE ipt_REJECT xt_CHECKSUM sch_prio 
bridge stp llc dm_crypt xt_state iptable_filter xt_CLASSIFY xt_tcpudp 
xt_DSCP iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables intel_powerclamp 
kvm_intel kvm psmouse serio_raw microcode lpc_ich ppdev parport_pc 
w83627ehf hwmon_vid coretemp nfsd nfs_acl auth_rpcgss nfs lp fscache 
lockd parport sunrpc btrfs zlib_deflate libcrc32c raid10 raid1 raid0 
multipath linear raid456 async_pq async_xor xor async_memcpy 
async_raid6_recov raid6_pq async_tx hid_generic usbhid hid ast ttm 
drm_kms_helper crc32_pclmul ghash_clmulni_intel drm aesni_intel 
ablk_helper cryptd lrw i2c_algo_bit gf128mul sysimgblt glue_helper 
sysfillrect aes_x86_64 syscopyarea e1000e mpt2sas ahci ptp libahci 
scsi_transport_sas pps_core raid_class video
[68194.340679] CPU: 4 PID: 31348 Comm: btrfs-endio-3 Tainted: G D      
3.10.0+ #11
[68194.340680] Hardware name: To be filled by O.E.M. To be filled by 
O.E.M./P8B-X series, BIOS 2107 05/04/2012
[68194.340681] task: ffff8803662f1740 ti: ffff88010859a000 task.ti: 
ffff88010859a000
[68194.340690] RIP: 0010:[<ffffffffa0272287>] [<ffffffffa0272287>] 
repair_io_failure+0x117/0x230 [btrfs]
[68194.340691] RSP: 0018:ffff88010859bca8  EFLAGS: 00010287
[68194.340692] RAX: fffffff9e1de3fe8 RBX: 0000000000001000 RCX: 
0000019e1ce5e000
[68194.340692] RDX: ffff88027acf7000 RSI: ffff88010859bcc0 RDI: 
ffff8803dd444be0
[68194.340693] RBP: ffff88010859bd18 R08: 0000000000000000 R09: 
0000000000000000
[68194.340693] R10: ffffffffbebe97ff R11: 0000000000003fb5 R12: 
ffff880416adc000
[68194.340694] R13: 00000929834ae000 R14: 00000000bebe9800 R15: 
ffff8801331a6b10
[68194.340695] FS:  0000000000000000(0000) GS:ffff88042fd00000(0000) 
knlGS:0000000000000000
[68194.340696] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[68194.340696] CR2: ffff87fc5cadb020 CR3: 0000000001c0c000 CR4: 
00000000001427e0
[68194.340697] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[68194.340697] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[68194.340698] Stack:
[68194.340700]  0000000000078000 ffffea000ecb4240 0000000000002000 
ffff88027acf7000
[68194.340701]  ffff880100000000 ffffffff00000000 ffff88010859bcd8 
ffff88010859bcd8
[68194.340703]  ffff88010859bd18 0000000000078000 ffff880410edf1a0 
ffffea000ecb4240
[68194.340703] Call Trace:
[68194.340712]  [<ffffffffa0272bdf>] end_bio_extent_readpage+0x78f/0x7f0 
[btrfs]
[68194.340716]  [<ffffffff8104f86a>] ? del_timer_sync+0x5a/0x70
[68194.340718]  [<ffffffff811a38ad>] bio_endio+0x1d/0x30
[68194.340725]  [<ffffffffa024cf41>] end_workqueue_fn+0x41/0x50 [btrfs]
[68194.340733]  [<ffffffffa02822d8>] worker_loop+0x148/0x520 [btrfs]
[68194.340741]  [<ffffffffa0282190>] ? btrfs_queue_worker+0x320/0x320 
[btrfs]
[68194.340744]  [<ffffffff81064410>] kthread+0xc0/0xd0
[68194.340745]  [<ffffffff81064350>] ? kthread_create_on_node+0x130/0x130
[68194.340748]  [<ffffffff81699f1c>] ret_from_fork+0x7c/0xb0
[68194.340750]  [<ffffffff81064350>] ? kthread_create_on_node+0x130/0x130
[68194.340769] Code: a0 e8 4e c1 00 00 85 c0 0f 85 b6 00 00 00 48 8b 55 
a8 44 3b 72 2c 0f 85 e8 00 00 00 45 8d 56 ff 4d 63 d2 4b 8d 04 52 48 c1 
e0 03 <4c> 8b 6c 02 38 49 c1 ed 09 4d 89 2f 48 8b 7d a8 4c 8b 64 07 30
[68194.340776] RIP  [<ffffffffa0272287>] repair_io_failure+0x117/0x230 
[btrfs]
[68194.340777]  RSP <ffff88010859bca8>
[68194.340777] CR2: ffff87fc5cadb020
[68194.340779] ---[ end trace ad5eb9d56280bbe8 ]---
[68194.344670] ------------[ cut here ]------------
[68194.344671] kernel BUG at fs/btrfs/extent_io.c:2054!
[68194.344672] invalid opcode: 0000 [#5] SMP
[68194.348653] Modules linked in: xfs ip6table_filter ip6_tables 
ebtable_nat ebtables ipt_MASQUERADE ipt_REJECT xt_CHECKSUM sch_prio 
bridge stp llc dm_crypt xt_state iptable_filter xt_CLASSIFY xt_tcpudp 
xt_DSCP iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables intel_powerclamp 
kvm_intel kvm psmouse serio_raw microcode lpc_ich ppdev parport_pc 
w83627ehf hwmon_vid coretemp nfsd nfs_acl auth_rpcgss nfs lp fscache 
lockd parport sunrpc btrfs zlib_deflate libcrc32c raid10 raid1 raid0 
multipath linear raid456 async_pq async_xor xor async_memcpy 
async_raid6_recov raid6_pq async_tx hid_generic usbhid hid ast ttm 
drm_kms_helper crc32_pclmul ghash_clmulni_intel drm aesni_intel 
ablk_helper cryptd lrw i2c_algo_bit gf128mul sysimgblt glue_helper 
sysfillrect aes_x86_64 syscopyarea e1000e mpt2sas ahci ptp libahci 
scsi_transport_sas pps_core raid_class video
[68194.348659] CPU: 5 PID: 16460 Comm: btrfs-endio-5 Tainted: G D      
3.10.0+ #11
[68194.348660] Hardware name: To be filled by O.E.M. To be filled by 
O.E.M./P8B-X series, BIOS 2107 05/04/2012
[68194.348661] task: ffff8804165fdd00 ti: ffff88021d67c000 task.ti: 
ffff88021d67c000
[68194.348780] RIP: 0010:[<ffffffffa0272360>] [<ffffffffa0272360>] 
repair_io_failure+0x1f0/0x230 [btrfs]
[68194.348781] RSP: 0018:ffff88021d67dca8  EFLAGS: 00010206
[68194.348783] RAX: 0000000000000000 RBX: 0000000000001000 RCX: 
0000019e1ce5e000
[68194.348783] RDX: ffff8801ec9c2c60 RSI: ffff88021d67dcc0 RDI: 
ffff8803dd444be0
[68194.348784] RBP: ffff88021d67dd18 R08: 0000000000000000 R09: 
0000000000000000
[68194.348785] R10: 0000000000000000 R11: 0000000000003fb5 R12: 
ffff880416adc000
[68194.348786] R13: 00000929834ae000 R14: 000000002866a700 R15: 
ffff880407ae2610
[68194.348787] FS:  0000000000000000(0000) GS:ffff88042fd40000(0000) 
knlGS:0000000000000000
[68194.348788] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[68194.348789] CR2: 00007fff31bf5168 CR3: 0000000001c0c000 CR4: 
00000000001427e0
[68194.348790] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[68194.348790] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[68194.348791] Stack:
[68194.348793]  0000000000076000 ffffea000ecb41c0 0000000000002000 
ffff8801ec9c2c60
[68194.348795]  ffff880200000000 ffffffff00000000 ffff88021d67dcd8 
ffff88021d67dcd8
[68194.348797]  ffff88021d67dd18 0000000000076000 ffff880417e099a0 
ffffea000ecb41c0
[68194.348798] Call Trace:
[68194.348807]  [<ffffffffa0272bdf>] end_bio_extent_readpage+0x78f/0x7f0 
[btrfs]
[68194.348810]  [<ffffffff811a38ad>] bio_endio+0x1d/0x30
[68194.348820]  [<ffffffffa024cf41>] end_workqueue_fn+0x41/0x50 [btrfs]
[68194.348829]  [<ffffffffa02822d8>] worker_loop+0x148/0x520 [btrfs]
[68194.348838]  [<ffffffffa0282190>] ? btrfs_queue_worker+0x320/0x320 
[btrfs]
[68194.348844]  [<ffffffff81064410>] kthread+0xc0/0xd0
[68194.348847]  [<ffffffff81064350>] ? kthread_create_on_node+0x130/0x130
[68194.348851]  [<ffffffff81699f1c>] ret_from_fork+0x7c/0xb0
[68194.348854]  [<ffffffff81064350>] ? kthread_create_on_node+0x130/0x130
[68194.348886] Code: 44 00 00 4c 89 ff e8 50 2f f3 e0 31 f6 4c 89 e7 e8 
66 f2 00 00 ba fb ff ff ff e9 a0 fe ff ff ba fb ff ff ff e9 96 fe ff ff 
0f 0b <0f> 0b 48 8b 55 98 4d 89 e8 48 c7 c7 90 a9 2c a0 49 8b 8c 24 88
[68194.348893] RIP  [<ffffffffa0272360>] repair_io_failure+0x1f0/0x230 
[btrfs]
[68194.348894]  RSP <ffff88021d67dca8>
[68194.348896] BUG: unable to handle kernel paging request at 
ffff8800f43153c0
[68194.348903] IP: [<ffffffffa0272287>] repair_io_failure+0x117/0x230 
[btrfs]
[68194.348905] ---[ end trace ad5eb9d56280bbe9 ]---
[68194.352789] PGD 201b067 PUD 42fffd067 PMD 0
[68194.352794] Oops: 0000 [#6] SMP
[68194.356985] Modules linked in: xfs ip6table_filter ip6_tables 
ebtable_nat ebtables ipt_MASQUERADE ipt_REJECT xt_CHECKSUM sch_prio 
bridge stp llc dm_crypt xt_state iptable_filter xt_CLASSIFY xt_tcpudp 
xt_DSCP iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables intel_powerclamp 
kvm_intel kvm psmouse serio_raw microcode lpc_ich ppdev parport_pc 
w83627ehf hwmon_vid coretemp nfsd nfs_acl auth_rpcgss nfs lp fscache 
lockd parport sunrpc btrfs zlib_deflate libcrc32c raid10 raid1 raid0 
multipath linear raid456 async_pq async_xor xor async_memcpy 
async_raid6_recov raid6_pq async_tx hid_generic usbhid hid ast ttm 
drm_kms_helper crc32_pclmul ghash_clmulni_intel drm aesni_intel 
ablk_helper cryptd lrw i2c_algo_bit gf128mul sysimgblt glue_helper 
sysfillrect aes_x86_64 syscopyarea e1000e mpt2sas ahci ptp libahci 
scsi_transport_sas pps_core raid_class video
[68194.356991] CPU: 1 PID: 16455 Comm: btrfs-endio-4 Tainted: G D      
3.10.0+ #11
[68194.356992] Hardware name: To be filled by O.E.M. To be filled by 
O.E.M./P8B-X series, BIOS 2107 05/04/2012
[68194.356993] task: ffff8803dd36ae80 ti: ffff88038a646000 task.ti: 
ffff88038a646000
[68194.357006] RIP: 0010:[<ffffffffa0272287>] [<ffffffffa0272287>] 
repair_io_failure+0x117/0x230 [btrfs]
[68194.357008] RSP: 0018:ffff88038a647ca8  EFLAGS: 00010287
[68194.357009] RAX: fffffffd96ade7e8 RBX: 0000000000001000 RCX: 
0000019e1ce5e000
[68194.357009] RDX: ffff88035d836ba0 RSI: ffff88038a647cc0 RDI: 
ffff8803dd444be0
[68194.357010] RBP: ffff88038a647d18 R08: 0000000000000000 R09: 
0000000000000000
[68194.357010] R10: ffffffffe6473eff R11: 0000000000003fb5 R12: 
ffff880416adc000
[68194.357012] R13: 00000929834ae000 R14: 00000000e6473f00 R15: 
ffff880345dd8710
[68194.357013] FS:  0000000000000000(0000) GS:ffff88042fc40000(0000) 
knlGS:0000000000000000
[68194.357013] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[68194.357014] CR2: ffff8800f43153c0 CR3: 0000000001c0c000 CR4: 
00000000001427e0
[68194.357015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[68194.357016] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[68194.357016] Stack:
[68194.357018]  000000000007c000 ffffea000ecb4340 0000000000002000 
ffff88035d836ba0
[68194.357020]  ffff880300000000 ffffffff00000000 ffff88038a647cd8 
ffff88038a647cd8
[68194.357022]  ffff88038a647d18 000000000007c000 ffff8803c5cb91a0 
ffffea000ecb4340
[68194.357023] Call Trace:
[68194.357032]  [<ffffffffa0272bdf>] end_bio_extent_readpage+0x78f/0x7f0 
[btrfs]
[68194.357035]  [<ffffffff811a38ad>] bio_endio+0x1d/0x30
[68194.357043]  [<ffffffffa024cf41>] end_workqueue_fn+0x41/0x50 [btrfs]
[68194.357052]  [<ffffffffa02822d8>] worker_loop+0x148/0x520 [btrfs]
[68194.357058]  [<ffffffff816902c7>] ? __schedule+0x3d7/0x800
[68194.357068]  [<ffffffffa0282190>] ? btrfs_queue_worker+0x320/0x320 
[btrfs]
[68194.357073]  [<ffffffff81064410>] kthread+0xc0/0xd0
[68194.357077]  [<ffffffff81064350>] ? kthread_create_on_node+0x130/0x130
[68194.357081]  [<ffffffff81699f1c>] ret_from_fork+0x7c/0xb0
[68194.357085]  [<ffffffff81064350>] ? kthread_create_on_node+0x130/0x130
[68194.357118] Code: a0 e8 4e c1 00 00 85 c0 0f 85 b6 00 00 00 48 8b 55 
a8 44 3b 72 2c 0f 85 e8 00 00 00 45 8d 56 ff 4d 63 d2 4b 8d 04 52 48 c1 
e0 03 <4c> 8b 6c 02 38 49 c1 ed 09 4d 89 2f 48 8b 7d a8 4c 8b 64 07 30
[68194.357126] RIP  [<ffffffffa0272287>] repair_io_failure+0x117/0x230 
[btrfs]
[68194.357127]  RSP <ffff88038a647ca8>
[68194.357127] CR2: ffff8800f43153c0
[68194.357128] ---[ end trace ad5eb9d56280bbea ]---
[68194.359850] ------------[ cut here ]------------
[68194.359852] kernel BUG at fs/btrfs/extent_io.c:2054!
[68194.359853] invalid opcode: 0000 [#7] SMP
[68194.362250] Modules linked in: xfs ip6table_filter ip6_tables 
ebtable_nat ebtables ipt_MASQUERADE ipt_REJECT xt_CHECKSUM sch_prio 
bridge stp llc dm_crypt xt_state iptable_filter xt_CLASSIFY xt_tcpudp 
xt_DSCP iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables intel_powerclamp 
kvm_intel kvm psmouse serio_raw microcode lpc_ich ppdev parport_pc 
w83627ehf hwmon_vid coretemp nfsd nfs_acl auth_rpcgss nfs lp fscache 
lockd parport sunrpc btrfs zlib_deflate libcrc32c raid10 raid1 raid0 
multipath linear raid456 async_pq async_xor xor async_memcpy 
async_raid6_recov raid6_pq async_tx hid_generic usbhid hid ast ttm 
drm_kms_helper crc32_pclmul ghash_clmulni_intel drm aesni_intel 
ablk_helper cryptd lrw i2c_algo_bit gf128mul sysimgblt glue_helper 
sysfillrect aes_x86_64 syscopyarea e1000e mpt2sas ahci ptp libahci 
scsi_transport_sas pps_core raid_class video
[68194.362256] CPU: 3 PID: 16448 Comm: btrfs-endio-3 Tainted: G D      
3.10.0+ #11
[68194.362257] Hardware name: To be filled by O.E.M. To be filled by 
O.E.M./P8B-X series, BIOS 2107 05/04/2012
[68194.362258] task: ffff8802c003dd00 ti: ffff88021d72e000 task.ti: 
ffff88021d72e000
[68194.362270] RIP: 0010:[<ffffffffa0272360>] [<ffffffffa0272360>] 
repair_io_failure+0x1f0/0x230 [btrfs]
[68194.362393] RSP: 0018:ffff88021d72fca8  EFLAGS: 00010206
[68194.362394] RAX: 0000000000000000 RBX: 0000000000001000 RCX: 
0000019e1ce5e000
[68194.362395] RDX: ffff8803d2d42180 RSI: ffff88021d72fcc0 RDI: 
ffff8803dd444be0
[68194.362395] RBP: ffff88021d72fd18 R08: 0000000000000000 R09: 
0000000000000000
[68194.362396] R10: 0000000000000000 R11: 0000000000003fb5 R12: 
ffff880416adc000
[68194.362397] R13: 00000929834ae000 R14: 00000000529b7d00 R15: 
ffff8803db4c5010
[68194.362398] FS:  0000000000000000(0000) GS:ffff88042fcc0000(0000) 
knlGS:0000000000000000
[68194.362399] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[68194.362399] CR2: ffff87fe167a32c0 CR3: 0000000001c0c000 CR4: 
00000000001427e0
[68194.362400] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[68194.362401] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[68194.362401] Stack:
[68194.362403]  000000000007f000 ffffea000aaaf400 0000000000002000 
ffff8803d2d42180
[68194.362404]  ffff880200000000 ffffffff00000000 ffff88021d72fcd8 
ffff88021d72fcd8
[68194.362407]  ffff88021d72fd18 000000000007f000 ffff88028a2231a0 
ffffea000aaaf400
[68194.362407] Call Trace:
[68194.362416]  [<ffffffffa0272bdf>] end_bio_extent_readpage+0x78f/0x7f0 
[btrfs]
[68194.362420]  [<ffffffff8104f86a>] ? del_timer_sync+0x5a/0x70
[68194.362422]  [<ffffffff811a38ad>] bio_endio+0x1d/0x30
[68194.362429]  [<ffffffffa024cf41>] end_workqueue_fn+0x41/0x50 [btrfs]
[68194.362438]  [<ffffffffa02822d8>] worker_loop+0x148/0x520 [btrfs]
[68194.362446]  [<ffffffffa0282190>] ? btrfs_queue_worker+0x320/0x320 
[btrfs]
[68194.362448]  [<ffffffff81064410>] kthread+0xc0/0xd0
[68194.362450]  [<ffffffff81064350>] ? kthread_create_on_node+0x130/0x130
[68194.362453]  [<ffffffff81699f1c>] ret_from_fork+0x7c/0xb0
[68194.362455]  [<ffffffff81064350>] ? kthread_create_on_node+0x130/0x130
[68194.362488] Code: 44 00 00 4c 89 ff e8 50 2f f3 e0 31 f6 4c 89 e7 e8 
66 f2 00 00 ba fb ff ff ff e9 a0 fe ff ff ba fb ff ff ff e9 96 fe ff ff 
0f 0b <0f> 0b 48 8b 55 98 4d 89 e8 48 c7 c7 90 a9 2c a0 49 8b 8c 24 88
[68194.362495] RIP  [<ffffffffa0272360>] repair_io_failure+0x1f0/0x230 
[btrfs]
[68194.362496]  RSP <ffff88021d72fca8>
[68194.362530] ---[ end trace ad5eb9d56280bbeb ]---
[68201.437611] btrfs read error corrected: ino 342 off 4614025216 (dev 
/dev/dm-13 sector 3262154808)
[68201.468125] btrfs read error corrected: ino 342 off 4614029312 (dev 
/dev/dm-13 sector 3262154816)
[68201.498394] btrfs read error corrected: ino 342 off 4614033408 (dev 
/dev/dm-13 sector 3262154824)
[68201.528165] BUG: unable to handle kernel paging request at 
ffff87f7e1868ca0
[68201.558087] IP: [<ffffffffa0272287>] repair_io_failure+0x117/0x230 
[btrfs]
[68201.587583] PGD 0
[68201.616040] Oops: 0000 [#8] SMP
[68201.643732] Modules linked in: xfs ip6table_filter ip6_tables 
ebtable_nat ebtables ipt_MASQUERADE ipt_REJECT xt_CHECKSUM sch_prio 
bridge stp llc dm_crypt xt_state iptable_filter xt_CLASSIFY xt_tcpudp 
xt_DSCP iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables intel_powerclamp 
kvm_intel kvm psmouse serio_raw microcode lpc_ich ppdev parport_pc 
w83627ehf hwmon_vid coretemp nfsd nfs_acl auth_rpcgss nfs lp fscache 
lockd parport sunrpc btrfs zlib_deflate libcrc32c raid10 raid1 raid0 
multipath linear raid456 async_pq async_xor xor async_memcpy 
async_raid6_recov raid6_pq async_tx hid_generic usbhid hid ast ttm 
drm_kms_helper crc32_pclmul ghash_clmulni_intel drm aesni_intel 
ablk_helper cryptd lrw i2c_algo_bit gf128mul sysimgblt glue_helper 
sysfillrect aes_x86_64 syscopyarea e1000e mpt2sas ahci ptp libahci 
scsi_transport_sas pps_core raid_class video
[68201.874427] CPU: 6 PID: 16447 Comm: btrfs-endio-2 Tainted: G D      
3.10.0+ #11
[68201.903336] Hardware name: To be filled by O.E.M. To be filled by 
O.E.M./P8B-X series, BIOS 2107 05/04/2012
[68201.932557] task: ffff8802c0038000 ti: ffff88021d72c000 task.ti: 
ffff88021d72c000
[68201.961934] RIP: 0010:[<ffffffffa0272287>] [<ffffffffa0272287>] 
repair_io_failure+0x117/0x230 [btrfs]
[68201.991913] RSP: 0000:ffff88021d72dca8  EFLAGS: 00010287
[68202.021797] RAX: fffffff4089687e8 RBX: 0000000000001000 RCX: 
0000019e1ce5e000
[68202.052048] RDX: ffff8803d8f00480 RSI: ffff88021d72dcc0 RDI: 
ffff8803dd444be0
[68202.082511] RBP: ffff88021d72dd18 R08: 0000000000000000 R09: 
0000000000000000
[68202.112798] R10: ffffffff805b9aff R11: 0000000000003fb5 R12: 
ffff880416adc000
[68202.142908] R13: 00000929834ae000 R14: 00000000805b9b00 R15: 
ffff8801c173db10
[68202.172849] FS:  0000000000000000(0000) GS:ffff88042fd80000(0000) 
knlGS:0000000000000000
[68202.203216] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[68202.233813] CR2: ffff87f7e1868ca0 CR3: 0000000001c0c000 CR4: 
00000000001427e0
[68202.264536] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[68202.294980] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[68202.325228] Stack:
[68202.355141]  000000000007a000 ffffea000ecb42c0 0000000000002000 
ffff8803d8f00480
[68202.385752]  ffff880200000000 ffffffff00000000 ffff88021d72dcd8 
ffff88021d72dcd8
[68202.416204]  ffff88021d72dd18 000000000007a000 ffff880407ae3ca0 
ffffea000ecb42c0
[68202.446611] Call Trace:
[68202.476773]  [<ffffffffa0272bdf>] end_bio_extent_readpage+0x78f/0x7f0 
[btrfs]
[68202.507646]  [<ffffffff8106e480>] ? finish_task_switch+0xb0/0xe0
[68202.538530]  [<ffffffff811a38ad>] bio_endio+0x1d/0x30
[68202.569277]  [<ffffffffa024cf41>] end_workqueue_fn+0x41/0x50 [btrfs]
[68202.600131]  [<ffffffffa02822d8>] worker_loop+0x148/0x520 [btrfs]
[68202.631005]  [<ffffffffa0282190>] ? btrfs_queue_worker+0x320/0x320 
[btrfs]
[68202.662007]  [<ffffffff81064410>] kthread+0xc0/0xd0
[68202.692862]  [<ffffffff81064350>] ? kthread_create_on_node+0x130/0x130
[68202.723399]  [<ffffffff81699f1c>] ret_from_fork+0x7c/0xb0
[68202.753395]  [<ffffffff81064350>] ? kthread_create_on_node+0x130/0x130
[68202.783159] Code: a0 e8 4e c1 00 00 85 c0 0f 85 b6 00 00 00 48 8b 55 
a8 44 3b 72 2c 0f 85 e8 00 00 00 45 8d 56 ff 4d 63 d2 4b 8d 04 52 48 c1 
e0 03 <4c> 8b 6c 02 38 49 c1 ed 09 4d 89 2f 48 8b 7d a8 4c 8b 64 07 30
[68202.845970] RIP  [<ffffffffa0272287>] repair_io_failure+0x117/0x230 
[btrfs]
[68202.876637]  RSP <ffff88021d72dca8>
[68202.907369] CR2: ffff87f7e1868ca0
[68202.938196] ---[ end trace ad5eb9d56280bbec ]---

--
Torbjørn
