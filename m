From: Chris Mason <chris.mason@oracle.com>
Subject: Re: different oops
Date: Fri, 03 Oct 2008 15:07:02 -0400
Message-ID: <1223060822.13375.48.camel@think.oraclecorp.com>
References: <200810031814.06897.mbuerger@edu.uni-klu.ac.at>
	 <1223052035.13375.27.camel@think.oraclecorp.com>
	 <200810031910.00572.mbuerger@edu.uni-klu.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Martin =?ISO-8859-1?Q?B=FCrger?= <mbuerger@edu.uni-klu.ac.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200810031910.00572.mbuerger@edu.uni-klu.ac.at>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-10-03 at 19:10 +0200, Martin B=C3=BCrger wrote:
> On Friday 03 October 2008, Chris Mason wrote:
> > On Fri, 2008-10-03 at 18:14 +0200, Martin B=C3=BCrger wrote:
> > > Hi,
> > > I'm using the sources from [1] which I checked out today. When
> > > testing the file system with compilebench [2] I traced oops [3]
> > > (with 2 cores, SMP), [4] (single core), [5] (no smp) and [6]
> > > (no-preemt).
> > >
> > >
> > > [1]
> > > git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unsta
> > >ble.git [2] http://oss.oracle.com/~mason/compilebench/
> > > [3] http://rafb.net/p/1hUnky34.html
> > > [4] http://rafb.net/p/kEGqY199.html
> > > [5] http://rafb.net/p/pAHJrV88.html
> > > [6] http://rafb.net/p/tkz92m77.html
> >
> > Hello,
> >
> > This is a long standing bug that so far we've only heard about on
> > gentoo installs.  Could you please give the attached patch a try
> > against your sources?
>=20
> Here's a trace after having applied the patch [1].
>=20
> [1] http://rafb.net/p/8zzEfe66.html
>=20

The interesting part of this is that every file created by compilebench
is filled by the same pattern 4k of 'a'.

Every corruption in Martin's trace looks the same:

bad tree block start 7016996765293437281 74264576

7016996765293437281 is what we found on disk, the second number is what
we expected to find.  The number we found on disk is what you get when
you have a u64 full of 'a'.

This means that we're overwriting metadata blocks with data blocks.  I'=
m
looking harder.

-chris



--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
