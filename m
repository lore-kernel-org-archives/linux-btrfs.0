From: Andi Kleen <andi@firstfloor.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Sun, 11 Jan 2009 21:34:41 +0100
Message-ID: <20090111203441.GQ26290@one.firstfloor.org>
References: <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu> <20090109174158.096dee70.akpm@linux-foundation.org> <20090110030216.GW26290@one.firstfloor.org> <1231676801.25018.150.camel@macbook.infradead.org> <20090111181307.GM26290@one.firstfloor.org> <alpine.LFD.2.00.0901111114230.6528@localhost.localdomain> <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231704939.25018.548.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

> Isn't the ioctl switch stack issue a separate GCC bug?
> 
> It was/is assigning assigning separate space for local variables which

Was -- i think that got fixed in gcc. But again only in newer versions.

> are mutually exclusive. So instead of the stack footprint of the
> function with the switch() being equal to the largest individual stack
> size of all the subfunctions, it's equal to the _sum_ of the stack sizes
> of the subfunctions. Even though it'll never use them all at the same
> time.
> 
> Without that bug, it would have been harmless to inline them all.

True.

-Andi
-- 
ak@linux.intel.com
