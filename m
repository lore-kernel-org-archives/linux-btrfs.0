Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:47598 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbbHZTwc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 15:52:32 -0400
Date: Thu, 27 Aug 2015 00:52:30 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs duperemove corrupt data while dedup
Message-ID: <20150827005230.402ecd0d@natsu>
In-Reply-To: <CAGqmi76J4XWv+ureSG66Da_E-xq3MqGahbhsaTR6Sf2rSHd4Ug@mail.gmail.com>
References: <CAGqmi76J4XWv+ureSG66Da_E-xq3MqGahbhsaTR6Sf2rSHd4Ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/o/etQNzGCNoIfjHTn4ZYCrb"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/o/etQNzGCNoIfjHTn4ZYCrb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Aug 2015 22:33:38 +0300
Timofey Titovets <nefelim4ag@gmail.com> wrote:

> what i've got (full diff in attach):
> --- /home/nefelim4ag/dedup.after        2015-08-26 21:36:55.773452558 +03=
00
> +++ /home/nefelim4ag/dedup.before       2015-08-26 21:21:01.203600761 +03=
00
> @@ -25139,9 +25139,9 @@ caf9d41036e46b85d90a9541e8bc9ce1  /home/
> ....
> -0ccbc9c81a51f59dcf2ac0d102de37cb
> /home/nefelim4ag/L4D2/left4dead2/pak01_003.vpk
> +e665b502ee977dc1c619ecbd415c91b8
> /home/nefelim4ag/L4D2/left4dead2/pak01_000.vpk
> ....
>=20
> Files sizes not changed and it's > 1MB.
>=20
> Every time i've get a random data corruption.

I'd suggest that you use "vbindiff" to visually compare two files to check
what the actual corruption is, maybe this could give some hints. Is it the =
1st
block, the last block, a few random bytes all over the place (unlikely), are
some parts zeroed out or contain just entirely different data, etc.

--=20
With respect,
Roman

--Sig_/o/etQNzGCNoIfjHTn4ZYCrb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlXeGP4ACgkQTLKSvz+PZwhyawCggmwMHdh/xO9mUWstlvBii03Q
+6MAn2Ht23Op3n/UMuwsrk+bevVLhPP0
=GAQ6
-----END PGP SIGNATURE-----

--Sig_/o/etQNzGCNoIfjHTn4ZYCrb--
