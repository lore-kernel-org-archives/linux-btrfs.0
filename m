From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 9 Jan 2009 09:14:44 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901090911580.6528@localhost.localdomain>
References: <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
 <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com>
 <20090109084620.3c711aad@infradead.org> <49678095.2030803@zytor.com> <alpine.DEB.1.10.0901091206460.17378@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Dirk Hohndel <hohndel@infradead.org>,
	Ingo Molnar <mingo@elte.hu>, jim owens <jowens@hp.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901091206460.17378@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 9 Jan 2009, Steven Rostedt wrote:
> 
> I vote for the, get rid of the current inline, rename __always_inline to 
> inline, and then remove all non needed inlines from the kernel.

This is what we do all the time, and historically have always done.

But
 - CONFIG_OPTIMIZE_INLINING=y screws that up
and
 - gcc still inlines even big functions static that have no markings at 
   all.

> We'll, probably start adding a lot more noinlines.

That's going to be very painful. Especially since the cases we really want 
to not inline is the random drivers etc - generally not "hot in the 
cache", but they are the ones that cause the most oopses (not per line, 
but globally - because there's just so many drivers).

		Linus
