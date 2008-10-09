From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] btrfs-progs: autotoolized and splitup into
	{libbtrfs,tools,tests}
Date: Thu, 09 Oct 2008 23:07:23 +0100
Message-ID: <1223590043.28324.83.camel@macbook.infradead.org>
References: <200810090420.49767.trapni@gentoo.org>
	 <1223549106.28324.14.camel@macbook.infradead.org>
	 <200810091555.38509.trapni@gentoo.org>  <1223589129.7861.61.camel@telesto>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Christian Parpart <trapni@gentoo.org>, linux-btrfs@vger.kernel.org
To: Eric Anopolsky <erpo41@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1223589129.7861.61.camel@telesto>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-10-09 at 15:52 -0600, Eric Anopolsky wrote:
> On Thu, 2008-10-09 at 15:55 +0200, Christian Parpart wrote:
> > On Thursday 09 October 2008 12:45:06 David Woodhouse wrote:
> > > On Thu, 2008-10-09 at 04:20 +0200, Christian Parpart wrote:
> > > > this now makes use of autoconf/automake/libtool suite,
> > >
> > > Please, God, no.
> > >
> > > I will personally buy a licence for GNU make for anyone who needs one.
> > 
> > In that case, you shall know what license automake is under, too,
> > and despite your impressions i read above, if you don't want it, fine with me, 
> > but stick to reasonable facts instead of religios talk next time you press a 
> > reply button.
> 
> I nearly tried to make an argument against the autotools last night.
> Today, I decided that I would rather explain why I had such a visceral
> reaction to the announcement and not try to convince anyone of anything.
> 
> The GNU autotools kept me out of FOSS development for the better part of
> a decade.
> 
> They obviously solve a common and important problem, or they wouldn't be
> so widespread.

Really, do they? In my experience, they cause more problems than they
solve. It's mostly just cargo-cult programming.

If you have decent, portable code, and decent makefiles, you really
don't need the baroque pile of turd that autotools inflicts on you.

If I ever see a btrfs-progs build trying to detect what kind of FORTRAN
compiler I have on the system, I'm never going to touch btrfs-progs
again. Life's just too bloody short to deal with that kind of crap.

-- 
dwmw2

