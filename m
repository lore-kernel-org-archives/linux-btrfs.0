From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 6 Jan 2009 14:31:50 -0800
Message-ID: <20090106223150.GF6741@linux.vnet.ibm.com>
References: <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com> <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins> <49636799.1010109@novell.com> <20090106214229.GD6741@linux.vnet.ibm.com> <1231278275.11687.111.camel@twins>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Piggin <npiggin@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231278275.11687.111.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 06, 2009 at 10:44:35PM +0100, Peter Zijlstra wrote:
> On Tue, 2009-01-06 at 13:42 -0800, Paul E. McKenney wrote:
> > Preemptable RCU needs to be faster.  Got it -- and might have a way
> > to do it by eliminating the irq disabling and cutting way back on the
> > number of operations that must be performed.  It would probably still
> > be necessary to access the task structure.
> > 
> > Or is something other than the raw performance of rcu_read_lock() and
> > rcu_read_unlock() at issue here?
> 
> With Linus' mutex_spin_or_schedule() function the whole - keeping
> owner's task_struct alive issue goes away,.. now if only the thing would
> boot...

Cool!  And I can relate to the "if only the thing would boot" part.  ;-)

							Thanx, Paul
