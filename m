Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55210 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbaKLU5t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 15:57:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xoez6-00031e-2r
	for linux-btrfs@vger.kernel.org; Wed, 12 Nov 2014 21:57:48 +0100
Received: from 5.100.184.48 ([5.100.184.48])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 21:57:48 +0100
Received: from btrfs by 5.100.184.48 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 21:57:48 +0100
To: linux-btrfs@vger.kernel.org
From: Erik Berg <btrfs@slipsprogrammoer.no>
Subject: Kernel crash during "btrfs fi balance start" on raid6 btrfs
Date: Wed, 12 Nov 2014 21:57:31 +0100
Message-ID: <m40hju$p5o$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pulled the latest btrfs-progs from kdave v3.17.1 and using the latest 
linux release candidate (3.18.0-031800rc4-generic) from canonical/ubuntu

btrfs fi show
Label: 'houseofcards'  uuid: 5c5fea06-0319-4e03-a42e-004e64aeed92
         Total devices 9 FS bytes used 10.91TiB
         devid    2 size 931.48GiB used 931.46GiB path /dev/sdd1
         devid    3 size 931.48GiB used 931.46GiB path /dev/sde1
         devid    4 size 1.82TiB used 1.82TiB path /dev/sdf1
         devid    5 size 2.73TiB used 2.44TiB path /dev/sdg1
         devid    6 size 3.64TiB used 2.44TiB path /dev/sdh1
         devid    7 size 3.64TiB used 2.44TiB path /dev/sdi1
         devid    8 size 931.46GiB used 931.44GiB path /dev/sdc1
         devid    9 size 3.64TiB used 2.44TiB path /dev/sdj1
         devid   10 size 3.64TiB used 1.49TiB path /dev/sdk1

erikberg@betsy:~$ sudo btrfs fi df
Data, RAID6: total=10.91TiB, used=10.90TiB
System, RAID6: total=112.00MiB, used=768.00KiB
Metadata, RAID6: total=13.31GiB, used=11.78GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

During the balance I see this line repeating a thousand times over
Nov 12 10:47:57 betsy kernel: [73073.321169] BTRFS (device sdj1): parent 
transid verify failed on 12547203039232 wanted 39375 found 39354

Hopefully this trace is also of some use.

[106115.988735] ------------[ cut here ]------------
[106116.033547] kernel BUG at 
/home/apw/COD/linux/fs/btrfs/extent-tree.c:5044!
[106116.100302] invalid opcode: 0000 [#1] SMP
[106116.139438] Modules linked in: arc4 md4 ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_
ipv4 xt_CHECKSUM iptable_mangle xt_tcpudp bridge stp llc ip6table_filter 
ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables 
intel_rapl x86_pkg_temp_thermal intel_powerclamp gpio_
ich coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul 
ghash_clmulni_intel cryptd serio_raw hpilo hpwdt lpc_ich 8250_fintek 
acpi_power_meter ipmi_si mac_hid ipmi_msghandler ie31200_edac edac_
core lp parport nls_utf8 cifs fscache btrfs xor raid6_pq hid_generic uas 
ahci usbhid tg3 psmouse ptp hid usb_storage libahci pps_core hpsa
[106116.721200] CPU: 0 PID: 6631 Comm: kworker/u128:0 Tainted: G 
W      3.18.0-031800rc4-generic #201411091835
[106116.817402] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 
11/09/2013
[106116.885106] Workqueue: btrfs-endio-write btrfs_endio_write_helper 
[btrfs]
[106116.950324] task: ffff8803f3186e00 ti: ffff8800b6b70000 task.ti: 
ffff8800b6b70000
[106117.021691] RIP: 0010:[<ffffffffc02ea7ca>]  [<ffffffffc02ea7ca>] 
drop_outstanding_extent+0x4a/0x50 [btrfs]
[106117.112562] RSP: 0018:ffff8800b6b73c78  EFLAGS: 00010246
[106117.162090] RAX: 00000000935e935e RBX: ffff8803c2253468 RCX: 
00000001bc6c928e
[106117.228658] RDX: 0000000000000000 RSI: 00000000003f8fff RDI: 
ffff8803c2253468
[106117.295827] RBP: ffff8800b6b73c78 R08: ffffea0003b55480 R09: 
ffffffffc032732a
[106117.362687] R10: 0000000000000001 R11: 0000000000000010 R12: 
ffff8803c22532e4
[106117.430173] R13: 0000000000000000 R14: ffff8803dba11000 R15: 
0000000000000000
[106117.496032] FS:  0000000000000000(0000) GS:ffff88040b400000(0000) 
knlGS:0000000000000000
[106117.570809] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[106117.625853] CR2: 00007fe11f1b8b38 CR3: 0000000001c16000 CR4: 
00000000001407f0
[106117.692769] Stack:
[106117.712256]  ffff8800b6b73cd8 ffffffffc02f4631 ffff88019964a780 
ffff8800280abc90
[106117.783215]  00000000003f8000 ffff8803c2253468 ffff8803dba11000 
ffff8800280abc90
[106117.853885]  ffff880033d80b40 ffff8803c2253468 ffff8803dba11000 
0000000000000000
[106117.925941] Call Trace:
[106117.949778]  [<ffffffffc02f4631>] 
btrfs_delalloc_release_metadata+0x51/0x190 [btrfs]
[106118.023943]  [<ffffffffc0314e54>] 
btrfs_finish_ordered_io+0x144/0x560 [btrfs]
[106118.090748]  [<ffffffff8109821c>] ? ttwu_do_wakeup+0x2c/0x100
[106118.146218]  [<ffffffffc0315285>] finish_ordered_fn+0x15/0x20 [btrfs]
[106118.207552]  [<ffffffffc033b50e>] normal_work_helper+0x7e/0x1b0 [btrfs]
[106118.270647]  [<ffffffffc033b7d2>] btrfs_endio_write_helper+0x12/0x20 
[btrfs]
[106118.337606]  [<ffffffff810874fe>] process_one_work+0x14e/0x460
[106118.393373]  [<ffffffff81087e7b>] worker_thread+0x11b/0x3f0
[106118.447102]  [<ffffffff81087d60>] ? create_worker+0x1e0/0x1e0
[106118.502168]  [<ffffffff8108d9f9>] kthread+0xc9/0xe0
[106118.547217]  [<ffffffff8108d930>] ? flush_kthread_worker+0x90/0x90
[106118.605013]  [<ffffffff817ac7fc>] ret_from_fork+0x7c/0xb0
[106118.657590]  [<ffffffff8108d930>] ? flush_kthread_worker+0x90/0x90
[106118.716661] Code: 77 80 04 72 1c 8b 57 ec 31 c0 8b 4f f0 39 d1 76 07 
01 c8 89 57 f0 29 d0 5d c3 0f 1f 80 00 00 00 00 8b 57 ec b8 01 00 00 00 
eb df <0f> 0b 0f 1f 40 00 0f 1f 44 00 00 55 41 b
[106118.894665] RIP  [<ffffffffc02ea7ca>] 
drop_outstanding_extent+0x4a/0x50 [btrfs]
[106118.962996]  RSP <ffff8800b6b73c78>
[106118.996886] ---[ end trace 347e89907c3322bf ]---

[106119.054995] ERST: [Firmware Warn]: Firmware does not respond in time.
[106119.136991] BUG: unable to handle kernel paging request at 
ffffffffffffffd8
[106119.203794] IP: [<ffffffff8108dd90>] kthread_data+0x10/0x20
[106119.257072] PGD 1c19067 PUD 1c1b067 PMD 0
[106119.296452] Oops: 0000 [#2] SMP
[106119.327010] Modules linked in: arc4 md4 ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_
[106119.912155] CPU: 0 PID: 6631 Comm: kworker/u128:0 Tainted: G      D 
W      3.18.0-031800rc4-generic #201411091835
[106120.008227] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 
11/09/2013
[106120.074715] task: ffff8803f3186e00 ti: ffff8800b6b70000 task.ti: 
ffff8800b6b70000
[106120.145146] RIP: 0010:[<ffffffff8108dd90>]  [<ffffffff8108dd90>] 
kthread_data+0x10/0x20
[106120.221656] RSP: 0018:ffff8800b6b73918  EFLAGS: 00010096
[106120.271431] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
ffffffff81ec3d40
[106120.338069] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
ffff8803f3186e00
[106120.405165] RBP: ffff8800b6b73918 R08: 0000000000000000 R09: 
0000000000000000
[106120.472527] R10: 0000000000000000 R11: 0000000000000013 R12: 
0000000000000000
[106120.538442] R13: ffff8803f3187338 R14: 0000000000000001 R15: 
0000000000000006
[106120.604344] FS:  0000000000000000(0000) GS:ffff88040b400000(0000) 
knlGS:0000000000000000
[106120.680009] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[106120.734278] CR2: 0000000000000028 CR3: 0000000001c16000 CR4: 
00000000001407f0
[106120.803878] Stack:
[106120.823672]  ffff8800b6b73938 ffffffff81088dc5 ffff8800b6b73938 
ffff88040b414640
[106120.894059]  ffff8800b6b739b8 ffffffff817a8433 ffff8800b6b73978 
ffff8803efdddd00
[106120.964289]  ffff8800b6b73fd8 0000000000014640 ffff8800b6b73998 
0000000000014640
[106121.034619] Call Trace:
[106121.058426]  [<ffffffff81088dc5>] wq_worker_sleeping+0x15/0xb0
[106121.113451]  [<ffffffff817a8433>] __schedule+0x5f3/0x780
[106121.163777]  [<ffffffff817a8699>] schedule+0x29/0x70
[106121.212578]  [<ffffffff81071945>] do_exit+0x2a5/0x470
[106121.262102]  [<ffffffff810c4ebc>] ? kmsg_dump+0x9c/0xc0
[106121.311501]  [<ffffffff81017dc8>] oops_end+0xb8/0x160
[106121.359317]  [<ffffffff810180c8>] die+0x58/0x90
[106121.403278]  [<ffffffff8101445d>] do_trap+0xcd/0x160
[106121.450806]  [<ffffffff81014936>] do_error_trap+0xe6/0x170
[106121.504950]  [<ffffffffc02ea7ca>] ? 
drop_outstanding_extent+0x4a/0x50 [btrfs]
[106121.569253]  [<ffffffffc02e6467>] ? btrfs_search_slot+0x757/0x860 
[btrfs]
[106121.633379]  [<ffffffff81015210>] do_invalid_op+0x20/0x30
[106121.684604]  [<ffffffff817ae31e>] invalid_op+0x1e/0x30
[106121.733747]  [<ffffffffc032732a>] ? free_extent_state+0x6a/0xd0 [btrfs]
[106121.797271]  [<ffffffffc02ea7ca>] ? 
drop_outstanding_extent+0x4a/0x50 [btrfs]
[106121.864837]  [<ffffffffc02f4631>] 
btrfs_delalloc_release_metadata+0x51/0x190 [btrfs]
[106121.938726]  [<ffffffffc0314e54>] 
btrfs_finish_ordered_io+0x144/0x560 [btrfs]
[106122.006580]  [<ffffffff8109821c>] ? ttwu_do_wakeup+0x2c/0x100
[106122.061392]  [<ffffffffc0315285>] finish_ordered_fn+0x15/0x20 [btrfs]
[106122.123338]  [<ffffffffc033b50e>] normal_work_helper+0x7e/0x1b0 [btrfs]
[106122.186112]  [<ffffffffc033b7d2>] btrfs_endio_write_helper+0x12/0x20 
[btrfs]
[106122.252618]  [<ffffffff810874fe>] process_one_work+0x14e/0x460
[106122.308094]  [<ffffffff81087e7b>] worker_thread+0x11b/0x3f0
[106122.360756]  [<ffffffff81087d60>] ? create_worker+0x1e0/0x1e0
[106122.417132]  [<ffffffff8108d9f9>] kthread+0xc9/0xe0
[106122.463734]  [<ffffffff8108d930>] ? flush_kthread_worker+0x90/0x90
[106122.522116]  [<ffffffff817ac7fc>] ret_from_fork+0x7c/0xb0
[106122.571060]  [<ffffffff8108d930>] ? flush_kthread_worker+0x90/0x90
[106122.629259] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 
66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 c8 04 00 00 55 48 
89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 0
[106122.810723] RIP  [<ffffffff8108dd90>] kthread_data+0x10/0x20
[106122.864731]  RSP <ffff8800b6b73918>
[106122.898314] CR2: ffffffffffffffd8
[106122.929810] ---[ end trace 347e89907c3322c0 ]---
[106123.001242] Fixing recursive fault but reboot is needed!

[106130.888883] ------------[ cut here ]------------
[106130.932807] WARNING: CPU: 1 PID: 6646 at 
/home/apw/COD/linux/kernel/watchdog.c:290 
watchdog_overflow_callback+0x98/0xc0()
[106131.036732] Watchdog detected hard LOCKUP on cpu 1
[106131.081991] Modules linked in: arc4 md4 ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_
[106131.668801] CPU: 1 PID: 6646 Comm: kworker/u128:6 Tainted: G      D 
W      3.18.0-031800rc4-generic #201411091835
[106131.764846] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 
11/09/2013
[106131.831427] Workqueue: btrfs-endio-write btrfs_endio_write_helper 
[btrfs]
[106131.894777]  0000000000000122 ffff88040b427ba8 ffffffff8179f058 
0000000000001f14
[106131.965029]  ffff88040b427bf8 ffff88040b427be8 ffffffff8106eafc 
0000000000000000
[106132.034982]  ffff8803f4c78000 0000000000000000 ffff88040b427d18 
0000000000000000
[106132.104772] Call Trace:
[106132.128184]  <NMI>  [<ffffffff8179f058>] dump_stack+0x46/0x58
[106132.183209]  [<ffffffff8106eafc>] warn_slowpath_common+0x8c/0xc0
[106132.239979]  [<ffffffff8106ebe6>] warn_slowpath_fmt+0x46/0x50
[106132.293919]  [<ffffffff81124188>] watchdog_overflow_callback+0x98/0xc0
[106132.355229]  [<ffffffff811687b8>] __perf_event_overflow+0x98/0x230
[106132.413873]  [<ffffffff8102c11a>] ? x86_perf_event_set_period+0xda/0x150
[106132.477089]  [<ffffffff81169074>] perf_event_overflow+0x14/0x20
[106132.532362]  [<ffffffff81033a99>] intel_pmu_handle_irq+0x1d9/0x2c0
[106132.591002]  [<ffffffff8102b464>] perf_event_nmi_handler+0x34/0x60
[106132.646330]  [<ffffffff8101820a>] nmi_handle+0x8a/0x140
[106132.696107]  [<ffffffff81046a20>] ? 
default_send_IPI_mask_allbutself_phys+0x100/0x100
[106132.769727]  [<ffffffff810188c6>] default_do_nmi+0x56/0x160
[106132.822927]  [<ffffffff81018a60>] do_nmi+0x90/0xd0
[106132.868797]  [<ffffffff817aec71>] end_repeat_nmi+0x1e/0x2e
[106132.921331]  [<ffffffff817ac347>] ? _raw_spin_lock+0x37/0x50
[106132.975427]  [<ffffffff817ac347>] ? _raw_spin_lock+0x37/0x50
[106133.029738]  [<ffffffff817ac347>] ? _raw_spin_lock+0x37/0x50
[106133.082850]  <<EOE>>  <IRQ>  [<ffffffff810ab5f3>] 
do_sched_rt_period_timer.isra.40+0xc3/0x290
[106133.163635]  [<ffffffff810d7689>] ? update_process_times+0x69/0x80
[106133.221950]  [<ffffffff810ab7ea>] sched_rt_period_timer+0x2a/0x60
[106133.280028]  [<ffffffff810d8126>] __run_hrtimer+0x76/0x230
[106133.331381]  [<ffffffff810ab7c0>] ? 
do_sched_rt_period_timer.isra.40+0x290/0x290
[106133.408374]  [<ffffffff810d892f>] hrtimer_interrupt+0xff/0x260
[106133.464004]  [<ffffffff81044d5b>] local_apic_timer_interrupt+0x3b/0x60
[106133.526041]  [<ffffffff817af785>] smp_apic_timer_interrupt+0x45/0x60
[106133.586667]  [<ffffffff817ad85d>] apic_timer_interrupt+0x6d/0x80
[106133.641065]  <EOI>  [<ffffffff817ac347>] ? _raw_spin_lock+0x37/0x50
[106133.700305]  [<ffffffff811ccaf5>] ? kmem_cache_alloc+0x35/0x1f0
[106133.755830]  [<ffffffffc030faf5>] btrfs_clear_bit_hook+0x45/0x2a0 
[btrfs]
[106133.820336]  [<ffffffffc0327b94>] clear_state_bit+0x64/0x170 [btrfs]
[106133.880510]  [<ffffffffc03280b5>] ? clear_extent_bit+0x2a5/0x380 [btrfs]
[106133.944701]  [<ffffffffc0327f4e>] clear_extent_bit+0x13e/0x380 [btrfs]
[106134.006864]  [<ffffffffc0311ef0>] ? btrfs_update_inode+0x70/0x100 
[btrfs]
[106134.070709]  [<ffffffffc0328929>] unlock_extent_cached+0x29/0x30 [btrfs]
[106134.133667]  [<ffffffffc0315060>] 
btrfs_finish_ordered_io+0x350/0x560 [btrfs]
[106134.201163]  [<ffffffffc0315285>] finish_ordered_fn+0x15/0x20 [btrfs]
[106134.261162]  [<ffffffffc033b50e>] normal_work_helper+0x7e/0x1b0 [btrfs]
[106134.323481]  [<ffffffffc033b7d2>] btrfs_endio_write_helper+0x12/0x20 
[btrfs]
[106134.389486]  [<ffffffff810874fe>] process_one_work+0x14e/0x460
[106134.444666]  [<ffffffff81087e7b>] worker_thread+0x11b/0x3f0
[106134.497981]  [<ffffffff81087d60>] ? create_worker+0x1e0/0x1e0
[106134.551754]  [<ffffffff8108d9f9>] kthread+0xc9/0xe0
[106134.598446]  [<ffffffff8108d930>] ? flush_kthread_worker+0x90/0x90
[106134.654652]  [<ffffffff817ac7fc>] ret_from_fork+0x7c/0xb0
[106134.706007]  [<ffffffff8108d930>] ? flush_kthread_worker+0x90/0x90
[106134.763962] ---[ end trace 347e89907c3322c1 ]---

[106144.825302] ------------[ cut here ]------------
[106144.868881] WARNING: CPU: 0 PID: 6631 at 
/home/apw/COD/linux/kernel/watchdog.c:290 
watchdog_overflow_callback+0x98/0xc0()
[106144.973077] Watchdog detected hard LOCKUP on cpu 0
[106145.016826] Modules linked in: arc4 md4 ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_
[106145.604946] CPU: 0 PID: 6631 Comm: kworker/u128:0 Tainted: G      D 
W      3.18.0-031800rc4-generic #201411091835
[106145.700266] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 
11/09/2013
[106145.766734]  0000000000000122 ffff88040b407ba8 ffffffff8179f058 
0000000000002556
[106145.836325]  ffff88040b407bf8 ffff88040b407be8 ffffffff8106eafc 
0000000000000000
[106145.906628]  ffff8803f516c000 0000000000000000 ffff88040b407d18 
0000000000000000
[106145.977868] Call Trace:
[106146.001725]  <NMI>  [<ffffffff8179f058>] dump_stack+0x46/0x58
[106146.055937]  [<ffffffff8106eafc>] warn_slowpath_common+0x8c/0xc0
[106146.112862]  [<ffffffff8106ebe6>] warn_slowpath_fmt+0x46/0x50
[106146.167263]  [<ffffffff81124188>] watchdog_overflow_callback+0x98/0xc0
[106146.227844]  [<ffffffff811687b8>] __perf_event_overflow+0x98/0x230
[106146.287117]  [<ffffffff8102c11a>] ? x86_perf_event_set_period+0xda/0x150
[106146.349690]  [<ffffffff81169074>] perf_event_overflow+0x14/0x20
[106146.405118]  [<ffffffff81033a99>] intel_pmu_handle_irq+0x1d9/0x2c0
[106146.465039]  [<ffffffff8102b464>] perf_event_nmi_handler+0x34/0x60
[106146.524395]  [<ffffffff8101820a>] nmi_handle+0x8a/0x140
[106146.574450]  [<ffffffff81046a20>] ? 
default_send_IPI_mask_allbutself_phys+0x100/0x100
[106146.649019]  [<ffffffff810188c6>] default_do_nmi+0x56/0x160
[106146.700180]  [<ffffffff81018a60>] do_nmi+0x90/0xd0
[106146.745265]  [<ffffffff817aec71>] end_repeat_nmi+0x1e/0x2e
[106146.797340]  [<ffffffff817ac3a2>] ? _raw_spin_lock_irq+0x42/0x60
[106146.855031]  [<ffffffff817ac3a2>] ? _raw_spin_lock_irq+0x42/0x60
[106146.912118]  [<ffffffff817ac3a2>] ? _raw_spin_lock_irq+0x42/0x60
[106146.969164]  <<EOE>>  [<ffffffff817a7ee5>] __schedule+0xa5/0x780
[106147.025679]  [<ffffffff817a8699>] schedule+0x29/0x70
[106147.072564]  [<ffffffff81071aab>] do_exit+0x40b/0x470
[106147.120705]  [<ffffffff81017dc8>] oops_end+0xb8/0x160
[106147.168606]  [<ffffffff81790d9e>] no_context+0x1b5/0x1c4
[106147.218875]  [<ffffffff81790f80>] __bad_area_nosemaphore+0x1d3/0x1f2
[106147.279482]  [<ffffffff810b5242>] ? up+0x32/0x50
[106147.324560]  [<ffffffff81790fb2>] bad_area_nosemaphore+0x13/0x15
[106147.380925]  [<ffffffff8105c372>] __do_page_fault+0x3b2/0x550
[106147.436451]  [<ffffffff810d0d8d>] ? call_rcu_sched+0x1d/0x20
[106147.489986]  [<ffffffff8124c30c>] ? proc_destroy_inode+0x1c/0x20
[106147.547089]  [<ffffffff810a4e61>] ? update_curr+0x141/0x1f0
[106147.598636]  [<ffffffff8105c69e>] do_page_fault+0x3e/0x80
[106147.649682]  [<ffffffff817ae908>] page_fault+0x28/0x30
[106147.697694]  [<ffffffff8108dd90>] ? kthread_data+0x10/0x20
[106147.748309]  [<ffffffff81088dc5>] wq_worker_sleeping+0x15/0xb0
[106147.803076]  [<ffffffff817a8433>] __schedule+0x5f3/0x780
[106147.853934]  [<ffffffff817a8699>] schedule+0x29/0x70
[106147.900385]  [<ffffffff81071945>] do_exit+0x2a5/0x470
[106147.947978]  [<ffffffff810c4ebc>] ? kmsg_dump+0x9c/0xc0
[106147.997279]  [<ffffffff81017dc8>] oops_end+0xb8/0x160
[106148.045863]  [<ffffffff810180c8>] die+0x58/0x90
[106148.088400]  [<ffffffff8101445d>] do_trap+0xcd/0x160
[106148.135606]  [<ffffffff81014936>] do_error_trap+0xe6/0x170
[106148.188218]  [<ffffffffc02ea7ca>] ? 
drop_outstanding_extent+0x4a/0x50 [btrfs]
[106148.255409]  [<ffffffffc02e6467>] ? btrfs_search_slot+0x757/0x860 
[btrfs]
[106148.319503]  [<ffffffff81015210>] do_invalid_op+0x20/0x30
[106148.370501]  [<ffffffff817ae31e>] invalid_op+0x1e/0x30
[106148.419553]  [<ffffffffc032732a>] ? free_extent_state+0x6a/0xd0 [btrfs]
[106148.482108]  [<ffffffffc02ea7ca>] ? 
drop_outstanding_extent+0x4a/0x50 [btrfs]
[106148.547596]  [<ffffffffc02f4631>] 
btrfs_delalloc_release_metadata+0x51/0x190 [btrfs]
[106148.618543]  [<ffffffffc0314e54>] 
btrfs_finish_ordered_io+0x144/0x560 [btrfs]
[106148.687489]  [<ffffffff8109821c>] ? ttwu_do_wakeup+0x2c/0x100
[106148.739689]  [<ffffffffc0315285>] finish_ordered_fn+0x15/0x20 [btrfs]
[106148.800745]  [<ffffffffc033b50e>] normal_work_helper+0x7e/0x1b0 [btrfs]
[106148.863596]  [<ffffffffc033b7d2>] btrfs_endio_write_helper+0x12/0x20 
[btrfs]
[106148.929403]  [<ffffffff810874fe>] process_one_work+0x14e/0x460
[106148.983920]  [<ffffffff81087e7b>] worker_thread+0x11b/0x3f0
[106149.035970]  [<ffffffff81087d60>] ? create_worker+0x1e0/0x1e0
[106149.090752]  [<ffffffff8108d9f9>] kthread+0xc9/0xe0
[106149.136658]  [<ffffffff8108d930>] ? flush_kthread_worker+0x90/0x90
[106149.194690]  [<ffffffff817ac7fc>] ret_from_fork+0x7c/0xb0
[106149.245551]  [<ffffffff8108d930>] ? flush_kthread_worker+0x90/0x90
[106149.305057] ---[ end trace 347e89907c3322c2 ]---

--
erikberg

