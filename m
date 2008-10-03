From: Martin =?utf-8?q?B=C3=BCrger?= <mbuerger@edu.uni-klu.ac.at>
Subject: Re: different oops
Date: Fri, 3 Oct 2008 19:10:00 +0200
Message-ID: <200810031910.00572.mbuerger@edu.uni-klu.ac.at>
References: <200810031814.06897.mbuerger@edu.uni-klu.ac.at> <1223052035.13375.27.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1223052035.13375.27.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 03 October 2008, Chris Mason wrote:
> On Fri, 2008-10-03 at 18:14 +0200, Martin B=C3=BCrger wrote:
> > Hi,
> > I'm using the sources from [1] which I checked out today. When
> > testing the file system with compilebench [2] I traced oops [3]
> > (with 2 cores, SMP), [4] (single core), [5] (no smp) and [6]
> > (no-preemt).
> >
> >
> > [1]
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unsta
> >ble.git [2] http://oss.oracle.com/~mason/compilebench/
> > [3] http://rafb.net/p/1hUnky34.html
> > [4] http://rafb.net/p/kEGqY199.html
> > [5] http://rafb.net/p/pAHJrV88.html
> > [6] http://rafb.net/p/tkz92m77.html
>
> Hello,
>
> This is a long standing bug that so far we've only heard about on
> gentoo installs.  Could you please give the attached patch a try
> against your sources?

Here's a trace after having applied the patch [1].

[1] http://rafb.net/p/8zzEfe66.html

--=20
Martin B=C3=BCrger
1024D/27C9019B@www.edu.uni-klu.ac.at/~mbuerger/key.asc
Key fingerprint =3D D10D 97EF 0C32 B337 5A12  0B6C 2D47 7575 27C9 019B
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
