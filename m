Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 176-31-121-172.kimsufi.com ([176.31.121.172]:38537 "EHLO
	len.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422714Ab2JaNxU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 09:53:20 -0400
Date: Wed, 31 Oct 2012 19:44:11 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Michael =?UTF-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
Cc: cwillu <cwillu@cwillu.com>, Ahmet Inan <ainan@mathematik.uni-freiburg.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: Why btrfs inline small file by default?
Message-ID: <20121031194411.3ee694f5@natsu>
In-Reply-To: <20121031115639.GB26070@yeono.kjorling.se>
References: <CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com>
	<50904949.8010603@gmail.com>
	<20121030221412.GB11422@carfax.org.uk>
	<20121030221947.GC11422@carfax.org.uk>
	<50906702.1010608@gmail.com>
	<CAE5mzvgMskhBgH506BageXREifs63Zn_HKDaWBMuesS8Np66SQ@mail.gmail.com>
	<CAFDW0j+1wx2_ZewQ69W7fyLuMyYxq29g62FGH5uX9kAFv-H3eQ@mail.gmail.com>
	<CAE5mzvgRqTC+zismMUt0AOYWP52EN9taowARqU=he1cmVMSTEQ@mail.gmail.com>
	<CAFDW0jLGFwrg-9GDoBUxHa6M0ZgjB4W4GJg3b88+6L-dGLJMUw@mail.gmail.com>
	<CAE5mzvjc2EfZ-+P55PukWmM7EduOdBephnuBGAe2JPKuOiQ0vg@mail.gmail.com>
	<20121031115639.GB26070@yeono.kjorling.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7RNDv.WoKekHB6FukeadTkx"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/7RNDv.WoKekHB6FukeadTkx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 31 Oct 2012 11:56:39 +0000
Michael Kj=C3=B6rling <michael@kjorling.se> wrote:

> On 31 Oct 2012 04:57 -0600, from cwillu@cwillu.com (cwillu):
> > 9.08GB + 992.48MB*2 =3D=3D 11.02GB
> >=20
> > 10.85GB + 518MB*2 =3D=3D 11.86GB
> >=20
> > That's nearly a GB smaller.
>=20
> That, too; I missed the "DUP". Not quite as pronounced as in my
> calculations, then, but still a significant enough difference.

There is also a number of cases which justify disabling DUP for metadata, e=
.g.

- underlying block device is an internally deduplicating SSD (i.e. possibly
  most of them)
- or the block device is a RAID incorporating redundancy
- or simply one wants increase performance at the cost of some reliability

With non-DUP metadata your calculations showing inlining being more efficie=
nt
remain correct.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/7RNDv.WoKekHB6FukeadTkx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCRKysACgkQTLKSvz+PZwjuKQCaAqJmTSKpgL2N9WA1T3XiyQHU
ObAAn1QLoarpJP2zbVvAjVKbduS6G1z4
=S2rF
-----END PGP SIGNATURE-----

--Sig_/7RNDv.WoKekHB6FukeadTkx--
