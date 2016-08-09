Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:54575 "EHLO
	techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750909AbcHIXqx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 19:46:53 -0400
Received: from pool-74-104-146-52.bstnma.fios.verizon.net ([74.104.146.52] helo=[192.168.1.158])
	by techsquare.com with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.71)
	(envelope-from <matt@techsquare.com>)
	id 1bXGFC-0003px-1M
	for linux-btrfs@vger.kernel.org; Tue, 09 Aug 2016 19:15:54 -0400
To: linux-btrfs@vger.kernel.org
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <a70af895-6d3e-3b8a-eeb3-71d6609f8154@techsquare.com>
Date: Tue, 9 Aug 2016 19:15:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: BTRFS: error (device sda1) in btrfs_run_delayed_refs:2963: errno=-17
 Object already exists
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Our server recently crashed and was rebooted.  When it returned our 
BTRFS volume is mounting read-only:

[  142.395093] BTRFS: error (device sda1) in 
btrfs_run_delayed_refs:2963: errno=-17 Object already exists
[  142.404418] BTRFS info (device sda1): forced readonly

I tried upgrading the kernel from 4.3 to 4.7.  Upgraded btrfs-progs to 
v4.7 as well.

# uname -a
Linux hostname 4.7.0-custom #1 SMP Tue Aug 9 11:16:28 EDT 2016 x86_64 
x86_64 x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.7

# btrfs fi show
Label: none  uuid: 33f9089e-acc7-4a39-8b83-b18bb182faaf
	Total devices 1 FS bytes used 14.95TiB
	devid    1 size 50.93TiB used 22.67TiB path /dev/sda1

# btrfs fi df /export/
Data, single: total=22.53TiB, used=14.89TiB
System, DUP: total=40.00MiB, used=2.39MiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=70.50GiB, used=60.21GiB
Metadata, single: total=1.51GiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B

# dmesg
[  142.394841] ------------[ cut here ]------------
[  142.394874] WARNING: CPU: 6 PID: 269 at fs/btrfs/extent-tree.c:2963 
btrfs_run_delayed_refs+0x292/0x2d0 [btrfs]
[  142.394876] BTRFS: Transaction aborted (error -17)
[  142.394878] Modules linked in: ipt_REJECT nf_reject_ipv4 xt_tcpudp 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
iptable_filter ip_tables x_tables ipmi_devintf nfsd auth_rpcgss nfs_acl 
nfs lockd grace sunrpc fscache sb_edac edac_core x86_pkg_temp_thermal 
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul 
crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul 
glue_helper ablk_helper cryptd dm_multipath joydev lpc_ich mei_me mei 
ioatdma wmi ipmi_si ipmi_msghandler shpchp mac_hid btrfs lp parport ses 
enclosure scsi_transport_sas raid10 raid456 async_raid6_recov 
async_memcpy async_pq async_xor async_tx xor igb raid6_pq libcrc32c 
i2c_algo_bit raid1 hid_generic dca usbhid raid0 ptp hid ahci 
megaraid_sas multipath libahci pps_core linear dm_mirror dm_region_hash 
dm_log
[  142.394942] CPU: 6 PID: 269 Comm: kworker/u18:5 Not tainted 
4.7.0-custom #1
[  142.394944] Hardware name: Supermicro 
X9DRH-7TF/7F/iTF/iF/X9DRH-7TF/7F/iTF/iF, BIOS 3.0b 04/28/2014
[  142.394966] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[  142.394969]  0000000000000000 ffff88086a057ca0 ffffffff813b816c 
ffff88086a057cf0
[  142.394972]  0000000000000000 ffff88086a057ce0 ffffffff8107a321 
00000b9325288170
[  142.394975]  ffff8808519eb000 ffff880825288170 ffff88086b2c1000 
0000000000000020
[  142.394978] Call Trace:
[  142.394987]  [<ffffffff813b816c>] dump_stack+0x63/0x87
[  142.394993]  [<ffffffff8107a321>] __warn+0xd1/0xf0
[  142.394996]  [<ffffffff8107a38f>] warn_slowpath_fmt+0x4f/0x60
[  142.395012]  [<ffffffffc01c6e52>] btrfs_run_delayed_refs+0x292/0x2d0 
[btrfs]
[  142.395025]  [<ffffffffc01c6f24>] delayed_ref_async_start+0x94/0xb0 
[btrfs]
[  142.395044]  [<ffffffffc020f780>] normal_work_helper+0xc0/0x2d0 [btrfs]
[  142.395050]  [<ffffffff81091082>] ? pwq_activate_delayed_work+0x42/0xb0
[  142.395066]  [<ffffffffc020fbc2>] btrfs_extent_refs_helper+0x12/0x20 
[btrfs]
[  142.395070]  [<ffffffff81093173>] process_one_work+0x153/0x3f0
[  142.395073]  [<ffffffff8109392b>] worker_thread+0x12b/0x4b0
[  142.395076]  [<ffffffff81093800>] ? rescuer_thread+0x340/0x340
[  142.395079]  [<ffffffff81099109>] kthread+0xc9/0xe0
[  142.395085]  [<ffffffff817db85f>] ret_from_fork+0x1f/0x40
[  142.395088]  [<ffffffff81099040>] ? kthread_park+0x60/0x60
[  142.395090] ---[ end trace e2b0b8dc37502011 ]---
[  142.395093] BTRFS: error (device sda1) in 
btrfs_run_delayed_refs:2963: errno=-17 Object already exists
[  142.404418] BTRFS info (device sda1): forced readonly
