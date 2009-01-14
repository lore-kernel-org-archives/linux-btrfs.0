From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Wed, 14 Jan 2009 22:14:58 +0100
Message-ID: <20090114211458.GD6519@elte.hu>
References: <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114105300.66bd014d.akpm@linux-foundation.org> <20090114190008.GA13203@elte.hu> <20090114113638.c818fcf8.akpm@linux-foundation.org> <20090114201435.GA6519@elte.hu> <20090114123017.9acf42d7.akpm@linux-foundation.org> <20090114205122.GC6519@elte.hu> <20090114130642.cf2b18b2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
	paulmck@linux.vnet.ibm.com, ghaskins@novell.com, matthew@wil.cx,
	andi@firstfloor.org, chris.mason@oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
	pmorreale@novell.com, SDietrich@novell.com,
	dmitry.adamushko@gmail.com, hannes@cmpxchg.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090114130642.cf2b18b2.akpm@linux-foundation.org>
List-ID: <linux-btrfs.vger.kernel.org>


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 14 Jan 2009 21:51:22 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > > > Do people enable CONFIG_SCHED_DEBUG?
> > > > 
> > > > If they suspect performance problems and want to analyze them?
> > > 
> > > The vast majority of users do not and usually cannot compile their own 
> > > kernels.
> > 
> > ... which they derive from distro kernels or some old .config they always 
> > used, via 'make oldconfig'. You are arguing against well-established facts 
> > here.
> > 
> > If you dont believe my word for it, here's an analysis of all kernel 
> > configs posted to lkml in the past 8 months:
> > 
> >    $ grep ^CONFIG_SCHED_DEBUG linux-kernel | wc -l
> >    424
> > 
> >    $ grep 'CONFIG_SCHED_DEBUG is not' linux-kernel | wc -l
> >    109
> > 
> > i.e. CONFIG_SCHED_DEBUG=y is set in 80% of the configs. A large majority 
> > of testers has it enabled and /sys/debug/sched_features was always a good 
> > mechanism that we used for runtime toggles.
> 
> You just disproved your own case :(

how so? 80% is not enough? I also checked Fedora and it has SCHED_DEBUG=y 
in its kernel rpms.

note that there's also a performance issue here: we generally _dont want_ 
a debug sysctl overhead in the mutex code or in any fastpath for that 
matter. So making it depend on SCHED_DEBUG is useful.

sched_feat() features get optimized out at build time when SCHED_DEBUG is 
disabled. So it gives us the best of two worlds: the utility of sysctls in 
the SCHED_DEBUG=y, and they get compiled out in the !SCHED_DEBUG case.

	Ingo
