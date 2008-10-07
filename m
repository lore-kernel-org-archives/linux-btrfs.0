From: "Andrea Gelmini" <andrea.gelmini@gmail.com>
Subject: Re: different oops
Date: Tue, 7 Oct 2008 18:36:07 +0200
Message-ID: <9cdbb57f0810070936s707f2aeek8f057e2c19efcd95@mail.gmail.com>
References: <200810031814.06897.mbuerger@edu.uni-klu.ac.at>
	 <200810032222.42054.mbuerger@edu.uni-klu.ac.at>
	 <1223065590.13375.68.camel@think.oraclecorp.com>
	 <9cdbb57f0810031509m35c71919s965778dc6cb0ec5f@mail.gmail.com>
	 <20081004003129.GC8449@think.oraclecorp.com>
	 <9cdbb57f0810070431w523f90eek63fd74e44add35cd@mail.gmail.com>
	 <1223384193.16546.111.camel@think.oraclecorp.com>
	 <9cdbb57f0810070804i1dfdedarc59d3d9189d621d5@mail.gmail.com>
	 <1223395385.16546.124.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1223395385.16546.124.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

2008/10/7 Chris Mason <chris.mason@oracle.com>:
> Ok, its important to understand which parts of the FS are using so much
> cpu.  It is pretty easy to tell based on the output of top (which procs
> are consuming the most time).

Well, it's not about a process doing something intensive, but
different procs doing a little i/o.
Azurues (reading and writing no more than 40KB/s), Firefox (I've got
cache in tmpfs, but history & co. in ~/.mozilla), IM (logs chat), Vim,
and so on.
So, usually, I see process in D (for too much time, I would say).
I though "maybe it takes too long to find free space", I was at 80% full.
A couple of hours ago I doubled the free space (now I am using the 33%
of the partition). Things are not perfect, but a lot better.
Loadavg is < 1, and things seems responsive.

Anyway, I'll wait some days and I'll see. I need to use it for
sometime to have a good idea.

Less free space could be the problem?

Ciao,
Gelma
