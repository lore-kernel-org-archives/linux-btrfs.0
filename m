Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50560 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbaGVHha (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 03:37:30 -0400
Received: from marcec ([77.22.138.176]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0MJSuF-1X71vf3xc3-0038jf for
 <linux-btrfs@vger.kernel.org>; Tue, 22 Jul 2014 09:37:29 +0200
Date: Tue, 22 Jul 2014 09:37:19 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC errors during balance
Message-ID: <20140722093719.51e8ab93@marcec>
In-Reply-To: <pan$1a441$ab255f41$47b5d104$887b5db7@cox.net>
References: <20140719172605.445e8445@marcec>
	<39E33553-3073-483E-9A2A-088212B40D0B@colorremedies.com>
	<pan$c685d$4bb40507$f2be4604$15619074@cox.net>
	<20140720122233.4ef06751@marcec>
	<20140720134054.3cd6cef3@marcec>
	<20140720214440.398e7e68@marcec>
	<20140721152216.27d8a4c4@marcec>
	<20140722003057.0f3b89f0@marcec>
	<20140722013022.52b189ee@marcec>
	<pan$1a441$ab255f41$47b5d104$887b5db7@cox.net>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//WJ46l/3iz8/p6a/2U=sHnn"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_//WJ46l/3iz8/p6a/2U=sHnn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Tue, 22 Jul 2014 03:26:39 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Marc Joliet posted on Tue, 22 Jul 2014 01:30:22 +0200 as excerpted:
>=20
> > And now that the background deletion of the old snapshots is done, the =
file
> > system ended up at:
> >=20
> > # btrfs filesystem df /run/media/marcec/MARCEC_BACKUP   =20
> > Data, single: total=3D219.00GiB, used=3D140.13GiB
> > System, DUP: total=3D32.00MiB, used=3D36.00KiB
> > Metadata, DUP: total=3D4.50GiB, used=3D2.40GiB
> > unknown, single: total=3D512.00MiB, used=3D0.00
> >=20
> > I don't know how reliable du is for this, but I used it to estimate how=
 much
> > used data I should expect, and I get 138 GiB.  That means that the snap=
shots
> > yield about 2 GiB "overhead", which is very reasonable, I think.  Obvio=
usly
> > I'll be starting a full balance now.
>=20
[snip total/used discussion]

No, you misunderstand: read my email three steps above yours (from the 21. =
at
15:22).  I am wondering about why the disk usage ballooned to >200 GiB in t=
he
first place.

--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_//WJ46l/3iz8/p6a/2U=sHnn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzhS3AAoJEL/Q5oYsiHj0YGQP/je0K8nfNKlWH9wSssksFw6q
2Oqg6EPeGNzOcH+lFLIBecF1R3rmkZPuQv7D8aNbdDLzltDgzpF7QbgazpQqTlwH
HYnPkg8silmgCWbA1wuPrYZtuw/gW6oOU7xiDFSq1/PVi61OqKjT46UqhH1WZjbB
VTKQznr0cjT189htS+EfJmIBIrWIPAgTwi/FmPjHTx4FQ3g5wW9niZxQSq/xQWXR
5bw8h5P9STxe/j+n3C15AZ/cyBwPLWk+V0GGiO5dkNCfxbSSwlykd5rWMo/tgxHW
1CAcdMDTvjZidkE41NzjwIPTCDlCflMkRR4Mc0M6ZfXMk3aP1TxUfTFGhINn6S/+
yJbzQ5yv9wy2pQ11FxoTZ657YY0hrRQjLvnZFCLW0adeRQ1DGjFbrgzFvbvPvcbM
kVoAiGwtpGGWPgFNrRhQ2fdW3Uf1eQbHRvjqkKGlCc9yQP3+rCMAXIFnOKgbGolW
0aPxCxwnXf2YtN4Gig09e5W0m8utuD94/UuocDRQeGK3txyqvB2v474l98CYBf5k
SVy6T0oovo+4ob93H5cy1fnoMqprXBFkXETi26crI8fHqulZ85kMkrFvBP2vmw3B
3jk1Z9deejEomKDwQw1kiQVBRDnPOCXqOIR6taajRYPX4BkneHRNU2tKFF28FCV0
g1XBypYqOMOL8JDPNXxw
=f7iW
-----END PGP SIGNATURE-----

--Sig_//WJ46l/3iz8/p6a/2U=sHnn--
