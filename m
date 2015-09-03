Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:16116 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbbICGJf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Sep 2015 02:09:35 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Aborting unused transaction
Message-ID: <55E7E41C.6080601@profihost.ag>
Date: Thu, 3 Sep 2015 08:09:32 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

[447062.309251] Modules linked in: dm_mod netconsole ipt_REJECT
nf_reject_ipv4 xt_multiport iptable_filter ip_tables x_tables
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative
bonding ext2 usbhid coretemp loop ehci_pci sb_edac ehci_hcd edac_core
i2c_i801 i2c_core usbcore shpchp usb_common ipmi_si ipmi_msghandler
button btrfs lzo_compress raid0 raid456 async_raid6_recov async_memcpy
async_pq async_xor async_tx xor raid6_pq raid1 md_mod sg sd_mod aacraid
ahci i40e(O) libahci ixgbe vxlan ip6_udp_tunnel mdio udp_tunnel ptp pps_core
[447062.309276] CPU: 3 PID: 28971 Comm: kworker/u65:6 Tainted: G
W  O    4.1.6+19-ph #1
[447062.309277] Hardware name: Supermicro X10DRH/X10DRH-IT, BIOS 1.0c
02/18/2015
[447062.309291] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
[btrfs]
[447062.309292]  ffffffffc03343f3 ffff8804e083f6c8 ffffffff8d633a26
0000000000000000
[447062.309294]  ffff8804e083f718 ffff8804e083f708 ffffffff8d07dd17
ffff88010ee6a460
[447062.309296]  ffff88085baa0120 0000000000000001 ffff88017f940800
0000000000004000
[447062.309298] Call Trace:
[447062.309306]  [<ffffffff8d633a26>] dump_stack+0x45/0x57
[447062.309309]  [<ffffffff8d07dd17>] warn_slowpath_common+0x97/0xe0
[447062.309311]  [<ffffffff8d07de16>] warn_slowpath_fmt+0x46/0x50
[447062.309318]  [<ffffffffc029c611>] btrfs_alloc_tree_block+0x431/0x4c0
[btrfs]
[447062.309328]  [<ffffffffc02d37d9>] ? read_extent_buffer+0xb9/0x120
[btrfs]
[447062.309334]  [<ffffffffc02862fc>] __btrfs_cow_block+0x11c/0x540 [btrfs]
[447062.309341]  [<ffffffffc02a9c25>] ? btrfs_buffer_uptodate+0x65/0x80
[btrfs]
[447062.309347]  [<ffffffffc02868ea>] btrfs_cow_block+0x12a/0x1c0 [btrfs]
[447062.309352]  [<ffffffffc028a800>] btrfs_search_slot+0x1d0/0xa10 [btrfs]
[447062.309357]  [<ffffffffc0291032>]
lookup_inline_extent_backref+0x122/0x5e0 [btrfs]
[447062.309362]  [<ffffffffc0282e1f>] ? leaf_space_used+0xdf/0x120 [btrfs]
[447062.309368]  [<ffffffffc02940dd>] __btrfs_free_extent+0x14d/0xc00
[btrfs]
[447062.309370]  [<ffffffff8d631b13>] ? __slab_free+0x102/0x200
[447062.309375]  [<ffffffffc028eef8>] ?
block_group_cache_tree_search+0x98/0xf0 [btrfs]
[447062.309381]  [<ffffffffc029b56c>]
__btrfs_run_delayed_refs+0x74c/0x1270 [btrfs]
[447062.309390]  [<ffffffffc029e434>] btrfs_run_delayed_refs+0x74/0x280
[btrfs]
[447062.309397]  [<ffffffffc029e8e7>] delayed_ref_async_start+0x37/0x90
[btrfs]
[447062.309408]  [<ffffffffc02e0d02>] normal_work_helper+0xc2/0x2a0 [btrfs]
[447062.309419]  [<ffffffffc02e1112>] btrfs_extent_refs_helper+0x12/0x20
[btrfs]
[447062.309422]  [<ffffffff8d09563f>] process_one_work+0x14f/0x410
[447062.309423]  [<ffffffff8d095a59>] worker_thread+0x119/0x510
[447062.309425]  [<ffffffff8d6359b1>] ? __schedule+0x4f1/0x99f
[447062.309427]  [<ffffffff8d095940>] ? process_scheduled_works+0x40/0x40
[447062.309429]  [<ffffffff8d09c1a9>] kthread+0xc9/0xe0
[447062.309431]  [<ffffffff8d09c0e0>] ? kthread_create_on_node+0x1a0/0x1a0
[447062.309433]  [<ffffffff8d63a562>] ret_from_fork+0x42/0x70
[447062.309435]  [<ffffffff8d09c0e0>] ? kthread_create_on_node+0x1a0/0x1a0
[447062.309436] ---[ end trace 3ba8d8d0d3b0be64 ]---
[447290.442974] use_block_rsv: 4210 callbacks suppressed
[447290.442978] ------------[ cut here ]------------
[447290.443011] WARNING: CPU: 18 PID: 24795 at
fs/btrfs/extent-tree.c:7539 btrfs_alloc_tree_block+0x431/0x4c0 [btrfs]()
[447290.443012] BTRFS: block rsv returned -28
[447290.443013] Modules linked in: dm_mod netconsole ipt_REJECT
nf_reject_ipv4 xt_multiport iptable_filter ip_tables x_tables
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative
bonding ext2 usbhid coretemp loop ehci_pci sb_edac ehci_hcd edac_core
i2c_i801 i2c_core usbcore shpchp usb_common ipmi_si ipmi_msghandler
button btrfs lzo_compress raid0 raid456 async_raid6_recov async_memcpy
async_pq async_xor async_tx xor raid6_pq raid1 md_mod sg sd_mod aacraid
ahci i40e(O) libahci ixgbe vxlan ip6_udp_tunnel mdio udp_tunnel ptp pps_core
[447290.443039] CPU: 18 PID: 24795 Comm: backup-vm.pl Tainted: G
W  O    4.1.6+19-ph #1
[447290.443040] Hardware name: Supermicro X10DRH/X10DRH-IT, BIOS 1.0c
02/18/2015
[447290.443041]  ffffffffc03343f3 ffff88101ea87588 ffffffff8d633a26
0000000000000000
[447290.443043]  ffff88101ea875d8 ffff88101ea875c8 ffffffff8d07dd17
ffff88010a3ba140
[447290.443045]  ffff88085baa0120 0000000000000001 ffff88017f940800
0000000000004000
[447290.443047] Call Trace:
[447290.443055]  [<ffffffff8d633a26>] dump_stack+0x45/0x57
[447290.443058]  [<ffffffff8d07dd17>] warn_slowpath_common+0x97/0xe0
[447290.443060]  [<ffffffff8d07de16>] warn_slowpath_fmt+0x46/0x50
[447290.443067]  [<ffffffffc029c611>] btrfs_alloc_tree_block+0x431/0x4c0
[btrfs]
[447290.443080]  [<ffffffffc02d37d9>] ? read_extent_buffer+0xb9/0x120
[btrfs]
[447290.443085]  [<ffffffffc02862fc>] __btrfs_cow_block+0x11c/0x540 [btrfs]
[447290.443093]  [<ffffffffc02a9c25>] ? btrfs_buffer_uptodate+0x65/0x80
[btrfs]
[447290.443099]  [<ffffffffc02868ea>] btrfs_cow_block+0x12a/0x1c0 [btrfs]
[447290.443104]  [<ffffffffc028a800>] btrfs_search_slot+0x1d0/0xa10 [btrfs]
[447290.443110]  [<ffffffffc0291032>]
lookup_inline_extent_backref+0x122/0x5e0 [btrfs]
[447290.443114]  [<ffffffffc0282e1f>] ? leaf_space_used+0xdf/0x120 [btrfs]
[447290.443120]  [<ffffffffc02940dd>] __btrfs_free_extent+0x14d/0xc00
[btrfs]
[447290.443125]  [<ffffffffc028eef8>] ?
block_group_cache_tree_search+0x98/0xf0 [btrfs]
[447290.443132]  [<ffffffffc029b56c>]
__btrfs_run_delayed_refs+0x74c/0x1270 [btrfs]
[447290.443138]  [<ffffffffc029e434>] btrfs_run_delayed_refs+0x74/0x280
[btrfs]
[447290.443146]  [<ffffffffc02bac2f>]
btrfs_truncate_inode_items+0xacf/0xc90 [btrfs]
[447290.443155]  [<ffffffffc02bbf64>] btrfs_evict_inode+0x3a4/0x550 [btrfs]
[447290.443158]  [<ffffffff8d1e9cdd>] ? __inode_wait_for_writeback+0x6d/0xc0
[447290.443162]  [<ffffffff8d1dbac8>] evict+0xb8/0x190
[447290.443163]  [<ffffffff8d1dc2db>] iput+0x18b/0x1f0
[447290.443166]  [<ffffffff8d1d0dea>] do_unlinkat+0x1ca/0x2d0
[447290.443169]  [<ffffffff8d14be33>] ? context_tracking_user_exit+0x13/0x20
[447290.443172]  [<ffffffff8d012558>] ?
syscall_trace_enter_phase1+0xf8/0x160
[447290.443173]  [<ffffffff8d14be13>] ?
context_tracking_user_enter+0x13/0x20
[447290.443175]  [<ffffffff8d1d1b56>] SyS_unlink+0x16/0x20
[447290.443178]  [<ffffffff8d63a16e>] system_call_fastpath+0x12/0x71
[447290.443179] ---[ end trace 3ba8d8d0d3b0be65 ]---
[447318.342947] ------------[ cut here ]------------
[447318.342996] WARNING: CPU: 7 PID: 16929 at fs/btrfs/super.c:260
__btrfs_abort_transaction+0x5f/0x140 [btrfs]()
[447318.343005] BTRFS: Transaction aborted (error -28)
[447318.343007] Modules linked in: dm_mod netconsole ipt_REJECT
nf_reject_ipv4 xt_multiport iptable_filter ip_tables x_tables
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative
bonding ext2 usbhid coretemp loop ehci_pci sb_edac ehci_hcd edac_core
i2c_i801 i2c_core usbcore shpchp usb_common ipmi_si ipmi_msghandler
button btrfs lzo_compress raid0 raid456 async_raid6_recov async_memcpy
async_pq async_xor async_tx xor raid6_pq raid1 md_mod sg sd_mod aacraid
ahci i40e(O) libahci ixgbe vxlan ip6_udp_tunnel mdio udp_tunnel ptp pps_core
[447318.343051] CPU: 7 PID: 16929 Comm: kworker/u65:10 Tainted: G
 W  O    4.1.6+19-ph #1
[447318.343052] Hardware name: Supermicro X10DRH/X10DRH-IT, BIOS 1.0c
02/18/2015
[447318.343067] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
[btrfs]
[447318.343073]  ffffffffc0333578 ffff88058947bc18 ffffffff8d633a26
000000000000c85c
[447318.343075]  ffff88058947bc68 ffff88058947bc58 ffffffff8d07dd17
ffff88085fb56180
[447318.343077]  ffff8808491d74a0 ffff88085bffa800 00000000ffffffe4
ffffffffc032cce0
[447318.343079] Call Trace:
[447318.343086]  [<ffffffff8d633a26>] dump_stack+0x45/0x57
[447318.343093]  [<ffffffff8d07dd17>] warn_slowpath_common+0x97/0xe0
[447318.343096]  [<ffffffff8d07de16>] warn_slowpath_fmt+0x46/0x50
[447318.343101]  [<ffffffffc0280d0f>]
__btrfs_abort_transaction+0x5f/0x140 [btrfs]
[447318.343109]  [<ffffffffc029e4ec>] btrfs_run_delayed_refs+0x12c/0x280
[btrfs]
[447318.343118]  [<ffffffffc029e8e7>] delayed_ref_async_start+0x37/0x90
[btrfs]
[447318.343127]  [<ffffffffc02e0d02>] normal_work_helper+0xc2/0x2a0 [btrfs]
[447318.343138]  [<ffffffffc02e1112>] btrfs_extent_refs_helper+0x12/0x20
[btrfs]
[447318.343143]  [<ffffffff8d09563f>] process_one_work+0x14f/0x410
[447318.343147]  [<ffffffff8d095a59>] worker_thread+0x119/0x510
[447318.343149]  [<ffffffff8d6359b1>] ? __schedule+0x4f1/0x99f
[447318.343152]  [<ffffffff8d095940>] ? process_scheduled_works+0x40/0x40
[447318.343154]  [<ffffffff8d09c1a9>] kthread+0xc9/0xe0
[447318.343156]  [<ffffffff8d09c0e0>] ? kthread_create_on_node+0x1a0/0x1a0
[447318.343158]  [<ffffffff8d63a562>] ret_from_fork+0x42/0x70
[447318.343160]  [<ffffffff8d09c0e0>] ? kthread_create_on_node+0x1a0/0x1a0
[447318.343161] ---[ end trace 3ba8d8d0d3b0be66 ]---
[447318.343166] BTRFS warning (device md50):
btrfs_run_delayed_refs:2821: Aborting unused transaction(No space left).
[447318.343187] BTRFS warning (device md50):
btrfs_run_delayed_refs:2821: Aborting unused transaction(No space left).
[447318.343192] BTRFS warning (device md50):
btrfs_run_delayed_refs:2821: Aborting unused transaction(No space left).
[447318.343205] BTRFS warning (device md50):
btrfs_run_delayed_refs:2821: Aborting unused transaction(No space left).
[447318.343214] BTRFS warning (device md50):
btrfs_run_delayed_refs:2821: Aborting unused transaction(No space left).
[447318.343219] BTRFS warning (device md50):
btrfs_run_delayed_refs:2821: Aborting unused transaction(No space left).
[447318.343255] ------------[ cut here ]------------
[447318.343269] WARNING: CPU: 7 PID: 16929 at fs/btrfs/delayed-ref.c:438
btrfs_select_ref_head+0x13c/0x150 [btrfs]()
[447318.343272] Modules linked in: dm_mod netconsole ipt_REJECT
nf_reject_ipv4 xt_multiport iptable_filter ip_tables x_tables
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative
bonding ext2 usbhid coretemp loop ehci_pci sb_edac ehci_hcd edac_core
i2c_i801 i2c_core usbcore shpchp usb_common ipmi_si ipmi_msghandler
button btrfs lzo_compress raid0 raid456 async_raid6_recov async_memcpy
async_pq async_xor async_tx xor raid6_pq raid1 md_mod sg sd_mod aacraid
ahci i40e(O) libahci ixgbe vxlan ip6_udp_tunnel mdio udp_tunnel ptp pps_core
[447318.343292] CPU: 7 PID: 16929 Comm: kworker/u65:10 Tainted: G
 W  O    4.1.6+19-ph #1
[447318.343295] Hardware name: Supermicro X10DRH/X10DRH-IT, BIOS 1.0c
02/18/2015
[447318.343304] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
[btrfs]
[447318.343306]  ffffffffc03354db ffff88058947bb28 ffffffff8d633a26
0000000000000001
[447318.343309]  0000000000000000 ffff88058947bb68 ffffffff8d07dd17
ffff88058947bba8
[447318.343311]  ffff8801398a8dc0 ffff880d8a3e89d8 0000000000000001
ffff880d8a3e8b00
[447318.343314] Call Trace:
[447318.343317]  [<ffffffff8d633a26>] dump_stack+0x45/0x57
[447318.343319]  [<ffffffff8d07dd17>] warn_slowpath_common+0x97/0xe0
[447318.343320]  [<ffffffff8d07dd7a>] warn_slowpath_null+0x1a/0x20
[447318.343328]  [<ffffffffc02fd6fc>] btrfs_select_ref_head+0x13c/0x150
[btrfs]
[447318.343338]  [<ffffffffc029b057>]
__btrfs_run_delayed_refs+0x237/0x1270 [btrfs]
[447318.343342]  [<ffffffff8d037c3b>] ? native_smp_send_reschedule+0x4b/0x60
[447318.343345]  [<ffffffff8d0a5ee9>] ? resched_curr+0x59/0xb0
[447318.343351]  [<ffffffffc029e434>] btrfs_run_delayed_refs+0x74/0x280
[btrfs]
[447318.343360]  [<ffffffffc029e8e7>] delayed_ref_async_start+0x37/0x90
[btrfs]
[447318.343368]  [<ffffffffc02e0d02>] normal_work_helper+0xc2/0x2a0 [btrfs]
[447318.343376]  [<ffffffffc02e1112>] btrfs_extent_refs_helper+0x12/0x20
[btrfs]
[447318.343380]  [<ffffffff8d09563f>] process_one_work+0x14f/0x410
[447318.343381]  [<ffffffff8d095a59>] worker_thread+0x119/0x510
[447318.343383]  [<ffffffff8d6359b1>] ? __schedule+0x4f1/0x99f
[447318.343384]  [<ffffffff8d095940>] ? process_scheduled_works+0x40/0x40
[447318.343386]  [<ffffffff8d09c1a9>] kthread+0xc9/0xe0
[447318.343390]  [<ffffffff8d09c0e0>] ? kthread_create_on_node+0x1a0/0x1a0
[447318.343393]  [<ffffffff8d63a562>] ret_from_fork+0x42/0x70
[447318.343395]  [<ffffffff8d09c0e0>] ? kthread_create_on_node+0x1a0/0x1a0
[447318.343396] ---[ end trace 3ba8d8d0d3b0be67 ]---
[447318.429463] BTRFS: error (device md50) in __btrfs_free_extent:6235:
errno=-28 No space left
[447318.455066] BTRFS: error (device md50) in __btrfs_free_extent:6235:
errno=-28 No space left
[447318.455068] BTRFS info (device md50): forced readonly
[447318.455069] BTRFS: error (device md50) in
btrfs_run_delayed_refs:2821: errno=-28 No space left
[447318.633845] BTRFS: error (device md50) in
btrfs_run_delayed_refs:2821: errno=-28 No space left
[447333.284334] pending csums is 221184

Stefan
