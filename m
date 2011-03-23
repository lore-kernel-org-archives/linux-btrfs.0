From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] btrfs: Simplify locking
Date: Wed, 23 Mar 2011 11:46:14 +0100
Message-ID: <20110323104614.GA12003@htj.dyndns.org>
References: <20110320174433.GA12003@htj.dyndns.org>
 <1300665355-sup-1698@think>
 <20110321082942.GD12003@htj.dyndns.org>
 <20110321165955.GG12003@htj.dyndns.org>
 <1300728113-sup-8564@think>
 <20110321181124.GK12003@htj.dyndns.org>
 <1300835390-sup-7485@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300835390-sup-7485@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Chris.

On Tue, Mar 22, 2011 at 07:13:09PM -0400, Chris Mason wrote:
> Ok, this impact of this is really interesting.  If we have very short
> waits where there is no IO at all, this patch tends to lose.  I ran with
> dbench 10 and got about 20% slower tput.
> 
> But, if we do any IO at all it wins by at least that much or more.  I
> think we should take this patch and just work on getting rid of the
> scheduling with the mutex held where possible.

I see.

> Tejun, could you please send the mutex_tryspin stuff in?  If we can get
> a sob for that I can send the whole thing.

I'm not sure whetehr mutex_tryspin() is justified at this point, and,
even if so, how to proceed with it.  Maybe we want to make
mutex_trylock() perform owner spin by default without introducing a
new API.

Given that the difference between SIMPLE and SPIN is small, I think it
would be best to simply use mutex_trylock() for now.  It's not gonna
make much difference either way.

How do you want to proceed?  I can prep patches doing the following.

- Convert CONFIG_DEBUG_LOCK_ALLOC to CONFIG_LOCKDEP.

- Drop locking.c and make the lock function simple wrapper around
  mutex operations.  This makes blocking/unblocking noops.

- Remove all blocking/unblocking calls along with the API.

- Remove locking wrappers and use mutex API directly.

What do you think?

Thanks.

-- 
tejun
