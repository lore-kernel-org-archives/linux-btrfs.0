Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53642 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751409AbeAZJhc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 04:37:32 -0500
Subject: Re: [PATCH 07/15] btrfs-progs: lowmem check: find_dir_item by di_key
 in check_dir_item()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-8-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9a968a12-464c-91bd-4396-8ec76a2bea49@gmx.com>
Date: Fri, 26 Jan 2018 17:37:25 +0800
MIME-Version: 1.0
In-Reply-To: <20180126083519.28373-8-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vRFL7yhuOd8FbM3LojHvzv4xD92wVV8ZS"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vRFL7yhuOd8FbM3LojHvzv4xD92wVV8ZS
Content-Type: multipart/mixed; boundary="u2TuWwzGleceVG2yeycXQe7nuaANfZa1F";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <9a968a12-464c-91bd-4396-8ec76a2bea49@gmx.com>
Subject: Re: [PATCH 07/15] btrfs-progs: lowmem check: find_dir_item by di_key
 in check_dir_item()
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-8-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-8-suy.fnst@cn.fujitsu.com>

--u2TuWwzGleceVG2yeycXQe7nuaANfZa1F
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 16:35, Su Yue wrote:
> In check_dir_item, we are going to search corresponding
> dir_item/index.
> @key shouldn't be used here. It should be @di_key.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  cmds-check.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index 4ce6139b3ab1..caac71a67472 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -6001,7 +6001,7 @@ begin:
> =20
>  		/* check relative INDEX/ITEM */
>  		key.objectid =3D di_key->objectid;
> -		if (key.type =3D=3D BTRFS_DIR_ITEM_KEY) {
> +		if (di_key->type =3D=3D BTRFS_DIR_ITEM_KEY) {
>  			key.type =3D BTRFS_DIR_INDEX_KEY;
>  			key.offset =3D index;
>  		} else {
>=20


--u2TuWwzGleceVG2yeycXQe7nuaANfZa1F--

--vRFL7yhuOd8FbM3LojHvzv4xD92wVV8ZS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpq9tUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhq/QgAhLbIwPX9ZVN9+OrapD/7s0AU
3t+wbMGVHsQBhLCktmrhGKNQP381m5Sc5F/E1jzHadk+pENnw0Tvov493mMTi73H
UVylPnfWL1SMGlZlqbqEH768G4hJ/Q4tOSPlnmQMsYAEBW0pmw444UPhwf583PI0
XbzC0JbHz305S0XTMqHYCf60LFolPYnVTwpljzzsTeC/zkGNlyRbrqTCGD+yQ3Po
I0J78+xKTjgTCz1e2H8pndzzku/kJkb9yPf4wg7brHHjjFFynh71Muo5CfLKfIRj
TuH8KPyol1HpQl9Uc0pGJyVS50pclKF1NSqk8FwNvjJULzvG6Uftpdo0ujc0ZQ==
=OltZ
-----END PGP SIGNATURE-----

--vRFL7yhuOd8FbM3LojHvzv4xD92wVV8ZS--
