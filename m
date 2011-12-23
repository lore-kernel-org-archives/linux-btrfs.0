From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs: fix num_workers_starting bug and other bugs in async
 thread
Date: Fri, 23 Dec 2011 08:21:26 -0500
Message-ID: <20111223132126.GN19266@shiny>
References: <20111223104453.GB8592@elgon.mountain>
 <20111223130603.GM19266@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111223130603.GM19266@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 23, 2011 at 08:06:03AM -0500, Chris Mason wrote:
> On Fri, Dec 23, 2011 at 01:44:53PM +0300, Dan Carpenter wrote:
> > Hi Josef,
> > 
> > Smatch complains about this change introduces a double unlock.
> > 
> > fs/btrfs/async-thread.c +608 find_worker(49) error: double unlock 'spin_lock:&workers->lock'
> > 
> >    579                          spin_unlock_irqrestore(&workers->lock, flags);
> >                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Thanks Dan, fixing.
> >    602  found:
> >    603          /*
> >    604           * this makes sure the worker doesn't exit before it is placed
> >    605           * onto a busy/idle list
> >    606           */
> >    607          atomic_inc(&worker->num_pending);
> >    608          spin_unlock_irqrestore(&workers->lock, flags);
> >                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > And again here.
> > 
> > Btw, does find_worker() ever get called with IRQs disabled?  If so then
> > __btrfs_start_workers() enables them.  Maybe that function should use
> > spin_lock_irqsave() instead of spin_lock_irq().
> 
> Patching this too.

Read that too quickly.  __btrfs_start_workers() can't be called with
irqs off, kthread_run schedules.

-chris

