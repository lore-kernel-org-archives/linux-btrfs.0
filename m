From: Chris Mason <chris.mason@oracle.com>
Subject: Re: different oops
Date: Fri, 03 Oct 2008 16:26:30 -0400
Message-ID: <1223065590.13375.68.camel@think.oraclecorp.com>
References: <200810031814.06897.mbuerger@edu.uni-klu.ac.at>
	 <200810032222.42054.mbuerger@edu.uni-klu.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Martin =?ISO-8859-1?Q?B=FCrger?= <mbuerger@edu.uni-klu.ac.at>,
	Andrea Gelmini <andrea.gelmini@gmail.com>,
	Toei Rei <toei.rei@stargazer.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200810032222.42054.mbuerger@edu.uni-klu.ac.at>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-10-03 at 22:22 +0200, Martin B=C3=BCrger wrote:

[ Btrfs corruptions on i386 ]

> CONFIG_LBD was not set during my tests. After enabling it no errors=20
> whatsoever occured executing the same tests.

Thank you, this is great news.  I had asked Andrea to try the same
thing.  Toei Rei we might have finally tracked down the metadata
corruptions you've been seeing.

CONFIG_LBD turns the sector_t data type from an unsigned long into a
u64.  Btrfs was using it like it was always a u64, and sometimes it was
overflowing.

-chris




--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
