From: Martin =?utf-8?q?B=C3=BCrger?= <mbuerger@edu.uni-klu.ac.at>
Subject: Re: [PATCH] Fix csum error for compressed data
Date: Mon, 10 Nov 2008 22:00:43 +0100
Message-ID: <200811102200.44107.mbuerger@edu.uni-klu.ac.at>
References: <4917FFB0.2000100@oracle.com> <1226319151.12914.1.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1226319151.12914.1.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 10 November 2008, Chris Mason wrote:
> On Mon, 2008-11-10 at 17:32 +0800, Yan Zheng wrote:
> > Hello,
> >
> > The decompress code doesn't take the logical offset in extent
> > pointer into account. If the logical offset isn't zero, data
> > will be decompressed into wrong pages. Thank you,
>
> Ah, thanks Yan.
>
>
> I'll push this out along with a few other fixes from the weekend
> shortly.
Well, if this should fix the issue I've reported last Friday I have=20
to tell you that this error still occurs during my test drives.

Best wishes,
--=20
Martin B=C3=BCrger
1024D/27C9019B@www.edu.uni-klu.ac.at/~mbuerger/key.asc
Key fingerprint =3D D10D 97EF 0C32 B337 5A12  0B6C 2D47 7575 27C9 019B
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
