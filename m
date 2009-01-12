From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
Date: Mon, 12 Jan 2009 18:13:08 +0100
Message-ID: <1231780388.4371.185.camel@laptop>
References: <1231774622.4371.96.camel@laptop>  <496B6C23.8000808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Avi Kivity <avi@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <496B6C23.8000808@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-01-12 at 18:13 +0200, Avi Kivity wrote:

> One thing that worries me here is that the spinners will spin on a 
> memory location in struct mutex, which means that the cacheline holding 
> the mutex (which is likely to be under write activity from the owner) 
> will be continuously shared by the spinners, slowing the owner down when 
> it needs to unshare it.  One way out of this is to spin on a location in 
> struct mutex_waiter, and have the mutex owner touch it when it schedules 
> out.

Yeah, that is what pure MCS locks do -- however I don't think its a
feasible strategy for this spin/sleep hybrid.

> So:
> - each task_struct has an array of currently owned mutexes, appended to 
> by mutex_lock()

That's not going to fly I think. Lockdep does this but its very
expensive and has some issues. We're currently at 48 max owners, and
still some code paths manage to exceed that.

> - mutex waiters spin on mutex_waiter.wait, which they initialize to zero
> - when switching out of a task, walk the mutex list, and for each mutex, 
> bump each waiter's wait variable, and clear the owner array

Which is O(n).

> - when unlocking a mutex, bump the nearest waiter's wait variable, and 
> remove from the owner array
> 
> Something similar might be done to spinlocks to reduce cacheline 
> contention from spinners and the owner.

Spinlocks can use 'pure' MCS locks.

