From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Sat, 10 Jan 2009 04:02:16 +0100
Message-ID: <20090110030216.GW26290@one.firstfloor.org>
References: <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu> <20090109174158.096dee70.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
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
	Sven Dietrich <SDietrich@novell.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090109174158.096dee70.akpm@linux-foundation.org>
List-ID: <linux-btrfs.vger.kernel.org>

> A side-effect of the inline fetish is that a lot of it goes into header
> files, thus requiring that those header files #include lots of other
> headers, thus leading to, well, the current mess.

I personally also always found it annoying while grepping that
part of the code is in a completely different directory.
e.g. try to go through TCP code without jumping to .hs all the time.

Long term that problem will hopefully disappear, as gcc learns to do cross
source file inlining (like a lot of other compilers already do)

-Andi

-- 
ak@linux.intel.com
