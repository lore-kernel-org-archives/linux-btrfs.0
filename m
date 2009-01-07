From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Wed, 7 Jan 2009 23:33:17 +0100
Message-ID: <20090107223317.GB27629@elte.hu>
References: <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org> <20090107213924.GP496@one.firstfloor.org> <49652C7C.3000909@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
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
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Gregory Haskins <ghaskins@novell.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49652C7C.3000909@novell.com>
List-ID: <linux-btrfs.vger.kernel.org>


* Gregory Haskins <ghaskins@novell.com> wrote:

> Can I ask a simple question in light of all this discussion?
> 
> "Is get_task_struct() really that bad?"

it dirties a cacheline and it also involves atomics.

Also, it's a small design cleanliness issue to me: get_task_struct() 
impacts the lifetime of an object - and if a locking primitive has 
side-effects on object lifetimes that's never nice.

	Ingo

