Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35279 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbbH2U6C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Aug 2015 16:58:02 -0400
Received: by pacdd16 with SMTP id dd16so96812242pac.2
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Aug 2015 13:58:01 -0700 (PDT)
Received: from ?IPv6:2601:646:202:8861:215:6dff:fe85:a43b? ([2601:646:202:8861:215:6dff:fe85:a43b])
        by smtp.googlemail.com with ESMTPSA id wf3sm9600507pab.9.2015.08.29.13.58.00
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sat, 29 Aug 2015 13:58:00 -0700 (PDT)
Subject: Re: 4.1.6 gentoo-hardened: Hang during rename
References: <55E214DD.9070504@gmail.com>
To: linux-btrfs@vger.kernel.org
From: Kenneth Lakin <kennethlakin@gmail.com>
Message-ID: <55E21CD1.60202@gmail.com>
Date: Sat, 29 Aug 2015 13:57:53 -0700
MIME-Version: 1.0
In-Reply-To: <55E214DD.9070504@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iJPBuBrlAg8XXs3VGFvXXer8Fp5dAd4tK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iJPBuBrlAg8XXs3VGFvXXer8Fp5dAd4tK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Apologies, here is the rest of the info I should have included in my
first post:

# uname -a
Linux campstove 4.1.6-hardened #2 SMP PREEMPT Thu Aug 27 08:08:50 PDT
2015 i686 Intel(R) Core(TM) Duo CPU L2400 @ 1.66GHz GenuineIntel GNU/Linu=
x
# btrfs fi show
Label: 'root'  uuid: 6635e5f8-550d-4a62-8448-a68f6b93598d
  Total devices 1 FS bytes used 23.48GiB
  devid    1 size 37.17GiB used 35.18GiB path /dev/mapper/campstovevg-roo=
t

Label: none  uuid: 58acea0c-bf02-456f-b068-6f8f6bd0ca9f
  Total devices 1 FS bytes used 36.49GiB
  devid    1 size 41.49GiB used 38.02GiB path /dev/mapper/_dev_dm_1

btrfs-progs v4.1.2
# btrfs fi df /
Data, single: total=3D32.40GiB, used=3D22.03GiB
System, single: total=3D32.00MiB, used=3D16.00KiB
Metadata, single: total=3D2.75GiB, used=3D1.46GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B




--iJPBuBrlAg8XXs3VGFvXXer8Fp5dAd4tK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJV4hzSAAoJEDpEx4ha9HUK+AMQAK8t3GNRmByJvSqX4z2Ht7a3
XYBRrQhOgw7FtqOTLt9ZtUp3AlL5EE1wGq786qMima0+d2cP2utyK71VUnk3t+8/
S4aIglG8z+okML82PCKov3kQK08LbWM7fNZS/d9i2g70CVKDmF8Wku9wDr1t713j
9e54IwjGpRRaAg3Eh4cfn+0BAZgAwS9LuZiGl6VaoPru8odgm9EyQe31fSvuwdu/
qj/hq5zIin7nNPppfDrgoGPkH7es+mfUEgxK1I0eKJ+FCCOLpFRszTcKhRMYCxHq
PdC6xkGECFj4MXc01sh1Vdtw9xkTh2ntP5CfwIwbRLfr5t2CLzooxV81D1irohvI
oQn68zt9KXQmrqDxy1VFXHHqn59VAZ8SulV93f673GGxN3AA+OXWfs5+zxX3uJ9E
S2fzi3xhDTRfRUGFS0nRH0QPtE8SGAwJCxAh2PCevAasXqLOh0gc6AVti3QJeVMz
StdgVxatP98irR9krtR2DK5FwIiZc0CujHl2aadQZ9V8o3f4Nh2NYgetWuivD2Kq
nvl0/mdBloVuz/K1Xc80nY02KMjW18S9eAtfg0yUh8aYoP8sfLk31A0yu/TABgJu
nNos+K6qUx9iE3klM1ifUg4lf/ALjg/R82AuWEE50YpjIVA5IKZFp0XbvRL7x/Rd
xwzn8zMci6srUD1tt95x
=bY3n
-----END PGP SIGNATURE-----

--iJPBuBrlAg8XXs3VGFvXXer8Fp5dAd4tK--
