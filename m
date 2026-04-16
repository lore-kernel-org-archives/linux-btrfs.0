Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF27838AC8A
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 21:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776374860; cv=none; b=Dqgxqp8+GGhnAwcuj51xH+831H1mhsPlBMDys7Wtz6ORqAD5MS58SYsKgil/PKoOTbIqY1jCrFbQzqU/pm+IJNaK+PA54WC7CWnVzY2oGjzekOfvFfpZW9ZmCBjawTgBK0e4JapA8nYRyxkxl4notUN+PM8lM2Zs4+JOpZZ66do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776374860; c=relaxed/simple;
	bh=DwA++zi68DltR6hoF0h37ep/4rKq/fXaRpI1hGoC6zk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Hd0YmbyqeisON4eUzuagsqFEnXDlQeMGuNYKY0tIVqQZDxxgOKDDn8GNPc4pgjcjhK67jAcfDCPJRFA3uDOaql+7oHlq4lcrZzZNrafcP35dFOZ+Xk9eJliPEo3WCfuCU1d8fvGxssQj1cZioHHC3kugZISbRg/QtRuKNgkPD5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=IAKVkzeC; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="IAKVkzeC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1776374855; x=1776979655; i=quwenruo.btrfs@gmx.com;
	bh=dH5k1praSRT77/TXMpjQbDHuQmj4nWtkB1Fqp2rDO9w=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=IAKVkzeCTdi3zJd+iFnX7K1VVVrgQ2AOGAc+Hgu3CLbfl2xDnm/MlbJ21RqE+BXG
	 S7OLynhFHGOS/ge6u3AU+FgG/I4vKgxhctmRv5QX08eE4oRx1ghf2kybcGFRUs/w5
	 Tiunl1DfezTLBuiXeu9zJAdDOxT1W4lNNDF+WsUfpB43KQLptpnBfaoKHvgxV6fgg
	 9uaPPhdsubMbyIdvIhKtEwwuSlKf+nHIQ7RUk3JJWWUxX3BKWnaqNfN8K4RNbZ/sG
	 0W070NvRZerhFWHBblPGyn347IhuFE6CszcRfxc5wL+k+otgTiNJfmYlvmv4PxWHn
	 SujNvuUKycg/i8CyzQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MLiCu-1vvopx46Hg-00XyP3; Thu, 16
 Apr 2026 23:27:35 +0200
Message-ID: <6f30349e-8ecf-42a7-a0ac-23f6a7b30c33@gmx.com>
Date: Fri, 17 Apr 2026 06:57:28 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org,
 wqu@suse.com, boris@bur.io, dsterba@suse.cz, fdmanana@kernel.org
References: <20260416180141.266457-1-mark@harmstone.com>
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
In-Reply-To: <20260416180141.266457-1-mark@harmstone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Pog1mVD7Mn9ZegDHNM6KODUu5jnQGTCGyXTIqKsf51vPnzRbtsj
 usM1J3xCs09dXU7H2UNCt8jGpU7JOHIWtg9laVslGRiocWRCXw8xH8l/PIptkZnJL3zLRff
 ckG0nyrOx2tUq6UEQRPgJzUAZ21W9U3mEd+UEKApSBfCzKNeqk3pyLdftF1LU6DT71qe+3l
 wVMm2FcDyMZSORrFbOquA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:6Zy7nx8RF68=;zJfpP9RE/cdAGLOpBRG6u7G5pic
 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
 wysYBuAnFkXlPdRhwACFTsZgrlfhEWIr/IGQ=



=E5=9C=A8 2026/4/17 03:31, Mark Harmstone =E5=86=99=E9=81=93:
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

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> Changes since v4:
> * Added check that csum_root isn't NULL
>=20
> Changes since v3:
> * Changed type to bit flags, so we can have e.g. COMPRESSED | ENCRYPTED
> * Made minor changes as requested by David Sterba
>=20
>   fs/btrfs/ioctl.c           | 346 +++++++++++++++++++++++++++++++++++++
>   include/uapi/linux/btrfs.h |  25 +++
>   2 files changed, 371 insertions(+)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a39460bf68a778..93046319711c7c 100644
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
> @@ -5140,6 +5141,349 @@ static int btrfs_ioctl_shutdown(struct btrfs_fs_=
info *fs_info, unsigned long arg
>   	return ret;
>   }
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
> +	if (unlikely(!csum_root)) {
> +		btrfs_err(fs_info,
> +			  "missing csum root for extent at bytenr %llu", disk_bytenr);
> +		return -EUCLEAN;
> +	}
> +
> +	ret =3D btrfs_lookup_csums_list(csum_root, disk_bytenr,
> +				      disk_bytenr + len - 1, &list, false);
> +	if (ret < 0)
> +		return ret;
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
> +	struct inode *vfs_inode =3D file_inode(file);
> +	struct btrfs_inode *inode =3D BTRFS_I(vfs_inode);
> +	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> +	struct btrfs_root *root =3D inode->root;
> +	struct btrfs_ioctl_get_csums_args args;
> +	BTRFS_PATH_AUTO_FREE(path);
> +	const u64 ino =3D btrfs_ino(inode);
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
> +	if (!S_ISREG(vfs_inode->i_mode))
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
> +
> +	if (clear_user(ubuf, buf_limit))
> +		return -EFAULT;
> +
> +	cur_offset =3D args.offset;
> +	end_offset =3D args.offset + args.length;
> +
> +	path =3D btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	ret =3D btrfs_wait_ordered_range(inode, cur_offset, args.length);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D down_read_interruptible(&vfs_inode->i_rwsem);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D btrfs_wait_ordered_range(inode, cur_offset, args.length);
> +	if (ret)
> +		goto out_unlock;
> +
> +	/* NODATASUM early exit. */
> +	if (inode->flags & BTRFS_INODE_NODATASUM) {
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
> +		struct btrfs_ioctl_get_csums_entry entry =3D { 0 };
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
> +		entry.offset =3D range_start;
> +		entry.length =3D range_len;
> +
> +		if (extent_type =3D=3D BTRFS_FILE_EXTENT_INLINE) {
> +			entry.type =3D BTRFS_GET_CSUMS_INLINE;
> +			if (compression !=3D BTRFS_COMPRESS_NONE)
> +				entry.type |=3D BTRFS_GET_CSUMS_COMPRESSED;
> +			if (encryption !=3D 0)
> +				entry.type |=3D BTRFS_GET_CSUMS_ENCRYPTED;
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
> +			} else if (encryption !=3D 0 ||
> +				   compression !=3D BTRFS_COMPRESS_NONE) {
> +				entry.type =3D 0;
> +				if (encryption !=3D 0)
> +					entry.type |=3D BTRFS_GET_CSUMS_ENCRYPTED;
> +				if (compression !=3D BTRFS_COMPRESS_NONE)
> +					entry.type |=3D BTRFS_GET_CSUMS_COMPRESSED;
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
> +	up_read(&vfs_inode->i_rwsem);
> +	return ret;
> +}
> +
>   long btrfs_ioctl(struct file *file, unsigned int
>   		cmd, unsigned long arg)
>   {
> @@ -5297,6 +5641,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>   		return btrfs_ioctl_subvol_sync(fs_info, argp);
>   	case BTRFS_IOC_SHUTDOWN:
>   		return btrfs_ioctl_shutdown(fs_info, arg);
> +	case BTRFS_IOC_GET_CSUMS:
> +		return btrfs_ioctl_get_csums(file, argp);
>   	}
>  =20
>   	return -ENOTTY;
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 9165154a274d94..ddb7a8f2610d0e 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -1100,6 +1100,29 @@ enum btrfs_err_code {
>   	BTRFS_ERROR_DEV_RAID1C4_MIN_NOT_MET,
>   };
>  =20
> +/* Flags for struct btrfs_ioctl_get_csums_entry::type */
> +#define BTRFS_GET_CSUMS_HAS_CSUMS	(1 << 0)
> +#define BTRFS_GET_CSUMS_ZEROED		(1 << 1)
> +#define BTRFS_GET_CSUMS_NODATASUM	(1 << 2)
> +#define BTRFS_GET_CSUMS_COMPRESSED	(1 << 3)
> +#define BTRFS_GET_CSUMS_ENCRYPTED	(1 << 4)
> +#define BTRFS_GET_CSUMS_INLINE		(1 << 5)
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

