From: Christian Parpart <trapni@gentoo.org>
Subject: Re: [PATCH] btrfs-progs: autotoolized and splitup into {libbtrfs,tools,tests}
Date: Fri, 10 Oct 2008 03:01:52 +0200
Message-ID: <200810100301.52995.trapni@gentoo.org>
References: <200810090420.49767.trapni@gentoo.org> <1223589129.7861.61.camel@telesto> <1223590043.28324.83.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Cc: Eric Anopolsky <erpo41@gmail.com>, linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1223590043.28324.83.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 10 October 2008 00:07:23 David Woodhouse wrote:
> On Thu, 2008-10-09 at 15:52 -0600, Eric Anopolsky wrote:
> > On Thu, 2008-10-09 at 15:55 +0200, Christian Parpart wrote:
> > > On Thursday 09 October 2008 12:45:06 David Woodhouse wrote:
> > > > On Thu, 2008-10-09 at 04:20 +0200, Christian Parpart wrote:
> > > > > this now makes use of autoconf/automake/libtool suite,
> > > >
> > > > Please, God, no.
> > > >
> > > > I will personally buy a licence for GNU make for anyone who needs
> > > > one.
> > >
> > > In that case, you shall know what license automake is under, too,
> > > and despite your impressions i read above, if you don't want it, fine
> > > with me, but stick to reasonable facts instead of religios talk next
> > > time you press a reply button.
> >
> > I nearly tried to make an argument against the autotools last night.
> > Today, I decided that I would rather explain why I had such a visceral
> > reaction to the announcement and not try to convince anyone of anything.
> >
> > The GNU autotools kept me out of FOSS development for the better part of
> > a decade.
> >
> > They obviously solve a common and important problem, or they wouldn't be
> > so widespread.
>
> Really, do they? In my experience, they cause more problems than they
> solve. It's mostly just cargo-cult programming.
>
> If you have decent, portable code, and decent makefiles, you really
> don't need the baroque pile of turd that autotools inflicts on you.
>
> If I ever see a btrfs-progs build trying to detect what kind of FORTRAN
> compiler I have on the system, I'm never going to touch btrfs-progs
> again. Life's just too bloody short to deal with that kind of crap.

whether  btrfs to be using autotools or not, the other kind this patch 
addressed seems to be more important to me: project modularization.

So please let me clarify why. The code being shared between kernel space and 
user space is much more then a single fragment of code, this can be verified 
using your favorite diff tools, although, the wiki states it is just to be 
meant this way, to share as much code as possible, which (from my point of 
view) seems to be quite logic, though, making a libbtrfs.a(or .so for user 
space) out of it is the very certain way to go from here.
And while the kernel land code seems more up-to-date than the one found in 
user-land, it's been at least a start, from project structure point of view, 
and for the sake of a clean project design.

Despite that, there actually are other tools that might benifit from libbtrfs, 
think of low-level backup tools (e.g. partimage), analytical tools, a fuse-
btrfs frontend (makes debugging/developing easier), and maybe more.

Best regards,
Christian Parpart.
