From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
Date: Tue, 13 Jan 2009 21:58:19 -0500
Message-ID: <1231901899.1709.18.camel@think.oraclecorp.com>
References: <1231774622.4371.96.camel@laptop>
	 <1231859742.442.128.camel@twins>
	 <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
	 <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins>
	 <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	 <1231867314.7141.16.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
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
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231867314.7141.16.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-13 at 18:21 +0100, Peter Zijlstra wrote:
> On Tue, 2009-01-13 at 08:49 -0800, Linus Torvalds wrote:
> > 
> > So do a v10, and ask people to test.
> 
> ---
> Subject: mutex: implement adaptive spinning
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Jan 12 14:01:47 CET 2009
> 
> Change mutex contention behaviour such that it will sometimes busy wait on
> acquisition - moving its behaviour closer to that of spinlocks.
> 

I've spent a bunch of time on this one, and noticed earlier today that I
still had bits of CONFIG_FTRACE compiling.  I wasn't actually tracing
anything, but it seems to have had a big performance hit.

The bad news is the simple spin got much much faster, dbench 50 coming
in at 1282MB/s instead of 580MB/s.  (other benchmarks give similar
results)

v10 is better that not spinning, but its in the 5-10% range.  So, I've
been trying to find ways to close the gap, just to understand exactly
where it is different.

If I take out:
	/*
	 * If there are pending waiters, join them.
	 */
	if (!list_empty(&lock->wait_list))
		break;


v10 pops dbench 50 up to 1800MB/s.  The other tests soundly beat my
spinning and aren't less fair.  But clearly this isn't a good solution.

I tried a few variations, like only checking the wait list once before
looping, which helps some.  Are there other suggestions on better tuning
options?

(I retested v7 and see similar results)

-chris



