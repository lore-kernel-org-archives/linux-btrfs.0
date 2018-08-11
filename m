Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:37992 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727324AbeHKSAA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Aug 2018 14:00:00 -0400
Date: Sat, 11 Aug 2018 11:25:27 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: erenthetitan@mail.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: List of known BTRFS Raid 5/6 Bugs?
Message-ID: <20180811152527.GF26989@hungrycats.org>
References: <20180811054927.GE26989@hungrycats.org>
 <20180811062704.846CD801E8@smtp03.mail.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dFWYt1i2NyOo1oI9"
In-Reply-To: <20180811062704.846CD801E8@smtp03.mail.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--dFWYt1i2NyOo1oI9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 11, 2018 at 08:27:04AM +0200, erenthetitan@mail.de wrote:
> I guess that covers most topics, two last questions:
>=20
> Will the write hole behave differently on Raid 6 compared to Raid 5 ?

Not really.  It changes the probability distribution (you get an extra
chance to recover using a parity block in some cases), but there are
still cases where data gets lost that didn't need to be.

> Is there any benefit of running Raid 5 Metadata compared to Raid 1 ?=20

There may be benefits of raid5 metadata, but they are small compared to
the risks.

In some configurations it may not be possible to allocate the last
gigabyte of space.  raid1 will allocate 1GB chunks from 2 disks at a
time while raid5 will allocate 1GB chunks from N disks at a time, and if
N is an odd number there could be one chunk left over in the array that
is unusable.  Most users will find this irrelevant because a large disk
array that is filled to the last GB will become quite slow due to long
free space search and seek times--you really want to keep usage below 95%,
maybe 98% at most, and that means the last GB will never be needed.

Reading raid5 metadata could theoretically be faster than raid1, but that
depends on a lot of variables, so you can't assume it as a rule of thumb.

Raid6 metadata is more interesting because it's the only currently
supported way to get 2-disk failure tolerance in btrfs.  Unfortunately
that benefit is rather limited due to the write hole bug.

There are patches floating around that implement multi-disk raid1 (i.e. 3
or 4 mirror copies instead of just 2).  This would be much better for
metadata than raid6--more flexible, more robust, and my guess is that
it will be faster as well (no need for RMW updates or journal seeks).

> -------------------------------------------------------------------------=
------------------------
> FreeMail powered by mail.de - MEHR SICHERHEIT, SERIOSIT=C4T UND KOMFORT
>=20

--dFWYt1i2NyOo1oI9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCW27/5AAKCRCB+YsaVrMb
nLG+AKCkIaixhJ3XMGU9pecQcYxBQ9JzGQCdH8Lyq7mBZyvVjfuby2mSM+jFzx8=
=h6ZQ
-----END PGP SIGNATURE-----

--dFWYt1i2NyOo1oI9--
