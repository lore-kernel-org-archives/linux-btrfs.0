Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4309B849C
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 22:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776118665; cv=none; b=bVQ1ECyeqz4mVt0R4PthvjQdBKxH+cxQVZUHSHxzOOrAc+ceGP6jpTIhZ1JVKhGg2uRdv+jYTKImwhBbKDOn/m2Q946VyRNXhYr2IR38ADY7vf5x6fC6ab8EpiYMaO3/UtoIBQ1MQVZPnFRQxTQ5gzLY+0Q9o2kEx31wF7C/1AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776118665; c=relaxed/simple;
	bh=14UunH0ddenvtH+XE6/6+z6865Cy9I3zl2WPek2gNrE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=f7nBednVb2lA4uOiocEPNI5prp/yc0NtueuDgiT6/QMbuILYLiIcTo5X/pZ7E/X0X6D0Hxqx8fNwrA7MMmgqL0429LWiJ2xERxlGDkOcFUWYi2zerZp17quZey0/fp3G7H/aLV+b95JWrqOTd2ccC1ij3fePk+KLTgW6n1mhqKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=qOHkLYHo; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="qOHkLYHo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1776118659; x=1776723459; i=quwenruo.btrfs@gmx.com;
	bh=0munhgyHVt9aNepbnMHVlydgjRx1hiuzDpqnIvlEiOY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=qOHkLYHoYcdgBVeD+QC1htMMHpq9+VG9J0COg3KhegrqLdGCsoB8DknGXCDpQMMS
	 yKRGvI1U90F1QaZG9CayctxAITROasGXQo/FL8tW1y+dncSQycrygkg+svrm2waz8
	 tf0KhJ1fZj6vL4DpFDVab5/CnRXIcxDW8i7zcrR014eobuHnlKjYTy6dS8vh3ksX4
	 2k49zlPgasCJzXf8OVDNaa9slJBt2yeT6MJsagj+B1rrYE2L6VtgSWMs8pUZbu3we
	 AtTDbILyJBaP0XHwco0UsmDPKbVvEfTngiGwj+ku3iJMgjwNoxeUl2G6eFOtl5Fxw
	 FcCt9ptLYjQdEc216g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MwQXN-1vKJPT2jsD-00vt1f; Tue, 14
 Apr 2026 00:17:39 +0200
Message-ID: <a8a06d0f-4ef8-4954-83ff-468668843b3c@gmx.com>
Date: Tue, 14 Apr 2026 07:47:34 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org,
 wqu@suse.com, boris@bur.io
References: <20260413171440.116041-1-mark@harmstone.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <20260413171440.116041-1-mark@harmstone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:g6Jl7T60oAof0F+JvmQY0KlPnnmMnJLsEOwv5EY/XqEWDDT2jRB
 2K4d0lkTD6bJ0WZjghOBhXz4mt72B5hqNKSN/eCDuXA+xY3gkcZELIEpqVYR95p1nLQaoYh
 tUZmMOa8Ht7A5zNs2xMAFqBSmbSNKTgGicE8A3QjkWDMEIIsrgi+EnxiHzEju3jXIhPSQwZ
 p8Kvp876YuGjjLlMU7GSA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:lVaxIinX1N4=;i6y4GrqHxEBhbd0LYvknSs+pLpA
 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



=E5=9C=A8 2026/4/14 02:44, Mark Harmstone =E5=86=99=E9=81=93:
> Add a new unprivileged BTRFS_IOC_GET_CSUMS ioctl, which can be used to
> query the on-disk csums for a file.
>=20
> The ioctl is deliberately per-file rather than exposing raw csum tree
> lookups, to avoid leaking information to users about files they may not
> have access to.
>=20
> This is done by userspace passing a struct btrfs_ioctl_get_csums_args to
> the kernel, which details the offset and length we're interested in, and
> a buffer for the kernel to write its results into. The kernel writes a
> struct btrfs_ioctl_get_csums_entry into the buffer, followed by the
> csums if available.
>=20
> If the extent is an uncompressed, non-nodatasum extent, the kernel sets
> the entry type to BTRFS_GET_CSUMS_HAS_CSUMS and follows it with the
> csums. If it is sparse, preallocated, or beyond the EOF, it sets the
> type to BTRFS_GET_CSUMS_ZEROED - this is so userspace knows it can use
> the precomputed hash of the zero sector. Otherwise, it sets the type to
> BTRFS_GET_CSUMS_NODATASUM, BTRFS_GET_CSUMS_COMPRESSED,
> BTRFS_GET_CSUM_ENCRYPTED, or BTRFS_GET_CSUM_INLINE.
>=20
> For example, a file with a [0, 4K) hole and [4K, 12K) data extent would
> produce the following output buffer:
>=20
>    | [0, 4K) ZEROED | [4K, 12K) HAS_CSUMS | csum data |
>=20
> We do store the csums of compressed extents, but we deliberately don't
> return them here: they're hashed over the compressed data, not the
> uncompressed data that's returned to userspace. Similarly for encrypted
> data, once encryption is supported, in which the csums will be on the
> ciphertext.
>=20
> The main use case for this is for speeding up mkfs.btrfs --rootdir. For
> the case when the source FS is btrfs and using the same csum algorithm,
> we can avoid having to recalculate the csums - in my synthetic
> benchmarks (16GB file on a spinning-rust drive), this resulted in a ~11%
> speed-up (218s to 196s).
>=20
> When using the --reflink option added in btrfs-progs v6.16.1, we can for=
go
> reading the data entirely, resulting a ~2200% speed-up on the same test
> (128s to 6s).
>=20
>      # mkdir rootdir
>      # dd if=3D/dev/urandom of=3Drootdir/file bs=3D4096 count=3D4194304
>=20
>      (without ioctl)
>      # echo 3 > /proc/sys/vm/drop_caches
>      # time mkfs.btrfs --rootdir rootdir testimg
>      ...
>      real    3m37.965s
>      user    0m5.496s
>      sys     0m6.125s
>=20
>      # echo 3 > /proc/sys/vm/drop_caches
>      # time mkfs.btrfs --rootdir rootdir --reflink testimg
>      ...
>      real    2m8.342s
>      user    0m5.472s
>      sys     0m1.667s
>=20
>      (with ioctl)
>      # echo 3 > /proc/sys/vm/drop_caches
>      # time mkfs.btrfs --rootdir rootdir testimg
>      ...
>      real    3m15.865s
>      user    0m4.258s
>      sys     0m6.261s
>=20
>      # echo 3 > /proc/sys/vm/drop_caches
>      # time mkfs.btrfs --rootdir rootdir --reflink testimg
>      ...
>      real    0m5.847s
>      user    0m2.899s
>      sys     0m0.097s
>=20
> Signed-off-by: Mark Harmstone <mark@harmstone.com>

Looks good to me for the current usage.

Reviewed-by: Qu Wenruo <wqu@suse.com>


Although the discussion about encryption makes me wonder if=20
btrfs_ioctl_get_csums_entry::type should be bit flags.

For now it's fine, but as Daniel mentioned, in the future we may want to=
=20
return the csum of such encrypted/compressed data.
In that case we need extra checks on the @flags to determine if=20
ENCRYPTED/COMPRESSED is followed by a csum or not.

If @type is bit flags, we can easily have things like=20
COMPRESSED|HAS_CSUM to indicate that future change.

Feel free to ignore this, it's just making the future expansion easier,=20
not critical and we can definitely find a way using the new @flags to=20
handle future change.

Thanks,
Qu

> ---
> Changes since v2:
>   * Added flags field to args for future expansion, must be 0 for now
>   * Added check that extent isn't encrypted
>   * Split NO_CSUMS into multiple reasons, as this is cheap and userspace
>     might find it useful: COMPRESSED, ENCRYPTED, NODATASUM, and INLINE
>   * Changed to use SZ_16M macro
>=20
>   fs/btrfs/ioctl.c           | 337 +++++++++++++++++++++++++++++++++++++
>   include/uapi/linux/btrfs.h |  25 +++
>   2 files changed, 362 insertions(+)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index b2e447f5005c16..cb37d793dbceff 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -56,6 +56,7 @@
>   #include "uuid-tree.h"
>   #include "ioctl.h"
>   #include "file.h"
> +#include "file-item.h"
>   #include "scrub.h"
>   #include "super.h"
>  =20
> @@ -5139,6 +5140,340 @@ static int btrfs_ioctl_shutdown(struct btrfs_fs_=
info *fs_info, unsigned long arg
>   }
>   #endif
>  =20
> +#define GET_CSUMS_BUF_MAX	SZ_16M
> +
> +static int copy_csums_to_user(struct btrfs_fs_info *fs_info, u64 disk_b=
ytenr,
> +			      u64 len, u8 __user *buf)
> +{
> +	struct btrfs_root *csum_root;
> +	struct btrfs_ordered_sum *sums;
> +	LIST_HEAD(list);
> +	const u32 csum_size =3D fs_info->csum_size;
> +	int ret;
> +
> +	csum_root =3D btrfs_csum_root(fs_info, disk_bytenr);
> +
> +	ret =3D btrfs_lookup_csums_list(csum_root, disk_bytenr,
> +				      disk_bytenr + len - 1, &list, false);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Clear the output buffer to handle potential gaps in csum coverage. =
*/
> +	if (clear_user(buf, (len >> fs_info->sectorsize_bits) * csum_size)) {
> +		ret =3D -EFAULT;
> +		goto out;
> +	}
> +
> +	ret =3D 0;
> +	while (!list_empty(&list)) {
> +		u64 offset;
> +		size_t copy_size;
> +
> +		sums =3D list_first_entry(&list, struct btrfs_ordered_sum, list);
> +		list_del(&sums->list);
> +
> +		offset =3D ((sums->logical - disk_bytenr) >> fs_info->sectorsize_bits=
) * csum_size;
> +		copy_size =3D (sums->len >> fs_info->sectorsize_bits) * csum_size;
> +
> +		if (copy_to_user(buf + offset, sums->sums, copy_size)) {
> +			kfree(sums);
> +			ret =3D -EFAULT;
> +			goto out;
> +		}
> +
> +		kfree(sums);
> +	}
> +
> +out:
> +	while (!list_empty(&list)) {
> +		sums =3D list_first_entry(&list, struct btrfs_ordered_sum, list);
> +		list_del(&sums->list);
> +		kfree(sums);
> +	}
> +	return ret;
> +}
> +
> +static int btrfs_ioctl_get_csums(struct file *file, void __user *argp)
> +{
> +	struct inode *inode =3D file_inode(file);
> +	struct btrfs_inode *bi =3D BTRFS_I(inode);
> +	struct btrfs_fs_info *fs_info =3D bi->root->fs_info;
> +	struct btrfs_root *root =3D bi->root;
> +	struct btrfs_ioctl_get_csums_args args;
> +	BTRFS_PATH_AUTO_FREE(path);
> +	const u64 ino =3D btrfs_ino(bi);
> +	const u32 sectorsize =3D fs_info->sectorsize;
> +	const u32 csum_size =3D fs_info->csum_size;
> +	u8 __user *ubuf;
> +	u64 buf_limit;
> +	u64 buf_used =3D 0;
> +	u64 cur_offset;
> +	u64 end_offset;
> +	u64 prev_extent_end;
> +	struct btrfs_key key;
> +	int ret;
> +
> +	if (!(file->f_mode & FMODE_READ))
> +		return -EBADF;
> +
> +	if (!S_ISREG(inode->i_mode))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&args, argp, sizeof(args)))
> +		return -EFAULT;
> +
> +	if (!IS_ALIGNED(args.offset, sectorsize) ||
> +	    !IS_ALIGNED(args.length, sectorsize))
> +		return -EINVAL;
> +	if (args.length =3D=3D 0)
> +		return -EINVAL;
> +	if (args.offset + args.length < args.offset)
> +		return -EOVERFLOW;
> +	if (args.flags !=3D 0)
> +		return -EINVAL;
> +	if (args.buf_size < sizeof(struct btrfs_ioctl_get_csums_entry))
> +		return -EINVAL;
> +
> +	buf_limit =3D min_t(u64, args.buf_size, GET_CSUMS_BUF_MAX);
> +	ubuf =3D (u8 __user *)(argp + offsetof(struct btrfs_ioctl_get_csums_ar=
gs, buf));
> +	cur_offset =3D args.offset;
> +	end_offset =3D args.offset + args.length;
> +
> +	path =3D btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	ret =3D btrfs_wait_ordered_range(bi, cur_offset, args.length);
> +	if (ret)
> +		return ret;
> +
> +	btrfs_inode_lock(bi, BTRFS_ILOCK_SHARED);
> +
> +	ret =3D btrfs_wait_ordered_range(bi, cur_offset, args.length);
> +	if (ret)
> +		goto out_unlock;
> +
> +	/* NODATASUM early exit. */
> +	if (bi->flags & BTRFS_INODE_NODATASUM) {
> +		struct btrfs_ioctl_get_csums_entry entry =3D {
> +			.offset =3D cur_offset,
> +			.length =3D end_offset - cur_offset,
> +			.type =3D BTRFS_GET_CSUMS_NODATASUM,
> +		};
> +
> +		if (copy_to_user(ubuf, &entry, sizeof(entry))) {
> +			ret =3D -EFAULT;
> +			goto out_unlock;
> +		}
> +
> +		buf_used =3D sizeof(entry);
> +		cur_offset =3D end_offset;
> +		goto done;
> +	}
> +
> +	prev_extent_end =3D cur_offset;
> +
> +	while (cur_offset < end_offset) {
> +		struct btrfs_file_extent_item *ei;
> +		struct extent_buffer *leaf;
> +		struct btrfs_ioctl_get_csums_entry entry;
> +		u64 extent_end;
> +		u64 disk_bytenr =3D 0;
> +		u64 extent_offset =3D 0;
> +		u64 range_start, range_len;
> +		u64 entry_csum_size;
> +		u64 key_offset;
> +		int extent_type;
> +		u8 compression;
> +		u8 encryption;
> +
> +		/* Search for the extent at or before cur_offset. */
> +		key.objectid =3D ino;
> +		key.type =3D BTRFS_EXTENT_DATA_KEY;
> +		key.offset =3D cur_offset;
> +
> +		ret =3D btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +		if (ret < 0)
> +			goto out_unlock;
> +
> +		if (ret > 0 && path->slots[0] > 0) {
> +			btrfs_item_key_to_cpu(path->nodes[0], &key,
> +					      path->slots[0] - 1);
> +			if (key.objectid =3D=3D ino &&
> +			    key.type =3D=3D BTRFS_EXTENT_DATA_KEY) {
> +				path->slots[0]--;
> +				if (btrfs_file_extent_end(path) <=3D cur_offset)
> +					path->slots[0]++;
> +			}
> +		}
> +
> +		if (path->slots[0] >=3D btrfs_header_nritems(path->nodes[0])) {
> +			ret =3D btrfs_next_leaf(root, path);
> +			if (ret < 0)
> +				goto out_unlock;
> +			if (ret > 0) {
> +				ret =3D 0;
> +				btrfs_release_path(path);
> +				break;
> +			}
> +		}
> +
> +		leaf =3D path->nodes[0];
> +
> +		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
> +		if (key.objectid !=3D ino || key.type !=3D BTRFS_EXTENT_DATA_KEY) {
> +			btrfs_release_path(path);
> +			break;
> +		}
> +
> +		extent_end =3D btrfs_file_extent_end(path);
> +		key_offset =3D key.offset;
> +
> +		/* Read extent fields before releasing the path. */
> +		ei =3D btrfs_item_ptr(leaf, path->slots[0],
> +				    struct btrfs_file_extent_item);
> +		extent_type =3D btrfs_file_extent_type(leaf, ei);
> +		compression =3D btrfs_file_extent_compression(leaf, ei);
> +		encryption =3D btrfs_file_extent_encryption(leaf, ei);
> +
> +		if (extent_type !=3D BTRFS_FILE_EXTENT_INLINE) {
> +			disk_bytenr =3D btrfs_file_extent_disk_bytenr(leaf, ei);
> +			if (disk_bytenr && compression =3D=3D BTRFS_COMPRESS_NONE)
> +				extent_offset =3D btrfs_file_extent_offset(leaf, ei);
> +		}
> +
> +		btrfs_release_path(path);
> +
> +		/* Implicit hole (NO_HOLES feature). */
> +		if (prev_extent_end < key_offset) {
> +			u64 hole_end =3D min(key_offset, end_offset);
> +			u64 hole_len =3D hole_end - prev_extent_end;
> +
> +			if (prev_extent_end >=3D cur_offset) {
> +				memset(&entry, 0, sizeof(entry));
> +				entry.offset =3D prev_extent_end;
> +				entry.length =3D hole_len;
> +				entry.type =3D BTRFS_GET_CSUMS_ZEROED;
> +
> +				if (buf_used + sizeof(entry) > buf_limit)
> +					goto done;
> +				if (copy_to_user(ubuf + buf_used, &entry,
> +						 sizeof(entry))) {
> +					ret =3D -EFAULT;
> +					goto out_unlock;
> +				}
> +				buf_used +=3D sizeof(entry);
> +				cur_offset =3D hole_end;
> +			}
> +
> +			if (key_offset >=3D end_offset) {
> +				cur_offset =3D end_offset;
> +				break;
> +			}
> +		}
> +
> +		/* Clamp to our query range. */
> +		range_start =3D max(cur_offset, key_offset);
> +		range_len =3D min(extent_end, end_offset) - range_start;
> +
> +		memset(&entry, 0, sizeof(entry));
> +		entry.offset =3D range_start;
> +		entry.length =3D range_len;
> +
> +		if (extent_type =3D=3D BTRFS_FILE_EXTENT_INLINE) {
> +			entry.type =3D BTRFS_GET_CSUMS_INLINE;
> +			entry_csum_size =3D 0;
> +		} else if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC) {
> +			entry.type =3D BTRFS_GET_CSUMS_ZEROED;
> +			entry_csum_size =3D 0;
> +		} else {
> +			/* BTRFS_FILE_EXTENT_REG */
> +			if (disk_bytenr =3D=3D 0) {
> +				/* Explicit hole. */
> +				entry.type =3D BTRFS_GET_CSUMS_ZEROED;
> +				entry_csum_size =3D 0;
> +			} else if (encryption !=3D 0) {
> +				entry.type =3D BTRFS_GET_CSUMS_ENCRYPTED;
> +				entry_csum_size =3D 0;
> +			} else if (compression !=3D BTRFS_COMPRESS_NONE) {
> +				entry.type =3D BTRFS_GET_CSUMS_COMPRESSED;
> +				entry_csum_size =3D 0;
> +			} else {
> +				entry.type =3D BTRFS_GET_CSUMS_HAS_CSUMS;
> +				entry_csum_size =3D (range_len >> fs_info->sectorsize_bits) * csum_=
size;
> +			}
> +		}
> +
> +		/* Check if this entry (+ csum data) fits in the buffer. */
> +		if (buf_used + sizeof(entry) + entry_csum_size > buf_limit) {
> +			if (buf_used =3D=3D 0) {
> +				ret =3D -EOVERFLOW;
> +				goto out_unlock;
> +			}
> +			goto done;
> +		}
> +
> +		if (copy_to_user(ubuf + buf_used, &entry, sizeof(entry))) {
> +			ret =3D -EFAULT;
> +			goto out_unlock;
> +		}
> +		buf_used +=3D sizeof(entry);
> +
> +		if (entry.type =3D=3D BTRFS_GET_CSUMS_HAS_CSUMS) {
> +			ret =3D copy_csums_to_user(fs_info,
> +				disk_bytenr + extent_offset + (range_start - key_offset),
> +				range_len, ubuf + buf_used);
> +			if (ret)
> +				goto out_unlock;
> +			buf_used +=3D entry_csum_size;
> +		}
> +
> +		cur_offset =3D range_start + range_len;
> +		prev_extent_end =3D extent_end;
> +
> +		if (fatal_signal_pending(current)) {
> +			if (buf_used =3D=3D 0) {
> +				ret =3D -EINTR;
> +				goto out_unlock;
> +			}
> +			goto done;
> +		}
> +
> +		cond_resched();
> +	}
> +
> +	/* Handle trailing implicit hole. */
> +	if (cur_offset < end_offset) {
> +		struct btrfs_ioctl_get_csums_entry entry =3D {
> +			.offset =3D prev_extent_end,
> +			.length =3D end_offset - prev_extent_end,
> +			.type =3D BTRFS_GET_CSUMS_ZEROED,
> +		};
> +
> +		if (buf_used + sizeof(entry) <=3D buf_limit) {
> +			if (copy_to_user(ubuf + buf_used, &entry,
> +					 sizeof(entry))) {
> +				ret =3D -EFAULT;
> +				goto out_unlock;
> +			}
> +			buf_used +=3D sizeof(entry);
> +			cur_offset =3D end_offset;
> +		}
> +	}
> +
> +done:
> +	args.offset =3D cur_offset;
> +	args.length =3D (cur_offset < end_offset) ? end_offset - cur_offset : =
0;
> +	args.buf_size =3D buf_used;
> +
> +	if (copy_to_user(argp, &args, sizeof(args)))
> +		ret =3D -EFAULT;
> +
> +out_unlock:
> +	btrfs_inode_unlock(bi, BTRFS_ILOCK_SHARED);
> +	return ret;
> +}
> +
>   long btrfs_ioctl(struct file *file, unsigned int
>   		cmd, unsigned long arg)
>   {
> @@ -5294,6 +5629,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>   #endif
>   	case BTRFS_IOC_SUBVOL_SYNC_WAIT:
>   		return btrfs_ioctl_subvol_sync(fs_info, argp);
> +	case BTRFS_IOC_GET_CSUMS:
> +		return btrfs_ioctl_get_csums(file, argp);
>   #ifdef CONFIG_BTRFS_EXPERIMENTAL
>   	case BTRFS_IOC_SHUTDOWN:
>   		return btrfs_ioctl_shutdown(fs_info, arg);
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 9165154a274d94..9b24218682990d 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -1100,6 +1100,29 @@ enum btrfs_err_code {
>   	BTRFS_ERROR_DEV_RAID1C4_MIN_NOT_MET,
>   };
>  =20
> +/* Types for struct btrfs_ioctl_get_csums_entry::type */
> +#define BTRFS_GET_CSUMS_HAS_CSUMS	0
> +#define BTRFS_GET_CSUMS_ZEROED		1
> +#define BTRFS_GET_CSUMS_NODATASUM	2
> +#define BTRFS_GET_CSUMS_COMPRESSED	3
> +#define BTRFS_GET_CSUMS_ENCRYPTED	4
> +#define BTRFS_GET_CSUMS_INLINE		5
> +
> +struct btrfs_ioctl_get_csums_entry {
> +	__u64 offset;		/* file offset of this range */
> +	__u64 length;		/* length in bytes */
> +	__u32 type;		/* BTRFS_GET_CSUMS_* type */
> +	__u32 reserved;		/* padding, must be 0 */
> +};
> +
> +struct btrfs_ioctl_get_csums_args {
> +	__u64 offset;		/* in/out: file offset */
> +	__u64 length;		/* in/out: range length */
> +	__u64 buf_size;		/* in/out: buffer capacity / bytes written */
> +	__u64 flags;		/* in: flags, must be 0 for now */
> +	__u8 buf[];		/* out: entries + csum data */
> +};
> +
>   /* Flags for IOC_SHUTDOWN, must match XFS_FSOP_GOING_FLAGS_* flags. */
>   #define BTRFS_SHUTDOWN_FLAGS_DEFAULT			0x0
>   #define BTRFS_SHUTDOWN_FLAGS_LOGFLUSH			0x1
> @@ -1226,6 +1249,8 @@ enum btrfs_err_code {
>   				     struct btrfs_ioctl_encoded_io_args)
>   #define BTRFS_IOC_SUBVOL_SYNC_WAIT _IOW(BTRFS_IOCTL_MAGIC, 65, \
>   					struct btrfs_ioctl_subvol_wait)
> +#define BTRFS_IOC_GET_CSUMS _IOWR(BTRFS_IOCTL_MAGIC, 66, \
> +				  struct btrfs_ioctl_get_csums_args)
>  =20
>   /* Shutdown ioctl should follow XFS's interfaces, thus not using btrfs=
 magic. */
>   #define BTRFS_IOC_SHUTDOWN	_IOR('X', 125, __u32)

