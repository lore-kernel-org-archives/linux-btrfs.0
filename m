Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:50780 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757754AbdLRBKT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Dec 2017 20:10:19 -0500
Subject: Re: How to repair errors only found with check --mode=lowmem
To: Tom Hale <tom@hale.ee>, linux-btrfs@vger.kernel.org
References: <abb41cea-93eb-0e35-e9b2-195968fc4fd7@hale.ee>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <19de77b6-0017-d172-993a-438d8bc9023d@gmx.com>
Date: Mon, 18 Dec 2017 09:10:10 +0800
MIME-Version: 1.0
In-Reply-To: <abb41cea-93eb-0e35-e9b2-195968fc4fd7@hale.ee>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9R1NoabBIXpQ597U3G0lTfChoHRSOAc6b"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9R1NoabBIXpQ597U3G0lTfChoHRSOAc6b
Content-Type: multipart/mixed; boundary="K8JKWIf6vOvD9H2WkNsHCdhgxX9kTtekg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tom Hale <tom@hale.ee>, linux-btrfs@vger.kernel.org
Message-ID: <19de77b6-0017-d172-993a-438d8bc9023d@gmx.com>
Subject: Re: How to repair errors only found with check --mode=lowmem
References: <abb41cea-93eb-0e35-e9b2-195968fc4fd7@hale.ee>
In-Reply-To: <abb41cea-93eb-0e35-e9b2-195968fc4fd7@hale.ee>

--K8JKWIf6vOvD9H2WkNsHCdhgxX9kTtekg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8816=E6=97=A5 23:41, Tom Hale wrote:
> The following shows that errors are found with check --mode=3Dlowmem, b=
ut
> are not picked up without lowmem.

Btrfs-progs version please.

Depending on your btrfs-progs version, and the output, it's possible
that they're just false alerts and should be addressed in latest version.=


Thanks,
Qu

>=20
> How would I go about fixing errors only reported by lowmem?
>=20
> ----------------------------------------
>=20
> [manjaro manjaro]# btrfs check --mode=3Dlowmem --progress
> /dev/mapper/vg_svelte-home
> Checking filesystem on /dev/mapper/vg_svelte-home
> UUID: 93722fa7-7e8f-418a-a7ca-080aca8db94b
> ERROR: extent[691815358464, 11042816] referencer count mismatch (root:
> 257, owner: 1869679, offset: 613974016) wanted: 1, have: 2
> ERROR: extent[720156536832, 99430400] referencer count mismatch (root:
> 257, owner: 758215, offset: 1610616832) wanted: 8, have: 379
> ERROR: extent[720669147136, 268435456] referencer count mismatch (root:=

> 257, owner: 758215, offset: 4096) wanted: 86, have: 1021
> ERROR: extent[720669147136, 268435456] referencer count mismatch (root:=

> 257, owner: 1767807, offset: 4096) wanted: 87, have: 1021
> ERROR: extent[726724722688, 64069632] referencer count mismatch (root:
> 257, owner: 1480823, offset: 99090432) wanted: 1, have: 5
> ERROR: extent[737910194176, 134217728] referencer count mismatch (root:=

> 257, owner: 1480726, offset: 268435456) wanted: 1, have: 8
> ERROR: extent[738077896704, 134217728] referencer count mismatch (root:=

> 257, owner: 1869696, offset: 402653184) wanted: 5, have: 8
> ERROR: extent[744334426112, 268435456] referencer count mismatch (root:=

> 257, owner: 1767802, offset: 0) wanted: 111, have: 294
> ERROR: extent[824948670464, 1671168] referencer count mismatch (root:
> 257, owner: 2000876, offset: 247861248) wanted: 16, have: 26
> ERROR: data extent[681550843904 8192] backref lost
> ERROR: errors found in extent allocation tree or chunk allocation
> cache and super generation don't match, space cache will be invalidated=

> ERROR: errors found in fs roots
> found 172094545920 bytes used, error(s) found
> total csum bytes: 165679768
> total tree bytes: 3066789888
> total fs tree bytes: 2751315968
> total extent tree bytes: 112295936
> btree space waste bytes: 568660274
> file data blocks allocated: 8158426562560
> =C2=A0referenced 597269540864
> [manjaro manjaro]# btrfs check --repair=C2=A0 --progress
> /dev/mapper/vg_svelte-home
> enabling repair mode
> Checking filesystem on /dev/mapper/vg_svelte-home
> UUID: 93722fa7-7e8f-418a-a7ca-080aca8db94b
> checking extents [.]
> Fixed 0 roots.
> cache and super generation don't match, space cache will be invalidated=

> checking fs roots [o]
> checking csums
> checking root refs
> found 172091723777 bytes used, no error found
> total csum bytes: 165679768
> total tree bytes: 2003206144
> total fs tree bytes: 1687732224
> total extent tree bytes: 112295936
> btree space waste bytes: 346177995
> file data blocks allocated: 5952940838912
> =C2=A0referenced 474676633600
> [manjaro manjaro]#
>=20
> ----------------------------------------
>=20


--K8JKWIf6vOvD9H2WkNsHCdhgxX9kTtekg--

--9R1NoabBIXpQ597U3G0lTfChoHRSOAc6b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlo3FXIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qie2Qf+Jf3Hy1zaRd5/FHaaN5qATuGX
pTnfOQysvYQoiEUIyKmCvsuILuw0vqti5Qiq5QMQQGcrQyRaTXSTWHAQEZQ8lVgz
hlXtChFJIdcn2g78SV+rH56vEwnmABxI0W0glDnLThsBGOpesNVGQLKNL7waisLN
j8QV3QzBnl0ipIe5uZBugwpt6NOckgLt2V2mlGSjfRwxQW8E35tMBmpQhlunC/f0
30wkGMWrx3wQjuzNg1sIw3jDrAcLneX0ZvIL+EzB5CRd+m+fr5Y6k41RaGd+Xsck
qklp6FTD1IhMPeTCfG/WDqSFGuIHKIeWhf6OvhbpRal1l254DbWHxB3F09rSJg==
=+tUD
-----END PGP SIGNATURE-----

--9R1NoabBIXpQ597U3G0lTfChoHRSOAc6b--
