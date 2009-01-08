From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 08 Jan 2009 18:23:12 +0100
Message-ID: <1231435392.11687.520.camel@twins>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
	 <1231347442.11687.344.camel@twins>
	 <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
	 <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
	 <1231365115.11687.361.camel@twins>
	 <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>
	 <1231366716.11687.377.camel@twins>
	 <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>
	 <1231408718.11687.400.camel@twins>  <20090108141808.GC11629@elte.hu>
	 <1231426014.11687.456.camel@twins>
	 <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
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
In-Reply-To: <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-01-08 at 08:58 -0800, Linus Torvalds wrote:
> 
> Ok, I've gone through -v7, and I'm sure you're all shocked to hear it, but 
> I have no complaints. 

*cheer*, except I guess we need to figure out what goes bad for Chris.

> Except that you dropped all the good commit 
> commentary you had earlier ;)

Yeah, I've yet to add that back, will do.

> The patch looks pretty good (except for the big "#if 0" block in 
> mutex-debug.c that I hope gets fixed, but I can't even really claim that I 
> can be bothered), the locking looks fine (ie no locking at all), and the 
> numbers seem pretty convinving.
> 
> Oh, and I think the open-coded
> 
> 	atomic_cmpxchg(count, 1, 0) == 1
> 
> could possibly just be replaced with a simple __mutex_fastpath_trylock(). 
> I dunno.

__mutex_fastpath_trylock() isn't always that neat -- see
include/asm-generic/mutex-xchg.h -- and its a NOP on DEBUG_MUTEXES.

Note how I used old_val for the list_empty() thing as well, we could
possibly drop that extra condition though.

