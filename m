From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 8 Jan 2009 09:52:24 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901080943270.3283@localhost.localdomain>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>  <1231347442.11687.344.camel@twins>  <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>  <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>  <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
  <1231365115.11687.361.camel@twins>  <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>  <1231366716.11687.377.camel@twins>  <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>  <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu>
  <1231426014.11687.456.camel@twins>  <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.DEB.1.10.0901081227260.24688@gandalf.stny.rr.com>
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
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901081227260.24688@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>



On Thu, 8 Jan 2009, Steven Rostedt wrote:
> 
> We keep spinning if the owner changes.

I think we want to - if you have multiple CPU's and a heavily contended 
lock that acts as a spinlock, we still _do_ want to keep spinning even if 
another CPU gets the lock.

And I don't even believe that is the bug. I suspect the bug is simpler. 

I think the "need_resched()" needs to go in the outer loop, or at least 
happen in the "!owner" case. Because at least with preemption, what can 
happen otherwise is

 - process A gets the lock, but gets preempted before it sets lock->owner.

   End result: count = 0, owner = NULL.

 - processes B/C goes into the spin loop, filling up all CPU's (assuming 
   dual-core here), and will now both loop forever if they hold the kernel 
   lock (or have some other preemption disabling thing over their down()).

And all the while, process A would _happily_ set ->owner, and eventually 
release the mutex, but it never gets to run to do either of them so.

In fact, you might not even need a process C: all you need is for B to be 
on the same runqueue as A, and having enough load on the other CPU's that 
A never gets migrated away. So "C" might be in user space.

I dunno. There are probably variations on the above.

		Linus
