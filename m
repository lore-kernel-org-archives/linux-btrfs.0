Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49453 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752546AbeEHFz4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 01:55:56 -0400
Subject: Re: [PATCH v2 1/2] btrfs-progs: qgroup: swap the argument in the
 caller of update_qgroup_relation
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180508054803.20851-1-lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <66de6183-f44b-befa-bcd1-c583437fdccf@gmx.com>
Date: Tue, 8 May 2018 13:55:32 +0800
MIME-Version: 1.0
In-Reply-To: <20180508054803.20851-1-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="u9bGLtD6o0txuTMqUk9lfAjlXjm7UCwrT"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--u9bGLtD6o0txuTMqUk9lfAjlXjm7UCwrT
Content-Type: multipart/mixed; boundary="RorQFRt0iybaeXDftcdIo6lxm3qmS28hg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <66de6183-f44b-befa-bcd1-c583437fdccf@gmx.com>
Subject: Re: [PATCH v2 1/2] btrfs-progs: qgroup: swap the argument in the
 caller of update_qgroup_relation
References: <20180508054803.20851-1-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180508054803.20851-1-lufq.fnst@cn.fujitsu.com>

--RorQFRt0iybaeXDftcdIo6lxm3qmS28hg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8808=E6=97=A5 13:48, Lu Fengqi wrote:
> The QGROUP_RELATION item is very special, it always exists in pairs
> (objectid and offset exchange). Its objectid and offset are the ids of =
a
> pair of parent and child qgroups, respectively. The larger one is
> parent and the smaller one is child. After the following commit, the or=
der
> of the parameters is wrong and causes qgroup show to output the wrong
> qgroup parent-child relationship.
>=20
> Fixes: aaf2dac5ef37 ("btrfs-progs: qgroup: split update_qgroup to reduc=
e arguments")
> Issue: #129
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> V2: Rename variables instead of the comment to make it clear.
>=20
>  qgroup.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/qgroup.c b/qgroup.c
> index 11659e8394dd..267cd7f11a9c 100644
> --- a/qgroup.c
> +++ b/qgroup.c
> @@ -1051,7 +1051,7 @@ static int __qgroups_search(int fd, struct qgroup=
_lookup *qgroup_lookup)
>  	struct btrfs_qgroup_limit_item *limit;
>  	u64 flags;
>  	u64 qgroupid;
> -	u64 qgroupid1;
> +	u64 child, parent;
> =20
>  	memset(&args, 0, sizeof(args));
> =20
> @@ -1119,14 +1119,14 @@ static int __qgroups_search(int fd, struct qgro=
up_lookup *qgroup_lookup)
>  							  qgroupid, limit);
>  				break;
>  			case BTRFS_QGROUP_RELATION_KEY:
> -				qgroupid =3D btrfs_search_header_offset(sh);
> -				qgroupid1 =3D btrfs_search_header_objectid(sh);
> +				child =3D btrfs_search_header_offset(sh);
> +				parent =3D btrfs_search_header_objectid(sh);
> =20
> -				if (qgroupid < qgroupid1)
> +				if (parent <=3D child)
>  					break;
> =20
>  				ret =3D update_qgroup_relation(qgroup_lookup,
> -							qgroupid, qgroupid1);
> +							     child, parent);
>  				break;
>  			default:
>  				return ret;
>=20


--RorQFRt0iybaeXDftcdIo6lxm3qmS28hg--

--u9bGLtD6o0txuTMqUk9lfAjlXjm7UCwrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrxO9QACgkQwj2R86El
/qg/6wf9GH+3ylt74zGt+ilzhlM5/4OBBfiNkd0wF6BCHJTZIPfH47lskOohl7QK
s4I4z8A2OCfoq48u+MLEHM5UQcYSsUo6IGvYNo9s5vp9Pj0OWW+BMG7KuhQiVPOo
qFXFtaOWR3XoOPfCI46lmCEMTO7z/dfsubbiEOqWcGFop46Ggol23iygMxiuWcsb
LMFGYDRq/L5i+MoCdlQEfNhlAtMOoUuTfE+K4+xDLQG8mZKqHbN9yMCcH08wOXo6
58ilGOvCetawHe1T9eUndNljBSdi7IYqKbJUQgOb2Tu5T5ER/4VnEjiNRmnlrgkE
nwMmLTEG9Sl4d+fhF8JFlL2olHZUEg==
=XEXM
-----END PGP SIGNATURE-----

--u9bGLtD6o0txuTMqUk9lfAjlXjm7UCwrT--
