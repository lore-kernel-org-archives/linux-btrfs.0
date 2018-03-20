Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:45493 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752347AbeCTIur (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 04:50:47 -0400
Subject: Re: [PATCH] btrfs: ctree.h: Fix wrong comment position about csum
 size
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cacb081b-619f-413e-0ebf-38f8e8af3d25@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <34461665-141e-55a5-ea29-ebc20cf939de@gmx.com>
Date: Tue, 20 Mar 2018 16:50:32 +0800
MIME-Version: 1.0
In-Reply-To: <cacb081b-619f-413e-0ebf-38f8e8af3d25@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gWBR2hZKgrt5TsUKqHTWcE34s99TYnNhm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gWBR2hZKgrt5TsUKqHTWcE34s99TYnNhm
Content-Type: multipart/mixed; boundary="LwCyMeFZJyw52FN9ASW0O6xLrpajvuj6p";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <34461665-141e-55a5-ea29-ebc20cf939de@gmx.com>
Subject: Re: [PATCH] btrfs: ctree.h: Fix wrong comment position about csum
 size
References: <cacb081b-619f-413e-0ebf-38f8e8af3d25@jp.fujitsu.com>
In-Reply-To: <cacb081b-619f-413e-0ebf-38f8e8af3d25@jp.fujitsu.com>

--LwCyMeFZJyw52FN9ASW0O6xLrpajvuj6p
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8820=E6=97=A5 14:47, Misono, Tomohiro wrote:
>=20
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

BTW this reminds me that, btrfs-progs is still using BTRFS_CRC32_SIZE
macro which the original comment is for.

It may be a good time to clean it up in btrfs-progs.

Thanks,
Qu

> ---
>  fs/btrfs/ctree.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index da308774b8a4..8f59cb20dd4c 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -86,9 +86,9 @@ struct btrfs_ordered_sum;
>   */
>  #define BTRFS_LINK_MAX 65535U
> =20
> +/* four bytes for CRC32 */
>  static const int btrfs_csum_sizes[] =3D { 4 };
> =20
> -/* four bytes for CRC32 */
>  #define BTRFS_EMPTY_DIR_SIZE 0
> =20
>  /* ioprio of readahead is set to idle */
>=20


--LwCyMeFZJyw52FN9ASW0O6xLrpajvuj6p--

--gWBR2hZKgrt5TsUKqHTWcE34s99TYnNhm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqwy1gXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgb/gf/XiiVsCA4bluJ/xTaRXJFJOP9
U+MHFLvXSDJu2wLz3EmaobuKfjh7/3/7KUJQNibcWcllKqER/fPBIZF+MEWm6sN6
QIKRIs6GzGoXU7ZV5JkJhB0+fh0ozEPCPSvlDrEbBfA76g2wFtc4hvSPgTWtD33D
lt4AZ366rgSz1Bhm3MPxyk7jYG+t9pQPkQqitK69L/hzRI3maNjiaRE5ubbkpjwA
AWJ8yRCzp840FqG6pVJKIrgysyEqTXhRtDKAtloftbfRFf7LHwBf96iP4wKUsD5H
qVd2X6l/gGvQ36H3KHSdaAohEJGO7ypjOsWB+wQL9WkPSAIu++lht77gdXdWFQ==
=tNyx
-----END PGP SIGNATURE-----

--gWBR2hZKgrt5TsUKqHTWcE34s99TYnNhm--
