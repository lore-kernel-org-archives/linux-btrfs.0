Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36249 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaJDKGe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Oct 2014 06:06:34 -0400
Date: Sat, 4 Oct 2014 05:06:28 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Dave Hansen <dave.hansen@intel.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Subject: Re: [x86, locking/rwlocks, btrfs] INFO: rcu_sched self-detected
 stall on CPU
Message-ID: <20141004050628.4613752a@as>
In-Reply-To: <542F693E.5070200@hp.com>
References: <20141003133351.GC32634@wfg-t540p.sh.intel.com>
	<542F693E.5070200@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 03 Oct 2014 23:27:58 -0400
Waiman Long <waiman.long@hp.com> wrote:

> On 10/03/2014 09:33 AM, Fengguang Wu wrote:
> > Hi Waiman,
> >
> > FYI, we noticed the below changes on commit
> >
> > bd01ec1a13f9a327950c8e3080096446c7804753 ("x86, locking/rwlocks: Enable qrwlocks on x86")
> >
> > +----------------------------------------------+------------+------------+
> > |                                              | 70af2f8a4f | bd01ec1a13 |
> > +----------------------------------------------+------------+------------+
> > | boot_successes                               | 3          | 2          |
> > | boot_failures                                | 7          | 13         |
> > | BUG:kernel_test_crashed                      | 7          | 8          |
> > | INFO:rcu_sched_self-detected_stall_on_CPU    | 0          | 4          |
> > | RIP:intel_idle                               | 0          | 4          |
> > | RIP:queue_write_lock_slowpath                | 0          | 4          |
> > | RIP:queue_read_lock_slowpath                 | 0          | 4          |
> > | RIP:sys_imageblit_sysimgblt                  | 0          | 2          |
> > | RIP:default_send_IPI_mask_sequence_phys      | 0          | 1          |
> > | RIP:memcpy                                   | 0          | 1          |
> > | RIP:delay_tsc                                | 0          | 4          |
> > | backtrace:cpu_startup_entry                  | 0          | 3          |
> > | backtrace:do_fsync                           | 0          | 4          |
> > | backtrace:SyS_fsync                          | 0          | 4          |
> > | backtrace:normal_work_helper                 | 0          | 1          |
> > | backtrace:vfs_write                          | 0          | 3          |
> > | backtrace:SyS_write                          | 0          | 3          |
> > | backtrace:do_sys_open                        | 0          | 4          |
> > | backtrace:SyS_open                           | 0          | 4          |
> > | backtrace:flush_to_ldisc                     | 0          | 1          |
> > | RIP:cpu_startup_entry                        | 0          | 1          |
> > | RIP:native_read_tsc                          | 0          | 2          |
> > | RIP:rcu_eqs_exit_common                      | 0          | 1          |
> > | INFO:rcu_sched_detected_stalls_on_CPUs/tasks | 0          | 1          |
> > +----------------------------------------------+------------+------------+
> >
> >
> > run: /lkp/lkp/src/monitors/wrapper sched_debug	{"interval"=>"10"}
> > run: /usr/bin/time -v -o /lkp/lkp/src/tmp/time /lkp/lkp/src/tests/wrapper fsmark	{"filesize"=>"9B", "test_size"=>"400M", "sync_method"=>"fsyncBeforeClose", "nr_directories"=>"16d", "nr_files_per_directory"=>"256fpd"}
> > run: /lkp/lkp/src/monitors/wrapper pmeter	{}
> > [  125.656200] INFO: rcu_sched self-detected stall on CPU
> > [  125.657199] INFO: rcu_sched self-detected stall on CPUINFO: rcu_sched self-detected stall on CPUINFO: rcu_sched self-detected stall on CPUINFO: rcu_sched self-detected stall on CPU { { { { 0 9 7 14} } } }  (t=100000 jiffies g=1792 c=1791 q=0)
> > [  125.657218]  (t=100000 jiffies g=1792 c=1791 q=0)
> > [  125.657219]  (t=100000 jiffies g=1792 c=1791 q=0)
> > [  125.657221]  (t=100000 jiffies g=1792 c=1791 q=0)
> > [  125.657222] sending NMI to all CPUs:
> > [  125.657224] NMI backtrace for cpu 0
> > [  125.657227] CPU: 0 PID: 3025 Comm: fs_mark Not tainted 3.16.0 #1
> > [  125.657227] Hardware name: Intel Corporation S5520UR/S5520UR, BIOS S5500.86B.01.00.0050.050620101605 05/06/2010
> > [  125.657228] task: ffff88007ef58000 ti: ffff88007ef54000 task.ti: ffff88007ef54000
> > [  125.657229] RIP: 0010:[<ffffffff8101cff6>]  [<ffffffff8101cff6>] native_read_tsc+0x6/0x20
> > [  125.657236] RSP: 0018:ffff88036fc03d20  EFLAGS: 00000002
> > [  125.657237] RAX: 000000003f172acf RBX: 000000003f172ab0 RCX: 0000000000000028
> > [  125.657238] RDX: 00000000000014e5 RSI: 0000000000000018 RDI: 000000000004773a
> > [  125.657238] RBP: ffff88036fc03d20 R08: ffffffff81da2200 R09: 0000000000000092
> > [  125.657239] R10: 000014e53edc9480 R11: 0000000000080000 R12: 000000000004773a
> > [  125.657239] R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000001
> > [  125.657241] FS:  0000000001ee0880(0063) GS:ffff88036fc00000(0000) knlGS:0000000000000000
> > [  125.657241] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [  125.657242] CR2: 000000000061c000 CR3: 000000007ef3c000 CR4: 00000000000007f0
> > [  125.657243] Stack:
> > [  125.657243]  ffff88036fc03d48 ffffffff813f85e3 0000000000001000 00000000000003e9
> > [  125.657244]  0000000000000400 ffff88036fc03d58 ffffffff813f8538 ffff88036fc03d78
> > [  125.657246]  ffffffff81046d1a 000000000000b032 ffffffff81da2200 ffff88036fc03dc0
> > [  125.657247] Call Trace:
> > [  125.657247]<IRQ>   [<ffffffff813f85e3>] delay_tsc+0x43/0x90
> > [  125.657253]  [<ffffffff813f8538>] __const_udelay+0x28/0x30
> > [  125.657254]  [<ffffffff81046d1a>] native_safe_apic_wait_icr_idle+0x2a/0x60
> > [  125.657257]  [<ffffffff810487e0>] default_send_IPI_mask_sequence_phys+0xd0/0x100
> > [  125.657259]  [<ffffffff8104d78e>] physflat_send_IPI_mask+0xe/0x10
> > [  125.657261]  [<ffffffff81048b74>] arch_trigger_all_cpu_backtrace+0x134/0x150
> > [  125.657262]  [<ffffffff810da1b9>] rcu_check_callbacks+0x4c9/0x740
> > [  125.657265]  [<ffffffff8107ca97>] update_process_times+0x47/0x70
> > [  125.657267]  [<ffffffff810e5105>] tick_sched_handle.isra.18+0x25/0x60
> > [  125.657269]  [<ffffffff810e53a1>] tick_sched_timer+0x41/0x60
> > [  125.657270]  [<ffffffff81096aa7>] __run_hrtimer+0x77/0x1f0
> > [  125.657274]  [<ffffffff810e5360>] ? tick_sched_do_timer+0x60/0x60
> > [  125.657275]  [<ffffffff81096ecf>] hrtimer_interrupt+0xff/0x240
> > [  125.657277]  [<ffffffff81046c9a>] local_apic_timer_interrupt+0x3a/0x60
> > [  125.657278]  [<ffffffff8185238f>] smp_apic_timer_interrupt+0x3f/0x50
> > [  125.657282]  [<ffffffff8185049d>] apic_timer_interrupt+0x6d/0x80
> > [  125.657285]<EOI>   [<ffffffff810c1661>] ? queue_read_lock_slowpath+0x111/0x130
> > [  125.657289]  [<ffffffff8184ee09>] _raw_read_lock+0x29/0x30
> > [  125.657292]  [<ffffffffa02805cc>] btrfs_clear_lock_blocking_rw+0x4c/0x100 [btrfs]
> > [  125.657307]  [<ffffffffa021fe51>] btrfs_clear_path_blocking+0x41/0x80 [btrfs]
> > [  125.657312]  [<ffffffffa0227f03>] btrfs_search_forward+0x203/0x330 [btrfs]
> > [  125.657318]  [<ffffffffa028707b>] btrfs_log_inode+0x27b/0x920 [btrfs]
> > [  125.657327]  [<ffffffff8115bc60>] ? find_get_pages_tag+0x110/0x1a0
> > [  125.657330]  [<ffffffffa02820cd>] ? check_parent_dirs_for_sync+0xfd/0x140 [btrfs]
> > [  125.657339]  [<ffffffffa0287986>] btrfs_log_inode_parent+0x1d6/0x540 [btrfs]
> > [  125.657349]  [<ffffffffa0288b42>] btrfs_log_dentry_safe+0x42/0x60 [btrfs]
> > [  125.657358]  [<ffffffffa0258da4>] btrfs_sync_file+0x194/0x310 [btrfs]
> > [  125.657367]  [<ffffffff81204a31>] do_fsync+0x51/0x80
> > [  125.657369]  [<ffffffff81204cc0>] SyS_fsync+0x10/0x20
> > [  125.657370]  [<ffffffff8184f5a9>] system_call_fastpath+0x16/0x1b
> > [  125.657372] Code: 65 ff 0c 25 e0 c7 00 00 e9 37 ff ff ff 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 5d c3 0f 1f 44 00 00 55 48 89 e5 0f 31<48>  c1 e2 20 89 c0 48 09 d0 5d c3 66 66 66 66 66 66 2e 0f 1f 84
> > [  125.657423] NMI backtrace for cpu 1
> > [  125.657425] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.16.0 #1
> > [  125.657426] Hardware name: Intel Corporation S5520UR/S5520UR, BIOS S5500.86B.01.00.0050.050620101605 05/06/2010
> > [  125.657427] task: ffff880366eb1d80 ti: ffff880366eb8000 task.ti: ffff880366eb8000
> > [  125.657428] RIP: 0010:[<ffffffff8145aa27>]  [<ffffffff8145aa27>] intel_idle+0xd7/0x160
> > [  125.657433] RSP: 0018:ffff880366ebbe50  EFLAGS: 00000046
> > [  125.657434] RAX: 0000000000000020 RBX: 0000000000000008 RCX: 0000000000000001
> > [  125.657435] RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000046
> > [  125.657436] RBP: ffff880366ebbe78 R08: 00000000000ec708 R09: 0000000000000002
> > [  125.657436] R10: 000014e53eafed88 R11: 00000000000006f6 R12: 0000000000000020
> > [  125.657437] R13: 0000000000000003 R14: 0000000000000004 R15: 0000000000000004
> > [  125.657438] FS:  0000000000000000(0000) GS:ffff8801e9c00000(0000) knlGS:0000000000000000
> > [  125.657439] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [  125.657440] CR2: 00000000006e7c24 CR3: 0000000001c21000 CR4: 00000000000007e0
> > [  125.657441] Stack:
> > [  125.657441]  00000001810dc3db ffff8801e9c1c900 ffffffff81d05740 0000001d0cdfc5fe
> > [  125.657443]  0000000000000004 ffff880366ebbea8 ffffffff816c1f9a ffffffff81da50c0
> > [  125.657444]  ffff8801e9c1c900 ffffffff81d05740 0000000008004000 ffff880366ebbeb8
> > [  125.657446] Call Trace:
> > [  125.657447]  [<ffffffff816c1f9a>] cpuidle_enter_state+0x3a/0xc0
> > [  125.657451]  [<ffffffff816c2107>] cpuidle_enter+0x17/0x20
> > [  125.657452]  [<ffffffff810b99b7>] cpu_idle_loop+0x317/0x460
> > [  125.657456]  [<ffffffff810b9b13>] cpu_startup_entry+0x13/0x20
> > [  125.657458]  [<ffffffff81044b9f>] start_secondary+0x1ff/0x290
> > [  125.657463] Code: c8 00 00 48 89 d1 48 2d c8 3f 00 00 0f 01 c8 65 48 8b 04 25 08 c8 00 00 48 8b 80 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9<65>  48 8b 04 25 08 c8 00 00 f0 80 a0 3a c0 ff ff df 0f ae f0 65
> > [  125.657492] NMI backtrace for cpu 2
> > [  125.657494] CPU: 2 PID: 3003 Comm: fs_mark Not tainted 3.16.0 #1
> > [  125.657494] Hardware name: Intel Corporation S5520UR/S5520UR, BIOS S5500.86B.01.00.0050.050620101605 05/06/2010
> > [  125.657495] task: ffff8801e6f75880 ti: ffff8801e75f0000 task.ti: ffff8801e75f0000
> > [  125.657496] RIP: 0010:[<ffffffff810c1528>]  [<ffffffff810c1528>] queue_write_lock_slowpath+0xf8/0x120
> > [  125.657499] RSP: 0018:ffff8801e75f37f0  EFLAGS: 00000212
> > [  125.657500] RAX: 0000000000006c64 RBX: ffff880359dc3e10 RCX: 00000000000082c8
> > [  125.657501] RDX: 00000000000082d0 RSI: 00000000000082d0 RDI: ffff880359dc3e84
> > [  125.657501] RBP: ffff8801e75f37f0 R08: ffff880359dc3e80 R09: 0000000000000206
> > [  125.657502] R10: 00000000000039ba R11: 00000000000003a6 R12: ffff880359dc3ea0
> > [  125.657503] R13: ffff880359dc3e88 R14: ffff8801e75f3828 R15: ffff880359dc3e80
> > [  125.657504] FS:  0000000001ee0880(0063) GS:ffff88036fc20000(0000) knlGS:0000000000000000
> > [  125.657505] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [  125.657506] CR2: 00007f39f56165c8 CR3: 00000001dd750000 CR4: 00000000000007e0
> > [  125.657506] Stack:
> > [  125.657507]  ffff8801e75f3800 ffffffff8184ed99 ffff8801e75f3860 ffffffffa0280aa9
> > [  125.657508]  ffffffff00000000 ffff8801e6f75880 ffffffff810b9400 ffff8801e75f3828
> > [  125.657510]  ffff8801e75f3828 ffff880359dc3e10 ffff88035571a000 ffff88035571a000
> > [  125.657512] Call Trace:
> > [  125.657512]  [<ffffffff8184ed99>] _raw_write_lock+0x29/0x30
> > [  125.657515]  [<ffffffffa0280aa9>] btrfs_tree_lock+0xc9/0x1e0 [btrfs]
> > [  125.657528]  [<ffffffff810b9400>] ? abort_exclusive_wait+0xb0/0xb0
> > [  125.657530]  [<ffffffffa022006b>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
> > [  125.657537]  [<ffffffffa02252c9>] btrfs_search_slot+0x939/0xa40 [btrfs]
> > [  125.657543]  [<ffffffffa025b13d>] ? btrfs_drop_extent_cache+0x37d/0x440 [btrfs]
> > [  125.657554]  [<ffffffffa023c297>] btrfs_lookup_file_extent+0x37/0x40 [btrfs]
> > [  125.657563]  [<ffffffffa025b6ee>] __btrfs_drop_extents+0x16e/0xd80 [btrfs]
> > [  125.657573]  [<ffffffffa0248983>] ? start_transaction+0x93/0x5a0 [btrfs]
> > [  125.657583]  [<ffffffffa024e652>] cow_file_range_inline+0x192/0x590 [btrfs]
> > [  125.657593]  [<ffffffffa0265683>] ? __set_extent_bit+0x493/0x580 [btrfs]
> > [  125.657604]  [<ffffffffa024ed38>] cow_file_range+0x2e8/0x410 [btrfs]
> > [  125.657614]  [<ffffffffa0264a7b>] ? find_delalloc_range.constprop.44+0xab/0x1a0 [btrfs]
> > [  125.657624]  [<ffffffffa0266fa9>] ? test_range_bit+0x109/0x180 [btrfs]
> > [  125.657635]  [<ffffffffa024fc44>] run_delalloc_range+0x314/0x340 [btrfs]
> > [  125.657645]  [<ffffffffa0267201>] ? find_lock_delalloc_range.constprop.43+0x1e1/0x210 [btrfs]
> > [  125.657656]  [<ffffffffa026731c>] writepage_delalloc.isra.32+0xec/0x160 [btrfs]
> > [  125.657667]  [<ffffffffa0267ed6>] __extent_writepage+0xb6/0x310 [btrfs]
> > [  125.657678]  [<ffffffffa026848a>] extent_write_cache_pages.isra.27.constprop.49+0x35a/0x410 [btrfs]
> > [  125.657689]  [<ffffffffa025aa18>] ? btrfs_file_write_iter+0x198/0x540 [btrfs]
> > [  125.657700]  [<ffffffffa026a36d>] extent_writepages+0x4d/0x70 [btrfs]
> > [  125.657711]  [<ffffffffa024cb10>] ? btrfs_writepage_end_io_hook+0x190/0x190 [btrfs]
> > [  125.657720]  [<ffffffff811d3382>] ? new_sync_write+0x82/0xb0
> > [  125.657723]  [<ffffffffa024a568>] btrfs_writepages+0x28/0x30 [btrfs]
> > [  125.657733]  [<ffffffff81168c0e>] do_writepages+0x1e/0x30
> > [  125.657736]  [<ffffffff8115cb29>] __filemap_fdatawrite_range+0x59/0x60
> > [  125.657738]  [<ffffffff8115cbf3>] filemap_fdatawrite_range+0x13/0x20
> > [  125.657740]  [<ffffffffa0258c5e>] btrfs_sync_file+0x4e/0x310 [btrfs]
> > [  125.657750]  [<ffffffff81204a31>] do_fsync+0x51/0x80
> > [  125.657751]  [<ffffffff81204cc0>] SyS_fsync+0x10/0x20
> > [  125.657753]  [<ffffffff8184f5a9>] system_call_fastpath+0x16/0x1b
> > [  125.657755] Code: b7 f6 66 66 66 90 66 66 90 5d c3 83 e2 fe 0f b7 f2 b8 00 80 00 00 0f 1f 44 00 00 41 0f b7 48 04 66 39 ca 0f 84 33 ff ff ff f3 90<83>  e8 01 75 eb 66 66 66 90 66 66 90 eb d8 89 d0 f0 41 0f b1 48
> > [  125.657774] NMI backtrace for cpu 3
> > [  125.657776] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.16.0 #1
> > [  125.657777] Hardware name: Intel Corporation S5520UR/S5520UR, BIOS S5500.86B.01.00.0050.050620101605 05/06/2010
> > [  125.657778] task: ffff880366eb5880 ti: ffff880366f08000 task.ti: ffff880366f08000
> > [  125.657779] RIP: 0010:[<ffffffff8145aa27>]  [<ffffffff8145aa27>] intel_idle+0xd7/0x160
> > [  125.657782] RSP: 0018:ffff880366f0be50  EFLAGS: 00000046
> > [  125.657783] RAX: 0000000000000020 RBX: 0000000000000008 RCX: 0000000000000001
> > [  125.657783] RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000046
> > [  125.657784] RBP: ffff880366f0be78 R08: 0000000000129657 R09: 0000000000000002
> > [  125.657785] R10: 000014e53be57e08 R11: 00000000000185c2 R12: 0000000000000020
> > [  125.657786] R13: 0000000000000003 R14: 0000000000000004 R15: 0000000000000004
> > [  125.657787] FS:  0000000000000000(0000) GS:ffff8801e9c20000(0000) knlGS:0000000000000000
> > [  125.657788] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [  125.657789] CR2: 000000000065600d CR3: 0000000001c21000 CR4: 00000000000007e0
> > [  125.657789] Stack:
> > [  125.657789]  00000003810dc3db ffff8801e9c3c900 ffffffff81d05740 0000001d0becef49
> > [  125.657791]  0000000000000004 ffff880366f0bea8 ffffffff816c1f9a ffffffff81da50c0
> > [  125.657793]  ffff8801e9c3c900 ffffffff81d05740 0000000008004000 ffff880366f0beb8
> > [  125.657794] Call Trace:
> > [  125.657795]  [<ffffffff816c1f9a>] cpuidle_enter_state+0x3a/0xc0
> > [  125.657797]  [<ffffffff816c2107>] cpuidle_enter+0x17/0x20
> > [  125.657799]  [<ffffffff810b99b7>] cpu_idle_loop+0x317/0x460
> > [  125.657801]  [<ffffffff810b9b13>] cpu_startup_entry+0x13/0x20
> > [  125.657803]  [<ffffffff81044b9f>] start_secondary+0x1ff/0x290
> > [  125.657806] Code: c8 00 00 48 89 d1 48 2d c8 3f 00 00 0f 01 c8 65 48 8b 04 25 08 c8 00 00 48 8b 80 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9<65>  48 8b 04 25 08 c8 00 00 f0 80 a0 3a c0 ff ff df 0f ae f0 65
> > [  125.657823] NMI backtrace for cpu 4
> > [  125.657825] CPU: 4 PID: 3023 Comm: fs_mark Not tainted 3.16.0 #1
> > [  125.657825] Hardware name: Intel Corporation S5520UR/S5520UR, BIOS S5500.86B.01.00.0050.050620101605 05/06/2010
> > [  125.657826] task: ffff88007eefbb00 ti: ffff88007ef1c000 task.ti: ffff88007ef1c000
> > [  125.657827] RIP: 0010:[<ffffffff813f8600>]  [<ffffffff813f8600>] delay_tsc+0x60/0x90
> > [  125.657829] RSP: 0018:ffff88036fc43bd8  EFLAGS: 00000007
> > [  125.657830] RAX: 0000000000000268 RBX: 000000003f2c1278 RCX: 0000000000000000
> > [  125.657830] RDX: 000000003f2c14e0 RSI: 0000000000000005 RDI: 0000000000000b6f
> > [  125.657831] RBP: ffff88036fc43bf0 R08: 0000000000000000 R09: 0000000000000046
> > [  125.657831] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000b6f
> > [  125.657832] R13: 0000000000000004 R14: ffffffff81ffc952 R15: 0000000000000039
> > [  125.657833] FS:  0000000001ee0880(0063) GS:ffff88036fc40000(0000) knlGS:0000000000000000
> > [  125.657833] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [  125.657834] CR2: 00007fe629a1c018 CR3: 000000007ef05000 CR4: 00000000000007e0
> > [  125.657834] Stack:
> > [  125.657834]  ffffffff82138c80 000000000000270e 0000000000000020 ffff88036fc43c00
> > [  125.657836]  ffffffff813f8538 ffff88036fc43c28 ffffffff814d02c0 ffffffff82138c80
> > [  125.657837]  0000000000000046 ffffffff81ffc979 ffff88036fc43c48 ffffffff814d04dc
> > [  125.657838] Call Trace:
> > [  125.657838]<IRQ>   [<ffffffff813f8538>] __const_udelay+0x28/0x30
> > [  125.657840]  [<ffffffff814d02c0>] wait_for_xmitr+0x30/0xa0
> > [  125.657844]  [<ffffffff814d04dc>] serial8250_console_putchar+0x1c/0x30
> > [  125.657845]  [<ffffffff814d04c0>] ? serial8250_console_write+0x190/0x190
> > [  125.657846]  [<ffffffff814caf1c>] uart_console_write+0x3c/0x70
> > [  125.657848]  [<ffffffff814d03fe>] serial8250_console_write+0xce/0x190
> > [  125.657849]  [<ffffffff810cbcd3>] call_console_drivers.constprop.24+0xa3/0xf0
> > [  125.657852]  [<ffffffff810cce99>] console_unlock+0x1d9/0x420
> > [  125.657853]  [<ffffffff810cd3f0>] vprintk_emit+0x310/0x580
> > [  125.657854]  [<ffffffff818427fc>] printk+0x4f/0x57
> > [  125.657858]  [<ffffffff810da102>] rcu_check_callbacks+0x412/0x740
> > [  125.657859]  [<ffffffff810a7e92>] ? account_process_tick+0x62/0x170
> > [  125.657864]  [<ffffffff8107ca97>] update_process_times+0x47/0x70
> > [  125.657865]  [<ffffffff810e5105>] tick_sched_handle.isra.18+0x25/0x60
> > [  125.657866]  [<ffffffff810e53a1>] tick_sched_timer+0x41/0x60
> > [  125.657867]  [<ffffffff81096aa7>] __run_hrtimer+0x77/0x1f0
> > [  125.657869]  [<ffffffff810e5360>] ? tick_sched_do_timer+0x60/0x60
> > [  125.657870]  [<ffffffff81096ecf>] hrtimer_interrupt+0xff/0x240
> > [  125.657871]  [<ffffffff81046c9a>] local_apic_timer_interrupt+0x3a/0x60
> > [  125.657872]  [<ffffffff8185238f>] smp_apic_timer_interrupt+0x3f/0x50
> > [  125.657874]  [<ffffffff8185049d>] apic_timer_interrupt+0x6d/0x80
> > [  125.657875]<EOI>   [<ffffffff810c1650>] ? queue_read_lock_slowpath+0x100/0x130
> >
> > Thanks,
> > Fengguang
> 
> The btrfs filesystem had problem using qrwlock. This was a known btrfs 
> problem in 3.16-rc1. The following patch by Chris should have fixed the 
> problem:
> 
>  > commit ea4ebde02e08558b020c4b61bb9a4c0fcf63028e
>  > Author: Chris Mason<clm@fb.com>
>  > Date:   Thu Jun 19 14:16:52 2014 -0700
>  >
>  >      Btrfs: fix deadlocks with trylock on tree nodes
> 
> Was that patch included in your test?
> 

That patch went in 3.16-rc2, so it can be assumed it was included in
the test kernel (3.16.0)

Just from a quick look, two CPUs have deadlocked, both in fsync().
One is trying to write the log:

> > [  125.657289]  [<ffffffff8184ee09>] _raw_read_lock+0x29/0x30
> > [  125.657292]  [<ffffffffa02805cc>] btrfs_clear_lock_blocking_rw+0x4c/0x100 [btrfs]
> > [  125.657307]  [<ffffffffa021fe51>] btrfs_clear_path_blocking+0x41/0x80 [btrfs]
> > [  125.657312]  [<ffffffffa0227f03>] btrfs_search_forward+0x203/0x330 [btrfs]
> > [  125.657318]  [<ffffffffa028707b>] btrfs_log_inode+0x27b/0x920 [btrfs]
> > [  125.657339]  [<ffffffffa0287986>] btrfs_log_inode_parent+0x1d6/0x540 [btrfs]
> > [  125.657349]  [<ffffffffa0288b42>] btrfs_log_dentry_safe+0x42/0x60 [btrfs]
> > [  125.657358]  [<ffffffffa0258da4>] btrfs_sync_file+0x194/0x310 [btrfs]

While the other is trying to do delalloc:

> > [  125.657512]  [<ffffffff8184ed99>] _raw_write_lock+0x29/0x30
> > [  125.657515]  [<ffffffffa0280aa9>] btrfs_tree_lock+0xc9/0x1e0 [btrfs]
> > [  125.657530]  [<ffffffffa022006b>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
> > [  125.657537]  [<ffffffffa02252c9>] btrfs_search_slot+0x939/0xa40 [btrfs]
> > [  125.657554]  [<ffffffffa023c297>] btrfs_lookup_file_extent+0x37/0x40 [btrfs]
> > [  125.657563]  [<ffffffffa025b6ee>] __btrfs_drop_extents+0x16e/0xd80 [btrfs]
> > [  125.657583]  [<ffffffffa024e652>] cow_file_range_inline+0x192/0x590 [btrfs]
> > [  125.657604]  [<ffffffffa024ed38>] cow_file_range+0x2e8/0x410 [btrfs]
> > [  125.657635]  [<ffffffffa024fc44>] run_delalloc_range+0x314/0x340 [btrfs]
> > [  125.657656]  [<ffffffffa026731c>] writepage_delalloc.isra.32+0xec/0x160 [btrfs]
> > [  125.657667]  [<ffffffffa0267ed6>] __extent_writepage+0xb6/0x310 [btrfs]
> > [  125.657678]  [<ffffffffa026848a>] extent_write_cache_pages.isra.27.constprop.49+0x35a/0x410 [btrfs]
> > [  125.657700]  [<ffffffffa026a36d>] extent_writepages+0x4d/0x70 [btrfs]
> > [  125.657723]  [<ffffffffa024a568>] btrfs_writepages+0x28/0x30 [btrfs]
> > [  125.657733]  [<ffffffff81168c0e>] do_writepages+0x1e/0x30
> > [  125.657736]  [<ffffffff8115cb29>] __filemap_fdatawrite_range+0x59/0x60
> > [  125.657738]  [<ffffffff8115cbf3>] filemap_fdatawrite_range+0x13/0x20
> > [  125.657740]  [<ffffffffa0258c5e>] btrfs_sync_file+0x4e/0x310 [btrfs]

