Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46724 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbcFXKRE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 06:17:04 -0400
Date: Fri, 24 Jun 2016 10:16:58 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Chris Murphy <lists@colorremedies.com>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160624101658.GI3325@carfax.org.uk>
References: <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
 <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org>
 <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org>
 <576CB0DA.6030409@gmail.com>
 <20160624085014.GH3325@carfax.org.uk>
 <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ev7mvGV+3JQuI2Eo"
In-Reply-To: <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ev7mvGV+3JQuI2Eo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 24, 2016 at 12:52:21PM +0300, Andrei Borzenkov wrote:
> On Fri, Jun 24, 2016 at 11:50 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Fri, Jun 24, 2016 at 07:02:34AM +0300, Andrei Borzenkov wrote:
> >> 24.06.2016 04:47, Zygo Blaxell =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >> > On Thu, Jun 23, 2016 at 06:26:22PM -0600, Chris Murphy wrote:
> >> >> On Thu, Jun 23, 2016 at 1:32 PM, Goffredo Baroncelli <kreijack@inwi=
nd.it> wrote:
> >> >>> The raid5 write hole is avoided in BTRFS (and in ZFS) thanks to th=
e checksum.
> >> >>
> >> >> Yeah I'm kinda confused on this point.
> >> >>
> >> >> https://btrfs.wiki.kernel.org/index.php/RAID56
> >> >>
> >> >> It says there is a write hole for Btrfs. But defines it in terms of
> >> >> parity possibly being stale after a crash. I think the term comes n=
ot
> >> >> from merely parity being wrong but parity being wrong *and* then be=
ing
> >> >> used to wrongly reconstruct data because it's blindly trusted.
> >> >
> >> > I think the opposite is more likely, as the layers above raid56
> >> > seem to check the data against sums before raid56 ever sees it.
> >> > (If those layers seem inverted to you, I agree, but OTOH there are
> >> > probably good reason to do it that way).
> >> >
> >>
> >> Yes, that's how I read code as well. btrfs layer that does checksumming
> >> is unaware of parity blocks at all; for all practical purposes they do
> >> not exist. What happens is approximately
> >>
> >> 1. logical extent is allocated and checksum computed
> >> 2. it is mapped to physical area(s) on disks, skipping over what would
> >> be parity blocks
> >> 3. when these areas are written out, RAID56 parity is computed and fil=
led in
> >>
> >> IOW btrfs checksums are for (meta)data and RAID56 parity is not data.
> >
> >    Checksums are not parity, correct. However, every data block
> > (including, I think, the parity) is checksummed and put into the csum
> > tree. This allows the FS to determine where damage has occurred,
> > rather thansimply detecting that it has occurred (which would be the
> > case if the parity doesn't match the data, or if the two copies of a
> > RAID-1 array don't match).
> >
>=20
> Yes, that is what I wrote below. But that means that RAID5 with one
> degraded disk won't be able to reconstruct data on this degraded disk
> because reconstructed extent content won't match checksum. Which kinda
> makes RAID5 pointless.

   Eh? How do you come to that conclusion?

   For data, say you have n-1 good devices, with n-1 blocks on them.
Each block has a checksum in the metadata, so you can read that
checksum, read the blocks, and verify that they're not damaged. From
those n-1 known-good blocks (all data, or one parity and the rest
data) you can reconstruct the remaining block. That reconstructed
block won't be checked against the csum for the missing block -- it'll
just be written and a new csum for it written with it.

   Hugo.

> ...
> >
> >> > It looks like uncorrectable failures might occur because parity is
> >> > correct, but the parity checksum is out of date, so the parity check=
sum
> >> > doesn't match even though data blindly reconstructed from the parity
> >> > *would* match the data.
> >> >
> >>
> >> Yep, that is how I read it too. So if your data is checksummed, it
> >> should at least avoid silent corruption.
> >>

--=20
Hugo Mills             | Debugging is like hitting yourself in the head with
hugo@... carfax.org.uk | hammer: it feels so good when you find the bug, and
http://carfax.org.uk/  | you're allowed to stop debugging.
PGP: E2AB1DE4          |                                        PotatoEngin=
eer

--ev7mvGV+3JQuI2Eo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXbQiaAAoJEFheFHXiqx3kwrAP/iuqDSjMueVpYukyFLczDe60
1VzkS5BVqR1PpcKXS4Tkvv/TkyTTnKe1frl1T55h5AS46rtzYdNdBbVEtkF51SgQ
2iwHpjt26kk8S5s2Q9a5n2Jjcn/GmAYqY5X7TOhVNgKNnDFsw3CVNYHmDWwZoszS
CdIB1ybe7W2qp6XSBGJ9X8iA009dXJ3J83xJCVpnNxd3KwnDiTqRS0VJI9DO2Q79
iFDOOIGUXUw+KynEPyJ9DAQGJp3iMkjTicrxA9vzwTlOzCrwjkOi1EC7r1xgCw1L
XwCybJP8hphw/b95p2Qyt2E3BLg3ID4KyOw1yV+njwklDt3SRRmbAWcFhitN9GFQ
eX0D6Htnmgmv0eMW/0jw4ajOhnkIm8Ey8gPNOhX78gSno2GSymrq0lV8kTW1K7mK
TDe9veYLmrvRCWDLdjOUFbkUwbZgx2Gty8Ui1aXi07wcH3me3BHMGgbXMqWaktSk
GmMbs4KCzKNVyX2Il3VnwZZHE0lop2dPIMKyyIZAWMWOJGX0yVtANYDh37kCd8GK
+DDarS4RmtIrUL+XDoXAKP7AS6LGUhJj2PSCemYojGKKPmiyYj5rX/j+f2yEbOIx
sfpE5m80CoXx6Z6p5N9tIazdTwaBrZKc1fcbqytdh+Sx4gFRSJE41xshUAIBQm48
rMgjpZEgpkWXECcAkbx4
=LkCa
-----END PGP SIGNATURE-----

--ev7mvGV+3JQuI2Eo--
