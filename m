From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Wed, 14 Jan 2009 22:41:58 +0100
Message-ID: <20090114214158.GA9992@elte.hu>
References: <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114105300.66bd014d.akpm@linux-foundation.org> <20090114190008.GA13203@elte.hu> <20090114113638.c818fcf8.akpm@linux-foundation.org> <20090114201435.GA6519@elte.hu> <20090114123017.9acf42d7.akpm@linux-foundation.org> <20090114205122.GC6519@elte.hu> <20090114130642.cf2b18b2.akpm@linux-foundation.org> <20090114211458.GD6519@elte.hu>
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
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760890AbZANVmx@vger.kernel.org>
In-Reply-To: <20090114211458.GD6519@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>


* Ingo Molnar <mingo@elte.hu> wrote:

> > You just disproved your own case :(
> 
> how so? 80% is not enough? I also checked Fedora and it has 
> SCHED_DEBUG=y in its kernel rpms.

Ubuntu has CONFIG_SCHED_DEBUG=y as well in their kernels.

> note that there's also a performance issue here: we generally _dont 
> want_ a debug sysctl overhead in the mutex code or in any fastpath for 
> that matter. So making it depend on SCHED_DEBUG is useful.
> 
> sched_feat() features get optimized out at build time when SCHED_DEBUG 
> is disabled. So it gives us the best of two worlds: the utility of 
> sysctls in the SCHED_DEBUG=y, and they get compiled out in the 
> !SCHED_DEBUG case.

There's a third issue as well: the toggle _is_ intentionally debug-only, 
while sysctls are non-debug and we _really_ dont want feature assymetry 
like that.

It will just splinter the application space: if there's significant 
performance variances then apps will just go the path of least resistence: 
instead of debugging the performance problems properly, the first group of 
applications will be tuned for the sysctl_mutex_spin=0 case, the second 
group of applications will be tuned for the sysctl_mutex_spin=1 case.

And if an enterprise distro decided to flip the default around we'd have a 
real tuning mess.

/sys/debug/sched_features strikes the right kind of balance IMO: it's not 
always available and it's explicitly in debugfs with no stable ABI so apps 
cannot standardize on being able to tweak it, but it's convenient enough 
in practice for developers to depend on it, performance analysis is easy, 
etc., etc.

	Ingo
