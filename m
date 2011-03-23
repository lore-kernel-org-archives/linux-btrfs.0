From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH RFC] btrfs: Simplify locking
Date: Wed, 23 Mar 2011 07:44:19 -0400
Message-ID: <1300880437-sup-6371@think>
References: <20110320174433.GA12003@htj.dyndns.org> <1300665355-sup-1698@think> <20110321082942.GD12003@htj.dyndns.org> <20110321165955.GG12003@htj.dyndns.org> <1300728113-sup-8564@think> <20110321181124.GK12003@htj.dyndns.org> <1300835390-sup-7485@think> <20110323104614.GA12003@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110323104614.GA12003@htj.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Tejun Heo's message of 2011-03-23 06:46:14 -0400:
> Hello, Chris.
> 
> On Tue, Mar 22, 2011 at 07:13:09PM -0400, Chris Mason wrote:
> > Ok, this impact of this is really interesting.  If we have very short
> > waits where there is no IO at all, this patch tends to lose.  I ran with
> > dbench 10 and got about 20% slower tput.
> > 
> > But, if we do any IO at all it wins by at least that much or more.  I
> > think we should take this patch and just work on getting rid of the
> > scheduling with the mutex held where possible.
> 
> I see.
> 
> > Tejun, could you please send the mutex_tryspin stuff in?  If we can get
> > a sob for that I can send the whole thing.
> 
> I'm not sure whetehr mutex_tryspin() is justified at this point, and,
> even if so, how to proceed with it.  Maybe we want to make
> mutex_trylock() perform owner spin by default without introducing a
> new API.

I'll benchmark without it, but I think the cond_resched is going to have
a pretty big impact.  I'm digging up the related benchmarks I used
during the initial adaptive spin work.

> 
> Given that the difference between SIMPLE and SPIN is small, I think it
> would be best to simply use mutex_trylock() for now.  It's not gonna
> make much difference either way.

mutex_trylock is a good start.

> 
> How do you want to proceed?  I can prep patches doing the following.
> 
> - Convert CONFIG_DEBUG_LOCK_ALLOC to CONFIG_LOCKDEP.
> 
> - Drop locking.c and make the lock function simple wrapper around
>   mutex operations.  This makes blocking/unblocking noops.
> 
> - Remove all blocking/unblocking calls along with the API.

I'd like to keep the blocking/unblocking calls for one release.  I'd
like to finally finish off my patches that do concurrent reads.

> 
> - Remove locking wrappers and use mutex API directly.

I'd also like to keep the wrappers until the concurrent reader locking
is done.

> 
> What do you think?

Thanks for all the work.

-chris
