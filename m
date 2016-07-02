Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:55038 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbcGBROX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jul 2016 13:14:23 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by syrinx.knorrie.org (Postfix) with ESMTPSA id 584FA600E8
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Jul 2016 19:14:18 +0200 (CEST)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: Filesystem locks up, also with older kernel on any action after
 booting into 4.7-rc4 once
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <472f47d4-b6c9-072d-3fe4-a1ec2af141c7@mendix.com>
Date: Sat, 2 Jul 2016 19:14:18 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just rebooted a VM into a 4.7 kernel. The joy didn't last long. After 
177 seconds the btrfs data partition (root is on ext4) locked up. Worse, 
it keeps locking up on any action performed even when  rebooting it with 
older kernels again. D: The filesystem initially mounts fine, but then 
locks up again immediately.

Linux stacheldraht 4.7.0-rc4-amd64 #1 SMP Debian 4.7~rc4-1~exp1 
(2016-06-20) x86_64 GNU/Linux

ps output shows [btrfs-transaction] in D state:

root      1108  0.0  0.0      0     0 ?        D    17:42   0:00  \_ 
[btrfs-transacti]

 From dmesg:

[  177.715994] ------------[ cut here ]------------
[  177.716032] WARNING: CPU: 0 PID: 1108 at 
/build/linux-vIn3gu/linux-4.7~rc4/fs/btrfs/locking.c:251 
btrfs_tree_lock+0x1eb/0x210 [btrfs]
[  177.716037] Modules linked in: binfmt_misc nf_log_ipv6 ip6t_REJECT 
nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter 
ip6table_mangle ip6table_raw ip6_tables nf_log_ipv4 nf_log_common xt_LOG 
xt_limit ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_owner xt_multiport 
xt_conntrack iptable_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_raw ip_tables 
x_tables intel_powerclamp evdev coretemp pcspkr crct10dif_pclmul 
crc32_pclmul ghash_clmulni_intel quota_v2 quota_tree loop autofs4 ext4 
ecb crc16 jbd2 mbcache btrfs crc32c_generic xor raid6_pq crc32c_intel 
xen_netfront aesni_intel xen_blkfront aes_x86_64 glue_helper lrw 
gf128mul ablk_helper cryptd
[  177.716090] CPU: 0 PID: 1108 Comm: btrfs-transacti Tainted: G 
W       4.7.0-rc4-amd64 #1 Debian 4.7~rc4-1~exp1
[  177.716095]  0000000000000200 00000000a4392a01 ffffffff81312db5 
0000000000000000
[  177.716104]  0000000000000000 ffffffff8107896e ffff880079adb9d8 
ffff88007b940800
[  177.716113]  0000000000004000 ffff880079adb9d8 ffff880079887928 
0000000000000000
[  177.716121] Call Trace:
[  177.716129]  [<ffffffff81312db5>] ? dump_stack+0x5c/0x77
[  177.716138]  [<ffffffff8107896e>] ? __warn+0xbe/0xe0
[  177.716154]  [<ffffffffc01425db>] ? btrfs_tree_lock+0x1eb/0x210 [btrfs]
[  177.716168]  [<ffffffffc00f2325>] ? btrfs_reserve_extent+0x1b5/0x200 
[btrfs]
[  177.716182]  [<ffffffffc00f24d7>] ? 
btrfs_alloc_tree_block+0x167/0x4e0 [btrfs]
[  177.716197]  [<ffffffffc00d981c>] ? __btrfs_cow_block+0x14c/0x5a0 [btrfs]
[  177.716210]  [<ffffffffc00d9dfb>] ? btrfs_cow_block+0x10b/0x1d0 [btrfs]
[  177.716224]  [<ffffffffc010215b>] ? commit_cowonly_roots+0x5b/0x2f0 
[btrfs]
[  177.716238]  [<ffffffffc00eeda3>] ? 
btrfs_run_delayed_refs+0x203/0x2b0 [btrfs]
[  177.716256]  [<ffffffffc016d9c4>] ? 
btrfs_qgroup_account_extents+0x84/0x180 [btrfs]
[  177.716273]  [<ffffffffc0104d78>] ? 
btrfs_commit_transaction+0x568/0xa40 [btrfs]
[  177.716290]  [<ffffffffc01052e5>] ? start_transaction+0x95/0x4a0 [btrfs]
[  177.716304]  [<ffffffffc00ff4d9>] ? transaction_kthread+0x1e9/0x200 
[btrfs]
[  177.716319]  [<ffffffffc00ff2f0>] ? 
btrfs_cleanup_transaction+0x590/0x590 [btrfs]
[  177.716328]  [<ffffffff810972bd>] ? kthread+0xcd/0xf0
[  177.716336]  [<ffffffff815d1d2f>] ? ret_from_fork+0x1f/0x40
[  177.716341]  [<ffffffff810971f0>] ? kthread_create_on_node+0x190/0x190
[  177.716360] ---[ end trace 558c4b7ce67e3503 ]---

And, then repeated every 120 seconds:

[  360.096092] INFO: task btrfs-transacti:1108 blocked for more than 120 
seconds.
[  360.096105]       Tainted: G        W       4.7.0-rc4-amd64 #1
[  360.096110] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  360.096120] btrfs-transacti D ffff88007d016d80     0  1108      2 
0x00000000
[  360.096128]  ffff88000292ee80 0000000000000000 ffff880078f3bbf0 
ffff880078f3c000
[  360.096136]  ffff880079adba40 ffff880079adba58 ffff880078f3bc08 
ffff880079adba38
[  360.096143]  0000000000000000 ffffffff815cdc11 ffff880079adb9d8 
ffffffffc01424aa
[  360.096151] Call Trace:
[  360.096162]  [<ffffffff815cdc11>] ? schedule+0x31/0x80
[  360.096193]  [<ffffffffc01424aa>] ? btrfs_tree_lock+0xba/0x210 [btrfs]
[  360.096201]  [<ffffffff810b8880>] ? wake_atomic_t_function+0x60/0x60
[  360.096215]  [<ffffffffc00f24d7>] ? 
btrfs_alloc_tree_block+0x167/0x4e0 [btrfs]
[  360.096229]  [<ffffffffc00d981c>] ? __btrfs_cow_block+0x14c/0x5a0 [btrfs]
[  360.096241]  [<ffffffffc00d9dfb>] ? btrfs_cow_block+0x10b/0x1d0 [btrfs]
[  360.096256]  [<ffffffffc010215b>] ? commit_cowonly_roots+0x5b/0x2f0 
[btrfs]
[  360.096269]  [<ffffffffc00eeda3>] ? 
btrfs_run_delayed_refs+0x203/0x2b0 [btrfs]
[  360.096287]  [<ffffffffc016d9c4>] ? 
btrfs_qgroup_account_extents+0x84/0x180 [btrfs]
[  360.096303]  [<ffffffffc0104d78>] ? 
btrfs_commit_transaction+0x568/0xa40 [btrfs]
[  360.096320]  [<ffffffffc01052e5>] ? start_transaction+0x95/0x4a0 [btrfs]
[  360.096334]  [<ffffffffc00ff4d9>] ? transaction_kthread+0x1e9/0x200 
[btrfs]
[  360.096348]  [<ffffffffc00ff2f0>] ? 
btrfs_cleanup_transaction+0x590/0x590 [btrfs]
[  360.096356]  [<ffffffff810972bd>] ? kthread+0xcd/0xf0
[  360.096362]  [<ffffffff815d1d2f>] ? ret_from_fork+0x1f/0x40
[  360.096367]  [<ffffffff810971f0>] ? kthread_create_on_node+0x190/0x190

I'm surprised to see qgroup mentioned, because I'm quite sure I don't 
use that.

I just force-rebooted the thing. Starting went well, mounting the 
partition went without any error.

But, any operation on the thing locks it up again.

-# btrfs sub list .

[   41.046160] ------------[ cut here ]------------
[   41.046196] WARNING: CPU: 2 PID: 573 at 
/build/linux-vIn3gu/linux-4.7~rc4/fs/btrfs/locking.c:251 
btrfs_tree_lock+0x1eb/0x210 [btrfs]
[   41.046201] Modules linked in: nf_log_ipv6 ip6t_REJECT nf_reject_ipv6 
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6table_mangle 
ip6table_raw ip6_tables nf_log_ipv4 nf_log_common xt_LOG xt_limit 
ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_owner xt_multiport xt_conntrack 
iptable_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 
nf_nat nf_conntrack iptable_mangle iptable_raw ip_tables x_tables 
intel_powerclamp coretemp evdev crct10dif_pclmul crc32_pclmul pcspkr 
ghash_clmulni_intel quota_v2 quota_tree loop autofs4 ext4 ecb crc16 jbd2 
mbcache btrfs crc32c_generic xor raid6_pq crc32c_intel aesni_intel 
xen_netfront xen_blkfront aes_x86_64 glue_helper lrw gf128mul 
ablk_helper cryptd
[   41.046257] CPU: 2 PID: 573 Comm: btrfs-transacti Tainted: G        W 
       4.7.0-rc4-amd64 #1 Debian 4.7~rc4-1~exp1
[   41.046265]  0000000000000200 000000002054ffcc ffffffff81312db5 
0000000000000000
[   41.046273]  0000000000000000 ffffffff8107896e ffff88007a03da18 
ffff8800027f4800
[   41.046281]  0000000000004000 ffff88007a03da18 ffff88007a3118e8 
0000000000000000
[   41.046289] Call Trace:
[   41.046297]  [<ffffffff81312db5>] ? dump_stack+0x5c/0x77
[   41.046304]  [<ffffffff8107896e>] ? __warn+0xbe/0xe0
[   41.046320]  [<ffffffffc013c5db>] ? btrfs_tree_lock+0x1eb/0x210 [btrfs]
[   41.046334]  [<ffffffffc00ec325>] ? btrfs_reserve_extent+0x1b5/0x200 
[btrfs]
[   41.046348]  [<ffffffffc00ec4d7>] ? 
btrfs_alloc_tree_block+0x167/0x4e0 [btrfs]
[   41.046363]  [<ffffffffc00d381c>] ? __btrfs_cow_block+0x14c/0x5a0 [btrfs]
[   41.046375]  [<ffffffffc00d3dfb>] ? btrfs_cow_block+0x10b/0x1d0 [btrfs]
[   41.046389]  [<ffffffffc00fc15b>] ? commit_cowonly_roots+0x5b/0x2f0 
[btrfs]
[   41.046404]  [<ffffffffc00e8da3>] ? 
btrfs_run_delayed_refs+0x203/0x2b0 [btrfs]
[   41.046421]  [<ffffffffc01679c4>] ? 
btrfs_qgroup_account_extents+0x84/0x180 [btrfs]
[   41.046439]  [<ffffffffc00fed78>] ? 
btrfs_commit_transaction+0x568/0xa40 [btrfs]
[   41.046455]  [<ffffffffc00ff2e5>] ? start_transaction+0x95/0x4a0 [btrfs]
[   41.046470]  [<ffffffffc00f94d9>] ? transaction_kthread+0x1e9/0x200 
[btrfs]
[   41.046485]  [<ffffffffc00f92f0>] ? 
btrfs_cleanup_transaction+0x590/0x590 [btrfs]
[   41.046494]  [<ffffffff810972bd>] ? kthread+0xcd/0xf0
[   41.046501]  [<ffffffff815d1d2f>] ? ret_from_fork+0x1f/0x40
[   41.046506]  [<ffffffff810971f0>] ? kthread_create_on_node+0x190/0x190
[   41.046510] ---[ end trace 8e8eb8d8f9f913e2 ]---

Will reboot back into 4.6 kernel now.

Oh... interesting... Wham!

[   33.189003] ------------[ cut here ]------------
[   33.189039] WARNING: CPU: 2 PID: 571 at 
/build/linux-FzSZXp/linux-4.6.2/fs/btrfs/locking.c:251 
btrfs_tree_lock+0x1eb/0x210 [btrfs]
[   33.189043] Modules linked in: nf_log_ipv6(E) ip6t_REJECT(E) 
nf_reject_ipv6(E) nf_conntrack_ipv6(E) nf_defrag_ipv6(E) 
ip6table_filter(E) ip6table_mangle(E) ip6table_raw(E) ip6_tables(E) 
nf_log_ipv4(E) nf_log_common(E) xt_LOG(E) xt_limit(E) ipt_REJECT(E) 
nf_reject_ipv4(E) xt_tcpudp(E) xt_owner(E) xt_multiport(E) 
xt_conntrack(E) iptable_filter(E) iptable_nat(E) nf_conntrack_ipv4(E) 
nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E) 
iptable_mangle(E) iptable_raw(E) ip_tables(E) x_tables(E) coretemp(E) 
crct10dif_pclmul(E) evdev(E) crc32_pclmul(E) pcspkr(E) 
ghash_clmulni_intel(E) quota_v2(E) quota_tree(E) loop(E) autofs4(E) 
ext4(E) ecb(E) crc16(E) jbd2(E) mbcache(E) btrfs(E) crc32c_generic(E) 
xor(E) raid6_pq(E) crc32c_intel(E) xen_netfront(E) xen_blkfront(E) 
aesni_intel(E) aes_x86_64(E) glue_helper(E) lrw(E) gf128mul(E) 
ablk_helper(E) cryptd(E)
[   33.189097] CPU: 2 PID: 571 Comm: btrfs-transacti Tainted: G        W 
   E   4.6.0-1-amd64 #1 Debian 4.6.2-2
[   33.189101]  0000000000000200 00000000ff3b5a1a ffffffff81311485 
0000000000000000
[   33.189105]  0000000000000000 ffffffff8107a50e ffff88007b8419d8 
ffff88007b6a4800
[   33.189109]  0000000000004000 ffff88007b8419d8 ffff88007b832960 
ffff880000156128
[   33.189116] Call Trace:
[   33.189125]  [<ffffffff81311485>] ? dump_stack+0x5c/0x77
[   33.189133]  [<ffffffff8107a50e>] ? __warn+0xbe/0xe0
[   33.189148]  [<ffffffffc01ada1b>] ? btrfs_tree_lock+0x1eb/0x210 [btrfs]
[   33.189162]  [<ffffffffc015f30e>] ? btrfs_reserve_extent+0x8e/0x1c0 
[btrfs]
[   33.189175]  [<ffffffffc015f6bc>] ? 
btrfs_alloc_tree_block+0x27c/0x4f0 [btrfs]
[   33.189192]  [<ffffffffc0146b1c>] ? __btrfs_cow_block+0x14c/0x5a0 [btrfs]
[   33.189204]  [<ffffffffc01470fb>] ? btrfs_cow_block+0x10b/0x1c0 [btrfs]
[   33.189219]  [<ffffffffc01ec9c2>] ? commit_cowonly_roots+0x5d/0x2b5 
[btrfs]
[   33.189232]  [<ffffffffc015bee3>] ? 
btrfs_run_delayed_refs+0x203/0x2b0 [btrfs]
[   33.189249]  [<ffffffffc01d9284>] ? 
btrfs_qgroup_account_extents+0x84/0x180 [btrfs]
[   33.189266]  [<ffffffffc017185e>] ? 
btrfs_commit_transaction+0x55e/0xa40 [btrfs]
[   33.189282]  [<ffffffffc0171dd5>] ? start_transaction+0x95/0x4a0 [btrfs]
[   33.189296]  [<ffffffffc016c6b9>] ? transaction_kthread+0x1e9/0x200 
[btrfs]
[   33.189310]  [<ffffffffc016c4d0>] ? 
btrfs_cleanup_transaction+0x590/0x590 [btrfs]
[   33.189318]  [<ffffffff81098f1d>] ? kthread+0xcd/0xf0
[   33.189325]  [<ffffffff815c6872>] ? ret_from_fork+0x22/0x40
[   33.189330]  [<ffffffff81098e50>] ? kthread_create_on_node+0x190/0x190
[   33.189334] ---[ end trace 69b0e2e54a91a13a ]---

Ok, back to 4.5...

[   32.989002] ------------[ cut here ]------------
[   32.989039] WARNING: CPU: 1 PID: 574 at 
/build/linux-dLBBFB/linux-4.5.3/fs/btrfs/locking.c:251 
btrfs_tree_lock+0x1eb/0x210 [btrfs]()
[   32.989044] Modules linked in: nf_log_ipv6(E) ip6t_REJECT(E) 
nf_reject_ipv6(E) nf_conntrack_ipv6(E) nf_defrag_ipv6(E) 
ip6table_filter(E) ip6table_mangle(E) ip6table_raw(E) ip6_tables(E) 
nf_log_ipv4(E) nf_log_common(E) xt_LOG(E) xt_limit(E) ipt_REJECT(E) 
nf_reject_ipv4(E) xt_tcpudp(E) xt_owner(E) xt_multiport(E) 
xt_conntrack(E) iptable_filter(E) iptable_nat(E) nf_conntrack_ipv4(E) 
nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E) 
iptable_mangle(E) iptable_raw(E) ip_tables(E) x_tables(E) coretemp(E) 
crct10dif_pclmul(E) crc32_pclmul(E) evdev(E) ghash_clmulni_intel(E) 
pcspkr(E) quota_v2(E) quota_tree(E) loop(E) autofs4(E) ext4(E) ecb(E) 
crc16(E) mbcache(E) jbd2(E) btrfs(E) crc32c_generic(E) xor(E) 
raid6_pq(E) crc32c_intel(E) xen_netfront(E) xen_blkfront(E) 
aesni_intel(E) aes_x86_64(E) glue_helper(E) lrw(E) gf128mul(E) 
ablk_helper(E) cryptd(E)
[   32.989095] CPU: 1 PID: 574 Comm: btrfs-transacti Tainted: G        W 
   E   4.5.0-2-amd64 #1 Debian 4.5.3-2
[   32.989099]  0000000000000200 00000000664900ad ffffffff81308145 
0000000000000000
[   32.989104]  ffffffffc016d338 ffffffff8107917d ffff88007b84de88 
ffff880000013000
[   32.989108]  0000000000004000 ffff88007b84de88 ffff88007b868980 
ffffffffc012029b
[   32.989115] Call Trace:
[   32.989124]  [<ffffffff81308145>] ? dump_stack+0x5c/0x77
[   32.989132]  [<ffffffff8107917d>] ? warn_slowpath_common+0x7d/0xb0
[   32.989147]  [<ffffffffc012029b>] ? btrfs_tree_lock+0x1eb/0x210 [btrfs]
[   32.989160]  [<ffffffffc00d2b2e>] ? btrfs_reserve_extent+0x8e/0x1c0 
[btrfs]
[   32.989174]  [<ffffffffc00d2edc>] ? 
btrfs_alloc_tree_block+0x27c/0x4f0 [btrfs]
[   32.989188]  [<ffffffffc00ba3ec>] ? __btrfs_cow_block+0x14c/0x5a0 [btrfs]
[   32.989200]  [<ffffffffc00ba9cb>] ? btrfs_cow_block+0x10b/0x1c0 [btrfs]
[   32.989215]  [<ffffffffc015edd2>] ? commit_cowonly_roots+0x5d/0x2b5 
[btrfs]
[   32.989228]  [<ffffffffc00cf723>] ? 
btrfs_run_delayed_refs+0x203/0x2a0 [btrfs]
[   32.989245]  [<ffffffffc014b7cd>] ? 
btrfs_qgroup_account_extents+0x7d/0x120 [btrfs]
[   32.989261]  [<ffffffffc00e4dce>] ? 
btrfs_commit_transaction+0x55e/0xa40 [btrfs]
[   32.989277]  [<ffffffffc00e5345>] ? start_transaction+0x95/0x4a0 [btrfs]
[   32.989292]  [<ffffffffc00dfd10>] ? transaction_kthread+0x220/0x240 
[btrfs]
[   32.989306]  [<ffffffffc00dfaf0>] ? 
btrfs_cleanup_transaction+0x580/0x580 [btrfs]
[   32.989315]  [<ffffffff81096c6d>] ? kthread+0xcd/0xf0
[   32.989321]  [<ffffffff81096ba0>] ? kthread_create_on_node+0x190/0x190
[   32.989327]  [<ffffffff815b780f>] ? ret_from_fork+0x3f/0x70
[   32.989332]  [<ffffffff81096ba0>] ? kthread_create_on_node+0x190/0x190
[   32.989337] ---[ end trace c64c2fa8373abec0 ]---

So, something happened inside the fs that makes it lock up every time I 
try to do anything with it...

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
