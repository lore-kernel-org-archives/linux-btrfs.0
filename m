Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:33155 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbeHQHgq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 03:36:46 -0400
Subject: Re: btrfsck out of memory for big fs
To: "litaibaichina@gmail.com" <litaibaichina@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <201808171044160880896@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <64a443c8-a041-ad07-3f16-2de616580a67@gmx.com>
Date: Fri, 17 Aug 2018 12:34:47 +0800
MIME-Version: 1.0
In-Reply-To: <201808171044160880896@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mJrdFyRvY4bxV1ESbgMlsbcYAurZyG6CU"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mJrdFyRvY4bxV1ESbgMlsbcYAurZyG6CU
Content-Type: multipart/mixed; boundary="vCW3tch7FOoNmuoyzNkPOlApXMXSn9uwv";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "litaibaichina@gmail.com" <litaibaichina@gmail.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <64a443c8-a041-ad07-3f16-2de616580a67@gmx.com>
Subject: Re: btrfsck out of memory for big fs
References: <201808171044160880896@gmail.com>
In-Reply-To: <201808171044160880896@gmail.com>

--vCW3tch7FOoNmuoyzNkPOlApXMXSn9uwv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/17 =E4=B8=8A=E5=8D=8810:44, litaibaichina@gmail.com wrote:
> Hi Guys,
>=20
> I had a big btrfs on a md device, =C2=A0it be mounted , but after a whi=
le it will become ready only:
> # btrfs fi df /data/
> Data, single: total=3D24.46TiB, used=3D24.46TiB
> System, DUP: total=3D8.00MiB, used=3D2.59MiB
> System, single: total=3D4.00MiB, used=3D0.00B
> Metadata, DUP: total=3D81.00GiB, used=3D79.71GiB
> Metadata, single: total=3D8.00MiB, used=3D0.00B
> GlobalReserve, single: total=3D512.00MiB, used=3D264.28MiB
>=20
> # dmesg -T
> [Thu Aug 16 18:16:31 2018] BTRFS error (device md127): parent transid v=
erify failed on 26603622694912 wanted 185320 found 207817
> [Thu Aug 16 18:16:31 2018] BTRFS error (device md127): parent transid v=
erify failed on 26603622694912 wanted 185320 found 207817

Transaction id mismatch, normally this means some of the fs is already
corrupted before.

And considering the transid gap, the corruption happened quite a long
time ago.

> [Thu Aug 16 18:16:31 2018] BTRFS warning (device md127): Skipping commi=
t of aborted transaction.
> [Thu Aug 16 18:16:31 2018] BTRFS: error (device md127) in cleanup_trans=
action:1864: errno=3D-5 IO failure
> [Thu Aug 16 18:16:31 2018] BTRFS info (device md127): forced readonly
> [Thu Aug 16 18:16:31 2018] BTRFS info (device md127): delayed_refs has =
NO entry
>=20
> I want to use btrfsck to check it, =C2=A0but it will OOM :
> # btrfsck /dev/md127
> Checking filesystem on /dev/md127
> UUID: 6b87a52f-9a5f-4d03-b345-9d954c2ce259
> checking extents
> Killed
>=20
> I am trying to use lowmem mode, =C2=A0but as I tried before, it may OOM=
 too, =C2=A0 =C2=A0any ideas ?

This depends on which version you tried before.

Lowmem mode used to do partial lowmem and partial normal mode check, and
normal mode caused the OOM.

Latest lowmem mode should not cause OOM, but please ger ready for the
super long run time.

Thanks,
Qu
>=20
> Thanks.
>=20


--vCW3tch7FOoNmuoyzNkPOlApXMXSn9uwv--

--mJrdFyRvY4bxV1ESbgMlsbcYAurZyG6CU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt2UGcACgkQwj2R86El
/qgNXQf9F9gEwQZG8NdF1txP1WkNoIpSdUM59uCOftLnXbZ4yW/fdvPacDYIKeKI
KkxggLM2ZDWNpsW4rfFixAhFXwsOJqUTeHXtaORevFNV9S/uyL/aPFBsI1wSskmd
QxOL7Mzi2zPhQXCRKx4RZBIkJ3XZXgiV2mflh2jd/vBpa9R7emog9erMieQVelvJ
nLikHvMp+zL8IinBd7A4GRmv4EAKdhVA1DwIlqkTIsrHTlW00qxIBRSPu7WX2Z0o
jhXYcFk4b5I7fO+41d3PenSx9Jd3fIc/KHsgVINRxvaNzaUXjD53M5EVQFIEK2wK
GXTsJnWkuJMSrdpSMxPwkRRbfWdkfQ==
=OKPh
-----END PGP SIGNATURE-----

--mJrdFyRvY4bxV1ESbgMlsbcYAurZyG6CU--
