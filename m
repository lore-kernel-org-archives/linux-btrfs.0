From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Sat, 10 Jan 2009 18:52:41 +0100
Message-ID: <20090110175240.GA1436@ucw.cz>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20081231104533.abfb1cf9.akpm@linux-foundation.org> <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Gregory Haskins <ghaskins@novell.com>,
	Nick Piggin <npiggin@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090106121052.GA27232@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>


> Linus, what do you think about this particular approach of spin-mutexes? 
> It's not the typical spin-mutex i think.
> 
> The thing i like most about Peter's patch (compared to most other adaptive 
> spinning approaches i've seen, which all sucked as they included various 
> ugly heuristics complicating the whole thing) is that it solves the "how 
> long should we spin" question elegantly: we spin until the owner runs on a 
> CPU.

Well; if there's a timeout, that's obviously safe.

But this has no timeout, and Linus wants to play games with accessing
'does owner run on cpu?' lockless. Now, can it mistakenly spin when
the owner is scheduled away? That would deadlock, and without locking,
I'm not sure if we prevent that....

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
