From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 6 Jan 2009 16:09:53 -0700
Message-ID: <20090106230953.GQ2002@parisc-linux.org>
References: <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins> <49636799.1010109@novell.com> <20090106214229.GD6741@linux.vnet.ibm.com> <1231278275.11687.111.camel@twins> <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain> <1231279660.11687.121.camel@twins> <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain> <1231281801.11687.125.camel@twins> <alpine.LFD.2.00.0901061456280.3057@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
	Gregory Haskins <ghaskins@novell.com>,
	Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901061456280.3057@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 06, 2009 at 03:00:47PM -0800, Linus Torvalds wrote:
> Well, if you didn't go to sleep, a few more questions..

I know this one!  Me sir, me me me!

> >  int __sched
> >  mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
> >  {
> > +	int ret;
> > +
> >  	might_sleep();
> > -	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
> > +	ret =  __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
> > +	if (!ret)
> > +		lock->owner = current;
> > +
> > +	return ret;
> 
> This looks ugly. Why doesn't __mutex_lock_common() just set the lock 
> owner? Hate seeing it done in the caller that has to re-compute common 
> (yeah, yeah, it's cheap) and just looks ugly.

Because __mutex_lock_common() is the slow path.  The fast path is a
couple of assembly instructions in asm/mutex.h.  If the lock isn't
contended, it will never call __mutex_lock_common().

That would make the whole exercise rather pointless; the only time worth
spinning really is if you're the only other one waiting for it ... if
there's already a waiter, you might as well go to sleep.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
