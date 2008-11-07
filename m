From: Chris Mason <chris.mason@oracle.com>
Subject: Re: oops: csum failed ino
Date: Fri, 07 Nov 2008 12:48:15 -0500
Message-ID: <1226080095.15281.64.camel@think.oraclecorp.com>
References: <200811071846.21043.mbuerger@edu.uni-klu.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Martin =?ISO-8859-1?Q?B=FCrger?= <mbuerger@edu.uni-klu.ac.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200811071846.21043.mbuerger@edu.uni-klu.ac.at>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-11-07 at 18:46 +0100, Martin B=C3=BCrger wrote:
> Hello,
> teasing the fs (compression enabled) with compilebench crashed like=20
> that [1].
>=20
> [1] http://rafb.net/p/lSU5XU71.html

Hi, which kernel version were you using for this?  I've pushed out a
number of fixes last night and this morning.

-chris


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
