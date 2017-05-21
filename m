Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45774 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752186AbdEUXqR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 May 2017 19:46:17 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:51032 helo=legolas.merlins.org)
        by mail1.merlins.org with esmtps
        (Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.87 #1)
        id 1dCaXu-0007qu-8Z
        for <linux-btrfs@vger.kernel.org>; Sun, 21 May 2017 16:46:04 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
        (envelope-from <marc@merlins.org>)
        id 1dCaXt-00083B-Q8
        for linux-btrfs@vger.kernel.org; Sun, 21 May 2017 16:45:57 -0700
Date: Sun, 21 May 2017 16:45:57 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20170521234557.pu3vs3igdx7mqjzb@merlins.org>
References: <20170521214733.c62v7el4g66jf63x@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170521214733.c62v7el4g66jf63x@merlins.org>
Subject: Re: 4.11.1: cannot btrfs check --repair a filesystem, causes heavy
 memory stalls
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 21, 2017 at 02:47:33PM -0700, Marc MERLIN wrote:
> gargamel:~# btrfs check --repair /dev/mapper/dshelf1
> enabling repair mode
> Checking filesystem on /dev/mapper/dshelf1
> UUID: 36f5079e-ca6c-4855-8639-ccb82695c18d
> checking extents
> 
> This causes a bunch of these:
> btrfs-transacti: page allocation stalls for 23508ms, order:0, mode:0x1400840(GFP_NOFS|__GFP_NOFAIL), nodemask=(null)
> btrfs-transacti cpuset=/ mems_allowed=0
> 
> What's the recommended way out of this and which code is at fault? I can't tell if btrfs is doing memory allocations wrong, or if it's just being undermined by the block layer dying underneath.

I went back to 4.8.10, and similar problem.
It looks like btrfs check exercises the kernel and causes everything to come down to a halt :(

Sadly, I tried a scrub on the same device, and it stalled after 6TB. The scrub process went zombie
and the scrub never succeeded, nor could it be stopped.

What do I try next? My filesystem seems ok when I use it except for that
BUG() crash I just reported a few days ago. I'm willing to believe there is a some problem with it somewhere
but if I can't scrub or check it, it's kind of hard to look into it further 

[ 1090.912073] INFO: task kworker/dying:63 blocked for more than 120 seconds.
[ 1090.933850]       Tainted: G     U          4.8.10-amd64-preempt-sysrq-20161121vb3tj1 #12
[ 1090.959465] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1090.983973] kworker/dying   D ffff9a23424e3d68     0    63      2 0x00000000
[ 1091.006171]  ffff9a23424e3d68 00ff9a213ab32140 ffffffff8dc0d4c0 ffff9a23424dc100
[ 1091.029349]  ffff9a23424e3d50 ffff9a23424e4000 ffff9a234098d064 ffff9a23424dc100
[ 1091.052490]  ffff9a234098d068 00000000ffffffff ffff9a23424e3d80 ffffffff8d6cf1a6
[ 1091.075679] Call Trace:
[ 1091.083882]  [<ffffffff8d6cf1a6>] schedule+0x8b/0xa3
[ 1091.099532]  [<ffffffff8d6cf44b>] schedule_preempt_disabled+0x18/0x24
[ 1091.119518]  [<ffffffff8d6d0841>] __mutex_lock_slowpath+0xce/0x16d
[ 1091.138705]  [<ffffffff8d6d08f7>] mutex_lock+0x17/0x27
[ 1091.154772]  [<ffffffff8d6d08f7>] ? mutex_lock+0x17/0x27
[ 1091.171382]  [<ffffffff8d0da5c6>] acct_process+0x4e/0xe0
[ 1091.187974]  [<ffffffff8d07d401>] ? rescuer_thread+0x24f/0x2d1
[ 1091.206170]  [<ffffffff8d06a5c1>] do_exit+0x3ba/0x97b
[ 1091.222001]  [<ffffffff8d192a8c>] ? kfree+0x7a/0x99
[ 1091.237307]  [<ffffffff8d07d72e>] ? worker_thread+0x2ab/0x2ba
[ 1091.255219]  [<ffffffff8d07d483>] ? rescuer_thread+0x2d1/0x2d1
[ 1091.273390]  [<ffffffff8d081dfb>] kthread+0xbc/0xbc
[ 1091.288672]  [<ffffffff8d6d23df>] ret_from_fork+0x1f/0x40
[ 1091.305524]  [<ffffffff8d081d3f>] ? init_completion+0x24/0x24
[ 1091.323404] INFO: task kworker/u16:4:158 blocked for more than 120 seconds.
[ 1091.344956]       Tainted: G     U          4.8.10-amd64-preempt-sysrq-20161121vb3tj1 #12
[ 1091.370145] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1091.394299] kworker/u16:4   D ffff9a233e607b58     0   158      2 0x00000000
[ 1091.416260] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[ 1091.435259]  ffff9a233e607b58 00ffffff8d0899ae ffff9a21f0c76180 ffff9a233e6021c0
[ 1091.458328]  ffff9a233e607b40 ffff9a233e608000 7fffffffffffffff ffff9a233e6021c0
[ 1091.481385]  ffffffff8d6d1244 ffff9a2317491e68 ffff9a233e607b70 ffffffff8d6cf1a6
[ 1091.504472] Call Trace:
[ 1091.512751]  [<ffffffff8d6d1244>] ? usleep_range+0x65/0x65
[ 1091.530093]  [<ffffffff8d6cf1a6>] schedule+0x8b/0xa3
[ 1091.545833]  [<ffffffff8d6d1287>] schedule_timeout+0x43/0x126
[ 1091.563782]  [<ffffffff8d08a9d3>] ? wake_up_process+0x15/0x17
[ 1091.581707]  [<ffffffff8d6cfb45>] do_wait_for_common+0x123/0x15f
[ 1091.600403]  [<ffffffff8d6cfb45>] ? do_wait_for_common+0x123/0x15f
[ 1091.619625]  [<ffffffff8d08aa1c>] ? wake_up_q+0x47/0x47
[ 1091.635983]  [<ffffffff8d6cfc02>] wait_for_common+0x3b/0x55
[ 1091.653380]  [<ffffffff8d6cfc39>] wait_for_completion+0x1d/0x1f
[ 1091.671811]  [<ffffffff8d28d247>] btrfs_async_run_delayed_refs+0xd3/0xed
[ 1091.692598]  [<ffffffff8d2a5dbe>] __btrfs_end_transaction+0x2a7/0x2dd
[ 1091.712585]  [<ffffffff8d2a5e04>] btrfs_end_transaction+0x10/0x12
[ 1091.731529]  [<ffffffff8d2ad5fa>] btrfs_finish_ordered_io+0x3f7/0x4db
[ 1091.751495]  [<ffffffff8d2ad946>] finish_ordered_fn+0x15/0x17
[ 1091.769372]  [<ffffffff8d2cfd68>] btrfs_scrubparity_helper+0x10e/0x258
[ 1091.789590]  [<ffffffff8d2cff40>] btrfs_endio_write_helper+0xe/0x10
[ 1091.809014]  [<ffffffff8d07d068>] process_one_work+0x186/0x29d
[ 1091.827123]  [<ffffffff8d07d66d>] worker_thread+0x1ea/0x2ba
[ 1091.844438]  [<ffffffff8d07d483>] ? rescuer_thread+0x2d1/0x2d1
[ 1091.862521]  [<ffffffff8d081df3>] kthread+0xb4/0xbc
[ 1091.877718]  [<ffffffff8d6d23df>] ret_from_fork+0x1f/0x40
[ 1091.894476]  [<ffffffff8d081d3f>] ? init_completion+0x24/0x24
[ 1091.912276] INFO: task kworker/u16:5:159 blocked for more than 120 seconds.
[ 1091.933740]       Tainted: G     U          4.8.10-amd64-preempt-sysrq-20161121vb3tj1 #12
[ 1091.958847] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1091.982906] kworker/u16:5   D ffff9a233e60f9c0     0   159      2 0x00000000
[ 1092.004713] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
[ 1092.023611]  ffff9a233e60f9c0 0000000000000246 ffff9a2342fa41c0 ffff9a233e608200
[ 1092.046575]  ffff9a233e60f9a8 ffff9a233e610000 ffff9a213898bd88 ffff9a233052f800
[ 1092.069536]  0000000000000001 0000000000000001 ffff9a233e60f9d8 ffffffff8d6cf1a6
[ 1092.092523] Call Trace:
[ 1092.100496]  [<ffffffff8d6cf1a6>] schedule+0x8b/0xa3
[ 1092.115995]  [<ffffffff8d2d866d>] btrfs_tree_lock+0xd6/0x1fb
[ 1092.133574]  [<ffffffff8d09af6c>] ? wake_up_atomic_t+0x2c/0x2c
[ 1092.151696]  [<ffffffff8d2847ff>] btrfs_search_slot+0x684/0x6fb
[ 1092.170074]  [<ffffffff8d28a364>] lookup_inline_extent_backref+0xf3/0x45b
[ 1092.191060]  [<ffffffff8d190787>] ? cpu_cache_get.isra.44+0xd/0x1d
[ 1092.210225]  [<ffffffff8d0a12c5>] ? __raw_write_unlock+0x11/0x23
[ 1092.228873]  [<ffffffff8d28b994>] __btrfs_free_extent+0x100/0x9ac
[ 1092.247770]  [<ffffffff8d088000>] ? preempt_latency_start+0x34/0x5d
[ 1092.267183]  [<ffffffff8d2e860f>] ? btrfs_merge_delayed_refs+0x90/0x270
[ 1092.287638]  [<ffffffff8d2900fe>] __btrfs_run_delayed_refs+0xa02/0xd13
[ 1092.307818]  [<ffffffff8d190787>] ? cpu_cache_get.isra.44+0xd/0x1d
[ 1092.326947]  [<ffffffff8d291d92>] btrfs_run_delayed_refs+0x86/0x1dc
[ 1092.346331]  [<ffffffff8d291f42>] delayed_ref_async_start+0x5a/0x99
[ 1092.365732]  [<ffffffff8d2cfd68>] btrfs_scrubparity_helper+0x10e/0x258
[ 1092.385888]  [<ffffffff8d2cfef0>] btrfs_extent_refs_helper+0xe/0x10
[ 1092.405244]  [<ffffffff8d07d068>] process_one_work+0x186/0x29d
[ 1092.423312]  [<ffffffff8d07d66d>] worker_thread+0x1ea/0x2ba
[ 1092.440625]  [<ffffffff8d07d483>] ? rescuer_thread+0x2d1/0x2d1
[ 1092.458723]  [<ffffffff8d081df3>] kthread+0xb4/0xbc
[ 1092.473931]  [<ffffffff8d6d23df>] ret_from_fork+0x1f/0x40
[ 1092.490685]  [<ffffffff8d081d3f>] ? init_completion+0x24/0x24
[ 1092.508525] INFO: task kworker/u16:8:162 blocked for more than 120 seconds.
[ 1092.529991]       Tainted: G     U          4.8.10-amd64-preempt-sysrq-20161121vb3tj1 #12
[ 1092.555104] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1092.579194] kworker/u16:8   D ffff9a233e623b58     0   162      2 0x00000000
[ 1092.601033] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[ 1092.619956]  ffff9a233e623b58 00ffffff8d0899ae ffff9a2342f80080 ffff9a233e61a000
[ 1092.642934]  ffff9a233e623b40 ffff9a233e624000 7fffffffffffffff ffff9a233e61a000
[ 1092.665923]  ffffffff8d6d1244 ffff9a2326a0d628 ffff9a233e623b70 ffffffff8d6cf1a6
[ 1092.688901] Call Trace:
[ 1092.696864]  [<ffffffff8d6d1244>] ? usleep_range+0x65/0x65
[ 1092.713931]  [<ffffffff8d6cf1a6>] schedule+0x8b/0xa3
[ 1092.729451]  [<ffffffff8d6d1287>] schedule_timeout+0x43/0x126
[ 1092.747312]  [<ffffffff8d3b7e78>] ? debug_smp_processor_id+0x17/0x19
[ 1092.767021]  [<ffffffff8d08a9d3>] ? wake_up_process+0x15/0x17
[ 1092.784903]  [<ffffffff8d6cfb45>] do_wait_for_common+0x123/0x15f
[ 1092.803533]  [<ffffffff8d6cfb45>] ? do_wait_for_common+0x123/0x15f
[ 1092.822696]  [<ffffffff8d08aa1c>] ? wake_up_q+0x47/0x47
[ 1092.838989]  [<ffffffff8d6cfc02>] wait_for_common+0x3b/0x55
[ 1092.856310]  [<ffffffff8d6cfc39>] wait_for_completion+0x1d/0x1f
[ 1092.874683]  [<ffffffff8d28d247>] btrfs_async_run_delayed_refs+0xd3/0xed
[ 1092.895383]  [<ffffffff8d2a5dbe>] __btrfs_end_transaction+0x2a7/0x2dd
[ 1092.915269]  [<ffffffff8d2a5e04>] btrfs_end_transaction+0x10/0x12
[ 1092.934131]  [<ffffffff8d2ad5fa>] btrfs_finish_ordered_io+0x3f7/0x4db
[ 1092.954047]  [<ffffffff8d088000>] ? preempt_latency_start+0x34/0x5d
[ 1092.973440]  [<ffffffff8d2ad946>] finish_ordered_fn+0x15/0x17
[ 1092.991244]  [<ffffffff8d2cfd68>] btrfs_scrubparity_helper+0x10e/0x258
[ 1093.011384]  [<ffffffff8d07b8c1>] ? pwq_activate_delayed_work+0x4d/0x5b
[ 1093.031800]  [<ffffffff8d2cff40>] btrfs_endio_write_helper+0xe/0x10
[ 1093.051185]  [<ffffffff8d07d068>] process_one_work+0x186/0x29d
[ 1093.069265]  [<ffffffff8d07d66d>] worker_thread+0x1ea/0x2ba
[ 1093.086569]  [<ffffffff8d07d483>] ? rescuer_thread+0x2d1/0x2d1
[ 1093.104632]  [<ffffffff8d081df3>] kthread+0xb4/0xbc
[ 1093.119828]  [<ffffffff8d6d23df>] ret_from_fork+0x1f/0x40
[ 1093.136618]  [<ffffffff8d081d3f>] ? init_completion+0x24/0x24
[ 1093.154411] INFO: task kworker/u16:13:171 blocked for more than 120 seconds.
[ 1093.176141]       Tainted: G     U          4.8.10-amd64-preempt-sysrq-20161121vb3tj1 #12
[ 1093.201248] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1093.225310] kworker/u16:13  D ffff9a233e653b58     0   171      2 0x00000000
[ 1093.247120] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[ 1093.266059]  ffff9a233e653b58 00ffffff8d0899ae ffff9a2342f8a100 ffff9a233e64a240
[ 1093.289050]  ffff9a233e653b40 ffff9a233e654000 7fffffffffffffff ffff9a233e64a240
[ 1093.312035]  ffffffff8d6d1244 ffff9a220b50ac28 ffff9a233e653b70 ffffffff8d6cf1a6
[ 1093.335029] Call Trace:
[ 1093.343008]  [<ffffffff8d6d1244>] ? usleep_range+0x65/0x65
[ 1093.360096]  [<ffffffff8d6cf1a6>] schedule+0x8b/0xa3
[ 1093.375601]  [<ffffffff8d6d1287>] schedule_timeout+0x43/0x126
[ 1093.393490]  [<ffffffff8d3b7e78>] ? debug_smp_processor_id+0x17/0x19
[ 1093.413203]  [<ffffffff8d08a9d3>] ? wake_up_process+0x15/0x17
[ 1093.431075]  [<ffffffff8d6cfb45>] do_wait_for_common+0x123/0x15f
[ 1093.449709]  [<ffffffff8d6cfb45>] ? do_wait_for_common+0x123/0x15f
[ 1093.468870]  [<ffffffff8d08aa1c>] ? wake_up_q+0x47/0x47
[ 1093.485154]  [<ffffffff8d6cfc02>] wait_for_common+0x3b/0x55
[ 1093.502461]  [<ffffffff8d6cfc39>] wait_for_completion+0x1d/0x1f
[ 1093.520811]  [<ffffffff8d28d247>] btrfs_async_run_delayed_refs+0xd3/0xed
[ 1093.541485]  [<ffffffff8d2a5dbe>] __btrfs_end_transaction+0x2a7/0x2dd
[ 1093.561398]  [<ffffffff8d2a5e04>] btrfs_end_transaction+0x10/0x12
[ 1093.580241]  [<ffffffff8d2ad5fa>] btrfs_finish_ordered_io+0x3f7/0x4db
[ 1093.600133]  [<ffffffff8d088000>] ? preempt_latency_start+0x34/0x5d
[ 1093.619502]  [<ffffffff8d2ad946>] finish_ordered_fn+0x15/0x17
[ 1093.637313]  [<ffffffff8d2cfd68>] btrfs_scrubparity_helper+0x10e/0x258
[ 1093.657467]  [<ffffffff8d07b8c1>] ? pwq_activate_delayed_work+0x4d/0x5b
[ 1093.677881]  [<ffffffff8d2cff40>] btrfs_endio_write_helper+0xe/0x10
[ 1093.697254]  [<ffffffff8d07d068>] process_one_work+0x186/0x29d
[ 1093.715324]  [<ffffffff8d07d66d>] worker_thread+0x1ea/0x2ba
[ 1093.732624]  [<ffffffff8d07d483>] ? rescuer_thread+0x2d1/0x2d1
[ 1093.750711]  [<ffffffff8d081df3>] kthread+0xb4/0xbc
[ 1093.765925]  [<ffffffff8d6d23df>] ret_from_fork+0x1f/0x40
[ 1093.782718]  [<ffffffff8d081d3f>] ? init_completion+0x24/0x24
[ 1093.800556] INFO: task kworker/u16:14:172 blocked for more than 120 seconds.
[ 1093.847428] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1093.871538] kworker/u16:14  D ffff9a233e65bb58     0   172      2 0x00000000
[ 1093.893373] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[ 1093.912298]  ffff9a233e65bb58 00ffffff8d0899ae ffffffff8dc0d4c0 ffff9a233e654280
[ 1093.935281]  ffff9a233e65bb40 ffff9a233e65c000 7fffffffffffffff ffff9a233e654280
[ 1093.958274]  ffffffff8d6d1244 ffff9a2318e2e928 ffff9a233e65bb70 ffffffff8d6cf1a6
[ 1093.981288] Call Trace:
[ 1093.989347]  [<ffffffff8d6d1244>] ? usleep_range+0x65/0x65
[ 1094.006469]  [<ffffffff8d6cf1a6>] schedule+0x8b/0xa3
[ 1094.022076]  [<ffffffff8d6d1287>] schedule_timeout+0x43/0x126
[ 1094.039943]  [<ffffffff8d3b7e78>] ? debug_smp_processor_id+0x17/0x19
[ 1094.059628]  [<ffffffff8d08a9d3>] ? wake_up_process+0x15/0x17
[ 1094.077525]  [<ffffffff8d6cfb45>] do_wait_for_common+0x123/0x15f
[ 1094.096215]  [<ffffffff8d6cfb45>] ? do_wait_for_common+0x123/0x15f
[ 1094.115490]  [<ffffffff8d08aa1c>] ? wake_up_q+0x47/0x47
[ 1094.131787]  [<ffffffff8d6cfc02>] wait_for_common+0x3b/0x55
[ 1094.149116]  [<ffffffff8d6cfc39>] wait_for_completion+0x1d/0x1f
[ 1094.167457]  [<ffffffff8d28d247>] btrfs_async_run_delayed_refs+0xd3/0xed
[ 1094.188167]  [<ffffffff8d2a5dbe>] __btrfs_end_transaction+0x2a7/0x2dd
[ 1094.208087]  [<ffffffff8d2a5e04>] btrfs_end_transaction+0x10/0x12
[ 1094.226949]  [<ffffffff8d2ad5fa>] btrfs_finish_ordered_io+0x3f7/0x4db
[ 1094.246856]  [<ffffffff8d088000>] ? preempt_latency_start+0x34/0x5d
[ 1094.266223]  [<ffffffff8d2ad946>] finish_ordered_fn+0x15/0x17
[ 1094.284063]  [<ffffffff8d2cfd68>] btrfs_scrubparity_helper+0x10e/0x258
[ 1094.304354]  [<ffffffff8d07b8c1>] ? pwq_activate_delayed_work+0x4d/0x5b
[ 1094.324809]  [<ffffffff8d2cff40>] btrfs_endio_write_helper+0xe/0x10
[ 1094.344190]  [<ffffffff8d07d068>] process_one_work+0x186/0x29d
[ 1094.362283]  [<ffffffff8d07d66d>] worker_thread+0x1ea/0x2ba
[ 1094.379576]  [<ffffffff8d07d483>] ? rescuer_thread+0x2d1/0x2d1
[ 1094.397667]  [<ffffffff8d081df3>] kthread+0xb4/0xbc
[ 1094.412878]  [<ffffffff8d6d23df>] ret_from_fork+0x1f/0x40
[ 1094.429647]  [<ffffffff8d081d3f>] ? init_completion+0x24/0x24

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
