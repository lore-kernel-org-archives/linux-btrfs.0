From: Martin =?utf-8?q?B=C3=BCrger?= <mbuerger@edu.uni-klu.ac.at>
Subject: Re: Kernel oops when running bonnie++ on btrfs
Date: Fri, 14 Nov 2008 18:14:41 +0100
Message-ID: <200811141814.41643.mbuerger@edu.uni-klu.ac.at>
References: <20081113184907.GA16224@tux64-02> <200811141747.03017.mbuerger@edu.uni-klu.ac.at> <1226682161.26512.21.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1226682161.26512.21.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 14 November 2008, Chris Mason wrote:
> On Fri, 2008-11-14 at 17:47 +0100, Martin B=C3=BCrger wrote:
> > On Thursday 13 November 2008, Josef Bacik wrote:
> > > Thanks, still tracking down random places where we ENOSPC too
> > > soon.
> >
> > Probably something I've just hit as well [1].
> >
> > [1] http://rafb.net/p/kvYLj917.html
>
> Thanks, they do look similar.  Did you mount with -o ssd?
No, no additional options at all.

--=20
Martin B=C3=BCrger
1024D/27C9019B@www.edu.uni-klu.ac.at/~mbuerger/key.asc
Key fingerprint =3D D10D 97EF 0C32 B337 5A12  0B6C 2D47 7575 27C9 019B
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
