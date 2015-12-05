Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:64205 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbbLEOMF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Dec 2015 09:12:05 -0500
Received: from thetick.localnet ([93.181.44.4]) by smtp.web.de (mrweb004) with
 ESMTPSA (Nemesis) id 0LaZQd-1aYU6X2dbj-00mM14 for
 <linux-btrfs@vger.kernel.org>; Sat, 05 Dec 2015 15:12:02 +0100
From: Marc Joliet <marcec@web.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: compression disk space saving - what are your results?
Date: Sat, 05 Dec 2015 15:11:51 +0100
Message-ID: <1864635.CI05HQM0X6@thetick>
In-Reply-To: <6329794.eixGOkx0p3@thetick>
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com> <6329794.eixGOkx0p3@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3847129.U3CGzM8B8N"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3847129.U3CGzM8B8N
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Saturday 05 December 2015 14:37:05 Marc Joliet wrote:
>My desktop looks like this:
>
>% df -h
>Dateisystem    Gr=C3=B6=C3=9Fe Benutzt Verf. Verw% Eingeh=C3=A4ngt auf=

>/dev/sda1       108G     79G   26G   76% /
>[...]
>
>For / I get a total of about 8G or at least 9% space saving:
>
># du -hsc /mnt/rootfs/*
>71G     /mnt/rootfs/home
>14G     /mnt/rootfs/rootfs
>2,3G    /mnt/rootfs/var
>87G     insgesamt
>
>I write "at least" because this does not include snapshots.

Just to be explicit, in case it was not clear, but I of course meant th=
at the=20
*du output* does not account for extra space used by snapshots.

>On my laptop
>the  difference is merely 1 GB (83 vs. 84 GB),

And here I also want to clarify that the df output was 84 GB, and the d=
u=20
output was 83 GB.  Again, the du output does not account for snapshots,=
 which=20
go back farther on the laptop: 2 weeks of daily snapshots (with autodef=
rag!)=20
instead of up to up to 2 days of bi-hourly snapshots.

I do think it's interesting that compression (even with LZO) seems to h=
ave=20
offset the extra space wastage caused by autodefrag.

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart3847129.U3CGzM8B8N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWYvCrAAoJEL/Q5oYsiHj0ELgP/R6+xuLz6g+3RCIxvoUkB2sv
IiO100Lyq+wxHMp+ro/tZd34VEodyr1BthPj59bApKvE2Chc/BvXxIzqHf1r3/Eh
V+Lc+4+GRVfJF8f+kUUxtvn498vKPPQRBJYGGg3nxj/S235E3mt63eeTXbCUOxuI
k4e+XXEXYVF7lm24HzT7IL+e9zM2WY+ZlFbqsF84RsFsYYfS/AK06FP372JS3boU
N1GYQAn3IWeGy26sQGdkbY1neUY3GSwIUB8ZdF10o5QVGE6+tcNUuMuUlz40nbdC
ESDFJVpwuo3igcvwZa4nOQ2FKGR7d2sCay/DnJ8tsF7WV+LEseTtU9EcLEIGJib8
1ToXMpx92h7C45oCYNGR4EnUrXdgOGYQ+j97wBl8+DigEIpSt9kZqr21OLQUtlO2
iOorEkGfdF7wNaQkaND4hKVSLIAxR8xSyb7KmW1CabFSOkUczogjaTZxuN6FLyOr
X+qQlX87QOW7iV7+UoXNgJjCMwbWOxeH5Kv90IJ32Aig9MEAo2lfk7xRbBHpTOW9
Qkd2zTgb3XtcBo6pVquLDrSvoohrzzG8QfRNI34FQaCJeWIntZ4NINAA7HQhkhoP
8uD7G395emWZ1HsQX44hhhfY4oRPbtPW95DH+ZE4kIkLc+0n+J+898AQn0lh0T8A
NJEzC0gw6H/nzHdLBe9q
=p6Ci
-----END PGP SIGNATURE-----

--nextPart3847129.U3CGzM8B8N--

