Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:52389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726289AbeGKJFp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jul 2018 05:05:45 -0400
Date: Wed, 11 Jul 2018 17:02:20 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <fdmanana@suse.com>
Subject: About hung task on generic/041
Message-ID: <20180711090220.GA21770@fnst.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

When I run generic/041 with v4.18-rc3 (turn on kasan and hung task
detection), btrfs-transaction kthread will trigger the hung task timeout
(stall at wait_event in btrfs_commit_transaction). At the same time, you
can see that xfs_io -c fsync will occupy 100% of the CPU. I am not sure
whether this is a problem. Any suggestion?

[Wed Jul 11 15:50:08 2018] INFO: task btrfs-transacti:1053 blocked for more than 120 seconds.
[Wed Jul 11 15:50:08 2018]       Not tainted 4.18.0-rc3-custom #14
[Wed Jul 11 15:50:08 2018] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Wed Jul 11 15:50:08 2018] btrfs-transacti D    0  1053      2 0x80000000
[Wed Jul 11 15:50:08 2018] Call Trace:
[Wed Jul 11 15:50:08 2018]  ? __schedule+0x5b2/0x1380
[Wed Jul 11 15:50:08 2018]  ? check_flags.part.23+0x240/0x240
[Wed Jul 11 15:50:08 2018]  ? firmware_map_remove+0x187/0x187
[Wed Jul 11 15:50:08 2018]  ? ___preempt_schedule+0x16/0x18
[Wed Jul 11 15:50:08 2018]  ? mark_held_locks+0x6e/0x90
[Wed Jul 11 15:50:08 2018]  ? _raw_spin_unlock_irqrestore+0x59/0x70
[Wed Jul 11 15:50:08 2018]  ? preempt_count_sub+0x14/0xc0
[Wed Jul 11 15:50:08 2018]  ? _raw_spin_unlock_irqrestore+0x46/0x70
[Wed Jul 11 15:50:08 2018]  ? prepare_to_wait_event+0x191/0x410
[Wed Jul 11 15:50:08 2018]  ? prepare_to_wait_exclusive+0x210/0x210
[Wed Jul 11 15:50:08 2018]  ? print_usage_bug+0x3a0/0x3a0
[Wed Jul 11 15:50:08 2018]  ? do_raw_spin_unlock+0x10f/0x1e0
[Wed Jul 11 15:50:08 2018]  ? do_raw_spin_trylock+0x120/0x120
[Wed Jul 11 15:50:08 2018]  schedule+0xca/0x260
[Wed Jul 11 15:50:08 2018]  ? rcu_lockdep_current_cpu_online+0x12b/0x160
[Wed Jul 11 15:50:08 2018]  ? __schedule+0x1380/0x1380
[Wed Jul 11 15:50:08 2018]  ? ___might_sleep+0x126/0x370
[Wed Jul 11 15:50:08 2018]  ? init_wait_entry+0xc7/0x100
[Wed Jul 11 15:50:08 2018]  ? __wake_up_locked_key_bookmark+0x20/0x20
[Wed Jul 11 15:50:08 2018]  ? __btrfs_run_delayed_items+0x1e5/0x280 [btrfs]
[Wed Jul 11 15:50:08 2018]  ? __might_sleep+0x31/0xd0
[Wed Jul 11 15:50:08 2018]  btrfs_commit_transaction+0x122a/0x1640 [btrfs]
[Wed Jul 11 15:50:08 2018]  ? btrfs_apply_pending_changes+0x90/0x90 [btrfs]
[Wed Jul 11 15:50:08 2018]  ? wait_woken+0x150/0x150
[Wed Jul 11 15:50:08 2018]  ? ret_from_fork+0x27/0x50
[Wed Jul 11 15:50:08 2018]  ? ret_from_fork+0x27/0x50
[Wed Jul 11 15:50:08 2018]  ? deref_stack_reg+0xe0/0xe0
[Wed Jul 11 15:50:08 2018]  ? __module_text_address+0x63/0xa0
[Wed Jul 11 15:50:08 2018]  ? preempt_count_sub+0x14/0xc0
[Wed Jul 11 15:50:08 2018]  ? transaction_kthread+0x161/0x240 [btrfs]
[Wed Jul 11 15:50:08 2018]  ? is_module_text_address+0x2b/0x50
[Wed Jul 11 15:50:08 2018]  ? transaction_kthread+0x1d9/0x240 [btrfs]
[Wed Jul 11 15:50:08 2018]  ? kernel_text_address+0x5a/0x100
[Wed Jul 11 15:50:08 2018]  ? deactivate_slab.isra.27+0x64f/0x7a0
[Wed Jul 11 15:50:08 2018]  ? __save_stack_trace+0x82/0x100
[Wed Jul 11 15:50:08 2018]  ? kasan_kmalloc+0x142/0x170
[Wed Jul 11 15:50:08 2018]  ? kmem_cache_alloc+0xfc/0x2e0
[Wed Jul 11 15:50:08 2018]  ? start_transaction+0x596/0x930 [btrfs]
[Wed Jul 11 15:50:08 2018]  ? transaction_kthread+0x1d9/0x240 [btrfs]
[Wed Jul 11 15:50:08 2018]  ? kthread+0x1b9/0x1e0
[Wed Jul 11 15:50:08 2018]  ? ret_from_fork+0x27/0x50
[Wed Jul 11 15:50:08 2018]  ? deactivate_slab.isra.27+0x64f/0x7a0
[Wed Jul 11 15:50:08 2018]  ? mark_lock+0x149/0xa80
[Wed Jul 11 15:50:08 2018]  ? init_object+0x6b/0x80
[Wed Jul 11 15:50:08 2018]  ? print_usage_bug+0x3a0/0x3a0
[Wed Jul 11 15:50:08 2018]  ? ___slab_alloc+0x62a/0x690
[Wed Jul 11 15:50:08 2018]  ? ___slab_alloc+0x62a/0x690
[Wed Jul 11 15:50:08 2018]  ? __lock_is_held+0x8c/0xe0
[Wed Jul 11 15:50:08 2018]  ? start_transaction+0x596/0x930 [btrfs]
[Wed Jul 11 15:50:08 2018]  ? preempt_count_sub+0x14/0xc0
[Wed Jul 11 15:50:08 2018]  ? rcu_lockdep_current_cpu_online+0x12b/0x160
[Wed Jul 11 15:50:08 2018]  ? rcu_oom_callback+0x40/0x40
[Wed Jul 11 15:50:08 2018]  ? __lock_is_held+0x8c/0xe0
[Wed Jul 11 15:50:08 2018]  ? start_transaction+0x596/0x930 [btrfs]
[Wed Jul 11 15:50:08 2018]  ? rcu_read_lock_sched_held+0x8f/0xa0
[Wed Jul 11 15:50:08 2018]  ? btrfs_record_root_in_trans+0x1f/0xa0 [btrfs]
[Wed Jul 11 15:50:08 2018]  ? start_transaction+0x26b/0x930 [btrfs]
[Wed Jul 11 15:50:08 2018]  ? btrfs_commit_transaction+0x1640/0x1640 [btrfs]
[Wed Jul 11 15:50:08 2018]  ? check_flags.part.23+0x240/0x240
[Wed Jul 11 15:50:08 2018]  ? lock_downgrade+0x380/0x380
[Wed Jul 11 15:50:08 2018]  ? do_raw_spin_unlock+0x10f/0x1e0
[Wed Jul 11 15:50:08 2018]  ? do_raw_spin_unlock+0x10f/0x1e0
[Wed Jul 11 15:50:08 2018]  ? do_raw_spin_trylock+0x120/0x120
[Wed Jul 11 15:50:08 2018]  transaction_kthread+0x219/0x240 [btrfs]
[Wed Jul 11 15:50:08 2018]  ? btrfs_cleanup_transaction+0x6f0/0x6f0 [btrfs]
[Wed Jul 11 15:50:08 2018]  kthread+0x1b9/0x1e0
[Wed Jul 11 15:50:08 2018]  ? kthread_flush_work_fn+0x10/0x10
[Wed Jul 11 15:50:08 2018]  ret_from_fork+0x27/0x50
[Wed Jul 11 15:50:08 2018] 
                           Showing all locks held in the system:
[Wed Jul 11 15:50:08 2018] 1 lock held by khungtaskd/72:
[Wed Jul 11 15:50:08 2018]  #0: 000000006461a1cc (rcu_read_lock){....}, at: debug_show_all_locks+0xa9/0x3d0
[Wed Jul 11 15:50:08 2018] 1 lock held by btrfs-transacti/1053:
[Wed Jul 11 15:50:08 2018]  #0: 000000005d73d46a (&fs_info->transaction_kthread_mutex){+.+.}, at: transaction_kthread+0x92/0x240 [btrfs]
[Wed Jul 11 15:50:08 2018] 1 lock held by dmesg/1066:
[Wed Jul 11 15:50:08 2018]  #0: 000000003e5d6fc4 (&user->lock){+.+.}, at: devkmsg_read+0xa5/0x4f0
[Wed Jul 11 15:50:08 2018] 4 locks held by xfs_io/7075:

-- 
Thanks,
Lu


