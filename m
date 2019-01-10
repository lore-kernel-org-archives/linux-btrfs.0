Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B1E0C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 11:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0640214DA
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 11:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbfAJLvr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:51:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:52392 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728484AbfAJLvq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 06:51:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A0EA1AD05;
        Thu, 10 Jan 2019 11:51:44 +0000 (UTC)
Subject: Re: btrfs hang on nfs?
To:     "Scott E. Blomquist" <sb@techsquare.com>, Jojo <jojo@automatix.de>,
        linux-btrfs@vger.kernel.org
References: <23605.54017.819143.292441@techsquare.com>
 <6d8d3b43-dc73-42b8-7c70-2fb8a3b0d98c@automatix.de>
 <23605.63394.330818.203495@techsquare.com>
 <23607.12444.740949.683554@techsquare.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <f95b63e3-9da5-ea60-3b4c-fbdf223f439c@suse.com>
Date:   Thu, 10 Jan 2019 13:51:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <23607.12444.740949.683554@techsquare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10.01.19 г. 13:46 ч., Scott E. Blomquist wrote:
> 
> Scott E. Blomquist writes:
>  > 
>  > Thank you so much, I would have never guessed that.
>  > 
>  > In my case the scheduler was set to deadline
>  > 
>  >     cat /sys/block/sd[a-c]/queue/scheduler
>  >     noop [deadline] cfq
>  >     noop [deadline] cfq
>  >     noop [deadline] cfq
>  > 
>  > I have set it to cfq, I did not see an option for bfq.
>  > 
>  > I am also building 4.19.13 and will swap that in ASAP.
>  > 
> 
> Unfortunately the cfq scheduler did not help.  The system wedged.
> 
> I did notice this for the first time...
> 
>     [Wed Jan  9 06:03:41 2019] BTRFS info (device sda1): the free space cache file (83320273633280) is invalid, skip it

What you could do is mount btrfs with -o clear_cache to make btrfs
rebuild the freespace cache.

> 
> anything I should do about that?
> 
> The messages were similar...
> 
>     [Wed Jan  9 23:52:04 2019] INFO: task nfsd:2997 blocked for more than 120 seconds.
>     [Wed Jan  9 23:52:04 2019]       Not tainted 4.17.14-custom #1
>     [Wed Jan  9 23:52:04 2019] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>     [Wed Jan  9 23:52:04 2019] nfsd            D    0  2997      2 0x80000000
>     [Wed Jan  9 23:52:04 2019] Call Trace:
>     [Wed Jan  9 23:52:04 2019]  ? __schedule+0x2cf/0x850
>     [Wed Jan  9 23:52:04 2019]  ? iput+0x6f/0x1b0
>     [Wed Jan  9 23:52:04 2019]  schedule+0x32/0x80
>     [Wed Jan  9 23:52:04 2019]  rwsem_down_write_failed+0x1e0/0x350
>     [Wed Jan  9 23:52:04 2019]  call_rwsem_down_write_failed+0x13/0x20
>     [Wed Jan  9 23:52:04 2019]  down_write+0x29/0x40
>     [Wed Jan  9 23:52:04 2019]  btrfs_file_write_iter+0xac/0x570 [btrfs]
>     [Wed Jan  9 23:52:04 2019]  ? nfsd_setuser+0x103/0x270 [nfsd]
>     [Wed Jan  9 23:52:04 2019]  do_iter_readv_writev+0xff/0x150
>     [Wed Jan  9 23:52:04 2019]  do_iter_write+0x78/0x180
>     [Wed Jan  9 23:52:04 2019]  nfsd_vfs_write+0xf0/0x440 [nfsd]
>     [Wed Jan  9 23:52:04 2019]  nfsd_write+0x84/0x150 [nfsd]
>     [Wed Jan  9 23:52:04 2019]  nfsd3_proc_write+0xcc/0x150 [nfsd]
>     [Wed Jan  9 23:52:04 2019]  nfsd_dispatch+0xb7/0x250 [nfsd]
>     [Wed Jan  9 23:52:04 2019]  svc_process_common+0x382/0x730 [sunrpc]
>     [Wed Jan  9 23:52:04 2019]  svc_process+0xeb/0x100 [sunrpc]
>     [Wed Jan  9 23:52:04 2019]  nfsd+0xe3/0x150 [nfsd]
>     [Wed Jan  9 23:52:04 2019]  kthread+0xf8/0x130
>     [Wed Jan  9 23:52:04 2019]  ? nfsd_destroy+0x60/0x60 [nfsd]
>     [Wed Jan  9 23:52:04 2019]  ? kthread_bind+0x10/0x10
>     [Wed Jan  9 23:52:04 2019]  ret_from_fork+0x35/0x40
> ... these two were different and at the tail of the dmesg...
>     [Wed Jan  9 23:52:05 2019] INFO: task kworker/u18:8:24049 blocked for more than 120 seconds.
>     [Wed Jan  9 23:52:05 2019]       Not tainted 4.17.14-custom #1
>     [Wed Jan  9 23:52:05 2019] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>     [Wed Jan  9 23:52:05 2019] kworker/u18:8   D    0 24049      2 0x80000000
>     [Wed Jan  9 23:52:05 2019] Workqueue: writeback wb_workfn (flush-btrfs-1)
>     [Wed Jan  9 23:52:05 2019] Call Trace:
>     [Wed Jan  9 23:52:05 2019]  ? __schedule+0x2cf/0x850
>     [Wed Jan  9 23:52:05 2019]  schedule+0x32/0x80
>     [Wed Jan  9 23:52:05 2019]  wait_current_trans+0x87/0xd0 [btrfs]
>     [Wed Jan  9 23:52:05 2019]  ? wait_woken+0x80/0x80
>     [Wed Jan  9 23:52:05 2019]  start_transaction+0x1ef/0x3f0 [btrfs]
>     [Wed Jan  9 23:52:05 2019]  find_free_extent+0x104b/0x1060 [btrfs]
>     [Wed Jan  9 23:52:05 2019]  ? alloc_debug_processing+0x7a/0x12c
>     [Wed Jan  9 23:52:05 2019]  btrfs_reserve_extent+0xf6/0x1f0 [btrfs]
>     [Wed Jan  9 23:52:05 2019]  cow_file_range.isra.67+0x119/0x440 [btrfs]
>     [Wed Jan  9 23:52:05 2019]  run_delalloc_range+0xff/0x380 [btrfs]
>     [Wed Jan  9 23:52:05 2019]  writepage_delalloc+0xfb/0x150 [btrfs]
>     [Wed Jan  9 23:52:05 2019]  __extent_writepage+0xdf/0x2b0 [btrfs]
>     [Wed Jan  9 23:52:05 2019]  ? invalid_page_referenced_vma+0x90/0x90
>     [Wed Jan  9 23:52:05 2019]  extent_write_cache_pages+0x22f/0x3d0 [btrfs]
>     [Wed Jan  9 23:52:05 2019]  extent_writepages+0x3f/0x60 [btrfs]
>     [Wed Jan  9 23:52:05 2019]  do_writepages+0x1a/0x70
>     [Wed Jan  9 23:52:05 2019]  __writeback_single_inode+0x3d/0x340
>     [Wed Jan  9 23:52:05 2019]  writeback_sb_inodes+0x224/0x480
>     [Wed Jan  9 23:52:05 2019]  __writeback_inodes_wb+0x87/0xb0
>     [Wed Jan  9 23:52:05 2019]  wb_writeback+0x258/0x2f0
>     [Wed Jan  9 23:52:05 2019]  ? cpumask_next+0x16/0x20
>     [Wed Jan  9 23:52:05 2019]  wb_workfn+0x2df/0x430
>     [Wed Jan  9 23:52:05 2019]  process_one_work+0x14c/0x350
>     [Wed Jan  9 23:52:05 2019]  worker_thread+0x47/0x3e0
>     [Wed Jan  9 23:52:05 2019]  kthread+0xf8/0x130
>     [Wed Jan  9 23:52:05 2019]  ? rescuer_thread+0x2f0/0x2f0
>     [Wed Jan  9 23:52:05 2019]  ? kthread_bind+0x10/0x10
>     [Wed Jan  9 23:52:05 2019]  ret_from_fork+0x35/0x40
>     [Wed Jan  9 23:54:07 2019] INFO: task dsmc:17747 blocked for more than 120 seconds.
>     [Wed Jan  9 23:54:07 2019]       Not tainted 4.17.14-custom #1
>     [Wed Jan  9 23:54:07 2019] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>     [Wed Jan  9 23:54:07 2019] dsmc            D    0 17747      1 0x00000000
>     [Wed Jan  9 23:54:07 2019] Call Trace:
>     [Wed Jan  9 23:54:07 2019]  ? __schedule+0x2cf/0x850
>     [Wed Jan  9 23:54:07 2019]  ? btrfs_set_path_blocking+0x31/0x60 [btrfs]
>     [Wed Jan  9 23:54:07 2019]  schedule+0x32/0x80
>     [Wed Jan  9 23:54:07 2019]  wait_current_trans+0x87/0xd0 [btrfs]
>     [Wed Jan  9 23:54:07 2019]  ? wait_woken+0x80/0x80
>     [Wed Jan  9 23:54:07 2019]  start_transaction+0x1ef/0x3f0 [btrfs]
>     [Wed Jan  9 23:54:07 2019]  btrfs_dirty_inode+0x49/0xe0 [btrfs]
>     [Wed Jan  9 23:54:07 2019]  touch_atime+0x8c/0xb0
>     [Wed Jan  9 23:54:07 2019]  iterate_dir+0x10a/0x180
>     [Wed Jan  9 23:54:07 2019]  __x64_sys_getdents+0x8e/0x110
>     [Wed Jan  9 23:54:07 2019]  ? iterate_dir+0x180/0x180
>     [Wed Jan  9 23:54:07 2019]  do_syscall_64+0x55/0x110
>     [Wed Jan  9 23:54:07 2019]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>     [Wed Jan  9 23:54:07 2019] RIP: 0033:0x7f0c982f9215
>     [Wed Jan  9 23:54:07 2019] RSP: 002b:00007f0c918a95c0 EFLAGS: 00000246 ORIG_RAX: 000000000000004e
>     [Wed Jan  9 23:54:07 2019] RAX: ffffffffffffffda RBX: 00007f0c3f348c60 RCX: 00007f0c982f9215
>     [Wed Jan  9 23:54:07 2019] RDX: 0000000000008000 RSI: 00007f0c3f348c60 RDI: 0000000000000007
>     [Wed Jan  9 23:54:07 2019] RBP: 00007f0c3f348c60 R08: 00000000000000ff R09: 0000000000001000
>     [Wed Jan  9 23:54:07 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000a6672f
>     [Wed Jan  9 23:54:07 2019] R13: 00007f0c918affe0 R14: 0000000000000000 R15: 00007f0c918affb0
> 

These don't tell the full story, what seems to be happening is that
stuff is waiting for transaction to finish but it's not evident which
thread is holding the transaction. Please, paste the output of
"echo w > /proc/sysrq-trigger" so we have full picture of what's blocked
where.


> 
