From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Mon, 12 Jan 2009 01:56:20 +0000
Message-ID: <20090112015620.GA6428@shareable.org>
References: <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu> <1231549697.5700.7.camel@brick> <alpine.LFD.2.00.0901091713150.6528@localhost.localdomain> <49682C05.7030407@zytor.com> <alpine.LFD.2.00.0901092119100.6528@localhost.localdomain> <20090111005458.GA5363@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
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
	Sven Dietrich <SDietrich@novell.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090111005458.GA5363@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

Ingo Molnar wrote:
> If it's used once in a single .c file it should be inlined even if
> it's large.

As Linus has pointed out, because of GCC not sharing stack among
different inlined functions, the above is surprisingly not true.

In kernel it's a problem due to raw stack usage.

In userspace apps (where stack used is larger), inlining single-call
functions could, paradoxically, run slower due to increased stack
dcache pressure for some larger functions.

-- Jamie
