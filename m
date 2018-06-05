Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:41047 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751567AbeFEFeS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Jun 2018 01:34:18 -0400
Subject: Re: [PATCH RFC ver.B] btrfs: scrub: Don't use inode pages for device
 replace
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
References: <20180605043656.4006-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e50c0393-9a5c-3b87-e1e6-830c10f72ae8@gmx.com>
Date: Tue, 5 Jun 2018 13:34:03 +0800
MIME-Version: 1.0
In-Reply-To: <20180605043656.4006-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ubCXMFPMrtGNFm5lEreJSsMJMF4rmyMpQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ubCXMFPMrtGNFm5lEreJSsMJMF4rmyMpQ
Content-Type: multipart/mixed; boundary="vw9Ny5lwSRrfDFaIfpMIlsev4FLrKqRXs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.cz>
Message-ID: <e50c0393-9a5c-3b87-e1e6-830c10f72ae8@gmx.com>
Subject: Re: [PATCH RFC ver.B] btrfs: scrub: Don't use inode pages for device
 replace
References: <20180605043656.4006-1-wqu@suse.com>
In-Reply-To: <20180605043656.4006-1-wqu@suse.com>

--vw9Ny5lwSRrfDFaIfpMIlsev4FLrKqRXs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi David,

It would be pretty nice if we could get this fix (or previous RFC patch)
to get into current release cycle.

As it's a unrecoverable data corruption, it would be better to get it
fixed as soon as possible.

Thanks,
Qu

On 2018=E5=B9=B406=E6=9C=8805=E6=97=A5 12:36, Qu Wenruo wrote:
> [BUG]
> Btrfs can easily create compressed extent without checksum (even
> though it shouldn't), and if we then try to replace device containing
> such extent, the result device will contain all the uncompressed data
> instead of the compressed one.
>=20
> Test case already submitted to fstests:
> https://patchwork.kernel.org/patch/10442353/
>=20
> [CAUSE]
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
> [FIX]
> In this attempt, we could just remove the "optimization" branch, and le=
t
> unified scrub_pages() to handle it.
>=20
> Although scrub_pages() won't bother reusing page cache, it will be a
> little slower, but it does the correct csum checking and won't cause
> such data corruption cause by "optimization".
>=20
> Reported-by: James Harvey <jamespharvey20@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> ver.B:
>     Instead of checking extent type in copy_nocow_pages() branch, just
>     remove them all, since existing scrub_pages() can handle nodatasum
>     case pretty well and it saves a lot of codes.
> ---
>  fs/btrfs/scrub.c | 341 -----------------------------------------------=

>  1 file changed, 341 deletions(-)
>=20
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 52b39a0924e9..799e4c6b2551 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -277,13 +277,6 @@ static int scrub_add_page_to_wr_bio(struct scrub_c=
tx *sctx,
>  static void scrub_wr_submit(struct scrub_ctx *sctx);
>  static void scrub_wr_bio_end_io(struct bio *bio);
>  static void scrub_wr_bio_end_io_worker(struct btrfs_work *work);
> -static int write_page_nocow(struct scrub_ctx *sctx,
> -			    u64 physical_for_dev_replace, struct page *page);
> -static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
> -				      struct scrub_copy_nocow_ctx *ctx);
> -static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 l=
en,
> -			    int mirror_num, u64 physical_for_dev_replace);
> -static void copy_nocow_pages_worker(struct btrfs_work *work);
>  static void __scrub_blocked_if_needed(struct btrfs_fs_info *fs_info);
>  static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info);
>  static void scrub_put_ctx(struct scrub_ctx *sctx);
> @@ -2799,17 +2792,10 @@ static int scrub_extent(struct scrub_ctx *sctx,=
 struct map_lookup *map,
>  			have_csum =3D scrub_find_csum(sctx, logical, csum);
>  			if (have_csum =3D=3D 0)
>  				++sctx->stat.no_csum;
> -			if (sctx->is_dev_replace && !have_csum) {
> -				ret =3D copy_nocow_pages(sctx, logical, l,
> -						       mirror_num,
> -						      physical_for_dev_replace);
> -				goto behind_scrub_pages;
> -			}
>  		}
>  		ret =3D scrub_pages(sctx, logical, l, physical, dev, flags, gen,
>  				  mirror_num, have_csum ? csum : NULL, 0,
>  				  physical_for_dev_replace);
> -behind_scrub_pages:
>  		if (ret)
>  			return ret;
>  		len -=3D l;
> @@ -4357,330 +4343,3 @@ static void scrub_remap_extent(struct btrfs_fs_=
info *fs_info,
>  	*extent_dev =3D bbio->stripes[0].dev;
>  	btrfs_put_bbio(bbio);
>  }
> -
> -static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 l=
en,
> -			    int mirror_num, u64 physical_for_dev_replace)
> -{
> -	struct scrub_copy_nocow_ctx *nocow_ctx;
> -	struct btrfs_fs_info *fs_info =3D sctx->fs_info;
> -
> -	nocow_ctx =3D kzalloc(sizeof(*nocow_ctx), GFP_NOFS);
> -	if (!nocow_ctx) {
> -		spin_lock(&sctx->stat_lock);
> -		sctx->stat.malloc_errors++;
> -		spin_unlock(&sctx->stat_lock);
> -		return -ENOMEM;
> -	}
> -
> -	scrub_pending_trans_workers_inc(sctx);
> -
> -	nocow_ctx->sctx =3D sctx;
> -	nocow_ctx->logical =3D logical;
> -	nocow_ctx->len =3D len;
> -	nocow_ctx->mirror_num =3D mirror_num;
> -	nocow_ctx->physical_for_dev_replace =3D physical_for_dev_replace;
> -	btrfs_init_work(&nocow_ctx->work, btrfs_scrubnc_helper,
> -			copy_nocow_pages_worker, NULL, NULL);
> -	INIT_LIST_HEAD(&nocow_ctx->inodes);
> -	btrfs_queue_work(fs_info->scrub_nocow_workers,
> -			 &nocow_ctx->work);
> -
> -	return 0;
> -}
> -
> -static int record_inode_for_nocow(u64 inum, u64 offset, u64 root, void=
 *ctx)
> -{
> -	struct scrub_copy_nocow_ctx *nocow_ctx =3D ctx;
> -	struct scrub_nocow_inode *nocow_inode;
> -
> -	nocow_inode =3D kzalloc(sizeof(*nocow_inode), GFP_NOFS);
> -	if (!nocow_inode)
> -		return -ENOMEM;
> -	nocow_inode->inum =3D inum;
> -	nocow_inode->offset =3D offset;
> -	nocow_inode->root =3D root;
> -	list_add_tail(&nocow_inode->list, &nocow_ctx->inodes);
> -	return 0;
> -}
> -
> -#define COPY_COMPLETE 1
> -
> -static void copy_nocow_pages_worker(struct btrfs_work *work)
> -{
> -	struct scrub_copy_nocow_ctx *nocow_ctx =3D
> -		container_of(work, struct scrub_copy_nocow_ctx, work);
> -	struct scrub_ctx *sctx =3D nocow_ctx->sctx;
> -	struct btrfs_fs_info *fs_info =3D sctx->fs_info;
> -	struct btrfs_root *root =3D fs_info->extent_root;
> -	u64 logical =3D nocow_ctx->logical;
> -	u64 len =3D nocow_ctx->len;
> -	int mirror_num =3D nocow_ctx->mirror_num;
> -	u64 physical_for_dev_replace =3D nocow_ctx->physical_for_dev_replace;=

> -	int ret;
> -	struct btrfs_trans_handle *trans =3D NULL;
> -	struct btrfs_path *path;
> -	int not_written =3D 0;
> -
> -	path =3D btrfs_alloc_path();
> -	if (!path) {
> -		spin_lock(&sctx->stat_lock);
> -		sctx->stat.malloc_errors++;
> -		spin_unlock(&sctx->stat_lock);
> -		not_written =3D 1;
> -		goto out;
> -	}
> -
> -	trans =3D btrfs_join_transaction(root);
> -	if (IS_ERR(trans)) {
> -		not_written =3D 1;
> -		goto out;
> -	}
> -
> -	ret =3D iterate_inodes_from_logical(logical, fs_info, path,
> -			record_inode_for_nocow, nocow_ctx, false);
> -	if (ret !=3D 0 && ret !=3D -ENOENT) {
> -		btrfs_warn(fs_info,
> -			   "iterate_inodes_from_logical() failed: log %llu, phys %llu, len =
%llu, mir %u, ret %d",
> -			   logical, physical_for_dev_replace, len, mirror_num,
> -			   ret);
> -		not_written =3D 1;
> -		goto out;
> -	}
> -
> -	btrfs_end_transaction(trans);
> -	trans =3D NULL;
> -	while (!list_empty(&nocow_ctx->inodes)) {
> -		struct scrub_nocow_inode *entry;
> -		entry =3D list_first_entry(&nocow_ctx->inodes,
> -					 struct scrub_nocow_inode,
> -					 list);
> -		list_del_init(&entry->list);
> -		ret =3D copy_nocow_pages_for_inode(entry->inum, entry->offset,
> -						 entry->root, nocow_ctx);
> -		kfree(entry);
> -		if (ret =3D=3D COPY_COMPLETE) {
> -			ret =3D 0;
> -			break;
> -		} else if (ret) {
> -			break;
> -		}
> -	}
> -out:
> -	while (!list_empty(&nocow_ctx->inodes)) {
> -		struct scrub_nocow_inode *entry;
> -		entry =3D list_first_entry(&nocow_ctx->inodes,
> -					 struct scrub_nocow_inode,
> -					 list);
> -		list_del_init(&entry->list);
> -		kfree(entry);
> -	}
> -	if (trans && !IS_ERR(trans))
> -		btrfs_end_transaction(trans);
> -	if (not_written)
> -		btrfs_dev_replace_stats_inc(&fs_info->dev_replace.
> -					    num_uncorrectable_read_errors);
> -
> -	btrfs_free_path(path);
> -	kfree(nocow_ctx);
> -
> -	scrub_pending_trans_workers_dec(sctx);
> -}
> -
> -static int check_extent_to_block(struct btrfs_inode *inode, u64 start,=
 u64 len,
> -				 u64 logical)
> -{
> -	struct extent_state *cached_state =3D NULL;
> -	struct btrfs_ordered_extent *ordered;
> -	struct extent_io_tree *io_tree;
> -	struct extent_map *em;
> -	u64 lockstart =3D start, lockend =3D start + len - 1;
> -	int ret =3D 0;
> -
> -	io_tree =3D &inode->io_tree;
> -
> -	lock_extent_bits(io_tree, lockstart, lockend, &cached_state);
> -	ordered =3D btrfs_lookup_ordered_range(inode, lockstart, len);
> -	if (ordered) {
> -		btrfs_put_ordered_extent(ordered);
> -		ret =3D 1;
> -		goto out_unlock;
> -	}
> -
> -	em =3D btrfs_get_extent(inode, NULL, 0, start, len, 0);
> -	if (IS_ERR(em)) {
> -		ret =3D PTR_ERR(em);
> -		goto out_unlock;
> -	}
> -
> -	/*
> -	 * This extent does not actually cover the logical extent anymore,
> -	 * move on to the next inode.
> -	 */
> -	if (em->block_start > logical ||
> -	    em->block_start + em->block_len < logical + len ||
> -	    test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
> -		free_extent_map(em);
> -		ret =3D 1;
> -		goto out_unlock;
> -	}
> -	free_extent_map(em);
> -
> -out_unlock:
> -	unlock_extent_cached(io_tree, lockstart, lockend, &cached_state);
> -	return ret;
> -}
> -
> -static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
> -				      struct scrub_copy_nocow_ctx *nocow_ctx)
> -{
> -	struct btrfs_fs_info *fs_info =3D nocow_ctx->sctx->fs_info;
> -	struct btrfs_key key;
> -	struct inode *inode;
> -	struct page *page;
> -	struct btrfs_root *local_root;
> -	struct extent_io_tree *io_tree;
> -	u64 physical_for_dev_replace;
> -	u64 nocow_ctx_logical;
> -	u64 len =3D nocow_ctx->len;
> -	unsigned long index;
> -	int srcu_index;
> -	int ret =3D 0;
> -	int err =3D 0;
> -
> -	key.objectid =3D root;
> -	key.type =3D BTRFS_ROOT_ITEM_KEY;
> -	key.offset =3D (u64)-1;
> -
> -	srcu_index =3D srcu_read_lock(&fs_info->subvol_srcu);
> -
> -	local_root =3D btrfs_read_fs_root_no_name(fs_info, &key);
> -	if (IS_ERR(local_root)) {
> -		srcu_read_unlock(&fs_info->subvol_srcu, srcu_index);
> -		return PTR_ERR(local_root);
> -	}
> -
> -	key.type =3D BTRFS_INODE_ITEM_KEY;
> -	key.objectid =3D inum;
> -	key.offset =3D 0;
> -	inode =3D btrfs_iget(fs_info->sb, &key, local_root, NULL);
> -	srcu_read_unlock(&fs_info->subvol_srcu, srcu_index);
> -	if (IS_ERR(inode))
> -		return PTR_ERR(inode);
> -
> -	/* Avoid truncate/dio/punch hole.. */
> -	inode_lock(inode);
> -	inode_dio_wait(inode);
> -
> -	physical_for_dev_replace =3D nocow_ctx->physical_for_dev_replace;
> -	io_tree =3D &BTRFS_I(inode)->io_tree;
> -	nocow_ctx_logical =3D nocow_ctx->logical;
> -
> -	ret =3D check_extent_to_block(BTRFS_I(inode), offset, len,
> -			nocow_ctx_logical);
> -	if (ret) {
> -		ret =3D ret > 0 ? 0 : ret;
> -		goto out;
> -	}
> -
> -	while (len >=3D PAGE_SIZE) {
> -		index =3D offset >> PAGE_SHIFT;
> -again:
> -		page =3D find_or_create_page(inode->i_mapping, index, GFP_NOFS);
> -		if (!page) {
> -			btrfs_err(fs_info, "find_or_create_page() failed");
> -			ret =3D -ENOMEM;
> -			goto out;
> -		}
> -
> -		if (PageUptodate(page)) {
> -			if (PageDirty(page))
> -				goto next_page;
> -		} else {
> -			ClearPageError(page);
> -			err =3D extent_read_full_page(io_tree, page,
> -							   btrfs_get_extent,
> -							   nocow_ctx->mirror_num);
> -			if (err) {
> -				ret =3D err;
> -				goto next_page;
> -			}
> -
> -			lock_page(page);
> -			/*
> -			 * If the page has been remove from the page cache,
> -			 * the data on it is meaningless, because it may be
> -			 * old one, the new data may be written into the new
> -			 * page in the page cache.
> -			 */
> -			if (page->mapping !=3D inode->i_mapping) {
> -				unlock_page(page);
> -				put_page(page);
> -				goto again;
> -			}
> -			if (!PageUptodate(page)) {
> -				ret =3D -EIO;
> -				goto next_page;
> -			}
> -		}
> -
> -		ret =3D check_extent_to_block(BTRFS_I(inode), offset, len,
> -					    nocow_ctx_logical);
> -		if (ret) {
> -			ret =3D ret > 0 ? 0 : ret;
> -			goto next_page;
> -		}
> -
> -		err =3D write_page_nocow(nocow_ctx->sctx,
> -				       physical_for_dev_replace, page);
> -		if (err)
> -			ret =3D err;
> -next_page:
> -		unlock_page(page);
> -		put_page(page);
> -
> -		if (ret)
> -			break;
> -
> -		offset +=3D PAGE_SIZE;
> -		physical_for_dev_replace +=3D PAGE_SIZE;
> -		nocow_ctx_logical +=3D PAGE_SIZE;
> -		len -=3D PAGE_SIZE;
> -	}
> -	ret =3D COPY_COMPLETE;
> -out:
> -	inode_unlock(inode);
> -	iput(inode);
> -	return ret;
> -}
> -
> -static int write_page_nocow(struct scrub_ctx *sctx,
> -			    u64 physical_for_dev_replace, struct page *page)
> -{
> -	struct bio *bio;
> -	struct btrfs_device *dev;
> -
> -	dev =3D sctx->wr_tgtdev;
> -	if (!dev)
> -		return -EIO;
> -	if (!dev->bdev) {
> -		btrfs_warn_rl(dev->fs_info,
> -			"scrub write_page_nocow(bdev =3D=3D NULL) is unexpected");
> -		return -EIO;
> -	}
> -	bio =3D btrfs_io_bio_alloc(1);
> -	bio->bi_iter.bi_size =3D 0;
> -	bio->bi_iter.bi_sector =3D physical_for_dev_replace >> 9;
> -	bio_set_dev(bio, dev->bdev);
> -	bio->bi_opf =3D REQ_OP_WRITE | REQ_SYNC;
> -	/* bio_add_page won't fail on a freshly allocated bio */
> -	bio_add_page(bio, page, PAGE_SIZE, 0);
> -
> -	if (btrfsic_submit_bio_wait(bio)) {
> -		bio_put(bio);
> -		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
> -		return -EIO;
> -	}
> -
> -	bio_put(bio);
> -	return 0;
> -}
>=20


--vw9Ny5lwSRrfDFaIfpMIlsev4FLrKqRXs--

--ubCXMFPMrtGNFm5lEreJSsMJMF4rmyMpQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsWIMsACgkQwj2R86El
/qhDbgf+NVwLHdKHTtGZEVdtJop8x75ZWktgANnN/RL+MskPcvAHLalujBqr5s6s
NBHigBpjIas1jaF2dYVk04VchAJU9VRUsrUuzmGc4oHUBEL5/CemLqdY7xMNl0nq
/lTS1uHAlYqvQDRzBgDzhsQGQciDkuyxxxEo2tzJRebDPOiCUJ8Y1H36ccbuplQ1
L+IglxoZ3l+bEohxbL3R6vt27tFUayl9B+60/CTu9rnAVYCT9cNJAWLZW4tUtGGQ
lctzZAITVfdDww2dcZfuQQ/UosxAXBhoDI0RQcSA6A/ohwZ4RVed1kK4stmdInMK
eAZfBBj9B2kFy0Wq/vQkjgf2OgvK9Q==
=jEtx
-----END PGP SIGNATURE-----

--ubCXMFPMrtGNFm5lEreJSsMJMF4rmyMpQ--
