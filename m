From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 09 Jan 2009 10:07:44 -0800
Message-ID: <49679270.1090600@zytor.com>
References: <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org> <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org> <20090109173914.GD6936@parisc-linux.org> <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
	Dirk Hohndel <hohndel@infradead.org>,
	Ingo Molnar <mingo@elte.hu>, jim owens <jowens@hp.com>,
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
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz,
	richard.guenther@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Linus Torvalds wrote:
> 
> So we do have special issues. And exactly _because_ we have special issues 
> we should also expect that some compiler defaults simply won't ever really 
> be appropriate for us.
> 

That is, of course, true.

However, the Linux kernel (and quite a few other kernels) is a very 
important customer of gcc, and adding sustainable modes for the kernel 
that we can rely on is probably something we can work with them on.

I think the relationship between the gcc and Linux kernel people is 
unnecessarily infected, and cultivating a more constructive relationship 
would be good.  I suspect a big part of the reason for the oddities is 
that the timeline for the kernel community from making a request into 
gcc until we can actually rely on it is *very* long, and so we end up 
having to working things around no matter what (usually with copious 
invective), and the gcc people have other customers with shorter lead 
times which therefore drive their development more.

	-hpa
