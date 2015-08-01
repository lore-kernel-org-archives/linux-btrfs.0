Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47111 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbbHAWeP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Aug 2015 18:34:15 -0400
Date: Sat, 1 Aug 2015 22:34:13 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Data single *and* raid?
Message-ID: <20150801223413.GC14352@carfax.org.uk>
References: <55BD277F.2040201@friedels.name>
 <20150801203258.GA14352@carfax.org.uk>
 <CAJCQCtTY0bWrFmm_6An9QcPm7ek53vCrFHjZjehHf-UotXJ7+A@mail.gmail.com>
 <pan$7fbcf$6323c57d$e51a436f$80a59676@cox.net>
 <CAJCQCtQOa8_fcX_O9zop=mT0ABp=3XtJZ5N2SE2nrX7-0TvSpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m51xatjYGsM+13rf"
In-Reply-To: <CAJCQCtQOa8_fcX_O9zop=mT0ABp=3XtJZ5N2SE2nrX7-0TvSpw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--m51xatjYGsM+13rf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 01, 2015 at 04:26:25PM -0600, Chris Murphy wrote:
> On Sat, Aug 1, 2015 at 3:45 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> > Does fi usage deal with raid5 yet?
> 
> Now that you mention it, I think it doesn't. But if it did, it would
> show this problem better than df I think.
> 
> > But, somewhere along the line he got 6 GiB of raid1 metadata.  Either he
> > added/rewrote a *BUNCH* of files after adding at least one device before
> > the conversion that he didn't tell us about, or the conversion screwed
> > up, because that's a lot of raid1 metadata coming out of nowhere!
> 
> Yeah it's a little confusing, that's why I asked about the kernel version.

   It's 6 GiB of metadata for 5.7 GIB of data, or thereabouts. 0.1% is
about the expected size.

   Now, given the original description, it's not clear at all why the
data has suddenly doubled in size -- unless there's some snapshots,
and the OP did a defrag as well.

> > But I'm *strongly* suspecting a pre-full-raid56-support kernel, because
> > btrfs-progs is certainly reasonably new (v4.1.1, as of yesterday 4.1.2 is
> > the newest as I mention above), but the fi df doesn't report global
> > reserve.  The only way I know of that it wouldn't report that with a new
> > userspace is if the kernelspace is too old.
> 
> Yes and that also puts it in the realm of kernels that weren't
> releasing/deallocating empty chunks; although I don't know if that's a
> factor, if dconvert forcibly deals with this..

   It does -- you only have to look at the btrfs fi df output to see
that there's no empty block groups (to within 0.1% or so)

> > Finally, that's btrfs-progs 4.1.1, the one that's blacklisted due to a
> > buggy mkfs.btrfs.  If he created the filesystem with that mkfs.btrfs...
> > maybe that explains the funky results, as well.
> 
> Good catch. That really ought to be filed as a bug with that distro to
> flat out remove 4.1.1 from the repos.

   If they picked up 4.1.1 fast enough, they should pick up 4.1.2 just
as quickly...

   Hugo.

-- 
Hugo Mills             | "What are we going to do tonight?"
hugo@... carfax.org.uk | "The same thing we do every night, Pinky. Try to
http://carfax.org.uk/  | take over the world!"
PGP: E2AB1DE4          |

--m51xatjYGsM+13rf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVvUllAAoJEFheFHXiqx3kKyMQAJWxaHRIqSLPA+/VeHB4wVzQ
qgna/ol3VxJLnKfUk1K/vfZiSsp6vEjY/pZzVU45D53Hak2jwAKLltVRLmHbm/By
pzQ/tDwVbVaVmarDvritkfCdXUPVeMDIz1LfgtTskKrRz5QrAcqdAtaOBh4JcgiU
RmpQCSNwVS24/ucziwVQF/9ycoFZRU31tMjWs77nY+48nJIL0AN/e38rLIoTd/Sk
yC2MoMH76rwp/METEat3HQfwW3BoVWe2t+H5jbBWAlm86ik+UV9fGLKF05BKndTE
+lK2cqv7GJTc94L1C+v3ErqT1cFhLS6FJfoV42EwWltuFGwZJANWEiC3UOdgxzdq
qew++yN/9InWP56MhIMD4Y6xncfEhIGPl2HmtWsIIHr7ZjUl+UpxDDCsiNhVqPap
1A1j1OO2l8/sInQDKMC6es2y/4HejTgMiDr7a785Y0SMxrVg1ZVH4fBa5eOe9/RN
5bTQLvnWlNtDJgv1J6b5daBTvYt7n1AoFTEyZSXfgsvu3cCq60Yd8S43QIDRBYDM
NTag6WQTOhns0aQQRbW1AW857EzA2mc1tpP62rb3boZhJsVjomaaFbmKDimGrmMX
tm19UweNC3PKFb4HRzhBw2ufdNfGZaM4fzBE3tKTGbCUMxtGs066b0+lfLJuXNbc
F7L0mPRBlusCp5386Gdd
=Kj93
-----END PGP SIGNATURE-----

--m51xatjYGsM+13rf--
