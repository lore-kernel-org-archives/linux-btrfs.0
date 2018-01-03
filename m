Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51645 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751274AbeACE63 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 23:58:29 -0500
Subject: Re: Kernel crash during btrfs scrub
To: Dmitry Katsubo <dma_k@mail.ru>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <3e11c358-c18d-684b-f5c7-a09f78bc7b07@mail.ru>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <dd8cc8ea-1a3d-ee75-ab75-0cc5802f33d4@gmx.com>
Date: Wed, 3 Jan 2018 12:58:23 +0800
MIME-Version: 1.0
In-Reply-To: <3e11c358-c18d-684b-f5c7-a09f78bc7b07@mail.ru>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="J0lV7l7kBLqr3Y2NjrRVvBbHwzh5V6QJr"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--J0lV7l7kBLqr3Y2NjrRVvBbHwzh5V6QJr
Content-Type: multipart/mixed; boundary="F7pNWttps6va5vqQWxrFOYzVCQwfMET3w";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dmitry Katsubo <dma_k@mail.ru>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <dd8cc8ea-1a3d-ee75-ab75-0cc5802f33d4@gmx.com>
Subject: Re: Kernel crash during btrfs scrub
References: <3e11c358-c18d-684b-f5c7-a09f78bc7b07@mail.ru>
In-Reply-To: <3e11c358-c18d-684b-f5c7-a09f78bc7b07@mail.ru>

--F7pNWttps6va5vqQWxrFOYzVCQwfMET3w
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8803=E6=97=A5 09:12, Dmitry Katsubo wrote:
> Dear btrfs team,
>=20
> I send a kernel crash report which I have observed recently during btrf=
s scrub.
> It looks like scrub itself has completed without errors.
>=20
> # btrfs scrub status /home
> scrub status for 83a3cb60-3334-4d11-9fdf-70b8e8703167
>         scrub started at Mon Jan  1 06:52:01 2018 and finished after 00=
:30:47
>         total bytes scrubbed: 87.55GiB with 0 errors
>=20
> # btrfs scrub status /var/log
> scrub status for 5b45ac8e-fd8c-4759-854a-94e45069959d
>         scrub started at Mon Jan  1 06:52:01 2018 and finished after 00=
:15:45
>         total bytes scrubbed: 23.39GiB with 0 errors
>=20
> Linux kernel v4.14.2-1
> btrfs-progs v4.7.3-1
>=20

It's not a kernel crash (if I didn't miss anything), but just kernel
warning.

The warning is caused by the fact that your fs (mostly created by old
mkfs.btrfs) has device with unaligned size.

You could either resize the device down a little (e.g. -4K) and newer
kernel (the one you're using should be new enough) could handle it well.

Or you could update your btrfs-progs (I assume you're using Arch, which
is already shipping btrfs-progs v4.14) and use "btrfs rescue
fix-device-size" to fix other device related problems offline.
(Not only the warning, but also potential superblock size mismatch)

Thanks,
Qu


--F7pNWttps6va5vqQWxrFOYzVCQwfMET3w--

--J0lV7l7kBLqr3Y2NjrRVvBbHwzh5V6QJr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpMYu8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qibbAf/adWCNT+42LF/BaMC9tSnAbjG
iotSKXJMP3ngmdV0TOdFHNGm88fy2MMrb0jmCl5VmtTDF2gwxWMkpT+nf3N39og8
2fL/uQPdKE6YH492UM5jrgjxXMVTlumkz8TqVmIbHCQbIkzh5Bu2MawEVnO/CHwL
7KsAR2oUhuXE7s5SphBrWF+HegnPmpWeul8cDh+FX/hC6QXb2U/FbadEIWU/rJTC
HamLftc/C4FJbTMB0Jt/wXMVqTbdp161TWseyG/Aq7KNg8VeVjCQNqlpICqV2g5j
deOvZ6IWKdxo6Ryn7tWA7GxD44V87mvdxCA4VlfhN44lWHo693dmxZE8j6daOw==
=lbOA
-----END PGP SIGNATURE-----

--J0lV7l7kBLqr3Y2NjrRVvBbHwzh5V6QJr--
