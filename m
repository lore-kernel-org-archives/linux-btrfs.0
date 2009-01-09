From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 18:40:31 +0100 (CET)
Message-ID: <alpine.LRH.1.10.0901091815140.24105@twin.jikos.cz>
References: <1231441350.14304.48.camel@think.oraclecorp.com>  <alpine.LFD.2.00.0901081109300.3283@localhost.localdomain> <1231442609.27687.1.camel@twins>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
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
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231442609.27687.1.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 8 Jan 2009, Peter Zijlstra wrote:

> > Well, at least we do unless you enable that broken paravirt support. 
> > I'm not at all clear on why CONFIG_PARAVIRT wants to use inferior 
> > locks, but I don't much care.
> Because the virtual cpu that has the ticket might not get scheduled for
> a while, even though another vcpu with a spinner is scheduled.
> The whole (para)virt is a nightmare in that respect.

Hmm, are we in fact really using byte locks in CONFIG_PARAVIRT situation? 
Where are we actually setting pv_lock_ops.spin_lock pointer to point to 
__byte_spin_lock?

Such initialization seems to happen only in paravirt_use_bytelocks() 
function, but my blind eyes prevent me from finding a callsite from which 
this function would eventually get called.

-- 
Jiri Kosina
SUSE Labs

