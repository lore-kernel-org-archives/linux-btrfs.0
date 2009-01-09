From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
	impact
Date: Fri, 9 Jan 2009 12:13:25 -0500
Message-ID: <20090109171324.GA29587@infradead.org>
References: <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: jim owens <jowens@hp.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49675920.4050205@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 09, 2009 at 09:03:12AM -0500, jim owens wrote:
> They also know inlining may increase program object size.
> That inlining will reduce object size on many architectures
> if the function is small is just a happy side effect to them.

The problem is that the threshold for that is architecture specific.
While e.g. x86 has relatively low overhead of prologue/epilogue other
architectures like s390 have enormous overhead.  So handling this in
the compiler would be optimal, but it would need at least whole-program
optimization and a compiler aware of the inline assembly to get it
half-way right.

