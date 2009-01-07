From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Wed, 7 Jan 2009 15:40:12 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>
References: <87r63ljzox.fsf@basil.nowhere.org>  <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>  <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>  <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>
  <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>  <49636799.1010109@novell.com>  <20090106214229.GD6741@linux.vnet.ibm.com>  <1231278275.11687.111.camel@twins>  <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>
 <1231279660.11687.121.camel@twins>  <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>  <1231281801.11687.125.camel@twins>  <1231283778.11687.136.camel@twins>  <1231329783.11687.287.camel@twins>  <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
 <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


On Wed, 7 Jan 2009, Linus Torvalds wrote:
> 
> So we can do all that locklessly and optimistically, just going back and 
> verifying the results later. This is why "thread_info" is actually a 
> better thing to use than "task_struct" - we can look up the cpu in it with 
> a simple dereference. We knew the pointer _used_ to be valid, so in any 
> normal situation, it will never page fault (and if you have 
> CONFIG_DEBUG_PAGEALLOC and hit a very unlucky race, then performance isn't 
> your concern anyway: we just need to make the page fault be non-lethal ;)

Wow, and I thought I do some crazy things with side effects of different 
kernel characteristics. So basically, since the owner use to be valid and 
we take the cpu number directly from the thread_info struct, we do not 
need to worry about page faulting.

Next comes the issue to know if the owner is still running. Wouldn't we 
need to do something like

	if (task_thread_info(cpu_rq(cpu)->curr) == owner)

I guess that would have the same characteristic, that even if the task 
struct of cpu_rq(cpu)->curr was freed, we can still reference the 
thread_info. Although, we might get garbage, but we don't care.

I understand that this should not be a problem, but I'm afraid it will 
give me nightmares at night. ;-)

God that code had better be commented well.

-- Steve
