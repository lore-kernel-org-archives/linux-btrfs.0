Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:41361 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751934AbeEGLTw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 May 2018 07:19:52 -0400
Subject: Re: [PATCH] btrfs-progs: qgroup: swap the argument in the caller of
 update_qgroup_relation
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180507085027.23059-1-lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <985b33f2-ea6f-aa25-493a-5895cc2b8eb0@gmx.com>
Date: Mon, 7 May 2018 19:19:32 +0800
MIME-Version: 1.0
In-Reply-To: <20180507085027.23059-1-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DH8bJBhjK4b5RuYenq0k3zAJHjOWNvfi4"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DH8bJBhjK4b5RuYenq0k3zAJHjOWNvfi4
Content-Type: multipart/mixed; boundary="FgXkd9bul5cdrjwCtjQrJz33IFYHuCFN9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <985b33f2-ea6f-aa25-493a-5895cc2b8eb0@gmx.com>
Subject: Re: [PATCH] btrfs-progs: qgroup: swap the argument in the caller of
 update_qgroup_relation
References: <20180507085027.23059-1-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180507085027.23059-1-lufq.fnst@cn.fujitsu.com>

--FgXkd9bul5cdrjwCtjQrJz33IFYHuCFN9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8807=E6=97=A5 16:50, Lu Fengqi wrote:
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
> ---
>  qgroup.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/qgroup.c b/qgroup.c
> index 11659e8394dd..e7e127daf5ce 100644
> --- a/qgroup.c
> +++ b/qgroup.c
> @@ -1122,11 +1122,16 @@ static int __qgroups_search(int fd, struct qgro=
up_lookup *qgroup_lookup)
>  				qgroupid =3D btrfs_search_header_offset(sh);
>  				qgroupid1 =3D btrfs_search_header_objectid(sh);
> =20
> -				if (qgroupid < qgroupid1)
> +				if (qgroupid <=3D qgroupid1)
>  					break;
> =20
> +				/*
> +				 * because of qgroupid > qgroupid1, qgroupid is
> +				 * the id of parent, and qgroupid1 is the id of
> +				 * child.
> +				 */

Instead of such comment, renaming @qgroupid to @parent, and @qgroupid1
to @child makes more sense.

And a test case would definitely help in this case.

Thanks,
Qu

>  				ret =3D update_qgroup_relation(qgroup_lookup,
> -							qgroupid, qgroupid1);
> +							qgroupid1, qgroupid);
>  				break;
>  			default:
>  				return ret;
>=20


--FgXkd9bul5cdrjwCtjQrJz33IFYHuCFN9--

--DH8bJBhjK4b5RuYenq0k3zAJHjOWNvfi4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrwNkUACgkQwj2R86El
/qhozggArv+AAzPHWnT/q1PI6HJc75uOqZThShJwVaIsD4jWA6ng5A9ugKJJnYvH
QkdykI/o0yRZAJFbZbZw8Vup9qF9CKb8mtHszD9BZw86GvLPWgkYxyiIt0zVXAab
h98DNpwpvxb0ok87v/HuUCFTrNEzMHoStvMd+pjIqPa+HFNd/CxCgcBWxM2IV6Kf
Ws09oc8XCrTfiRHNAwW7UbbN1VlNKS+jT/FG+wTXy55daSa87bdGrCWACP6sfbtD
CFmbJ4K5YFLDUgszji7VBvjag81KAk7Zd8CAQ1QNzlnsnYO9mP3ku9w7fbV9iHoM
0Dfgy291l3RSOf3uSrml6CrKaBPMgg==
=rb30
-----END PGP SIGNATURE-----

--DH8bJBhjK4b5RuYenq0k3zAJHjOWNvfi4--
