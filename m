Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:37309 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751409AbeEQG44 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 02:56:56 -0400
Subject: Re: [PATCH v5 0/3] btrfs: Add three new unprivileged ioctls to allow
 normal users to call "sub list/show" etc.
To: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1526446338.git.misono.tomohiro@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1de3700b-47ef-979a-3c72-8897601b2214@gmx.com>
Date: Thu, 17 May 2018 14:56:45 +0800
MIME-Version: 1.0
In-Reply-To: <cover.1526446338.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mPwCWBTHc76umHybKU6vXIkDw3doIa9dO"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mPwCWBTHc76umHybKU6vXIkDw3doIa9dO
Content-Type: multipart/mixed; boundary="KEmRhb2vLx5xN0tf1fZVNATk2rxfsTSgB";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <1de3700b-47ef-979a-3c72-8897601b2214@gmx.com>
Subject: Re: [PATCH v5 0/3] btrfs: Add three new unprivileged ioctls to allow
 normal users to call "sub list/show" etc.
References: <cover.1526446338.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1526446338.git.misono.tomohiro@jp.fujitsu.com>

--KEmRhb2vLx5xN0tf1fZVNATk2rxfsTSgB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8816=E6=97=A5 13:49, Tomohiro Misono wrote:
> [based on current misc-next]
>=20
> changelog:
> v4 -> v5
>   - Update error handling of 1st/2nd patch. See each log for details
>   - Fix misspelling
> v3 -> v4
>   - call btrfs_next_leaf() after btrfs_search_slot() when the slot
>     position exceeds the number of items
>   - rebased to current misc-next
> v2 -> v3
>   - fix kbuild test bot warning
> v1 -> v2
>   - completely reimplement 1st/2nd ioctl to have user friendly api
>   - various cleanup, remove unnecessary goto
> =3D=3D=3D
>=20
> This adds three new unprivileged ioctls:
>=20
> 1st patch:
>   ioctl which returns subvolume information of ROOT_ITEM and ROOT_BACKR=
EF
> 2nd patch:
>   ioctl which returns subvolume information of ROOT_REF (without subvol=
ume name)

First 2 patches looks mostly fine.

> 3rd patch:=20
>   user version of ino_lookup ioctl which also performs permission check=
=2E

I'm a little concerned about this.

What will happen in the following scenario?
- Environment is container whose rootfs is a subvolume of btrfs
- The root and normal use try to call subvolume list on their rootfs

Will it leak the real subvolume layout to the container root/normal user?=


Or it will leak anyway even without the unprivileged ioctl?

Thanks,
Qu

>=20
> They will be used to implement user version of "subvolume list/show" et=
c.
> in user tools.
> See each commit log for more detals.
>=20
> The implementation of btrfs-progs can be found in the ML titled as foll=
ows:=20
>   [PATCH 0/11] btrfs-progs: Rework of "subvolume list/show" and relax t=
he root privileges of them
>=20
> Tomohiro Misono (3):
>   btrfs: Add unprivileged ioctl which returns subvolume information
>   btrfs: Add unprivileged ioctl which returns subvolume's ROOT_REF
>   btrfs: Add unprivileged version of ino_lookup ioctl
>=20
>  fs/btrfs/ioctl.c           | 452 +++++++++++++++++++++++++++++++++++++=
++++++++
>  include/uapi/linux/btrfs.h |  84 +++++++++
>  2 files changed, 536 insertions(+)
>=20


--KEmRhb2vLx5xN0tf1fZVNATk2rxfsTSgB--

--mPwCWBTHc76umHybKU6vXIkDw3doIa9dO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr9J60ACgkQwj2R86El
/qhQyAf/aRxfnzhkBJ5uv/4C4WFLH3w3nqW75iIx4oyhcwXuRoFKGfs/JdQ9R+YW
RcJNWK12POcjAtUTGz+roKYtHqxOX1I+yLTN0JY4ddDR0qaUih7Ci6A5spsj0Fmt
si843Bx6e0QfC9Q0baeRGH2M0hMH0UdSU0BgtX8fczhRqbq5vw9lhcBiWe4vblOh
AG3IFmaHstLs5LMHQJngWnpWJtJjKwyzCjLl1wwjr0itbEqdZU0rE5HU2jJilrJF
57wuCBzT7ahz6bc793xravfSfvsRv9Rb56B3BVdEGG0OxszPmIZVu+wCOgDZ/TKQ
mcO0tprwNRtTTktzv+1nYF6q6GAJ0g==
=ptPq
-----END PGP SIGNATURE-----

--mPwCWBTHc76umHybKU6vXIkDw3doIa9dO--
