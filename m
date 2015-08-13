Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35932 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbbHMXZm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 19:25:42 -0400
Received: by wicja10 with SMTP id ja10so1854619wic.1
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 16:25:41 -0700 (PDT)
Received: from U64-desktop (smtp.infinitegrid.org. [46.182.105.104])
        by smtp.gmail.com with ESMTPSA id eb3sm303156wib.24.2015.08.13.16.25.39
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Thu, 13 Aug 2015 16:25:40 -0700 (PDT)
Date: Fri, 14 Aug 2015 09:25:34 +1000
From: David Seikel <onefang@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Oddness with phantom device replacing real device.
Message-ID: <20150814092534.29e08bde.onefang@gmail.com>
In-Reply-To: <20150813095510.GP12976@carfax.org.uk>
References: <20150813133322.369c10af.onefang@gmail.com>
	<20150813095510.GP12976@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fe6j_BWI8xwU_8yJ=CUrJ6L"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/fe6j_BWI8xwU_8yJ=CUrJ6L
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Aug 2015 09:55:10 +0000 Hugo Mills <hugo@carfax.org.uk>
wrote:

> On Thu, Aug 13, 2015 at 01:33:22PM +1000, David Seikel wrote:
> > I don't actually think that this is a BTRFS problem, but it's
> > showing symptoms within BTRFS, and I have no other clues, so maybe
> > the BTRFS experts can help me figure out what is actually going
> > wrong.
> >=20
> > I'm a sysadmin working for a company that does scientific modelling.
> > They have many TBs of data.  We use two servers running Ubuntu
> > 14.04 LTS to backup all of this data.  One of them includes 16
> > spinning rust disks hooked to a RAID controller running in JBOD
> > mode (in other words, as far as Linux is concerned, they are just
> > 16 ordinary disks).  They are /dev/sdc to /dev/sdr, all being used
> > as a single BTRFS file system.
> >=20
> > I have been having no end of trouble with this system recently.
> > Keep in mind that due to the huge amount of data we deal with, doing
> > anything takes a long time.  So "recently" means "in the last
> > several months".
> >=20
> > My latest attempt to beat some sense into this server was to
> > upgrade it to the latest officially backported kernel from Ubuntu,
> > and compile my own copy of btrfs-progs from source code (latest
> > release from github). Then I recreated the 16 disk BTRFS file
> > system, and started the backup software running again, from
> > scratch.  The next day, /dev/sdc has vanished, to be replaced be a
> > phantom /dev/sds.  There's no such disk as /dev/sds.  /dev/sds is
> > now included in the BTRFS file system replacing /dev/sdc.  In /dev
> > sdc does indeed vanish, and sds does indeed appear.  This was
> > happening before.  /dev/sds then starts to fill up with errors,
> > since no such disk actually exists.
>=20
>    Sounds like the kind of behaviour when the disk has vanished from
> the system for long enough to drop out and be recreated by the
> driver. The renaming may (possibly) be down to a poor error-handling
> path in btrfs -- we see this happening on USB sometimes, where the
> original device node is still hung on to by the FS on a hardware
> error, and so when the device comes back it's given a different name.

So that part may need some fixing in BTRFS.

> > I don't know what is actually causing the problem.  The disks are
> > in a hot swap backplane, and if I actually pulled sdc out, then it
> > would still be listed as part of the BTRFS file system, wouldn't it?
>=20
>    With btrfs fi show, no, you'd get ** some devices missing ** in the
> output.

Which is different from what I'm getting.

> >  If I
> > then where to plug some new disk into the same spot, it would not be
> > recognised as part of the file system?
>=20
>    Correct... Unless the device had a superblock with the same UUID in
> it (like, say, the new device is just the old one reappearing
> again). In that case, udev would trigger a btrfs dev scan, and the
> "new" device would rejoin the FS -- probably a little out of date, but
> that would be caught by checksums and be fixed if you have redundancy
> in the storage.

But btrfs is thinking it's a different device, hence all the errors as
it gets confused.

> >  So assuming that the RAID
> > controller is getting confused and thinking that sdc has been
> > pulled, then replaced by sds, it should not be showing up as part
> > of the BTRFS file system?  Or maybe there's a signature on sdc that
> > BTRFS notices makes it part of the file system, even though BTRFS
> > is now confused about it's location?
>=20
>    See above.
>=20
> > After a reboot, sdc returns and sds is gone again.
>=20
>    Expected.
>=20
> > The RAID controller has recently been replaced, but there where
> > similar problems with the old one as well.  A better model of RAID
> > controller was chosen this time.
> >=20
> > I've also not been able to complete a scrub on this system recently.
> > The really odd thing is that I get messages that the scrub has
> > aborted, yet the scrub continues, then much later (days later) the
> > scrub causes a kernel panic.  The "aborted" happens some random
> > time into the scrub, but usually in the early part of the scrub.
> > Mind you, if BTRFS is completely confused due to a problem
> > elsewhere, then maybe this can be excused.
>=20
>    I think that means that it's aborting on one device but continuing
> on all the others.

Ah, would be useful for scrub to say so, and point out which device/s
got aborted.

> > The other backup server is almost identical, though it has less
> > disks in the array.  It doesn't have any issues with the BTRFS file
> > system.
> >=20
> > Can any one help shed some light on this please?  Hopefully some
> > "quick" things to try, given my definition of "recently" above means
> > that most things take days or weeks, or even months for me to try.
> >=20
> > I have attached the usual debugging info requested.  This is after
> > the bogus sds replaces sdc.
> >=20
>=20
>    The first thing would be to check your system logs for signs of
> hardware problems (ATA errors). This sounds a lot like you've got a
> dodgy disk that needs to be replaced.

Just gotta figure out which one, I thought I already replaced the dodgy
one.  Might be more than one.  sigh

I'm guessing /dev/sdc.

--=20
A big old stinking pile of genius that no one wants
coz there are too many silver coated monkeys in the world.

--Sig_/fe6j_BWI8xwU_8yJ=CUrJ6L
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlXNJ24ACgkQM4aCtK1wD2I8+wCgy6dgqK9iolUqINbQlidc2J8Y
HnUAoOw1rL19uptMy929n5O+ATerXTrF
=0spW
-----END PGP SIGNATURE-----

--Sig_/fe6j_BWI8xwU_8yJ=CUrJ6L--
