From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
Date: Mon, 12 Jan 2009 08:04:22 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901120802430.6528@localhost.localdomain>
References: <1231774622.4371.96.camel@laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ingo Molnar <mingo@elte.hu>,
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
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231774622.4371.96.camel@laptop>
List-ID: <linux-btrfs.vger.kernel.org>



On Mon, 12 Jan 2009, Peter Zijlstra wrote:
> 
> Change mutex contention behaviour such that it will sometimes busy wait on
> acquisition - moving its behaviour closer to that of spinlocks.

This version seems worse in so many ways.

You made the mutex bigger, for no obvious reason.

You made it back into the locked version.

You have unnecessary preempt_enable/preempt_disable calls in functions 
that need to be called (and are called) with preemption already disabled.

Things seem to be going backwards.

		Linus
