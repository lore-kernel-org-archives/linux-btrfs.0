Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46206 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbcFXIuY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 04:50:24 -0400
Date: Fri, 24 Jun 2016 08:50:14 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Chris Murphy <lists@colorremedies.com>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160624085014.GH3325@carfax.org.uk>
References: <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org>
 <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
 <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org>
 <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org>
 <576CB0DA.6030409@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U3BNvdZEnlJXqmh+"
In-Reply-To: <576CB0DA.6030409@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--U3BNvdZEnlJXqmh+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 24, 2016 at 07:02:34AM +0300, Andrei Borzenkov wrote:
> 24.06.2016 04:47, Zygo Blaxell =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On Thu, Jun 23, 2016 at 06:26:22PM -0600, Chris Murphy wrote:
> >> On Thu, Jun 23, 2016 at 1:32 PM, Goffredo Baroncelli <kreijack@inwind.=
it> wrote:
> >>> The raid5 write hole is avoided in BTRFS (and in ZFS) thanks to the c=
hecksum.
> >>
> >> Yeah I'm kinda confused on this point.
> >>
> >> https://btrfs.wiki.kernel.org/index.php/RAID56
> >>
> >> It says there is a write hole for Btrfs. But defines it in terms of
> >> parity possibly being stale after a crash. I think the term comes not
> >> from merely parity being wrong but parity being wrong *and* then being
> >> used to wrongly reconstruct data because it's blindly trusted.
> >=20
> > I think the opposite is more likely, as the layers above raid56
> > seem to check the data against sums before raid56 ever sees it.
> > (If those layers seem inverted to you, I agree, but OTOH there are
> > probably good reason to do it that way).
> >=20
>=20
> Yes, that's how I read code as well. btrfs layer that does checksumming
> is unaware of parity blocks at all; for all practical purposes they do
> not exist. What happens is approximately
>=20
> 1. logical extent is allocated and checksum computed
> 2. it is mapped to physical area(s) on disks, skipping over what would
> be parity blocks
> 3. when these areas are written out, RAID56 parity is computed and filled=
 in
>=20
> IOW btrfs checksums are for (meta)data and RAID56 parity is not data.

   Checksums are not parity, correct. However, every data block
(including, I think, the parity) is checksummed and put into the csum
tree. This allows the FS to determine where damage has occurred,
rather thansimply detecting that it has occurred (which would be the
case if the parity doesn't match the data, or if the two copies of a
RAID-1 array don't match).

   (Note that csums for metadata are stored in the metadata block
itself, not in the csum tree).

   Hugo.

> > It looks like uncorrectable failures might occur because parity is
> > correct, but the parity checksum is out of date, so the parity checksum
> > doesn't match even though data blindly reconstructed from the parity
> > *would* match the data.
> >=20
>=20
> Yep, that is how I read it too. So if your data is checksummed, it
> should at least avoid silent corruption.
>=20
> >> I don't read code well enough, but I'd be surprised if Btrfs
> >> reconstructs from parity and doesn't then check the resulting
> >> reconstructed data to its EXTENT_CSUM.
> >=20
> > I wouldn't be surprised if both things happen in different code paths,
> > given the number of different paths leading into the raid56 code and
> > the number of distinct failure modes it seems to have.
> >=20
>=20
> Well, the problem is that parity block cannot be redirected on write as
> data blocks; which makes it impossible to version control it. The only
> solution I see is to always use full stripe writes by either wasting
> time in fixed width stripe or using variable width, so that every stripe
> always gets new version of parity. This makes it possible to keep parity
> checksums like data checksums.
>=20



--=20
Hugo Mills             | Darkling's First Law of Filesystems:
hugo@... carfax.org.uk | The user hates their data
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--U3BNvdZEnlJXqmh+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXbPRGAAoJEFheFHXiqx3k5gMQALtuEvCy97Xz0lsoaNkPDImB
uz2QwEnRZ60c04D33NJjQucrVQHBQFHdQ4BOfOJgbUu1HpyM/7EgCPx4tYTUQdZX
KNkm8alKE1oZVzepG3MNSjHRnySzdndkBNGFKJWQVv2L5VRHGnGaT5wCBAuaISo5
q13cXJuKpsvJ65qZgsrAAOjWKpqdh2BfPyksXKi/wdOAA9vPFTE1LocA6PUVkudJ
TaaDi42pZLdTN7zMcBtPRkDE7BGIaVxekGfhSb5reNluzXyxYXOSrqwmqo6dD4Tk
4YcKFarcwmHm1JY/9+Iz7p3k2keISdxuhWqJsMrypB8OcEc6MY6xIW3OypvMdbwN
JCgBueO0D7ndApJt3SRmOMkp54itVuID5FWaNPfoyvroN0qnloeU0t9X60Vpqzpo
CmbC9v+m/ub6C0YjVpz8itUTOsxn8lBNqTh0/qpGC0i+vtxMgWemyCseQZnuw91z
oz178twIz1fH2NqFubK3kuO2VZ2AoGy5fDrEBuIs52n4yws8502wE++553GSJpRf
JgObEL95YMjfnXaatq1DKtLoNz1907lmVJoMQsA/HjahPEvggK3Obq/0g0wwjbCp
VFB2ebv5OoN/TDmXBgMx6BHCNW+YUWOEDEcyscbT8nH25a8hdJI9tuve+RV0B+44
tvBgoyZoZS3Eo9J9eShO
=56Yx
-----END PGP SIGNATURE-----

--U3BNvdZEnlJXqmh+--
