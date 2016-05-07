Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60638 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbcEGPW0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 May 2016 11:22:26 -0400
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0MWCKz-1bAS4E0wdV-00XNrG for
 <linux-btrfs@vger.kernel.org>; Sat, 07 May 2016 17:22:23 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: random i/o error without error in dmesg
Date: Sat, 07 May 2016 17:22:13 +0200
Message-ID: <2609832.j3xfNZhHBD@thetick>
In-Reply-To: <1892242.Gv7fI7HlO2@thetick>
References: <562E0D31.2080003@dblaci.hu> <5339076.FcC2BAjqs5@thetick> <1892242.Gv7fI7HlO2@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2975475.fkG31Xn4XU"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2975475.fkG31Xn4XU
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Saturday 07 May 2016
schrieb Marc Joliet <marcec@gmx.de>

>I'm thinking of filing=20
>a bug report with dovecot; perhaps none of their devs test with btrfs?=


So I did this, and got a little bit of feedback.  Quoting from the repl=
y I=20
got:

"*.index.log files are always appended to using O_APPEND flag. Maybe th=
is is=20
relevant.

Also when a new .log file is created it's opened without the O_APPEND f=
lag and=20
the O_APPEND is added later. This was causing a bug recently in unionfs=
, which=20
ignored the flag change and caused log file corruption."

The other bit of advise was to stress test dovecot using imaptest, but =
I'll=20
have to do that when I have more time.

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart2975475.fkG31Xn4XU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXLggtAAoJEL/Q5oYsiHj0M3UP/RKl1tk9O7a1w6lx7DpOHi26
Ro9ggJ+YIC09Qdu8OBveHKEimOoC6LQTLxXT/qgOWxN4uN7BMyKRTNhQwXKzMnTs
5DOMeekS+hBbTuvKzLoSvyan/KFRp4S4c5scIsHis74w+d8KIAQhM4ji+y8Ps4m7
6ImyjVrfJ3u8+qguOR4ZfUjcPNX+SxlhMLCtuMMwbe+zzliwRxYU52iTHg8iy3jX
PCIHpfcVc9Ovlvt7mOuv2mLzeZwUqvE9R+6Zqv1hLlHBYu0pPZErYjcFQIbSp07+
T6g+UfLSWYP6pvKJZP2ZSF4Vw631wtidD/kJpiCZUbfJu2gVu6UKa2MC3xNJH5YE
n5Ti0SQBzVhE3RsMuhUIxQbQt4qg3xkak9772efMMjQNhvJh9D76vsMlt8j5FM5R
foHExt/mO9AzRAmytI2qlHBV9WdQBuAMu47E5MiuzQOJAGhJG95BSiV7LH8nJDuT
8kan+nFNFwyT8xv7yGW2HKk8GhetvFqoZajTmaDSJNUlvZaB7cqpcO3dzlgS6172
umFjxJaTPFZ4PUIUH1L5eWUtnb7zhirZ9YK7yiGdLxV3tfdoYo/mmy/G2Yr9DOoy
D1euHAQgaphV2Nlan/HDbuz8qdqIpS175vq9/Bg6UdzDPr6y9HcCdmUsXcEyMjhY
Kz+ZW3TTL8/mN1dQ3cdH
=Mm6w
-----END PGP SIGNATURE-----

--nextPart2975475.fkG31Xn4XU--

