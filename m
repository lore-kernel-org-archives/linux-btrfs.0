From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Wed, 14 Jan 2009 12:21:31 -0800
Message-ID: <20090114122131.021e96b0.akpm@linux-foundation.org>
References: <1231774622.4371.96.camel@laptop>
	<1231859742.442.128.camel@twins>
	<alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
	<1231863710.7141.3.camel@twins>
	<1231864854.7141.8.camel@twins>
	<alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	<1231867314.7141.16.camel@twins>
	<1231952436.14825.28.camel@laptop>
	<20090114183319.GA18630@elte.hu>
	<20090114105300.66bd014d.akpm@linux-foundation.org>
	<20090114190008.GA13203@elte.hu>
	<20090114113638.c818fcf8.akpm@linux-foundation.org>
	<1231962650.14825.55.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: mingo@elte.hu, torvalds@linux-foundation.org,
	paulmck@linux.vnet.ibm.com, ghaskins@novell.com, matthew@wil.cx,
	andi@firstfloor.org, chris.mason@oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
	pmorreale@novell.com, SDietrich@novell.com,
	dmitry.adamushko@gmail.com, hannes@cmpxchg.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231962650.14825.55.camel@laptop>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 14 Jan 2009 20:50:50 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2009-01-14 at 11:36 -0800, Andrew Morton wrote:
> 
> > Do people enable CONFIG_SCHED_DEBUG?
> 
> Well, I have it always enabled, but I've honestly no idea if that makes
> me weird.

It'd be weird if you're not weird.

> > CONFIG_DEBUG_MUTEXES=n, CONFIG_SCHED_DEBUG=y is getting to be a pretty
> > small subset?
> 
> Could be, do you fancy me doing a sysctl? shouldn't be hard.

The /sys/debug knob depends upon CONFIG_SCHED_DEBUG, I assume?

umm, yes, I do think that it would be prudent to make this control
unconditionally available.  Experience tells us that any regressions
which this change causes could take a long time to turn up - sometimes
years.  By which time the people who are reporting the regressions are
running packaged kernels, and if that packaged kernel didn't enable
CONFIG_SCHED_DEBUG, we're a bit screwed.

Did we end up deciding to remove the CONFIG_DEBUG_MUTEXES=n dependency?
