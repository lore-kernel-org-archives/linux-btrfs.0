From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Fix csum error for compressed data
Date: Mon, 10 Nov 2008 16:09:25 -0500
Message-ID: <1226351365.10966.2.camel@think.oraclecorp.com>
References: <4917FFB0.2000100@oracle.com>
	 <1226319151.12914.1.camel@think.oraclecorp.com>
	 <200811102200.44107.mbuerger@edu.uni-klu.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Martin =?ISO-8859-1?Q?B=FCrger?= <mbuerger@edu.uni-klu.ac.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200811102200.44107.mbuerger@edu.uni-klu.ac.at>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-11-10 at 22:00 +0100, Martin B=C3=BCrger wrote:
> On Monday 10 November 2008, Chris Mason wrote:
> > On Mon, 2008-11-10 at 17:32 +0800, Yan Zheng wrote:
> > > Hello,
> > >
> > > The decompress code doesn't take the logical offset in extent
> > > pointer into account. If the logical offset isn't zero, data
> > > will be decompressed into wrong pages. Thank you,
> >
> > Ah, thanks Yan.
> >
> >
> > I'll push this out along with a few other fixes from the weekend
> > shortly.
> Well, if this should fix the issue I've reported last Friday I have=20
> to tell you that this error still occurs during my test drives.

Do you also have this changeset:

http://git.kernel.org/?p=3Dlinux/kernel/git/mason/btrfs-unstable.git;a=3D=
commit;h=3De04ca626baee684bea9d6239e4e1119b696101b2

-chris


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
