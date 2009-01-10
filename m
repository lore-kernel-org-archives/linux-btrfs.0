From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Sun, 11 Jan 2009 10:59:05 +1100
Message-ID: <49693649.1020406@goop.org>
References: <1231441350.14304.48.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901081109300.3283@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901081109300.3283@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Linus Torvalds wrote:
> Actually, the real spin locks are now fair. We use ticket locks on x86.
>
> Well, at least we do unless you enable that broken paravirt support. I'm 
> not at all clear on why CONFIG_PARAVIRT wants to use inferior locks, but I 
> don't much care.
>   

No, it will continue to use ticket locks, but there's the option to 
switch to byte locks or something else.  Ticket locks are awesomely bad 
when the VCPU scheduler fights with the run-order required by the ticket 
order.

    J
