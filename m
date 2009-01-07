From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v4][RFC]: mutex: implement adaptive spinning
Date: Wed, 7 Jan 2009 08:25:30 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
References: <87r63ljzox.fsf@basil.nowhere.org>  <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>  <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>  <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>
  <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>  <49636799.1010109@novell.com>  <20090106214229.GD6741@linux.vnet.ibm.com>  <1231278275.11687.111.camel@twins>  <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>
 <1231279660.11687.121.camel@twins>  <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>  <1231281801.11687.125.camel@twins>  <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231329783.11687.287.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, 7 Jan 2009, Peter Zijlstra wrote:
>
> Change mutex contention behaviour such that it will sometimes busy wait on
> acquisition - moving its behaviour closer to that of spinlocks.

Ok, this one looks _almost_ ok.

The only problem is that I think you've lost the UP case. 

In UP, you shouldn't have the code to spin, and the "spin_or_schedule()" 
should fall back to just the schedule case.

It migth also be worthwhile to try to not set the owner, and re-organize 
that a bit (by making it a inline function that sets the owner only for 
CONFIG_SMP or lockdep/debug). 

			Linus
