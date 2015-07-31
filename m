Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:15977 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbbGaTeQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jul 2015 15:34:16 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: btrfs trace / deadlock with 4.2-rc3
Message-ID: <55BBCDBC.3030709@profihost.ag>
Date: Fri, 31 Jul 2015 21:34:20 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

i got the following error today.

2015-07-31 21:00:19     ---[ end Kernel panic - not syncing: Watchdog 
detected hard LOCKUP on cpu 12
2015-07-31 21:00:19     Kernel Offset: 0x0 from 0xffffffff81000000 
(relocation range: 0xffffffff80000000-0xffffffff9fffffff)
2015-07-31 21:00:18     Shutting down cpus with NMI
2015-07-31 21:00:17     Kernel panic - not syncing: Watchdog detected 
hard LOCKUP on cpu 12
2015-07-31 21:00:13     ---[ end trace f1b45f288cc28a82 ]---
2015-07-31 21:00:13     RSP <ffff880f0cb7fb28>
2015-07-31 21:00:13     RIP [<ffffffffa02152ee>] 
insert_inline_extent_backref+0xde/0xe0 [btrfs]
2015-07-31 21:00:13     Code: 45 10 49 89 d9 48 8b 55 c8 4c 89 34 24 4c 
89 e9 4c 89 fe 4c 89 e7 48 89 44 24 10 8b 45 28 89 44 24 08 e8 a6 ee ff 
ff 31 c0 eb ae <0f> 0b 0f 1f 44 00 00 55 ba c0 00 00 00 65 48 8b 04 25 
80 a8 00
2015-07-31 21:00:12     [<ffffffff81090a30>] ? kthread_worker_fn+0x150/0x150
2015-07-31 21:00:12     [<ffffffff815f9088>] ret_from_fork+0x58/0x90
2015-07-31 21:00:12     [<ffffffff81090a30>] ? kthread_worker_fn+0x150/0x150
2015-07-31 21:00:12     [<ffffffff81090af9>] kthread+0xc9/0xe0
2015-07-31 21:00:12     [<ffffffffa02313f0>] ? open_ctree+0x22e0/0x22e0 
[btrfs]
2015-07-31 21:00:12     [<ffffffffa02315bd>] 
transaction_kthread+0x1cd/0x250 [btrfs]
2015-07-31 21:00:12     [<ffffffffa023390e>] 
btrfs_commit_transaction+0x4e/0xae0 [btrfs]
2015-07-31 21:00:12     [<ffffffffa0221f8b>] 
btrfs_run_delayed_refs+0x7b/0x2a0 [btrfs]
2015-07-31 21:00:12     [<ffffffff810a81cc>] ? put_prev_entity+0x3c/0x310
2015-07-31 21:00:12     [<ffffffffa021f754>] 
__btrfs_run_delayed_refs+0xdf4/0x11b0 [btrfs]
2015-07-31 21:00:12     [<ffffffff810a0e05>] ? sched_clock_cpu+0x85/0xc0
2015-07-31 21:00:12     [<ffffffffa0215db6>] 
__btrfs_inc_extent_ref.isra.74+0xa6/0x270 [btrfs]
2015-07-31 21:00:12     [<ffffffffa020945a>] ? 
btrfs_alloc_path+0x1a/0x20 [btrfs]
2015-07-31 21:00:12     [<ffffffff81187fb2>] ? kmem_cache_alloc+0x122/0x130
2015-07-31 21:00:11     Call Trace:
2015-07-31 21:00:11     ffffea003bf76800 0000000000002203 
ffff880a368620b8 ffff88105347d800
2015-07-31 21:00:11     0000000000000001 ffffffff81187fb2 
ffff880f0cb7fb88 ffffffffa020945a
2015-07-31 21:00:11     0000000000000000 0000000000000005 
0000000000000001 0000000000000000Stack:
2015-07-31 21:00:11     CR2: 00007fd544c85a84 CR3: 0000000001a14000 CR4: 
00000000001407e0
2015-07-31 21:00:11     CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
2015-07-31 21:00:11     FS: 0000000000000000(0000) 
GS:ffff88107fc00000(0000) knlGS:0000000000000000
2015-07-31 21:00:11     R13: 0000000000000000 R14: 0000000000000000 R15: 
ffff88095a4d0c60
2015-07-31 21:00:11     R10: 0000000000000000 R11: 0000000000000002 R12: 
ffff8810539ce000
2015-07-31 21:00:11     RBP: ffff880f0cb7fba8 R08: 0000000000004000 R09: 
ffff880f0cb7fa08
2015-07-31 21:00:11     RDX: 0000000000002000 RSI: 0000000000000001 RDI: 
0000000000000000
2015-07-31 21:00:11     RAX: 0000000000000000 RBX: 0000000000000001 RCX: 
0000000000000001
2015-07-31 21:00:11     RSP: 0018:ffff880f0cb7fb28 EFLAGS: 00010293
2015-07-31 21:00:10     RIP: 0010:[<ffffffffa02152ee>] 
[<ffffffffa02152ee>] insert_inline_extent_backref+0xde/0xe0 [btrfs]
2015-07-31 21:00:10     task: ffff880896429d30 ti: ffff880f0cb7c000 
task.ti: ffff880f0cb7c000
2015-07-31 21:00:10     Hardware name: Supermicro X10DRH/X10DRH-IT, BIOS 
1.0c 02/18/2015
2015-07-31 21:00:10     CPU: 8 PID: 4407 Comm: btrfs-transacti Tainted: 
G D W O 4.2-rc3-ph #1
2015-07-31 21:00:10     Modules linked in: dm_mod netconsole ipt_REJECT 
nf_reject_ipv4 xt_multiport iptable_filter ip_tables x_tables 
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative 
bonding ext2 coretemp usbhid loop ehci_pci ehci_hcd sb_edac usbcore 
i2c_i801 ipmi_si edac_core i2c_core usb_common shpchp ipmi_msghandler 
button btrfs lzo_compress raid0 raid456 async_raid6_recov async_memcpy 
async_pq async_xor async_tx xor raid6_pq raid1 md_mod sg ixgbe(O) 
i40e(O) sd_mod vxlan ip6_udp_tunnel udp_tunnel ahci ptp aacraid libahci 
pps_core
2015-07-31 21:00:10     invalid opcode: 0000 [#3] SMP
2015-07-31 21:00:10     kernel BUG at fs/btrfs/extent-tree.c:1833!
2015-07-31 21:00:10     ------------[ cut here ]------------
2015-07-31 20:59:48     Fixing recursive fault but reboot is needed!
2015-07-31 20:59:48     ---[ end trace f1b45f288cc28a81 ]---
2015-07-31 20:59:48     CR2: ffffffffffffffd8
2015-07-31 20:59:48     RSP <ffff880f7b6c7728>
2015-07-31 20:59:48     RIP [<ffffffff81090d80>] kthread_data+0x10/0x20
2015-07-31 20:59:48     Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 
e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 c0 08 00 
00 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 
44 00 00
2015-07-31 20:59:48     [<ffffffff81090a30>] ? kthread_worker_fn+0x150/0x150
2015-07-31 20:59:48     [<ffffffff815f9088>] ret_from_fork+0x58/0x90
2015-07-31 20:59:48     [<ffffffff81090a30>] ? kthread_worker_fn+0x150/0x150
2015-07-31 20:59:48     [<ffffffff81090af9>] kthread+0xc9/0xe0
2015-07-31 20:59:48     [<ffffffff8108b0f0>] ? 
process_scheduled_works+0x40/0x40
2015-07-31 20:59:47     [<ffffffff8108b213>] worker_thread+0x123/0x430
2015-07-31 20:59:47     [<ffffffff8108ae53>] process_one_work+0x153/0x3b0
2015-07-31 20:59:47     [<ffffffffa0265802>] 
btrfs_extent_refs_helper+0x12/0x20 [btrfs]
2015-07-31 20:59:47     [<ffffffffa02653e9>] 
normal_work_helper+0xb9/0x2a0 [btrfs]
2015-07-31 20:59:47     [<ffffffffa0222487>] 
delayed_ref_async_start+0x37/0x90 [btrfs]
2015-07-31 20:59:47     [<ffffffffa0221f8b>] 
btrfs_run_delayed_refs+0x7b/0x2a0 [btrfs]
2015-07-31 20:59:47     [<ffffffffa0234955>] ? 
start_transaction+0x135/0x5c0 [btrfs]
2015-07-31 20:59:47     [<ffffffff8109a3cd>] ? ttwu_do_wakeup+0x1d/0xd0
2015-07-31 20:59:47     [<ffffffffa021f754>] 
__btrfs_run_delayed_refs+0xdf4/0x11b0 [btrfs]
2015-07-31 20:59:47     [<ffffffff810a8874>] ? enqueue_entity+0x384/0x990
2015-07-31 20:59:47     [<ffffffffa0215db6>] 
__btrfs_inc_extent_ref.isra.74+0xa6/0x270 [btrfs]
2015-07-31 20:59:47     [<ffffffffa020945a>] ? 
btrfs_alloc_path+0x1a/0x20 [btrfs]
2015-07-31 20:59:47     [<ffffffff81187fb2>] ? kmem_cache_alloc+0x122/0x130
2015-07-31 20:59:46     [<ffffffffa0215270>] ? 
insert_inline_extent_backref+0x60/0xe0 [btrfs]
2015-07-31 20:59:46     [<ffffffffa02152ee>] ? 
insert_inline_extent_backref+0xde/0xe0 [btrfs]
2015-07-31 20:59:46     [<ffffffff815fa7a8>] invalid_op+0x18/0x20
2015-07-31 20:59:46     [<ffffffff81003520>] do_invalid_op+0x20/0x30
2015-07-31 20:59:46     [<ffffffffa024d0d4>] ? 
btrfs_get_token_64+0x64/0xf0 [btrfs]
2015-07-31 20:59:46     [<ffffffffa02152ee>] ? 
insert_inline_extent_backref+0xde/0xe0 [btrfs]
2015-07-31 20:59:46     [<ffffffff81002f5c>] do_error_trap+0xbc/0x100
2015-07-31 20:59:46     [<ffffffff81091822>] ? 
__atomic_notifier_call_chain+0x12/0x20
2015-07-31 20:59:46     [<ffffffff81002db9>] do_trap+0x69/0x150
2015-07-31 20:59:46     [<ffffffff81006678>] die+0x58/0x90
2015-07-31 20:59:46     [<ffffffff810064e6>] oops_end+0x96/0xe0
2015-07-31 20:59:45     [<ffffffff81076877>] do_exit+0x6d7/0xa30
2015-07-31 20:59:45     [<ffffffff815f5319>] schedule+0x29/0x70
2015-07-31 20:59:45     [<ffffffff815f5048>] __schedule+0x5a8/0x810
2015-07-31 20:59:45     [<ffffffff8108be95>] wq_worker_sleeping+0x15/0xa0
2015-07-31 20:59:45     Call Trace:
2015-07-31 20:59:45     ffff880f7b6c7fd8 0000000000011ac0 
ffff880f7b6c77a8 ffff88104ebf1d30
2015-07-31 20:59:45     ffff880f7b6c77b8 ffffffff815f5048 
ffff88104ebf1d30 0000000000011ac0
2015-07-31 20:59:45     ffff880f7b6c7748 ffffffff8108be95 
ffff880f7b6c7748 ffff88104ebf2648Stack:
2015-07-31 20:59:45     CR2: 0000000000000028 CR3: 0000000001a14000 CR4: 
00000000001407e0
2015-07-31 20:59:45     CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
2015-07-31 20:59:44     FS: 0000000000000000(0000) 
GS:ffff88107fcc0000(0000) knlGS:0000000000000000
2015-07-31 20:59:44     R13: 000000000000000e R14: 0000000000000001 R15: 
ffff88104ebf1d30
2015-07-31 20:59:44     R10: ffff8809e9c28000 R11: 0000000000000000 R12: 
ffff88107fcd1ac0
2015-07-31 20:59:44     RBP: ffff880f7b6c7728 R08: 0000000000000001 R09: 
0000000000000027
2015-07-31 20:59:44     RDX: 0000000000000000 RSI: 000000000000000e RDI: 
ffff88104ebf1d30
2015-07-31 20:59:44     RAX: 0000000000000000 RBX: 000000000000000e RCX: 
0000000000000000
2015-07-31 20:59:44     RSP: 0018:ffff880f7b6c7728 EFLAGS: 00010092
2015-07-31 20:59:44     RIP: 0010:[<ffffffff81090d80>] 
[<ffffffff81090d80>] kthread_data+0x10/0x20
2015-07-31 20:59:44     task: ffff88104ebf1d30 ti: ffff880f7b6c4000 
task.ti: ffff880f7b6c4000
2015-07-31 20:59:44     Hardware name: Supermicro X10DRH/X10DRH-IT, BIOS 
1.0c 02/18/2015
2015-07-31 20:59:44     CPU: 14 PID: 9212 Comm: kworker/u66:6 Tainted: G 
D W O 4.2-rc3-ph #1
2015-07-31 20:59:43     Modules linked in: dm_mod netconsole ipt_REJECT 
nf_reject_ipv4 xt_multiport iptable_filter ip_tables x_tables 
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative 
bonding ext2 coretemp usbhid loop ehci_pci ehci_hcd sb_edac usbcore 
i2c_i801 ipmi_si edac_core i2c_core usb_common shpchp ipmi_msghandler 
button btrfs lzo_compress raid0 raid456 async_raid6_recov async_memcpy 
async_pq async_xor async_tx xor raid6_pq raid1 md_mod sg ixgbe(O) 
i40e(O) sd_mod vxlan ip6_udp_tunnel udp_tunnel ahci ptp aacraid libahci 
pps_core
2015-07-31 20:59:43     Oops: 0000 [#2] SMP
2015-07-31 20:59:43     PGD 1a15067 PUD 1a17067 PMD 0
2015-07-31 20:59:43     IP: [<ffffffff81090d80>] kthread_data+0x10/0x20
2015-07-31 20:59:43     BUG: unable to handle kernel paging request at 
ffffffffffffffd8
2015-07-31 20:59:43     ---[ end trace f1b45f288cc28a80 ]---
2015-07-31 20:59:43     RSP <ffff880f7b6c7ab8>
2015-07-31 20:59:42     RIP [<ffffffffa02152ee>] 
insert_inline_extent_backref+0xde/0xe0 [btrfs]
2015-07-31 20:59:42     Code: 45 10 49 89 d9 48 8b 55 c8 4c 89 34 24 4c 
89 e9 4c 89 fe 4c 89 e7 48 89 44 24 10 8b 45 28 89 44 24 08 e8 a6 ee ff 
ff 31 c0 eb ae <0f> 0b 0f 1f 44 00 00 55 ba c0 00 00 00 65 48 8b 04 25 
80 a8 00
2015-07-31 20:59:42     [<ffffffff81090a30>] ? kthread_worker_fn+0x150/0x150
2015-07-31 20:59:42     [<ffffffff815f9088>] ret_from_fork+0x58/0x90
2015-07-31 20:59:42     [<ffffffff81090a30>] ? kthread_worker_fn+0x150/0x150
2015-07-31 20:59:42     [<ffffffff81090af9>] kthread+0xc9/0xe0
2015-07-31 20:59:42     [<ffffffff8108b0f0>] ? 
process_scheduled_works+0x40/0x40
2015-07-31 20:59:42     [<ffffffff8108b213>] worker_thread+0x123/0x430
2015-07-31 20:59:42     [<ffffffff8108ae53>] process_one_work+0x153/0x3b0
2015-07-31 20:59:42     [<ffffffffa0265802>] 
btrfs_extent_refs_helper+0x12/0x20 [btrfs]
2015-07-31 20:59:42     [<ffffffffa02653e9>] 
normal_work_helper+0xb9/0x2a0 [btrfs]
2015-07-31 20:59:41     [<ffffffffa0222487>] 
delayed_ref_async_start+0x37/0x90 [btrfs]
2015-07-31 20:59:41     [<ffffffffa0221f8b>] 
btrfs_run_delayed_refs+0x7b/0x2a0 [btrfs]
2015-07-31 20:59:41     [<ffffffffa0234955>] ? 
start_transaction+0x135/0x5c0 [btrfs]
2015-07-31 20:59:41     [<ffffffff8109a3cd>] ? ttwu_do_wakeup+0x1d/0xd0
2015-07-31 20:59:41     [<ffffffffa021f754>] 
__btrfs_run_delayed_refs+0xdf4/0x11b0 [btrfs]
2015-07-31 20:59:41     [<ffffffff810a8874>] ? enqueue_entity+0x384/0x990
2015-07-31 20:59:41     [<ffffffffa0215db6>] 
__btrfs_inc_extent_ref.isra.74+0xa6/0x270 [btrfs]
2015-07-31 20:59:41     [<ffffffffa020945a>] ? 
btrfs_alloc_path+0x1a/0x20 [btrfs]
2015-07-31 20:59:41     [<ffffffff81187fb2>] ? kmem_cache_alloc+0x122/0x130
2015-07-31 20:59:41     Call Trace:
2015-07-31 20:59:41     ffffea003bf76800 00000000000024cd 
ffff880d8232da98 ffff88105347d800
2015-07-31 20:59:41     0000000000000001 ffffffff81187fb2 
ffff880f7b6c7b18 ffffffffa020945a
2015-07-31 20:59:40     0000000000000000 0000000000000005 
0000000000000001 0000000000000000Stack:
2015-07-31 20:59:40     CR2: 00000000006e5dc8 CR3: 0000000001a14000 CR4: 
00000000001407e0
2015-07-31 20:59:40     CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
2015-07-31 20:59:40     FS: 0000000000000000(0000) 
GS:ffff88107fc80000(0000) knlGS:0000000000000000
2015-07-31 20:59:40     R13: 0000000000000000 R14: 0000000000000000 R15: 
ffff880f5d51af30
2015-07-31 20:59:40     R10: 0000000000000000 R11: 0000000000000002 R12: 
ffff8810539ce000
2015-07-31 20:59:40     RBP: ffff880f7b6c7b38 R08: 0000000000004000 R09: 
ffff880f7b6c7998
2015-07-31 20:59:40     RDX: 0000000000002000 RSI: 0000000000000001 RDI: 
0000000000000000
2015-07-31 20:59:40     RAX: 0000000000000000 RBX: 0000000000000001 RCX: 
0000000000000001
2015-07-31 20:59:40     RSP: 0018:ffff880f7b6c7ab8 EFLAGS: 00010293
2015-07-31 20:59:40     RIP: 0010:[<ffffffffa02152ee>] 
[<ffffffffa02152ee>] insert_inline_extent_backref+0xde/0xe0 [btrfs]
2015-07-31 20:59:40     task: ffff88104ebf1d30 ti: ffff880f7b6c4000 
task.ti: ffff880f7b6c4000
2015-07-31 20:59:39     Workqueue: btrfs-extent-refs 
btrfs_extent_refs_helper [btrfs]
2015-07-31 20:59:39     Hardware name: Supermicro X10DRH/X10DRH-IT, BIOS 
1.0c 02/18/2015
2015-07-31 20:59:39     CPU: 12 PID: 9212 Comm: kworker/u66:6 Tainted: G 
W O 4.2-rc3-ph #1
2015-07-31 20:59:39     Modules linked in: dm_mod netconsole ipt_REJECT 
nf_reject_ipv4 xt_multiport iptable_filter ip_tables x_tables 
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative 
bonding ext2 coretemp usbhid loop ehci_pci ehci_hcd sb_edac usbcore 
i2c_i801 ipmi_si edac_core i2c_core usb_common shpchp ipmi_msghandler 
button btrfs lzo_compress raid0 raid456 async_raid6_recov async_memcpy 
async_pq async_xor async_tx xor raid6_pq raid1 md_mod sg ixgbe(O) 
i40e(O) sd_mod vxlan ip6_udp_tunnel udp_tunnel ahci ptp aacraid libahci 
pps_core
2015-07-31 20:59:39     invalid opcode: 0000 [#1] SMP
2015-07-31 20:59:39     kernel BUG at fs/btrfs/extent-tree.c:1833!
2015-07-31 20:59:39     ------------[ cut here ]------------

Stefan
