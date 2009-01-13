From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
Date: Tue, 13 Jan 2009 17:39:07 +0100
Message-ID: <20090113163907.GA24996@elte.hu>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231863710.7141.3.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>


* Peter Zijlstra <peterz@infradead.org> wrote:

> > Now you're forcing the slow-path on unlock. Maybe it was intentional, 
> > maybe it wasn't. Did you perhaps mean
> > 
> > 	if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
> > 
> > here? I thought we agreed it was safe, if only because it should be 
> > equivalent to just having done "mutex_trylock()" instead of a "real" 
> > lock sequence.
> 
> Yes, that was an 'accident' from -v8, yes we did think the cmpxchg was 
> good, however I did get some spurious lockups on -v7, and I only noticed 
> the thing after I'd done most of the testing, so I decided to let it be 
> for now.
> 
> Let me put the cmpxchg back in and see if this is all still good (only 
> 3*2*2 configs to test :-).

i saw sporadic lockups with -v7 too, so if you send a -v10 with Linus's 
sequence for the unlock it takes about an hour of testing to check whether 
it still occurs.

	Ingo
