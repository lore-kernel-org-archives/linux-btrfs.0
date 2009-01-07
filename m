From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Wed, 7 Jan 2009 13:24:24 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901071314490.3057@localhost.localdomain>
References: <1231279660.11687.121.camel@twins> <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain> <1231281801.11687.125.camel@twins> <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
 <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090107210923.GV2002@parisc-linux.org>
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, 7 Jan 2009, Matthew Wilcox wrote:
> 
> I appreciate this is sample code, but using __get_user() on
> non-userspace pointers messes up architectures which have separate
> user/kernel spaces (eg the old 4G/4G split for x86-32).  Do we have an
> appropriate function for kernel space pointers?  Is this a good reason
> to add one?

Yes, you're right. 

We could do the whole "oldfs = get_fs(); set_fs(KERNEL_DS); .. 
set_fs(oldfs);" crud, but it would probably be better to just add an 
architected accessor. Especially since it's going to generally just be a

	#define get_kernel_careful(val,p) __get_user(val,p)

for most architectures.

We've needed that before (and yes, we've simply mis-used __get_user() on 
x86 before rather than add it).

			Linus
