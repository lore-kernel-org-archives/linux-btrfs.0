Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A46C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 11:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72C3A214DA
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 11:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbfAJLqi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:46:38 -0500
Received: from aquinas.techsquare.com ([75.125.237.226]:51574 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727455AbfAJLqi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 06:46:38 -0500
Received: from sb by techsquare.com with local (Exim 4.71)
        (envelope-from <sb@techsquare.com>)
        id 1ghYnE-0003oq-R1; Thu, 10 Jan 2019 06:46:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23607.12444.740949.683554@techsquare.com>
Date:   Thu, 10 Jan 2019 06:46:36 -0500
To:     Jojo <jojo@automatix.de>, linux-btrfs@vger.kernel.org
Cc:     sb@techsquare.com
Subject: Re: btrfs hang on nfs?
In-Reply-To: <23605.63394.330818.203495@techsquare.com>
References: <23605.54017.819143.292441@techsquare.com>
        <6d8d3b43-dc73-42b8-7c70-2fb8a3b0d98c@automatix.de>
        <23605.63394.330818.203495@techsquare.com>
X-Mailer: VM 8.0.13 under 23.1.1 (x86_64-pc-linux-gnu)
From:   "Scott E. Blomquist" <sb@techsquare.com>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: sb@techsquare.com
X-SA-Exim-Scanned: No (on techsquare.com); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Scott E. Blomquist writes:
 > 
 > Thank you so much, I would have never guessed that.
 > 
 > In my case the scheduler was set to deadline
 > 
 >     cat /sys/block/sd[a-c]/queue/scheduler
 >     noop [deadline] cfq
 >     noop [deadline] cfq
 >     noop [deadline] cfq
 > 
 > I have set it to cfq, I did not see an option for bfq.
 > 
 > I am also building 4.19.13 and will swap that in ASAP.
 > 

Unfortunately the cfq scheduler did not help.  The system wedged.

I did notice this for the first time...

    [Wed Jan  9 06:03:41 2019] BTRFS info (device sda1): the free space cache file (83320273633280) is invalid, skip it

anything I should do about that?

The messages were similar...

    [Wed Jan  9 23:52:04 2019] INFO: task nfsd:2997 blocked for more than 120 seconds.
    [Wed Jan  9 23:52:04 2019]       Not tainted 4.17.14-custom #1
    [Wed Jan  9 23:52:04 2019] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [Wed Jan  9 23:52:04 2019] nfsd            D    0  2997      2 0x80000000
    [Wed Jan  9 23:52:04 2019] Call Trace:
    [Wed Jan  9 23:52:04 2019]  ? __schedule+0x2cf/0x850
    [Wed Jan  9 23:52:04 2019]  ? iput+0x6f/0x1b0
    [Wed Jan  9 23:52:04 2019]  schedule+0x32/0x80
    [Wed Jan  9 23:52:04 2019]  rwsem_down_write_failed+0x1e0/0x350
    [Wed Jan  9 23:52:04 2019]  call_rwsem_down_write_failed+0x13/0x20
    [Wed Jan  9 23:52:04 2019]  down_write+0x29/0x40
    [Wed Jan  9 23:52:04 2019]  btrfs_file_write_iter+0xac/0x570 [btrfs]
    [Wed Jan  9 23:52:04 2019]  ? nfsd_setuser+0x103/0x270 [nfsd]
    [Wed Jan  9 23:52:04 2019]  do_iter_readv_writev+0xff/0x150
    [Wed Jan  9 23:52:04 2019]  do_iter_write+0x78/0x180
    [Wed Jan  9 23:52:04 2019]  nfsd_vfs_write+0xf0/0x440 [nfsd]
    [Wed Jan  9 23:52:04 2019]  nfsd_write+0x84/0x150 [nfsd]
    [Wed Jan  9 23:52:04 2019]  nfsd3_proc_write+0xcc/0x150 [nfsd]
    [Wed Jan  9 23:52:04 2019]  nfsd_dispatch+0xb7/0x250 [nfsd]
    [Wed Jan  9 23:52:04 2019]  svc_process_common+0x382/0x730 [sunrpc]
    [Wed Jan  9 23:52:04 2019]  svc_process+0xeb/0x100 [sunrpc]
    [Wed Jan  9 23:52:04 2019]  nfsd+0xe3/0x150 [nfsd]
    [Wed Jan  9 23:52:04 2019]  kthread+0xf8/0x130
    [Wed Jan  9 23:52:04 2019]  ? nfsd_destroy+0x60/0x60 [nfsd]
    [Wed Jan  9 23:52:04 2019]  ? kthread_bind+0x10/0x10
    [Wed Jan  9 23:52:04 2019]  ret_from_fork+0x35/0x40
... these two were different and at the tail of the dmesg...
    [Wed Jan  9 23:52:05 2019] INFO: task kworker/u18:8:24049 blocked for more than 120 seconds.
    [Wed Jan  9 23:52:05 2019]       Not tainted 4.17.14-custom #1
    [Wed Jan  9 23:52:05 2019] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [Wed Jan  9 23:52:05 2019] kworker/u18:8   D    0 24049      2 0x80000000
    [Wed Jan  9 23:52:05 2019] Workqueue: writeback wb_workfn (flush-btrfs-1)
    [Wed Jan  9 23:52:05 2019] Call Trace:
    [Wed Jan  9 23:52:05 2019]  ? __schedule+0x2cf/0x850
    [Wed Jan  9 23:52:05 2019]  schedule+0x32/0x80
    [Wed Jan  9 23:52:05 2019]  wait_current_trans+0x87/0xd0 [btrfs]
    [Wed Jan  9 23:52:05 2019]  ? wait_woken+0x80/0x80
    [Wed Jan  9 23:52:05 2019]  start_transaction+0x1ef/0x3f0 [btrfs]
    [Wed Jan  9 23:52:05 2019]  find_free_extent+0x104b/0x1060 [btrfs]
    [Wed Jan  9 23:52:05 2019]  ? alloc_debug_processing+0x7a/0x12c
    [Wed Jan  9 23:52:05 2019]  btrfs_reserve_extent+0xf6/0x1f0 [btrfs]
    [Wed Jan  9 23:52:05 2019]  cow_file_range.isra.67+0x119/0x440 [btrfs]
    [Wed Jan  9 23:52:05 2019]  run_delalloc_range+0xff/0x380 [btrfs]
    [Wed Jan  9 23:52:05 2019]  writepage_delalloc+0xfb/0x150 [btrfs]
    [Wed Jan  9 23:52:05 2019]  __extent_writepage+0xdf/0x2b0 [btrfs]
    [Wed Jan  9 23:52:05 2019]  ? invalid_page_referenced_vma+0x90/0x90
    [Wed Jan  9 23:52:05 2019]  extent_write_cache_pages+0x22f/0x3d0 [btrfs]
    [Wed Jan  9 23:52:05 2019]  extent_writepages+0x3f/0x60 [btrfs]
    [Wed Jan  9 23:52:05 2019]  do_writepages+0x1a/0x70
    [Wed Jan  9 23:52:05 2019]  __writeback_single_inode+0x3d/0x340
    [Wed Jan  9 23:52:05 2019]  writeback_sb_inodes+0x224/0x480
    [Wed Jan  9 23:52:05 2019]  __writeback_inodes_wb+0x87/0xb0
    [Wed Jan  9 23:52:05 2019]  wb_writeback+0x258/0x2f0
    [Wed Jan  9 23:52:05 2019]  ? cpumask_next+0x16/0x20
    [Wed Jan  9 23:52:05 2019]  wb_workfn+0x2df/0x430
    [Wed Jan  9 23:52:05 2019]  process_one_work+0x14c/0x350
    [Wed Jan  9 23:52:05 2019]  worker_thread+0x47/0x3e0
    [Wed Jan  9 23:52:05 2019]  kthread+0xf8/0x130
    [Wed Jan  9 23:52:05 2019]  ? rescuer_thread+0x2f0/0x2f0
    [Wed Jan  9 23:52:05 2019]  ? kthread_bind+0x10/0x10
    [Wed Jan  9 23:52:05 2019]  ret_from_fork+0x35/0x40
    [Wed Jan  9 23:54:07 2019] INFO: task dsmc:17747 blocked for more than 120 seconds.
    [Wed Jan  9 23:54:07 2019]       Not tainted 4.17.14-custom #1
    [Wed Jan  9 23:54:07 2019] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [Wed Jan  9 23:54:07 2019] dsmc            D    0 17747      1 0x00000000
    [Wed Jan  9 23:54:07 2019] Call Trace:
    [Wed Jan  9 23:54:07 2019]  ? __schedule+0x2cf/0x850
    [Wed Jan  9 23:54:07 2019]  ? btrfs_set_path_blocking+0x31/0x60 [btrfs]
    [Wed Jan  9 23:54:07 2019]  schedule+0x32/0x80
    [Wed Jan  9 23:54:07 2019]  wait_current_trans+0x87/0xd0 [btrfs]
    [Wed Jan  9 23:54:07 2019]  ? wait_woken+0x80/0x80
    [Wed Jan  9 23:54:07 2019]  start_transaction+0x1ef/0x3f0 [btrfs]
    [Wed Jan  9 23:54:07 2019]  btrfs_dirty_inode+0x49/0xe0 [btrfs]
    [Wed Jan  9 23:54:07 2019]  touch_atime+0x8c/0xb0
    [Wed Jan  9 23:54:07 2019]  iterate_dir+0x10a/0x180
    [Wed Jan  9 23:54:07 2019]  __x64_sys_getdents+0x8e/0x110
    [Wed Jan  9 23:54:07 2019]  ? iterate_dir+0x180/0x180
    [Wed Jan  9 23:54:07 2019]  do_syscall_64+0x55/0x110
    [Wed Jan  9 23:54:07 2019]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [Wed Jan  9 23:54:07 2019] RIP: 0033:0x7f0c982f9215
    [Wed Jan  9 23:54:07 2019] RSP: 002b:00007f0c918a95c0 EFLAGS: 00000246 ORIG_RAX: 000000000000004e
    [Wed Jan  9 23:54:07 2019] RAX: ffffffffffffffda RBX: 00007f0c3f348c60 RCX: 00007f0c982f9215
    [Wed Jan  9 23:54:07 2019] RDX: 0000000000008000 RSI: 00007f0c3f348c60 RDI: 0000000000000007
    [Wed Jan  9 23:54:07 2019] RBP: 00007f0c3f348c60 R08: 00000000000000ff R09: 0000000000001000
    [Wed Jan  9 23:54:07 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000a6672f
    [Wed Jan  9 23:54:07 2019] R13: 00007f0c918affe0 R14: 0000000000000000 R15: 00007f0c918affb0

I did just upgrade to ...

    Linux kanlabfs 4.19.13-custom #1 SMP Wed Jan 9 08:36:50 EST 2019 x86_64 x86_64 x86_64 GNU/Linux

and 

    root@kanlabfs:~/bin# btrfs --version
    btrfs-progs v4.19.1 

We'll see how things go with the new kernel and btrfs progs.

Cheers,

sb. Scott Blomquist
