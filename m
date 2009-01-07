From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v4][RFC]: mutex: implement adaptive spinning
Date: Wed, 07 Jan 2009 15:58:17 +0100
Message-ID: <1231340297.11687.301.camel@twins>
References: <87r63ljzox.fsf@basil.nowhere.org> <49636799.1010109@novell.com>
	 <20090106214229.GD6741@linux.vnet.ibm.com>
	 <1231278275.11687.111.camel@twins>
	 <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>
	 <1231279660.11687.121.camel@twins>
	 <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>
	 <1231281801.11687.125.camel@twins> <1231283778.11687.136.camel@twins>
	 <1231329783.11687.287.camel@twins>
	 <c62985530901070650x3264c6d5g14788c5440fe5d3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <c62985530901070650x3264c6d5g14788c5440fe5d3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-01-07 at 15:50 +0100, Fr=C3=A9d=C3=A9ric Weisbecker wrote:
> 2009/1/7 Peter Zijlstra <peterz@infradead.org>:
> > Change mutex contention behaviour such that it will sometimes busy =
wait on
> > acquisition - moving its behaviour closer to that of spinlocks.
> >
> > This concept got ported to mainline from the -rt tree, where it was=
 originally
> > implemented for rtmutexes by Steven Rostedt, based on work by Grego=
ry Haskins.
> >
> > Testing with Ingo's test-mutex application (http://lkml.org/lkml/20=
06/1/8/50)
> > gave a 8% boost for VFS scalability on my testbox:
> >
> >  # echo MUTEX_SPIN > /debug/sched_features
> >  # ./test-mutex V 16 10
> >  2 CPUs, running 16 parallel test-tasks.
> >  checking VFS performance.
> >
> >  avg ops/sec:                74910
> >
> >  # echo NO_MUTEX_SPIN > /debug/sched_features
> >  # ./test-mutex V 16 10
> >  2 CPUs, running 16 parallel test-tasks.
> >  checking VFS performance.
> >
> >  avg ops/sec:                68804
> >
> > The key criteria for the busy wait is that the lock owner has to be=
 running on
> > a (different) cpu. The idea is that as long as the owner is running=
, there is a
> > fair chance it'll release the lock soon, and thus we'll be better o=
ff spinning
> > instead of blocking/scheduling.
> >
> > Since regular mutexes (as opposed to rtmutexes) do not atomically t=
rack the
> > owner, we add the owner in a non-atomic fashion and deal with the r=
aces in
> > the slowpath.
> >
> > Furthermore, to ease the testing of the performance impact of this =
new code,
> > there is means to disable this behaviour runtime (without having to=
 reboot
> > the system), when scheduler debugging is enabled (CONFIG_SCHED_DEBU=
G=3Dy),
> > by issuing the following command:
> >
> >  # echo NO_MUTEX_SPIN > /debug/sched_features
> >
> > This command re-enables spinning again (this is also the default):
> >
> >  # echo MUTEX_SPIN > /debug/sched_features
> >
> > There's also a few new statistic fields in /proc/sched_debug
> > (available if CONFIG_SCHED_DEBUG=3Dy and CONFIG_SCHEDSTATS=3Dy):
> >
> >  # grep mtx /proc/sched_debug
> >  .mtx_spin                      : 2387
> >  .mtx_sched                     : 2283
> >  .mtx_spin                      : 1277
> >  .mtx_sched                     : 1700
> >
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Reviewed-and-signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---

> Sorry I haven't read all the previous talk about the older version.
> But it is possible that, in hopefully rare cases, you enter
> mutex_spin_or_schedule
> multiple times, and try to spin for the same lock each of these times=
=2E
>=20
> For each of the above break,
>=20
> _if you exit the spin because the mutex is unlocked, and someone else
> grab it before you
> _ or simply the owner changed...
>=20
> then you will enter again in mutex_spin_or_schedule, you have some ch=
ances that
> rq->curr =3D=3D the new owner, and then you will spin again.
> And this situation can almost really make you behave like a spinlock.=
=2E.

You understand correctly, that is indeed possible.

> Shouldn't it actually try only one time to spin, and if it calls agai=
n
> mutex_spin_or_schedule()
> then it would be better to schedule()  ?

I don't know, maybe code it up and find a benchmark where it makes a
difference. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
