Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58587 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729852AbeGZNsr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 09:48:47 -0400
Subject: Re: [PATCH] btrfs: qgroup: Auto kick in rescan if qgroup tree is
 initialized without rescan initialized
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180726065900.8469-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <aea075b8-c7a6-7098-2f18-f57403737140@gmx.com>
Date: Thu, 26 Jul 2018 20:31:55 +0800
MIME-Version: 1.0
In-Reply-To: <20180726065900.8469-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6SNVugc85yTzYUgUTEATQ3siHNH6OUuzL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6SNVugc85yTzYUgUTEATQ3siHNH6OUuzL
Content-Type: multipart/mixed; boundary="lJRmKCd6GNI3NX0G1TNaEVovo7qkOVTya";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <aea075b8-c7a6-7098-2f18-f57403737140@gmx.com>
Subject: Re: [PATCH] btrfs: qgroup: Auto kick in rescan if qgroup tree is
 initialized without rescan initialized
References: <20180726065900.8469-1-wqu@suse.com>
In-Reply-To: <20180726065900.8469-1-wqu@suse.com>

--lJRmKCd6GNI3NX0G1TNaEVovo7qkOVTya
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8826=E6=97=A5 14:59, Qu Wenruo wrote:
> Under certain case, btrfs/166 could cause power loss just after quota
> tree initialized but rescan not kicked in.
>=20
> In this case, since flags of qgroup status item is just ON |
> INCONSISTENT, without RESCAN flag, rescan won't be kicked in in next
> mount.
>=20
> Now kick in rescan automatically for such situation, so user won't need=

> to do rescan manually.

Please ignore this patch, as just suggested by Misono, it's addressed by
later patch "btrfs: qgroup: Init flags with RESCAN bit at quota enable
time".

Thanks,
Qu

>=20
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index c25dc47210a3..e62598fc354f 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -392,6 +392,17 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info =
*fs_info)
>  			fs_info->qgroup_flags =3D btrfs_qgroup_status_flags(l,
>  									  ptr);
>  			rescan_progress =3D btrfs_qgroup_status_rescan(l, ptr);
> +
> +			/*
> +			 * Qgroup is enabled but rescan hans't kicked in and
> +			 * power loss happened, kick rescan in
> +			 */
> +			if (rescan_progress =3D=3D 0 &&
> +			    (BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT |
> +			     BTRFS_QGROUP_STATUS_FLAG_ON) =3D=3D
> +			    fs_info->qgroup_flags)
> +				fs_info->qgroup_flags |=3D
> +					BTRFS_QGROUP_STATUS_FLAG_RESCAN;
>  			goto next1;
>  		}
> =20
>=20


--lJRmKCd6GNI3NX0G1TNaEVovo7qkOVTya--

--6SNVugc85yTzYUgUTEATQ3siHNH6OUuzL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltZvzwACgkQwj2R86El
/qjnSgf/UNGd0C2k7kv13bcV/yuOrFxNNqVJYSiOlYOXDBhM9wHbwiBouLpF4OmD
xRrkJvzIWAUoE9HlUZisQy0SlTymFtHhlFwKapdv8tnk1rmTEr+6E6OdFcZq/td2
aETdUSlYuqjwCV9VIqtYh2cSypRZNhka0TjSMMI818HpOdGd90XgEJuBmnIniBW9
Xo+ItOI0ND5CCZTPXhPlWVEcOJR2Nb/+Od/GGtFMF0rN9uDZKEdHZKSIlE5F/3Hp
UGpnMAiUUbpveceQuqVHxdzun9h+S2escLSLxg9+KreJYvDzq3O6ymtGqw+26Cdz
rkfAsySD1Ekxw1N2Lp0LCZwlDW7d4Q==
=PV/d
-----END PGP SIGNATURE-----

--6SNVugc85yTzYUgUTEATQ3siHNH6OUuzL--
