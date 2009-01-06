From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 06 Jan 2009 11:23:43 -0500
Message-ID: <1231259023.4290.159.camel@think.oraclecorp.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
	 <1230765549.7538.8.camel@think.oraclecorp.com>
	 <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>
	 <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org>
	 <1231242031.11687.97.camel@twins>
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
	Gregory Haskins <ghaskins@novell.com>,
	Nick Piggin <npiggin@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231242031.11687.97.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-06 at 12:40 +0100, Peter Zijlstra wrote:
> Subject: mutex: adaptive spin
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Jan 06 12:32:12 CET 2009
> 
> Based on the code in -rt, provide adaptive spins on generic mutexes.

I already sent Peter details, but the patch has problems without mutex
debugging turned on.  So it isn't quite ready for benchmarking yet.

-chris


