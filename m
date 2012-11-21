Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:57860 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab2KUM6Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Nov 2012 07:58:16 -0500
Date: Wed, 21 Nov 2012 07:58:03 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, Arne Jansen <jansen@webgods.de>,
        Chris Mason <clmason@fusionio.com>
Subject: Re: Scrub racing with btrfs workers on umount
Message-ID: <20121121125803.GB7243@shiny.int.fusionio.com>
References: <50AB86D5.6040501@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50AB86D5.6040501@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 20, 2012 at 06:34:13AM -0700, Jan Schmidt wrote:
> I found a race condition in the way scrub interacts with btrfs workers:
> 
> Please carefully distinguish "workers" as struct btrfs_workers from "worker" as
> struct btrfs_worker_thread.
> 
> Process A: umount
> 	Process B: scrub-workers
> 		Process C: genwork-worker
> 
> A: close_ctree()
> A: scrub_cancel()
> 	B: scrub_workers_put()
> 	B: btrfs_stop_workers()
> 	B: -> lock(workers->lock)
> 	B: -> splice idle worker list into worker list
> 	B: -> while (worker list)
> 	B: ->	worker = delete from worker list
> 	B: ->	unlock(workers->lock)
> 	B: ->	kthread_stop(worker)
> 		C: __btrfs_start_workers()
> 		C: -> kthread_run starts new scrub-worker
> 		C: -> lock(workers->lock) /* from scrub-workers */
> 		C: -> add to workers idle list
> 		C: -> unlock(workers->lock)
> 	B: ->	lock(workers->lock)
> A: stop genwork-worker
> 
> In that situation, the scrub-workers have one idle worker but return from
> btrfs_stop_workers(). There are several strategies to fix this:
> 
> 1. Let close_ctree call scrub_cancel() after stopping the generic worker.
> 
> 2. Let btrfs_stop_workers be more careful on insertions to the idle list, like:
> 
> diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
> index 58b7d14..2523781 100644
> --- a/fs/btrfs/async-thread.c
> +++ b/fs/btrfs/async-thread.c
> @@ -431,6 +431,8 @@ void btrfs_stop_workers(struct btrfs_workers *workers)
>                         kthread_stop(worker->task);
>                 spin_lock_irq(&workers->lock);
>                 put_worker(worker);
> +               /* we dropped the lock above, check for new idle workers */
> +               list_splice_init(&workers->idle_list, &workers->worker_list);
>         }
>         spin_unlock_irq(&workers->lock);
>  }
> 
> 3. Find out why __btrfs_start_workers() gets called in the above scenario at all.
> 
> Any thoughts? Otherwise, I'm going for option 3 and will call back.

I'd go for a mixture of 1 and 3.  My first guess is that we're getting
endio events for scrub reads and that is kicking the scrub state
machine.

-chris

