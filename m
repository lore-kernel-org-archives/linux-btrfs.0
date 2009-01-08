From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 8 Jan 2009 10:30:52 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901081030050.22642@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>  <1231347442.11687.344.camel@twins>  <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>  <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>  <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
  <1231365115.11687.361.camel@twins>  <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>  <1231366716.11687.377.camel@twins>  <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>  <1231408718.11687.400.camel@twins>  <20090108141808.GC11629@elte.hu>
  <1231426014.11687.456.camel@twins>  <alpine.DEB.1.10.0901081003050.22642@gandalf.stny.rr.com> <1231428220.11687.464.camel@twins> <alpine.DEB.1.10.0901081026120.22642@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
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
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901081026120.22642@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Thu, 8 Jan 2009, Steven Rostedt wrote:
> > > > +	/*
> > > > +	 * We need to validate that we can do a
> > > > +	 * get_cpu() and that we have the percpu area.
> > > > +	 */
> > > > +	if (!cpu_online(cpu))
> > > > +		goto out;
> > > 
> > > Should we need to do a "get_cpu" or something? Couldn't the CPU disappear 
> > > between these two calls. Or does it do a stop-machine and the preempt 
> > > disable will protect us?
> > 
> > Did you miss the preempt_disable() a bit up?
> 
> No, let me rephrase it better. Does the preempt_disable protect against
> another CPU from going off line? Does taking a CPU off line do a 
> stop_machine?

I just looked at the cpu hotplug code, and it does call stop machine. All 
is in order ;-)

-- Steve

