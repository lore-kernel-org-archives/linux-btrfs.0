From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
Date: Mon, 12 Jan 2009 08:20:34 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901120818070.6528@localhost.localdomain>
References: <1231774622.4371.96.camel@laptop> <alpine.LFD.2.00.0901120802430.6528@localhost.localdomain>
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
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901120802430.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>



On Mon, 12 Jan 2009, Linus Torvalds wrote:
> 
> You made it back into the locked version.

Btw, even if you probably had some reason for this, one thing to note is 
that I think Chris' performance testing showed that the version using a 
lock was inferior to his local btrfs hack, while the unlocked version 
actually beat his hack.

Maybe I misunderstood his numbers, though. But if I followed that sub-part 
of the test right, it really means that the locked version is pointless - 
it will never be able to replace peoples local hacks for this same thing, 
because it just doesn't give the performance people are looking for.

Since the whole (and _only_) point of this thing is to perform well, 
that's a big deal.

		Linus
