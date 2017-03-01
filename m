Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:51397 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752303AbdCASfN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Mar 2017 13:35:13 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0LedVG-1bxSgT49BG-00qORU for
 <linux-btrfs@vger.kernel.org>; Wed, 01 Mar 2017 19:28:00 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already exists
Date: Wed, 01 Mar 2017 19:27:54 +0100
Message-ID: <14042548.TX92NSv1AZ@thetick>
In-Reply-To: <14737660.8idzxVKBRv@thetick>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de> <63cf74bb-009a-b422-4390-7562395db31d@cn.fujitsu.com> <14737660.8idzxVKBRv@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5930958.ub92GHGjzy"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart5930958.ub92GHGjzy
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Wednesday 01 March 2017 19:14:07 Marc Joliet wrote:
> > And btrfs check --mode=3Dlowmem is also recommended as in some rare=
 case,
> > low mem mode can detect bug which original mode doesn't.
>=20
> I did see differences in output the last time around (again, see my
> previous  messages in this thread), so I'll run with lowmem.

OK, just to prevent confusion: it turns out I never posted the output o=
f=20
btrfs-check with --mode=3Dlowmem from the first time I was seeing these=
 errors,=20
but I remember the output being (slightly) different from the original =
mode.

=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart5930958.ub92GHGjzy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYtxKqAAoJEL/Q5oYsiHj0GK8P/1Gt4vQRkSud3SE5Sqi85G4T
AwZAF9GG929JzSgyM7mmmuf63TOWIFVadTjm4ScteHPzzSvMby7hkzMHPNWD3XKp
RTDumitIO9zIZwl8HLFEV0LACYxqklouNeWZjZelgvkcx0WTJkvGBAHXmLaIDoXj
Pziy1Wn1wVQ39k4cRZkw0nUI9F+cqEIXhxBPeWX9VWHbZuixS+/IABuCzUGOgJ6h
egvEF3ANjnR9VWCLYvAogZdBxFGhzwkKDukm7AijJQMqxdHTertVAk8fuKOU5KOt
TTq7wTyo50p2cvQ0flPEnZ9245/B5VkRPod36+VxAo6nBafPllwjbJfm2uOWU2eo
0QKlWTZ81u5ZPTa42vAWXXrWCBsXPUj7vGbArii6bc6wWpHOMBbv9eyvm4cWgsZe
se2YDpzNyBa2+CHrS+8+B5ibwdSWTKkFsVkT7Dx2c4fGqluZpej97kXSnvpQ+9B5
eiEyMQl953TzHGo8ElQ52SGyytN20ch0fwRrvINe0UAL672SRV6v9frBu+BjkStm
UZjpZf03FF0SedAwEd2kPDTc/U2+w5u66Z2rQUPF+nyYGa63puWm/FBWJM8TwYaF
bw6nRW+duGqUyFag/bSzknaPIh7Si68dxOVQNTqd6Pu8cWnFI5RZl2eA5gvkcDTb
yBtBAVd8hVlkuIjAq5iF
=KMxu
-----END PGP SIGNATURE-----

--nextPart5930958.ub92GHGjzy--

