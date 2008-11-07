From: Martin =?utf-8?q?B=C3=BCrger?= <mbuerger@edu.uni-klu.ac.at>
Subject: Re: oops: csum failed ino
Date: Fri, 7 Nov 2008 19:41:45 +0100
Message-ID: <200811071941.45493.mbuerger@edu.uni-klu.ac.at>
References: <200811071846.21043.mbuerger@edu.uni-klu.ac.at> <1226080095.15281.64.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1226080095.15281.64.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 07 November 2008, Chris Mason wrote:
> On Fri, 2008-11-07 at 18:46 +0100, Martin B=C3=BCrger wrote:
> > Hello,
> > teasing the fs (compression enabled) with compilebench crashed
> > like that [1].
> >
> > [1] http://rafb.net/p/lSU5XU71.html
>
> Hi, which kernel version were you using for this?  I've pushed
> out a number of fixes last night and this morning.
I was using 2.6.27 with patches from [1] (seems to be moved at the=20
moment - use Google's cache instead). I checked out btrfs=20
standalone version shortly before I did the test.

[1] http://zen-sources.org

--=20
Martin B=C3=BCrger
1024D/27C9019B@www.edu.uni-klu.ac.at/~mbuerger/key.asc
Key fingerprint =3D D10D 97EF 0C32 B337 5A12  0B6C 2D47 7575 27C9 019B
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
