Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61593 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754796AbeASAqV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 19:46:21 -0500
Subject: Re: [PATCH] btrfs: Use IS_ALIGNED in btrfs_truncate_block instead of
 opencoding it
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1516279626-6111-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7d7570f4-43fa-8ebc-9a16-b2777eeabf3f@gmx.com>
Date: Fri, 19 Jan 2018 08:45:40 +0800
MIME-Version: 1.0
In-Reply-To: <1516279626-6111-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qRLsniUpJu8GJG79YijmJJFJVUFulAky7"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qRLsniUpJu8GJG79YijmJJFJVUFulAky7
Content-Type: multipart/mixed; boundary="eMN5lWVxQMQFTCIhvrET9j0UehXbEzjPe";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <7d7570f4-43fa-8ebc-9a16-b2777eeabf3f@gmx.com>
Subject: Re: [PATCH] btrfs: Use IS_ALIGNED in btrfs_truncate_block instead of
 opencoding it
References: <1516279626-6111-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1516279626-6111-1-git-send-email-nborisov@suse.com>

--eMN5lWVxQMQFTCIhvrET9j0UehXbEzjPe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8818=E6=97=A5 20:47, Nikolay Borisov wrote:
> No functional changes, just makes the code more readable
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 269d129ffb1f..e9690e2aba09 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4775,8 +4775,8 @@ int btrfs_truncate_block(struct inode *inode, lof=
f_t from, loff_t len,
>  	u64 block_start;
>  	u64 block_end;
> =20
> -	if ((offset & (blocksize - 1)) =3D=3D 0 &&
> -	    (!len || ((len & (blocksize - 1)) =3D=3D 0)))
> +	if (IS_ALIGNED(offset, blocksize) &&
> +	    (!len || IS_ALIGNED(len, blocksize)))
>  		goto out;
> =20
>  	block_start =3D round_down(from, blocksize);
>=20


--eMN5lWVxQMQFTCIhvrET9j0UehXbEzjPe--

--qRLsniUpJu8GJG79YijmJJFJVUFulAky7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlphP7QXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgmtAf+J1vtlPuQjXAV6P+24Or4XXUy
MCyHBswnK7xIMTaNtQcIu9FerFlZ5DLQuEgnNIYd2QczkBe4eJCxOgQC7HLrK1wX
YiCP7dsJ8qWpCnbGTNkLTg5vWSINRzWpIRg2J8l7oz5zD8B/QZaZZ7y0Fk+uIq+b
0yu9Q7GVwWOYECpf178Rs7dYGIkmBhFliTdBTeyAzR0B290T7+DzcYPTHskDfUPb
EkxAU6FGO7llG3RXk9TvD+9/TZy/r7WzjzIXvWoVLsvG9YSkV7j1u2S7g+iqzSDp
+PbQAiflKEsm50XRW4zcKWqoppEkGAS1iRUdyT+C/jQUhsPAkMt8IEX5HKWv2g==
=pyqa
-----END PGP SIGNATURE-----

--qRLsniUpJu8GJG79YijmJJFJVUFulAky7--
