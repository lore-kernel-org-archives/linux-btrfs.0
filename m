Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52165 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbeH1LKu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 07:10:50 -0400
Subject: Re: [PATCH RFC] btrfs: clone: Flush data before doing clone
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180828055453.2353-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e212e8be-01eb-4451-69e4-10a312849fb0@gmx.com>
Date: Tue, 28 Aug 2018 15:20:21 +0800
MIME-Version: 1.0
In-Reply-To: <20180828055453.2353-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="q9s2XgMclc77OkUe8ZbvHFSLaIW1tBP09"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q9s2XgMclc77OkUe8ZbvHFSLaIW1tBP09
Content-Type: multipart/mixed; boundary="UKByl8It1Rw4KVToRTJJt2ccQxW33fldx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <e212e8be-01eb-4451-69e4-10a312849fb0@gmx.com>
Subject: Re: [PATCH RFC] btrfs: clone: Flush data before doing clone
References: <20180828055453.2353-1-wqu@suse.com>
In-Reply-To: <20180828055453.2353-1-wqu@suse.com>

--UKByl8It1Rw4KVToRTJJt2ccQxW33fldx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/28 =E4=B8=8B=E5=8D=881:54, Qu Wenruo wrote:
> Due to the limitation of btrfs_cross_ref_exist(), run_delalloc_nocow()
> can still fall back to CoW even only (unrelated) part of the
> preallocated extent is shared.
>=20
> This makes the follow case to do unnecessary CoW:
>=20
>  # xfs_io -f -c "falloc 0 2M" $mnt/file
>  # xfs_io -c "pwrite 0 1M" $mnt/file
>  # xfs_io -c "reflink $mnt/file 1M 4M 1M" $mnt/file
>  # sync
>=20
> The pwrite will still be CoWed, since at writeback time, the
> preallocated extent is already shared, btrfs_cross_ref_exist() will
> return 1 and make run_delalloc_nocow() fall back to cow_file_range().
>=20
> This is definitely an overkilling workaround, but this should be the
> simplest way without further screwing up already complex NOCOW routine.=


Err, this is not even a working workaround.

It could still lead to bytes_may_use underflow as long as
btrfs_cross_ref_exist() could return 1 for partly shared prealloc extent.=


So please ignore this patch.

Thanks,
Qu

>=20
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/ctree.h |  1 +
>  fs/btrfs/file.c  |  4 ++--
>  fs/btrfs/ioctl.c | 21 +++++++++++++++++++++
>  3 files changed, 24 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 53af9f5253f4..ddacc41ff124 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3228,6 +3228,7 @@ int btrfs_add_inode_defrag(struct btrfs_trans_han=
dle *trans,
>  			   struct btrfs_inode *inode);
>  int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info);
>  void btrfs_cleanup_defrag_inodes(struct btrfs_fs_info *fs_info);
> +int btrfs_start_ordered_ops(struct inode *inode, loff_t start, loff_t =
end);
>  int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int d=
atasync);
>  void btrfs_drop_extent_cache(struct btrfs_inode *inode, u64 start, u64=
 end,
>  			     int skip_pinned);
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 2be00e873e92..118bfd019c6c 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1999,7 +1999,7 @@ int btrfs_release_file(struct inode *inode, struc=
t file *filp)
>  	return 0;
>  }
> =20
> -static int start_ordered_ops(struct inode *inode, loff_t start, loff_t=
 end)
> +int btrfs_start_ordered_ops(struct inode *inode, loff_t start, loff_t =
end)
>  {
>  	int ret;
>  	struct blk_plug plug;
> @@ -2056,7 +2056,7 @@ int btrfs_sync_file(struct file *file, loff_t sta=
rt, loff_t end, int datasync)
>  	 * multi-task, and make the performance up.  See
>  	 * btrfs_wait_ordered_range for an explanation of the ASYNC check.
>  	 */
> -	ret =3D start_ordered_ops(inode, start, end);
> +	ret =3D btrfs_start_ordered_ops(inode, start, end);
>  	if (ret)
>  		goto out;
> =20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 63600dc2ac4c..866979f530bc 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4266,6 +4266,27 @@ static noinline int btrfs_clone_files(struct fil=
e *file, struct file *file_src,
>  			goto out_unlock;
>  	}
> =20
> +	/*
> +	 * btrfs_cross_ref_exist() only does check at extent level,
> +	 * we could cause unexpected NOCOW write to be COWed.
> +	 * E.g.:
> +	 * falloc 0 2M file1
> +	 * pwrite 0 1M file1 (at this point it should go NOCOW)
> +	 * reflink src=3Dfile1 srcoff=3D1M dst=3Dfile1 dstoff=3D4M len=3D1M
> +	 * sync
> +	 *
> +	 * In above case, due to the preallocated extent is shared
> +	 * the data at 0~1M can't go NOCOW.
> +	 *
> +	 * So flush the whole src inode to avoid any unneeded CoW.
> +	 */
> +	ret =3D btrfs_start_ordered_ops(src, 0, -1);
> +	if (ret < 0)
> +		goto out_unlock;
> +	ret =3D btrfs_wait_ordered_range(src, 0, -1);
> +	if (ret < 0)
> +		goto out_unlock;
> +
>  	/*
>  	 * Lock the target range too. Right after we replace the file extent
>  	 * items in the fs tree (which now point to the cloned data), we migh=
t
>=20


--UKByl8It1Rw4KVToRTJJt2ccQxW33fldx--

--q9s2XgMclc77OkUe8ZbvHFSLaIW1tBP09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluE97UACgkQwj2R86El
/qiHcwf+OHXr9+mC0kOoDJKKJfcX8kF4K8B7GCP30JXUMdQ75w0AANRYX4DWsjyq
QLbeH5UpU0rZkdvqzLJhvHtJU7guEXugeqBGVURQlb/n9Kl0KdGjhlo0MhC3w/l7
VKccaCu7DWo3Y6/vk6I4ywR+80j1T96ZRoWK67TAPxk/yLAg8ZZyCSuK4f9ia0qi
RB/rZlCA6KixoXJu96B1WsUTgChOsfqiXKT+2IlLGuVnSoVQu3wAK7LXVVQyExF3
Y+3NAqs9CFtppmIshhqqotv/VHa237L39mzFlnhIkWw4PpL00J/Cr9g8syPtm+hS
BXCKuLaspNERxP9I+YzhQKxWOu+/zw==
=Iw3F
-----END PGP SIGNATURE-----

--q9s2XgMclc77OkUe8ZbvHFSLaIW1tBP09--
