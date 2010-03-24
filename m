From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC PATCH 0/2] more raid456 thread pool experimentation
Date: Wed, 24 Mar 2010 15:31:56 -0400
Message-ID: <20100324193156.GH5021@think>
References: <20100324144904.15371.2317.stgit@dwillia2-linux>
 <20100324155154.GG5021@think>
 <e9c3a7c21003241106h10d1bc1am22b40fef4a335f70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c21003241106h10d1bc1am22b40fef4a335f70@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 24, 2010 at 11:06:40AM -0700, Dan Williams wrote:
> On Wed, Mar 24, 2010 at 8:51 AM, Chris Mason <chris.mason@oracle.com>=
 wrote:
> > On Wed, Mar 24, 2010 at 07:53:10AM -0700, Dan Williams wrote:
> >> The current implementation with the async thread pool ends up spre=
ading
> >> the work over too many threads. =A0The btrfs workqueue is targeted=
 at high
> >> cpu utilization works and has a threshold mechanism to limit threa=
d
> >> spawning. =A0Unfortunately it still ends up increasing cpu utiliza=
tion
> >> without a comparable improvement in throughput. =A0Here are the nu=
mbers
> >> relative to the multicore disabled case:
> >>
> >> idle_thresh =A0 throughput =A0 =A0 =A0cycles
> >> 4 =A0 =A0 =A0 =A0 =A0 =A0 +0% =A0 =A0 =A0 =A0 =A0 =A0 +102%
> >> 64 =A0 =A0 =A0 =A0 =A0 =A0+4% =A0 =A0 =A0 =A0 =A0 =A0 +63%
> >> 128 =A0 =A0 =A0 =A0 =A0 +1% =A0 =A0 =A0 =A0 =A0 =A0 +45%
> >
> > Interesting, do the btrfs workqueues improve things? =A0Or do you t=
hink they are
> > just a better base for more tuning?
>=20
> Both, throughput falls off a cliff with the async thread pool, and
> there are more knobs to turn in this implementation.

Ok, it's really interesting that we're only getting you 4% faster tput,
at 63% more cycles.  That looks like something more than just cache
affinity, but at least for btrfs I always had bigger problems than
affinity, so I haven't dug into that part yet.

>=20
> > I had always hoped to find more users for the work queues and tried=
 to
> > keep btrfs specific features out of them. =A0The place I didn't ent=
irely
> > succeed was in the spin locks, the ordered queues take regular spin
> > locks to avoid turning off irqs where btrfs always does things outs=
ide
> > of interrupt time. =A0Doesn't look like raid needs the ordered queu=
es so
> > this should work pretty well.
> >
> >>
> >> This appears to show that something more fundamental needs to happ=
en to
> >> take advantage of percpu raid processing. =A0More profiling is nee=
ded, but
> >> the suspects in my mind are conf->device_lock contention and the f=
act
> >> that all work is serialized through conf->handle_list with no meth=
od for
> >> encouraging stripe_head to thread affinity.
> >
> > The big place I'd suggest to look inside the btrfs async-thread.c f=
or
> > optimization is the worker_loop(). =A0For work that tends to be bur=
sty and
> > relatively short, we can have worker threads finish their work fair=
ly
> > quickly and go to sleep, only to be woken up very quickly again wit=
h
> > another big batch of work. =A0The worker_loop code tries to wait ar=
ound
> > for a while, but the tuning here was btrfs specific.
> >
> > It might also help to tune the find_worker and next_worker code to =
prefer
> > giving work to threads that are running but almost done with their
> > queue. =A0Maybe they can be put onto a special hot list as they get=
 near
> > the end of their queue.
> >
>=20
> Thanks I'll take a look at these suggestions.  For these optimization=
s
> to have a chance I think we need stripes to maintain affinity with th=
e
> first core that picks up the work.  Currently all stripes take a trip
> through the single-threaded raid5d when their reference count drops t=
o
> zero, only to be immediately reissued to the thread pool potentially
> on a different core (but I need to back this assumption up with more
> profiling).

Well, I'd definitely say the pool is going to give you a random
core.

>=20
> > There's a rule somewhere that patches renaming things must have rep=
lies
> > questioning the new name. =A0The first reply isn't actually allowed=
 to
> > suggest a better name, which is good because I'm not very good at
> > that kind of thing.
> >
> > Really though, btr_queue is fine by me, but don't feel obligated to=
 keep
> > some variation of btrfs in the name ;)
>=20
> btr_queue seemed to make sense since it's spreading work like "butter=
" :-).

Grin, it doesn't take many butter jokes to sell me.  Careful though, yo=
u
can't have just one buttery thread pool.  Just wait, you'll think of
good reasons to add another real soon.

Speaking of which, you want to use the atomic thread starting helper.
Basically kthread_run does GFP allocations that can wait on disk, and
if you're the disk it is waiting on things can go badly in a hurry.

We should probably integrate a single kthread run helper thread into th=
e
pools instead of forcing people to make their own.  I'll take a look.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
