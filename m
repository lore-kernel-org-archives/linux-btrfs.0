Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45595 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933517AbcHYMJI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 08:09:08 -0400
Subject: Re: [PULL] Btrfs fixes, part 3
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>
References: <cover.1472045668.git.dsterba@suse.com>
 <20160825105439.GA83439@clm-mbp.thefacebook.com>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57BEDEE9.2020607@cn.fujitsu.com>
Date: Thu, 25 Aug 2016 20:04:57 +0800
MIME-Version: 1.0
In-Reply-To: <20160825105439.GA83439@clm-mbp.thefacebook.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi david and chris,

On 08/25/2016 06:54 PM, Chris Mason wrote:
> On Wed, Aug 24, 2016 at 03:42:54PM +0200, David Sterba wrote:
>> Hi,
>>
>> this pull request contains part 2 and adds more that arrived in the 
>> meantime
>> (new fixes or updated versions of patches). Assorted fixes. Please pull,
>> thanks.
>
> Looks like this commit is deadlocking btrfs/071, I'm double checking 
> with it removed:
>
> commit 9711669d602004f7658cf7fe003181de69e5ae6d
> Author: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> Date:   Wed Jul 27 13:50:21 2016 +0800
>
>    btrfs: should block unused block groups deletion work when 
> allocating data space
I've reproduced this issue when running btrfs/071 multiple times, sorry 
again.
Also I have known the reason, currently please ignore this patch.

Regards,
Xiaoguang Wang

>
> There's a lockdep splat:
>
> [  400.354652] run fstests btrfs/013 at 2016-08-24 14:36:41
> [  400.939980] BTRFS: device fsid 6dd1d6e7-e6a7-4754-b1da-6ae12db06087 
> devid 1 transid 3 /dev/vdh
> [  400.982129] BTRFS info (device vdh): disk space caching is enabled
> [  400.983470] BTRFS info (device vdh): has skinny extents
> [  400.984706] BTRFS info (device vdh): flagging fs with big metadata 
> feature
> [  400.993415] BTRFS info (device vdh): creating UUID tree
> [  411.057401] BTRFS info (device vdh): relocating block group 
> 29360128 flags 36
> [  411.080278] BTRFS info (device vdh): found 2 extents
> [  411.092704] BTRFS info (device vdh): relocating block group 
> 20971520 flags 34
> [  411.105887] BTRFS info (device vdh): found 1 extents
> [  411.117528] BTRFS info (device vdh): relocating block group 
> 12582912 flags 1
>
> [  411.119023] =============================================
> [  411.119283] [ INFO: possible recursive locking detected ]
> [  411.119283] 4.8.0-rc3-13125-gff57150 #231 Not tainted
> [  411.119283] ---------------------------------------------
> [  411.119283] btrfs/12261 is trying to acquire lock:
> [  411.119283]  (&fs_info->bg_delete_sem){++++..}, at: 
> [<ffffffffa0a2aeef>] btrfs_alloc_data_chunk_ondemand+0x9f/0x560 [btrfs]
> [  411.119283]               but task is already holding lock:
> [  411.119283]  (&fs_info->bg_delete_sem){++++..}, at: 
> [<ffffffffa0a727e4>] __btrfs_balance+0x374/0xe70 [btrfs]
> [  411.119283]               other info that might help us debug this:
> [  411.119283]  Possible unsafe locking scenario:
>
> [  411.119283]        CPU0
> [  411.119283]        ----
> [  411.119283]   lock(&fs_info->bg_delete_sem);
> [  411.119283]   lock(&fs_info->bg_delete_sem);
> [  411.119283]                *** DEADLOCK ***
>
> [  411.119283]  May be due to missing lock nesting notation
>
> [  411.119283] 6 locks held by btrfs/12261:
> [  411.119283]  #0:  (sb_writers#9){.+.+.+}, at: [<ffffffff8122f273>] 
> __sb_start_write+0xd3/0xf0
> [  411.119283]  #1:  (&fs_info->volume_mutex){+.+.+.}, at: 
> [<ffffffffa0a7db28>] btrfs_ioctl_balance+0x118/0x370 [btrfs]
> [  411.119283]  #2:  (&fs_info->bg_delete_sem){++++..}, at: 
> [<ffffffffa0a727e4>] __btrfs_balance+0x374/0xe70 [btrfs]
> [  411.119283]  #3:  (&fs_info->cleaner_mutex){+.+...}, at: 
> [<ffffffffa0aa620f>] btrfs_relocate_block_group+0x17f/0x2a0 [btrfs]
> [  411.119283]  #4:  (sb_internal){.+.+.+}, at: [<ffffffff8122f231>] 
> __sb_start_write+0x91/0xf0
> [  411.119283]  #5: (&cur_trans->cache_write_mutex){+.+...}, at: 
> [<ffffffffa0a2bf3c>] btrfs_start_dirty_block_groups+0x1ac/0x550 [btrfs]
> [  411.119283]               stack backtrace:
> [  411.119283] CPU: 6 PID: 12261 Comm: btrfs Not tainted 
> 4.8.0-rc3-13125-gff57150 #231
> [  411.119283] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
> BIOS 1.9.0-1.fc24 04/01/2014
> [  411.119283]  0000000000000000 ffff880fd72371f8 ffffffff8149def7 
> 0000000000000007
> [  411.119283]  0000000000000006 ffffffff8256a580 ffff880fe67a5d00 
> ffff880fd72372f8
> [  411.119283]  ffffffff810c6a4b ffff880fd7237308 0000000000000046 
> ffff880fe67a6580
> [  411.119283] Call Trace:
> [  411.119283]  [<ffffffff8149def7>] dump_stack+0x6b/0xa4
> [  411.119283]  [<ffffffff810c6a4b>] __lock_acquire+0x73b/0x1800
> [  411.119283]  [<ffffffffa0a0cc5a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
> [  411.119283]  [<ffffffffa0a0cc5a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
> [  411.119283]  [<ffffffff814bcb47>] ? debug_smp_processor_id+0x17/0x20
> [  411.119283]  [<ffffffff810c7bc9>] lock_acquire+0xb9/0x290
> [  411.119283]  [<ffffffffa0a2aeef>] ? 
> btrfs_alloc_data_chunk_ondemand+0x9f/0x560 [btrfs]
> [  411.119283]  [<ffffffffa0a2aedb>] ? 
> btrfs_alloc_data_chunk_ondemand+0x8b/0x560 [btrfs]
> [  411.119283]  [<ffffffff81992574>] down_read+0x34/0x60
> [  411.119283]  [<ffffffffa0a2aeef>] ? 
> btrfs_alloc_data_chunk_ondemand+0x9f/0x560 [btrfs]
> [  411.119283]  [<ffffffff819942d5>] ? _raw_spin_unlock+0x35/0x60
> [  411.119283]  [<ffffffffa0a2aeef>] 
> btrfs_alloc_data_chunk_ondemand+0x9f/0x560 [btrfs]
> [  411.119283]  [<ffffffffa0a2b619>] ? cache_save_setup+0x1f9/0x390 
> [btrfs]
> [  411.119283]  [<ffffffffa0a2b3f8>] 
> btrfs_check_data_free_space+0x48/0x70 [btrfs]
> [  411.119283]  [<ffffffffa0a2b659>] cache_save_setup+0x239/0x390 [btrfs]
> [  411.119283]  [<ffffffffa0a2c027>] 
> btrfs_start_dirty_block_groups+0x297/0x550 [btrfs]
> [  411.119283]  [<ffffffff810c5f91>] ? 
> trace_hardirqs_on_caller+0x101/0x1d0
> [  411.119283]  [<ffffffff810c5cbe>] ? mark_held_locks+0x6e/0x90
> [  411.119283]  [<ffffffff8198ff7a>] ? 
> __mutex_unlock_slowpath+0x10a/0x1b0
> [  411.119283]  [<ffffffff810c5f91>] ? 
> trace_hardirqs_on_caller+0x101/0x1d0
> [  411.119283]  [<ffffffff8198ff63>] ? __mutex_unlock_slowpath+0xf3/0x1b0
> [  411.119283]  [<ffffffffa0a40a4d>] 
> btrfs_commit_transaction+0x16d/0xd80 [btrfs]
> [  411.119283]  [<ffffffff814bcb23>] ? __this_cpu_preempt_check+0x13/0x20
> [  411.119283]  [<ffffffff810c11a8>] ? percpu_down_read_trylock+0x48/0xa0
> [  411.119283]  [<ffffffff8122f231>] ? __sb_start_write+0x91/0xf0
> [  411.119283]  [<ffffffff8122f231>] ? __sb_start_write+0x91/0xf0
> [  411.119283]  [<ffffffffa0a41b8b>] ? start_transaction+0xab/0x4b0 
> [btrfs]
> [  411.119283]  [<ffffffffa0a9e8d4>] prepare_to_relocate+0xe4/0x110 
> [btrfs]
> [  411.119283]  [<ffffffffa0aa5337>] relocate_block_group+0x47/0x7a0 
> [btrfs]
> [  411.119283]  [<ffffffff810c606d>] ? trace_hardirqs_on+0xd/0x10
> [  411.119283]  [<ffffffff81990791>] ? mutex_lock_nested+0x2b1/0x400
> [  411.119283]  [<ffffffffa0aa620f>] ? 
> btrfs_relocate_block_group+0x17f/0x2a0 [btrfs]
> [  411.119283]  [<ffffffff810c0f23>] ? up_write+0x23/0x50
> [  411.119283]  [<ffffffffa0aa6217>] 
> btrfs_relocate_block_group+0x187/0x2a0 [btrfs]
> [  411.119283]  [<ffffffffa0a71afa>] btrfs_relocate_chunk+0x8a/0x120 
> [btrfs]
> [  411.119283]  [<ffffffffa0a72ee7>] __btrfs_balance+0xa77/0xe70 [btrfs]
> [  411.119283]  [<ffffffff8198ff63>] ? __mutex_unlock_slowpath+0xf3/0x1b0
> [  411.119283]  [<ffffffffa0a736d9>] btrfs_balance+0x3f9/0x690 [btrfs]
> [  411.119283]  [<ffffffffa0a7dd33>] ? btrfs_ioctl_balance+0x323/0x370 
> [btrfs]
> [  411.119283]  [<ffffffff810dcb8f>] ? rcu_read_lock_sched_held+0x4f/0x90
> [  411.119283]  [<ffffffffa0a7d9ff>] ? kzalloc+0xf/0x20 [btrfs]
> [  411.119283]  [<ffffffffa0a7dd33>] btrfs_ioctl_balance+0x323/0x370 
> [btrfs]
> [  411.119283]  [<ffffffff8198df11>] ? __schedule+0x341/0xc00
> [  411.119283]  [<ffffffff81994287>] ? 
> _raw_spin_unlock_irqrestore+0x67/0x80
> [  411.119283]  [<ffffffffa0a852ab>] btrfs_ioctl+0x60b/0x1460 [btrfs]
> [  411.119283]  [<ffffffff8112cfde>] ? __audit_syscall_entry+0xae/0x110
> [  411.119283]  [<ffffffff810f2e2f>] ? current_kernel_time64+0x9f/0xb0
> [  411.119283]  [<ffffffff810c5f91>] ? 
> trace_hardirqs_on_caller+0x101/0x1d0
> [  411.119283]  [<ffffffff810c606d>] ? trace_hardirqs_on+0xd/0x10
> [  411.119283]  [<ffffffff8112cfde>] ? __audit_syscall_entry+0xae/0x110
> [  411.119283]  [<ffffffff81240c38>] vfs_ioctl+0x18/0x30
> [  411.119283]  [<ffffffff8124135e>] do_vfs_ioctl+0x8e/0x670
> [  411.119283]  [<ffffffff8112cfde>] ? __audit_syscall_entry+0xae/0x110
> [  411.119283]  [<ffffffff8112d268>] ? __audit_syscall_exit+0x228/0x2b0
> [  411.119283]  [<ffffffff810024c3>] ? syscall_trace_enter+0x213/0x3e0
> [  411.119283]  [<ffffffff812419d2>] SyS_ioctl+0x92/0xa0
> [  411.119283]  [<ffffffff81003013>] do_syscall_64+0x63/0x130
> [  411.119283]  [<ffffffff8100201a>] ? trace_hardirqs_on_thunk+0x1a/0x1c
> [  411.119283]  [<ffffffff8199451a>] entry_SYSCALL64_slow_path+0x25/0x25
>
> But we make it through btrfs/013 up to btrfs/071 and then:
>
> [ 1721.312198] INFO: task btrfs-cleaner:28544 blocked for more than 
> 120 seconds.
> [ 1721.312995]       Tainted: G        W 4.8.0-rc3-13125-gff57150 #231
> [ 1721.313710] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [ 1721.315255] btrfs-cleaner   D ffff880fd6753b28     0 28544 2 
> 0x00000080
> [ 1721.316148]  ffff880fd6753b28 0000000000000046 0000000000000046 
> 0000000000000000
> [ 1721.316989]  0000000000000246 ffff880f12bdc5c0 ffff880fe476c5c0 
> 0000000000000000
> [ 1721.317832]  ffff880fdb48c500 0000000000000282 0000000000000282 
> 0000000000000000
> [ 1721.318695] Call Trace:
> [ 1721.318857]  [<ffffffff810c606d>] ? trace_hardirqs_on+0xd/0x10
> [ 1721.319445]  [<ffffffff8198eaba>] schedule+0x4a/0xc0
> [ 1721.319945]  [<ffffffffa0a3f07d>] wait_current_trans+0xbd/0x130 
> [btrfs]
> [ 1721.320629]  [<ffffffff810b97f0>] ? woken_wake_function+0x20/0x20
> [ 1721.321308]  [<ffffffff8122f273>] ? __sb_start_write+0xd3/0xf0
> [ 1721.321884]  [<ffffffffa0a41dca>] start_transaction+0x2ea/0x4b0 
> [btrfs]
> [ 1721.322593]  [<ffffffffa0a422d8>] btrfs_start_transaction+0x18/0x20 
> [btrfs]
> [ 1721.323329]  [<ffffffffa0a423ce>] 
> btrfs_start_transaction_fallback_global_rsv+0x2e/0xe0 [btrfs]
> [ 1721.324276]  [<ffffffffa0a182a4>] 
> btrfs_start_trans_remove_block_group+0x84/0xc0 [btrfs]
> [ 1721.325140]  [<ffffffffa0a1e6ac>] 
> btrfs_delete_unused_bgs+0x1fc/0x520 [btrfs]
> [ 1721.325856]  [<ffffffff8198ff63>] ? __mutex_unlock_slowpath+0xf3/0x1b0
> [ 1721.326613]  [<ffffffffa0a36400>] cleaner_kthread+0x1a0/0x1e0 [btrfs]
> [ 1721.327301]  [<ffffffffa0a36260>] ? btree_readpage+0x30/0x30 [btrfs]
> [ 1721.327929]  [<ffffffff8109058e>] kthread+0xde/0x100
> [ 1721.328413]  [<ffffffff8109b015>] ? schedule_tail+0x35/0xf0
> [ 1721.328979]  [<ffffffff8199467f>] ret_from_fork+0x1f/0x40
> [ 1721.329526]  [<ffffffff810904b0>] ? __init_kthread_worker+0x70/0x70
> [ 1721.330165] INFO: lockdep is turned off.
> [ 1721.330499] INFO: task btrfs-transacti:28545 blocked for more than 
> 120 seconds.
> [ 1721.331254]       Tainted: G        W 4.8.0-rc3-13125-gff57150 #231
> [ 1721.331971] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [ 1721.332804] btrfs-transacti D ffff880fd70bfc88     0 28545 2 
> 0x00000080
> [ 1721.333571]  ffff880fd70bfc88 0000000000000046 0000000000000046 
> 0000000000000000
> [ 1721.334411]  0000000000000246 ffff880f12bddd00 ffff880fe84c0000 
> ffff880f00000000
> [ 1721.335299]  ffff880fdb48c500 0000000000000282 0000000000000282 
> 0000000000000000
> [ 1721.336139] Call Trace:
> [ 1721.336298]  [<ffffffff810c606d>] ? trace_hardirqs_on+0xd/0x10
> [ 1721.336855]  [<ffffffff8198eaba>] schedule+0x4a/0xc0
> [ 1721.337348]  [<ffffffffa0a3f07d>] wait_current_trans+0xbd/0x130 
> [btrfs]
> [ 1721.338076]  [<ffffffff810b97f0>] ? woken_wake_function+0x20/0x20
> [ 1721.338684]  [<ffffffffa0a41d3a>] start_transaction+0x25a/0x4b0 
> [btrfs]
> [ 1721.339377]  [<ffffffffa0a41fa7>] 
> btrfs_attach_transaction+0x17/0x20 [btrfs]
> [ 1721.340312]  [<ffffffffa0a3987d>] transaction_kthread+0x19d/0x210 
> [btrfs]
> [ 1721.341142]  [<ffffffffa0a396e0>] ? close_ctree+0x380/0x380 [btrfs]
> [ 1721.341757]  [<ffffffff8109058e>] kthread+0xde/0x100
> [ 1721.342406]  [<ffffffff8109b015>] ? schedule_tail+0x35/0xf0
> [ 1721.343047]  [<ffffffff8199467f>] ret_from_fork+0x1f/0x40
> [ 1721.343553]  [<ffffffff810904b0>] ? __init_kthread_worker+0x70/0x70
> [ 1721.344243] INFO: lockdep is turned off.
> [ 1721.344582] INFO: task fsstress:28551 blocked for more than 120 
> seconds.
> [ 1721.345270]       Tainted: G        W 4.8.0-rc3-13125-gff57150 #231
> [ 1721.345947] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [ 1721.346757] fsstress        D ffff880fd777fc78     0 28551 28548 
> 0x00000080
> [ 1721.347590]  ffff880fd777fc78 0000000000000046 0000000000000046 
> 0000000000000000
> [ 1721.348506]  0000000000000246 ffff880ef7835d00 ffff880fe84845c0 
> 0000000000000000
> [ 1721.349349]  ffff880fdb48c500 0000000000000286 0000000000000286 
> 0000000000000000
> [ 1721.350243] Call Trace:
> [ 1721.350404]  [<ffffffff810c606d>] ? trace_hardirqs_on+0xd/0x10
> [ 1721.350970]  [<ffffffff8198eaba>] schedule+0x4a/0xc0
> [ 1721.351474]  [<ffffffffa0a3f07d>] wait_current_trans+0xbd/0x130 
> [btrfs]
> [ 1721.352178]  [<ffffffff810b97f0>] ? woken_wake_function+0x20/0x20
> [ 1721.352775]  [<ffffffff819900de>] ? mutex_unlock+0xe/0x10
> [ 1721.353349]  [<ffffffffa0a41d3a>] start_transaction+0x25a/0x4b0 
> [btrfs]
> [ 1721.354050]  [<ffffffff81992d15>] ? rwsem_down_read_failed+0xc5/0x120
> [ 1721.354682]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.355368]  [<ffffffffa0a424a7>] 
> btrfs_attach_transaction_barrier+0x27/0x60 [btrfs]
> [ 1721.356210]  [<ffffffffa0a02d6a>] btrfs_sync_fs+0x7a/0x250 [btrfs]
> [ 1721.356813]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.357489]  [<ffffffff81269210>] sync_fs_one_sb+0x20/0x30
> [ 1721.358132]  [<ffffffff8122fe3f>] iterate_supers+0xaf/0xe0
> [ 1721.358889]  [<ffffffff81269705>] sys_sync+0x55/0x90
> [ 1721.359428]  [<ffffffff81003013>] do_syscall_64+0x63/0x130
> [ 1721.360058]  [<ffffffff8100201a>] ? trace_hardirqs_on_thunk+0x1a/0x1c
> [ 1721.360696]  [<ffffffff8199451a>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 1721.361414] INFO: lockdep is turned off.
> [ 1721.361751] INFO: task fsstress:28552 blocked for more than 120 
> seconds.
> [ 1721.362445]       Tainted: G        W 4.8.0-rc3-13125-gff57150 #231
> [ 1721.363210] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [ 1721.364051] fsstress        D ffff880fdb077c78     0 28552 28548 
> 0x00000080
> [ 1721.364793]  ffff880fdb077c78 0000000000000046 0000000000000046 
> 0000000000000000
> [ 1721.365653]  0000000000000246 ffff880ef7830000 ffff880fe84a0000 
> 0000000000000000
> [ 1721.366508]  ffff880fdb48c500 0000000000000286 0000000000000286 
> 0000000000000000
> [ 1721.367362] Call Trace:
> [ 1721.367521]  [<ffffffff810c606d>] ? trace_hardirqs_on+0xd/0x10
> [ 1721.368112]  [<ffffffff8198eaba>] schedule+0x4a/0xc0
> [ 1721.368588]  [<ffffffffa0a3f07d>] wait_current_trans+0xbd/0x130 
> [btrfs]
> [ 1721.369280]  [<ffffffff810b97f0>] ? woken_wake_function+0x20/0x20
> [ 1721.369867]  [<ffffffff819900de>] ? mutex_unlock+0xe/0x10
> [ 1721.370502]  [<ffffffffa0a41d3a>] start_transaction+0x25a/0x4b0 
> [btrfs]
> [ 1721.371221]  [<ffffffff81992d15>] ? rwsem_down_read_failed+0xc5/0x120
> [ 1721.371846]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.372534]  [<ffffffffa0a424a7>] 
> btrfs_attach_transaction_barrier+0x27/0x60 [btrfs]
> [ 1721.373372]  [<ffffffffa0a02d6a>] btrfs_sync_fs+0x7a/0x250 [btrfs]
> [ 1721.373986]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.374649]  [<ffffffff81269210>] sync_fs_one_sb+0x20/0x30
> [ 1721.375291]  [<ffffffff8122fe3f>] iterate_supers+0xaf/0xe0
> [ 1721.375811]  [<ffffffff81269705>] sys_sync+0x55/0x90
> [ 1721.376305]  [<ffffffff81003013>] do_syscall_64+0x63/0x130
> [ 1721.376832]  [<ffffffff8100201a>] ? trace_hardirqs_on_thunk+0x1a/0x1c
> [ 1721.377503]  [<ffffffff8199451a>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 1721.378222] INFO: lockdep is turned off.
> [ 1721.378558] INFO: task fsstress:28553 blocked for more than 120 
> seconds.
> [ 1721.379246]       Tainted: G        W 4.8.0-rc3-13125-gff57150 #231
> [ 1721.379914] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [ 1721.380764] fsstress        D ffff880f198efc78     0 28553 28548 
> 0x00000080
> [ 1721.381599]  ffff880f198efc78 0000000000000046 0000000000000046 
> 0000000000000000
> [ 1721.382452]  0000000000000246 ffff880ef7832e80 ffff880f03029740 
> 0000000000000000
> [ 1721.383302]  ffff880fdb48c500 0000000000000286 0000000000000286 
> 0000000000000000
> [ 1721.384209] Call Trace:
> [ 1721.384368]  [<ffffffff810c606d>] ? trace_hardirqs_on+0xd/0x10
> [ 1721.384932]  [<ffffffff8198eaba>] schedule+0x4a/0xc0
> [ 1721.385436]  [<ffffffffa0a3f07d>] wait_current_trans+0xbd/0x130 
> [btrfs]
> [ 1721.386135]  [<ffffffff810b97f0>] ? woken_wake_function+0x20/0x20
> [ 1721.386723]  [<ffffffff819900de>] ? mutex_unlock+0xe/0x10
> [ 1721.387338]  [<ffffffffa0a41d3a>] start_transaction+0x25a/0x4b0 
> [btrfs]
> [ 1721.388049]  [<ffffffff81992d15>] ? rwsem_down_read_failed+0xc5/0x120
> [ 1721.388675]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.389361]  [<ffffffffa0a424a7>] 
> btrfs_attach_transaction_barrier+0x27/0x60 [btrfs]
> [ 1721.390257]  [<ffffffffa0a02d6a>] btrfs_sync_fs+0x7a/0x250 [btrfs]
> [ 1721.390875]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.391555]  [<ffffffff81269210>] sync_fs_one_sb+0x20/0x30
> [ 1721.392115]  [<ffffffff8122fe3f>] iterate_supers+0xaf/0xe0
> [ 1721.392636]  [<ffffffff81269705>] sys_sync+0x55/0x90
> [ 1721.393192]  [<ffffffff81003013>] do_syscall_64+0x63/0x130
> [ 1721.393710]  [<ffffffff8100201a>] ? trace_hardirqs_on_thunk+0x1a/0x1c
> [ 1721.394376]  [<ffffffff8199451a>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 1721.395038] INFO: lockdep is turned off.
> [ 1721.395378] INFO: task fsstress:28554 blocked for more than 120 
> seconds.
> [ 1721.396076]       Tainted: G        W 4.8.0-rc3-13125-gff57150 #231
> [ 1721.396742] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [ 1721.397572] fsstress        D ffff880fd4953c78     0 28554 28548 
> 0x00000080
> [ 1721.398360]  ffff880fd4953c78 0000000000000046 0000000000000046 
> 0000000000000000
> [ 1721.399295]  0000000000000246 ffff880ef7831740 ffff880fe2fb8000 
> 0000000000000002
> [ 1721.400162]  ffff880fdb48c500 0000000000000286 0000000000000286 
> 0000000000000000
> [ 1721.400983] Call Trace:
> [ 1721.401180]  [<ffffffff810c606d>] ? trace_hardirqs_on+0xd/0x10
> [ 1721.401739]  [<ffffffff8198eaba>] schedule+0x4a/0xc0
> [ 1721.402323]  [<ffffffffa0a3f07d>] wait_current_trans+0xbd/0x130 
> [btrfs]
> [ 1721.402992]  [<ffffffff810b97f0>] ? woken_wake_function+0x20/0x20
> [ 1721.403613]  [<ffffffff819900de>] ? mutex_unlock+0xe/0x10
> [ 1721.404171]  [<ffffffffa0a41d3a>] start_transaction+0x25a/0x4b0 
> [btrfs]
> [ 1721.404824]  [<ffffffff81992d15>] ? rwsem_down_read_failed+0xc5/0x120
> [ 1721.405548]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.406251]  [<ffffffffa0a424a7>] 
> btrfs_attach_transaction_barrier+0x27/0x60 [btrfs]
> [ 1721.407094]  [<ffffffffa0a02d6a>] btrfs_sync_fs+0x7a/0x250 [btrfs]
> [ 1721.407694]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.408427]  [<ffffffff81269210>] sync_fs_one_sb+0x20/0x30
> [ 1721.408954]  [<ffffffff8122fe3f>] iterate_supers+0xaf/0xe0
> [ 1721.409497]  [<ffffffff81269705>] sys_sync+0x55/0x90
> [ 1721.409958]  [<ffffffff81003013>] do_syscall_64+0x63/0x130
> [ 1721.410502]  [<ffffffff8100201a>] ? trace_hardirqs_on_thunk+0x1a/0x1c
> [ 1721.411219]  [<ffffffff8199451a>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 1721.411856] INFO: lockdep is turned off.
> [ 1721.412285] INFO: task fsstress:28555 blocked for more than 120 
> seconds.
> [ 1721.412964]       Tainted: G        W 4.8.0-rc3-13125-gff57150 #231
> [ 1721.413667] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [ 1721.414506] fsstress        D ffff880fc5f93898     0 28555 28548 
> 0x00000080
> [ 1721.415408]  ffff880fc5f93898 0000000000000000 0000000000000000 
> ffff880fc5f938c8
> [ 1721.416280]  0000000000000046 ffff880ef78345c0 ffff880fe2fbdd00 
> ffff880f00000000
> [ 1721.417137]  0000000000000000 0000000000000246 ffffffff00000000 
> 0000000000000000
> [ 1721.417961] Call Trace:
> [ 1721.418156]  [<ffffffff8198eaba>] schedule+0x4a/0xc0
> [ 1721.418614]  [<ffffffff810c606d>] ? trace_hardirqs_on+0xd/0x10
> [ 1721.419206]  [<ffffffff819941fb>] ? _raw_spin_unlock_irq+0x3b/0x60
> [ 1721.419813]  [<ffffffff81992d15>] rwsem_down_read_failed+0xc5/0x120
> [ 1721.420560]  [<ffffffff814aceb8>] 
> call_rwsem_down_read_failed+0x18/0x30
> [ 1721.421261]  [<ffffffff81992582>] down_read+0x42/0x60
> [ 1721.421763]  [<ffffffffa0a2aeef>] ? 
> btrfs_alloc_data_chunk_ondemand+0x9f/0x560 [btrfs]
> [ 1721.422606]  [<ffffffff819942d5>] ? _raw_spin_unlock+0x35/0x60
> [ 1721.423212]  [<ffffffffa0a2aeef>] 
> btrfs_alloc_data_chunk_ondemand+0x9f/0x560 [btrfs]
> [ 1721.424070]  [<ffffffffa0a9470d>] ? 
> btrfs_truncate_free_space_cache+0x17d/0x1d0 [btrfs]
> [ 1721.424901]  [<ffffffffa0a2b3f8>] 
> btrfs_check_data_free_space+0x48/0x70 [btrfs]
> [ 1721.425779]  [<ffffffffa0a2b659>] cache_save_setup+0x239/0x390 [btrfs]
> [ 1721.426486]  [<ffffffffa0a6b564>] ? free_extent_buffer+0x44/0xb0 
> [btrfs]
> [ 1721.427198]  [<ffffffffa0a2b875>] btrfs_setup_space_cache+0xc5/0xe0 
> [btrfs]
> [ 1721.427909]  [<ffffffffa0a3e0ca>] commit_cowonly_roots+0xfa/0x310 
> [btrfs]
> [ 1721.428706]  [<ffffffffa0a3dfb4>] ? commit_fs_roots+0x1b4/0x1d0 
> [btrfs]
> [ 1721.429426]  [<ffffffffa0aba38a>] ? 
> btrfs_qgroup_account_extents+0x4a/0x270 [btrfs]
> [ 1721.430265]  [<ffffffffa0a40ec8>] 
> btrfs_commit_transaction+0x5e8/0xd80 [btrfs]
> [ 1721.431092]  [<ffffffff812065e4>] ? kmem_cache_alloc+0x1f4/0x320
> [ 1721.431685]  [<ffffffffa0a41c0a>] ? start_transaction+0x12a/0x4b0 
> [btrfs]
> [ 1721.432391]  [<ffffffff819900de>] ? mutex_unlock+0xe/0x10
> [ 1721.432911]  [<ffffffffa0a41b8b>] ? start_transaction+0xab/0x4b0 
> [btrfs]
> [ 1721.433610]  [<ffffffff81992d15>] ? rwsem_down_read_failed+0xc5/0x120
> [ 1721.434349]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.434994]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.435667]  [<ffffffffa0a02d81>] btrfs_sync_fs+0x91/0x250 [btrfs]
> [ 1721.436318]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.437040]  [<ffffffff81269210>] sync_fs_one_sb+0x20/0x30
> [ 1721.437563]  [<ffffffff8122fe3f>] iterate_supers+0xaf/0xe0
> [ 1721.438115]  [<ffffffff81269705>] sys_sync+0x55/0x90
> [ 1721.438570]  [<ffffffff81003013>] do_syscall_64+0x63/0x130
> [ 1721.439123]  [<ffffffff8100201a>] ? trace_hardirqs_on_thunk+0x1a/0x1c
> [ 1721.439758]  [<ffffffff8199451a>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 1721.440669] INFO: lockdep is turned off.
> [ 1721.441200] INFO: task fsstress:28556 blocked for more than 120 
> seconds.
> [ 1721.442201]       Tainted: G        W 4.8.0-rc3-13125-gff57150 #231
> [ 1721.443187] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [ 1721.444087] fsstress        D ffff880fd9c7bc78     0 28556 28548 
> 0x00000080
> [ 1721.444842]  ffff880fd9c7bc78 0000000000000046 0000000000000046 
> 0000000000000000
> [ 1721.445707]  0000000000000246 ffff880fe2fbae80 ffff880ef7832e80 
> 0000000000000000
> [ 1721.446568]  ffff880fdb48c500 0000000000000286 0000000000000286 
> 0000000000000000
> [ 1721.447466] Call Trace:
> [ 1721.447626]  [<ffffffff810c606d>] ? trace_hardirqs_on+0xd/0x10
> [ 1721.448208]  [<ffffffff8198eaba>] schedule+0x4a/0xc0
> [ 1721.448674]  [<ffffffffa0a3f07d>] wait_current_trans+0xbd/0x130 
> [btrfs]
> [ 1721.449349]  [<ffffffff810b97f0>] ? woken_wake_function+0x20/0x20
> [ 1721.449913]  [<ffffffff819900de>] ? mutex_unlock+0xe/0x10
> [ 1721.450454]  [<ffffffffa0a41d3a>] start_transaction+0x25a/0x4b0 
> [btrfs]
> [ 1721.451119]  [<ffffffff81992d15>] ? rwsem_down_read_failed+0xc5/0x120
> [ 1721.451727]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.452506]  [<ffffffffa0a424a7>] 
> btrfs_attach_transaction_barrier+0x27/0x60 [btrfs]
> [ 1721.453556]  [<ffffffffa0a02d6a>] btrfs_sync_fs+0x7a/0x250 [btrfs]
> [ 1721.454227]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.454868]  [<ffffffff81269210>] sync_fs_one_sb+0x20/0x30
> [ 1721.455431]  [<ffffffff8122fe3f>] iterate_supers+0xaf/0xe0
> [ 1721.455959]  [<ffffffff81269705>] sys_sync+0x55/0x90
> [ 1721.456450]  [<ffffffff81003013>] do_syscall_64+0x63/0x130
> [ 1721.456982]  [<ffffffff8100201a>] ? trace_hardirqs_on_thunk+0x1a/0x1c
> [ 1721.457653]  [<ffffffff8199451a>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 1721.458327] INFO: lockdep is turned off.
> [ 1721.458666] INFO: task fsstress:28557 blocked for more than 120 
> seconds.
> [ 1721.459371]       Tainted: G        W 4.8.0-rc3-13125-gff57150 #231
> [ 1721.460173] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [ 1721.461042] fsstress        D ffff880f18f67c78     0 28557 28548 
> 0x00000080
> [ 1721.461798]  ffff880f18f67c78 0000000000000046 0000000000000046 
> 0000000000000000
> [ 1721.462663]  0000000000000246 ffff880fe2fb9740 ffff880ef7830000 
> 0000000000000000
> [ 1721.463523]  ffff880fdb48c500 0000000000000286 0000000000000286 
> 0000000000000000
> [ 1721.464393] Call Trace:
> [ 1721.464553]  [<ffffffff810c606d>] ? trace_hardirqs_on+0xd/0x10
> [ 1721.465225]  [<ffffffff8198eaba>] schedule+0x4a/0xc0
> [ 1721.465726]  [<ffffffffa0a3f07d>] wait_current_trans+0xbd/0x130 
> [btrfs]
> [ 1721.466427]  [<ffffffff810b97f0>] ? woken_wake_function+0x20/0x20
> [ 1721.467059]  [<ffffffff819900de>] ? mutex_unlock+0xe/0x10
> [ 1721.467587]  [<ffffffffa0a41d3a>] start_transaction+0x25a/0x4b0 
> [btrfs]
> [ 1721.468365]  [<ffffffff81992d15>] ? rwsem_down_read_failed+0xc5/0x120
> [ 1721.469042]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.469703]  [<ffffffffa0a424a7>] 
> btrfs_attach_transaction_barrier+0x27/0x60 [btrfs]
> [ 1721.470552]  [<ffffffffa0a02d6a>] btrfs_sync_fs+0x7a/0x250 [btrfs]
> [ 1721.471280]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.471947]  [<ffffffff81269210>] sync_fs_one_sb+0x20/0x30
> [ 1721.472502]  [<ffffffff8122fe3f>] iterate_supers+0xaf/0xe0
> [ 1721.473066]  [<ffffffff81269705>] sys_sync+0x55/0x90
> [ 1721.473528]  [<ffffffff81003013>] do_syscall_64+0x63/0x130
> [ 1721.474141]  [<ffffffff8100201a>] ? trace_hardirqs_on_thunk+0x1a/0x1c
> [ 1721.474802]  [<ffffffff8199451a>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 1721.475475] INFO: lockdep is turned off.
> [ 1721.475815] INFO: task fsstress:28558 blocked for more than 120 
> seconds.
> [ 1721.476521]       Tainted: G        W 4.8.0-rc3-13125-gff57150 #231
> [ 1721.477316] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [ 1721.478166] fsstress        D ffff880fdb39bc78     0 28558 28548 
> 0x00000080
> [ 1721.478928]  ffff880fdb39bc78 0000000000000046 0000000000000046 
> 0000000000000000
> [ 1721.479791]  0000000000000246 ffff880fe2fb8000 ffff880fe5c31740 
> 0000000000000000
> [ 1721.480730]  ffff880fdb48c500 0000000000000286 0000000000000286 
> 0000000000000000
> [ 1721.481600] Call Trace:
> [ 1721.481760]  [<ffffffff810c606d>] ? trace_hardirqs_on+0xd/0x10
> [ 1721.482366]  [<ffffffff8198eaba>] schedule+0x4a/0xc0
> [ 1721.482846]  [<ffffffffa0a3f07d>] wait_current_trans+0xbd/0x130 
> [btrfs]
> [ 1721.483620]  [<ffffffff810b97f0>] ? woken_wake_function+0x20/0x20
> [ 1721.484260]  [<ffffffff819900de>] ? mutex_unlock+0xe/0x10
> [ 1721.484794]  [<ffffffffa0a41d3a>] start_transaction+0x25a/0x4b0 
> [btrfs]
> [ 1721.485496]  [<ffffffff81992d15>] ? rwsem_down_read_failed+0xc5/0x120
> [ 1721.486232]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.486917]  [<ffffffffa0a424a7>] 
> btrfs_attach_transaction_barrier+0x27/0x60 [btrfs]
> [ 1721.487769]  [<ffffffffa0a02d6a>] btrfs_sync_fs+0x7a/0x250 [btrfs]
> [ 1721.488427]  [<ffffffff812691f0>] ? iter_file_splice_write+0x400/0x400
> [ 1721.489177]  [<ffffffff81269210>] sync_fs_one_sb+0x20/0x30
> [ 1721.489706]  [<ffffffff8122fe3f>] iterate_supers+0xaf/0xe0
> [ 1721.490268]  [<ffffffff81269705>] sys_sync+0x55/0x90
> [ 1721.490733]  [<ffffffff81003013>] do_syscall_64+0x63/0x130
> [ 1721.491289]  [<ffffffff8100201a>] ? trace_hardirqs_on_thunk+0x1a/0x1c
> [ 1721.491935]  [<ffffffff8199451a>] entry_SYSCALL64_slow_path+0x25/0x25
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



