Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48416 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754096AbeGCH6g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 03:58:36 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 58A9DACE2
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Jul 2018 07:58:35 +0000 (UTC)
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
From: Nikolay Borisov <nborisov@suse.com>
Subject: ac0b4145d662 ("btrfs: scrub: Don't use inode pages for device
 replace") breaking btrfs/100
Message-ID: <68fd4173-100b-ad70-8fdf-92209077f39a@suse.com>
Date: Tue, 3 Jul 2018 10:58:34 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Qu, 

The commit from $SUBJECT breaks btrfs/100. Before that commit this test 
takes around 25 seconds and it succeeds, whereas with this patch applied 
the test is twice as fast but is broken after just a couple of iterations.
 The breake I've observed so far is either lock up of the machine or errors 
in the output. Here is what the lock up looks like: 

[   83.335513] sysrq: SysRq : Show Blocked State
[   83.336199]   task                        PC stack   pid father
[   83.336241] kworker/u12:1   D    0    72      2 0x80000000
[   83.336272] Workqueue: writeback wb_workfn (flush-btrfs-9)
[   83.336279] Call Trace:
[   83.336292]  __schedule+0x220/0x860
[   83.336301]  schedule+0x33/0x90
[   83.336306]  io_schedule+0x16/0x40
[   83.336312]  __lock_page+0x119/0x160
[   83.336319]  ? add_to_page_cache_lru+0xe0/0xe0
[   83.336327]  extent_write_cache_pages+0x374/0x420
[   83.336337]  ? match_held_lock.part.8+0x41/0x130
[   83.336345]  ? __lock_acquire+0x2b6/0x18e0
[   83.336353]  extent_writepages+0x51/0x80
[   83.336361]  btrfs_writepages+0xe/0x10
[   83.336366]  do_writepages+0x48/0xf0
[   83.336370]  ? writeback_sb_inodes+0x132/0x5f0
[   83.336378]  __writeback_single_inode+0x5b/0x730
[   83.336381]  ? __writeback_single_inode+0x5b/0x730
[   83.336388]  writeback_sb_inodes+0x258/0x5f0
[   83.336399]  __writeback_inodes_wb+0x67/0xb0
[   83.336406]  wb_writeback+0x31d/0x570
[   83.336410]  ? mark_held_locks+0x58/0x80
[   83.336425]  wb_workfn+0x23a/0x650
[   83.336511]  ? wb_workfn+0x23a/0x650
[   83.336524]  process_one_work+0x1f7/0x630
[   83.336533]  worker_thread+0x3d/0x3b0
[   83.336540]  kthread+0x129/0x140
[   83.336544]  ? process_one_work+0x630/0x630
[   83.336548]  ? kthread_flush_work_fn+0x20/0x20
[   83.336553]  ret_from_fork+0x3a/0x50
[   83.336580] kworker/u12:3   D    0  1220      2 0x80000000
[   83.336595] Workqueue: btrfs-flush_delalloc btrfs_flush_delalloc_helper
[   83.336605] Call Trace:
[   83.336614]  __schedule+0x220/0x860
[   83.336622]  ? _raw_spin_unlock_irq+0x2c/0x40
[   83.336631]  schedule+0x33/0x90
[   83.336638]  io_schedule+0x16/0x40
[   83.336643]  __lock_page+0x119/0x160
[   83.336649]  ? add_to_page_cache_lru+0xe0/0xe0
[   83.336656]  extent_write_cache_pages+0x374/0x420
[   83.336665]  ? trace_hardirqs_off+0xd/0x10
[   83.336670]  ? _raw_spin_unlock_irqrestore+0x5b/0x60
[   83.336680]  extent_writepages+0x51/0x80
[   83.336687]  btrfs_writepages+0xe/0x10
[   83.336691]  do_writepages+0x48/0xf0
[   83.336701]  __filemap_fdatawrite_range+0x80/0xb0
[   83.336705]  ? normal_work_helper+0x358/0x640
[   83.336709]  ? __filemap_fdatawrite_range+0x80/0xb0
[   83.336716]  filemap_flush+0x1c/0x20
[   83.336720]  btrfs_run_delalloc_work+0x1d/0x50
[   83.336726]  normal_work_helper+0x4e/0x640
[   83.336734]  btrfs_flush_delalloc_helper+0x12/0x20
[   83.336738]  process_one_work+0x1f7/0x630
[   83.336748]  worker_thread+0x3d/0x3b0
[   83.336755]  kthread+0x129/0x140
[   83.336759]  ? process_one_work+0x630/0x630
[   83.336762]  ? kthread_flush_work_fn+0x20/0x20
[   83.336768]  ret_from_fork+0x3a/0x50
[   83.336798] btrfs           D    0  4378   2851 0x00000000
[   83.336805] Call Trace:
[   83.336812]  __schedule+0x220/0x860
[   83.336820]  ? wait_for_common+0x117/0x1f0
[   83.336824]  schedule+0x33/0x90
[   83.336828]  schedule_timeout+0x23a/0x570
[   83.336835]  ? mark_held_locks+0x58/0x80
[   83.336842]  ? _raw_spin_unlock_irq+0x2c/0x40
[   83.336848]  ? wait_for_common+0x117/0x1f0
[   83.336856]  ? trace_hardirqs_on_caller+0x100/0x190
[   83.336864]  ? wait_for_common+0x117/0x1f0
[   83.336868]  wait_for_common+0x13b/0x1f0
[   83.336876]  ? wake_up_q+0x80/0x80
[   83.336884]  wait_for_completion+0x1d/0x20
[   83.336891]  start_delalloc_inodes+0x289/0x360
[   83.336902]  btrfs_start_delalloc_roots+0x1cc/0x2e0
[   83.336913]  btrfs_dev_replace_finishing+0xa8/0x770
[   83.336918]  ? start_transaction+0xa6/0x4c0
[   83.336928]  btrfs_dev_replace_start+0x4fd/0x6f0
[   83.336937]  btrfs_dev_replace_by_ioctl+0x39/0x60
[   83.336941]  btrfs_ioctl+0x2700/0x31c0
[   83.336953]  ? lock_acquire+0xa5/0x230
[   83.336961]  ? do_sigaction+0x122/0x1d0
[   83.336971]  do_vfs_ioctl+0xa6/0x6a0
[   83.336975]  ? _raw_spin_unlock_irq+0x2c/0x40
[   83.336981]  ? do_vfs_ioctl+0xa6/0x6a0
[   83.336986]  ? do_sigaction+0x122/0x1d0
[   83.336993]  ? __might_fault+0x85/0x90
[   83.337003]  ksys_ioctl+0x41/0x70
[   83.337010]  __x64_sys_ioctl+0x1a/0x20
[   83.337016]  do_syscall_64+0x5f/0x1b0
[   83.337020]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

And when it fails the output from dmesg is: http://termbin.com/s6ep
