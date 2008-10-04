From: Chris Mason <chris.mason@oracle.com>
Subject: Re: different oops
Date: Fri, 3 Oct 2008 20:30:41 -0400
Message-ID: <20081004003041.GB8449@think.oraclecorp.com>
References: <200810031814.06897.mbuerger@edu.uni-klu.ac.at> <200810032222.42054.mbuerger@edu.uni-klu.ac.at> <1223065590.13375.68.camel@think.oraclecorp.com> <9cdbb57f0810031509m35c71919s965778dc6cb0ec5f@mail.gmail.com> <9cdbb57f0810031715p54bb98a6j9884e65dac0f6efb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Martin =?iso-8859-1?Q?B=FCrger?= <mbuerger@edu.uni-klu.ac.at>,
	Toei Rei <toei.rei@stargazer.at>, linux-btrfs@vger.kernel.org
To: Andrea Gelmini <andrea.gelmini@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <9cdbb57f0810031715p54bb98a6j9884e65dac0f6efb@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 04, 2008 at 02:15:53AM +0200, Andrea Gelmini wrote:
> 2008/10/4 Andrea Gelmini <andrea.gelmini@gmail.com>:
> > 2008/10/3 Chris Mason <chris.mason@oracle.com>:
> >> On Fri, 2008-10-03 at 22:22 +0200, Martin B=FCrger wrote:
> >> Thank you, this is great news.  I had asked Andrea to try the same
> >> thing.  Toei Rei we might have finally tracked down the metadata
> >> corruptions you've been seeing.
> >
> > Just enabling LBD seems to fix the problem here, too.
>=20
> During a cp of ~40GB of data, some delete, a mirrordir, umount/mount,
> I've got these:
> [10214.972922] leaf ref miss for bytenr 632594432

These are safe, I'm removing them.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
