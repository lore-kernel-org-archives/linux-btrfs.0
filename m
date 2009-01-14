From: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
Date: Wed, 14 Jan 2009 18:04:45 +0100
Message-ID: <20090114170445.GA18964@wotan.suse.de>
References: <1231774622.4371.96.camel@laptop> <496B6C23.8000808@redhat.com> <1231780388.4371.185.camel@laptop> <496B7EBC.6020208@redhat.com> <1231951599.14825.18.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Avi Kivity <avi@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231951599.14825.18.camel@laptop>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 14, 2009 at 05:46:39PM +0100, Peter Zijlstra wrote:
> On Mon, 2009-01-12 at 19:32 +0200, Avi Kivity wrote:
> > Peter Zijlstra wrote:
> > > Spinlocks can use 'pure' MCS locks.
> > >   
> > 
> > How about this, then.  In mutex_lock(), keep wait_lock locked and only 
> > release it when scheduling out.  Waiter spinning naturally follows.  If 
> > spinlocks are cache friendly (are they today?) 
> 
> (no they're not, Nick's ticket locks still spin on a shared cacheline
> IIRC -- the MCS locks mentioned could fix this)

It reminds me. I wrote a basic variation of MCS spinlocks a while back. And
converted dcache lock to use it, which showed large dbench improvements on
a big machine (of course for different reasons than the dbench improvements
in this threaed).

http://lkml.org/lkml/2008/8/28/24

Each "lock" object is sane in size because given set of spin-local queues may
only be used once per lock stack. But any spinlocks within a mutex acquisition
will always be at the bottom of such a stack anyway, by definition.

If you can use any code or concept for your code, that would be great.

 
> > we inherit that.  If 
> > there is no contention on the mutex, then we don't need to reacquire the 
> > wait_lock on mutex_unlock() (not that the atomic op is that expensive 
> > these days).
> 
> That might actually work, although we'd have to move the
> __mutex_slowpath_needs_to_unlock() branch outside wait_lock otherwise
> we'll deadlock :-)
> 
> It might be worth trying this if we get serious fairness issues with the
> current construct.
