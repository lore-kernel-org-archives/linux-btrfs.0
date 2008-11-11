From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Fix csum error for compressed data
Date: Tue, 11 Nov 2008 16:41:04 -0500
Message-ID: <1226439664.26490.0.camel@think.oraclecorp.com>
References: <4917FFB0.2000100@oracle.com>
	 <200811110708.36712.mbuerger@edu.uni-klu.ac.at>
	 <3d0408630811110057lec87365w1095f570d4bd55e5@mail.gmail.com>
	 <200811111814.38911.mbuerger@edu.uni-klu.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Martin =?ISO-8859-1?Q?B=FCrger?= <mbuerger@edu.uni-klu.ac.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200811111814.38911.mbuerger@edu.uni-klu.ac.at>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-11-11 at 18:14 +0100, Martin B=C3=BCrger wrote:
> On Tuesday 11 November 2008, Yan Zheng wrote:
> > Hi Martin,
> >
> > Please try following patch. Thank you,
> That fixed it.

Thank you both, I've pushed out Yan Zheng's fix.

-chris


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
