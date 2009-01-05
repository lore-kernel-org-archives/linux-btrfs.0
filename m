From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Btrfs for mainline
Date: Tue, 6 Jan 2009 01:47:23 +1100
Message-ID: <200901060147.24285.nickpiggin@yahoo.com.au>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Peter Zijlstra <peterz@infradead.org>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Gregory Haskins <ghaskins@novell.com>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090104184103.GE2002@parisc-linux.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 05 January 2009 05:41:03 Matthew Wilcox wrote:
> On Sun, Jan 04, 2009 at 07:21:50PM +0100, Peter Zijlstra wrote:
> > The -rt tree has adaptive spin patches for the rtmutex code, its really
> > not all that hard to do -- the rtmutex code is way more tricky than the
> > regular mutexes due to all the PI fluff.
> >
> > For kernel only locking the simple rule: spin iff the lock holder is
> > running proved to be simple enough. Any added heuristics like max spin
> > count etc. only made things worse. The whole idea though did make sense
> > and certainly improved performance.
>
> That implies moving
>
>         struct thread_info      *owner;
>
> out from under the CONFIG_DEBUG_MUTEXES code.  One of the original
> justifications for mutexes was:
>
>  - 'struct mutex' is smaller on most architectures: .e.g on x86,
>    'struct semaphore' is 20 bytes, 'struct mutex' is 16 bytes.
>     A smaller structure size means less RAM footprint, and better
>     CPU-cache utilization.
>
> I'd be reluctant to reverse that decision just for btrfs.
>
> Benchmarking required!  Maybe I can put a patch together that implements
> the simple 'spin if it's running' heuristic and throw it at our
> testing guys on Monday ...

adaptive locks have traditionally (read: Linus says) indicated the locking
is suboptimal from a performance perspective and should be reworked. This
is definitely the case for the -rt patchset, because they deliberately
trade performance by change even very short held spinlocks to sleeping locks. 

So I don't really know if -rt justifies adaptive locks in mainline/btrfs.
Is there no way for the short critical sections to be decoupled from the
long/sleeping ones?

