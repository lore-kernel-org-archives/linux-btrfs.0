Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26957 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaHJO4U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 10:56:20 -0400
Date: Sun, 10 Aug 2014 22:55:44 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: miaox@cn.fujitsu.com, Martin Steigerwald <Martin@lichtvoll.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix compressed write corruption on enospc
Message-ID: <20140810145543.GA31343@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1406213285-19607-1-git-send-email-bo.li.liu@oracle.com>
 <3143412.n5KSJct7YP@merkaba>
 <53E22F37.9000308@fb.com>
 <4178355.kT8uO1WxjX@merkaba>
 <53E24738.5070908@fb.com>
 <53E2CDD9.5080009@fb.com>
 <20140807075029.GA29710@localhost.localdomain>
 <53E336D5.3010401@cn.fujitsu.com>
 <53E386E7.50802@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53E386E7.50802@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 07, 2014 at 10:02:15AM -0400, Chris Mason wrote:
> 
> 
> On 08/07/2014 04:20 AM, Miao Xie wrote:
> > On Thu, 7 Aug 2014 15:50:30 +0800, Liu Bo wrote:
> >>>> [90496.156016] kworker/u8:14   D ffff880044e38540     0 21050      2 0x00000000
> >>>> [90496.157683] Workqueue: btrfs-delalloc normal_work_helper [btrfs]
> >>>> [90496.159320]  ffff88022880f990 0000000000000002 ffff880407f649b0 ffff88022880ffd8
> >>>> [90496.160997]  ffff880044e38000 0000000000013040 ffff880044e38000 7fffffffffffffff
> >>>> [90496.162686]  ffff880301383aa0 0000000000000002 ffffffff814705d0 ffff880301383a98
> >>>> [90496.164360] Call Trace:
> >>>> [90496.166028]  [<ffffffff814705d0>] ? michael_mic.part.6+0x21/0x21
> >>>> [90496.167854]  [<ffffffff81470fd0>] schedule+0x64/0x66
> >>>> [90496.169574]  [<ffffffff814705ff>] schedule_timeout+0x2f/0x114
> >>>> [90496.171221]  [<ffffffff8106479a>] ? wake_up_process+0x2f/0x32
> >>>> [90496.172867]  [<ffffffff81062c3b>] ? get_parent_ip+0xd/0x3c
> >>>> [90496.174472]  [<ffffffff81062ce5>] ? preempt_count_add+0x7b/0x8e
> >>>> [90496.176053]  [<ffffffff814717f3>] __wait_for_common+0x11e/0x163
> >>>> [90496.177619]  [<ffffffff814717f3>] ? __wait_for_common+0x11e/0x163
> >>>> [90496.179173]  [<ffffffff810647aa>] ? wake_up_state+0xd/0xd
> >>>> [90496.180728]  [<ffffffff81471857>] wait_for_completion+0x1f/0x21
> >>>> [90496.182285]  [<ffffffffc044e3b3>] btrfs_async_run_delayed_refs+0xbf/0xd9 [btrfs]
> >>>> [90496.183833]  [<ffffffffc04624e1>] __btrfs_end_transaction+0x2b6/0x2ec [btrfs]
> >>>> [90496.185380]  [<ffffffffc0462522>] btrfs_end_transaction+0xb/0xd [btrfs]
> >>>> [90496.186940]  [<ffffffffc0451742>] find_free_extent+0x8a9/0x976 [btrfs]
> >>>> [90496.189464]  [<ffffffffc0451990>] btrfs_reserve_extent+0x6f/0x119 [btrfs]
> >>>> [90496.191326]  [<ffffffffc0466b45>] cow_file_range+0x1a6/0x377 [btrfs]
> >>>> [90496.193080]  [<ffffffffc047adc4>] ? extent_write_locked_range+0x10c/0x11e [btrfs]
> >>>> [90496.194659]  [<ffffffffc04677e4>] submit_compressed_extents+0x100/0x412 [btrfs]
> >>>> [90496.196225]  [<ffffffff8120e344>] ? debug_smp_processor_id+0x17/0x19
> >>>> [90496.197776]  [<ffffffffc0467b78>] async_cow_submit+0x82/0x87 [btrfs]
> >>>> [90496.199383]  [<ffffffffc048644b>] normal_work_helper+0x153/0x224 [btrfs]
> >>>> [90496.200944]  [<ffffffff81052d8c>] process_one_work+0x16f/0x2b8
> >>>> [90496.202483]  [<ffffffff81053636>] worker_thread+0x27b/0x32e
> >>>> [90496.204000]  [<ffffffff810533bb>] ? cancel_delayed_work_sync+0x10/0x10
> >>>> [90496.205514]  [<ffffffff81058012>] kthread+0xb2/0xba
> >>>> [90496.207040]  [<ffffffff81470000>] ? ap_handle_dropped_data+0xf/0xc8
> >>>> [90496.208565]  [<ffffffff81057f60>] ? __kthread_parkme+0x62/0x62
> >>>> [90496.210096]  [<ffffffff81473f6c>] ret_from_fork+0x7c/0xb0
> >>>> [90496.211618]  [<ffffffff81057f60>] ? __kthread_parkme+0x62/0x62
> >>>>
> >>>>
> >>>> Ok, this should explain the hang.  submit_compressed_extents is calling
> >>>> cow_file_range with a locked page.
> >>>>
> >>>> cow_file_range is trying to find a free extent and in the process is
> >>>> calling btrfs_end_transaction, which is running the async delayed refs,
> >>>> which is trying to write dirty pages, which is waiting for your locked
> >>>> page.
> >>>>
> >>>> I should be able to reproduce this ;)
> >>>
> >>> This part of the trace is relatively new because Liu Bo's patch made us
> >>> redirty the pages, making it more likely that we'd try to write them
> >>> during commit.
> >>>
> >>> But, at the end of the day we have a fundamental deadlock with
> >>> committing a transaction while holding a locked page from an ordered file.
> >>>
> >>> For now, I'm ripping out the strict ordered file and going back to a
> >>> best-effort filemap_flush like ext4 is using.
> >>
> >> I think I've figured the deadlock out, this is obviously a race case, really
> >> hard to reproduce :-(
> >>
> >> So it turns out to be related to workqueues -- now a kthread can process
> >> work_struct queued in different workqueues, so we can explain the deadlock as
> >> such,
> >>
> >> (1)
> >> "btrfs-delalloc" workqueue gets a compressed extent to process with all its pages
> >> locked during this, and it runs into read free space cache inode, and then wait
> >> on lock_page().
> >>
> >> (2)
> >> Reading that free space cache inode comes to submit part, and we have a
> >> indirect twice endio way for it, with the first endio we come to end_workqueue_bio()
> >> and queue a work in "btrfs-endio-meta" workqueue, and it will run the real
> >> endio() for us, but ONLY when it's processed.
> >>
> >> So the problem is a kthread can serve several workqueues, which means
> >> works in "btrfs-endio-meta" workqueues and works in "btrfs-flush_delalloc"
> >> workqueues can be in the same processing list of a kthread.  When
> >> "btrfs-flush_delalloc" waits for the compressed page and "btrfs-endio-meta"
> >> comes after it, it hangs.
> > 
> > I don't think it is right. All the btrfs workqueue has RECLAIM flag, which means
> > each btrfs workqueue has its own rescue worker. So the problem you said should
> > not happen.
> 
> Right, I traded some emails with Tejun about this and spent a few days
> trying to prove the workqueues were doing the wrong thing.   It will end
> up spawning another worker thread for the new work, and it won't get
> queued up behind the existing thread.
> 
> If both work items went to the same workqueue, you'd definitely be right.
> 
> I've got a patch to change the flush-delalloc code so we don't do the
> file writes during commit.  It seems like the only choice right now.

Not the only choice any more ;)

It turns out to be related to async_cow's ordered list, say we have two
async_cow works on the wq->ordered_list, and the first work(named A) finishes its
->ordered_func() and ->ordered_free(), and the second work(B) starts B's
->ordered_func() which gets to read free space cache inode, where it queues a
work on @endio_meta_workers, but this work happens to be the same address with
A's work.

So now the situation is,

(1) in kthread's looping worker_thread(), work A is actually running its job,
(2) however, work A has freed its memory but kthread still want to use this
    address of memory, which means worker->current_work is still A's address.
(3) B's readahead for free space cache inode happens to queue a work whose
    address of memory is just the previous address of A's work, which means
    another worker's ->current_work is also A's address.
(4) as in btrfs we all use function normal_work_helper(), so
    worker->current_func is fixed here.
(5) worker_thread()
           ->process_one_work()
                    ->find_worker_executing_work()    
                    (find a collision, another work returns)

Then we saw the hang.

Still testing my patch, will run it for about 2 days to check if it works.

thanks,
-liubo
