Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299AbaAHSwB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 13:52:01 -0500
Date: Wed, 8 Jan 2014 19:51:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 00/18] Replace btrfs_workers with kernel workqueue
 based btrfs_workqueue
Message-ID: <20140108185159.GI6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com>
 <52B3105A.5000102@fb.com>
 <52B3B4BC.70204@cn.fujitsu.com>
 <52B44688.5070603@fb.com>
 <52B7A158.8000503@cn.fujitsu.com>
 <52CCEF3E.5010807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52CCEF3E.5010807@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 08, 2014 at 02:25:02PM +0800, Qu Wenruo wrote:
> >But according to the dmesg, which is expired now though, I made the
> >following assumption:
> >
> >There is a possibility that out of order execution made the "work->wq =
> >wq" sentence executed behind the "queue_work()" call,
> >and the "normal_work_helper" is executed in another CPU instantly, which
> >caused the problem.

This could be the reason, though I still don't see how exactly this
happens.

> >------
> >static inline void __btrfs_queue_work(struct __btrfs_workqueue *wq,
> >struct btrfs_work *work)
> >{
> >unsigned long flags;
> >
> >work->wq = wq;
> >/* There is no memory barrier ensure the work->wq = wq is executed
> >before queue_work */
> >thresh_queue_hook(wq);
> >if (work->ordered_func) {
> >spin_lock_irqsave(&wq->list_lock, flags);
> >list_add_tail(&work->ordered_list, &wq->ordered_list);
> >spin_unlock_irqrestore(&wq->list_lock, flags);
> >}
> >queue_work(wq->normal_wq, &work->normal_work);
> >}
> >------
> >
> >The fix is as easy as just adding a smp_wmb() behind the "work->wq = wq"
> >sentence, but since I failed to reproduce the bug,
> >I can't confirm whether the fix is good or not.
> >
> >I know it's impolite but would you please first try the smp_wmb() first to
> >confirm the fix?
> If itis convenient for you,would you please give some feedback about the
> smp_wmb() fix ?
> 
> Also incase that smp_wmb() doesn't work, it would be very nice of you to
> also try smp_mb() fix.

The smp_wmb barriers have to pair with smp_rmb, which means that
normal_work_helper() has to call smp_rmb at the beginning.

What still puzzles me is why would the barriers are needed at all,
although your example code shows the effects of a delayed store.

Down the call stack, the barrier takes place:

queue_work
  queue_work_on(WORK_CPU_UNBOUND)
    __queue_work
      insert_work
        smp_mb

There is no barrier before the work is being processed in
workqueue.c::process_one_work(), but there maybe an implied one.


david
