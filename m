From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Thu, 15 Jan 2009 16:04:18 -0500
Message-ID: <1232053458.8269.139.camel@think.oraclecorp.com>
References: <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins>
	 <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	 <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop>
	 <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu>
	 <20090114192811.GA19691@elte.hu> <20090115174440.GF29283@parisc-linux.org>
	 <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain>
	 <20090115180844.GL22472@elte.hu>
	 <alpine.LFD.2.00.0901151015270.6528@localhost.localdomain>
	 <1232047618.8269.93.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901151208310.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901151208310.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-01-15 at 12:13 -0800, Linus Torvalds wrote:
> 
> On Thu, 15 Jan 2009, Chris Mason wrote:
> 
> > On Thu, 2009-01-15 at 10:16 -0800, Linus Torvalds wrote:
> > > 
> > > Umm. Except if you wrote the code nicely and used spinlocks, you wouldn't 
> > > hold the lock over all those unnecessary and complex operations.
> > 
> > While this is true, there are examples of places we should expect
> > speedups for this today.
> 
> Sure. There are cases where we do have to use sleeping things, because the 
> code is generic and really can't control what lower levels do, and those 
> lower levels have to be able to sleep.
> 
> So:
> 
> > Concurrent file creation/deletion in a single dir will often find things
> > hot in cache and not have to block anywhere (mail spools).
> 
> The inode->i_mutex thing really does need to use a mutex, and spinning 
> will help. Of course, it should only help when you really have lots of 
> concurrent create/delete/readdir in the same directory, and that hopefully 
> is a very rare load in real life, but hey, it's a valid one.
> 

Mail server deletes is the common one I can think of.  Mail server
creates end up bound by fsync in my testing here, so it doesn't quite
show up unless your IO subsystem is much faster than your kernel.


> > Concurrent O_DIRECT aio writes to the same file, where i_mutex is
> > dropped early on.
> 
> Won't the actual IO costs generally dominate in everything but trivial 
> benchmarks?

Benchmarks in the past on large IO rigs have shown it.  It isn't
something you're going to see on a regular sized server, but for AIO +
O_DIRECT, the pieces that hold i_mutex can be seen in real life.

[ re: pipes, ok I don't know of realistic pipe benchmarks but I'll run
them if people can suggest one ]

I ran a mailserver delivery simulation (fs_mark), and then my standard
dbench/4k creates/4k stats on ext3 and ext4.

ext3 had very similar scores with spinning on and off.

ext4 scored the same on mailserver delivery (fsync bound apparently)

For the others:

dbench no spin: 1970MB/s
dbench spin:    3036MB/s

(4k creates in file/sec, higher is better)
4k creates no spin: avg 418.91 median 346.12 std 306.37 high 2025.80 low 338.11
4k creates spin:    avg 406.09 median 344.27 std 179.95 high 1249.78 low 336.10

Somehow the spinning mutex made ext4 more fair.  The 4k create test had
50 procs doing file creates in parallel, but each proc was operating in
its own directory.  So, they shouldn't actually be competing for any of
the VFS mutexes.

The stat run was the same patched/unpatched, probably for the same
reason.

None of this is very earth shattering, apparently my canned benchmarks
for btrfs pain points don't apply that well to ext34.  

-chris


