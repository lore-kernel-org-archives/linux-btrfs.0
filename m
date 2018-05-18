Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:49933 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750763AbeERFbY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 01:31:24 -0400
Subject: Re: [PATCH v2 6/6] Btrfs: remove always true check in unlock_up
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526612424-97061-7-git-send-email-bo.liu@linux.alibaba.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a57a50ed-30b3-8274-ef91-4e1d2cb64ede@gmx.com>
Date: Fri, 18 May 2018 13:31:16 +0800
MIME-Version: 1.0
In-Reply-To: <1526612424-97061-7-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DmQy2EoejkEu5vjcKtYlVFm5ObyGwYV1d"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DmQy2EoejkEu5vjcKtYlVFm5ObyGwYV1d
Content-Type: multipart/mixed; boundary="Eg0rIr8qaYcbd02fJd2In2tEAuF3NWoEB";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Message-ID: <a57a50ed-30b3-8274-ef91-4e1d2cb64ede@gmx.com>
Subject: Re: [PATCH v2 6/6] Btrfs: remove always true check in unlock_up
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526612424-97061-7-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526612424-97061-7-git-send-email-bo.liu@linux.alibaba.com>

--Eg0rIr8qaYcbd02fJd2In2tEAuF3NWoEB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8818=E6=97=A5 11:00, Liu Bo wrote:
> As unlock_up() is written as
>=20
> for () {
>    if (!path->locks[i])
>        break;
>    ...
>    if (... && path->locks[i]) {
>    }
> }
>=20
> Apparently, @path->locks[i] is always true at this 'if'.
>=20
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/ctree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index e619f7e01794..65dbebb8cc59 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2330,7 +2330,7 @@ static noinline void unlock_up(struct btrfs_path =
*path, int level,
>  			no_skips =3D 1;
> =20
>  		t =3D path->nodes[i];
> -		if (i >=3D lowest_unlock && i > skip_level && path->locks[i]) {
> +		if (i >=3D lowest_unlock && i > skip_level) {
>  			btrfs_tree_unlock_rw(t, path->locks[i]);
>  			path->locks[i] =3D 0;
>  			if (write_lock_level &&
>=20


--Eg0rIr8qaYcbd02fJd2In2tEAuF3NWoEB--

--DmQy2EoejkEu5vjcKtYlVFm5ObyGwYV1d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr+ZSQACgkQwj2R86El
/qh1fQgAjeyMYkgIwe7XIdCgAWoc9psIE5DMOFViEjBYT1BouG6f5+jdF9DZRVMX
8UNEKKhUEl9vWBzvPy8WTtTPgBQwIf6AAV6Xk2smxGt2maS0qo+CiAHHqY/p0cTq
yYBgQn52Npq3jccMKd8Mah42yjB0Em+c2H9yqVlFt/Kk545+HTlHJH1aN0H7Be+C
ZDxZLMj+urp2n/81fyxusLfQJKDlHb5cpUjAQvT2SA+SGedr7OZ9efA12joAYixo
GkV17fS0II3oJ/kjEE8cD92JZac15E4XsPMhH+nUhu5k2K3KC1l+gA4ZmhxqI4HB
VyfRf0zcsaJhw9FhZucndGsmW9BrxA==
=FBok
-----END PGP SIGNATURE-----

--DmQy2EoejkEu5vjcKtYlVFm5ObyGwYV1d--
