From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 0/2] more raid456 thread pool experimentation
Date: Wed, 24 Mar 2010 11:06:40 -0700
Message-ID: <e9c3a7c21003241106h10d1bc1am22b40fef4a335f70@mail.gmail.com>
References: <20100324144904.15371.2317.stgit@dwillia2-linux>
	 <20100324155154.GG5021@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100324155154.GG5021@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 24, 2010 at 8:51 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Wed, Mar 24, 2010 at 07:53:10AM -0700, Dan Williams wrote:
>> The current implementation with the async thread pool ends up spread=
ing
>> the work over too many threads. =A0The btrfs workqueue is targeted a=
t high
>> cpu utilization works and has a threshold mechanism to limit thread
>> spawning. =A0Unfortunately it still ends up increasing cpu utilizati=
on
>> without a comparable improvement in throughput. =A0Here are the numb=
ers
>> relative to the multicore disabled case:
>>
>> idle_thresh =A0 throughput =A0 =A0 =A0cycles
>> 4 =A0 =A0 =A0 =A0 =A0 =A0 +0% =A0 =A0 =A0 =A0 =A0 =A0 +102%
>> 64 =A0 =A0 =A0 =A0 =A0 =A0+4% =A0 =A0 =A0 =A0 =A0 =A0 +63%
>> 128 =A0 =A0 =A0 =A0 =A0 +1% =A0 =A0 =A0 =A0 =A0 =A0 +45%
>
> Interesting, do the btrfs workqueues improve things? =A0Or do you thi=
nk they are
> just a better base for more tuning?

Both, throughput falls off a cliff with the async thread pool, and
there are more knobs to turn in this implementation.

> I had always hoped to find more users for the work queues and tried t=
o
> keep btrfs specific features out of them. =A0The place I didn't entir=
ely
> succeed was in the spin locks, the ordered queues take regular spin
> locks to avoid turning off irqs where btrfs always does things outsid=
e
> of interrupt time. =A0Doesn't look like raid needs the ordered queues=
 so
> this should work pretty well.
>
>>
>> This appears to show that something more fundamental needs to happen=
 to
>> take advantage of percpu raid processing. =A0More profiling is neede=
d, but
>> the suspects in my mind are conf->device_lock contention and the fac=
t
>> that all work is serialized through conf->handle_list with no method=
 for
>> encouraging stripe_head to thread affinity.
>
> The big place I'd suggest to look inside the btrfs async-thread.c for
> optimization is the worker_loop(). =A0For work that tends to be burst=
y and
> relatively short, we can have worker threads finish their work fairly
> quickly and go to sleep, only to be woken up very quickly again with
> another big batch of work. =A0The worker_loop code tries to wait arou=
nd
> for a while, but the tuning here was btrfs specific.
>
> It might also help to tune the find_worker and next_worker code to pr=
efer
> giving work to threads that are running but almost done with their
> queue. =A0Maybe they can be put onto a special hot list as they get n=
ear
> the end of their queue.
>

Thanks I'll take a look at these suggestions.  For these optimizations
to have a chance I think we need stripes to maintain affinity with the
first core that picks up the work.  Currently all stripes take a trip
through the single-threaded raid5d when their reference count drops to
zero, only to be immediately reissued to the thread pool potentially
on a different core (but I need to back this assumption up with more
profiling).

> There's a rule somewhere that patches renaming things must have repli=
es
> questioning the new name. =A0The first reply isn't actually allowed t=
o
> suggest a better name, which is good because I'm not very good at
> that kind of thing.
>
> Really though, btr_queue is fine by me, but don't feel obligated to k=
eep
> some variation of btrfs in the name ;)

btr_queue seemed to make sense since it's spreading work like "butter" =
:-).

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
