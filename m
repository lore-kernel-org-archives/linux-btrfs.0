From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Thu, 15 Jan 2009 10:44:40 -0700
Message-ID: <20090115174440.GF29283@parisc-linux.org>
References: <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu> <20090114192811.GA19691@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
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
	Dmitry Adamushko <dmitry.adamushko@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090114192811.GA19691@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 14, 2009 at 08:28:11PM +0100, Ingo Molnar wrote:
>                       [v2.6.14]     [v2.6.29]
> 
>                       Semaphores  | Mutexes
>             ----------------------------------------------
>                                   | no-spin           spin
>                                   |
>   [tmpfs]   ops/sec:       50713  |  291038         392865       (+34.9%)
>   [ext3]    ops/sec:       45214  |  283291         435674       (+53.7%)
> 
> A 10x macro-performance improvement on ext3, compared to 2.6.14 :-)
> 
> While lots of other details got changed meanwhile, i'm sure most of the 
> performance win on this particular VFS workload comes from mutexes.

I asked a couple of our benchmarking teams to try -v9.  Neither the OLTP
benchmark, nor the kernel-perf test suite found any significant
performance change.  I suspect mutex contention isn't a significant
problem for most workloads.

Has anyone found a non-synthetic benchmark where this makes a
significant difference?  Aside from btrfs, I mean.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
