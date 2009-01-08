From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Wed, 7 Jan 2009 22:38:18 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901072232580.2429@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain> <1231281801.11687.125.camel@twins> <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins>
 <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org> <20090107213924.GP496@one.firstfloor.org>
 <49652C7C.3000909@novell.com> <alpine.LFD.2.00.0901071510390.3057@localhost.localdomain> <alpine.LFD.2.00.0901071516280.3057@localhost.localdomain> <49657297.9000708@novell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Peter Zijlstra <peterz@infradead.org>,
	paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Gregory Haskins <ghaskins@novell.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49657297.9000708@novell.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Wed, 7 Jan 2009, Gregory Haskins wrote:
> 
> In my defense, the -rt versions of the patches guarantee this is ok
> based on a little hack:

The -rt versions worry about much more than what the mutex code in
mainline does. Linus is correct in his arguments. The adaptive mutex (as 
suppose to what -rt has), is only to help aid in preformance. There are a 
lot of races that can happen in mainline version where lock taking may not 
be fifo, or where we might start to schedule when we could have taken the 
lock. These races are not in -rt, but that is because -rt cares about 
these. But mainline cares more about performance over determinism. This 
means that we have to look at the current code that Peter is submitting 
with a different perspective than we do in -rt.

-- Steve


