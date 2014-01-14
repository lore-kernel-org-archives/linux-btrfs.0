Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.229.20.24]:36129 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbaANVTa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 16:19:30 -0500
Date: Wed, 15 Jan 2014 03:19:27 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How does btrfs handle bad blocks in raid1?
Message-ID: <20140115031927.4fd1d44b@natsu>
In-Reply-To: <1207CF09-B2A4-4DB6-9CA8-C3C78C1DA0F3@colorremedies.com>
References: <201401100106.s0A16CNd016476@atl4mhib27.myregisteredsite.com>
	<52CF4D5D.2010709@chinilu.com>
	<486C0640-409D-4636-858C-84A679C0AF4E@colorremedies.com>
	<20140115013703.33bb2799@natsu>
	<1207CF09-B2A4-4DB6-9CA8-C3C78C1DA0F3@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1Hj/+SU_.qg5FpbzA8MElJ9"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/1Hj/+SU_.qg5FpbzA8MElJ9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Jan 2014 14:05:11 -0700
Chris Murphy <lists@colorremedies.com> wrote:

>=20
> On Jan 14, 2014, at 12:37 PM, Roman Mamedov <rm@romanrm.net> wrote:
> >=20
> > I vaguely remember having some drives that were not able to remap a sin=
gle
> > block on write, but doing that successfully if I overwrote a sizable ar=
ea
> > around (and including) that block, or overwrite the whole drive. And af=
ter
> > that they worked without issue not exhibiting further bad blocks.
>=20
> Presumably the SMART self-assessment for this drive was FAIL?=20

No of course not, why? SMART goes to FAIL only if one of the attributes fal=
ls
below threshold, in this case that would be Reallocated Sector Count having
too much sectors. But nope, it either had zero, or in single-digit numbers.

I don't ever remember seeing a SMART FAIL drive that would function in any
usual sense of that word. Whereas such pecularities (bad sectors /
unremappable sectors / not wanting to remap until you overwrite large area =
and
perhaps even multiple times at that), all with SMART =3D PASS, are seen left
right and center.

> And if so what's the point of the work around when we only have a pass/fa=
il
> level granularity for drive health?

Not sure what you're referring to here. As said above, the FAIL/PASS status=
 is
largely useless, and the more important indicators are the values and dynam=
ics
in Reallocated sector count, Current pending sectors, Reported uncorrectabl=
e,
etc.

> a way to send a command to the firmware to persistently increase the rese=
rve
> sectors at the expensive of available space - in effect it reduces the LBA
> count by e.g. 10MB, thereby increasing the reserve pool by 10MB.

Yes please that, and also a pony. :)

-=20
With respect,
Roman

--Sig_/1Hj/+SU_.qg5FpbzA8MElJ9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLVqd8ACgkQTLKSvz+PZwhBaACgkMGzdB32ZvgkriTQSLa6sdKS
9ogAnjKVz8wO1Kc1D24ZuL1Ow3d3Tavw
=1Mg6
-----END PGP SIGNATURE-----

--Sig_/1Hj/+SU_.qg5FpbzA8MElJ9--
