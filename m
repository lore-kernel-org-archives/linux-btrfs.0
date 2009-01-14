From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Wed, 14 Jan 2009 20:28:11 +0100
Message-ID: <20090114192811.GA19691@elte.hu>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
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
	Dmitry Adamushko <dmitry.adamushko@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090114184746.GA21334@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>


* Ingo Molnar <mingo@elte.hu> wrote:

> Latest performance figures, on a 2-socket 16-way Nehalem test-system, 
> running the code above, measured via "test-mutex V 128 10" VFS 
> creat+unlink scalability test on tmpfs and ext3:
> 
>                               no-spin           spin
> 
>  [tmpfs]    avg ops/sec:       291038         392865       (+34.9%)
>  [ext3]     avg ops/sec:       283291         435674       (+53.7%)

Btw., for historic kicks i just went back to v2.6.15-2019-gf17578d - the 
last pre-mutexes semaphore based kernel, using the same .config.

I tracked down two bugs in it to make it boot on a Nehalem, so we can now 
compare the above numbers against historic semaphore performance:

                      [v2.6.14]     [v2.6.29]

                      Semaphores  | Mutexes
            ----------------------------------------------
                                  | no-spin           spin
                                  |
  [tmpfs]   ops/sec:       50713  |  291038         392865       (+34.9%)
  [ext3]    ops/sec:       45214  |  283291         435674       (+53.7%)

A 10x macro-performance improvement on ext3, compared to 2.6.14 :-)

While lots of other details got changed meanwhile, i'm sure most of the 
performance win on this particular VFS workload comes from mutexes.

So i think the long mutex migration pain was definitely worth it.

	Ingo
