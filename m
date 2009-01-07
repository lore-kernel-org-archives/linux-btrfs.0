From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Wed, 7 Jan 2009 22:37:40 +0100
Message-ID: <20090107213740.GO496@one.firstfloor.org>
References: <1231278275.11687.111.camel@twins> <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain> <1231279660.11687.121.camel@twins> <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain> <1231281801.11687.125.camel@twins> <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
	Gregory Haskins <ghaskins@novell.com>,
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

> But we can do that with __get_user(thread_info->cpu) (very unlikely page 
> fault protection due to the possibility of CONFIG_DEBUG_PAGEALLOC) and 
> then validating the cpu. It it's in range, we can use it and verify 
> whether cpu_rq(cpu)->curr has that thread_info.
> 
> So we can do all that locklessly and optimistically, just going back and 
> verifying the results later. This is why "thread_info" is actually a 
> better thing to use than "task_struct" - we can look up the cpu in it with 
> a simple dereference. We knew the pointer _used_ to be valid, so in any 
> normal situation, it will never page fault (and if you have 
> CONFIG_DEBUG_PAGEALLOC and hit a very unlucky race, then performance isn't 
> your concern anyway: we just need to make the page fault be non-lethal ;)

The problem with probe_kernel_address() is that it does lots of
operations around the access in the hot path (set_fs, pagefault_disable etc.), 
so i'm not sure that's a good idea. 

Sure you can probably do better, but that would involve
patching all architectures won't it? Ok I suppose
you could make an ARCH_HAS_blabla white list, but that
wouldn't be exactly pretty.

-Andi
