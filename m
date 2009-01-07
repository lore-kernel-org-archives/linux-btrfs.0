From: "Peter W. Morreale" <pmorreale@novell.com>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Wed, 07 Jan 2009 22:51:05 +0000
Message-ID: <1231368665.3470.513.camel@hermosa.site>
References: <1231283778.11687.136.camel@twins>
	 <1231329783.11687.287.camel@twins>
	 <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
	 <1231347442.11687.344.camel@twins>
	 <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
	 <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
	 <20090107210923.GV2002@parisc-linux.org>
	 <20090107213924.GP496@one.firstfloor.org> <49652C7C.3000909@novell.com>
	 <20090107223317.GB27629@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Gregory Haskins <ghaskins@novell.com>,
	Andi Kleen <andi@firstfloor.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	paulmck@linux.vnet.ibm.com, Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Sven Dietrich <SDietrich@novell.com>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090107223317.GB27629@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-01-07 at 23:33 +0100, Ingo Molnar wrote:
> * Gregory Haskins <ghaskins@novell.com> wrote:
> 
> > Can I ask a simple question in light of all this discussion?
> > 
> > "Is get_task_struct() really that bad?"
> 
> it dirties a cacheline and it also involves atomics.
> 
> Also, it's a small design cleanliness issue to me: get_task_struct() 
> impacts the lifetime of an object - and if a locking primitive has 
> side-effects on object lifetimes that's never nice.
> 

True, but it's for one iteration * NR_CPUS, max.

Best,
-PWM


> 	Ingo
> 

