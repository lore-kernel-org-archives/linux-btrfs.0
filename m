Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:48974 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbbDDBz5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Apr 2015 21:55:57 -0400
Received: from mailext.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id EB4D556A976
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Apr 2015 03:55:54 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: 3.19.3: fs/btrfs/super.c:260 __btrfs_abort_transaction+0x4c/0x10e  [btrfs]()
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 04 Apr 2015 10:55:54 +0900
From: Tomasz Chmielewski <tch@virtall.com>
Message-ID: <6f897a1668c402fef084382bcda34fc7@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Got this one for some reason; this fs did not have any issues before:


[64343.060291] perf interrupt took too long (2544 > 2500), lowering 
kernel.perf_event_max_sample_rate to 50000
[67344.630449] ------------[ cut here ]------------
[67344.630509] WARNING: CPU: 3 PID: 21885 at fs/btrfs/super.c:260 
__btrfs_abort_transaction+0x4c/0x10e [btrfs]()
[67344.630626] BTRFS: Transaction aborted (error -22)
[67344.630627] Modules linked in: xt_nat xt_tcpudp ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables tun 
cpufreq_conservative cpufreq_powersave cpufreq_stats ipv6 btrfs xor 
raid6_pq zlib_deflate coretemp hwmon loop parport_pc parport 8250_fintek 
tpm_infineon tpm_tis tpm pcspkr i2c_i801 i2c_core battery video ehci_pci 
ehci_hcd lpc_ich mfd_core button acpi_cpufreq ext4 crc16 jbd2 mbcache 
raid1 sg sd_mod ahci libahci r8169 mii libata scsi_mod
[67344.631027] CPU: 3 PID: 21885 Comm: btrfs Not tainted 3.19.3 #1
[67344.631074] Hardware name: System manufacturer System Product 
Name/P8H77-M PRO, BIOS 1101 02/04/2013
[67344.631164]  0000000000000009 ffff8800ab38b928 ffffffff813bd016 
ffff88081facd801
[67344.631253]  ffff8800ab38b978 ffff8800ab38b968 ffffffff8103b025 
0000000000000000
[67344.631342]  ffffffffa029235e 00000000ffffffea ffff880042a59800 
ffff8807f1e7dd10
[67344.631431] Call Trace:
[67344.631477]  [<ffffffff813bd016>] dump_stack+0x45/0x57
[67344.631525]  [<ffffffff8103b025>] warn_slowpath_common+0x97/0xb1
[67344.631575]  [<ffffffffa029235e>] ? 
__btrfs_abort_transaction+0x4c/0x10e [btrfs]
[67344.631663]  [<ffffffff8103b0d3>] warn_slowpath_fmt+0x41/0x43
[67344.631713]  [<ffffffffa029235e>] 
__btrfs_abort_transaction+0x4c/0x10e [btrfs]
[67344.632914]  [<ffffffffa02b658c>] create_pending_snapshot+0x6a3/0x6e4 
[btrfs]
[67344.632967]  [<ffffffffa029f93b>] ? 
block_rsv_release_bytes.isra.54+0xb0/0xc1 [btrfs]
[67344.633060]  [<ffffffffa02b6633>] create_pending_snapshots+0x66/0x89 
[btrfs]
[67344.633114]  [<ffffffffa02b78c4>] 
btrfs_commit_transaction+0x44f/0x9bb [btrfs]
[67344.633208]  [<ffffffffa02e03f4>] btrfs_mksubvol.isra.61+0x2eb/0x418 
[btrfs]
[67344.633257]  [<ffffffff81065b9d>] ? add_wait_queue+0x44/0x44
[67344.633310]  [<ffffffffa02e0670>] 
btrfs_ioctl_snap_create_transid+0x14f/0x180 [btrfs]
[67344.633404]  [<ffffffffa02e07d4>] 
btrfs_ioctl_snap_create_v2+0xc7/0x112 [btrfs]
[67344.633497]  [<ffffffffa02e43a3>] btrfs_ioctl+0x6cc/0x22f5 [btrfs]
[67344.633545]  [<ffffffff810d8bc5>] ? handle_mm_fault+0x452/0x9fc
[67344.633594]  [<ffffffff8117870f>] ? avc_has_perm+0x2e/0xf7
[67344.633641]  [<ffffffff811119cf>] do_vfs_ioctl+0x418/0x460
[67344.633688]  [<ffffffff81111a65>] SyS_ioctl+0x4e/0x7d
[67344.633735]  [<ffffffff81031c5b>] ? do_page_fault+0xc/0x11
[67344.633782]  [<ffffffff813c19f2>] system_call_fastpath+0x12/0x17
[67344.633829] ---[ end trace ea2b25b59548e150 ]---
[67344.633875] BTRFS: error (device sdb5) in 
create_pending_snapshot:1392: errno=-22 unknown
[67344.633964] BTRFS info (device sdb5): forced readonly
[67344.634010] BTRFS warning (device sdb5): Skipping commit of aborted 
transaction.
[67344.634098] BTRFS: error (device sdb5) in cleanup_transaction:1670: 
errno=-22 unknown
[67344.634186] BTRFS info (device sdb5): delayed_refs has NO entry



-- 
Tomasz Chmielewski
http://www.sslrack.com

