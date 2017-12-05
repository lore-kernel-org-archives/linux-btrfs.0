Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57416 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752548AbdLEIHw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 03:07:52 -0500
Subject: Re: [PATCH 3/3] Btrfs: make raid6 rebuild retry more
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171204224037.7556-1-bo.li.liu@oracle.com>
 <20171204224037.7556-4-bo.li.liu@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1ab2da20-6294-67a4-2ef3-6a65afed0fc6@gmx.com>
Date: Tue, 5 Dec 2017 16:07:35 +0800
MIME-Version: 1.0
In-Reply-To: <20171204224037.7556-4-bo.li.liu@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oDtO8TSiBfD8s4oaEc6rO9Afco5rbqfjD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oDtO8TSiBfD8s4oaEc6rO9Afco5rbqfjD
Content-Type: multipart/mixed; boundary="rwsjo1pAqlU183ECJxpbMxvSmRIINs6ps";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <1ab2da20-6294-67a4-2ef3-6a65afed0fc6@gmx.com>
Subject: Re: [PATCH 3/3] Btrfs: make raid6 rebuild retry more
References: <20171204224037.7556-1-bo.li.liu@oracle.com>
 <20171204224037.7556-4-bo.li.liu@oracle.com>
In-Reply-To: <20171204224037.7556-4-bo.li.liu@oracle.com>

--rwsjo1pAqlU183ECJxpbMxvSmRIINs6ps
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8805=E6=97=A5 06:40, Liu Bo wrote:
> There is a scenario that can end up with rebuild process failing to
> return good content, i.e.
> suppose that all disks can be read without problems and if the content
> that was read out doesn't match its checksum, currently for raid6
> btrfs at most retries twice,
>=20
> - the 1st retry is to rebuild with all other stripes, it'll eventually
>   be a raid5 xor rebuild,
> - if the 1st fails, the 2nd retry will deliberately fail parity p so
>   that it will do raid6 style rebuild,
>=20
> however, the chances are that another non-parity stripe content also
> has something corrupted, so that the above retries are not able to
> return correct content, and users will think of this as data loss.
> More seriouly, if the loss happens on some important internal btree
> roots, it could refuse to mount.
>=20
> This extends btrfs to do more retries and each retry fails only one
> stripe.  Since raid6 can tolerate 2 disk failures, if there is one
> more failure besides the failure on which we're recovering, this can
> always work.

This should be the correct behavior for RAID6, try all possible
combination until all combination is exhausted or correct data can be
recovered.

>=20
> The worst case is to retry as many times as the number of raid6 disks,
> but given the fact that such a scenario is really rare in practice,
> it's still acceptable.

And even we tried that much times, I don't think it will be a big problem=
=2E
Since most of the that happens purely in memory, it should be so fast
that no obvious impact can be observed.

While with some small nitpick inlined below, the idea looks pretty good
to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

>=20
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/raid56.c  | 18 ++++++++++++++----
>  fs/btrfs/volumes.c |  9 ++++++++-
>  2 files changed, 22 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 8d09535..064d5bc 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -2166,11 +2166,21 @@ int raid56_parity_recover(struct btrfs_fs_info =
*fs_info, struct bio *bio,
>  	}
> =20
>  	/*
> -	 * reconstruct from the q stripe if they are
> -	 * asking for mirror 3
> +	 * Loop retry:
> +	 * for 'mirror =3D=3D 2', reconstruct from all other stripes.

What about using macro to makes the reassemble method more human readable=
?

And for mirror =3D=3D 2 case, "rebuild from all" do you mean rebuild usin=
g
all remaining data stripe + P? The word "all" here is a little confusing.=


Thanks,
Qu

> +	 * for 'mirror_num > 2', select a stripe to fail on every retry.
>  	 */> -	if (mirror_num =3D=3D 3)
> -		rbio->failb =3D rbio->real_stripes - 2;
> +	if (mirror_num > 2) {
> +		/*
> +		 * 'mirror =3D=3D 3' is to fail the p stripe and
> +		 * reconstruct from the q stripe.  'mirror > 3' is to
> +		 * fail a data stripe and reconstruct from p+q stripe.
> +		 */
> +		rbio->failb =3D rbio->real_stripes - (mirror_num - 1);
> +		ASSERT(rbio->failb > 0);
> +		if (rbio->failb <=3D rbio->faila)
> +			rbio->failb--;
> +	}
> =20
>  	ret =3D lock_stripe_add(rbio);
> =20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index b397375..95371f8 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5094,7 +5094,14 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_in=
fo, u64 logical, u64 len)
>  	else if (map->type & BTRFS_BLOCK_GROUP_RAID5)
>  		ret =3D 2;
>  	else if (map->type & BTRFS_BLOCK_GROUP_RAID6)
> -		ret =3D 3;
> +		/*
> +		 * There could be two corrupted data stripes, we need
> +		 * to loop retry in order to rebuild the correct data.
> +		 *=20
> +		 * Fail a stripe at a time on every retry except the
> +		 * stripe under reconstruction.
> +		 */
> +		ret =3D map->num_stripes;
>  	else
>  		ret =3D 1;
>  	free_extent_map(em);
>=20


--rwsjo1pAqlU183ECJxpbMxvSmRIINs6ps--

--oDtO8TSiBfD8s4oaEc6rO9Afco5rbqfjD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlomU8cXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgMPwgArdGCqe+xQS5LlMKZJoCmFKAe
/5WRkGUsC/4E3b6gOp3vjeEOEzmK4djWPY9zaTH4TJCSCqlnnS1nqMfctp/gp2vB
3UKwqAA1YOypDRHcqZlQAujNRDUQarnpZBloHYCuxTPknnTYPBOOfOHaLnhZHMg/
Qb2JuLE3I1gnYY3D/IOEnWxphFsYlHZIa3ANwKDADq9C314KgqF8OT4xzz++vb1O
Tht3ZVLSIutQRjg3B8jJEsCMLlZrI0u27DdtsM0VLC8gbcYmWWoXEezL4S2UlQbX
u2x/wjwQtOFispMOVIMki7T5nztTGSz6p9Wx7ZxpTpF6m73eyqHT2WiHJ9Cvkw==
=H2Ay
-----END PGP SIGNATURE-----

--oDtO8TSiBfD8s4oaEc6rO9Afco5rbqfjD--
