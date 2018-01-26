Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63562 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752919AbeAZJnp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 04:43:45 -0500
Subject: Re: [PATCH 06/15] btrfs-progs: lowmem check: let check_dir_item()
 return if repaired
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-7-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4eb72230-50aa-1bc3-2bbd-118b2e46ac33@gmx.com>
Date: Fri, 26 Jan 2018 17:43:38 +0800
MIME-Version: 1.0
In-Reply-To: <20180126083519.28373-7-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aDD9NEhvAuVsTzbOCnyBCCuxULDK8nSJa"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aDD9NEhvAuVsTzbOCnyBCCuxULDK8nSJa
Content-Type: multipart/mixed; boundary="u16VhokB8oDOUWReCtFT18FTwlp6afDmT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <4eb72230-50aa-1bc3-2bbd-118b2e46ac33@gmx.com>
Subject: Re: [PATCH 06/15] btrfs-progs: lowmem check: let check_dir_item()
 return if repaired
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-7-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-7-suy.fnst@cn.fujitsu.com>

--u16VhokB8oDOUWReCtFT18FTwlp6afDmT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 16:35, Su Yue wrote:
> If repair_dir_item deleted the item, goto last checked then returns
> instead of searching di_key again then returns -ENOENT.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  cmds-check.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index eb65a18fe64b..4ce6139b3ab1 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -5931,7 +5931,7 @@ begin:
>  				path->slots[0]--;

Well, not a problem of this patch, but I found previous lines have proble=
m:
------
		ret =3D btrfs_search_slot(NULL, root, di_key, path, 0, 0);
		/* the item was deleted, let path point the last checked item */
		if (ret > 0) {
			if (path->slots[0] =3D=3D 0)
				btrfs_prev_leaf(root, path);
			else
				path->slots[0]--;
		}
------

Here return value of btrfs_prev_leaf() is ignored, which can return
error or >1.

Thanks,
Qu

>  		}
>  		if (ret)
> -			goto out;
> +			return err;>  	}
> =20
>  	node =3D path->nodes[0];
> @@ -6040,7 +6040,7 @@ next:
>  			break;
>  		}
>  	}
> -out:
> +
>  	/* research path */
>  	btrfs_release_path(path);
>  	ret =3D btrfs_search_slot(NULL, root, di_key, path, 0, 0);
>=20


--u16VhokB8oDOUWReCtFT18FTwlp6afDmT--

--aDD9NEhvAuVsTzbOCnyBCCuxULDK8nSJa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpq+EoXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhsOwf+P/3Jog/j57ZCAhxkhI8kmH2/
Q9qOqKzrr9sjOWtnX+3ykbSpuJRhHUxnZFBijp/YveGOGA+7XE4mlPIFo1xsAnFj
SwAF3Y+/0Kop3um5gvoRh2codYjdLYX566U/4sLDzTDnY6t/TQfGnnEYJq+/twXJ
4pidGvY3XmBmxralMOuTdOpohPaH6susPT2QH9oiMwdEqDdE5rESEEtVNiz9iGni
u1u0OAeRWNKhN9ia4nWif+/44I7z9WcG3r2Ebu/pOfZGvApqZSMxvCOENcsz+Rao
M7tDqps6/ueKgjjNTODMTTF3Zspze6GgCmV4TfEOuwa6QlFnUFDUAB27alc0WA==
=PVSU
-----END PGP SIGNATURE-----

--aDD9NEhvAuVsTzbOCnyBCCuxULDK8nSJa--
