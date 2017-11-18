Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:38098 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1423640AbdKRAta (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 19:49:30 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 2682011608F4
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Nov 2017 00:49:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Nov 2017 00:49:26 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 18 Nov 2017 09:49:25 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: 4.14 balance: kernel BUG at
 /home/kernel/COD/linux/fs/btrfs/ctree.c:1856!
Message-ID: <e01cb2f95b44b7648855a4fe5070fd10@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm getting the following BUG when running balance on one of my systems:


[ 3458.698704] BTRFS info (device sdb3): relocating block group 
306045779968 flags data|raid1
[ 3466.892933] BTRFS info (device sdb3): found 2405 extents
[ 3495.408630] BTRFS info (device sdb3): found 2405 extents
[ 3498.161144] ------------[ cut here ]------------
[ 3498.161150] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/ctree.c:1856!
[ 3498.161264] invalid opcode: 0000 [#1] SMP
[ 3498.161363] Modules linked in: nf_log_ipv6 nf_log_ipv4 nf_log_common 
xt_LOG xt_multiport xt_conntrack xt_nat binfmt_misc veth ip6table_filter 
xt_CHECKSUM iptable_mangle xt_tcpudp ip6t_MASQUERADE 
nf_nat_masquerade_ipv6 ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 
nf_nat_ipv6 ip6_tables ipt_MASQUERADE nf_nat_masquerade_ipv4 xt_comment 
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat 
nf_conntrack iptable_filter ip_tables x_tables bridge stp llc intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass 
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel 
aes_x86_64 crypto_simd glue_helper cryptd intel_cstate hci_uart 
intel_rapl_perf btbcm input_leds serdev serio_raw btqca btintel 
bluetooth intel_pch_thermal intel_lpss_acpi intel_lpss mac_hid acpi_pad
[ 3498.162060]  ecdh_generic acpi_als kfifo_buf industrialio autofs4 
btrfs zstd_compress raid10 raid456 async_raid6_recov async_memcpy 
async_pq async_xor async_tx xor raid6_pq libcrc32c raid0 multipath 
linear raid1 e1000e psmouse ptp ahci pps_core libahci wmi 
pinctrl_sunrisepoint i2c_hid video pinctrl_intel hid
[ 3498.162386] CPU: 7 PID: 29041 Comm: btrfs Not tainted 
4.14.0-041400-generic #201711122031
[ 3498.162545] Hardware name: FUJITSU  /D3401-H2, BIOS V5.0.0.12 R1.5.0 
for D3401-H2x                     02/27/2017
[ 3498.162723] task: ffff8d7858e82f00 task.stack: ffffb4ee47d5c000
[ 3498.162890] RIP: 0010:read_node_slot+0xd7/0xe0 [btrfs]
[ 3498.163027] RSP: 0018:ffffb4ee47d5fb88 EFLAGS: 00010246
[ 3498.163156] RAX: ffff8d78c8bb7000 RBX: ffff8d8124abd380 RCX: 
0000000000000001
[ 3498.163290] RDX: 0000000000000048 RSI: ffff8d7ae1fef6f8 RDI: 
ffff8d8124aa0000
[ 3498.163422] RBP: ffffb4ee47d5fba8 R08: 0000000000000001 R09: 
ffff8d8124abd384
[ 3498.163555] R10: 0000000000000001 R11: 0000000000114000 R12: 
0000000000000002
[ 3498.163689] R13: ffffb4ee47d5fc66 R14: ffffb4ee47d5fc50 R15: 
0000000000000000
[ 3498.163825] FS:  00007fa4c9a998c0(0000) GS:ffff8d816e5c0000(0000) 
knlGS:0000000000000000
[ 3498.163990] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3498.164120] CR2: 000056410155a028 CR3: 00000009c194c002 CR4: 
00000000003606e0
[ 3498.164255] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 3498.164390] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[ 3498.164523] Call Trace:
[ 3498.164694]  tree_advance+0x16e/0x1d0 [btrfs]
[ 3498.164874]  btrfs_compare_trees+0x2da/0x6a0 [btrfs]
[ 3498.165078]  ? process_extent+0x1580/0x1580 [btrfs]
[ 3498.165264]  btrfs_ioctl_send+0xe94/0x1120 [btrfs]
[ 3498.165450]  btrfs_ioctl+0x93c/0x1f00 [btrfs]
[ 3498.165587]  ? enqueue_task_fair+0xa8/0x6c0
[ 3498.165724]  do_vfs_ioctl+0xa5/0x600
[ 3498.165854]  ? do_vfs_ioctl+0xa5/0x600
[ 3498.165979]  ? _do_fork+0x144/0x3a0
[ 3498.166103]  SyS_ioctl+0x79/0x90
[ 3498.166234]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[ 3498.166368] RIP: 0033:0x7fa4c8b17f07
[ 3498.166488] RSP: 002b:00007ffd33644e38 EFLAGS: 00000202 ORIG_RAX: 
0000000000000010
[ 3498.166653] RAX: ffffffffffffffda RBX: 00007fa4c8a1a700 RCX: 
00007fa4c8b17f07
[ 3498.166787] RDX: 00007ffd33644f30 RSI: 0000000040489426 RDI: 
0000000000000004
[ 3498.166921] RBP: 00007ffd33644dc0 R08: 0000000000000000 R09: 
00007fa4c8a1a700
[ 3498.167055] R10: 00007fa4c8a1a9d0 R11: 0000000000000202 R12: 
0000000000000000
[ 3498.167190] R13: 00007ffd33644dbf R14: 00007fa4c8a1a9c0 R15: 
000000000129f020
[ 3498.167326] Code: 48 c7 c3 fb ff ff ff e8 f8 5c 05 00 48 89 d8 5b 41 
5c 41 5d 41 5e 5d c3 48 c7 c3 fe ff ff ff 48 89 d8 5b 41 5c 41 5d 41 5e 
5d c3 <0f> 0b 0f 1f 80 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 57 41
[ 3498.167690] RIP: read_node_slot+0xd7/0xe0 [btrfs] RSP: 
ffffb4ee47d5fb88
[ 3498.167892] ---[ end trace 6a751a3020dd3086 ]---
[ 3499.572729] BTRFS info (device sdb3): relocating block group 
304972038144 flags data|raid1
[ 3504.068432] BTRFS info (device sdb3): found 2037 extents
[ 3538.281808] BTRFS info (device sdb3): found 2037 extents



Tomasz Chmielewski
https://lxadm.com
