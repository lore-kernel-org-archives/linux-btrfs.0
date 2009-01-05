From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs for mainline
Date: Mon, 05 Jan 2009 09:34:23 -0500
Message-ID: <1231166063.4290.37.camel@think.oraclecorp.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
	 <1230765549.7538.8.camel@think.oraclecorp.com>
	 <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>
	 <1231093310.27690.5.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Gregory Haskins <ghaskins@novell.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231093310.27690.5.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2009-01-04 at 19:21 +0100, Peter Zijlstra wrote:
> On Sat, 2009-01-03 at 12:17 -0700, Matthew Wilcox wrote:
> > > - locking.c needs a lot of cleanup.
> > > If combination spinlocks/mutexes are really a win they should be 
> > > in the generic mutex framework. And I'm still dubious on the
> > hardcoded 
> > > numbers.
> > 
> > I don't think this needs to be cleaned up before merge.  I've spent
> > an hour or two looking at it, and while we can do a somewhat better
> > job as part of the generic mutex framework, it's quite tricky (due to
> > the different <asm/mutex.h> implementations).  It has the potential to
> > introduce some hard-to-hit bugs in the generic mutexes, and there's some
> > API discussions to have.
> 
> I'm really opposed to having this in some filesystem. Please remove it
> before merging it.
> 

It is 5 lines in a single function that is local to btrfs.  I'll be
happy to take it out when a clear path to a replacement is in.

I know people have been doing work in this area for -rt, and do not want
to start a parallel effort to change things.

I'm not trying to jump into the design discussions because there are
people already working on it who know the issues much better than I do. 

But, if anyone working on adaptive mutexes is looking for a coder,
tester, use case, or benchmark for their locking scheme, my hand is up.

Until then, this is my for loop, there are many like it, but this one is
mine.

-chris


