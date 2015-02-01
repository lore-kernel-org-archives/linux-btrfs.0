Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:20948 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbbBADnS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Jan 2015 22:43:18 -0500
Date: Sat, 31 Jan 2015 19:43:15 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, NeilBrown <neilb@suse.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: __might_sleep() warnings on v3.19-rc6
Message-ID: <20150201034315.GA20124@wfg-t540p.sh.intel.com>
References: <20141028142541.GA19097@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141028142541.GA19097@wfg-t540p.sh.intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I see 2 __might_sleep() warnings on when running LKP tests on
v3.19-rc6, one related to raid5 and another related to btrfs.

They might be exposed by this patch.

commit 8eb23b9f35aae413140d3fda766a98092c21e9b0
Author:     Peter Zijlstra <peterz@infradead.org>

    sched: Debug nested sleeps
    
    Validate we call might_sleep() with TASK_RUNNING, which catches places
    where we nest blocking primitives, eg. mutex usage in a wait loop.
    
    Since all blocking is arranged through task_struct::state, nesting
    this will cause the inner primitive to set TASK_RUNNING and the outer
    will thus not block.
    
    Another observed problem is calling a blocking function from
    schedule()->sched_submit_work()->blk_schedule_flush_plug() which will
    then destroy the task state for the actual __schedule() call that
    comes after it.


dmesg-ivb44:20150129001242:x86_64-rhel:3.19.0-rc6-g26bc420b:1


FSUse%        Count         Size    Files/sec     App Overhead
[   60.691525] ------------[ cut here ]------------
[   60.697499] WARNING: CPU: 0 PID: 1065 at kernel/sched/core.c:7300 __might_sleep+0xbd/0xd0()
[   60.709010] do not call blocking ops when !TASK_RUNNING; state=2 set at [<ffffffff810b63ff>] prepare_to_wait+0x2f/0x90
[   60.721646] Modules linked in: f2fs raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq ipmi_watchdog netconsole sg sd_mod mgag200 syscopyarea sysfillrect isci sysimgblt libsas ttm snd_pcm ahci snd_timer drm_kms_helper scsi_transport_sas libahci snd sb_edac soundcore drm libata edac_core i2c_i801 pcspkr wmi ipmi_si ipmi_msghandler
[   60.759585] CPU: 0 PID: 1065 Comm: kworker/u481:6 Not tainted 3.19.0-rc6-g26bc420b #1
[   60.769025] Hardware name: Intel Corporation S2600WP/S2600WP, BIOS SE5C600.86B.02.02.0002.122320131210 12/23/2013
[   60.781193] Workqueue: writeback bdi_writeback_workfn (flush-9:0)
[   60.788725]  ffffffff81b75d50 ffff88080979b3e8 ffffffff818a38f0 ffff88081ee100f8
[   60.797820]  ffff88080979b438 ffff88080979b428 ffffffff8107260a ffff88080979b428
[   60.806879]  ffffffff81b8c759 00000000000004d9 0000000000000000 0000000063fbe018
[   60.815935] Call Trace:
[   60.819368]  [<ffffffff818a38f0>] dump_stack+0x4c/0x65
[   60.825817]  [<ffffffff8107260a>] warn_slowpath_common+0x8a/0xc0
[   60.833269]  [<ffffffff81072686>] warn_slowpath_fmt+0x46/0x50
[   60.840379]  [<ffffffff810afe95>] ? pick_next_task_fair+0x1b5/0x8d0
[   60.848104]  [<ffffffff810b63ff>] ? prepare_to_wait+0x2f/0x90
[   60.855215]  [<ffffffff810b63ff>] ? prepare_to_wait+0x2f/0x90
[   60.862337]  [<ffffffff8109874d>] __might_sleep+0xbd/0xd0
[   60.869044]  [<ffffffff811c7cd7>] kmem_cache_alloc_trace+0x1d7/0x250
[   60.876830]  [<ffffffff817175d7>] ? bitmap_get_counter+0x117/0x280
[   60.884429]  [<ffffffff817175d7>] bitmap_get_counter+0x117/0x280
[   60.891807]  [<ffffffff810f6d02>] ? __module_text_address+0x12/0x70
[   60.899452]  [<ffffffff81717f54>] bitmap_startwrite+0x74/0x300
[   60.906601]  [<ffffffffa017659a>] add_stripe_bio+0x2aa/0x350 [raid456]
[   60.914518]  [<ffffffffa017d20d>] make_request+0x1dd/0xf30 [raid456]
[   60.922211]  [<ffffffff818aae00>] ? __account_scheduler_latency+0x150/0x370
[   60.930581]  [<ffffffff810b67e0>] ? wait_woken+0xc0/0xc0
[   60.937100]  [<ffffffff8109201f>] ? kthread+0xef/0x110
[   60.943404]  [<ffffffff8170b8c4>] md_make_request+0xf4/0x190
[   60.950277]  [<ffffffff8140fa3d>] ? radix_tree_lookup+0xd/0x10
[   60.957392]  [<ffffffffa027829c>] ? get_node_info+0x8c/0x2b0 [f2fs]
[   60.964937]  [<ffffffff813db848>] generic_make_request+0xd8/0x130
[   60.972291]  [<ffffffff813db908>] submit_bio+0x68/0x160
[   60.978677]  [<ffffffffa0273d58>] __submit_merged_bio+0x48/0x110 [f2fs]
[   60.986622]  [<ffffffffa0274b48>] f2fs_submit_page_mbio+0xa8/0x1f0 [f2fs]
[   60.994817]  [<ffffffffa027f7c0>] write_data_page+0x90/0xc0 [f2fs]
[   61.002272]  [<ffffffffa0276adf>] do_write_data_page+0xdf/0x310 [f2fs]
[   61.010119]  [<ffffffffa0276ee6>] f2fs_write_data_page+0x1d6/0x3e0 [f2fs]
[   61.018275]  [<ffffffffa0273e37>] __f2fs_writepage+0x17/0x50 [f2fs]
[   61.025831]  [<ffffffff811758cc>] write_cache_pages+0x21c/0x4e0
[   61.033003]  [<ffffffff813db848>] ? generic_make_request+0xd8/0x130
[   61.040543]  [<ffffffffa0273e20>] ? __submit_merged_bio+0x110/0x110 [f2fs]
[   61.048843]  [<ffffffffa027481c>] f2fs_write_data_pages+0xac/0x200 [f2fs]
[   61.056969]  [<ffffffff8117777e>] do_writepages+0x1e/0x30
[   61.063506]  [<ffffffff812108f0>] __writeback_single_inode+0x40/0x280
[   61.071217]  [<ffffffff810b6385>] ? wake_up_bit+0x25/0x30
[   61.077763]  [<ffffffff81211b03>] writeback_sb_inodes+0x263/0x410
[   61.085114]  [<ffffffff81211d4f>] __writeback_inodes_wb+0x9f/0xd0
[   61.092423]  [<ffffffff8121220b>] wb_writeback+0x24b/0x300
[   61.099030]  [<ffffffff81214194>] bdi_writeback_workfn+0x1d4/0x470
[   61.106400]  [<ffffffff8108bcc8>] process_one_work+0x158/0x4b0
[   61.113383]  [<ffffffff8108c08b>] worker_thread+0x6b/0x5e0
[   61.119967]  [<ffffffff8108c020>] ? process_one_work+0x4b0/0x4b0
[   61.127117]  [<ffffffff8109201f>] kthread+0xef/0x110
[   61.133102]  [<ffffffff81091f30>] ? kthread_create_on_node+0x180/0x180
[   61.140805]  [<ffffffff818abf7c>] ret_from_fork+0x7c/0xb0
[   61.147269]  [<ffffffff81091f30>] ? kthread_create_on_node+0x180/0x180
[   61.154973] ---[ end trace 2db29906e8050768 ]---
    17        51200      4194304         32.0          2701319

dmesg-lkp-ne04:20150128110549:x86_64-rhel:3.19.0-rc6-g26bc420b:1


FSUse%        Count         Size    Files/sec     App Overhead
[  101.678419] ------------[ cut here ]------------
[  101.684612] WARNING: CPU: 4 PID: 2153 at kernel/sched/core.c:7300 __might_sleep+0xbd/0xd0()
[  101.696412] do not call blocking ops when !TASK_RUNNING; state=2 set at [<ffffffff810b63ff>] prepare_to_wait+0x2f/0x90
[  101.709259] Modules linked in: ipmi_watchdog btrfs sr_mod cdrom xor raid6_pq sg sd_mod snd_pcm snd_timer snd soundcore pcspkr mgag200 syscopyarea sysfillrect sysimgblt ttm ahci drm_kms_helper libahci drm libata usb_storage i2c_i801 ipmi_si ipmi_msghandler i7core_edac edac_core acpi_cpufreq
[  101.741823] CPU: 4 PID: 2153 Comm: fs_mark Not tainted 3.19.0-rc6-g26bc420b #1
[  101.750851] Hardware name: Intel Corporation S5520UR/S5520UR, BIOS S5500.86B.01.00.0050.050620101605 05/06/2010
[  101.763101]  ffffffff81b75d50 ffff8801dd947c78 ffffffff818a38f0 ffff8801e9c500f8
[  101.772473]  ffff8801dd947cc8 ffff8801dd947cb8 ffffffff8107260a 0000000000000004
[  101.781793]  ffffffff81b76780 0000000000000061 0000000000000000 ffff8801e8438000
[  101.791140] Call Trace:
[  101.794751]  [<ffffffff818a38f0>] dump_stack+0x4c/0x65
[  101.801386]  [<ffffffff8107260a>] warn_slowpath_common+0x8a/0xc0
[  101.809003]  [<ffffffff81072686>] warn_slowpath_fmt+0x46/0x50
[  101.816335]  [<ffffffff810b63ff>] ? prepare_to_wait+0x2f/0x90
[  101.823616]  [<ffffffff810b63ff>] ? prepare_to_wait+0x2f/0x90
[  101.830875]  [<ffffffff8109874d>] __might_sleep+0xbd/0xd0
[  101.837766]  [<ffffffff818a9364>] mutex_lock+0x24/0x50
[  101.844399]  [<ffffffffa0285e88>] wait_for_writer+0x68/0xc0 [btrfs]
[  101.853029]  [<ffffffff810b67e0>] ? wait_woken+0xc0/0xc0
[  101.859849]  [<ffffffffa028b918>] btrfs_sync_log+0xf8/0xa70 [btrfs]
[  101.867740]  [<ffffffffa028c7bd>] ? btrfs_log_dentry_safe+0x6d/0x80 [btrfs]
[  101.876395]  [<ffffffffa02605d2>] btrfs_sync_file+0x2f2/0x330 [btrfs]
[  101.884375]  [<ffffffff81218101>] do_fsync+0x51/0x80
[  101.890737]  [<ffffffff81197977>] ? might_fault+0x47/0x50
[  101.897610]  [<ffffffff812183a0>] SyS_fsync+0x10/0x20
[  101.904096]  [<ffffffff818ac029>] system_call_fastpath+0x12/0x17
[  101.911647] ---[ end trace 77681997f1c4e23f ]---
     1        51200         8192        365.3          2076332

Thanks,
Fengguang
