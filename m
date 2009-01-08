From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 8 Jan 2009 13:14:08 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901081305430.24688@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>  <1231347442.11687.344.camel@twins>  <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>  <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>  <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
  <1231365115.11687.361.camel@twins>  <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>  <1231366716.11687.377.camel@twins>  <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>  <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu>
  <1231426014.11687.456.camel@twins>  <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.DEB.1.10.0901081227260.24688@gandalf.stny.rr.com> <alpine.LFD.2.00.0901080943270.3283@localhost.localdomain>
 <alpine.DEB.1.10.0901081300370.24688@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@elte.hu>, paulmck@linux.vnet.ibm.com,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901081300370.24688@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>




On Thu, 8 Jan 2009, Steven Rostedt wrote:
> > In fact, you might not even need a process C: all you need is for B to be 
> > on the same runqueue as A, and having enough load on the other CPU's that 
> > A never gets migrated away. So "C" might be in user space.

You're right about not needing process C.

> > 
> > I dunno. There are probably variations on the above.
> 
> Ouch! I think you are on to something:
> 
>         for (;;) {
>                 struct thread_info *owner;
> 
>                 old_val = atomic_cmpxchg(&lock->count, 1, 0);
>                 if (old_val == 1) {
>                         lock_acquired(&lock->dep_map, ip);
>                         mutex_set_owner(lock);
>                         return 0;
>                 }
> 
>                 if (old_val < 0 && !list_empty(&lock->wait_list))
>                         break;
> 
>                 /* See who owns it, and spin on him if anybody */
>                 owner = ACCESS_ONCE(lock->owner);
> 
> The owner was preempted before assigning lock->owner (as you stated).

If it was the current process that preempted the owner and these are RT 
tasks pinned to the same CPU and the owner is of lower priority than the 
spinner, we have a deadlock!

Hmm, I do not think the need_sched here will even fix that :-/

-- Steve

