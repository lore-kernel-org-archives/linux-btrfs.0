Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57278 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751053AbeFAAbM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 20:31:12 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3F073AD7C
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Jun 2018 00:31:11 +0000 (UTC)
Subject: Re: [PATCH RFC] btrfs: scrub: Don't use inode pages for device
 replace
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180531083551.25273-1-wqu@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <c181a573-3b88-2bb3-acc1-bd91f81ebefa@suse.com>
Date: Thu, 31 May 2018 20:31:08 -0400
MIME-Version: 1.0
In-Reply-To: <20180531083551.25273-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qpnvinyRUQ3yGuR1JBHfH8gXcjuyPNP61"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qpnvinyRUQ3yGuR1JBHfH8gXcjuyPNP61
Content-Type: multipart/mixed; boundary="e2D1kz264q4LBEJK0Ayc5CuCQq2yUEV5x";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <c181a573-3b88-2bb3-acc1-bd91f81ebefa@suse.com>
Subject: Re: [PATCH RFC] btrfs: scrub: Don't use inode pages for device
 replace
References: <20180531083551.25273-1-wqu@suse.com>
In-Reply-To: <20180531083551.25273-1-wqu@suse.com>

--e2D1kz264q4LBEJK0Ayc5CuCQq2yUEV5x
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/31/18 4:35 AM, Qu Wenruo wrote:
> [BUG]
> Btrfs can easily create compressed extent without checksum (even
> though it shouldn't), and if we then try to replace device containing
> such extent, the result device will contain all the uncompressed data
> instead of the compressed one.
>=20
> Leading to data corruption.
>=20
> [Cause]
> When handling compressed extent without checksum, device replace will
> goes into copy_nocow_pages() function.
>=20
> In that function, btrfs will get all inodes referring to this data
> extents and then use find_or_create_page() to get pages direct from tha=
t
> inode.
>=20
> The problem here is, pages directly from inode are always uncompressed.=

> And for compressed data extent, they mismatch with on-disk data.
> Thus this leads to corrupted compressed data extent written to replace
> device.
>=20
> [Fix]
> The fix is a little tricky.
> As we can't determine if an extent is compressed until we iterate
> through at least one of its refereners, so we still need to go into
> copy_nocow_pages() function.
>=20
> And before we really begin to copy data, we check if the extent is
> compressed, and if it is, we fallback to scrub_pages() to read the
> on-disk data other than inode's uncompressed data.
>=20
> To be able to call scrub_pages(), we need extra parameters, add all of
> them (@physical, @dev, @gen, excluding @flags which is fixed to
> BTRFS_EXTENT_FLAG_DATA) to copy_nocow_pages() and nocow_ctx structure.
>=20
> Reported-by: James Harvey <jamespharvey20@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>=20
> In fact, the copy_nocow_pages() and its children functions are just a
> kind of "clever" optimization to skip some read IO.
>=20
> However I'm never a fan of such "optimization", no to mention when it's=

> causing bugs.
> Although the ability to use page cache to write data back looks pretty
> nice, it's in fact pretty niche.
>=20
> I'm pretty happy if we could remove the whole copy_nocow_pages() branch=
,
> and use the only and unified scrub_pages() to handle everything.
> At least it's way more cleaner than current solution.

I think this is the way to go.  It's added complexity for not a lot of
benefit.

-Jeff

> ---
>  fs/btrfs/scrub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-----=

>  1 file changed, 45 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 52b39a0924e9..307a06450e5c 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -212,6 +212,11 @@ struct scrub_copy_nocow_ctx {
>  	u64			physical_for_dev_replace;
>  	struct list_head	inodes;
>  	struct btrfs_work	work;
> +
> +	/* All these members are only for falling back to scrub_pages() */
> +	u64			fb_physical;
> +	struct btrfs_device	*fb_dev;
> +	u64			fb_gen;
>  };
> =20
>  struct scrub_warning {
> @@ -282,6 +287,7 @@ static int write_page_nocow(struct scrub_ctx *sctx,=

>  static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
>  				      struct scrub_copy_nocow_ctx *ctx);
>  static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 l=
en,
> +			    u64 physical, struct btrfs_device *dev, u64 gen,
>  			    int mirror_num, u64 physical_for_dev_replace);
>  static void copy_nocow_pages_worker(struct btrfs_work *work);
>  static void __scrub_blocked_if_needed(struct btrfs_fs_info *fs_info);
> @@ -2801,8 +2807,8 @@ static int scrub_extent(struct scrub_ctx *sctx, s=
truct map_lookup *map,
>  				++sctx->stat.no_csum;
>  			if (sctx->is_dev_replace && !have_csum) {
>  				ret =3D copy_nocow_pages(sctx, logical, l,
> -						       mirror_num,
> -						      physical_for_dev_replace);
> +						physical, dev, gen, mirror_num,
> +						physical_for_dev_replace);
>  				goto behind_scrub_pages;
>  			}
>  		}
> @@ -4359,6 +4365,7 @@ static void scrub_remap_extent(struct btrfs_fs_in=
fo *fs_info,
>  }
> =20
>  static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 l=
en,
> +			    u64 physical, struct btrfs_device *dev, u64 gen,
>  			    int mirror_num, u64 physical_for_dev_replace)
>  {
>  	struct scrub_copy_nocow_ctx *nocow_ctx;
> @@ -4379,6 +4386,11 @@ static int copy_nocow_pages(struct scrub_ctx *sc=
tx, u64 logical, u64 len,
>  	nocow_ctx->len =3D len;
>  	nocow_ctx->mirror_num =3D mirror_num;
>  	nocow_ctx->physical_for_dev_replace =3D physical_for_dev_replace;
> +
> +	nocow_ctx->fb_physical =3D physical;
> +	nocow_ctx->fb_gen =3D gen;
> +	nocow_ctx->fb_dev =3D dev;
> +
>  	btrfs_init_work(&nocow_ctx->work, btrfs_scrubnc_helper,
>  			copy_nocow_pages_worker, NULL, NULL);
>  	INIT_LIST_HEAD(&nocow_ctx->inodes);
> @@ -4487,7 +4499,7 @@ static void copy_nocow_pages_worker(struct btrfs_=
work *work)
>  }
> =20
>  static int check_extent_to_block(struct btrfs_inode *inode, u64 start,=
 u64 len,
> -				 u64 logical)
> +				 u64 logical, int *compressed)
>  {
>  	struct extent_state *cached_state =3D NULL;
>  	struct btrfs_ordered_extent *ordered;
> @@ -4523,6 +4535,7 @@ static int check_extent_to_block(struct btrfs_ino=
de *inode, u64 start, u64 len,
>  		ret =3D 1;
>  		goto out_unlock;
>  	}
> +	*compressed =3D em->compress_type;
>  	free_extent_map(em);
> =20
>  out_unlock:
> @@ -4543,6 +4556,7 @@ static int copy_nocow_pages_for_inode(u64 inum, u=
64 offset, u64 root,
>  	u64 nocow_ctx_logical;
>  	u64 len =3D nocow_ctx->len;
>  	unsigned long index;
> +	int compressed;
>  	int srcu_index;
>  	int ret =3D 0;
>  	int err =3D 0;
> @@ -4576,12 +4590,20 @@ static int copy_nocow_pages_for_inode(u64 inum,=
 u64 offset, u64 root,
>  	nocow_ctx_logical =3D nocow_ctx->logical;
> =20
>  	ret =3D check_extent_to_block(BTRFS_I(inode), offset, len,
> -			nocow_ctx_logical);
> +			nocow_ctx_logical, &compressed);
>  	if (ret) {
>  		ret =3D ret > 0 ? 0 : ret;
>  		goto out;
>  	}
> =20
> +	/*
> +	 * We hit the damn nodatasum compressed extent, we can't use any page=

> +	 * from inode as they are all *UNCOMPRESSED*.
> +	 * We fall back to scrub_pages() for such case.
> +	 */
> +	if (compressed)
> +		goto fallback;
> +
>  	while (len >=3D PAGE_SIZE) {
>  		index =3D offset >> PAGE_SHIFT;
>  again:
> @@ -4624,11 +4646,16 @@ static int copy_nocow_pages_for_inode(u64 inum,=
 u64 offset, u64 root,
>  		}
> =20
>  		ret =3D check_extent_to_block(BTRFS_I(inode), offset, len,
> -					    nocow_ctx_logical);
> +					    nocow_ctx_logical, &compressed);
>  		if (ret) {
>  			ret =3D ret > 0 ? 0 : ret;
>  			goto next_page;
>  		}
> +		if (compressed) {
> +			unlock_page(page);
> +			put_page(page);
> +			goto fallback;
> +		}
> =20
>  		err =3D write_page_nocow(nocow_ctx->sctx,
>  				       physical_for_dev_replace, page);
> @@ -4651,6 +4678,19 @@ static int copy_nocow_pages_for_inode(u64 inum, =
u64 offset, u64 root,
>  	inode_unlock(inode);
>  	iput(inode);
>  	return ret;
> +
> +fallback:
> +	inode_unlock(inode);
> +	iput(inode);
> +
> +	ret =3D scrub_pages(nocow_ctx->sctx, nocow_ctx->logical,
> +			  nocow_ctx->len, nocow_ctx->fb_physical,
> +			  nocow_ctx->fb_dev, BTRFS_EXTENT_FLAG_DATA,
> +			  nocow_ctx->fb_gen, nocow_ctx->mirror_num,
> +			  NULL, 0, physical_for_dev_replace);
> +	if (!ret)
> +		ret =3D COPY_COMPLETE;
> +	return ret;
>  }
> =20
>  static int write_page_nocow(struct scrub_ctx *sctx,
>=20


--=20
Jeff Mahoney
SUSE Labs


--e2D1kz264q4LBEJK0Ayc5CuCQq2yUEV5x--

--qpnvinyRUQ3yGuR1JBHfH8gXcjuyPNP61
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlsQk8wACgkQHntLYyF5
5bKUPBAAhE58jBdzWBxqEU9uVsp3yeJQZHhHTe+/HbG5GIcAqDSV2s1XzRcU03xJ
hCX8fs06zkyEs6kYatiDcaFAll+JAWlIwrnq+JnSEKjpKtmFtaomRabhdDcVRJiI
+CKyKZE3w7R2CITruVKlyeN1yaUWdRNZiSXTeKvksINnychQ2HT2dyiGx3G0UjRB
KVedLyMEabMASdom34m3S2IAy+hOLk9NQyklBW07Ke3WFrqBrbZvq393EQGt5Ma3
L88MzRlhtdsnNfQ9WlAtIxkaHtckPuzmV7q1MVpWagCER3Ln/HCJPBL2gGArHPWE
RnUe4jDOo3dk75NGVh37+cl6Gizmzuq78uJHxZA73iGrbXG5+ebZZY5gwmARYmeT
xKsdUI2Zr1uHRaqCiecOjQOBgqE2HD3LfakyFeVd2OVqIHRqekFGK49LUFzG9Nss
Wk8NOav8HcaYxAKpDzGAcyOqBZwBrQO1wCGMQ/6q2xXroDo5eDxHTA6RkzctEG2V
IaB3C6nF1jh4Baf0CteMQWjhcEZNDpvqS3PMOWQnWSD+XDrR9WfO95vL9Etq83JN
QOE+PWWjkQsE7qUvcekk6lnHwYMAXun7G3DT7vOdVlGFv3qDmC+AguegQnbO+peq
LB6SdLoGqTynqpcT9NTx0bRo6Ey4r2ss7cc0SgVAXivImSE8mBA=
=p25A
-----END PGP SIGNATURE-----

--qpnvinyRUQ3yGuR1JBHfH8gXcjuyPNP61--
