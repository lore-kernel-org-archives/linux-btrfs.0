Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55347 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751570AbdLEIoA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 03:44:00 -0500
Subject: Re: [RFC] Improve subvolume usability for a normal user
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3934c7d3-b601-bbba-5d16-5c3ef9bb527a@gmx.com>
Date: Tue, 5 Dec 2017 16:43:49 +0800
MIME-Version: 1.0
In-Reply-To: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5lF6UtgHJw2bJaKVqbgoubTTvBFGpRUOE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5lF6UtgHJw2bJaKVqbgoubTTvBFGpRUOE
Content-Type: multipart/mixed; boundary="b5CImfr6eTbRk7wijIltPuSOvhEMOx9uu";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <3934c7d3-b601-bbba-5d16-5c3ef9bb527a@gmx.com>
Subject: Re: [RFC] Improve subvolume usability for a normal user
References: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
In-Reply-To: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>

--b5CImfr6eTbRk7wijIltPuSOvhEMOx9uu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8805=E6=97=A5 16:25, Misono, Tomohiro wrote:
> Hello all,
>=20
> I want to address some issues of subvolume usability for a normal user.=

> i.e. a user can create subvolumes, but
>  - Cannot delete their own subvolume (by default)
>  - Cannot tell subvolumes from directories (in a straightforward way)
>  - Cannot check the quota limit when qgroup is enabled
>=20
> Here I show the initial thoughts and approaches to this problem.
> I want to check if this is a right approach or not before I start writi=
ng code.
>=20
> Comments are welcome.
> Tomohiro Misono
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> - Goal and current problem
> The goal of this RFC is to give a normal user more control to their own=
 subvolumes.
> Currently the control to subvolumes for a normal user is restricted as =
below:=20
>=20
> +-------------+------+------+
> |   command   | root | user |
> +-------------+------+------+
> | sub create  | Y    | Y    |
> | sub snap    | Y    | Y    |
> | sub del     | Y    | N    |
> | sub list    | Y    | N    |
> | sub show    | Y    | N    |
> | qgroup show | Y    | N    |
> +-------------+------+------+
>=20
> In short, I want to change this as below in order to improve user's usa=
bility:
>=20
> +-------------+------+--------+
> |   command   | root | user   |
> +-------------+------+--------+
> | sub create  | Y    | Y      |
> | sub snap    | Y    | Y      |
> | sub del     | Y    | N -> Y |
> | sub list    | Y    | N -> Y |
> | sub show    | Y    | N -> Y |
> | qgroup show | Y    | N -> Y |
> +-------------+------+--------+
>=20
> In words,
> (1) allow deletion of subvolume if a user owns it, and=20
> (2) allow getting subvolume/quota info if a user has read access to it
>  (sub list/qgroup show just lists the subvolumes which are readable by =
the user)
>=20
> I think other commands not listed above (qgroup limit, send/receive etc=
=2E) should
> be done by root and not be allowed for a normal user.
>=20
>=20
> - Outside the scope of this RFC
> There is a qualitative problem to use qgroup for limiting user disk amo=
unt;
> quota limit can easily be averted by creating a subvolume. I think that=
 forcing
> inheriting quota of parent subvolume is a solution, but I won't address=
 nor
> discuss this here.=20
>=20
>=20
> - Proposal
>  (1) deletion of subvolume
>=20
>   I want to change the default behavior to allow a user to delete their=
 own
>   subvolumes.
>  =20
>   This is not the same behavior as when user_subvol_rm_alowed mount opt=
ion is
>   specified; in that case a user can delete the subvolume to which they=
 have
>   write+exec right.
>  =20
>   Since snapshot creation is already restricted to the subvolume owner,=
 it is
>   consistent that only the owner of the subvolume (or root) can delete =
it.
>  =20
>   The implementation should be straightforward.

Personally speaking, I prefer to do the complex owner check in user daemo=
n.

And do the privilege in user daemon (call it btrfsd for example).

So btrfs-progs will works in 2 modes, if root calls it, do as it used to =
do.
If normal user calls it, proxy the request to btrfsd, and btrfsd does
the privilege checking and call ioctl (with root privilege).

Then no impact to kernel, all complex work is done in user space.

>=20
>  (2) getting subvolume/quota info
>=20
>   TREE_SEARCH ioctl is used to retrieve the subvolume/quota info by btr=
fs-progs
>   (sub show/list, qgroup show etc.). This requires the root permission.=

>  =20
>   The easiest way to allow a user to get subvolume/quota info is just r=
elaxing
>   the permission of TREE_SEARCH. However, since all the tree informatio=
n (inc.
>   file name) will be exposed, this poses a sequrity risk and is not acc=
eptable.
>  =20
>   So, I want to introduce 2 ioctls to get subvolume/quota info respecti=
vely for
>   a normal user, which return only the info readable by the user:
>  =20
>    [subvolume info]
>     Mainly search ROOT tree for ROOT_ITEM/ROOT_BACKREF, but check its r=
ead
>    right by searching FS/FILE tree and comparing it with caller's uid.
>  =20
>    [quota info]
>     Same as above, but mainly search QUOTA tree and only returns level =
0 info.
>  =20
>   Also, in order to construct subvolume path, permission of INO_LOOKUP =
ioctl
>   needs to be relaxed for the user who has read access to the subvolume=
=2E

Same method can apply to this either.

Thanks,
Qu
>=20
>=20
> - Summary of Proposal
>  - Change the default behavior to allow a user to delete their own subv=
olumes
>  - Add 2 new non-root ioctls to get subvolume/quota info for accessible=
 subvolumes
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--b5CImfr6eTbRk7wijIltPuSOvhEMOx9uu--

--5lF6UtgHJw2bJaKVqbgoubTTvBFGpRUOE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlomXEUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgajgf/Y0B5b/l7xtdEH0qwK3FIKLSn
7DllCqvMBpcGsOazhJKD5syNKbYWyWV3VzjZKKXNyHhuDVlHyULRSJlIIN2LTDHA
UCMcQ1uPIU9dTkFcPjKqhwebS/gADPgb4IEwU58CNzsnU7gJT+WhYhTifYIACdPo
2NbtY5VRuikG+7/7nKsWWaO7/Sp1h55j1XQdQNKwz+5K8ZhuQ64eIqwBzxpi5ZGw
8tQE4msUiSyAoCZvrkFc6GR5l3cS/3Eu5tbKK8W08ep6t+6SHB+EhelL45p/wWML
W/8boHj+IxHdld9u4gMJCjsIxcLcLfCRktK5tyoFoto/3DqZV+8D+Qs0Fmhwug==
=hFI9
-----END PGP SIGNATURE-----

--5lF6UtgHJw2bJaKVqbgoubTTvBFGpRUOE--
