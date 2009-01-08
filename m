From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 08 Jan 2009 20:23:29 +0100
Message-ID: <1231442609.27687.1.camel@twins>
References: <1231441350.14304.48.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901081109300.3283@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Chris Mason <chris.mason@oracle.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@elte.hu>, paulmck@linux.vnet.ibm.com,
	Gregory Haskins <ghaskins@novell.com>,
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762070AbZAHTX6@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901081109300.3283@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-01-08 at 11:13 -0800, Linus Torvalds wrote:
> 
> Well, at least we do unless you enable that broken paravirt support. I'm 
> not at all clear on why CONFIG_PARAVIRT wants to use inferior locks, but I 
> don't much care.

Because the virtual cpu that has the ticket might not get scheduled for
a while, even though another vcpu with a spinner is scheduled.

The whole (para)virt is a nightmare in that respect.
