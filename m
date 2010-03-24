From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC PATCH 0/2] more raid456 thread pool experimentation
Date: Wed, 24 Mar 2010 11:51:54 -0400
Message-ID: <20100324155154.GG5021@think>
References: <20100324144904.15371.2317.stgit@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100324144904.15371.2317.stgit@dwillia2-linux>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 24, 2010 at 07:53:10AM -0700, Dan Williams wrote:
> The current implementation with the async thread pool ends up spreading
> the work over too many threads.  The btrfs workqueue is targeted at high
> cpu utilization works and has a threshold mechanism to limit thread
> spawning.  Unfortunately it still ends up increasing cpu utilization
> without a comparable improvement in throughput.  Here are the numbers
> relative to the multicore disabled case:
> 
> idle_thresh	throughput	cycles
> 4		+0%		+102%
> 64		+4%		+63%
> 128		+1%		+45%

Interesting, do the btrfs workqueues improve things?  Or do you think they are
just a better base for more tuning?

I had always hoped to find more users for the work queues and tried to
keep btrfs specific features out of them.  The place I didn't entirely
succeed was in the spin locks, the ordered queues take regular spin
locks to avoid turning off irqs where btrfs always does things outside
of interrupt time.  Doesn't look like raid needs the ordered queues so
this should work pretty well.

> 
> This appears to show that something more fundamental needs to happen to
> take advantage of percpu raid processing.  More profiling is needed, but
> the suspects in my mind are conf->device_lock contention and the fact
> that all work is serialized through conf->handle_list with no method for
> encouraging stripe_head to thread affinity.

The big place I'd suggest to look inside the btrfs async-thread.c for
optimization is the worker_loop().  For work that tends to be bursty and
relatively short, we can have worker threads finish their work fairly
quickly and go to sleep, only to be woken up very quickly again with
another big batch of work.  The worker_loop code tries to wait around
for a while, but the tuning here was btrfs specific.

It might also help to tune the find_worker and next_worker code to prefer
giving work to threads that are running but almost done with their
queue.  Maybe they can be put onto a special hot list as they get near
the end of their queue.

There's a rule somewhere that patches renaming things must have replies
questioning the new name.  The first reply isn't actually allowed to
suggest a better name, which is good because I'm not very good at
that kind of thing.

Really though, btr_queue is fine by me, but don't feel obligated to keep
some variation of btrfs in the name ;)

-chris

