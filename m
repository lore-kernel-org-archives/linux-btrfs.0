Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.gocept.net ([195.62.125.19]:52297 "EHLO mail.gocept.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751078AbdBWNTe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Feb 2017 08:19:34 -0500
From: Christian Theune <ct@flyingcircus.io>
Message-Id: <3DCDD3DC-4201-4529-AACA-07A431AB4D6C@flyingcircus.io>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_8C76D25A-A2E8-4CD2-9F36-E3173D63C6B6";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Re: Downgrading kernel 4.9 to 4.4 with space_cache=v2 enabled?
Date: Thu, 23 Feb 2017 14:19:12 +0100
In-Reply-To: <71958378-5AB4-4E66-8F54-60215141D1BB@flyingcircus.io>
Cc: linux-btrfs@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <BB064A3C-6F5C-4490-80A6-F42BEFAA945A@flyingcircus.io>
 <029c96aa-9c1e-f12c-8b63-4e4485428c67@gmail.com>
 <71958378-5AB4-4E66-8F54-60215141D1BB@flyingcircus.io>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_8C76D25A-A2E8-4CD2-9F36-E3173D63C6B6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi,

just for future reference if someone finds this thread: there is a bit =
of output I=E2=80=99m seeing with this crashing kernel (unclear whether =
related to btrfs or not):

  31 | 02/23/2017 | 09:51:22 | OS Stop/Shutdown #0x4f | Run-time =
critical stop | Asserted
  32 | Linux kernel panic: Out of memo
  33 | Linux kernel panic: ry and no k
  34 | Linux kernel panic: illable pro
  35 | Linux kernel panic: cesses...

Cheers,
Christian


--
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 http://flyingcircus.io
Forsterstra=C3=9Fe 29 =C2=B7 06112 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian. =
Theune, Christian. Zagrodnick


--Apple-Mail=_8C76D25A-A2E8-4CD2-9F36-E3173D63C6B6
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQEcBAEBCgAGBQJYruFQAAoJEKuh8lKpfGLOOWEH/2Bf0/RurQPvPyQ+Bx5vqIWS
6d3lHCtD1ob9sx4DYGJq2xwvOAsTzjB4rljCiOiOyy3xquNCfq7xiI1UKD3z/5ih
/bhIeb9mqb1g9kc6Xreyfo03TFx44KaPGmlLsV9zN2uG1QcxxNYpZVuwIMRHD5xH
TNN8zHvKeJxX970fPt+N4NgVNihFxmSvZxW1pQEciedHq9dWKldazLDN76N3TR5Y
3l7VzYmNGCXdLDiCNJHUsVJxl2556jNLIV+166dr7fl//oMjAZZkVGOgNY2QqTab
e1UfpQbwjwy1J8I9PASrHYRiJTlQZNYtfw5OImDI2C91NDvDuel9mv4yBwclg+I=
=4pSB
-----END PGP SIGNATURE-----

--Apple-Mail=_8C76D25A-A2E8-4CD2-9F36-E3173D63C6B6--
