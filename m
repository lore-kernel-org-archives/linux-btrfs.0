From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Wed, 7 Jan 2009 15:57:06 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901071552550.3057@localhost.localdomain>
References: <87r63ljzox.fsf@basil.nowhere.org>  <20090103191706.GA2002@parisc-linux.org> <1231368870.6686.16.camel@norville.austin.ibm.com> <alpine.LFD.2.00.0901071518570.3057@localhost.localdomain> <alpine.DEB.1.10.0901071848431.23456@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
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
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901071848431.23456@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, 7 Jan 2009, Steven Rostedt wrote:
> 
> Should that be:
> 
> #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_MEMORY_HOTPLUG)

Well, probably CONFIG_MEMORY_HOTREMOVE, no? And I'd actually suggest that 
unplugging should have a stop-machine if it doesn't already, just because 
it's such a special case - like module removal.

			Linus
