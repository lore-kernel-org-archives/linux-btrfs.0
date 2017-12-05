Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:53352 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752488AbdLEILk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 03:11:40 -0500
Subject: Re: [PATCH] btrfs: Handle btrfs_set_extent_delalloc failure
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
References: <1512458959-20473-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <638fd7c3-c805-dc78-17e9-3a4a648a2aae@gmx.com>
Date: Tue, 5 Dec 2017 16:10:59 +0800
MIME-Version: 1.0
In-Reply-To: <1512458959-20473-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="q8E5nDJC2jl9cuLPPDh6uAkrDAKj5rsIA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q8E5nDJC2jl9cuLPPDh6uAkrDAKj5rsIA
Content-Type: multipart/mixed; boundary="Ff4Xste66bstMGTTw3LKNHx2o69ASoIl8";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Message-ID: <638fd7c3-c805-dc78-17e9-3a4a648a2aae@gmx.com>
Subject: Re: [PATCH] btrfs: Handle btrfs_set_extent_delalloc failure
References: <1512458959-20473-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1512458959-20473-1-git-send-email-nborisov@suse.com>

--Ff4Xste66bstMGTTw3LKNHx2o69ASoIl8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8805=E6=97=A5 15:29, Nikolay Borisov wrote:
> This function was introduced by 247e743cbe6e ("Btrfs: Use async helpers=
 to deal
> with pages that have been improperly dirtied") and it didn't do any err=
or
> handling then. This function might very well fail in ENOMEM situation, =
yet
> it's not handled, this could lead to inconsistent state. So let's handl=
e the
> failure by setting the mapping error bit.
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Qu Wenruo <wqu@suse.com>

That's the only missing one. Nice catch.

Thanks,
Qu
> ---
>  fs/btrfs/inode.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 993061f83067..7a5a46fefdb4 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2098,8 +2098,15 @@ static void btrfs_writepage_fixup_worker(struct =
btrfs_work *work)
>  		goto out;
>  	 }
> =20
> -	btrfs_set_extent_delalloc(inode, page_start, page_end, 0, &cached_sta=
te,
> -				  0);
> +	ret =3D btrfs_set_extent_delalloc(inode, page_start, page_end, 0,
> +					&cached_state, 0);
> +	if (ret) {
> +		mapping_set_error(page->mapping, ret);
> +		end_extent_writepage(page, ret, page_start, page_end);
> +		ClearPageChecked(page);
> +		goto out;
> +	 }
> +
>  	ClearPageChecked(page);
>  	set_page_dirty(page);
>  	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
>=20


--Ff4Xste66bstMGTTw3LKNHx2o69ASoIl8--

--q8E5nDJC2jl9cuLPPDh6uAkrDAKj5rsIA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlomVJMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiqEgf/bhOBhA+VuEY9i2aRFrlFfUQ7
gkIkRbPz2TGlq3ZvFQ5GyXTsXV0MHQbBSUeOQNREf/uh1Cv8cvf6XVLkQKe6o/BQ
g7B/Co6Cry6xTqNw11nAclJLcrYMTuDqNxtm+dtm2ajf+h7qhW2iPRvTPIuRkTkI
vF8IsYjexoIAmXJjgDnDcN7PhdQUozZviMRVBpKaYbFl8P2oow3imnV6AFDokc3g
ADyZ30dyV1EJs+3wwazXiCCbFEEsjEtnmHm/h1NW0LBVO/ysI5BGOJX4ExXNRaWL
tILP8ZRzRPq3IjBZEgHqX4daq3EpFVuQ4CUL3kUz0igF5ps8U+Be4a9iXUOKEw==
=VNwo
-----END PGP SIGNATURE-----

--q8E5nDJC2jl9cuLPPDh6uAkrDAKj5rsIA--
