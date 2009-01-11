From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex:
 implement adaptive spinning
Date: Sun, 11 Jan 2009 20:15:39 +0000
Message-ID: <1231704939.25018.548.camel@macbook.infradead.org>
References: <1231537320.5726.2.camel@brick>
	 <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain>
	 <20090109231227.GA25070@elte.hu>
	 <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain>
	 <20090110010125.GA31031@elte.hu>
	 <20090109174158.096dee70.akpm@linux-foundation.org>
	 <20090110030216.GW26290@one.firstfloor.org>
	 <1231676801.25018.150.camel@macbook.infradead.org>
	 <20090111181307.GM26290@one.firstfloor.org>
	 <alpine.LFD.2.00.0901111114230.6528@localhost.localdomain>
	 <20090111201427.GP26290@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090111201427.GP26290@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2009-01-11 at 21:14 +0100, Andi Kleen wrote:
> 
> On the other hand (my personal opinion, not shared by everyone) is 
> that the ioctl switch stack issue is mostly only a problem with 4K 
> stacks and in the rare cases when I still run 32bit kernels
> I never set that option because I consider it russian roulette
> (because there undoutedly dangerous dynamic stack growth cases that 
> checkstack.pl doesn't flag) 

Isn't the ioctl switch stack issue a separate GCC bug?

It was/is assigning assigning separate space for local variables which
are mutually exclusive. So instead of the stack footprint of the
function with the switch() being equal to the largest individual stack
size of all the subfunctions, it's equal to the _sum_ of the stack sizes
of the subfunctions. Even though it'll never use them all at the same
time.

Without that bug, it would have been harmless to inline them all.
		
-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

