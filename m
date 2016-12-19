Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58439 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932352AbcLSLMb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 06:12:31 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0Metpl-1byoi23xV3-00OYLJ for
 <linux-btrfs@vger.kernel.org>; Mon, 19 Dec 2016 12:12:28 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-check finds file extent holes
Date: Mon, 19 Dec 2016 12:12:21 +0100
Message-ID: <2803352.RXeKIAebAS@thetick>
In-Reply-To: <6935146.pedKUuRHNK@thetick>
References: <6935146.pedKUuRHNK@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2598015.VZ1nIrqhte"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2598015.VZ1nIrqhte
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Saturday 17 December 2016 00:18:13 Marc Joliet wrote:
> The initial results with btrfs-check's low-memory mode found=20
> reference count mismatches, but that seems to have been a false posit=
ive,=20
> since btrfs-check's normal mode does not find them.

FWIW, just in case this wasn't known yet (I know lowmem mode is still=20=

considered experimental), here is the lowmem output from three runs, in=
 order. =20
(I don't have the exact dates, but the FS was mounted in-between each r=
un over=20
the course of about 24 hours.)

# btrfs check --mode lowmem /dev/sdb2                                  =
                                                                       =
                                                                       =
                                 =20
Checking filesystem on /dev/sdb2
UUID: f97b3cda-15e8-418b-bb9b-235391ef2a38
checking extents
ERROR: extent[3839195598848, 20480] referencer count mismatch (root: 31=
589,=20
owner: 2688918, offset: 4927488) wanted: 3, have: 4
ERROR: extent[3839195598848, 20480] referencer count mismatch (root: 31=
614,=20
owner: 2688918, offset: 4927488) wanted: 3, have: 4
ERROR: extent[3839195598848, 20480] referencer count mismatch (root: 31=
422,=20
owner: 2688918, offset: 4927488) wanted: 2, have: 4
ERROR: extent[3840794644480, 655360] referencer count mismatch (root: 3=
1422,=20
owner: 494683, offset: 734683136) wanted: 6, have: 11
ERROR: extent[3840794644480, 655360] referencer count mismatch (root: 3=
1579,=20
owner: 494683, offset: 734683136) wanted: 2, have: 7
^C

# btrfs check --mode lowmem /dev/sdb2                                  =
                                                                       =
                                                                       =
                                 =20
[6/1151]
Checking filesystem on /dev/sdb2
UUID: f97b3cda-15e8-418b-bb9b-235391ef2a38
checking extents
ERROR: extent[3839195598848, 20480] referencer count mismatch (root: 31=
614,=20
owner: 2688918, offset: 4927488) wanted: 3, have: 4
ERROR: extent[3839195598848, 20480] referencer count mismatch (root: 31=
422,=20
owner: 2688918, offset: 4927488) wanted: 2, have: 4
ERROR: extent[3840794644480, 655360] referencer count mismatch (root: 3=
1422,=20
owner: 494683, offset: 734683136) wanted: 6, have: 11
ERROR: extent[3840794644480, 655360] referencer count mismatch (root: 3=
1579,=20
owner: 494683, offset: 734683136) wanted: 2, have: 7
ERROR: extent[3853952757760, 4096] referencer count mismatch (root: 316=
14,=20
owner: 2688918, offset: 4935680) wanted: 1, have: 2
ERROR: extent[3855013117952, 32768] referencer count mismatch (root: 30=
188,=20
owner: 494681, offset: 32219136) wanted: 1, have: 2
ERROR: extent[3855013117952, 32768] referencer count mismatch (root: 30=
819,=20
owner: 494681, offset: 32219136) wanted: 1, have: 2
ERROR: extent[3855013117952, 32768] referencer count mismatch (root: 28=
250,=20
owner: 494681, offset: 32219136) wanted: 1, have: 2
ERROR: extent[3855013117952, 32768] referencer count mismatch (root: 29=
175,=20
owner: 494681, offset: 32219136) wanted: 1, have: 2
ERROR: extent[3855015211008, 57344] referencer count mismatch (root: 31=
614,=20
owner: 494681, offset: 32366592) wanted: 1, have: 2
ERROR: extent[3855015211008, 57344] referencer count mismatch (root: 31=
538,=20
owner: 494681, offset: 32366592) wanted: 1, have: 2
ERROR: extent[3855015211008, 57344] referencer count mismatch (root: 31=
579,=20
owner: 494681, offset: 32366592) wanted: 1, have: 2
ERROR: extent[3855015211008, 57344] referencer count mismatch (root: 31=
466,=20
owner: 494681, offset: 32366592) wanted: 1, have: 2
ERROR: extent[3855015211008, 57344] referencer count mismatch (root: 31=
540,=20
owner: 494681, offset: 32366592) wanted: 1, have: 2
ERROR: extent[3856459112448, 770048] referencer count mismatch (root: 3=
0819,=20
owner: 494683, offset: 1430528000) wanted: 1, have: 10
ERROR: extent[3856582701056, 4096] referencer count mismatch (root: 315=
72,=20
owner: 195432, offset: 83841024) wanted: 1, have: 0
ERROR: extent[3857416364032, 98304] referencer count mismatch (root: 31=
614,=20
owner: 494683, offset: 735207424) wanted: 2, have: 3
ERROR: extent[3857416364032, 98304] referencer count mismatch (root: 31=
624,=20
owner: 494683, offset: 735207424) wanted: 1, have: 3
ERROR: extent[3857658413056, 65536] referencer count mismatch (root: 29=
175,=20
owner: 2261987, offset: 474120192) wanted: 1, have: 2
ERROR: extent[3861689466880, 40960] referencer count mismatch (root: 31=
383,=20
owner: 1277577, offset: 12189696) wanted: 1, have: 2
ERROR: extent[3861689995264, 40960] referencer count mismatch (root: 31=
383,=20
owner: 1277577, offset: 12320768) wanted: 1, have: 2
ERROR: extent[3861694464000, 32768] referencer count mismatch (root: 30=
904,=20
owner: 1277577, offset: 4980736) wanted: 3, have: 10
ERROR: extent[3861694464000, 32768] referencer count mismatch (root: 30=
937,=20
owner: 1277577, offset: 4980736) wanted: 3, have: 10
ERROR: extent[3861694464000, 32768] referencer count mismatch (root: 31=
570,=20
owner: 1277577, offset: 4980736) wanted: 3, have: 10
ERROR: extent[3861694464000, 32768] referencer count mismatch (root: 31=
569,=20
owner: 1277577, offset: 4980736) wanted: 3, have: 10
ERROR: extent[3861694464000, 32768] referencer count mismatch (root: 30=
910,=20
owner: 1277577, offset: 4980736) wanted: 3, have: 10
ERROR: extent[3861694464000, 32768] referencer count mismatch (root: 30=
824,=20
owner: 1277577, offset: 4980736) wanted: 3, have: 10
ERROR: extent[3861694464000, 32768] referencer count mismatch (root: 31=
044,=20
owner: 1277577, offset: 4980736) wanted: 3, have: 10
ERROR: extent[3861694464000, 32768] referencer count mismatch (root: 31=
048,=20
owner: 1277577, offset: 4980736) wanted: 3, have: 10
ERROR: extent[3861694464000, 32768] referencer count mismatch (root: 31=
363,=20
owner: 1277577, offset: 4980736) wanted: 3, have: 10
ERROR: extent[3861698289664, 45056] referencer count mismatch (root: 30=
824,=20
owner: 1277577, offset: 12845056) wanted: 3, have: 5
ERROR: extent[3861700083712, 40960] referencer count mismatch (root: 30=
824,=20
owner: 1277577, offset: 13107200) wanted: 2, have: 3
ERROR: extent[3861711024128, 40960] referencer count mismatch (root: 30=
653,=20
owner: 1277577, offset: 4063232) wanted: 4, have: 7
ERROR: extent[3861711024128, 40960] referencer count mismatch (root: 30=
629,=20
owner: 1277577, offset: 4063232) wanted: 3, have: 7
ERROR: extent[3861711593472, 45056] referencer count mismatch (root: 30=
653,=20
owner: 1277577, offset: 2228224) wanted: 1, have: 2
ERROR: extent[3861717663744, 49152] referencer count mismatch (root: 31=
570,=20
owner: 1277577, offset: 3145728) wanted: 2, have: 4
ERROR: extent[3861717663744, 49152] referencer count mismatch (root: 31=
569,=20
owner: 1277577, offset: 3145728) wanted: 2, have: 4
ERROR: extent[3861718708224, 45056] referencer count mismatch (root: 30=
653,=20
owner: 1277577, offset: 3538944) wanted: 1, have: 8
ERROR: extent[3861719072768, 45056] referencer count mismatch (root: 30=
653,=20
owner: 1277577, offset: 3801088) wanted: 5, have: 6
ERROR: extent[3861719748608, 45056] referencer count mismatch (root: 31=
570,=20
owner: 1277577, offset: 4325376) wanted: 2, have: 7
ERROR: extent[3861719748608, 45056] referencer count mismatch (root: 31=
569,=20
owner: 1277577, offset: 4325376) wanted: 2, have: 7
ERROR: extent[3861721608192, 40960] referencer count mismatch (root: 31=
570,=20
owner: 1277577, offset: 4849664) wanted: 7, have: 8
ERROR: extent[3861721608192, 40960] referencer count mismatch (root: 31=
569,=20
owner: 1277577, offset: 4849664) wanted: 7, have: 8
ERROR: extent[3861742219264, 40960] referencer count mismatch (root: 30=
904,=20
owner: 1277577, offset: 5373952) wanted: 8, have: 10
ERROR: extent[3861742219264, 40960] referencer count mismatch (root: 30=
937,=20
owner: 1277577, offset: 5373952) wanted: 8, have: 10
ERROR: extent[3861742219264, 40960] referencer count mismatch (root: 31=
570,=20
owner: 1277577, offset: 5373952) wanted: 8, have: 10
ERROR: extent[3861742219264, 40960] referencer count mismatch (root: 31=
569,=20
owner: 1277577, offset: 5373952) wanted: 8, have: 10
ERROR: extent[3861742219264, 40960] referencer count mismatch (root: 30=
910,=20
owner: 1277577, offset: 5373952) wanted: 8, have: 10
ERROR: extent[3861742219264, 40960] referencer count mismatch (root: 30=
824,=20
owner: 1277577, offset: 5373952) wanted: 8, have: 10
ERROR: extent[3861742219264, 40960] referencer count mismatch (root: 31=
044,=20
owner: 1277577, offset: 5373952) wanted: 8, have: 10
ERROR: extent[3861742219264, 40960] referencer count mismatch (root: 31=
048,=20
owner: 1277577, offset: 5373952) wanted: 8, have: 10
ERROR: extent[3861742219264, 40960] referencer count mismatch (root: 31=
363,=20
owner: 1277577, offset: 5373952) wanted: 8, have: 10
ERROR: extent[3861811728384, 65536] referencer count mismatch (root: 30=
188,=20
owner: 494681, offset: 51904512) wanted: 2, have: 3
ERROR: extent[3861811728384, 65536] referencer count mismatch (root: 31=
113,=20
owner: 494681, offset: 51904512) wanted: 2, have: 3
ERROR: extent[3861849968640, 45056] referencer count mismatch (root: 30=
653,=20
owner: 1277577, offset: 6160384) wanted: 5, have: 7
ERROR: extent[3861947879424, 49152] referencer count mismatch (root: 31=
660,=20
owner: 494681, offset: 63864832) wanted: 1, have: 2
ERROR: extent[3861947879424, 49152] referencer count mismatch (root: 31=
579,=20
owner: 494681, offset: 63864832) wanted: 1, have: 2
ERROR: extent[3861947879424, 49152] referencer count mismatch (root: 29=
175,=20
owner: 494681, offset: 63864832) wanted: 1, have: 2
ERROR: extent[3862172643328, 49152] referencer count mismatch (root: 28=
250,=20
owner: 494681, offset: 79257600) wanted: 1, have: 2
ERROR: extent[3862172643328, 49152] referencer count mismatch (root: 31=
422,=20
owner: 494681, offset: 79257600) wanted: 1, have: 2
ERROR: extent[3862172643328, 49152] referencer count mismatch (root: 31=
113,=20
owner: 494681, offset: 79257600) wanted: 1, have: 2
ERROR: extent[3862177021952, 40960] referencer count mismatch (root: 31=
614,=20
owner: 494681, offset: 81608704) wanted: 1, have: 2
ERROR: extent[3862177021952, 40960] referencer count mismatch (root: 31=
579,=20
owner: 494681, offset: 81608704) wanted: 1, have: 2
ERROR: extent[3862177021952, 40960] referencer count mismatch (root: 31=
466,=20
owner: 494681, offset: 81608704) wanted: 1, have: 2
ERROR: extent[3862177816576, 32768] referencer count mismatch (root: 31=
422,=20
owner: 494681, offset: 82059264) wanted: 1, have: 2
ERROR: extent[3862177816576, 32768] referencer count mismatch (root: 31=
113,=20
owner: 494681, offset: 82059264) wanted: 1, have: 2
ERROR: extent[3862969823232, 28672] referencer count mismatch (root: 31=
510,=20
owner: 213766, offset: 5021696) wanted: 1, have: 0
ERROR: extent[3863189831680, 155648] referencer count mismatch (root: 2=
9175,=20
owner: 494683, offset: 1419395072) wanted: 1, have: 6
^C

# btrfs check --mode lowmem /dev/sdb2                                  =
                                                                       =
                                                                       =
                                         =20
Checking filesystem on /dev/sdb2
UUID: f97b3cda-15e8-418b-bb9b-235391ef2a38
checking extents
ERROR: extent[3839195598848, 20480] referencer count mismatch (root: 31=
614,=20
owner: 2688918, offset: 4927488) wanted: 3, have: 4
ERROR: extent[3839195598848, 20480] referencer count mismatch (root: 31=
707,=20
owner: 2688918, offset: 4927488) wanted: 3, have: 4
ERROR: extent[3839195598848, 20480] referencer count mismatch (root: 31=
422,=20
owner: 2688918, offset: 4927488) wanted: 2, have: 4
ERROR: extent[3840794644480, 655360] referencer count mismatch (root: 3=
1422,=20
owner: 494683, offset: 734683136) wanted: 6, have: 11
ERROR: extent[3840794644480, 655360] referencer count mismatch (root: 3=
1579,=20
owner: 494683, offset: 734683136) wanted: 2, have: 7
ERROR: extent[3853952757760, 4096] referencer count mismatch (root: 316=
14,=20
owner: 2688918, offset: 4935680) wanted: 1, have: 2
ERROR: extent[3853952757760, 4096] referencer count mismatch (root: 317=
07,=20
owner: 2688918, offset: 4935680) wanted: 1, have: 2
ERROR: extent[3855013117952, 32768] referencer count mismatch (root: 30=
188,=20
owner: 494681, offset: 32219136) wanted: 1, have: 2
ERROR: extent[3855013117952, 32768] referencer count mismatch (root: 30=
819,=20
owner: 494681, offset: 32219136) wanted: 1, have: 2
ERROR: extent[3855013117952, 32768] referencer count mismatch (root: 28=
250,=20
owner: 494681, offset: 32219136) wanted: 1, have: 2
ERROR: extent[3855013117952, 32768] referencer count mismatch (root: 29=
175,=20
owner: 494681, offset: 32219136) wanted: 1, have: 2
ERROR: extent[3855015211008, 57344] referencer count mismatch (root: 31=
614,=20
owner: 494681, offset: 32366592) wanted: 1, have: 2
ERROR: extent[3855015211008, 57344] referencer count mismatch (root: 31=
538,=20
owner: 494681, offset: 32366592) wanted: 1, have: 2
ERROR: extent[3855015211008, 57344] referencer count mismatch (root: 31=
684,=20
owner: 494681, offset: 32366592) wanted: 1, have: 2
ERROR: extent[3855015211008, 57344] referencer count mismatch (root: 31=
579,=20
owner: 494681, offset: 32366592) wanted: 1, have: 2
ERROR: extent[3855015211008, 57344] referencer count mismatch (root: 31=
697,=20
owner: 494681, offset: 32366592) wanted: 1, have: 2
ERROR: extent[3855015211008, 57344] referencer count mismatch (root: 31=
466,=20
owner: 494681, offset: 32366592) wanted: 1, have: 2
ERROR: extent[3855015211008, 57344] referencer count mismatch (root: 31=
540,=20
owner: 494681, offset: 32366592) wanted: 1, have: 2
ERROR: extent[3856388816896, 20480] referencer count mismatch (root: 31=
697,=20
owner: 2688944, offset: 74829824) wanted: 1, have: 0
ERROR: extent[3856388816896, 20480] referencer count mismatch (root: 31=
714,=20
owner: 2688944, offset: 74829824) wanted: 1, have: 0
ERROR: extent[3856459112448, 770048] referencer count mismatch (root: 3=
0819,=20
owner: 494683, offset: 1430528000) wanted: 1, have: 10
ERROR: extent[3856582701056, 4096] referencer count mismatch (root: 315=
72,=20
owner: 195432, offset: 83841024) wanted: 1, have: 0
^C

=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup
--nextPart2598015.VZ1nIrqhte
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYV8CWAAoJEL/Q5oYsiHj0Z7YP/3M3BgsmmqZcSTBWiyaXg5cm
MuxIvrMqcay6M5oOZsHkNqSji4sZ1r60x1nrnb5LPdRp9wLtM57Uw+QFxbiWdzUf
jBCx250LgUCOs6frnNhLRNpG9m31KeL/a3VV9EvvHUEhBg8oL94Qw52nAj+Uf1QM
JlaXLUToAuN3CweKAcoqtWk10ShO/butXqNOZGjgnBd3o0qu8W/wlJJrnBVcqLTo
+c8bR4O90suctsYSsumiaQynQdYIZT6gS8VR0s7/cGa2qc+HBOzgj7rJCPHMZo3h
/h886hMoUpJspy4rNOMum9Ou8QmBpyeBpr7e7yVj5RCl9QX2aSpQR2Avt6K6Aqhq
vt2hwFnqV2Yh6gB4fgB66qRjAEDB4tyYEnKD0wclBbjKB/nGE2S58eePVTk5r1Pa
NgKBd3gEa5IbzA1pZUd84OeOwh4FMjj8jqgVLWax7EX5dSwXWwH3q1VEk3Foo072
1EFSagsKLWIC1bkU7kMCS52FkfAMTqMK2s3PGRsWgO5X7T7bMMjxhpj2iurNW/P7
PQzTjJD9s8C7dnH7PzpKgWMd1t8F6RLfv7c86ZBAEAsKSfwYKmygzwXldUDm0m0U
unAoA4sIsJv09Ywy6/2Ow2daTnqv2zp5/u6Ui3t7mLOH7ZKcEXXFzOvYU8rBy+zG
dY3ayEeCH2BuraK5Xr6+
=9Jc8
-----END PGP SIGNATURE-----

--nextPart2598015.VZ1nIrqhte--

