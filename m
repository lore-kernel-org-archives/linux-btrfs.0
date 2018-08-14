Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:42572 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729443AbeHNGfE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Aug 2018 02:35:04 -0400
Date: Mon, 13 Aug 2018 23:49:49 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Menion <menion@gmail.com>
Cc: erenthetitan@mail.de, linux-btrfs@vger.kernel.org
Subject: Re: List of known BTRFS Raid 5/6 Bugs?
Message-ID: <20180814034949.GH26989@hungrycats.org>
References: <20180811054927.GE26989@hungrycats.org>
 <20180811062704.846CD801E8@smtp03.mail.de>
 <20180811152527.GF26989@hungrycats.org>
 <CAJVZm6eA7upEy53L7WwvtVbwa+Om4LTi=nz0xAjNN9g92tppfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gm5TwAJMO0F2iVRz"
In-Reply-To: <CAJVZm6eA7upEy53L7WwvtVbwa+Om4LTi=nz0xAjNN9g92tppfg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gm5TwAJMO0F2iVRz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 13, 2018 at 09:20:22AM +0200, Menion wrote:
> Hi
> I have a BTRFS RAID5 array built on 5x8TB HDD filled with, well :),
> there are contradicting opinions by the, well, "several" ways to check
> the used space on a BTRFS RAID5 array, but I should be aroud 8TB of
> data.
> This array is running on kernel 4.17.3 and it definitely experienced
> power loss while data was being written.
> I can say that it wen through at least a dozen of unclear shutdown
> So following this thread I started my first scrub on the array. and
> this is the outcome (after having resumed it 4 times, two after a
> power loss...):
>=20
> menion@Menionubuntu:~$ sudo btrfs scrub status /media/storage/das1/
> scrub status for 931d40c6-7cd7-46f3-a4bf-61f3a53844bc
>         scrub resumed at Sun Aug 12 18:43:31 2018 and finished after 55:0=
6:35
>         total bytes scrubbed: 2.59TiB with 0 errors
>=20
> So, there are 0 errors, but I don't understand why it says 2.59TiB of
> scrubbed data. Is it possible that also this values is crap, as the
> non zero counters for RAID5 array?

I just tested a quick scrub with injected errors on 4.18.0 and it looks
like the garbage values are finally fixed (yay!).

I never saw invalid values for 'total bytes' from raid5; however, scrub
has (had?) trouble resuming, especially if the system was rebooted between
cancel and resume, but sometimes just if the scrub had just been suspended
too long (maybe if there are changes to the chunk tree...?).

55 hours for 2600 GB is just under 50GB per hour, which doesn't sound
too unreasonable for btrfs, though it is known to be a bit slow compared
to other raid5 implementations.

> Il giorno sab 11 ago 2018 alle ore 17:29 Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> ha scritto:
> >
> > On Sat, Aug 11, 2018 at 08:27:04AM +0200, erenthetitan@mail.de wrote:
> > > I guess that covers most topics, two last questions:
> > >
> > > Will the write hole behave differently on Raid 6 compared to Raid 5 ?
> >
> > Not really.  It changes the probability distribution (you get an extra
> > chance to recover using a parity block in some cases), but there are
> > still cases where data gets lost that didn't need to be.
> >
> > > Is there any benefit of running Raid 5 Metadata compared to Raid 1 ?
> >
> > There may be benefits of raid5 metadata, but they are small compared to
> > the risks.
> >
> > In some configurations it may not be possible to allocate the last
> > gigabyte of space.  raid1 will allocate 1GB chunks from 2 disks at a
> > time while raid5 will allocate 1GB chunks from N disks at a time, and if
> > N is an odd number there could be one chunk left over in the array that
> > is unusable.  Most users will find this irrelevant because a large disk
> > array that is filled to the last GB will become quite slow due to long
> > free space search and seek times--you really want to keep usage below 9=
5%,
> > maybe 98% at most, and that means the last GB will never be needed.
> >
> > Reading raid5 metadata could theoretically be faster than raid1, but th=
at
> > depends on a lot of variables, so you can't assume it as a rule of thum=
b.
> >
> > Raid6 metadata is more interesting because it's the only currently
> > supported way to get 2-disk failure tolerance in btrfs.  Unfortunately
> > that benefit is rather limited due to the write hole bug.
> >
> > There are patches floating around that implement multi-disk raid1 (i.e.=
 3
> > or 4 mirror copies instead of just 2).  This would be much better for
> > metadata than raid6--more flexible, more robust, and my guess is that
> > it will be faster as well (no need for RMW updates or journal seeks).
> >
> > > ---------------------------------------------------------------------=
----------------------------
> > > FreeMail powered by mail.de - MEHR SICHERHEIT, SERIOSIT=C4T UND KOMFO=
RT
> > >
>=20

--gm5TwAJMO0F2iVRz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCW3JRWgAKCRCB+YsaVrMb
nH3BAKC0Ljm0ASVqkmqWYkvdTD99wkdzigCePqSQ8o7DJ2KQyT1beQAwNDRCT+U=
=ArI/
-----END PGP SIGNATURE-----

--gm5TwAJMO0F2iVRz--
