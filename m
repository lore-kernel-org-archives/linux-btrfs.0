Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64125 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751835AbeBFB2Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Feb 2018 20:28:24 -0500
Subject: Re: [PATCH RFC] Btrfs: expose bad chunks in sysfs
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180205231502.12900-1-bo.li.liu@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1489ba8a-8cac-1a25-3dc5-9274bc96b5ef@gmx.com>
Date: Tue, 6 Feb 2018 09:28:14 +0800
MIME-Version: 1.0
In-Reply-To: <20180205231502.12900-1-bo.li.liu@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EaE6HG4vYEirxeXAPPlSdEXgSrZZhP0YS"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EaE6HG4vYEirxeXAPPlSdEXgSrZZhP0YS
Content-Type: multipart/mixed; boundary="iUzyS066IYG03cNgHRFdi4FgCJV3YSwDr";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <1489ba8a-8cac-1a25-3dc5-9274bc96b5ef@gmx.com>
Subject: Re: [PATCH RFC] Btrfs: expose bad chunks in sysfs
References: <20180205231502.12900-1-bo.li.liu@oracle.com>
In-Reply-To: <20180205231502.12900-1-bo.li.liu@oracle.com>

--iUzyS066IYG03cNgHRFdi4FgCJV3YSwDr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8806=E6=97=A5 07:15, Liu Bo wrote:
> Btrfs tries its best to tolerate write errors, but kind of silently
> (except some messages in kernel log).
>=20
> For raid1 and raid10, this is usually not a problem because there is a
> copy as backup, while for parity based raid setup, i.e. raid5 and
> raid6, the problem is that, if a write error occurs due to some bad
> sectors, one horizonal stripe becomes degraded and the number of write
> errors it can tolerate gets reduced by one, now if two disk fails,
> data may be lost forever.
>=20
> One way to mitigate the data loss pain is to expose 'bad chunks',
> i.e. degraded chunks, to users, so that they can use 'btrfs balance'
> to relocate the whole chunk and get the full raid6 protection again
> (if the relocation works).
>=20
> This introduces 'bad_chunks' in btrfs's per-fs sysfs directory.  Once
> a chunk of raid5 or raid6 becomes degraded, it will appear in
> 'bad_chunks'.

Sysfs looks good.

Although other systems uses their own interface to handle their status.
Mdadm uses /proc/mdstat to show such status, LVM uses lvdisplay/lvs.

So here comes to a new sys-fs interface.

>=20
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> - In this patch, 'bad chunks' is not persistent on disk, but it can be
>   added if it's thought to be a good idea.

IHMO such bad chunks list can be built using existing dev status at
mount time.

Although using dev status may cause extra problems like false alerts.

> - This is lightly tested, comments are very welcome.

Just checked the code, there are 2 concerns:

1) The way to remove bad chunk
   Currently it can only be removed when the chunk is removed.
   If any transient write error happened, the bad chunk will just be
   there forever (if not removed)

   It seems to cause false alert.

   And extra logic to determine if it's a real bad chunk in kernel seems
   a little complex and less flex.
   (Maybe an interface to info userspace where problem happens is more
    flex?)

2) Bad chunk is only added when writing
   Read routine should also be able to detect bad chunks, with better
   accuracy.

>=20
>  fs/btrfs/ctree.h       |  8 +++++++
>  fs/btrfs/disk-io.c     |  2 ++
>  fs/btrfs/extent-tree.c | 13 +++++++++++
>  fs/btrfs/raid56.c      | 59 ++++++++++++++++++++++++++++++++++++++++++=
++++++--
>  fs/btrfs/sysfs.c       | 26 ++++++++++++++++++++++
>  fs/btrfs/volumes.c     | 15 +++++++++++--
>  fs/btrfs/volumes.h     |  2 ++
>  7 files changed, 121 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 13c260b..08aad65 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1101,6 +1101,9 @@ struct btrfs_fs_info {
>  	spinlock_t ref_verify_lock;
>  	struct rb_root block_tree;
>  #endif
> +
> +	struct list_head bad_chunks;

Rbtree may be better here.

Since iterating a list to remove bad chunk can sometimes be slow.

> +	seqlock_t bc_lock;
>  };
> =20
>  static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
> @@ -2568,6 +2571,11 @@ static inline gfp_t btrfs_alloc_write_mask(struc=
t address_space *mapping)
> =20
>  /* extent-tree.c */
> =20
> +struct btrfs_bad_chunk {
> +	u64 chunk_offset;

It would be better to have chunk_size to info user.
Just chunk start won't tell user how serious the problem is.

And according to the code, any write error makes the chunk marked as
bad, no matter if the error can be tolerant.

It would be better if we have different error type, bad for error
intolerant, while degraded for some something tolerant.

Thanks,
Qu

> +	struct list_head list;
> +};
> +
>  enum btrfs_inline_ref_type {
>  	BTRFS_REF_TYPE_INVALID =3D	 0,
>  	BTRFS_REF_TYPE_BLOCK =3D		 1,
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index a8ecccf..061e7f94 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2568,6 +2568,8 @@ int open_ctree(struct super_block *sb,
>  	init_waitqueue_head(&fs_info->async_submit_wait);
> =20
>  	INIT_LIST_HEAD(&fs_info->pinned_chunks);
> +	INIT_LIST_HEAD(&fs_info->bad_chunks);
> +	seqlock_init(&fs_info->bc_lock);
> =20
>  	/* Usable values until the real ones are cached from the superblock *=
/
>  	fs_info->nodesize =3D 4096;
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 2f43285..3ca7cb4 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9903,6 +9903,19 @@ int btrfs_free_block_groups(struct btrfs_fs_info=
 *info)
>  		kobject_del(&space_info->kobj);
>  		kobject_put(&space_info->kobj);
>  	}
> +
> +	/* Clean up bad chunks. */
> +	write_seqlock_irq(&info->bc_lock);
> +	while (!list_empty(&info->bad_chunks)) {
> +		struct btrfs_bad_chunk *bc;
> +
> +		bc =3D list_first_entry(&info->bad_chunks,
> +				      struct btrfs_bad_chunk, list);
> +		list_del_init(&bc->list);
> +		kfree(bc);
> +	}
> +	write_sequnlock_irq(&info->bc_lock);
> +
>  	return 0;
>  }
> =20
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index a7f7925..e960247 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -888,14 +888,19 @@ static void rbio_orig_end_io(struct btrfs_raid_bi=
o *rbio, blk_status_t err)
>  }
> =20
>  /*
> - * end io function used by finish_rmw.  When we finally
> - * get here, we've written a full stripe
> + * end io function used by finish_rmw.  When we finally get here, we'v=
e written
> + * a full stripe.
> + *
> + * Note that this is not under interrupt context as we queued endio to=
 workers.
>   */
>  static void raid_write_end_io(struct bio *bio)
>  {
>  	struct btrfs_raid_bio *rbio =3D bio->bi_private;
>  	blk_status_t err =3D bio->bi_status;
>  	int max_errors;
> +	u64 stripe_start =3D rbio->bbio->raid_map[0];
> +	struct btrfs_fs_info *fs_info =3D rbio->fs_info;
> +	int err_cnt;
> =20
>  	if (err)
>  		fail_bio_stripe(rbio, bio);
> @@ -908,12 +913,58 @@ static void raid_write_end_io(struct bio *bio)
>  	err =3D BLK_STS_OK;
> =20
>  	/* OK, we have read all the stripes we need to. */
> +	err_cnt =3D atomic_read(&rbio->error);
>  	max_errors =3D (rbio->operation =3D=3D BTRFS_RBIO_PARITY_SCRUB) ?
>  		     0 : rbio->bbio->max_errors;
>  	if (atomic_read(&rbio->error) > max_errors)
>  		err =3D BLK_STS_IOERR;
> =20
>  	rbio_orig_end_io(rbio, err);
> +
> +	/*
> +	 * If there is any error, this stripe is a degraded one, so is the wh=
ole
> +	 * chunk, expose this chunk info to sysfs.
> +	 */
> +	if (unlikely(err_cnt)) {
> +		struct btrfs_bad_chunk *bc;
> +		struct btrfs_bad_chunk *tmp;
> +		struct extent_map *em;
> +		unsigned long flags;
> +
> +		em =3D get_chunk_map(fs_info, stripe_start, 1);
> +		if (IS_ERR(em))
> +			return;
> +
> +		bc =3D kzalloc(sizeof(*bc), GFP_NOFS);
> +		/* If allocation fails, it's OK. */
> +		if (!bc) {
> +			free_extent_map(em);
> +			return;
> +		}
> +
> +		write_seqlock_irqsave(&fs_info->bc_lock, flags);
> +		list_for_each_entry(tmp, &fs_info->bad_chunks, list) {
> +			if (tmp->chunk_offset !=3D em->start)
> +				continue;
> +
> +			/*
> +			 * Don't bother if this chunk has already been recorded.
> +			 */
> +			write_sequnlock_irqrestore(&fs_info->bc_lock, flags);
> +			kfree(bc);
> +			free_extent_map(em);
> +			return;
> +		}
> +
> +		/* Add new bad chunk to list. */
> +		bc->chunk_offset =3D em->start;
> +		free_extent_map(em);
> +
> +		INIT_LIST_HEAD(&bc->list);
> +		list_add(&bc->list, &fs_info->bad_chunks);
> +
> +		write_sequnlock_irqrestore(&fs_info->bc_lock, flags);
> +	}
>  }
> =20
>  /*
> @@ -1320,6 +1371,8 @@ static noinline void finish_rmw(struct btrfs_raid=
_bio *rbio)
>  		bio->bi_end_io =3D raid_write_end_io;
>  		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
> =20
> +		btrfs_bio_wq_end_io(rbio->fs_info, bio, BTRFS_WQ_ENDIO_RAID56);
> +
>  		submit_bio(bio);
>  	}
>  	return;
> @@ -2465,6 +2518,8 @@ static noinline void finish_parity_scrub(struct b=
trfs_raid_bio *rbio,
>  		bio->bi_end_io =3D raid_write_end_io;
>  		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
> =20
> +		btrfs_bio_wq_end_io(rbio->fs_info, bio, BTRFS_WQ_ENDIO_RAID56);
> +
>  		submit_bio(bio);
>  	}
>  	return;
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index a28bba8..0baaa33 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -490,12 +490,38 @@ static ssize_t quota_override_store(struct kobjec=
t *kobj,
> =20
>  BTRFS_ATTR_RW(, quota_override, quota_override_show, quota_override_st=
ore);
> =20
> +static ssize_t btrfs_bad_chunks_show(struct kobject *kobj,
> +				     struct kobj_attribute *a, char *buf)
> +{
> +	struct btrfs_fs_info *fs_info =3D to_fs_info(kobj);
> +	struct btrfs_bad_chunk *bc;
> +	int len =3D 0;
> +	unsigned int seq;
> +
> +	/* read lock please */
> +	do {
> +		seq =3D read_seqbegin(&fs_info->bc_lock);
> +		list_for_each_entry(bc, &fs_info->bad_chunks, list) {
> +			len +=3D snprintf(buf + len, PAGE_SIZE - len, "%llu\n",
> +					bc->chunk_offset);
> +			/* chunk offset is u64 */
> +			if (len >=3D PAGE_SIZE)
> +				break;
> +		}
> +	} while (read_seqretry(&fs_info->bc_lock, seq));
> +
> +	return len;
> +}
> +
> +BTRFS_ATTR(, bad_chunks, btrfs_bad_chunks_show);
> +
>  static const struct attribute *btrfs_attrs[] =3D {
>  	BTRFS_ATTR_PTR(, label),
>  	BTRFS_ATTR_PTR(, nodesize),
>  	BTRFS_ATTR_PTR(, sectorsize),
>  	BTRFS_ATTR_PTR(, clone_alignment),
>  	BTRFS_ATTR_PTR(, quota_override),
> +	BTRFS_ATTR_PTR(, bad_chunks),
>  	NULL,
>  };
> =20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a256842..d71f11a 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2803,8 +2803,8 @@ static int btrfs_del_sys_chunk(struct btrfs_fs_in=
fo *fs_info, u64 chunk_offset)
>  	return ret;
>  }
> =20
> -static struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,=

> -					u64 logical, u64 length)
> +struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,
> +				 u64 logical, u64 length)
>  {
>  	struct extent_map_tree *em_tree;
>  	struct extent_map *em;
> @@ -2840,6 +2840,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle =
*trans,
>  	u64 dev_extent_len =3D 0;
>  	int i, ret =3D 0;
>  	struct btrfs_fs_devices *fs_devices =3D fs_info->fs_devices;
> +	struct btrfs_bad_chunk *bc;
> =20
>  	em =3D get_chunk_map(fs_info, chunk_offset, 1);
>  	if (IS_ERR(em)) {
> @@ -2916,6 +2917,16 @@ int btrfs_remove_chunk(struct btrfs_trans_handle=
 *trans,
>  	}
> =20
>  out:
> +	write_seqlock_irq(&fs_info->bc_lock);
> +	list_for_each_entry(bc, &fs_info->bad_chunks, list) {
> +		if (bc->chunk_offset =3D=3D chunk_offset) {
> +			list_del_init(&bc->list);
> +			kfree(bc);
> +			break;
> +		}
> +	}
> +	write_sequnlock_irq(&fs_info->bc_lock);
> +
>  	/* once for us */
>  	free_extent_map(em);
>  	return ret;
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index ff15208..4e846ba 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -396,6 +396,8 @@ static inline enum btrfs_map_op btrfs_op(struct bio=
 *bio)
>  	}
>  }
> =20
> +struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,
> +				 u64 logical, u64 length);
>  int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 st=
art,
>  				   u64 end, u64 *length);
>  void btrfs_get_bbio(struct btrfs_bio *bbio);
>=20


--iUzyS066IYG03cNgHRFdi4FgCJV3YSwDr--

--EaE6HG4vYEirxeXAPPlSdEXgSrZZhP0YS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlp5BK4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhvpwf9HRpD73LI4aE6gPzmoJfoyjNj
2ksxWQH054qEPeeZX2M7wi0GJ6egLijT54QJ8oCkkNf71NZ9EPMsAgRTBgQYzHMV
OcZ44N29lPgkwDkA9LV8sL3c3KweOR0is6PCkeoq+JCARH5c2kDwPUI565R95TCt
qQbyrqlmHlSb84qxLzD2W5nt3N7M9eDoifEj6WLQSIxOWwjxC9ehuUwLE9caQ2qZ
HdIVpvpdnew671Ym/jSVNNlM8zTjJTdc3RfDRxvvfJf2+DhhlA0SsYVY5by4IQpX
iCTG4duDwsUX0mQSqixY7EzD+HFoiVccNQ4bNYlwnl3nD2Ry6vM2OIg1icLueQ==
=lQR9
-----END PGP SIGNATURE-----

--EaE6HG4vYEirxeXAPPlSdEXgSrZZhP0YS--
