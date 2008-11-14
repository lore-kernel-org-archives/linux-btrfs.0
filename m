From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Kernel oops when running bonnie++ on btrfs
Date: Fri, 14 Nov 2008 12:02:41 -0500
Message-ID: <1226682161.26512.21.camel@think.oraclecorp.com>
References: <20081113184907.GA16224@tux64-02>
	 <20081113192005.GA17006@unused.rdu.redhat.com>
	 <200811141747.03017.mbuerger@edu.uni-klu.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Martin =?ISO-8859-1?Q?B=FCrger?= <mbuerger@edu.uni-klu.ac.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200811141747.03017.mbuerger@edu.uni-klu.ac.at>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-11-14 at 17:47 +0100, Martin B=C3=BCrger wrote:
> On Thursday 13 November 2008, Josef Bacik wrote:
> > Thanks, still tracking down random places where we ENOSPC too
> > soon.
> Probably something I've just hit as well [1].
>=20
> [1] http://rafb.net/p/kvYLj917.html

Thanks, they do look similar.  Did you mount with -o ssd?

-chris


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
