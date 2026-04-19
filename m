Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB0F13B7AE
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 01:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776562182; cv=none; b=Sl+U+L4VgjQyivXSGgFtrEFguo4iFfpt/zLRBLozKO6BrVwq0r5s3DeQordvIR3A1rmlOkwpV3ANTUulRFydtjeJvEBrJ/AIWaSqfrMx5g7MWg56IUnHsaLEH8LJuyE4avqSfsWrRoLVnuVp5nkCLvidiZlIic1poUBNt6XEEa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776562182; c=relaxed/simple;
	bh=AVeRpO4mg7Wl8BWba5NL9DOC4B0j8zcYw28IxM+Qc3Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SbPRCr6JPsfNzrdH4I0v/vgu3N5AaiK40lRbbSjQPkG2vwoiMMINmRQBTBaoiKSyR3ApBUg8k0mUDHCde6O+WMNXYzBlIWBp75lcRso2961Gr139VLD+EZDqWhgLVaAZ41qataqPiwf4Oa3rindw3RM9BvZzTBX/Oa1QmISGWgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=tPbd8uXv; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="tPbd8uXv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1776562177; x=1777166977; i=quwenruo.btrfs@gmx.com;
	bh=1YaMLrhcrLtvQYeBQZptBcQZRwiF5NGxDPbBd7iPM/c=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=tPbd8uXvLg2NHd38/Y2eB+3AeQFzYNP55BRAhFTUazhoo4xxbKFnEM1Q/NPuNs2Q
	 5A0FqoM3O9cyCDj5YAlfAgYiKovKCv6IDWJV2l6ivD42G6Ejj37Y/t2D7GMi9xJ0h
	 dtHJRLApZw1FnHeRLKFSmQ4cRZ2DePPx1rdNLPgXQuc7oBQ4ZYd5KWw4JnbZ/zkJY
	 Y5QCh9b6enZcuLtuc2h2kMcxAANOF6+DlBZi3VST1dzT+f77pYHzQV2K2PSeqjKH8
	 mM/zEhpKLd9vxzU+itRihmH7aXRY/dVqq4mHqyDDLRubtNUlDwZgvb/foQFKlVeMg
	 9gc4+AidebP5pMx52A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N1fmq-1vH3f61UMa-00w3jO; Sun, 19
 Apr 2026 03:29:37 +0200
Message-ID: <17a6d129-c0b1-4a8e-aa0e-9087ec5616c9@gmx.com>
Date: Sun, 19 Apr 2026 10:59:33 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] btrfs: support for FALLOC_FL_COLLAPSE_RANGE in
 btrfs_fallocate()
To: Paul Richards <paul.richards@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
References: <20260418143808.199603-1-paul.richards@gmail.com>
 <20260418143808.199603-3-paul.richards@gmail.com>
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
In-Reply-To: <20260418143808.199603-3-paul.richards@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:AhkJO1dTRJwEfkpcOXMo/SDzM/Q1gzpLqvgzxVeRPd3BQ8tl2jW
 Xn/4yEEZXOn4bkuqwoXQSdSdaOcli0hS/ueLR1zbUdY+7HtyMYzAwd7gmemC4XdihFkfRA3
 dBXRPGsLS12TaS4yuZ2YMDalXTJiyZMxm4amyk+hYyp3v3MRxg5iXS5tK95ycfllKBOswFf
 Y3dTpko74MF2S7LQE0MKg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:hwi74qPUuM8=;aneSUfShTgTo4di226OHxtmhlaT
 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



=E5=9C=A8 2026/4/19 00:08, Paul Richards =E5=86=99=E9=81=93:

Commit message please, especially when you're implementing a new feature.

> Assisted-by: Amazon Q Developer:auto/unknown
> Signed-off-by: Paul Richards <paul.richards@gmail.com>
> ---
>   fs/btrfs/file.c | 300 ++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 300 insertions(+)
>=20
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 0b5cc3cec675..99d24bef5f88 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -39,6 +39,13 @@
>   #include "super.h"
>   #include "print-tree.h"
>  =20
> +/*
> + * When we shift extents as part of fallocate insert or collapse we com=
mit
> + * and cycle the transaction every BTRFS_INSERT_COLLAPSE_TRANSACTION_CY=
CLE_INTERVAL
> + * extents to avoid accumulating too many changes in one transaction.
> + */
> +#define BTRFS_INSERT_COLLAPSE_TRANSACTION_CYCLE_INTERVAL (32)
> +

As mentioned in the cover letter, you can go with=20
btrfs_should_end_transaction() to do the check, which I believe is=20
better than a fixed threshold.

>   /*
>    * Unlock folio after btrfs_file_write() is done with it.
>    */
> @@ -2648,6 +2655,296 @@ int btrfs_replace_file_extents(struct btrfs_inod=
e *inode,
>   	return ret;
>   }
>  =20
> +/*
> + * Update the extent back-reference in the extent tree when a
> + * BTRFS_EXTENT_DATA_KEY item is shifted to a new logical file offset.
> + * Drops the back-reference at old_file_offset and adds one at new_file=
_offset.
> + * Holes (disk_bytenr =3D=3D 0) and inline extents have no back-referen=
ces and
> + * must not be passed to this function.
> + */
> +static int btrfs_shift_extent_backref(struct btrfs_trans_handle *trans,
> +				      struct btrfs_root *root, u64 ino,
> +				      u64 disk_bytenr, u64 num_bytes,
> +				      u64 old_file_offset, u64 new_file_offset)
> +{
> +	struct btrfs_ref ref =3D {
> +		.bytenr =3D disk_bytenr,
> +		.num_bytes =3D num_bytes,
> +		.parent =3D 0,
> +		.owning_root =3D btrfs_root_id(root),
> +		.ref_root =3D btrfs_root_id(root),
> +	};
> +	int ret;
> +
> +	ref.action =3D BTRFS_DROP_DELAYED_REF;
> +	btrfs_init_data_ref(&ref, ino, old_file_offset, 0, false);
> +	ret =3D btrfs_free_extent(trans, &ref);
> +	if (unlikely(ret)) {
> +		btrfs_abort_transaction(trans, ret);
> +		return ret;
> +	}
> +
> +	ref.action =3D BTRFS_ADD_DELAYED_REF;
> +	btrfs_init_data_ref(&ref, ino, new_file_offset, 0, false);
> +	ret =3D btrfs_inc_extent_ref(trans, &ref);
> +	if (unlikely(ret))
> +		btrfs_abort_transaction(trans, ret);
> +
> +	return ret;
> +}
> +
> +static int btrfs_collapse_range(struct inode *inode, loff_t offset, lof=
f_t len)
> +{
> +	struct btrfs_fs_info *fs_info =3D inode_to_fs_info(inode);
> +	struct btrfs_root *root =3D BTRFS_I(inode)->root;
> +	u64 end =3D offset + len;
> +	struct btrfs_path *path;

I'd recommend to go auto free for @path.

> +	struct btrfs_trans_handle *trans =3D NULL;
> +	struct extent_state *cached_state =3D NULL;
> +	struct extent_buffer *leaf;
> +	struct btrfs_key key;
> +	struct btrfs_key new_key;
> +	u64 ino =3D btrfs_ino(BTRFS_I(inode));
> +	int ret;
> +
> +	if (!IS_ENABLED(CONFIG_BTRFS_EXPERIMENTAL))
> +		return -EOPNOTSUPP;
> +
> +	/* offset and len must be sector-aligned */
> +	if (!IS_ALIGNED(offset | len, fs_info->sectorsize))

I'd prefer a more human readable separate checks on @offset and @len=20
instead.

> +		return -EINVAL;
> +
> +	/* collapse range must not reach or pass EOF - use ftruncate instead *=
/
> +	if (end >=3D inode->i_size)

And please also do a overflow check before this one.

> +		return -EINVAL;
> +
> +	btrfs_info(fs_info,
> +		   "btrfs_collapse_range: ino=3D%llu offset=3D%lld len=3D%lld i_size=
=3D%lld",
> +		   btrfs_ino(BTRFS_I(inode)), offset, len, inode->i_size);

Either change it to a trace event, or just drop it.

For internal debugging, introduce trace_printk()/printk() in a dedicated=
=20
debug patch instead and never send that debug patch.

> +
> +	/* wait for any ordered extents in [offset, i_size) to complete */
> +	ret =3D btrfs_wait_ordered_range(BTRFS_I(inode), offset,
> +				       inode->i_size - offset);

I'd prefer to use (u64)-1 as the length to be extra safe.

It's possible that we have some OE beyond the rounded up isize.

> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Flush dirty pages and invalidate the page cache for [offset, i_size=
)
> +	 * before any extent manipulation, following the ext4/xfs pattern.
> +	 * We hold BTRFS_ILOCK_MMAP so no new dirty pages can appear during
> +	 * the operation. The page cache must be empty before we shift extent
> +	 * keys so that stale pages at the old offsets cannot be read back
> +	 * after the collapse.
> +	 */
> +	ret =3D filemap_write_and_wait_range(inode->i_mapping, offset, LLONG_M=
AX);
> +	if (ret)
> +		return ret;
> +	btrfs_info(fs_info,
> +		   "btrfs_collapse_range: nrpages before upfront invalidate=3D%lu (pa=
ges before offset=3D%llu not invalidated)",
> +		   inode->i_mapping->nrpages, offset >> PAGE_SHIFT);
> +	truncate_pagecache_range(inode, offset, LLONG_MAX);
> +	btrfs_info(fs_info,
> +		   "btrfs_collapse_range: nrpages after upfront invalidate=3D%lu (exp=
ected %llu)",
> +		   inode->i_mapping->nrpages, offset >> PAGE_SHIFT);
> +
> +	path =3D btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Lock the range [offset, end) and invalidate the page cache within
> +	 * it. btrfs_punch_hole_lock_range() calls truncate_pagecache_range()
> +	 * internally in a retry loop.
> +	 */
> +	btrfs_punch_hole_lock_range(inode, offset, end - 1, &cached_state);

Please lock the range to (u64)-1.

You're modifying all the underlay extent maps beyond @offset.

> +
> +	/*
> +	 * Remove all extents in [offset, end). Passing NULL for extent_info
> +	 * means we are punching a hole. btrfs_replace_file_extents() splits
> +	 * any extent straddling the boundaries, drops extent refs, and
> +	 * returns a transaction handle for us to reuse.
> +	 */
> +	ret =3D btrfs_replace_file_extents(BTRFS_I(inode), path,
> +					 offset, end - 1, NULL, &trans);

Not sure if this will work on fses without no-holes (aka, -O ^no-holes=20
option for mkfs).

This will insert hole file extents to fill range [@offset, @offset +=20
@len), with ^no-holes, there will be file extent items with disk_bytenr=20
=3D=3D 0.

> +	btrfs_info(fs_info,
> +		   "btrfs_collapse_range: btrfs_replace_file_extents ret=3D%d nrpages=
=3D%lu",
> +		   ret, inode->i_mapping->nrpages);
> +	if (ret)
> +		goto out_unlock;
> +
> +	/*
> +	 * Shift all BTRFS_EXTENT_DATA_KEY items with key.offset >=3D end
> +	 * leftward by len bytes.
> +	 *
> +	 * We iterate forward (lowest offset first) which is safe for a
> +	 * left-shift because the new key is always less than the old one,
> +	 * so we never collide with a key we haven't visited yet.
> +	 */
> +	key.objectid =3D ino;
> +	key.type =3D BTRFS_EXTENT_DATA_KEY;
> +	key.offset =3D end;
> +
> +	int nr_shifted =3D 0;
> +	while (1) {
> +		struct btrfs_file_extent_item *fi;
> +		u64 disk_bytenr;
> +		u64 num_bytes;
> +		u64 extent_offset;
> +		int extent_type;
> +
> +		ret =3D btrfs_search_slot(trans, root, &key, path, 0, 1);
> +		if (ret < 0)
> +			goto out_trans;
> +
> +		/* If no exact match, slot points at the next item - that's fine */
> +
> +		leaf =3D path->nodes[0];
> +		if (path->slots[0] >=3D btrfs_header_nritems(leaf)) {
> +			ret =3D btrfs_next_leaf(root, path);

This is not safe.
The next leaf may not be COWed.

If you check all btrfs_next_leaf() usages after a btrfs_search_slot()=20
call, the btrfs_search_slot() is nevered called with @cow =3D=3D 1.

> +			if (ret < 0)
> +				goto out_trans;
> +			if (ret > 0) {
> +				/* No more items - we are done shifting */
> +				ret =3D 0;
> +				break;
> +			}
> +			leaf =3D path->nodes[0];
> +		}
> +
> +		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
> +
> +		/* Stop if we've moved past this inode's extent data items */
> +		if (key.objectid !=3D ino || key.type !=3D BTRFS_EXTENT_DATA_KEY) {
> +			ret =3D 0;
> +			break;
> +		}
> +
> +		btrfs_info(fs_info,
> +			   "btrfs_collapse_range: shifting key offset %llu -> %llu",
> +			   key.offset, key.offset - len);
> +
> +		fi =3D btrfs_item_ptr(leaf, path->slots[0],
> +				    struct btrfs_file_extent_item);
> +		extent_type =3D btrfs_file_extent_type(leaf, fi);
> +		disk_bytenr =3D btrfs_file_extent_disk_bytenr(leaf, fi);
> +		num_bytes =3D btrfs_file_extent_disk_num_bytes(leaf, fi);
> +		extent_offset =3D btrfs_file_extent_offset(leaf, fi);
> +
> +		memcpy(&new_key, &key, sizeof(new_key));
> +		new_key.offset -=3D len;
> +		btrfs_set_item_key_safe(trans, path, &new_key);

For ^no-holes, this will cause problems, as there can be a hole extent=20
with exactly the same offset.

> +
> +		/*
> +		 * Update the back-reference in the extent tree to reflect the
> +		 * new logical file offset. Holes (disk_bytenr =3D=3D 0) and inline
> +		 * extents have no back-references to update.
> +		 */
> +		if (extent_type !=3D BTRFS_FILE_EXTENT_INLINE && disk_bytenr > 0) {
> +			ret =3D btrfs_shift_extent_backref(trans, root, ino,
> +					disk_bytenr, num_bytes,
> +					key.offset - extent_offset,
> +					new_key.offset - extent_offset);
> +			if (unlikely(ret))
> +				goto out_trans;
> +		}
> +
> +		/* Advance to the next item on the next iteration */
> +		key.offset =3D new_key.offset + 1;

This is very ineffcient.

You're calling btrfs_search_slot() for every file extent item, just=20
please don't.

Just handle all involved file extent items inside the leaf in one go.

> +		nr_shifted++;
> +
> +		/*
> +		 * Cycle the transaction every N items to avoid holding a
> +		 * single transaction open across a large number of extent
> +		 * items. btrfs_set_item_key_safe() modifies leaves in-place
> +		 * so we won't hit -ENOSPC; we use a simple counter instead.
> +		 * Update the inode at each cycle point so it is consistent
> +		 * on disk if a crash occurs mid-loop.
> +		 */
> +		if (nr_shifted % BTRFS_INSERT_COLLAPSE_TRANSACTION_CYCLE_INTERVAL =3D=
=3D 0) {
> +			btrfs_info(fs_info,
> +			   "btrfs_collapse_range: cycling transaction, nr_shifted=3D%d", nr_=
shifted);
> +			inode_inc_iversion(inode);
> +			inode_set_mtime_to_ts(inode,
> +					      inode_set_ctime_current(inode));
> +			ret =3D btrfs_update_inode(trans, BTRFS_I(inode));
> +			if (ret) {
> +				btrfs_release_path(path);
> +				goto out_trans;
> +			}
> +			btrfs_end_transaction(trans);
> +			btrfs_btree_balance_dirty(fs_info);
> +			trans =3D btrfs_start_transaction(root, 1);
> +			if (IS_ERR(trans)) {
> +				ret =3D PTR_ERR(trans);
> +				trans =3D NULL;
> +				btrfs_release_path(path);
> +				goto out_unlock;
> +			}
> +		}
> +
> +		btrfs_release_path(path);
> +	}

The whole loop can be extracted into a helper.

The difference between insert and collapse is just the difference in the=
=20
file offset shift direction (pluse for insert, minus to collapse).

Having two similar copies between insert and collapse is never going to=20
improve the maintenanceability.

> +
> +	if (ret)
> +		goto out_trans;
> +
> +	/* Update i_size and the on-disk inode */
> +	btrfs_info(fs_info,
> +		   "btrfs_collapse_range: updating i_size %lld -> %lld nrpages=3D%lu"=
,
> +		   inode->i_size, inode->i_size - len, inode->i_mapping->nrpages);
> +	/*
> +	 * Drop the extent map cache for [offset, i_size) so that subsequent
> +	 * reads re-load the correct mappings from the btree. The key-shift
> +	 * loop updated the btree but the in-memory extent map cache still
> +	 * has entries at the old logical offsets.
> +	 */
> +	btrfs_drop_extent_map_range(BTRFS_I(inode), offset, (u64)-1, false);
> +	inode_inc_iversion(inode);
> +	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
> +	i_size_write(inode, inode->i_size - len);
> +	btrfs_inode_safe_disk_i_size_write(BTRFS_I(inode), 0);
> +	ret =3D btrfs_update_inode(trans, BTRFS_I(inode));
> +
> +out_trans:
> +	if (trans) {
> +		if (ret)
> +			btrfs_end_transaction(trans);

Not sure if we're safe to end the transaction here. If we a critical=20
error, there may be file extents moved but some are not.

But at the same time, we may have commit a transaction halfway, thus the=
=20
inconsitency may already be there.

Is there any docs about what is the expected behavior if INSERT/COLLAPSE=
=20
failed halfway?

Should the fs fully revert to the original state (not sure if even=20
possible) or something else?

> +		else
> +			ret =3D btrfs_end_transaction(trans);
> +	}
> +out_unlock:
> +	btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, offset, end - 1,
> +			    &cached_state);
> +	btrfs_info(fs_info,
> +		   "btrfs_collapse_range: post-unlock ret=3D%d i_size=3D%lld, invalid=
ating page cache from %lld",
> +		   ret, inode->i_size, offset);
> +	if (IS_ENABLED(CONFIG_BTRFS_DEBUG) && !ret) {
> +		/*
> +		 * These are expected to be no-ops: ordered extents were drained
> +		 * at the start of this function and BTRFS_ILOCK_MMAP has been
> +		 * held throughout, so no new writes could have been submitted.
> +		 * The page cache was emptied from offset onwards upfront and
> +		 * nrpages in that region stayed 0 throughout the operation.
> +		 * Pages before offset are unaffected and may still be cached.
> +		 */
> +		int wait_ret =3D btrfs_wait_ordered_range(BTRFS_I(inode), offset,
> +						    inode->i_size);

Hide it behind DEBUG doesn't mean you can add whatever operations.

If you want to add this, please explain why.
If you can not explain it, just don't add in the formal patch.

Thanks,
Qu

> +		btrfs_info(fs_info,
> +			   "btrfs_collapse_range: post-shift wait_ordered ret=3D%d",
> +			   wait_ret);
> +		ASSERT(wait_ret =3D=3D 0);
> +		ASSERT(filemap_range_has_page(inode->i_mapping, offset,
> +					      LLONG_MAX) =3D=3D false);
> +		truncate_pagecache_range(inode, offset, LLONG_MAX);
> +		btrfs_info(fs_info,
> +			   "btrfs_collapse_range: truncate_pagecache_range done");
> +		ASSERT(filemap_range_has_page(inode->i_mapping, offset,
> +					      LLONG_MAX) =3D=3D false);
> +	}
> +	btrfs_free_path(path);
> +	return ret;
> +}
> +
>   static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t l=
en)
>   {
>   	struct inode *inode =3D file_inode(file);
> @@ -3296,6 +3593,9 @@ static long btrfs_fallocate(struct file *file, int=
 mode,
>   	case FALLOC_FL_PUNCH_HOLE:
>   		ret =3D btrfs_punch_hole(file, offset, len);
>   		break;
> +	case FALLOC_FL_COLLAPSE_RANGE:
> +		ret =3D btrfs_collapse_range(inode, offset, len);
> +		break;
>   	default:
>   		ret =3D -EOPNOTSUPP;
>   	}

