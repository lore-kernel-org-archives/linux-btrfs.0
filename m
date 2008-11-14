From: Martin =?iso-8859-1?q?B=FCrger?= <mbuerger@edu.uni-klu.ac.at>
Subject: Re: Kernel oops when running bonnie++ on btrfs
Date: Fri, 14 Nov 2008 17:47:02 +0100
Message-ID: <200811141747.03017.mbuerger@edu.uni-klu.ac.at>
References: <20081113184907.GA16224@tux64-02> <20081113192005.GA17006@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081113192005.GA17006@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 13 November 2008, Josef Bacik wrote:
> Thanks, still tracking down random places where we ENOSPC too
> soon.
Probably something I've just hit as well [1].

[1] http://rafb.net/p/kvYLj917.html

Best wishes,
--=20
Martin B=FCrger
1024D/27C9019B@www.edu.uni-klu.ac.at/~mbuerger/key.asc
Key fingerprint =3D D10D 97EF 0C32 B337 5A12  0B6C 2D47 7575 27C9 019B
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
