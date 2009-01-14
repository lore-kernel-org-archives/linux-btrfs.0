From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Wed, 14 Jan 2009 21:27:36 +0100
Message-ID: <20090114202736.GB6519@elte.hu>
References: <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114105300.66bd014d.akpm@linux-foundation.org> <20090114190008.GA13203@elte.hu> <20090114113638.c818fcf8.akpm@linux-foundation.org> <1231962650.14825.55.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
	ghaskins@novell.com, matthew@wil.cx, andi@firstfloor.org,
	chris.mason@oracle.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	tglx@linutronix.de, npiggin@suse.de, pmorreale@novell.com,
	SDietrich@novell.com, dmitry.adamushko@gmail.com,
	hannes@cmpxchg.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231962650.14825.55.camel@laptop>
List-ID: <linux-btrfs.vger.kernel.org>


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2009-01-14 at 11:36 -0800, Andrew Morton wrote:
> 
> > Do people enable CONFIG_SCHED_DEBUG?
> 
> Well, I have it always enabled, but I've honestly no idea if that makes
> me weird.
> 
> > CONFIG_DEBUG_MUTEXES=n, CONFIG_SCHED_DEBUG=y is getting to be a pretty 
> > small subset?
> 
> Could be, do you fancy me doing a sysctl? shouldn't be hard.

i dunno, why another fancy sysctl for something that fits quite nicely 
into the existing sched_features scheme that we've been using for such 
purposes for the past 3-4 kernel releases?

we always provided various toggles for new scheduler features via 
/sys/debug/sched_features, so that people can do performance regression 
testing, and it works quite well.

	Ingo
