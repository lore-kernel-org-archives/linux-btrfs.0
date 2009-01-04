From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Btrfs for mainline
Date: Sun, 04 Jan 2009 19:21:50 +0100
Message-ID: <1231093310.27690.5.camel@twins>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
	 <1230765549.7538.8.camel@think.oraclecorp.com>
	 <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Gregory Haskins <ghaskins@novell.com>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090103191706.GA2002@parisc-linux.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2009-01-03 at 12:17 -0700, Matthew Wilcox wrote:
> > - locking.c needs a lot of cleanup.
> > If combination spinlocks/mutexes are really a win they should be 
> > in the generic mutex framework. And I'm still dubious on the
> hardcoded 
> > numbers.
> 
> I don't think this needs to be cleaned up before merge.  I've spent
> an hour or two looking at it, and while we can do a somewhat better
> job as part of the generic mutex framework, it's quite tricky (due to
> the different <asm/mutex.h> implementations).  It has the potential to
> introduce some hard-to-hit bugs in the generic mutexes, and there's some
> API discussions to have.

I'm really opposed to having this in some filesystem. Please remove it
before merging it.

The -rt tree has adaptive spin patches for the rtmutex code, its really
not all that hard to do -- the rtmutex code is way more tricky than the
regular mutexes due to all the PI fluff.

For kernel only locking the simple rule: spin iff the lock holder is
running proved to be simple enough. Any added heuristics like max spin
count etc. only made things worse. The whole idea though did make sense
and certainly improved performance.

We've also been looking at doing adaptive spins for futexes, although
that does get a little more complex, furthermore, we've never gotten
around to actually doing any code on that.

