From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 22:15:13 +0100
Message-ID: <20090109211513.GO26290@one.firstfloor.org>
References: <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org> <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090109133710.GB31845@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

> I've done a finegrained size analysis today (see my other mail in this 
> thread), and it turns out that on gcc 4.3.x the main (and pretty much 
> only) inlining annotation that matters in arch/x86/include/asm/*.h is the 
> onliner patch attached below, annotating constant_test_bit().

That's pretty cool.

Should definitely file a gcc bug report for that though so that
they can fix gcc. Did you already do that or should I?

-Andi
