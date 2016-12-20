Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33036 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758479AbcLTR0a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 12:26:30 -0500
Date: Tue, 20 Dec 2016 18:26:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, quwenruo@cn.fujitsu.com
Subject: Re: [PATCH 1/2] btrfs: drop trace_btrfs_all_work_done() from
 normal_work_helper()
Message-ID: <20161220172613.GQ3620@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161214140530.6534-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161214140530.6534-1-bigeasy@linutronix.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adding Qu to CC,

On Wed, Dec 14, 2016 at 03:05:29PM +0100, Sebastian Andrzej Siewior wrote:
> For btrfs_scrubparity_helper() the ->func() is set to
> scrub_parity_bio_endio_worker(). This functions invokes
> scrub_free_parity() which kfrees() the `work' object. All is good as
> long as trace events are not enabled because we boom with a backtrace
> like this:
> | Workqueue: btrfs-endio btrfs_endio_helper
> | RIP: 0010:[<ffffffff812f81ae>]  [<ffffffff812f81ae>] trace_event_raw_event_btrfs__work__done+0x4e/0xa0
> | Call Trace:
> |  [<ffffffff8136497d>] btrfs_scrubparity_helper+0x59d/0x780
> |  [<ffffffff81364c49>] btrfs_endio_helper+0x9/0x10
> |  [<ffffffff8108af8e>] process_one_work+0x26e/0x7b0
> |  [<ffffffff8108b516>] worker_thread+0x46/0x560
> |  [<ffffffff81091c4e>] kthread+0xee/0x110
> |  [<ffffffff818e166a>] ret_from_fork+0x2a/0x40
> 
> So in order to avoid this, I remove the trace point.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  fs/btrfs/async-thread.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
> index e0f071f6b5a7..d0dfc3d2e199 100644
> --- a/fs/btrfs/async-thread.c
> +++ b/fs/btrfs/async-thread.c
> @@ -318,8 +318,6 @@ static void normal_work_helper(struct btrfs_work *work)
>  		set_bit(WORK_DONE_BIT, &work->flags);
>  		run_ordered_work(wq);
>  	}
> -	if (!need_order)
> -		trace_btrfs_all_work_done(work);

The comment in the function says we can't touch 'work' after the
callbacks. I don't see any way to use it in a tracepoint here. The
"all_work_done" pairs with a preceding trace_btrfs_work_sched in the
same function or from within run_ordered_work, also called after the
free callback.

So I think we should either remove the tracepoint completely or change
the arguments to take something else than a potentially freed 'work'.

I'm a bit puzzled by the comment in trace/events/btrfs.h

http://lxr.free-electrons.com/source/include/trace/events/btrfs.h#L1165

/* For situiations that the work is freed */
DECLARE_EVENT_CLASS(btrfs__work__done,

so we're expecing a freed pointer anyway? That sounds wrong.

I'll queue the patch for 4.10 as it fixes a crash.
