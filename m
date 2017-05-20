Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45123 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752024AbdETA7B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 20:59:01 -0400
Date: Sat, 20 May 2017 00:57:09 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: Liu Bo <bo.li.liu@oracle.com>, Chris Mason <clm@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: 4.11.0: kernel BUG at fs/btrfs/ctree.h:1779!
Message-ID: <20170520005709.GP9701@carfax.org.uk>
References: <20170519041638.sf7sensley4lpxiz@merlins.org>
 <20170519190358.GC10137@lim.localdomain>
 <20170520001134.GW29894@merlins.org>
 <20170520003747.GO9701@carfax.org.uk>
 <20170520004748.GA29894@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="V7BlxAaPrdhzdIM1"
In-Reply-To: <20170520004748.GA29894@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--V7BlxAaPrdhzdIM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 19, 2017 at 05:47:48PM -0700, Marc MERLIN wrote:
> On Sat, May 20, 2017 at 12:37:47AM +0000, Hugo Mills wrote:
> > > Can I make another plea for just removing all those BUG/BUG_ON?
> > > They really have no place in production code, there is no excuse for a
> > > filesystem to bring down the entire and in the process not even tell you
> > > which of your filesystems had the issue to start with.
> > > 
> > > Could this be made part of a cleanup for this build to remove them all?
> > 
> >    The removal of these has been an ongoing process for at least the
> > last 5 years.
>  
> That's great news, thanks. I guess I'm a bit edgy because I've hit too many
> of them already :) but glad to hear that there are a lot fewer now.
> 
> >    I don't understand the specifics of the kernel code in question(*),
> > but compared to 5 years ago, btrfs has got rid of most of the
> > BUG_ONs(**) a few years ago. The remaining ones are probably
> > complicated to deal with in any way more elegant than just stopping.
> 
> The biggest problem is that those BUG* do not even tell you where the
> problem.
> The assumption that you'd only ever have a single btrfs filesystem mounted,
> is flawed to say the least :)
> (I have 5 different ones on my server)

   I think from the POV of removing these BUG_ONs, it doesn't matter
which FS causes them. "All" you need to know is where the error
happened. From there, you can (in theory) work out what was wrong and
handle it more elagantly than simply stopping.

   Obviously it would be nice, from the POV of the sysadmin, to know
which FS was complaining, but as an FS developer it's secondary to
identifying a BUG_ON which happens in real life, which offers an
opportunity to make the error path more elegant.

> >    I recall seeing someone's stats on BUG_ON locations a couple of
> > years ago, and btrfs had managed to get the number of locations down
> > below XFS (but no other FS). It's a kind of success, at least...
> 
> Good to know, thanks, and thanks to anyone who has worked on removing those.

   I don't know what the current state is. Maybe someone on IRC will
be able to do the greps/stats to give proper numbers to it.

   Hugo.

-- 
Hugo Mills             | IMPROVE YOUR ORGANISMS!!
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                            Subject line of spam email

--V7BlxAaPrdhzdIM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZH5RlAAoJEFheFHXiqx3kLOYP/0RR8SB4uhYXKfC8bRFHa7vq
Wv1+SEYmTDioJ/DdRu1X3L6MarejEn8bvsh7tbBcXfBBx0YUMnrQ45xlko57d/+Q
MrsrTWXJ1X3DawSRtIsM4hIULNTlvj2BE5RluXXtKszLvmiB+s98YgOPBic0Z0G3
y3MXR30B+6DHKKUAI1ItQjl/O2PDPUZyJsSLBm2tGk1sjuvWcSr79xV8ikUOsput
2LXNWg1KPLpugoAcERM2Fcs08cqO98RXSchTdwQuh/9f00uBKzbe67nTPt9oZMmO
jO9sIb/6mugezcmhL7NCouu/QXro6eg1CzLoxPkaMPpwkNDdsWOCoDwFJrUZqlYF
vlfogfe+W/E4bYb82im1PimknwGgXHhzQUcTmI3a/Zwqm9r5cf6J3Iehqd97IUvf
Qw+/G21Mb7XxugW1F9wsyWkEcelRwhvpJlUXB3tek0LlOo5orZi/OI9LY1e4ye+L
mhqw1eN+gnlJpc/uZ+g1vSTDjXrQEZ0+WbnUfNoc2x2XSt510FhnNitnLNf8LOTS
kAa6g4E8JPzxE0WDM0ON7o8+q1D6jJNkPfzmWd9REyouI7e02drnxQml38QoPGWP
QYf1hDaomzhXArzM8slsX94WMoJDF0zHA7Sqo+okL3D0boQ/BeSY5y63efTAnnRj
acUQvrvJDHA6RiWdKWIz
=LqaD
-----END PGP SIGNATURE-----

--V7BlxAaPrdhzdIM1--
