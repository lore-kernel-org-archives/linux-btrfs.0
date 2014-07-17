Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53848 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbaGQCWr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 22:22:47 -0400
Date: Wed, 16 Jul 2014 19:22:41 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
Cc: "Andrew E. Mileski" <andrewm@isoar.ca>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs is  related to OOM death problems on my 8GB server with both 3.15.1 and 3.14?
Message-ID: <20140717022241.GO17093@merlins.org>
References: <CALJXSJr=PayTcA9z0dsuBu0KRoOKMNRRJfqE4mWAgP8cxopdfg@mail.gmail.com> <53C3313B.1080500@cn.fujitsu.com> <20140716155532.GA21186@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140716155532.GA21186@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 16, 2014 at 08:55:32AM -0700, Marc MERLIN wrote:
> On Mon, Jul 14, 2014 at 09:24:11AM +0800, Qu Wenruo wrote:
> > >But generally, is there a tool to locate which kernel function allocated
> > >all that RAM that seems to get allocated and forgotten?
> > This can be done by kernel memleak detection.
> > Location:
> > -> Kernel hacking
> >     -> Memory Debugging
> >         -> Kernel memory leak detector
> > 
> > Then you can check /sys/kernel/debug/memleak to see which function
> > call caused the problem.
> 
> I wanted to report back on this.
> Unfortunately my laptop with 3.15.5 does not stay up more than 30mn,
> sometimes fewer when kmemleak is on. When I turn it off from the boot
> command line, the laptop seems to behave ok.

I forgot to attach the logs of what I get soon after enabling kmemleak:
http://marc.merlins.org/tmp/btrfs_hang_kmemleak.txt

Highlight, first what got logged as stuff started hanging, and later the top
of sysrq-w (look for Sysrq to get to it more quickly)


kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
INFO: task kworker/u16:4:95 blocked for more than 120 seconds.
      Tainted: G           O  3.15.5-amd64-i915-preempt-20140714 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u16:4   D 0000000000000000     0    95      2 0x00000000
Workqueue: btrfs-flush_delalloc normal_work_helper
 ffff880407297b60 0000000000000046 ffff880407297b30 ffff880407297fd8
 ffff8804075f44d0 00000000000141c0 ffff88041e2941c0 ffff8804075f44d0
 ffff880407297c00 0000000000000002 ffffffff810fdda8 ffff880407297b70
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81242aaf>] lock_page+0x1e/0x21
 [<ffffffff812465ba>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
 [<ffffffff810731c8>] ? ttwu_stat+0x97/0xcc
 [<ffffffff8162223d>] ? _raw_spin_unlock_irqrestore+0x1f/0x32
 [<ffffffff81078164>] ? try_to_wake_up+0x1b3/0x1c5
 [<ffffffff81246a18>] extent_writepages+0x4b/0x5c
 [<ffffffff81230d08>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122f2e3>] btrfs_writepages+0x28/0x2a
 [<ffffffff8110873d>] do_writepages+0x1e/0x2c
 [<ffffffff810ff507>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff810fff50>] filemap_flush+0x1c/0x1e
 [<ffffffff81231945>] btrfs_run_delalloc_work+0x32/0x69
 [<ffffffff81252437>] normal_work_helper+0xfe/0x240
 [<ffffffff81065e29>] process_one_work+0x195/0x2d2
 [<ffffffff810660cb>] worker_thread+0x136/0x205
 [<ffffffff81065f95>] ? process_scheduled_works+0x2f/0x2f
 [<ffffffff8106b564>] kthread+0xae/0xb6
 [<ffffffff8106b4b6>] ? __kthread_parkme+0x61/0x61
 [<ffffffff81628d7c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b4b6>] ? __kthread_parkme+0x61/0x61
INFO: task btrfs-transacti:548 blocked for more than 120 seconds.
      Tainted: G           O  3.15.5-amd64-i915-preempt-20140714 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transacti D 0000000000000000     0   548      2 0x00000000
 ffff880404bbfc80 0000000000000046 000000000000e5fc ffff880404bbffd8
 ffff880404bb82d0 00000000000141c0 7fffffffffffffff ffff8802099d2888
 0000000000000002 ffffffff8161f048 7fffffffffffffff ffff880404bbfc90
Call Trace:
 [<ffffffff8161f048>] ? sock_rps_reset_flow+0x37/0x37
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161f081>] schedule_timeout+0x39/0x129
 [<ffffffff810765ed>] ? get_parent_ip+0xd/0x3c
 [<ffffffff81625a8f>] ? preempt_count_add+0x7a/0x8d
 [<ffffffff81620244>] __wait_for_common+0x11a/0x159
 [<ffffffff810781bf>] ? wake_up_state+0x12/0x12
 [<ffffffff816202a7>] wait_for_completion+0x24/0x26
 [<ffffffff8123981f>] btrfs_wait_and_free_delalloc_work+0x16/0x28
 [<ffffffff812417f8>] btrfs_run_ordered_operations+0x1e7/0x21e
 [<ffffffff8122cbad>] btrfs_commit_transaction+0x27/0x8b0
 [<ffffffff8122966a>] transaction_kthread+0xf8/0x1ab
 [<ffffffff81229572>] ? btrfs_cleanup_transaction+0x44c/0x44c
 [<ffffffff8106b564>] kthread+0xae/0xb6
 [<ffffffff8106b4b6>] ? __kthread_parkme+0x61/0x61
 [<ffffffff81628d7c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b4b6>] ? __kthread_parkme+0x61/0x61
INFO: task pidgin:11402 blocked for more than 120 seconds.
      Tainted: G           O  3.15.5-amd64-i915-preempt-20140714 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
pidgin          D 0000000000000006     0 11402   5650 0x00000080
 ffff8803c4307c30 0000000000000082 ffff8803c4307c00 ffff8803c4307fd8
 ffff8803cb684050 00000000000141c0 ffff88041e3941c0 ffff8803cb684050
 ffff8803c4307cd0 0000000000000002 ffffffff810fdda8 ffff8803c4307c40
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81242aaf>] lock_page+0x1e/0x21
 [<ffffffff812465ba>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
 [<ffffffff81246a18>] extent_writepages+0x4b/0x5c
 [<ffffffff81317ac9>] ? debug_smp_processor_id+0x17/0x19
 [<ffffffff81230d08>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122f2e3>] btrfs_writepages+0x28/0x2a
 [<ffffffff8110873d>] do_writepages+0x1e/0x2c
 [<ffffffff810ff507>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff810ff57d>] filemap_fdatawrite_range+0x13/0x15
 [<ffffffff8123a726>] btrfs_sync_file+0x8b/0x2b3
 [<ffffffff8132254e>] ? __percpu_counter_add+0x8c/0xa6
 [<ffffffff8117c02f>] vfs_fsync_range+0x18/0x22
 [<ffffffff8117c055>] vfs_fsync+0x1c/0x1e
 [<ffffffff8117c261>] do_fsync+0x2c/0x4c
 [<ffffffff8117c46a>] SyS_fsync+0x10/0x14
 [<ffffffff81628e2d>] system_call_fastpath+0x1a/0x1f
INFO: task BrowserBlocking:15468 blocked for more than 120 seconds.
      Tainted: G           O  3.15.5-amd64-i915-preempt-20140714 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
BrowserBlocking D 0000000000000000     0 15468  15395 0x00000080
 ffff88038ba6fc30 0000000000000086 ffff88038ba6fc00 ffff88038ba6ffd8
 ffff8800b394c310 00000000000141c0 ffff88041e2141c0 ffff8800b394c310
 ffff88038ba6fcd0 0000000000000002 ffffffff810fdda8 ffff88038ba6fc40
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81242aaf>] lock_page+0x1e/0x21
 [<ffffffff812465ba>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
 [<ffffffff81246a18>] extent_writepages+0x4b/0x5c
 [<ffffffff81230d08>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122f2e3>] btrfs_writepages+0x28/0x2a
 [<ffffffff8110873d>] do_writepages+0x1e/0x2c
 [<ffffffff810ff507>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff810ff57d>] filemap_fdatawrite_range+0x13/0x15
 [<ffffffff8123a726>] btrfs_sync_file+0x8b/0x2b3
 [<ffffffff81158d94>] ? __sb_end_write+0x2d/0x5b
 [<ffffffff8117c02f>] vfs_fsync_range+0x18/0x22
 [<ffffffff8117c055>] vfs_fsync+0x1c/0x1e
 [<ffffffff8117c261>] do_fsync+0x2c/0x4c
 [<ffffffff8117c46a>] SyS_fsync+0x10/0x14
 [<ffffffff81628e2d>] system_call_fastpath+0x1a/0x1f
INFO: task Chrome_DBThread:15469 blocked for more than 120 seconds.
      Tainted: G           O  3.15.5-amd64-i915-preempt-20140714 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Chrome_DBThread D 0000000000000004     0 15469  15395 0x00000080
 ffff8803967afc30 0000000000000086 ffff8803967afc00 ffff8803967affd8
 ffff880395892290 00000000000141c0 ffff88041e3141c0 ffff880395892290
 ffff8803967afcd0 0000000000000002 ffffffff810fdda8 ffff8803967afc40
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81242aaf>] lock_page+0x1e/0x21
 [<ffffffff812465ba>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
 [<ffffffff8111d502>] ? copy_page_to_iter+0x163/0x26b
 [<ffffffff810fdf7d>] ? file_accessed+0x13/0x15
 [<ffffffff81246a18>] extent_writepages+0x4b/0x5c
 [<ffffffff81230d08>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122f2e3>] btrfs_writepages+0x28/0x2a
 [<ffffffff8110873d>] do_writepages+0x1e/0x2c
 [<ffffffff810ff507>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff810ff57d>] filemap_fdatawrite_range+0x13/0x15
 [<ffffffff8123a726>] btrfs_sync_file+0x8b/0x2b3
 [<ffffffff8117c02f>] vfs_fsync_range+0x18/0x22
 [<ffffffff8117c055>] vfs_fsync+0x1c/0x1e
 [<ffffffff8117c261>] do_fsync+0x2c/0x4c
 [<ffffffff8117c481>] SyS_fdatasync+0x13/0x17
 [<ffffffff81628e2d>] system_call_fastpath+0x1a/0x1f
INFO: task Chrome_FileThre:15470 blocked for more than 120 seconds.
      Tainted: G           O  3.15.5-amd64-i915-preempt-20140714 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Chrome_FileThre D 0000000000000005     0 15470  15395 0x00000080
 ffff88038bd7fc30 0000000000000086 ffff88038bd7fc00 ffff88038bd7ffd8
 ffff8803a065c250 00000000000141c0 ffff88041e3541c0 ffff8803a065c250
 ffff88038bd7fcd0 0000000000000002 ffffffff810fdda8 ffff88038bd7fc40
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81242aaf>] lock_page+0x1e/0x21
 [<ffffffff812465ba>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
 [<ffffffff816204bc>] ? mutex_unlock+0x16/0x18
 [<ffffffff8123bb5d>] ? btrfs_file_aio_write+0x3e9/0x4b6
 [<ffffffff81246a18>] extent_writepages+0x4b/0x5c
 [<ffffffff81230d08>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122f2e3>] btrfs_writepages+0x28/0x2a
 [<ffffffff8110873d>] do_writepages+0x1e/0x2c
 [<ffffffff810ff507>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff810ff57d>] filemap_fdatawrite_range+0x13/0x15
 [<ffffffff8123a726>] btrfs_sync_file+0x8b/0x2b3
 [<ffffffff81158d94>] ? __sb_end_write+0x2d/0x5b
 [<ffffffff8117c02f>] vfs_fsync_range+0x18/0x22
 [<ffffffff8117c055>] vfs_fsync+0x1c/0x1e
 [<ffffffff8117c261>] do_fsync+0x2c/0x4c
 [<ffffffff8117c46a>] SyS_fsync+0x10/0x14
 [<ffffffff81628e2d>] system_call_fastpath+0x1a/0x1f
INFO: task IndexedDB:15475 blocked for more than 120 seconds.
      Tainted: G           O  3.15.5-amd64-i915-preempt-20140714 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
IndexedDB       D 0000000000000007     0 15475  15395 0x00000080
 ffff88038ba87c30 0000000000000086 ffff88038ba87c00 ffff88038ba87fd8
 ffff88038bda6150 00000000000141c0 ffff88041e3d41c0 ffff88038bda6150
 ffff88038ba87cd0 0000000000000002 ffffffff810fdda8 ffff88038ba87c40
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81242aaf>] lock_page+0x1e/0x21
 [<ffffffff812465ba>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
 [<ffffffff816204bc>] ? mutex_unlock+0x16/0x18
 [<ffffffff8123bb5d>] ? btrfs_file_aio_write+0x3e9/0x4b6
 [<ffffffff81246a18>] extent_writepages+0x4b/0x5c
 [<ffffffff81230d08>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122f2e3>] btrfs_writepages+0x28/0x2a
 [<ffffffff8110873d>] do_writepages+0x1e/0x2c
 [<ffffffff810ff507>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff810ff57d>] filemap_fdatawrite_range+0x13/0x15
 [<ffffffff8123a743>] btrfs_sync_file+0xa8/0x2b3
 [<ffffffff8132254e>] ? __percpu_counter_add+0x8c/0xa6
 [<ffffffff8117c02f>] vfs_fsync_range+0x18/0x22
 [<ffffffff8117c055>] vfs_fsync+0x1c/0x1e
 [<ffffffff8117c261>] do_fsync+0x2c/0x4c
 [<ffffffff8117c481>] SyS_fdatasync+0x13/0x17
 [<ffffffff81628e2d>] system_call_fastpath+0x1a/0x1f
INFO: task BrowserBlocking:15487 blocked for more than 120 seconds.
      Tainted: G           O  3.15.5-amd64-i915-preempt-20140714 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
BrowserBlocking D ffff8804044d4080     0 15487  15395 0x00000080
 ffff88038ba0bc30 0000000000000086 ffff88038ba0bc00 ffff88038ba0bfd8
 ffff8800b4256350 00000000000141c0 ffff88041e2941c0 ffff8800b4256350
 ffff88038ba0bcd0 0000000000000002 ffffffff810fdda8 ffff88038ba0bc40
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81242aaf>] lock_page+0x1e/0x21
 [<ffffffff812465ba>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
 [<ffffffff8111d38c>] ? pagefault_enable+0xe/0x21
 [<ffffffff8111d502>] ? copy_page_to_iter+0x163/0x26b
 [<ffffffff810fdf7d>] ? file_accessed+0x13/0x15
 [<ffffffff81246a18>] extent_writepages+0xffff8117c02f>] vfs_fsync_range+0x18/0x22
 [<ffffffff8117c055>] vfs_fsync+0x1c/0x1e
 [<ffffffff8117c261>] do_fsync+0x2c/0x4c
 [<ffffffff8117c481>] SyS_fdatasync+0x13/0x17
 [<ffffffff81628e2d>] system_call_fastpath+0x1a/0x1f
INFO: task BrowserBlocking:15501 blocked for more than 120 seconds.
      Tainted: G           O  3.15.5-amd64-i915-preempt-20140714 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
BrowserBlocking D 0000000000000002     0 15501  15395 0x00000080
 ffff8800af733c30 0000000000000086 ffff8800af733c00 ffff8800af733fd8
 ffff8800af73c3d0 00000000000141c0 ffff88041e2941c0 ffff8800af73c3d0
 ffff8800af733cd0 0000000000000002 ffffffff810fdda8 ffff8800af733c40
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81242aaf>] lock_page+0x1e/0x21
 [<ffffffff812465ba>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
 [<ffffffff81246a18>] extent_writepages+0x4b/0x5c
 [<ffffffff81230d08>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122f2e3>] btrfs_writepages+0x28/0x2a
 [<ffffffff8110873d>] do_writepages+0x1e/0x2c
 [<ffffffff810ff507>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff810ff57d>] filemap_fdatawrite_range+0x13/0x15
 [<ffffffff8123a726>] btrfs_sync_file+0x8b/0x2b3
 [<ffffffff81158d94>] ? __sb_end_write+0x2d/0x5b
 [<ffffffff8117c02f>] vfs_fsync_range+0x18/0x22
 [<ffffffff8117c055>] vfs_fsync+0x1c/0x1e
 [<ffffffff8117c261>] do_fsync+0x2c/0x4c
 [<ffffffff8117c46a>] SyS_fsync+0x10/0x14
 [<ffffffff81628e2d>] system_call_fastpath+0x1a/0x1f
INFO: task Chrome_HistoryT:15507 blocked for more than 120 seconds.
      Tainted: G           O  3.15.5-amd64-i915-preempt-20140714 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Chrome_HistoryT D 0000000000000000     0 15507  15395 0x00000080
 ffff88038772fc30 0000000000000086 ffff88038772fc00 ffff88038772ffd8
 ffff88038ba0e1d0 00000000000141c0 ffff88041e2141c0 ffff88038ba0e1d0
 ffff88038772fcd0 0000000000000002 ffffffff810fdda8 ffff88038772fc40
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81242aaf>] lock_page+0x1e/0x21
 [<ffffffff812465ba>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
 [<ffffffff813085a7>] ? radix_tree_lookup_slot+0x10/0x1f
 [<ffffffff810fe4bc>] ? find_get_entry+0x69/0x75
 [<ffffffff810fdf7d>] ? file_accessed+0x13/0x15
 [<ffffffff81246a18>] extent_writepages+0x4b/0x5c
 [<ffffffff81230d08>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122f2e3>] btrfs_writepages+0x28/0x2a
 [<ffffffff8110873d>] do_writepages+0x1e/0x2c
 [<ffffffff810ff507>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff810ff57d>] filemap_fdatawrite_range+0x13/0x15
 [<ffffffff8123a726>] btrfs_sync_file+0x8b/0x2b3
 [<ffffffff8117c02f>] vfs_fsync_range+0x18/0x22
 [<ffffffff8117c055>] vfs_fsync+0x1c/0x1e
 [<ffffffff8117c261>] do_fsync+0x2c/0x4c
 [<ffffffff8117c481>] SyS_fdatasync+0x13/0x17
 [<ffffffff81628e2d>] system_call_fastpath+0x1a/0x1f



SysRq : Show Blocked State
  task                        PC stack   pid father
kworker/u16:4   D 0000000000000000     0    95      2 0x00000000
Workqueue: btrfs-flush_delalloc normal_work_helper
 ffff880407297b60 0000000000000046 ffff880407297b30 ffff880407297fd8
 ffff8804075f44d0 00000000000141c0 ffff88041e2941c0 ffff8804075f44d0
 ffff880407297c00 0000000000000002 ffffffff810fdda8 ffff880407297b70
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81242aaf>] lock_page+0x1e/0x21
 [<ffffffff812465ba>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
 [<ffffffff810731c8>] ? ttwu_stat+0x97/0xcc
 [<ffffffff8162223d>] ? _raw_spin_unlock_irqrestore+0x1f/0x32
 [<ffffffff81078164>] ? try_to_wake_up+0x1b3/0x1c5
 [<ffffffff81246a18>] extent_writepages+0x4b/0x5c
 [<ffffffff81230d08>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122f2e3>] btrfs_writepages+0x28/0x2a
 [<ffffffff8110873d>] do_writepages+0x1e/0x2c
 [<ffffffff810ff507>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff810fff50>] filemap_flush+0x1c/0x1e
 [<ffffffff81231945>] btrfs_run_delalloc_work+0x32/0x69
 [<ffffffff81252437>] normal_work_helper+0xfe/0x240
 [<ffffffff81065e29>] process_one_work+0x195/0x2d2
 [<ffffffff810660cb>] worker_thread+0x136/0x205
 [<ffffffff81065f95>] ? process_scheduled_works+0x2f/0x2f
 [<ffffffff8106b564>] kthread+0xae/0xb6
 [<ffffffff8106b4b6>] ? __kthread_parkme+0x61/0x61
 [<ffffffff81628d7c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b4b6>] ? __kthread_parkme+0x61/0x61
btrfs-transacti D 0000000000000000     0   548      2 0x00000000
 ffff880404bbfc80 0000000000000046 000000000000e5fc ffff880404bbffd8
 ffff880404bb82d0 00000000000141c0 7fffffffffffffff ffff8802099d2888
 0000000000000002 ffffffff8161f048 7fffffffffffffff ffff880404bbfc90
Call Trace:
 [<ffffffff8161f048>] ? sock_rps_reset_flow+0x37/0x37
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161f081>] schedule_timeout+0x39/0x129
 [<ffffffff810765ed>] ? get_parent_ip+0xd/0x3c
 [<ffffffff81625a8f>] ? preempt_count_add+0x7a/0x8d
 [<ffffffff81620244>] __wait_for_common+0x11a/0x159
 [<ffffffff810781bf>] ? wake_up_state+0x12/0x12
 [<ffffffff816202a7>] wait_for_completion+0x24/0x26
 [<ffffffff8123981f>] btrfs_wait_and_free_delalloc_work+0x16/0x28
 [<ffffffff812417f8>] btrfs_run_ordered_operations+0x1e7/0x21e
 [<ffffffff8122cbad>] btrfs_commit_transaction+0x27/0x8b0
 [<ffffffff8122966a>] transaction_kthread+0xf8/0x1ab
 [<ffffffff81229572>] ? btrfs_cleanup_transaction+0x44c/0x44c
 [<ffffffff8106b564>] kthread+0xae/0xb6
 [<ffffffff8106b4b6>] ? __kthread_parkme+0x61/0x61
 [<ffffffff81628d7c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b4b6>] ? __kthread_parkme+0x61/0x61
pidgin          D 0000000000000006     0 11402   5650 0x00000080
 ffff8803c4307c30 0000000000000082 ffff8803c4307c00 ffff8803c4307fd8
 ffff8803cb684050 00000000000141c0 ffff88041e3941c0 ffff8803cb684050
 ffff8803c4307cd0 0000000000000002 ffffffff810fdda8 ffff8803c4307c40
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81242aaf>] lock_page+0x1e/0x21
 [<ffffffff812465ba>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
 [<ffffffff81246a18>] extent_writepages+0x4b/0x5c
 [<ffffffff81317ac9>] ? debug_smp_processor_id+0x17/0x19
 [<ffffffff81230d08>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122f2e3>] btrfs_writepages+0x28/0x2a
 [<ffffffff8110873d>] do_writepages+0x1e/0x2c
 [<ffffffff810ff507>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff810ff57d>] filemap_fdatawrite_range+0x13/0x15
 [<ffffffff8123a726>] btrfs_sync_file+0x8b/0x2b3
 [<ffffffff8132254e>] ? __percpu_counter_add+0x8c/0xa6
 [<ffffffff8117c02f>] vfs_fsync_range+0x18/0x22
 [<ffffffff8117c055>] vfs_fsync+0x1c/0x1e
 [<ffffffff8117c261>] do_fsync+0x2c/0x4c
 [<ffffffff8117c46a>] SyS_fsync+0x10/0x14
 [<ffffffff81628e2d>] system_call_fastpath+0x1a/0x1f
BrowserBlocking D 0000000000000000     0 15468  15395hedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81242aaf>] lock_page+0x1e/0x21
 [<ffffffff812465ba>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
 [<ffffffff8111d502>] ? copy_page_to_iter+0x163/0x26b
 [<ffffffff810fdf7d>] ? file_accessed+0x13/0x15
 [<ffffffff81246a18>] extent_writepages+0x4b/0x5c
 [<ffffffff81230d08>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122f2e3>] btrfs_writepages+0x28/0x2a
 [<ffffffff8110873d>] do_writepages+0x1e/0x2c
 [<ffffffff810ff507>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff810ff57d>] filemap_fdatawrite_range+0x13/0x15
 [<ffffffff8123a726>] btrfs_sync_file+0x8b/0x2b3
 [<ffffffff8117c02f>] vfs_fsync_range+0x18/0x22
 [<ffffffff8117c055>] vfs_fsync+0x1c/0x1e
 [<ffffffff8117c261>] do_fsync+0x2c/0x4c
 [<ffffffff8117c481>] SyS_fdatasync+0x13/0x17
 [<ffffffff81628e2d>] system_call_fastpath+0x1a/0x1f
Chrome_FileThre D 0000000000000005     0 15470  15395 0x00000080
 ffff88038bd7fc30 0000000000000086 ffff88038bd7fc00 ffff88038bd7ffd8
 ffff8803a065c250 00000000000141c0 ffff88041e3541c0 ffff8803a065c250
 ffff88038bd7fcd0 0000000000000002 ffffffff810fdda8 ffff88038bd7fc40
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81242aaf>] lock_page+0x1e/0x21
 [<ffffffff812465ba>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
 [<ffffffff816204bc>] ? mutex_unlock+0x16/0x18
 [<ffffffff8123bb5d>] ? btrfs_file_aio_write+0x3e9/0x4b6
 [<ffffffff81246a18>] extent_writepages+0x4b/0x5c
 [<ffffffff81230d08>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122f2e3>] btrfs_writepages+0x28/0x2a
 [<ffffffff8110873d>] do_writepages+0x1e/0x2c
 [<ffffffff810ff507>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff810ff57d>] filemap_fdatawrite_range+0x13/0x15
 [<ffffffff8123a726>] btrfs_sync_file+0x8b/0x2b3
 [<ffffffff81158d94>] ? __sb_end_write+0x2d/0x5b
 [<ffffffff8117c02f>] vfs_fsync_range+0x18/0x22
 [<ffffffff8117c055>] vfs_fsync+0x1c/0x1e
 [<ffffffff8117c261>] do_fsync+0x2c/0x4c
 [<ffffffff8117c46a>] SyS_fsync+0x10/0x14
 [<ffffffff81628e2d>] system_call_fastpath+0x1a/0x1f
IndexedDB       D 0000000000000007     0 15475  15395 0x00000080
 ffff88038ba87c30 0000000000000086 ffff88038ba87c00 ffff88038ba87fd8
 ffff88038bda6150 00000000000141c0 ffff88041e3d41c0 ffff88038bda6150
 ffff88038ba87cd0 0000000000000002 ffffffff810fdda8 ffff88038ba87c40
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake/0x21
 [<ffffffff8111d502>] ? copy_page_to_iter+0x163/0x26b
 [<ffffffff810fdf7d>] ? file_accessed+0x13/0x15
 [<ffffffff81246a18>] extent_writepages+0x4b/0x5c
 [<ffffffff81230d08>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122f2e3>] btrfs_writepages+0x28/0x2a
 [<ffffffff8110873d>] do_writepages+0x1e/0x2c
 [<ffffffff810ff507>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff810ff57d>] filemap_fdatawrite_range+0x13/0x15
 [<ffffffff8123a743>] btrfs_sync_file+0xa8/0x2b3
 [<ffffffff8117c02f>] vfs_fsync_range+0x18/0x22
 [<ffffffff8117c055>] vfs_fsync+0x1c/0x1e
 [<ffffffff8117c261>] do_fsync+0x2c/0x4c
 [<ffffffff8117c481>] SyS_fdatasync+0x13/0x17
 [<ffffffff81628e2d>] system_call_fastpath+0x1a/0x1f
BrowserBlocking D 0000000000000002     0 15501  15395 0x00000080
 ffff8800af733c30 0000000000000086 ffff8800af733c00 ffff8800af733fd8
 ffff8800af73c3d0 00000000000141c0 ffff88041e2941c0 ffff8800af73c3d0
 ffff8800af733cd0 0000000000000002 ffffffff810fdda8 ffff8800af733c40
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81242aaf>] lock_page+0x1e/0x21
 [<ffffffff812465ba>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
 [<ffffffff81246a18>] extent_writepages+0x4b/0x5c
 [<ffffffff81230d08>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122f2e3>] btrfs_writepages+0x28/0x2a
 [<ffffffff8110873d>] do_writepages+0x1e/0x2c
 [<ffffffff810ff507>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff810ff57d>] filemap_fdatawrite_range+0x13/0x15
 [<ffffffff8123a726>] btrfs_sync_file+0x8b/0x2b3
 [<ffffffff81158d94>] ? __sb_end_write+0x2d/0x5b
 [<ffffffff8117c02f>] vfs_fsync_range+0x18/0x22
 [<ffffffff8117c055>] vfs_fsync+0x1c/0x1e
 [<ffffffff8117c261>] do_fsync+0x2c/0x4c
 [<ffffffff8117c46a>] SyS_fsync+0x10/0x14
 [<ffffffff81628e2d>] system_call_fastpath+0x1a/0x1f
Chrome_HistoryT D 0000000000000000     0 15507  15395 0x00000080
 ffff88038772fc30 0000000000000086 ffff88038772fc00 ffff88038772ffd8
 ffff88038ba0e1d0 00000000000141c0 ffff88041e2141c0 ffff88038ba0e1d0
 ffff88038772fcd0 0000000000000002 ffffffff810fdda8 ffff88038772fc40
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81242aaf>] lock_page+0x1e/0x21
 [<ffffffff812465ba>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
 [<ffffffff813085a7>] ? radix_tree_lookup_slot+0x10/0x1f
 [<ffffffff810fe4bc>] ? find_get_entry+0x69/0x75
 [<ffffffff810fdf7d>] ? file_accessed+0x13/0x15
 [<ffffffff81246a18>] extent_writepages+0x4b/0x5c
 [<ffffffff81230d08>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122f2e3>] btrfs_writepages+0x28/0x2a
 [<ffffffff8110873d>] do_wrrange+0x55/0x57
 [<ffffffff810ff57d>] filemap_fdatawrite_range+0x13/0x15
 [<ffffffff8123a726>] btrfs_sync_file+0x8b/0x2b3
 [<ffffffff8117c02f>] vfs_fsync_range+0x18/0x22
 [<ffffffff8117c055>] vfs_fsync+0x1c/0x1e
 [<ffffffff8117c261>] do_fsync+0x2c/0x4c
 [<ffffffff8117c481>] SyS_fdatasync+0x13/0x17
 [<ffffffff81628e2d>] system_call_fastpath+0x1a/0x1f
kworker/u16:5   D 0000000000000000     0 15410      2 0x00000080
Workqueue: btrfs-delalloc normal_work_helper
 ffff88039b863860 0000000000000046 ffff88039b863830 ffff88039b863fd8
 ffff88039f87a0d0 00000000000141c0 ffff88041e3141c0 ffff88039f87a0d0
 ffff88039b863900 0000000000000002 ffffffff810fdda8 ffff88039b863870
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff810fe757>] lock_page+0x19/0x1c
 [<ffffffff810fe7b3>] find_lock_entry+0x33/0x55
 [<ffffffff810fe7e3>] find_lock_page+0xe/0x1b
 [<ffffffff810feccc>] find_or_create_page+0x31/0x83
 [<ffffffff81260ce7>] io_ctl_prepare_pages+0x49/0x11c
 [<ffffffff81262897>] __load_free_space_cache+0x1be/0x56c
 [<ffffffff81262d2b>] load_free_space_cache+0xe6/0x199
 [<ffffffff810765ed>] ? get_parent_ip+0xd/0x3c
 [<ffffffff81217d49>] cache_block_group+0x1c4/0x343
 [<ffffffff8108489d>] ? finish_wait+0x65/0x65
 [<ffffffff8121c7ed>] find_free_extent+0x391/0x89e
 [<ffffffff8121ce7a>] btrfs_reserve_extent+0x70/0x114
 [<ffffffff81232765>] cow_file_range+0x1b0/0x388
 [<ffffffff81233414>] submit_compressed_extents+0x102/0x40f
 [<ffffffff81152ae3>] ? delete_object_full+0x29/0x2c
 [<ffffffff81231910>] ? async_cow_free+0x24/0x27
 [<ffffffff812337a7>] async_cow_submit+0x86/0x8b
 [<ffffffff812524cd>] normal_work_helper+0x194/0x240
 [<ffffffff81065e29>] process_one_work+0x195/0x2d2
 [<ffffffff810660cb>] worker_thread+0x136/0x205
 [<ffffffff81065f95>] ? process_scheduled_works+0x2f/0x2f
 [<ffffffff8106b564>] kthread+0xae/0xb6
 [<ffffffff8106b4b6>] ? __kthread_parkme+0x61/0x61
 [<ffffffff81628d7c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b4b6>] ? __kthread_parkme+0x61/0x61
kworker/u16:11  D 0000000000000000     0 15419      2 0x00000080
Workqueue: writeback bdi_writeback_workfn (flush-btrfs-1)
 ffff8800b3823a00 0000000000000046 ffff8800b38239d0 ffff8800b3823fd8
 ffff8800b6f60110 00000000000141c0 ffff88041e3541c0 ffff8800b6f60110
 ffff8800b3823aa0 0000000000000002 ffffffff810fdda8 ffff8800b3823a10
Call Trace:
 [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161fa5e>] schedule+0x73/0x75
 [<ffffffff8161fc03>] io_schedule+0x60/0x7a
 [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
 [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fde71>] __lock_page+0x69/0x6b
 [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81242aaf>] lock_page+0x1e/0x21
 [<ffffffff812465ba>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
 [<ffffffff81246a18>] extent_writepages+0x4b/0x5c
 [<ffffffff81230d08>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff81625a8c>] ? preempt_count_add+0x77/0x8d
 [<ffffffff8122f2e3>] btrfs_writepages+0x28/0x2a
 [<ffffffff8110873d>] do_writepages+0x1e/0x2c
 [<ffffffff81177d7f>] __writeback_single_inode+0x7d/0x238
 [<ffffffff81178ab7>] writeback_sb_inodes+0x1eb/0x339
 [<ffffffff81178c79>] __writeback_inodes_wb+0x74/0xb7
 [<ffffffff81178df4>] wb_writeback+0x138/0x293
 [<ffffffff8117942c>] bdi_writeback_workfn+0x19a/0x329
 [<ffffffff8100d047>] ? load_TLS+0xb/0xf
 [<ffffffff81065e29>] process_one_work+0x195/0x2d2
 [<ffffffff810660cb>] worker_thread+0x136/0x205
 [<ffffffff81065f95>] ? process_scheduled_works+0x2f/0x2f
 [<ffffffff8106b564>] kthread+0xae/0xb6
 [<ffffffff8106b4b6>] ? __kthread_parkme+0x61/0x61
 [<ffffffff81628d7c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b4b6>] ? __kthread_parkme+0x61/0x61
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
