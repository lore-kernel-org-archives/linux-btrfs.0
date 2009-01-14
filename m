From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Wed, 14 Jan 2009 20:33:17 +0100
Message-ID: <20090114193317.GA23227@elte.hu>
References: <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114105300.66bd014d.akpm@linux-foundation.org> <1231960986.14825.45.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231960986.14825.45.camel@laptop>
List-ID: <linux-btrfs.vger.kernel.org>


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2009-01-14 at 10:53 -0800, Andrew Morton wrote:
> > On Wed, 14 Jan 2009 19:33:19 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > Please pull the adaptive-mutexes-for-linus git tree
> > 
> > <fear>
> > 
> > - It seems a major shortcoming that the feature is disabled if
> >   CONFIG_DEBUG_MUTEXES=y.  It means that lots of people won't test it.
> 
> Yes, that's a bit unfortunate, a simple patch to enable that is:
> 
> I must admit I'm a bit stumped on why that debug check triggers, I
> couldn't reproduce today, but Ingo ran into it quite quickly :/

Yes, the debug patch caused this false positive warning on one of my 
test-systems:

Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 255762
------------[ cut here ]------------
WARNING: at kernel/mutex-debug.c:77 debug_mutex_unlock+0x94/0xde()
Hardware name:         
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.29-rc1-tip-00983-ge1af3bd-dirty #1
Call Trace:
 [<ffffffff8024f2f7>] warn_slowpath+0xd8/0xf7
 [<ffffffff8024f5ec>] ? wake_up_klogd+0x9/0x2f
 [<ffffffff80270fd1>] ? graph_lock+0x27/0x66
 [<ffffffff80275329>] ? validate_chain+0xd4d/0xd9f
 [<ffffffff802714c4>] ? save_trace+0x3f/0xb2
 [<ffffffff80275b4f>] ? __lock_acquire+0x7d4/0x832
 [<ffffffff80275c5f>] ? lock_acquire+0xb2/0xc2
 [<ffffffff8025091c>] ? cpu_maps_update_begin+0x17/0x19
 [<ffffffff80271d21>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80270a8e>] debug_mutex_unlock+0x94/0xde
 [<ffffffff80906d71>] __mutex_unlock_slowpath+0xdd/0x152
 [<ffffffff80906df4>] mutex_unlock+0xe/0x10
 [<ffffffff80250955>] cpu_maps_update_done+0x15/0x17
 [<ffffffff808ce8b5>] register_cpu_notifier+0x2c/0x32
 [<ffffffff80d7683e>] page_alloc_init+0x10/0x12
 [<ffffffff80d5ac45>] start_kernel+0x1ba/0x422
 [<ffffffff80d5a140>] ? early_idt_handler+0x0/0x73
 [<ffffffff80d5a2c3>] x86_64_start_reservations+0xae/0xb2
 [<ffffffff80d5a421>] x86_64_start_kernel+0x137/0x146
---[ end trace a7919e7f17c0a725 ]---
Kernel command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty 5 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled pci=nomsi
kernel profiling enabled (shift: 0)
debug: sysrq always enabled.
Initializing CPU#0

So we left that change out from this pull request. It's not a big deal i 
think - mutex debugging always had a different fast-path from no-debug 
mutexes anyway (or a lack of fast-path to begin with). So the performance 
characteristics were always subtly different. Now they might be more 
different - but we'll fix that too.

	Ingo
