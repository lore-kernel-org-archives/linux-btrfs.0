From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] btrfs file write debugging patch
Date: Tue, 1 Mar 2011 08:51:45 -0600
Message-ID: <AANLkTi=zQR_0_8m5RhPYnFB11=h+0URUSmcNMcOn+mjE@mail.gmail.com>
References: <1298857223-sup-5612@think>
	<201102281114.00018.johannes.hirte@fem.tu-ilmenau.de>
	<20110228161056.GA2769@localhost.localdomain>
	<1298911556.11118.8.camel@mainframe>
	<AANLkTin_Hjr3StjWUGrwCHBzhk_kwj-G2WqxZM6=CqN2@mail.gmail.com>
	<AANLkTikex7g4+dc9qiPdL_xRk5SoFxE3TCfN7dg3kaR2@mail.gmail.com>
	<1865303E0DED764181A9D882DEF65FB68662A5EA63@shsmsx502.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: =?ISO-8859-1?Q?Maria_Wikstr=F6m?= <maria@ponstudios.se>,
	Josef Bacik <josef@redhat.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Zhong, Xin" <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1865303E0DED764181A9D882DEF65FB68662A5EA63@shsmsx502.ccr.corp.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 1, 2011 at 4:14 AM, Zhong, Xin <xin.zhong@intel.com> wrote:
> Is your system running out of memory or is there any other thread like flush-btrfs competing for the same page?
>

There's no sign of memory pressure.  Although I only have 1 GB in this
box, I'm still show ~1/2 GB RAM free during this build.  There's no
swap space allocated, and nothing in dmesg that indicates there's a
transient spike of RAM pressure.

> I can only see one process in your ftrace log. You may need to trace all btrfs.ko function calls instead of a single process. Thanks!
>

That ftrace.log was run with ftrace defaults for a function trace.  It
should collect calls from the whole system.

For the sake of consistency, I am intentionally trying to insure that
very few other things are going on at the same time as this build.
And I'm building with "-j1" so things will happen the same way each
time.

Also, I supplied just the tail end of the trace log.  The full log
shows a few of the other build processes leading up to the problem,
but the ftrace ring buffer fills up surprisingly fast.  Even with a
50MB ring buffer for ftrace, I usually collect less than 1 second of
information when something busy like a build is going on.

Let me know if you'd like to see the full log.  It's bigger, but I can
find someplace to put it.

But I'm pretty sure that wmldbcreate is the only thing that is going
on when the breakage occurs.  Otherwise I wouldn't get such consistent
breakage in the same spot every time.
