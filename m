From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 08:37:08 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901090835010.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain> <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
 <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org> <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu>
 <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <49677A0E.3090709@zytor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
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
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49677A0E.3090709@zytor.com>
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 9 Jan 2009, H. Peter Anvin wrote:
> 
> __asm_inline was my suggestion, to distinguish "inline this
> unconditionally because gcc screws up in the presence of asm()"

THERE IS NO ASM IN THERE!

Guys, look at the code. No asm. The whole notion that gcc gets confused by 
inline asms IS BOGUS. It's simply not TRUE. Gcc gets confused because gcc 
is confused, and it has NOTHING to do with inline asms.

So please don't confuse things further. 

		Linus
