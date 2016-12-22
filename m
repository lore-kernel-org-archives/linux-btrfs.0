Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47799 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934851AbcLVOSr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 09:18:47 -0500
Subject: Re: [bug report] btrfs: root->fs_info cleanup, add fs_info
 convenience variables
To: Dan Carpenter <dan.carpenter@oracle.com>
References: <20161222125304.GA16117@elgon.mountain>
Cc: linux-btrfs@vger.kernel.org
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <1cfa2654-79c0-348b-d17c-f21bbb700a56@suse.com>
Date: Thu, 22 Dec 2016 09:18:40 -0500
MIME-Version: 1.0
In-Reply-To: <20161222125304.GA16117@elgon.mountain>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7lGBHOg9GbSrLw1h5igC4o3poKxoNk2ng"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7lGBHOg9GbSrLw1h5igC4o3poKxoNk2ng
Content-Type: multipart/mixed; boundary="JkBdb50949b2jmFp2NK1pDlIlAIjUFW7l";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <1cfa2654-79c0-348b-d17c-f21bbb700a56@suse.com>
Subject: Re: [bug report] btrfs: root->fs_info cleanup, add fs_info
 convenience variables
References: <20161222125304.GA16117@elgon.mountain>
In-Reply-To: <20161222125304.GA16117@elgon.mountain>

--JkBdb50949b2jmFp2NK1pDlIlAIjUFW7l
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/16 7:53 AM, Dan Carpenter wrote:
> Hello Jeff Mahoney,
>=20
> This is a semi-automatic email about new static checker warnings.

Hi Dan -

Thanks for the report.  We've already seen this one and the right fix is
to remove the checks in btrfs_get_name since exportfs won't pass
negative dentries.  The original reporter has submitted a patch for that.=


-Jeff

> The patch 0b246afa62b0: "btrfs: root->fs_info cleanup, add fs_info=20
> convenience variables" from Jun 22, 2016, leads to the following=20
> Smatch complaint:
>=20
> fs/btrfs/export.c:238 btrfs_get_name()
> 	 warn: variable dereferenced before check 'inode' (see line 226)
>=20
> fs/btrfs/export.c
>    225		struct inode *dir =3D d_inode(parent);
>    226		struct btrfs_fs_info *fs_info =3D btrfs_sb(inode->i_sb);
>                                                          ^^^^^^^^^^^
> Patch adds dereference.
>=20
>    227		struct btrfs_path *path;
>    228		struct btrfs_root *root =3D BTRFS_I(dir)->root;
>    229		struct btrfs_inode_ref *iref;
>    230		struct btrfs_root_ref *rref;
>    231		struct extent_buffer *leaf;
>    232		unsigned long name_ptr;
>    233		struct btrfs_key key;
>    234		int name_len;
>    235		int ret;
>    236		u64 ino;
>    237=09
>    238		if (!dir || !inode)
>                              ^^^^^
> Old code checked for NULL.
>=20
>    239			return -EINVAL;
>    240=09
>=20
> regards,
> dan carpenter
>=20


--=20
Jeff Mahoney
SUSE Labs


--JkBdb50949b2jmFp2NK1pDlIlAIjUFW7l--

--7lGBHOg9GbSrLw1h5igC4o3poKxoNk2ng
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJYW+DDAAoJEB57S2MheeWydYYQAMLjBuu/1RhwJZW7UMSaxIMt
iW1w40vZAHxIItFx/RXh4OcXmD+MPyOI1yTpBxDr9Y6ZZlGuV5WYPgYpT8L5jzw2
mw5Ib83rjdrB6UIoYc2pipAi1PTYZQRf3DYSNFcE8xfOqB/iTyYthTAQtcfgEimW
UKwz2AQN9F5ao4tY7H7UHHcb3ss2iM5Gk5ePRdaOpGssTac2Dsij3uRQERBFsb1G
rG74Jl1VWBK1dAFJK6j/I+jiXAX1EFB8Oo0X5uI1maqy1420UJnGqvpMgN8QYQGB
kq9vznKYAL7Tzii0EiWY13Ej4fktC4BOZQBHnD82e3lAyKDrcXVb9GO/jRZHwGhp
ih1UltpC2/6LA1Y0WuYoMyAYuISUdSwRqGGu3iqWabYsiE85D2c5+qWtUT1MaN7e
ONWh8CMh+7f+/22k8jdRgkSxGo5oWxTD1q4DXOFcGDxcACTQHGwgU6c8l9P1Lp1k
KciLYOAzn4V95oIQm85PUshvYXwkd4dqdUC6ThAmEybeEF9kGsOZIUHcIfeLfBmo
3KDG3+4UOJ5ijSORfTNk4vSAnS8/mAphsRWvKKD/j6vwY8mg6D/IWDgJAmyck68a
rAUDK5dKi5PMZiYAjEEcylJIYE2Lb2uMvLIl/Si8nq0rZ3QhRLEkiXyCm1cXcoJK
Abmg6/lGxfuOVzrBD7eQ
=Rs+d
-----END PGP SIGNATURE-----

--7lGBHOg9GbSrLw1h5igC4o3poKxoNk2ng--
