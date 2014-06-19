Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:47522 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531AbaFSRwc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 13:52:32 -0400
Received: from g2t2352.austin.hp.com (g2t2352.austin.hp.com [15.217.128.51])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id A36FA4544
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 17:33:11 +0000 (UTC)
Message-ID: <53A32353.5000104@hp.com>
Date: Thu, 19 Jun 2014 13:52:19 -0400
From: Waiman Long <waiman.long@hp.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: Marc Dionne <marc.c.dionne@gmail.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, t-itoh@jp.fujitsu.com
Subject: Re: Lockups with btrfs on 3.16-rc1 - bisected
References: <CAB9dFdsyB40V2BGwdQKzSSz7YUWMh-C2AWdDNK=PMG9h+BO57w@mail.gmail.com>	<53A20FFF.3010807@hp.com>	<53A2125B.3050701@fb.com>	<53A21702.8090109@hp.com>	<53A21C78.1040809@fb.com>	<53A21E84.2050103@hp.com>	<53A22064.7080400@fb.com>	<53A2212E.7090907@hp.com>	<53A2268F.3080807@fb.com>	<CAB9dFds5J8Ti3CgtxHrgqM3j1TiwqYCnhP+A3Nb0q-FNgmQbXA@mail.gmail.com>	<53A22A01.7080505@hp.com>	<CAB9dFdvD9QMZ_rONhhP5ZD2E7+A7qxnsY978Snc3zHEbdPRszw@mail.gmail.com> <CAB9dFdtTFN+uQ8=WXVa0Y5GbBSYM5iVLgTaEeh_FqHt=XFKNvQ@mail.gmail.com> <53A246C6.5050408@fb.com> <53A2573B.1060901@hp.com> <53A31514.8030308@fb.com>
In-Reply-To: <53A31514.8030308@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/19/2014 12:51 PM, Chris Mason wrote:
> On 06/18/2014 11:21 PM, Waiman Long wrote:
>> On 06/18/2014 10:11 PM, Chris Mason wrote:
>>> On 06/18/2014 10:03 PM, Marc Dionne wrote:
>>>> On Wed, Jun 18, 2014 at 8:41 PM, Marc
>>>> Dionne<marc.c.dionne@gmail.com>   wrote:
>>>>> On Wed, Jun 18, 2014 at 8:08 PM, Waiman Long<waiman.long@hp.com>
>>>>> wrote:
>>>>>> On 06/18/2014 08:03 PM, Marc Dionne wrote:
>>>> And for an additional data point, just removing those
>>>> CONFIG_DEBUG_LOCK_ALLOC ifdefs looks like it's sufficient to prevent
>>>> the symptoms when lockdep is not enabled.
>>> Ok, somehow we've added a lock inversion here that wasn't here before.
>>> Thanks for confirming, I'll nail it down.
>>>
>>> -chris
>>>
>> I am pretty sure that the hangup is caused by the following kind of code
>> fragment in the locking.c file:
>>
>>   if (eb->lock_nested) {
>>                  read_lock(&eb->lock);
>>                  if (eb->lock_nested&&  current->pid == eb->lock_owner) {
>>
>> Is it possible to do the check without taking the read_lock?
> I think you're right, we haven't added any new recursive takers of the
> lock.  The path where we are deadlocking has an extent buffer that isn't
> in the path yet locked.  I think we're taking the read lock while that
> one is write locked.
>
> Reworking the nesting a big here.
>
> -chris

I would like to take back my comments. I took out the read_lock, but the 
process still hang while doing file activities on btrfs filesystem. So 
the problem is trickier than I thought. Below are the stack backtraces 
of some of the relevant processes.

-Longman

INFO: rcu_sched self-detected stall on CPU
INFO: rcu_sched self-detected stall on CPUINFO: rcu_sched self-detected 
stall on
  CPU {INFO: rcu_sched self-detected stall on CPU { 10 20}  {}  0}  
(t=21000 jiff
ies g=4633 c=4632 q=8579)
  (t=21000 jiffies g=4633 c=4632 q=8579)
sending NMI to all CPUs:
  (t=21000 jiffies g=4633 c=4632 q=8579)
NMI backtrace for cpu 0
CPU: 0 PID: 559 Comm: kworker/u65:8 Tainted: G            E 3.16.0-rc1 #3
Hardware name: HP ProLiant DL380 G6, BIOS P62 01/30/2011
Workqueue: btrfs-endio-write normal_work_helper
task: ffff88040e986510 ti: ffff88040e98c000 task.ti: ffff88040e98c000
RIP: 0010:[<ffffffff810a687d>]  [<ffffffff810a687d>] 
do_raw_spin_unlock+0x3d/0xa
0
RSP: 0018:ffff88041fc03d08  EFLAGS: 00000046
RAX: 0000000000000000 RBX: ffff88041fc13680 RCX: ffff88040e98c010
RDX: 0000000000000acd RSI: 0000000000000001 RDI: ffff88041fc13680
RBP: ffff88041fc03d18 R08: 0000000000000000 R09: 0000000000000006
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88041fc13680
R13: 0000000000000082 R14: 0000000000000000 R15: ffff88041fc0d1a0
FS:  0000000000000000(0000) GS:ffff88041fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f40cbd78000 CR3: 0000000001c10000 CR4: 00000000000007f0
Stack:
  0000000000000000 0000000000000082 ffff88041fc03d38 ffffffff8166e7e6
  ffff88041fc13680 0000000000013680 ffff88041fc03d68 ffffffff810834a0
  ffffffff81c4f940 0000000000000086 ffffffff81d57d60 0000000000000000
Call Trace:
<IRQ>  [<ffffffff8166e7e6>] _raw_spin_unlock_irqrestore+0x36/0x50
  [<ffffffff810834a0>] resched_cpu+0x80/0x90
  [<ffffffff810be01f>] print_cpu_stall+0x12f/0x140
  [<ffffffff810a0700>] ? cpuacct_css_alloc+0xb0/0xb0
  [<ffffffff810be46f>] __rcu_pending+0x1ff/0x210
  [<ffffffff810bf3cd>] rcu_check_callbacks+0xed/0x1a0
  [<ffffffff8105f938>] update_process_times+0x48/0x80
  [<ffffffff810caa77>] tick_sched_handle+0x37/0x80
  [<ffffffff810cb2f4>] tick_sched_timer+0x54/0x90
  [<ffffffff8107aba1>] __run_hrtimer+0x81/0x1c0
  [<ffffffff810cb2a0>] ? tick_nohz_handler+0xc0/0xc0
  [<ffffffff8107afc6>] hrtimer_interrupt+0x116/0x2a0
  [<ffffffff8103643b>] local_apic_timer_interrupt+0x3b/0x60
  [<ffffffff81671685>] smp_apic_timer_interrupt+0x45/0x60
  [<ffffffff8166fc8a>] apic_timer_interrupt+0x6a/0x70
<EOI>  [<ffffffff810a7180>] ? queue_write_lock_slowpath+0x60/0x90
  [<ffffffff810a692d>] do_raw_write_lock+0x4d/0xa0
  [<ffffffff8166e3b9>] _raw_write_lock+0x39/0x40
  [<ffffffff812948ef>] ? btrfs_try_tree_write_lock+0x4f/0xc0
  [<ffffffff812948ef>] btrfs_try_tree_write_lock+0x4f/0xc0
  [<ffffffff81236e62>] btrfs_search_slot+0x422/0x870
  [<ffffffff81237c7e>] btrfs_insert_empty_items+0x7e/0xe0
  [<ffffffff8125f83c>] insert_reserved_file_extent.clone.0+0x13c/0x2f0
  [<ffffffff81262745>] btrfs_finish_ordered_io+0x495/0x560
  [<ffffffff81262825>] finish_ordered_fn+0x15/0x20
  [<ffffffff8128a8ed>] normal_work_helper+0x8d/0x1b0
  [<ffffffff8107052b>] process_one_work+0x1db/0x510
  [<ffffffff810704b6>] ? process_one_work+0x166/0x510
  [<ffffffff810717ef>] worker_thread+0x11f/0x3c0
  [<ffffffff810716d0>] ? maybe_create_worker+0x190/0x190
  [<ffffffff8107791e>] kthread+0xde/0x100
  [<ffffffff81077840>] ? __init_kthread_worker+0x70/0x70
  [<ffffffff8166ed6c>] ret_from_fork+0x7c/0xb0
  [<ffffffff81077840>] ? __init_kthread_worker+0x70/0x70
Code: 4e ad de 48 89 fb 75 42 0f b7 13 0f b7 43 02 66 39 c2 74 66 65 48 
8b 04 25
  c0 b9 00 00 48 39 43 10 75 46 65 8b 04 25 30 b0 00 00 <39> 43 08 75 28 
48 c7 43
  10 ff ff ff ff c7 43 08 ff ff ff ff 66

--------------------------------------------------------

NMI backtrace for cpu 10
CPU: 10 PID: 23844 Comm: kworker/u65:14 Tainted: G            E 
3.16.0-rc1 #3
Hardware name: HP ProLiant DL380 G6, BIOS P62 01/30/2011
Workqueue: btrfs-endio-write normal_work_helper
task: ffff880407c26190 ti: ffff88040799c000 task.ti: ffff88040799c000
RIP: 0010:[<ffffffff8103779c>]  [<ffffffff8103779c>] 
default_send_IPI_mask_seque
nce_phys+0x6c/0xf0
RSP: 0018:ffff88041fca3cf8  EFLAGS: 00000046
RAX: ffff88081faa0000 RBX: 0000000000000002 RCX: 0000000000000032
RDX: 000000000000000b RSI: 0000000000000020 RDI: 0000000000000020
RBP: ffff88041fca3d38 R08: ffffffff81d58160 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 000000000000b034
R13: ffffffff81d58160 R14: 0000000000000400 R15: 0000000000000092
FS:  0000000000000000(0000) GS:ffff88041fca0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f40ca200000 CR3: 0000000001c10000 CR4: 00000000000007e0
Stack:
  0000000000000012 000000000000000a ffff88041fca3d18 0000000000000000
  0000000000002183 ffffffff81d57d60 0000000000000000 ffff88041fcad1a0
  ffff88041fca3d48 ffffffff8103acb7 ffff88041fca3d68 ffffffff81037941
Call Trace:
<IRQ>  [<ffffffff8103acb7>] physflat_send_IPI_all+0x17/0x20
  [<ffffffff81037941>] arch_trigger_all_cpu_backtrace+0x61/0xa0
  [<ffffffff810bdfcc>] print_cpu_stall+0xdc/0x140
  [<ffffffff810a0700>] ? cpuacct_css_alloc+0xb0/0xb0
  [<ffffffff810be46f>] __rcu_pending+0x1ff/0x210
  [<ffffffff810bf3cd>] rcu_check_callbacks+0xed/0x1a0
  [<ffffffff8105f938>] update_process_times+0x48/0x80
  [<ffffffff810caa77>] tick_sched_handle+0x37/0x80
  [<ffffffff810cb2f4>] tick_sched_timer+0x54/0x90
  [<ffffffff8107aba1>] __run_hrtimer+0x81/0x1c0
  [<ffffffff810cb2a0>] ? tick_nohz_handler+0xc0/0xc0
  [<ffffffff8107afc6>] hrtimer_interrupt+0x116/0x2a0
  [<ffffffff8103643b>] local_apic_timer_interrupt+0x3b/0x60
  [<ffffffff81671685>] smp_apic_timer_interrupt+0x45/0x60
  [<ffffffff8166fc8a>] apic_timer_interrupt+0x6a/0x70
<EOI>  [<ffffffff810a7223>] ? queue_read_lock_slowpath+0x73/0x90
  [<ffffffff810a69c4>] do_raw_read_lock+0x44/0x50
  [<ffffffff8166e6bc>] _raw_read_lock+0x3c/0x50
  [<ffffffff81294d31>] ? btrfs_clear_lock_blocking_rw+0x71/0x1d0
  [<ffffffff81294d31>] btrfs_clear_lock_blocking_rw+0x71/0x1d0
  [<ffffffff8122d92a>] btrfs_clear_path_blocking+0x3a/0x80
  [<ffffffff81236f3d>] btrfs_search_slot+0x4fd/0x870
  [<ffffffff8123873e>] btrfs_next_old_leaf+0x24e/0x480
  [<ffffffff81238980>] btrfs_next_leaf+0x10/0x20
  [<ffffffff8126e7f8>] __btrfs_drop_extents+0x2a8/0xe80
  [<ffffffff810a3b11>] ? __lock_acquire+0x1b1/0x470
  [<ffffffff811937e5>] ? kmem_cache_alloc+0x1a5/0x1d0
  [<ffffffff8125f7a7>] insert_reserved_file_extent.clone.0+0xa7/0x2f0
  [<ffffffff81262745>] btrfs_finish_ordered_io+0x495/0x560
  [<ffffffff81262825>] finish_ordered_fn+0x15/0x20
  [<ffffffff8128a8ed>] normal_work_helper+0x8d/0x1b0
  [<ffffffff8107052b>] process_one_work+0x1db/0x510
  [<ffffffff810704b6>] ? process_one_work+0x166/0x510
  [<ffffffff810717ef>] worker_thread+0x11f/0x3c0
  [<ffffffff810716d0>] ? maybe_create_worker+0x190/0x190
  [<ffffffff8107791e>] kthread+0xde/0x100
  [<ffffffff81077840>] ? __init_kthread_worker+0x70/0x70
  [<ffffffff8166ed6c>] ret_from_fork+0x7c/0xb0
  [<ffffffff81077840>] ? __init_kthread_worker+0x70/0x70
Code: c2 01 4c 89 ef 48 63 d2 e8 22 8a 32 00 48 63 35 cf 26 d2 00 89 c2 
48 39 f2
  73 55 48 8b 04 d5 00 57 d4 81 83 fb 02 41 0f b7 0c 04 <74> 55 8b 04 25 
00 c3 5f
  ff f6 c4 10 74 1b 66 0f 1f 44 00 00 f3

--------------------------------------------------------------------------

NMI backtrace for cpu 14
CPU: 14 PID: 23832 Comm: tar Tainted: G            E 3.16.0-rc1 #3
Hardware name: HP ProLiant DL380 G6, BIOS P62 01/30/2011
task: ffff8808028f4950 ti: ffff8808028ac000 task.ti: ffff8808028ac000
RIP: 0010:[<ffffffff8135a5e7>]  [<ffffffff8135a5e7>] delay_tsc+0x37/0x60
RSP: 0018:ffff88041fce3ad8  EFLAGS: 00000046
RAX: 000000002ae3de42 RBX: ffffffff82b54958 RCX: 000000000000000e
RDX: 00000000000000ff RSI: 000000002ae3d696 RDI: 0000000000000b75
RBP: ffff88041fce3ad8 R08: 000000000000000e R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: 000000000000270b
R13: 0000000000000020 R14: 0000000000000020 R15: ffffffff8143d620
FS:  00007f84603367a0(0000) GS:ffff88041fce0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fffea97afd8 CR3: 000000080ae98000 CR4: 00000000000007e0
Stack:
  ffff88041fce3ae8 ffffffff8135a5a8 ffff88041fce3b18 ffffffff8143d5b0
  ffffffff8143309c ffffffff82b54958 0000000000000074 000000000000002a
  ffff88041fce3b38 ffffffff8143d646 ffffffff829cde5f ffffffff82b54958
Call Trace:
<IRQ>  [<ffffffff8135a5a8>] __const_udelay+0x28/0x30
  [<ffffffff8143d5b0>] wait_for_xmitr+0x30/0xa0
  [<ffffffff8143309c>] ? vt_console_print+0x2cc/0x3b0
  [<ffffffff8143d646>] serial8250_console_putchar+0x26/0x40
  [<ffffffff814387ae>] uart_console_write+0x3e/0x70
  [<ffffffff8143fcf6>] serial8250_console_write+0xb6/0x180
  [<ffffffff810b2635>] call_console_drivers.clone.2+0xa5/0x100
  [<ffffffff810b2773>] console_cont_flush.clone.0+0xe3/0x190
  [<ffffffff810b2858>] console_unlock+0x38/0x310
  [<ffffffff810b1d57>] ? __down_trylock_console_sem+0x47/0x50
  [<ffffffff810b303d>] ? vprintk_emit+0x2bd/0x5d0
  [<ffffffff810b305e>] vprintk_emit+0x2de/0x5d0
  [<ffffffff810a3b11>] ? __lock_acquire+0x1b1/0x470
  [<ffffffff81669486>] printk+0x4d/0x4f
  [<ffffffff810bdf1d>] print_cpu_stall+0x2d/0x140
  [<ffffffff810a0700>] ? cpuacct_css_alloc+0xb0/0xb0
  [<ffffffff810be46f>] __rcu_pending+0x1ff/0x210
  [<ffffffff810bf3cd>] rcu_check_callbacks+0xed/0x1a0
  [<ffffffff8105f938>] update_process_times+0x48/0x80
  [<ffffffff810caa77>] tick_sched_handle+0x37/0x80
  [<ffffffff810cb2f4>] tick_sched_timer+0x54/0x90
  [<ffffffff8107aba1>] __run_hrtimer+0x81/0x1c0
  [<ffffffff810cb2a0>] ? tick_nohz_handler+0xc0/0xc0
  [<ffffffff8107afc6>] hrtimer_interrupt+0x116/0x2a0
  [<ffffffff8103643b>] local_apic_timer_interrupt+0x3b/0x60
  [<ffffffff81671685>] smp_apic_timer_interrupt+0x45/0x60
  [<ffffffff8166fc8a>] apic_timer_interrupt+0x6a/0x70
<EOI>  [<ffffffff810a7223>] ? queue_read_lock_slowpath+0x73/0x90
  [<ffffffff810a69c4>] do_raw_read_lock+0x44/0x50
  [<ffffffff8166e6bc>] _raw_read_lock+0x3c/0x50
  [<ffffffff81294be8>] ? btrfs_tree_read_lock+0x58/0x130
  [<ffffffff81294be8>] btrfs_tree_read_lock+0x58/0x130
  [<ffffffff8122d7ab>] btrfs_read_lock_root_node+0x3b/0x50
  [<ffffffff8123709c>] btrfs_search_slot+0x65c/0x870
  [<ffffffff8125cef8>] ? btrfs_set_bit_hook+0xd8/0x150
  [<ffffffff8124b76d>] btrfs_lookup_dir_item+0x7d/0xd0
  [<ffffffff8126a895>] btrfs_lookup_dentry+0xb5/0x390
  [<ffffffff8166e82b>] ? _raw_spin_unlock+0x2b/0x40
  [<ffffffff8126ab86>] btrfs_lookup+0x16/0x40
  [<ffffffff811ac3ad>] lookup_real+0x1d/0x60
  [<ffffffff811aeac4>] lookup_open+0xc4/0x1c0
  [<ffffffff811b0428>] ? do_last+0x338/0x8c0
  [<ffffffff811b0442>] do_last+0x352/0x8c0
  [<ffffffff811acc00>] ? __inode_permission+0x90/0xd0
  [<ffffffff811b3224>] path_openat+0xc4/0x480
  [<ffffffff810a3b11>] ? __lock_acquire+0x1b1/0x470
  [<ffffffff810a082b>] ? cpuacct_charge+0x6b/0x90
  [<ffffffff811c0b86>] ? __alloc_fd+0x36/0x150
  [<ffffffff811b371a>] do_filp_open+0x4a/0xa0
  [<ffffffff811c0bfc>] ? __alloc_fd+0xac/0x150
  [<ffffffff810f4254>] ? __audit_syscall_entry+0x94/0x100
  [<ffffffff811a131a>] do_sys_open+0x11a/0x230
  [<ffffffff811a146e>] SyS_open+0x1e/0x20
  [<ffffffff8166ee12>] system_call_fastpath+0x16/0x1b
Code: 04 25 30 b0 00 00 66 66 90 0f ae e8 0f 31 89 c6 eb 11 66 90 f3 90 
65 8b 0c
  25 30 b0 00 00 44 39 c1 75 12 66 66 90 0f ae e8 0f 31 <89> c2 29 f2 39 
fa 72 e1
  c9 c3 29 c6 01 f7 66 66 90 0f ae e8 0f


-----------------------------------------------------------------------
NMI backtrace for cpu 20
CPU: 20 PID: 154 Comm: kworker/u65:1 Tainted: G            E 3.16.0-rc1 #3
Hardware name: HP ProLiant DL380 G6, BIOS P62 01/30/2011
Workqueue: btrfs-endio-write normal_work_helper
task: ffff88040d83e190 ti: ffff88040d840000 task.ti: ffff88040d840000
RIP: 0010:[<ffffffff810a7184>]  [<ffffffff810a7184>] 
queue_write_lock_slowpath+0
x64/0x90
RSP: 0018:ffff88040d843838  EFLAGS: 00000206
RAX: 0000000000000101 RBX: ffff8807f7b51bc8 RCX: 0000000000000101
RDX: 00000000000000ff RSI: ffff88040d83edc8 RDI: ffff8807f7b51bc8
RBP: ffff88040d843838 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8807f7b51bb4
R13: ffff8807f7b51c00 R14: ffff8807f7b51bb8 R15: ffff8807f7b51c48
FS:  0000000000000000(0000) GS:ffff88041fd40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fc824402008 CR3: 0000000001c10000 CR4: 00000000000007e0
Stack:
  ffff88040d843858 ffffffff810a692d ffff8807f7b51bb8 ffff8807f7b51bc8
  ffff88040d843888 ffffffff8166e3b9 ffffffff81294769 ffff8807f7b51bb4
  ffff8807f7b51c00 ffff88040d8438b8 ffff88040d843918 ffffffff81294769
Call Trace:
  [<ffffffff810a692d>] do_raw_write_lock+0x4d/0xa0
  [<ffffffff8166e3b9>] _raw_write_lock+0x39/0x40
  [<ffffffff81294769>] ? btrfs_tree_lock+0xf9/0x230
  [<ffffffff81294769>] btrfs_tree_lock+0xf9/0x230
  [<ffffffff8122d70e>] ? btrfs_root_node+0x5e/0xc0
  [<ffffffff8109a850>] ? bit_waitqueue+0xe0/0xe0
  [<ffffffff8122d8db>] btrfs_lock_root_node+0x3b/0x50
  [<ffffffff812370ef>] btrfs_search_slot+0x6af/0x870
  [<ffffffff81294600>] ? btrfs_tree_unlock+0x70/0xe0
  [<ffffffff8129462e>] ? btrfs_tree_unlock+0x9e/0xe0
  [<ffffffff810a42c4>] ? __lock_release+0x84/0x180
  [<ffffffff8124bf9d>] btrfs_lookup_file_extent+0x3d/0x40
  [<ffffffff8126e6a2>] __btrfs_drop_extents+0x152/0xe80
  [<ffffffff810a3b11>] ? __lock_acquire+0x1b1/0x470
  [<ffffffff810bb412>] ? rcu_resched+0x22/0x30
  [<ffffffff8166a316>] ? _cond_resched+0x36/0x60
  [<ffffffff811937e5>] ? kmem_cache_alloc+0x1a5/0x1d0
  [<ffffffff8125f7a7>] insert_reserved_file_extent.clone.0+0xa7/0x2f0
  [<ffffffff81262745>] btrfs_finish_ordered_io+0x495/0x560
  [<ffffffff81262825>] finish_ordered_fn+0x15/0x20
  [<ffffffff8128a8ed>] normal_work_helper+0x8d/0x1b0
  [<ffffffff8107052b>] process_one_work+0x1db/0x510
  [<ffffffff810704b6>] ? process_one_work+0x166/0x510
  [<ffffffff810717ef>] worker_thread+0x11f/0x3c0
  [<ffffffff810716d0>] ? maybe_create_worker+0x190/0x190
  [<ffffffff8107791e>] kthread+0xde/0x100
  [<ffffffff81077840>] ? __init_kthread_worker+0x70/0x70
  [<ffffffff8166ed6c>] ret_from_fork+0x7c/0xb0
  [<ffffffff81077840>] ? __init_kthread_worker+0x70/0x70
Code: 83 47 04 01 c9 c3 90 f3 90 8b 17 84 d2 75 f8 89 d1 89 d0 83 c9 01 
f0 0f b1
  0f 39 d0 75 e9 ba ff 00 00 00 eb 04 66 90 f3 90 8b 07 <83> f8 01 75 f7 
f0 0f b1
  17 83 f8 01 75 ee eb c4 f3 90 0f b7 01

