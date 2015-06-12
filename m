Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:51187 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbbFLXX4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 19:23:56 -0400
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: kernel crashes with btrfs and busy database IO - how to debug?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 13 Jun 2015 08:23:53 +0900
From: Tomasz Chmielewski <tch@virtall.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <557AA1B9.9040009@cn.fujitsu.com>
References: <ae9b9ca434c98509ca6c1ba6dbd84b63@admin.virtall.com>
 <557A8691.6070908@cn.fujitsu.com>
 <73cb882c23a71c9039a0e7bbfddfab64@admin.virtall.com>
 <557AA1B9.9040009@cn.fujitsu.com>
Message-ID: <cf09b22a06bf52a5b365fa44e15583f7@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-06-12 18:09, Qu Wenruo wrote:

>> while true; do dmesg -c ; done
>> 
>> but that's usually incomplete.
> If your dmesg is up-to-date, dmesg -w should do it better than your 
> script.
> And normally, I can get a full trace with backtrace when kernel down 
> with it.
> 
> And if it still can't get the full trace, then try kdump.

Thanks for the tip with dmesg -w - my version didn't have this option, 
so I had to get it from newer util-linux. Unfortunately still didn't get 
the crash with this (over SSH).

I did get it from /var/crash/ though - is it more useful? I don't have 
vmlinux for this kernel though, but have just built 4.1-rc7 with the 
same config, can try to get the crash there.

Let me know.


(lots of "blocked for more than 120 second" prior to the crash).

[45196.626314] INFO: task mongod:26260 blocked for more than 120 
seconds.
[45196.626335]       Not tainted 4.1.0-040100rc7-generic #201506080035
[45196.626354] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[45196.626386] mongod          D ffff8803411f3ce8     0 26260   7478 
0x00000100
[45196.626388]  ffff8803411f3ce8 ffff8803411f3d08 ffff8800c5e8bfc0 
ffff88080bf2bc60
[45196.626389]  ffff8808075dda90 0000000000000246 ffff8803411f4000 
ffff8808094e71f0
[45196.626391]  ffff8808094e7000 ffff8808094e71f0 0000000000000001 
ffff8803411f3d08
[45196.626392] Call Trace:
[45196.626393]  [<ffffffff81808b47>] schedule+0x37/0x90
[45196.626400]  [<ffffffffc015a131>] 
wait_current_trans.isra.33+0xb1/0x110 [btrfs]
[45196.626401]  [<ffffffff810c0700>] ? prepare_to_wait_event+0x100/0x100
[45196.626407]  [<ffffffffc015be1e>] 
start_transaction.part.35+0x46e/0x540 [btrfs]
[45196.626414]  [<ffffffffc015bf19>] start_transaction+0x29/0x30 [btrfs]
[45196.626420]  [<ffffffffc015c25b>] btrfs_start_transaction+0x1b/0x20 
[btrfs]
[45196.626427]  [<ffffffffc017180a>] btrfs_sync_file+0x1aa/0x380 [btrfs]
[45196.626428]  [<ffffffff811390c9>] ? 
__seccomp_phase1_filter+0x69/0x1a0
[45196.626430]  [<ffffffff81236c26>] vfs_fsync_range+0x46/0xc0
[45196.626431]  [<ffffffff811c0fc3>] ? find_vma+0x73/0x80
[45196.626432]  [<ffffffff811c6e88>] SyS_msync+0x188/0x210
[45196.626434]  [<ffffffff8180cbb2>] system_call_fastpath+0x16/0x75
[45196.626435] INFO: task mongod:26942 blocked for more than 120 
seconds.
[45196.626456]       Not tainted 4.1.0-040100rc7-generic #201506080035
[45196.626475] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[45196.626507] mongod          D ffff880020957d18     0 26942   7478 
0x00000100
[45196.626509]  ffff880020957d18 ffff880020957d08 ffff8800c5e8bfc0 
ffff88080bf28a10
[45196.626510]  ffff88071f2ce4a0 0000000000000246 ffff880020958000 
ffff8800b3c5fc98
[45196.626511]  0000000000000000 ffff8800b3c5fc20 ffff8808072381b0 
ffff880020957d38
[45196.626513] Call Trace:
[45196.626514]  [<ffffffff81808b47>] schedule+0x37/0x90
[45196.626521]  [<ffffffffc0158cf5>] wait_for_commit.isra.25+0x45/0x80 
[btrfs]
[45196.626522]  [<ffffffff810c0700>] ? prepare_to_wait_event+0x100/0x100
[45196.626529]  [<ffffffffc015ab23>] 
btrfs_commit_transaction+0x153/0xb60 [btrfs]
[45196.626537]  [<ffffffffc0176c96>] ? 
btrfs_wait_ordered_range+0x106/0x160 [btrfs]
[45196.626545]  [<ffffffffc0171973>] btrfs_sync_file+0x313/0x380 [btrfs]
[45196.626546]  [<ffffffff81236c26>] vfs_fsync_range+0x46/0xc0
[45196.626547]  [<ffffffff81236cbc>] vfs_fsync+0x1c/0x20
[45196.626549]  [<ffffffff81236cf8>] do_fsync+0x38/0x70
[45196.626550]  [<ffffffff812370f3>] SyS_fdatasync+0x13/0x20
[45196.626551]  [<ffffffff8180cbb2>] system_call_fastpath+0x16/0x75
[45705.854778] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000008
[45705.854824] IP: [<ffffffffc0158b8e>] 
btrfs_wait_pending_ordered+0x5e/0x110 [btrfs]
[45705.854870] PGD 457a23067 PUD 7113e6067 PMD 0
[45705.854889] Oops: 0002 [#1] SMP
[45705.854907] Modules linked in: xt_conntrack veth xt_CHECKSUM 
iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc intel_rapl 
iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm 
eeepc_wmi asus_wmi crct10dif_pclmul crc32_pclmul ghash_clmulni_intel 
aesni_intel sparse_keymap ie31200_edac shpchp 8250_fintek lpc_ich 
edac_core aes_x86_64 lrw gf128mul tpm_infineon glue_helper serio_raw 
video mac_hid ablk_helper cryptd wmi btrfs lp parport raid10 raid456 
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq 
e1000e raid1 ahci ptp raid0 libahci pps_core multipath linear
[45705.855168] CPU: 1 PID: 4010 Comm: mongod Not tainted 
4.1.0-040100rc7-generic #201506080035
[45705.855202] Hardware name: System manufacturer System Product 
Name/P8B WS, BIOS 0904 10/24/2011
[45705.855235] task: ffff8807fc85da90 ti: ffff8800a0620000 task.ti: 
ffff8800a0620000
[45705.855266] RIP: 0010:[<ffffffffc0158b8e>]  [<ffffffffc0158b8e>] 
btrfs_wait_pending_ordered+0x5e/0x110 [btrfs]
[45705.855308] RSP: 0018:ffff8800a0623d18  EFLAGS: 00010212
[45705.855326] RAX: 0000000000000000 RBX: ffff88000e1e0078 RCX: 
000000000000322e
[45705.855347] RDX: 0000000000000000 RSI: 000000000000322e RDI: 
ffff8808068aa838
[45705.855368] RBP: ffff8800a0623d88 R08: 0000000000000000 R09: 
0000000000000000
[45705.855389] R10: 0000000000000001 R11: 0000000000000000 R12: 
ffff880806d67800
[45705.855410] R13: ffff8808068aa838 R14: ffff88000e1e0000 R15: 
ffff8800b3c5fc20
[45705.855431] FS:  00007f6fc5f37700(0000) GS:ffff88082fa40000(0000) 
knlGS:0000000000000000
[45705.855463] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[45705.855482] CR2: 0000000000000008 CR3: 000000046293a000 CR4: 
00000000000407e0
[45705.855503] Stack:
[45705.855516]  ffff8800a0623d48 ffff8800b3c5fcd0 ffff8808094fe800 
ffff880806d67800
[45705.855549]  ffff88080a70ec28 ffffffffa0623db0 0000000000000283 
ffff88080a6f1c60
[45705.855582]  ffff880806d67800 ffff88080a6f1c60 ffff880806d67800 
0000000000000000
[45705.855615] Call Trace:
[45705.855637]  [<ffffffffc015addb>] 
btrfs_commit_transaction+0x40b/0xb60 [btrfs]
[45705.855671]  [<ffffffff810c0700>] ? prepare_to_wait_event+0x100/0x100
[45705.855698]  [<ffffffffc0171973>] btrfs_sync_file+0x313/0x380 [btrfs]
[45705.855721]  [<ffffffff81236c26>] vfs_fsync_range+0x46/0xc0
[45705.855740]  [<ffffffff81236cbc>] vfs_fsync+0x1c/0x20
[45705.855758]  [<ffffffff81236cf8>] do_fsync+0x38/0x70
[45705.855777]  [<ffffffff812370d0>] SyS_fsync+0x10/0x20
[45705.855796]  [<ffffffff8180cbb2>] system_call_fastpath+0x16/0x75
[45705.855815] Code: 45 98 48 39 d8 0f 84 ad 00 00 00 48 8d 45 a8 48 83 
c0 18 48 89 45 90 66 0f 1f 44 00 00 48 8b 13 48 8b 43 08 4c 89 ef 4c 8d 
73 88 <48> 89 42 08 48 89 10 48 89 1b 48 89 5b 08 e8 4f 3b 6b c1 e8 3a
[45705.855906] RIP  [<ffffffffc0158b8e>] 
btrfs_wait_pending_ordered+0x5e/0x110 [btrfs]
[45705.855944]  RSP <ffff8800a0623d18>
[45705.855959] CR2: 0000000000000008


-- 
Tomasz Chmielewski
http://wpkg.org


