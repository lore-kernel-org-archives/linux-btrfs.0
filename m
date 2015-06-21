Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:41073 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbbFUSWX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Jun 2015 14:22:23 -0400
Date: Sun, 21 Jun 2015 23:22:21 +0500
From: Roman Mamedov <rm@romanrm.net>
To: =?UTF-8?B?U3fDom1p?= Petaramesh <swami@petaramesh.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Is there a "nossd" option ?
Message-ID: <20150621232221.6ef1c967@natsu>
In-Reply-To: <4527646.9Fsd4pK4E8@zafu>
References: <1586648.BNplRrhkhg@zafu>
	<20150621223121.617b8894@natsu>
	<4527646.9Fsd4pK4E8@zafu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oyl=lIvHu_kGgUXrTkV4VL_"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/oyl=lIvHu_kGgUXrTkV4VL_
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 21 Jun 2015 20:11:25 +0200
Sw=C3=A2mi Petaramesh <swami@petaramesh.org> wrote:

> Le dimanche 21 juin 2015 22:31:21 Roman Mamedov a =C3=A9crit :
> >=20
> > Yes the "nossd" option (written literally like that) does in fact exist.
> > It would have taken you less time to try if it works, than to write this
> > long-winded message. :)
>=20
> Possibly. Unless trying a non-existing mount option causes the mount to f=
ail,=20
> thus causing the system boot to fail, thus needing me to boot from a live=
=20
> rescue CD... that would take much longer than writing an half-page=20
> email ;-)
 =20
  mount / -o nossd,remount=20

works too:

[3917300.257773] BTRFS info (device dm-0): not using ssd allocation scheme

As a side note, I used this option a lot in the past to make remote block
devices such as NBD or AoE not detect as SSDs.

--=20
With respect,
Roman

--Sig_/oyl=lIvHu_kGgUXrTkV4VL_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlWHAN0ACgkQTLKSvz+PZwiaAQCfVfcZZ4tSTlEcCAIlJ8QJs4vc
BagAoIZoRuTfIctta009+5q0lammlD97
=F100
-----END PGP SIGNATURE-----

--Sig_/oyl=lIvHu_kGgUXrTkV4VL_--
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
