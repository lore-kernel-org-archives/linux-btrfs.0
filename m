From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Wed, 14 Jan 2009 12:30:17 -0800
Message-ID: <20090114123017.9acf42d7.akpm@linux-foundation.org>
References: <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
	<1231863710.7141.3.camel@twins>
	<1231864854.7141.8.camel@twins>
	<alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	<1231867314.7141.16.camel@twins>
	<1231952436.14825.28.camel@laptop>
	<20090114183319.GA18630@elte.hu>
	<20090114105300.66bd014d.akpm@linux-foundation.org>
	<20090114190008.GA13203@elte.hu>
	<20090114113638.c818fcf8.akpm@linux-foundation.org>
	<20090114201435.GA6519@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
	paulmck@linux.vnet.ibm.com, ghaskins@novell.com, matthew@wil.cx,
	andi@firstfloor.org, chris.mason@oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
	pmorreale@novell.com, SDietrich@novell.com,
	dmitry.adamushko@gmail.com, hannes@cmpxchg.org
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090114201435.GA6519@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 14 Jan 2009 21:14:35 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 14 Jan 2009 20:00:08 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > On Wed, 14 Jan 2009 19:33:19 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> > > > 
> > > > > Please pull the adaptive-mutexes-for-linus git tree
> > > > 
> > > > <fear>
> > > > 
> > > > - It seems a major shortcoming that the feature is disabled if
> > > >   CONFIG_DEBUG_MUTEXES=y.  It means that lots of people won't test it.
> > 
> > ^^^?
> >  
> > > > - When people hit performance/latency oddities, it would be nice if
> > > >   they had a /proc knob with which they could disable this feature at
> > > >   runtime.
> > > > 
> > > >   This would also be useful for comparative performance testing.
> > > 
> > > Yeah. From my other mail:
> > > 
> > > > > We still have the /sys/debug/sched_features tunable under 
> > > > > CONFIG_SCHED_DEBUG=y, so should this cause any performance regressions 
> > > > > somewhere, it can be pinned down and blamed back on this change 
> > > > > easily, without bisection and without rebooting the box.
> > > 
> > > This kind of easy knob was included early on - this is how all those spin 
> > > versus no-spin numbers were done.
> > 
> > Do people enable CONFIG_SCHED_DEBUG?
> 
> If they suspect performance problems and want to analyze them?

The vast majority of users do not and usually cannot compile their own
kernels.

> Note that CONFIG_SCHED_DEBUG=y is also the default.

akpm:/usr/src/25> echo $ARCH
x86_64
akpm:/usr/src/25> make defconfig
*** Default configuration is based on 'x86_64_defconfig'
#
# configuration written to .config
#
akpm:/usr/src/25> grep SCHED_DEBUG .config 
# CONFIG_SCHED_DEBUG is not set

> > CONFIG_DEBUG_MUTEXES=n, CONFIG_SCHED_DEBUG=y is getting to be a pretty 
> > small subset?
> 
> Those two are the default config settings actually, so i'd expect it to be 
> the most commonly occuring combinations.

akpm:/usr/src/25> grep DEBUG_MUTEXES .config
# CONFIG_DEBUG_MUTEXES is not set

