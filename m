Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54916 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751101AbdKTCNk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Nov 2017 21:13:40 -0500
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com>
Date: Mon, 20 Nov 2017 10:13:34 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vUJr049l2Tn89UundBmjehKuNN6DF0qqn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vUJr049l2Tn89UundBmjehKuNN6DF0qqn
Content-Type: multipart/mixed; boundary="lSmxgs0owpQ0D7jEhcQNL5EKmKkNvJoCf";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
In-Reply-To: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>

--lSmxgs0owpQ0D7jEhcQNL5EKmKkNvJoCf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8819=E6=97=A5 14:17, Chris Murphy wrote:
> fstrim should trim free space, but it only trims unallocated. This is
> with kernel 4.14.0 and the entire 4.13 series. I'm pretty sure it
> behaved this way with 4.12 also.

Tested with 4.14-rc7, can't reproduce it.
------
# btrfs fi us /mnt/btrfs/
Overall:
    Device size:		   1.00GiB
    Device allocated:		 566.38MiB
    Device unallocated:		 457.62MiB
    Device missing:		     0.00B
    Used:			 256.81MiB
    Free (estimated):		 649.62MiB	(min: 420.81MiB)
    Data ratio:			      1.00
    Metadata ratio:		      2.00
    Global reserve:		  16.00MiB	(used: 0.00B)

Data,single: Size:448.00MiB, Used:256.00MiB
   /dev/loop0	 448.00MiB

Metadata,DUP: Size:51.19MiB, Used:400.00KiB
   /dev/loop0	 102.38MiB

System,DUP: Size:8.00MiB, Used:16.00KiB
   /dev/loop0	  16.00MiB

Unallocated:
   /dev/loop0	 457.62MiB

# fstrim  /mnt/btrfs -v
/mnt/btrfs: 665.3 MiB (697597952 bytes) trimmed
------


Any special mount options or setup?
(BTW, I also tried space_cache=3Dv2 and default v1, no obvious difference=
)

Thanks,
Qu

>=20
>=20
> [root@f27h ~]# fstrim -v /
> /: 39 GiB (41841328128 bytes) trimmed
> [root@f27h ~]# btrfs fi us /
> Overall:
>     Device size:          70.00GiB
>     Device allocated:          31.03GiB
>     Device unallocated:          38.97GiB
>     Device missing:             0.00B
>     Used:              22.02GiB
>     Free (estimated):          47.72GiB    (min: 47.72GiB)
>     Data ratio:                  1.00
>     Metadata ratio:              1.00
>     Global reserve:          65.97MiB    (used: 0.00B)
>=20
> Data,single: Size:30.00GiB, Used:21.25GiB
>    /dev/nvme0n1p8      30.00GiB
>=20
> Metadata,single: Size:1.00GiB, Used:791.58MiB
>    /dev/nvme0n1p8       1.00GiB
>=20
> System,single: Size:32.00MiB, Used:16.00KiB
>    /dev/nvme0n1p8      32.00MiB
>=20
> Unallocated:
>    /dev/nvme0n1p8      38.97GiB
>=20
>=20


--lSmxgs0owpQ0D7jEhcQNL5EKmKkNvJoCf--

--vUJr049l2Tn89UundBmjehKuNN6DF0qqn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloSOk4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjnmgf/Ya0N+Nsxyyszv4bzJStIURSH
C0Kp9pcGdMs4+3UfTamL5Jhfj0Y8njN4YBKAP+OnRvjtrE1LCoP4ge2vt48FRuA0
/Y95GtGhEGgb0rCkdsIZkjVeuI+FUk+uHldoo5hRu7LvrMGFKo90xQSaw2VFHax7
vl+vtXe+nkAEdj0dKRhIYMwlm4SPmYPRpVALtwDVtNWWaz0dr8N5gWlq+xWXuJRK
ZPoBIF80Hrk4wTyKElW5ZudJDoj3ZcQb9OfphtredfBSjLD43PpFClJUnDemX2I+
3tD/UzMSbW1cBQHpfczSVVZ4uPj95GRfXq8P8uEOSKTWpu2z2adX90FtkSkcwA==
=dU+k
-----END PGP SIGNATURE-----

--vUJr049l2Tn89UundBmjehKuNN6DF0qqn--
