From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 9 Jan 2009 09:57:30 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901090954410.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org> <20090109172011.GD26290@one.firstfloor.org>
 <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org> <20090109094142.367012b6@infradead.org> <20090109180213.GH26290@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dirk Hohndel <hohndel@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	jim owens <jowens@hp.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090109180213.GH26290@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 9 Jan 2009, Andi Kleen wrote:
> 
> Universal noinline would also be a bad idea because of its
> costs (4.1% text size increase). Perhaps should make it
> a CONFIG option for debugging though.

That's _totally_ the wrong way.

If you can reproduce an issue on your machine, you generally don't care 
about inline, because you can see the stack, do the whole "gdb vmlinux" 
thing, and you generally have tools to help you decode things. Including 
just recompiling the kernel with an added noinline.

But _users_ just get their oopses sent automatically. So it's not about 
"debugging kernels", it's about _normal_ kernels. They are the ones that 
need to be debuggable, and the ones that care most about things like the 
symbolic EIP being as helpful as possible.

			Linus
