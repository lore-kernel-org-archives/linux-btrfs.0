Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:34557 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbbF0Pvy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jun 2015 11:51:54 -0400
Date: Sat, 27 Jun 2015 20:51:48 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, clm@fb.com
Subject: Re: kernel 4.1: no space left on device
Message-ID: <20150627205148.284ff359@natsu>
In-Reply-To: <558EC1F4.1050301@profihost.ag>
References: <558EC1F4.1050301@profihost.ag>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qGTa02aejN0YgRuRL2h0QVU"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/qGTa02aejN0YgRuRL2h0QVU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 27 Jun 2015 17:32:04 +0200
Stefan Priebe <s.priebe@profihost.ag> wrote:

> Hi,
>=20
> while having some big btrfs volumes (44TB + 37TB).
>=20
> I see on a regular basis the "no space left on device" message. I'm only=
=20
> able to "fix" this. By running btrfs balance AND unmounting and=20
> remounting the btrfs volume.
>=20
> Is there any way to debug / workaround this one?

You should post your 'df', 'btrfs fi df' and 'btrfs fi show' for both devic=
es.

--=20
With respect,
Roman

--Sig_/qGTa02aejN0YgRuRL2h0QVU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlWOxpQACgkQTLKSvz+PZwi2EwCfXBtyaZ+G+5/48ttXUG+mL3hT
IxwAniaAr1Qx7UB0kbZhE+ZAUQkELLEv
=FNrA
-----END PGP SIGNATURE-----

--Sig_/qGTa02aejN0YgRuRL2h0QVU--
