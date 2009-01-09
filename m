From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 8 Jan 2009 19:42:48 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901081940260.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain> <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
 <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <1231444786.5715.8.camel@brick> <4966ABF9.9080409@zytor.com> <20090109033531.GR496@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
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
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090109033531.GR496@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 9 Jan 2009, Andi Kleen wrote:
> 
> I actually often use noinline when developing code simply because it 
> makes it easier to read oopses when gcc doesn't inline ever static
> (which it normally does if it only has a single caller)

Yes. Gcc inlining is a total piece of sh*t.

Gcc doesn't inline enough when we ask it to, and inlines too damn 
aggressively when we don't. It seems to almost totally ignore the inline 
hint. 

Oh, well. The best option tends to be

 - mark things "noinline" just to make sure gcc doesn't screw up.

 - make "inline" mean "must_inline".

 - maybe add a new "maybe_inline" to be the "inline" hint that gcc uses.

because quite frankly, depending on gcc to do the right thing is not 
working out.

			Linus
