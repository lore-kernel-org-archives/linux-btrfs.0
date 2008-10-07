From: Chris Mason <chris.mason@oracle.com>
Subject: Re: different oops
Date: Tue, 07 Oct 2008 12:03:05 -0400
Message-ID: <1223395385.16546.124.camel@think.oraclecorp.com>
References: <200810031814.06897.mbuerger@edu.uni-klu.ac.at>
	 <200810032222.42054.mbuerger@edu.uni-klu.ac.at>
	 <1223065590.13375.68.camel@think.oraclecorp.com>
	 <9cdbb57f0810031509m35c71919s965778dc6cb0ec5f@mail.gmail.com>
	 <20081004003129.GC8449@think.oraclecorp.com>
	 <9cdbb57f0810070431w523f90eek63fd74e44add35cd@mail.gmail.com>
	 <1223384193.16546.111.camel@think.oraclecorp.com>
	 <9cdbb57f0810070804i1dfdedarc59d3d9189d621d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Andrea Gelmini <andrea.gelmini@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <9cdbb57f0810070804i1dfdedarc59d3d9189d621d5@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-10-07 at 17:04 +0200, Andrea Gelmini wrote:
> 2008/10/7 Chris Mason <chris.mason@oracle.com>:
> > Btrfs does use more cpu than reiserfs will because of the checksumming,
> I don't think this is the problem. I mean, in same condition, with Reiserfs3,
> I stay between 0.85 - 1.50 load avg.
> Now I easily go from 5 - 10.
> It's hard to believe so much overhead just for CRC.
> Anyway, can I safely mount my /home disabling CRC? I read it about time before.

Yes, you can mount -o nodatasum

> 
> > and you have dm-crypt using CPU as well.  Is the system unresponsive
> > during the high load?
> not exactly. it became slugghish. so, things that was zero-wait, now
> may have seconds of delay.
> something similar a "make -j"...
> now I have doubled the space of the logical volume, and things seems
> better (now, loadavg is not going over 4, doing
> the mirrordir test).
> anyway, I have to use it almost one day, to have a clear idea.

Ok, its important to understand which parts of the FS are using so much
cpu.  It is pretty easy to tell based on the output of top (which procs
are consuming the most time).

> 
> > The load on linux is somewhat strange because it reflects both the
> > number of procs waiting on IO and the number using CPU.  Running top and
> > looking at the process states will help figure out which one is the
> > cause 'D' means IO and 'R' means CPU.
> yes.
> well, the strange things is the system is faster than before doing
> write. but looking at top (I use htop, but it doesn't matter), it
> doesn't seem something process related, but seems kernel alway busy
> doing something I can't figure out.
> 
> are there some tests I can run just to have some raw number to try to
> explain this?

Which procs are using the most time in top?

-chris


