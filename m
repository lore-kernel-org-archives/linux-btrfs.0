From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 9 Jan 2009 12:29:08 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901091227040.6528@localhost.localdomain>
References: <20090108141808.GC11629@elte.hu>  <1231426014.11687.456.camel@twins>  <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>  <1231434515.14304.27.camel@think.oraclecorp.com>  <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
 <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com>  <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain>  <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com>  <20090109153508.GA4671@elte.hu>  <alpine.LFD.2.00.0901090817470.6528@localhost.localdomain>
 <1231532276.2081.12.camel@entropy>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ingo Molnar <mingo@elte.hu>, jim owens <jowens@hp.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
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
To: Nicholas Miell <nmiell@comcast.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231532276.2081.12.camel@entropy>
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 9 Jan 2009, Nicholas Miell wrote:
> 
> Maybe the kernel's backtrace code should be fixed instead of blaming
> gcc.

And maybe people who don't know what they are talking about shouldn't 
speak?

You just loaded the whole f*cking debug info just to do that exact 
analysis. Guess how big it is for the kernel?

Did you even read this discussion? Did you see my comments about why 
kernel backtrace debugging is different from regular user mode debugging?

			Linus
