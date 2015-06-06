Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:54564 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbbFFGNo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 6 Jun 2015 02:13:44 -0400
Received: from mailext.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id D6C0C35E376
	for <linux-btrfs@vger.kernel.org>; Sat,  6 Jun 2015 08:07:10 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: 4.1-rc6 - kernel crash after doing chattr +C
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 06 Jun 2015 15:07:10 +0900
From: Tomasz Chmielewski <tch@virtall.com>
Message-ID: <a0a89c2461696c66da9b453d39967493@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

4.1-rc6, busy filesystem.

I was running mongo import which made quite a lot of IO.
During the import, I did "chattr +C /var/lib/mongodb" - shortly after I 
saw this in dmesg and server died:

[57860.149839] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000008
[57860.149877] IP: [<ffffffffc0158b8e>] 
btrfs_wait_pending_ordered+0x5e/0x110 [btrfs]
[57860.149923] PGD 5d1ac6067 PUD 5d40fc067 PMD 0
[57860.149943] Oops: 0002 [#1] SMP
[57860.149960] Modules linked in: xt_conntrack veth xt_CHECKSUM 
iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc intel_rapl 
iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm 
crct10dif_pclmul eeepc_wmi asus_wmi crc32_pclmul ghash_clmulni_intel 
sparse_keymap aesni_intel aes_x86_64 ie31200_edac lpc_ich lrw gf128mul 
edac_core glue_helper ablk_helper shpchp cryptd serio_raw wmi video 
tpm_infineon 8250_fintek mac_hid btrfs lp parport raid10 raid456 
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq 
e1000e raid1 ahci raid0 ptp libahci pps_core multipath linear
[57860.150203] CPU: 4 PID: 14111 Comm: mongod Not tainted 
4.1.0-040100rc6-generic #201506010235
[57860.150237] Hardware name: System manufacturer System Product 
Name/P8B WS, BIOS 0904 10/24/2011
[57860.150271] task: ffff88007901bc60 ti: ffff8805d5c38000 task.ti: 
ffff8805d5c38000
[57860.150303] RIP: 0010:[<ffffffffc0158b8e>]  [<ffffffffc0158b8e>] 
btrfs_wait_pending_ordered+0x5e/0x110 [btrfs]
[57860.150346] RSP: 0018:ffff8805d5c3bd18  EFLAGS: 00010206
[57860.150364] RAX: 0000000000000000 RBX: ffff880103c9d950 RCX: 
0000000000003d44
[57860.150386] RDX: 0000000000000000 RSI: 0000000000003d44 RDI: 
ffff880806a74838
[57860.150407] RBP: ffff8805d5c3bd88 R08: 0000000000000000 R09: 
0000000000000000
[57860.150428] R10: 0000000000000001 R11: 0000000000000000 R12: 
ffff880806bcb800
[57860.150450] R13: ffff880806a74838 R14: ffff880103c9d8d8 R15: 
ffff88080a7e3518
[57860.150471] FS:  00007f5f4e6dc700(0000) GS:ffff88082fb00000(0000) 
knlGS:0000000000000000
[57860.150504] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[57860.150523] CR2: 0000000000000008 CR3: 000000062a584000 CR4: 
00000000000407e0
[57860.150544] Stack:
[57860.150558]  ffff8805d5c3bd48 ffff88080a7e35c8 ffff880806bcb000 
ffff880806bcb800
[57860.150592]  ffff8800070da638 ffffffffd5c3bdb0 0000000000000287 
ffff88080a72a4d0
[57860.150626]  ffff880806bcb800 ffff88080a72a4d0 ffff880806bcb800 
0000000000000000
[57860.150659] Call Trace:
[57860.150682]  [<ffffffffc015addb>] 
btrfs_commit_transaction+0x40b/0xb60 [btrfs]
[57860.150717]  [<ffffffff810c0700>] ? prepare_to_wait_event+0x100/0x100
[57860.150745]  [<ffffffffc0171973>] btrfs_sync_file+0x313/0x380 [btrfs]
[57860.150768]  [<ffffffff81236bf6>] vfs_fsync_range+0x46/0xc0
[57860.150788]  [<ffffffff81236c8c>] vfs_fsync+0x1c/0x20
[57860.150806]  [<ffffffff81236cc8>] do_fsync+0x38/0x70
[57860.150825]  [<ffffffff812370c3>] SyS_fdatasync+0x13/0x20
[57860.150846]  [<ffffffff8180cb32>] system_call_fastpath+0x16/0x75
[57860.150866] Code: 45 98 48 39 d8 0f 84 ad 00 00 00 48 8d 45 a8 48 83 
c0 18 48 89 45 90 66 0f 1f 44 00 00 48 8b 13 48 8b 43 08 4c 89 ef 4c 8d 
73 88 <48> 89 42 08 48 89 10 48 89 1b 48 89 5b 08 e8 bf 3a 6b c1 e8 aa
[57860.150959] RIP  [<ffffffffc0158b8e>] 
btrfs_wait_pending_ordered+0x5e/0x110 [btrfs]
[57860.150998]  RSP <ffff8805d5c3bd18>
[57860.151014] CR2: 0000000000000008
[57860.151186] ---[ end trace f41cd52aa31494ac ]---


-- 
Tomasz Chmielewski
http://wpkg.org

