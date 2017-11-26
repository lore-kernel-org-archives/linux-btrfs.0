Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:36660 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752053AbdKZHz7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Nov 2017 02:55:59 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 54FAB1230B99
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Nov 2017 07:46:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Nov 2017 07:46:45 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sun, 26 Nov 2017 16:46:45 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: again "out of space" and remount read only, with 4.14
Message-ID: <dfdbf8227acb0f10ed14edb0a8638ce0@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Got this one on a 4.14-rc7 filesystem with some 400 GB left:

[2217513.502016] BTRFS: Transaction aborted (error -28)
[2217513.502038] ------------[ cut here ]------------
[2217513.502064] WARNING: CPU: 6 PID: 29325 at 
/home/kernel/COD/linux/fs/btrfs/extent-tree.c:3089 
btrfs_run_delayed_refs+0x244/0x250 [btrfs]
[2217513.502064] Modules linked in: vhost_net vhost tap nf_log_ipv4 
nf_log_common xt_LOG xt_REDIRECT nf_nat_redirect xt_NFLOG nfnetlink_log 
nfnetlink xt_conntrack ipt_REJECT nf_reject_ipv4 binfmt_misc veth 
ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 
nf_nat_ipv6 ip6table_filter ip6_tables xt_comment xt_CHECKSUM 
iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc btrfs 
zstd_compress intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp 
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc kvm_intel kvm 
irqbypass aesni_intel eeepc_wmi aes_x86_64 asus_wmi sparse_keymap 
crypto_simd wmi_bmof input_leds glue_helper ie31200_edac shpchp lpc_ich
[2217513.502099]  cryptd serio_raw mac_hid intel_cstate intel_rapl_perf 
tpm_infineon nfsd auth_rpcgss nfs_acl lockd grace sunrpc lp parport 
autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor 
async_tx xor raid6_pq libcrc32c raid0 multipath linear raid1 e1000e ahci 
libahci ptp pps_core wmi video
[2217513.502120] CPU: 6 PID: 29325 Comm: postdrop Not tainted 
4.14.0-041400rc7-generic #201710292231
[2217513.502121] Hardware name: System manufacturer System Product 
Name/P8B WS, BIOS 0904 10/24/2011
[2217513.502122] task: ffff9fc681f54500 task.stack: ffffc313cab74000
[2217513.502137] RIP: 0010:btrfs_run_delayed_refs+0x244/0x250 [btrfs]
[2217513.502138] RSP: 0018:ffffc313cab77be8 EFLAGS: 00010282
[2217513.502140] RAX: 0000000000000026 RBX: 00000000ffffffe4 RCX: 
0000000000000000
[2217513.502141] RDX: 0000000000000000 RSI: ffff9fce2fb8dc98 RDI: 
ffff9fce2fb8dc98
[2217513.502142] RBP: ffffc313cab77c40 R08: 0000000000000001 R09: 
00000000000041dc
[2217513.502143] R10: ffffc313cab77ad8 R11: 0000000000000000 R12: 
ffff9fce0967b258
[2217513.502144] R13: ffff9fce07680000 R14: ffff9fcd27aa7000 R15: 
ffffffffffffffff
[2217513.502145] FS:  00007fd929cb9800(0000) GS:ffff9fce2fb80000(0000) 
knlGS:0000000000000000
[2217513.502146] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[2217513.502147] CR2: 00007ffc6a7aae98 CR3: 00000001e8e10006 CR4: 
00000000000606e0
[2217513.502148] Call Trace:
[2217513.502167]  create_pending_snapshot+0x5b7/0xf70 [btrfs]
[2217513.502183]  create_pending_snapshots+0x88/0xb0 [btrfs]
[2217513.502197]  ? create_pending_snapshots+0x88/0xb0 [btrfs]
[2217513.502212]  btrfs_commit_transaction+0x3a7/0x8d0 [btrfs]
[2217513.502215]  ? wait_woken+0x80/0x80
[2217513.502232]  btrfs_sync_file+0x348/0x410 [btrfs]
[2217513.502235]  vfs_fsync_range+0x4b/0xb0
[2217513.502236]  do_fsync+0x3d/0x70
[2217513.502238]  SyS_fsync+0x10/0x20
[2217513.502240]  do_syscall_64+0x61/0x120
[2217513.502243]  entry_SYSCALL64_slow_path+0x25/0x25
[2217513.502244] RIP: 0033:0x7fd927955ba0
[2217513.502245] RSP: 002b:00007fff6576e748 EFLAGS: 00000246 ORIG_RAX: 
000000000000004a
[2217513.502247] RAX: ffffffffffffffda RBX: 000056504aaecbd0 RCX: 
00007fd927955ba0
[2217513.502248] RDX: 000000000000022a RSI: 00000000000001e4 RDI: 
0000000000000004
[2217513.502249] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0101010101010101
[2217513.502250] R10: 00007fff6576e510 R11: 0000000000000246 R12: 
00005650493433f8
[2217513.502251] R13: 000056504aaee120 R14: 0000000000000045 R15: 
0000565049344d44
[2217513.502252] Code: fe ff 89 d9 ba 11 0c 00 00 48 c7 c6 40 28 8b c0 
4c 89 e7 e8 c5 bc 09 00 e9 b5 fe ff ff 89 de 48 c7 c7 f8 94 8b c0 e8 dd 
47 cd da <0f> ff eb d3 e8 3a be 09 00 0f 1f 00 66 66 66 66 90 55 48 89 
e5
[2217513.502283] ---[ end trace cf63b0489605e465 ]---
[2217513.502342] BTRFS: error (device sda4) in 
btrfs_run_delayed_refs:3089: errno=-28 No space left
[2217513.502400] BTRFS info (device sda4): forced readonly
[2217513.502402] BTRFS: error (device sda4) in 
create_pending_snapshot:1625: errno=-28 No space left
[2217513.502458] BTRFS warning (device sda4): Skipping commit of aborted 
transaction.
[2217513.502460] BTRFS: error (device sda4) in cleanup_transaction:1873: 
errno=-28 No space left
[2217524.419368] mail[2522]: segfault at c0 ip 00007f0c5487c33b sp 
00007ffdfac77030 error 4 in libmailutils.so.4.0.0[7f0c547f2000+b0000]
[2217605.435864] BTRFS error (device sda4): pending csums is 22380544



Tomasz Chmielewski
https://lxadm.com
