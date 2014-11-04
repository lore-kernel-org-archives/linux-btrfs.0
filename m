Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37687 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbaKDOkG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Nov 2014 09:40:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XlfH9-0003vS-UY
	for linux-btrfs@vger.kernel.org; Tue, 04 Nov 2014 15:40:03 +0100
Received: from 5.100.185.91 ([5.100.185.91])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Nov 2014 15:40:03 +0100
Received: from btrfs by 5.100.185.91 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Nov 2014 15:40:03 +0100
To: linux-btrfs@vger.kernel.org
From: Erik Berg <btrfs@slipsprogrammoer.no>
Subject: Kernel crash during "btrfs device delete" on raid6 volume
Date: Tue, 04 Nov 2014 15:36:46 +0100
Message-ID: <m3ao9u$de7$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pulled the latest btrfs-progs from kdave (v3.17-12-gcafacda) and using 
the latest linux release candidate (3.18.0-031800rc3-generic) from 
canonical/ubuntu

btrfs fi show
Label: none  uuid: 5c5fea06-0319-4e03-a42e-004e64aeed92
	Total devices 9 FS bytes used 10.91TiB
	devid    2 size 931.48GiB used 928.02GiB path /dev/sdc1
	devid    3 size 931.48GiB used 928.02GiB path /dev/sdd1
	devid    4 size 1.82TiB used 1.67TiB path /dev/sde1
	devid    5 size 2.73TiB used 2.28TiB path /dev/sdf1
	devid    6 size 3.64TiB used 2.73TiB path /dev/sdg1
	devid    7 size 3.64TiB used 2.73TiB path /dev/sdh1
	devid    8 size 931.46GiB used 655.90GiB path /dev/sdb1
	devid    9 size 3.64TiB used 2.73TiB path /dev/sdi1
	devid   10 size 3.64TiB used 1.79TiB path /dev/sdj1

btrfs fi df
Data, RAID6: total=10.91TiB, used=10.90TiB
System, RAID6: total=96.00MiB, used=800.00KiB
Metadata, RAID6: total=13.23GiB, used=11.79GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Trying to remove device sdb1, the kernel crashes after a minute or so.

[  597.576827] ------------[ cut here ]------------
[  597.617519] kernel BUG at /home/apw/COD/linux/mm/slub.c:3334!
[  597.668145] invalid opcode: 0000 [#1] SMP
[  597.704410] Modules linked in: arc4 md4 ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 
xt_CHECKSUM iptable_mangle xt_tcpudp bridge stp llc ip6table_filter 
ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables 
gpio_ich intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp 
kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel cryptd 
serio_raw hpilo hpwdt 8250_fintek acpi_power_meter ie31200_edac lpc_ich 
edac_core ipmi_si ipmi_msghandler mac_hid lp parport nls_utf8 cifs 
fscache hid_generic usbhid hid btrfs xor raid6_pq uas usb_storage tg3 
ptp ahci psmouse libahci pps_core hpsa
[  598.268179] CPU: 1 PID: 129 Comm: kworker/u128:3 Not tainted 
3.18.0-031800rc3-generic #201411022335
[  598.349925] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 
11/09/2013
[  598.413231] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-2)
[  598.471103] task: ffff8803f16a3c00 ti: ffff880036b70000 task.ti: 
ffff880036b70000
[  598.538393] RIP: 0010:[<ffffffff811c74fd>]  [<ffffffff811c74fd>] 
kfree+0x16d/0x170
[  598.606217] RSP: 0018:ffff880036b73528  EFLAGS: 00010246
[  598.653844] RAX: 01ffff0000000000 RBX: ffff880036b735c8 RCX: 
0000000000000000
[  598.717899] RDX: ffff8803743a6010 RSI: dead000000100100 RDI: 
ffff880036b735c8
[  598.781662] RBP: ffff880036b73558 R08: 0000000000000000 R09: 
ffffea0000dadcc0
[  598.846028] R10: 0000000000000001 R11: 0000000000000010 R12: 
ffff8803f1e09800
[  598.910713] R13: ffff8803ac757d40 R14: ffffffffc04fed0c R15: 
ffff880036b735d8
[  598.975333] FS:  0000000000000000(0000) GS:ffff88040b420000(0000) 
knlGS:0000000000000000
[  599.048512] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  599.100167] CR2: 00007fa9a3854024 CR3: 0000000001c16000 CR4: 
00000000001407e0
[  599.165150] Stack:
[  599.183305]  ffff8803f1e09800 00000dad07c20000 ffff8803f1e09800 
ffff8803ac757d40
[  599.249603]  ffff8803ac757d40 ffff880036b735d8 ffff880036b73618 
ffffffffc04fed0c
[  599.316306]  ffff8803f1b86b00 ffff880374338000 00000dad07dc0000 
ffff880036b73638
[  599.383404] Call Trace:
[  599.405429]  [<ffffffffc04fed0c>] 
btrfs_lookup_csums_range+0x2ac/0x4a0 [btrfs]
[  599.470388]  [<ffffffffc05251a3>] ? 
__btrfs_add_ordered_extent+0x43/0x3c0 [btrfs]
[  599.537826]  [<ffffffffc0560047>] btrfs_reloc_clone_csums+0x77/0xe0 
[btrfs]
[  599.600291]  [<ffffffffc051435f>] run_delalloc_nocow+0x62f/0xae0 [btrfs]
[  599.660798]  [<ffffffffc051499e>] run_delalloc_range+0x18e/0x1b0 [btrfs]
[  599.720774]  [<ffffffffc052a4b4>] 
writepage_delalloc.isra.32+0xf4/0x170 [btrfs]
[  599.786169]  [<ffffffffc052cb1f>] __extent_writepage+0xcf/0x280 [btrfs]
[  599.845626]  [<ffffffff811a7e20>] ? SyS_msync+0x230/0x230
[  599.894443]  [<ffffffffc052cf8a>] 
extent_write_cache_pages.isra.25.constprop.38+0x2ba/0x420 [btrfs]
[  599.975893]  [<ffffffffc052d5fe>] extent_writepages+0x4e/0x70 [btrfs]
[  600.033786]  [<ffffffffc0511b20>] ? btrfs_submit_direct+0x1b0/0x1b0 
[btrfs]
[  600.096916]  [<ffffffffc050df08>] btrfs_writepages+0x28/0x30 [btrfs]
[  600.153782]  [<ffffffff8117ae80>] do_writepages+0x20/0x40
[  600.202558]  [<ffffffff8120e635>] __writeback_single_inode+0x45/0x1c0
[  600.260557]  [<ffffffff8121000e>] writeback_sb_inodes+0x22e/0x340
[  600.314444]  [<ffffffff812101be>] __writeback_inodes_wb+0x9e/0xd0
[  600.369057]  [<ffffffff8121047b>] wb_writeback+0x28b/0x330
[  600.418704]  [<ffffffff81201282>] ? get_nr_dirty_inodes+0x52/0x80
[  600.473413]  [<ffffffff812105bf>] wb_check_old_data_flush+0x9f/0xb0
[  600.530122]  [<ffffffff81210704>] wb_do_writeback+0x134/0x1c0
[  600.580781]  [<ffffffff8108a8af>] ? set_worker_desc+0x6f/0x80
[  600.632015]  [<ffffffff81212698>] bdi_writeback_workfn+0x78/0x1f0
[  600.686073]  [<ffffffff810874fe>] process_one_work+0x14e/0x460
[  600.738144]  [<ffffffff81087e7b>] worker_thread+0x11b/0x3f0
[  600.787525]  [<ffffffff81087d60>] ? create_worker+0x1e0/0x1e0
[  600.838305]  [<ffffffff8108d9f9>] kthread+0xc9/0xe0
[  600.882010]  [<ffffffff8108d930>] ? flush_kthread_worker+0x90/0x90
[  600.936705]  [<ffffffff817a8f3c>] ret_from_fork+0x7c/0xb0
[  600.984246]  [<ffffffff8108d930>] ? flush_kthread_worker+0x90/0x90
[  601.038920] Code: 31 f6 f6 c4 40 74 04 41 8b 71 68 4c 89 cf e8 2b ee 
fa ff e9 6a ff ff ff 49 8b 41 30 49 8b 11 80 e6 80 4c 0f 45 c8 e9 09 ff 
ff ff <0f> 0b 90 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 49 89 f6 41 55
[  601.211081] RIP  [<ffffffff811c74fd>] kfree+0x16d/0x170
[  601.258198]  RSP <ffff880036b73528>
[  601.292012] ---[ end trace 4760080785caca88 ]---
[  601.340046] BUG: unable to handle kernel paging request at 
ffffffffffffffd8
[  601.402579] IP: [<ffffffff8108dd90>] kthread_data+0x10/0x20
[  601.452802] PGD 1c19067 PUD 1c1b067 PMD 0
[  601.489933] Oops: 0000 [#2] SMP
[  601.518941] Modules linked in: arc4 md4 ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 
xt_CHECKSUM iptable_mangle xt_tcpudp bridge stp llc ip6table_filter 
ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables 
gpio_ich intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp 
kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel cryptd 
serio_raw hpilo hpwdt 8250_fintek acpi_power_meter ie31200_edac lpc_ich 
edac_core ipmi_si ipmi_msghandler mac_hid lp parport nls_utf8 cifs 
fscache hid_generic usbhid hid btrfs xor raid6_pq uas usb_storage tg3 
ptp ahci psmouse libahci pps_core hpsa
[  602.085373] CPU: 0 PID: 129 Comm: kworker/u128:3 Tainted: G      D 
      3.18.0-031800rc3-generic #201411022335
[  602.176706] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 
11/09/2013
[  602.240091] task: ffff8803f16a3c00 ti: ffff880036b70000 task.ti: 
ffff880036b70000
[  602.307799] RIP: 0010:[<ffffffff8108dd90>]  [<ffffffff8108dd90>] 
kthread_data+0x10/0x20
[  602.379755] RSP: 0018:ffff880036b731c8  EFLAGS: 00010096
[  602.428065] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
ffffffff81ec3d40
[  602.492644] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 
ffff8803f16a3c00
[  602.557055] RBP: ffff880036b731c8 R08: 0000000000000000 R09: 
0000000000000000
[  602.621551] R10: 0000000000000000 R11: 0000000000000013 R12: 
0000000000000000
[  602.685388] R13: ffff8803f16a4138 R14: 0000000000000001 R15: 
0000000000000006
[  602.749810] FS:  0000000000000000(0000) GS:ffff88040b400000(0000) 
knlGS:0000000000000000
[  602.822794] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  602.874743] CR2: 0000000000000028 CR3: 00000000365e9000 CR4: 
00000000001407f0
[  602.938478] Stack:
[  602.956406]  ffff880036b731e8 ffffffff81088dc5 ffff880036b731e8 
ffff88040b414640
[  603.023393]  ffff880036b73268 ffffffff817a4b73 ffff880036b73228 
ffff8803f17ce3a8
[  603.089287]  ffff880036b73fd8 0000000000014640 ffff880036b73248 
0000000000014640
[  603.156124] Call Trace:
[  603.178182]  [<ffffffff81088dc5>] wq_worker_sleeping+0x15/0xb0
[  603.231061]  [<ffffffff817a4b73>] __schedule+0x5f3/0x780
[  603.278841]  [<ffffffff817a4dd9>] schedule+0x29/0x70
[  603.324031]  [<ffffffff81071945>] do_exit+0x2a5/0x470
[  603.369604]  [<ffffffff810c4ebc>] ? kmsg_dump+0x9c/0xc0
[  603.415525]  [<ffffffff81017dc8>] oops_end+0xb8/0x160
[  603.461093]  [<ffffffff810180c8>] die+0x58/0x90
[  603.502306]  [<ffffffff8101445d>] do_trap+0xcd/0x160
[  603.546936]  [<ffffffff81014936>] do_error_trap+0xe6/0x170
[  603.596527]  [<ffffffff811c74fd>] ? kfree+0x16d/0x170
[  603.643039]  [<ffffffffc05380d0>] ? btrfs_num_copies+0xb0/0x160 [btrfs]
[  603.702386]  [<ffffffffc052dc06>] ? release_extent_buffer+0x36/0xe0 
[btrfs]
[  603.764396]  [<ffffffffc052dce2>] ? 
free_extent_buffer.part.37+0x32/0x90 [btrfs]
[  603.830710]  [<ffffffffc052e165>] ? free_extent_buffer+0x35/0x40 [btrfs]
[  603.889622]  [<ffffffffc04fed0c>] ? 
btrfs_lookup_csums_range+0x2ac/0x4a0 [btrfs]
[  603.956709]  [<ffffffff81015210>] do_invalid_op+0x20/0x30
[  604.005227]  [<ffffffff817aaa5e>] invalid_op+0x1e/0x30
[  604.052681]  [<ffffffffc04fed0c>] ? 
btrfs_lookup_csums_range+0x2ac/0x4a0 [btrfs]
[  604.118969]  [<ffffffff811c74fd>] ? kfree+0x16d/0x170
[  604.164042]  [<ffffffffc04fed0c>] 
btrfs_lookup_csums_range+0x2ac/0x4a0 [btrfs]
[  604.229643]  [<ffffffffc05251a3>] ? 
__btrfs_add_ordered_extent+0x43/0x3c0 [btrfs]
[  604.297028]  [<ffffffffc0560047>] btrfs_reloc_clone_csums+0x77/0xe0 
[btrfs]
[  604.360017]  [<ffffffffc051435f>] run_delalloc_nocow+0x62f/0xae0 [btrfs]
[  604.420316]  [<ffffffffc051499e>] run_delalloc_range+0x18e/0x1b0 [btrfs]
[  604.481403]  [<ffffffffc052a4b4>] 
writepage_delalloc.isra.32+0xf4/0x170 [btrfs]
[  604.547266]  [<ffffffffc052cb1f>] __extent_writepage+0xcf/0x280 [btrfs]
[  604.606342]  [<ffffffff811a7e20>] ? SyS_msync+0x230/0x230
[  604.655704]  [<ffffffffc052cf8a>] 
extent_write_cache_pages.isra.25.constprop.38+0x2ba/0x420 [btrfs]
[  604.736965]  [<ffffffffc052d5fe>] extent_writepages+0x4e/0x70 [btrfs]
[  604.794404]  [<ffffffffc0511b20>] ? btrfs_submit_direct+0x1b0/0x1b0 
[btrfs]
[  604.856681]  [<ffffffffc050df08>] btrfs_writepages+0x28/0x30 [btrfs]
[  604.913692]  [<ffffffff8117ae80>] do_writepages+0x20/0x40
[  604.962262]  [<ffffffff8120e635>] __writeback_single_inode+0x45/0x1c0
[  605.019870]  [<ffffffff8121000e>] writeback_sb_inodes+0x22e/0x340
[  605.074173]  [<ffffffff812101be>] __writeback_inodes_wb+0x9e/0xd0
[  605.128939]  [<ffffffff8121047b>] wb_writeback+0x28b/0x330
[  605.178060]  [<ffffffff81201282>] ? get_nr_dirty_inodes+0x52/0x80
[  605.232308]  [<ffffffff812105bf>] wb_check_old_data_flush+0x9f/0xb0
[  605.288400]  [<ffffffff81210704>] wb_do_writeback+0x134/0x1c0
[  605.339998]  [<ffffffff8108a8af>] ? set_worker_desc+0x6f/0x80
[  605.391472]  [<ffffffff81212698>] bdi_writeback_workfn+0x78/0x1f0
[  605.446241]  [<ffffffff810874fe>] process_one_work+0x14e/0x460
[  605.498863]  [<ffffffff81087e7b>] worker_thread+0x11b/0x3f0
[  605.549473]  [<ffffffff81087d60>] ? create_worker+0x1e0/0x1e0
[  605.601439]  [<ffffffff8108d9f9>] kthread+0xc9/0xe0
[  605.646272]  [<ffffffff8108d930>] ? flush_kthread_worker+0x90/0x90
[  605.701779]  [<ffffffff817a8f3c>] ret_from_fork+0x7c/0xb0
[  605.750846]  [<ffffffff8108d930>] ? flush_kthread_worker+0x90/0x90
[  605.804813] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 
66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 c8 04 00 00 55 48 
89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
[  605.979337] RIP  [<ffffffff8108dd90>] kthread_data+0x10/0x20
[  606.030495]  RSP <ffff880036b731c8>
[  606.061854] CR2: ffffffffffffffd8
[  606.091158] ---[ end trace 4760080785caca89 ]---
[  606.138417] Fixing recursive fault but reboot is needed!
[  628.041189] ------------[ cut here ]------------
[  628.082909] WARNING: CPU: 0 PID: 129 at 
/home/apw/COD/linux/kernel/watchdog.c:290 
watchdog_overflow_callback+0x98/0xc0()
[  628.182195] Watchdog detected hard LOCKUP on cpu 0
[  628.224240] Modules linked in: arc4 md4 ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 
xt_CHECKSUM iptable_mangle xt_tcpudp bridge stp llc ip6table_filter 
ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables 
gpio_ich intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp 
kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel cryptd 
serio_raw hpilo hpwdt 8250_fintek acpi_power_meter ie31200_edac lpc_ich 
edac_core ipmi_si ipmi_msghandler mac_hid lp parport nls_utf8 cifs 
fscache hid_generic usbhid hid btrfs xor raid6_pq uas usb_storage tg3 
ptp ahci psmouse libahci pps_core hpsa
[  628.800634] CPU: 0 PID: 129 Comm: kworker/u128:3 Tainted: G      D 
      3.18.0-031800rc3-generic #201411022335
[  628.892387] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 
11/09/2013
[  628.956324]  0000000000000122 ffff88040b407ba8 ffffffff8179b798 
0000000000000007
[  629.023414]  ffff88040b407bf8 ffff88040b407be8 ffffffff8106eafc 
0000000000000000
[  629.090426]  ffff8803f516c000 0000000000000000 ffff88040b407d18 
0000000000000000
[  629.158724] Call Trace:
[  629.188779]  <NMI>  [<ffffffff8179b798>] dump_stack+0x46/0x58
[  629.241611]  [<ffffffff8106eafc>] warn_slowpath_common+0x8c/0xc0
[  629.295718]  [<ffffffff8106ebe6>] warn_slowpath_fmt+0x46/0x50
[  629.348518]  [<ffffffff81124188>] watchdog_overflow_callback+0x98/0xc0
[  629.408366]  [<ffffffff81165008>] __perf_event_overflow+0x98/0x230
[  629.464570]  [<ffffffff8102c11a>] ? x86_perf_event_set_period+0xda/0x150
[  629.525925]  [<ffffffff811658c4>] perf_event_overflow+0x14/0x20
[  629.580555]  [<ffffffff81033a99>] intel_pmu_handle_irq+0x1d9/0x2c0
[  629.637039]  [<ffffffff8102b464>] perf_event_nmi_handler+0x34/0x60
[  629.693305]  [<ffffffff8101820a>] nmi_handle+0x8a/0x140
[  629.742009]  [<ffffffff81046a20>] ? 
default_send_IPI_mask_allbutself_phys+0x100/0x100
[  629.815252]  [<ffffffff8101896e>] default_do_nmi+0xfe/0x160
[  629.866694]  [<ffffffff81018a60>] do_nmi+0x90/0xd0
[  629.909845]  [<ffffffff817ab3b1>] end_repeat_nmi+0x1e/0x2e
[  629.958832]  [<ffffffff817a8ada>] ? _raw_spin_lock_irq+0x3a/0x60
[  630.013637]  [<ffffffff817a8ada>] ? _raw_spin_lock_irq+0x3a/0x60
[  630.066976]  [<ffffffff817a8ada>] ? _raw_spin_lock_irq+0x3a/0x60
[  630.121565]  <<EOE>>  [<ffffffff817a4625>] __schedule+0xa5/0x780
[  630.176775]  [<ffffffff817a4dd9>] schedule+0x29/0x70
[  630.221368]  [<ffffffff81071aab>] do_exit+0x40b/0x470
[  630.267338]  [<ffffffff81017dc8>] oops_end+0xb8/0x160
[  630.313330]  [<ffffffff8178d4de>] no_context+0x1b5/0x1c4
[  630.360564]  [<ffffffff8178d6c0>] __bad_area_nosemaphore+0x1d3/0x1f2
[  630.418565]  [<ffffffff8178d6f2>] bad_area_nosemaphore+0x13/0x15
[  630.473877]  [<ffffffff8105c372>] __do_page_fault+0x3b2/0x550
[  630.526491]  [<ffffffff810d0d8d>] ? call_rcu_sched+0x1d/0x20
[  630.578309]  [<ffffffff81248b8c>] ? proc_destroy_inode+0x1c/0x20
[  630.633517]  [<ffffffff810a4e61>] ? update_curr+0x141/0x1f0
[  630.684709]  [<ffffffff8105c69e>] do_page_fault+0x3e/0x80
[  630.734007]  [<ffffffff817ab048>] page_fault+0x28/0x30
[  630.781044]  [<ffffffff8108dd90>] ? kthread_data+0x10/0x20
[  630.831439]  [<ffffffff81088dc5>] wq_worker_sleeping+0x15/0xb0
[  630.884290]  [<ffffffff817a4b73>] __schedule+0x5f3/0x780
[  630.931040]  [<ffffffff817a4dd9>] schedule+0x29/0x70
[  630.975132]  [<ffffffff81071945>] do_exit+0x2a5/0x470
[  631.020738]  [<ffffffff810c4ebc>] ? kmsg_dump+0x9c/0xc0
[  631.069118]  [<ffffffff81017dc8>] oops_end+0xb8/0x160
[  631.117791]  [<ffffffff810180c8>] die+0x58/0x90
[  631.157776]  [<ffffffff8101445d>] do_trap+0xcd/0x160
[  631.201786]  [<ffffffff81014936>] do_error_trap+0xe6/0x170
[  631.250238]  [<ffffffff811c74fd>] ? kfree+0x16d/0x170
[  631.294923]  [<ffffffffc05380d0>] ? btrfs_num_copies+0xb0/0x160 [btrfs]
[  631.353303]  [<ffffffffc052dc06>] ? release_extent_buffer+0x36/0xe0 
[btrfs]
[  631.414831]  [<ffffffffc052dce2>] ? 
free_extent_buffer.part.37+0x32/0x90 [btrfs]
[  631.479502]  [<ffffffffc052e165>] ? free_extent_buffer+0x35/0x40 [btrfs]
[  631.538774]  [<ffffffffc04fed0c>] ? 
btrfs_lookup_csums_range+0x2ac/0x4a0 [btrfs]
[  631.605298]  [<ffffffff81015210>] do_invalid_op+0x20/0x30
[  631.654156]  [<ffffffff817aaa5e>] invalid_op+0x1e/0x30
[  631.701640]  [<ffffffffc04fed0c>] ? 
btrfs_lookup_csums_range+0x2ac/0x4a0 [btrfs]
[  631.769148]  [<ffffffff811c74fd>] ? kfree+0x16d/0x170
[  631.814158]  [<ffffffffc04fed0c>] 
btrfs_lookup_csums_range+0x2ac/0x4a0 [btrfs]
[  631.878501]  [<ffffffffc05251a3>] ? 
__btrfs_add_ordered_extent+0x43/0x3c0 [btrfs]
[  631.944855]  [<ffffffffc0560047>] btrfs_reloc_clone_csums+0x77/0xe0 
[btrfs]
[  632.006112]  [<ffffffffc051435f>] run_delalloc_nocow+0x62f/0xae0 [btrfs]
[  632.066120]  [<ffffffffc051499e>] run_delalloc_range+0x18e/0x1b0 [btrfs]
[  632.125507]  [<ffffffffc052a4b4>] 
writepage_delalloc.isra.32+0xf4/0x170 [btrfs]
[  632.191089]  [<ffffffffc052cb1f>] __extent_writepage+0xcf/0x280 [btrfs]
[  632.249324]  [<ffffffff811a7e20>] ? SyS_msync+0x230/0x230
[  632.298562]  [<ffffffffc052cf8a>] 
extent_write_cache_pages.isra.25.constprop.38+0x2ba/0x420 [btrfs]
[  632.382554]  [<ffffffffc052d5fe>] extent_writepages+0x4e/0x70 [btrfs]
[  632.440722]  [<ffffffffc0511b20>] ? btrfs_submit_direct+0x1b0/0x1b0 
[btrfs]
[  632.503587]  [<ffffffffc050df08>] btrfs_writepages+0x28/0x30 [btrfs]
[  632.561458]  [<ffffffff8117ae80>] do_writepages+0x20/0x40
[  632.610972]  [<ffffffff8120e635>] __writeback_single_inode+0x45/0x1c0
[  632.670403]  [<ffffffff8121000e>] writeback_sb_inodes+0x22e/0x340
[  632.727108]  [<ffffffff812101be>] __writeback_inodes_wb+0x9e/0xd0
[  632.782298]  [<ffffffff8121047b>] wb_writeback+0x28b/0x330
[  632.832142]  [<ffffffff81201282>] ? get_nr_dirty_inodes+0x52/0x80
[  632.887494]  [<ffffffff812105bf>] wb_check_old_data_flush+0x9f/0xb0
[  632.944732]  [<ffffffff81210704>] wb_do_writeback+0x134/0x1c0
[  632.997801]  [<ffffffff8108a8af>] ? set_worker_desc+0x6f/0x80
[  633.051181]  [<ffffffff81212698>] bdi_writeback_workfn+0x78/0x1f0
[  633.107282]  [<ffffffff810874fe>] process_one_work+0x14e/0x460
[  633.162037]  [<ffffffff81087e7b>] worker_thread+0x11b/0x3f0
[  633.213238]  [<ffffffff81087d60>] ? create_worker+0x1e0/0x1e0
[  633.267016]  [<ffffffff8108d9f9>] kthread+0xc9/0xe0
[  633.311850]  [<ffffffff8108d930>] ? flush_kthread_worker+0x90/0x90
[  633.368591]  [<ffffffff817a8f3c>] ret_from_fork+0x7c/0xb0
[  633.417460]  [<ffffffff8108d930>] ? flush_kthread_worker+0x90/0x90
[  633.474349] ---[ end trace 4760080785caca8a ]---

I'm aware raid5/6 isn't even considered close production ready, so I'm 
not sure if this is all interesting for anyone to look at yet, but if is 
please let me know what else of information I can provide.

--
erikberg

