From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
Date: Mon, 12 Jan 2009 18:16:21 +0100
Message-ID: <1231780581.4371.193.camel@laptop>
References: <1231774622.4371.96.camel@laptop>
	 <alpine.LFD.2.00.0901120802430.6528@localhost.localdomain>
	 <alpine.LFD.2.00.0901120818070.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901120818070.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-01-12 at 08:20 -0800, Linus Torvalds wrote:
> 
> On Mon, 12 Jan 2009, Linus Torvalds wrote:
> > 
> > You made it back into the locked version.
> 
> Btw, even if you probably had some reason for this, one thing to note is 
> that I think Chris' performance testing showed that the version using a 
> lock was inferior to his local btrfs hack, while the unlocked version 
> actually beat his hack.
> 
> Maybe I misunderstood his numbers, though. But if I followed that sub-part 
> of the test right, it really means that the locked version is pointless - 
> it will never be able to replace peoples local hacks for this same thing, 
> because it just doesn't give the performance people are looking for.
> 
> Since the whole (and _only_) point of this thing is to perform well, 
> that's a big deal.

Like said in reply to Chris' email, I just wanted to see if fairness was
worth the effort, because the pure unlocked spin showed significant
unfairness (and I know some people really care about some level of
fairness).

Initial testing with the simple test-mutex thing didn't show too bad
numbers.

