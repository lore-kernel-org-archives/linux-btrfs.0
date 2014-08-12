Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25260 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaHLHvV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 03:51:21 -0400
Date: Tue, 12 Aug 2014 15:51:05 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Chris Mason <clm@fb.com>, Martin Steigerwald <Martin@lichtvoll.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix compressed write corruption on enospc
Message-ID: <20140812075104.GD9244@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <3143412.n5KSJct7YP@merkaba>
 <53E22F37.9000308@fb.com>
 <4178355.kT8uO1WxjX@merkaba>
 <53E24738.5070908@fb.com>
 <53E2CDD9.5080009@fb.com>
 <20140807075029.GA29710@localhost.localdomain>
 <53E336D5.3010401@cn.fujitsu.com>
 <53E386E7.50802@fb.com>
 <20140810145543.GA31343@localhost.localdomain>
 <53E98237.3070108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53E98237.3070108@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 12, 2014 at 10:55:51AM +0800, Miao Xie wrote:
> On Sun, 10 Aug 2014 22:55:44 +0800, Liu Bo wrote:
> >>>>> This part of the trace is relatively new because Liu Bo's patch made us
> >>>>> redirty the pages, making it more likely that we'd try to write them
> >>>>> during commit.
> >>>>>
> >>>>> But, at the end of the day we have a fundamental deadlock with
> >>>>> committing a transaction while holding a locked page from an ordered file.
> >>>>>
> >>>>> For now, I'm ripping out the strict ordered file and going back to a
> >>>>> best-effort filemap_flush like ext4 is using.
> >>>>
> >>>> I think I've figured the deadlock out, this is obviously a race case, really
> >>>> hard to reproduce :-(
> >>>>
> >>>> So it turns out to be related to workqueues -- now a kthread can process
> >>>> work_struct queued in different workqueues, so we can explain the deadlock as
> >>>> such,
> >>>>
> >>>> (1)
> >>>> "btrfs-delalloc" workqueue gets a compressed extent to process with all its pages
> >>>> locked during this, and it runs into read free space cache inode, and then wait
> >>>> on lock_page().
> >>>>
> >>>> (2)
> >>>> Reading that free space cache inode comes to submit part, and we have a
> >>>> indirect twice endio way for it, with the first endio we come to end_workqueue_bio()
> >>>> and queue a work in "btrfs-endio-meta" workqueue, and it will run the real
> >>>> endio() for us, but ONLY when it's processed.
> >>>>
> >>>> So the problem is a kthread can serve several workqueues, which means
> >>>> works in "btrfs-endio-meta" workqueues and works in "btrfs-flush_delalloc"
> >>>> workqueues can be in the same processing list of a kthread.  When
> >>>> "btrfs-flush_delalloc" waits for the compressed page and "btrfs-endio-meta"
> >>>> comes after it, it hangs.
> >>>
> >>> I don't think it is right. All the btrfs workqueue has RECLAIM flag, which means
> >>> each btrfs workqueue has its own rescue worker. So the problem you said should
> >>> not happen.
> >>
> >> Right, I traded some emails with Tejun about this and spent a few days
> >> trying to prove the workqueues were doing the wrong thing.   It will end
> >> up spawning another worker thread for the new work, and it won't get
> >> queued up behind the existing thread.
> >>
> >> If both work items went to the same workqueue, you'd definitely be right.
> >>
> >> I've got a patch to change the flush-delalloc code so we don't do the
> >> file writes during commit.  It seems like the only choice right now.
> > 
> > Not the only choice any more ;)
> > 
> > It turns out to be related to async_cow's ordered list, say we have two
> > async_cow works on the wq->ordered_list, and the first work(named A) finishes its
> > ->ordered_func() and ->ordered_free(), and the second work(B) starts B's
> > ->ordered_func() which gets to read free space cache inode, where it queues a
> > work on @endio_meta_workers, but this work happens to be the same address with
> > A's work.
> > 
> > So now the situation is,
> > 
> > (1) in kthread's looping worker_thread(), work A is actually running its job,
> > (2) however, work A has freed its memory but kthread still want to use this
> >     address of memory, which means worker->current_work is still A's address.
> > (3) B's readahead for free space cache inode happens to queue a work whose
> >     address of memory is just the previous address of A's work, which means
> >     another worker's ->current_work is also A's address.
> > (4) as in btrfs we all use function normal_work_helper(), so
> >     worker->current_func is fixed here.
> > (5) worker_thread()
> >            ->process_one_work()
> >                     ->find_worker_executing_work()    
> >                     (find a collision, another work returns)
> > 
> > Then we saw the hang.
> 
> Here is my understand of what you said:
> The same worker dealt with work A and work B, and the 3rd work which was introduced by
> work B and has the same virtual memory address as work A was also inserted into the work
> list of that worker. But work B was wait for the 3rd work at that time, so deadlock happened.
> Am I right?
> 
> If I'm right, I think what you said is impossible. Before we dealt with work B, we should
> already invoke spin_unlock_irq(&pool->lock), which implies a memory barrier that all changes
> happens before unlock should complete before unlock, that is the address in current_work should
> be the address of work B, when we inserted the 3rd work which was introduced by work B, we
> should not find the address of work A in current_work of work B's worker.
> 
> I can not reproduce the problem on my machine, so I don't verify whether what I said is right
> or not. Please correct me if I am wrong.

Hmm, my fault...the problem is complex so I didn't describe it 100% precisely
in the above reply.

I've sent a patch about this which has the truth you may want :-)

-liubo
