Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6F441C71
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 17:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776275246; cv=none; b=UoJLoXSy1OhAG9CZzbhKe2s33/9Jvkitm+72SLJZjBL7vEN55dz4rL+o7AqKBezsPa7U8JwYjepXNOU8cr7YWsCRxMGsJwIRF9Eaput4mUmSil+fhXiIZpmzdHE4qdukks7TQmOgHbzzJgJIuqs3R/T+qCvFFVM/Qsro2jA5mb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776275246; c=relaxed/simple;
	bh=WS250ZxwmbXCLu66AeEiCK8dmHEoK77GCtbPRShpV+4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TkLGdgE2J96F5GafMPIixW4XzZQNJwSsVzGcHp/Kz46b6z/x5gURbCn6cIPCa1KHMrvnvwt4z2G77ioLkdbZF3Xl3L5j+p9PaL4sLF5B5mP+ck245/6xTcf7OV3kbMZbyCCj8rk827DNSkfSGDRHgmT+7tgOcEsXVU1MbY9QqOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YqYK+nkd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YqYK+nkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B05C19424
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 17:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776275246;
	bh=WS250ZxwmbXCLu66AeEiCK8dmHEoK77GCtbPRShpV+4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YqYK+nkdVwPrLwPYiV+kylJs0x9RbuWlRXGjyHlY0pUrk1bD0DpF+3X9SZU8H1q/e
	 JgKJ8AUmkuQKzBzhxK6Oa9qR+i++aCe2M1pDtwZ2RFqrAllpGMYIpq/IC35OmW2yZq
	 Kws4QRDSsTUpsiQCQrrv1GB91iaLllKg+d16GAaJzZJxGl5CyXcq9pxW59XhrB3rOl
	 qxH29l9eHJqyflK2KVK6/A1/k9914qR9jpMNPwu98XzskIx4BWEPF4S9X+AQF6mMXj
	 wYOm+B4atFVLoys8l6mFgiraEr1qz7iuu5ecT4qHbF31jIVvIs/Q2urEB+ZQv1gCTf
	 oRPSfZ7YVkQRQ==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b9358bc9c50so933902166b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 10:47:26 -0700 (PDT)
X-Gm-Message-State: AOJu0Yyvlhsrevgrkj90oyWW/BZNopwEB/NsPN5fSYjuxisLuBB7FKpA
	7aoUQt15f1dvJmgnJt0XwnwxHb4dAHC+gjTXe3x0zmljB4NbRaG03aWlK8NofMhOBHB6xn8n54L
	6F2gxQxtEnmrY1oqry8ECNOdf4rCvk3g=
X-Received: by 2002:a17:907:1b1c:b0:b9c:4893:822e with SMTP id
 a640c23a62f3a-b9d72440894mr1283380666b.10.1776275244613; Wed, 15 Apr 2026
 10:47:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260415170001.109723-1-mark@harmstone.com>
In-Reply-To: <20260415170001.109723-1-mark@harmstone.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 15 Apr 2026 18:46:46 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5UYpm5rc2xU2H2oKjuZ3NjWcq9QL647QsSgBCd3oEY_g@mail.gmail.com>
X-Gm-Features: AQROBzDIHKWytiJal4EuyKFU7Xfbkb3qn0e48R1WcoGnzW5gBuMFz0mmWvlKktQ
Message-ID: <CAL3q7H5UYpm5rc2xU2H2oKjuZ3NjWcq9QL647QsSgBCd3oEY_g@mail.gmail.com>
Subject: Re: [PATCH v4] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com, boris@bur.io, dsterba@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 6:08=E2=80=AFPM Mark Harmstone <mark@harmstone.com>=
 wrote:
>
> Add a new unprivileged BTRFS_IOC_GET_CSUMS ioctl, which can be used to
> query the on-disk csums for a file.
>
> The ioctl is deliberately per-file rather than exposing raw csum tree
> lookups, to avoid leaking information to users about files they may not
> have access to.
>
> This is done by userspace passing a struct btrfs_ioctl_get_csums_args to
> the kernel, which details the offset and length we're interested in, and
> a buffer for the kernel to write its results into. The kernel writes a
> struct btrfs_ioctl_get_csums_entry into the buffer, followed by the
> csums if available.
>
> If the extent is an uncompressed, non-nodatasum extent, the kernel sets
> the entry type to BTRFS_GET_CSUMS_HAS_CSUMS and follows it with the
> csums. If it is sparse, preallocated, or beyond the EOF, it sets the
> type to BTRFS_GET_CSUMS_ZEROED - this is so userspace knows it can use
> the precomputed hash of the zero sector. Otherwise, it sets the type to
> BTRFS_GET_CSUMS_NODATASUM, BTRFS_GET_CSUMS_COMPRESSED,
> BTRFS_GET_CSUM_ENCRYPTED, or BTRFS_GET_CSUM_INLINE.
>
> For example, a file with a [0, 4K) hole and [4K, 12K) data extent would
> produce the following output buffer:
>
>   | [0, 4K) ZEROED | [4K, 12K) HAS_CSUMS | csum data |
>
> We do store the csums of compressed extents, but we deliberately don't
> return them here: they're hashed over the compressed data, not the
> uncompressed data that's returned to userspace. Similarly for encrypted
> data, once encryption is supported, in which the csums will be on the
> ciphertext.
>
> The main use case for this is for speeding up mkfs.btrfs --rootdir. For
> the case when the source FS is btrfs and using the same csum algorithm,
> we can avoid having to recalculate the csums - in my synthetic
> benchmarks (16GB file on a spinning-rust drive), this resulted in a ~11%
> speed-up (218s to 196s).
>
> When using the --reflink option added in btrfs-progs v6.16.1, we can forg=
o
> reading the data entirely, resulting a ~2200% speed-up on the same test
> (128s to 6s).
>
>     # mkdir rootdir
>     # dd if=3D/dev/urandom of=3Drootdir/file bs=3D4096 count=3D4194304
>
>     (without ioctl)
>     # echo 3 > /proc/sys/vm/drop_caches
>     # time mkfs.btrfs --rootdir rootdir testimg
>     ...
>     real    3m37.965s
>     user    0m5.496s
>     sys     0m6.125s
>
>     # echo 3 > /proc/sys/vm/drop_caches
>     # time mkfs.btrfs --rootdir rootdir --reflink testimg
>     ...
>     real    2m8.342s
>     user    0m5.472s
>     sys     0m1.667s
>
>     (with ioctl)
>     # echo 3 > /proc/sys/vm/drop_caches
>     # time mkfs.btrfs --rootdir rootdir testimg
>     ...
>     real    3m15.865s
>     user    0m4.258s
>     sys     0m6.261s
>
>     # echo 3 > /proc/sys/vm/drop_caches
>     # time mkfs.btrfs --rootdir rootdir --reflink testimg
>     ...
>     real    0m5.847s
>     user    0m2.899s
>     sys     0m0.097s
>
> Signed-off-by: Mark Harmstone <mark@harmstone.com>
> ---
> Changes since v3:
> * Changed type to bit flags, so we can have e.g. COMPRESSED | ENCRYPTED
> * Made minor changes as requested by David Sterba
>
>  fs/btrfs/ioctl.c           | 341 +++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/btrfs.h |  25 +++
>  2 files changed, 366 insertions(+)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a39460bf68a778..610eba1fe76f80 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -56,6 +56,7 @@
>  #include "uuid-tree.h"
>  #include "ioctl.h"
>  #include "file.h"
> +#include "file-item.h"
>  #include "scrub.h"
>  #include "super.h"
>
> @@ -5140,6 +5141,344 @@ static int btrfs_ioctl_shutdown(struct btrfs_fs_i=
nfo *fs_info, unsigned long arg
>         return ret;
>  }
>
> +#define GET_CSUMS_BUF_MAX      SZ_16M
> +
> +static int copy_csums_to_user(struct btrfs_fs_info *fs_info, u64 disk_by=
tenr,
> +                             u64 len, u8 __user *buf)
> +{
> +       struct btrfs_root *csum_root;
> +       struct btrfs_ordered_sum *sums;
> +       LIST_HEAD(list);
> +       const u32 csum_size =3D fs_info->csum_size;
> +       int ret;
> +
> +       csum_root =3D btrfs_csum_root(fs_info, disk_bytenr);

Please, check that the root is not null; if it is null, log an error
message and return an error.
We found many missing instances that sometimes triggered null pointer
dereferences when the file system was corrupted or mounted with the
rescue option, among other issues.
See:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D2b4cb4e58f3463d142fcece5a19e0405fb82c794

Thanks.



> +
> +       ret =3D btrfs_lookup_csums_list(csum_root, disk_bytenr,
> +                                     disk_bytenr + len - 1, &list, false=
);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret =3D 0;
> +       while (!list_empty(&list)) {
> +               u64 offset;
> +               size_t copy_size;
> +
> +               sums =3D list_first_entry(&list, struct btrfs_ordered_sum=
, list);
> +               list_del(&sums->list);
> +
> +               offset =3D ((sums->logical - disk_bytenr) >> fs_info->sec=
torsize_bits) * csum_size;
> +               copy_size =3D (sums->len >> fs_info->sectorsize_bits) * c=
sum_size;
> +
> +               if (copy_to_user(buf + offset, sums->sums, copy_size)) {
> +                       kfree(sums);
> +                       ret =3D -EFAULT;
> +                       goto out;
> +               }
> +
> +               kfree(sums);
> +       }
> +
> +out:
> +       while (!list_empty(&list)) {
> +               sums =3D list_first_entry(&list, struct btrfs_ordered_sum=
, list);
> +               list_del(&sums->list);
> +               kfree(sums);
> +       }
> +       return ret;
> +}
> +
> +static int btrfs_ioctl_get_csums(struct file *file, void __user *argp)
> +{
> +       struct inode *vfs_inode =3D file_inode(file);
> +       struct btrfs_inode *inode =3D BTRFS_I(vfs_inode);
> +       struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> +       struct btrfs_root *root =3D inode->root;
> +       struct btrfs_ioctl_get_csums_args args;
> +       BTRFS_PATH_AUTO_FREE(path);
> +       const u64 ino =3D btrfs_ino(inode);
> +       const u32 sectorsize =3D fs_info->sectorsize;
> +       const u32 csum_size =3D fs_info->csum_size;
> +       u8 __user *ubuf;
> +       u64 buf_limit;
> +       u64 buf_used =3D 0;
> +       u64 cur_offset;
> +       u64 end_offset;
> +       u64 prev_extent_end;
> +       struct btrfs_key key;
> +       int ret;
> +
> +       if (!(file->f_mode & FMODE_READ))
> +               return -EBADF;
> +
> +       if (!S_ISREG(vfs_inode->i_mode))
> +               return -EINVAL;
> +
> +       if (copy_from_user(&args, argp, sizeof(args)))
> +               return -EFAULT;
> +
> +       if (!IS_ALIGNED(args.offset, sectorsize) ||
> +           !IS_ALIGNED(args.length, sectorsize))
> +               return -EINVAL;
> +       if (args.length =3D=3D 0)
> +               return -EINVAL;
> +       if (args.offset + args.length < args.offset)
> +               return -EOVERFLOW;
> +       if (args.flags !=3D 0)
> +               return -EINVAL;
> +       if (args.buf_size < sizeof(struct btrfs_ioctl_get_csums_entry))
> +               return -EINVAL;
> +
> +       buf_limit =3D min_t(u64, args.buf_size, GET_CSUMS_BUF_MAX);
> +       ubuf =3D (u8 __user *)(argp + offsetof(struct btrfs_ioctl_get_csu=
ms_args, buf));
> +
> +       if (clear_user(ubuf, buf_limit))
> +               return -EFAULT;
> +
> +       cur_offset =3D args.offset;
> +       end_offset =3D args.offset + args.length;
> +
> +       path =3D btrfs_alloc_path();
> +       if (!path)
> +               return -ENOMEM;
> +
> +       ret =3D btrfs_wait_ordered_range(inode, cur_offset, args.length);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D down_read_interruptible(&vfs_inode->i_rwsem);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D btrfs_wait_ordered_range(inode, cur_offset, args.length);
> +       if (ret)
> +               goto out_unlock;
> +
> +       /* NODATASUM early exit. */
> +       if (inode->flags & BTRFS_INODE_NODATASUM) {
> +               struct btrfs_ioctl_get_csums_entry entry =3D {
> +                       .offset =3D cur_offset,
> +                       .length =3D end_offset - cur_offset,
> +                       .type =3D BTRFS_GET_CSUMS_NODATASUM,
> +               };
> +
> +               if (copy_to_user(ubuf, &entry, sizeof(entry))) {
> +                       ret =3D -EFAULT;
> +                       goto out_unlock;
> +               }
> +
> +               buf_used =3D sizeof(entry);
> +               cur_offset =3D end_offset;
> +               goto done;
> +       }
> +
> +       prev_extent_end =3D cur_offset;
> +
> +       while (cur_offset < end_offset) {
> +               struct btrfs_file_extent_item *ei;
> +               struct extent_buffer *leaf;
> +               struct btrfs_ioctl_get_csums_entry entry =3D { 0 };
> +               u64 extent_end;
> +               u64 disk_bytenr =3D 0;
> +               u64 extent_offset =3D 0;
> +               u64 range_start, range_len;
> +               u64 entry_csum_size;
> +               u64 key_offset;
> +               int extent_type;
> +               u8 compression;
> +               u8 encryption;
> +
> +               /* Search for the extent at or before cur_offset. */
> +               key.objectid =3D ino;
> +               key.type =3D BTRFS_EXTENT_DATA_KEY;
> +               key.offset =3D cur_offset;
> +
> +               ret =3D btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +               if (ret < 0)
> +                       goto out_unlock;
> +
> +               if (ret > 0 && path->slots[0] > 0) {
> +                       btrfs_item_key_to_cpu(path->nodes[0], &key,
> +                                             path->slots[0] - 1);
> +                       if (key.objectid =3D=3D ino &&
> +                           key.type =3D=3D BTRFS_EXTENT_DATA_KEY) {
> +                               path->slots[0]--;
> +                               if (btrfs_file_extent_end(path) <=3D cur_=
offset)
> +                                       path->slots[0]++;
> +                       }
> +               }
> +
> +               if (path->slots[0] >=3D btrfs_header_nritems(path->nodes[=
0])) {
> +                       ret =3D btrfs_next_leaf(root, path);
> +                       if (ret < 0)
> +                               goto out_unlock;
> +                       if (ret > 0) {
> +                               ret =3D 0;
> +                               btrfs_release_path(path);
> +                               break;
> +                       }
> +               }
> +
> +               leaf =3D path->nodes[0];
> +
> +               btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
> +               if (key.objectid !=3D ino || key.type !=3D BTRFS_EXTENT_D=
ATA_KEY) {
> +                       btrfs_release_path(path);
> +                       break;
> +               }
> +
> +               extent_end =3D btrfs_file_extent_end(path);
> +               key_offset =3D key.offset;
> +
> +               /* Read extent fields before releasing the path. */
> +               ei =3D btrfs_item_ptr(leaf, path->slots[0],
> +                                   struct btrfs_file_extent_item);
> +               extent_type =3D btrfs_file_extent_type(leaf, ei);
> +               compression =3D btrfs_file_extent_compression(leaf, ei);
> +               encryption =3D btrfs_file_extent_encryption(leaf, ei);
> +
> +               if (extent_type !=3D BTRFS_FILE_EXTENT_INLINE) {
> +                       disk_bytenr =3D btrfs_file_extent_disk_bytenr(lea=
f, ei);
> +                       if (disk_bytenr && compression =3D=3D BTRFS_COMPR=
ESS_NONE)
> +                               extent_offset =3D btrfs_file_extent_offse=
t(leaf, ei);
> +               }
> +
> +               btrfs_release_path(path);
> +
> +               /* Implicit hole (NO_HOLES feature). */
> +               if (prev_extent_end < key_offset) {
> +                       u64 hole_end =3D min(key_offset, end_offset);
> +                       u64 hole_len =3D hole_end - prev_extent_end;
> +
> +                       if (prev_extent_end >=3D cur_offset) {
> +                               entry.offset =3D prev_extent_end;
> +                               entry.length =3D hole_len;
> +                               entry.type =3D BTRFS_GET_CSUMS_ZEROED;
> +
> +                               if (buf_used + sizeof(entry) > buf_limit)
> +                                       goto done;
> +                               if (copy_to_user(ubuf + buf_used, &entry,
> +                                                sizeof(entry))) {
> +                                       ret =3D -EFAULT;
> +                                       goto out_unlock;
> +                               }
> +                               buf_used +=3D sizeof(entry);
> +                               cur_offset =3D hole_end;
> +                       }
> +
> +                       if (key_offset >=3D end_offset) {
> +                               cur_offset =3D end_offset;
> +                               break;
> +                       }
> +               }
> +
> +               /* Clamp to our query range. */
> +               range_start =3D max(cur_offset, key_offset);
> +               range_len =3D min(extent_end, end_offset) - range_start;
> +
> +               entry.offset =3D range_start;
> +               entry.length =3D range_len;
> +
> +               if (extent_type =3D=3D BTRFS_FILE_EXTENT_INLINE) {
> +                       entry.type =3D BTRFS_GET_CSUMS_INLINE;
> +                       if (compression !=3D BTRFS_COMPRESS_NONE)
> +                               entry.type |=3D BTRFS_GET_CSUMS_COMPRESSE=
D;
> +                       if (encryption !=3D 0)
> +                               entry.type |=3D BTRFS_GET_CSUMS_ENCRYPTED=
;
> +                       entry_csum_size =3D 0;
> +               } else if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC)=
 {
> +                       entry.type =3D BTRFS_GET_CSUMS_ZEROED;
> +                       entry_csum_size =3D 0;
> +               } else {
> +                       /* BTRFS_FILE_EXTENT_REG */
> +                       if (disk_bytenr =3D=3D 0) {
> +                               /* Explicit hole. */
> +                               entry.type =3D BTRFS_GET_CSUMS_ZEROED;
> +                               entry_csum_size =3D 0;
> +                       } else if (encryption !=3D 0 ||
> +                                  compression !=3D BTRFS_COMPRESS_NONE) =
{
> +                               entry.type =3D 0;
> +                               if (encryption !=3D 0)
> +                                       entry.type |=3D BTRFS_GET_CSUMS_E=
NCRYPTED;
> +                               if (compression !=3D BTRFS_COMPRESS_NONE)
> +                                       entry.type |=3D BTRFS_GET_CSUMS_C=
OMPRESSED;
> +                               entry_csum_size =3D 0;
> +                       } else {
> +                               entry.type =3D BTRFS_GET_CSUMS_HAS_CSUMS;
> +                               entry_csum_size =3D (range_len >> fs_info=
->sectorsize_bits) * csum_size;
> +                       }
> +               }
> +
> +               /* Check if this entry (+ csum data) fits in the buffer. =
*/
> +               if (buf_used + sizeof(entry) + entry_csum_size > buf_limi=
t) {
> +                       if (buf_used =3D=3D 0) {
> +                               ret =3D -EOVERFLOW;
> +                               goto out_unlock;
> +                       }
> +                       goto done;
> +               }
> +
> +               if (copy_to_user(ubuf + buf_used, &entry, sizeof(entry)))=
 {
> +                       ret =3D -EFAULT;
> +                       goto out_unlock;
> +               }
> +               buf_used +=3D sizeof(entry);
> +
> +               if (entry.type =3D=3D BTRFS_GET_CSUMS_HAS_CSUMS) {
> +                       ret =3D copy_csums_to_user(fs_info,
> +                               disk_bytenr + extent_offset + (range_star=
t - key_offset),
> +                               range_len, ubuf + buf_used);
> +                       if (ret)
> +                               goto out_unlock;
> +                       buf_used +=3D entry_csum_size;
> +               }
> +
> +               cur_offset =3D range_start + range_len;
> +               prev_extent_end =3D extent_end;
> +
> +               if (fatal_signal_pending(current)) {
> +                       if (buf_used =3D=3D 0) {
> +                               ret =3D -EINTR;
> +                               goto out_unlock;
> +                       }
> +                       goto done;
> +               }
> +
> +               cond_resched();
> +       }
> +
> +       /* Handle trailing implicit hole. */
> +       if (cur_offset < end_offset) {
> +               struct btrfs_ioctl_get_csums_entry entry =3D {
> +                       .offset =3D prev_extent_end,
> +                       .length =3D end_offset - prev_extent_end,
> +                       .type =3D BTRFS_GET_CSUMS_ZEROED,
> +               };
> +
> +               if (buf_used + sizeof(entry) <=3D buf_limit) {
> +                       if (copy_to_user(ubuf + buf_used, &entry,
> +                                        sizeof(entry))) {
> +                               ret =3D -EFAULT;
> +                               goto out_unlock;
> +                       }
> +                       buf_used +=3D sizeof(entry);
> +                       cur_offset =3D end_offset;
> +               }
> +       }
> +
> +done:
> +       args.offset =3D cur_offset;
> +       args.length =3D (cur_offset < end_offset) ? end_offset - cur_offs=
et : 0;
> +       args.buf_size =3D buf_used;
> +
> +       if (copy_to_user(argp, &args, sizeof(args)))
> +               ret =3D -EFAULT;
> +
> +out_unlock:
> +       up_read(&vfs_inode->i_rwsem);
> +       return ret;
> +}
> +
>  long btrfs_ioctl(struct file *file, unsigned int
>                 cmd, unsigned long arg)
>  {
> @@ -5297,6 +5636,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>                 return btrfs_ioctl_subvol_sync(fs_info, argp);
>         case BTRFS_IOC_SHUTDOWN:
>                 return btrfs_ioctl_shutdown(fs_info, arg);
> +       case BTRFS_IOC_GET_CSUMS:
> +               return btrfs_ioctl_get_csums(file, argp);
>         }
>
>         return -ENOTTY;
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 9165154a274d94..ddb7a8f2610d0e 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -1100,6 +1100,29 @@ enum btrfs_err_code {
>         BTRFS_ERROR_DEV_RAID1C4_MIN_NOT_MET,
>  };
>
> +/* Flags for struct btrfs_ioctl_get_csums_entry::type */
> +#define BTRFS_GET_CSUMS_HAS_CSUMS      (1 << 0)
> +#define BTRFS_GET_CSUMS_ZEROED         (1 << 1)
> +#define BTRFS_GET_CSUMS_NODATASUM      (1 << 2)
> +#define BTRFS_GET_CSUMS_COMPRESSED     (1 << 3)
> +#define BTRFS_GET_CSUMS_ENCRYPTED      (1 << 4)
> +#define BTRFS_GET_CSUMS_INLINE         (1 << 5)
> +
> +struct btrfs_ioctl_get_csums_entry {
> +       __u64 offset;           /* file offset of this range */
> +       __u64 length;           /* length in bytes */
> +       __u32 type;             /* BTRFS_GET_CSUMS_* type */
> +       __u32 reserved;         /* padding, must be 0 */
> +};
> +
> +struct btrfs_ioctl_get_csums_args {
> +       __u64 offset;           /* in/out: file offset */
> +       __u64 length;           /* in/out: range length */
> +       __u64 buf_size;         /* in/out: buffer capacity / bytes writte=
n */
> +       __u64 flags;            /* in: flags, must be 0 for now */
> +       __u8 buf[];             /* out: entries + csum data */
> +};
> +
>  /* Flags for IOC_SHUTDOWN, must match XFS_FSOP_GOING_FLAGS_* flags. */
>  #define BTRFS_SHUTDOWN_FLAGS_DEFAULT                   0x0
>  #define BTRFS_SHUTDOWN_FLAGS_LOGFLUSH                  0x1
> @@ -1226,6 +1249,8 @@ enum btrfs_err_code {
>                                      struct btrfs_ioctl_encoded_io_args)
>  #define BTRFS_IOC_SUBVOL_SYNC_WAIT _IOW(BTRFS_IOCTL_MAGIC, 65, \
>                                         struct btrfs_ioctl_subvol_wait)
> +#define BTRFS_IOC_GET_CSUMS _IOWR(BTRFS_IOCTL_MAGIC, 66, \
> +                                 struct btrfs_ioctl_get_csums_args)
>
>  /* Shutdown ioctl should follow XFS's interfaces, thus not using btrfs m=
agic. */
>  #define BTRFS_IOC_SHUTDOWN     _IOR('X', 125, __u32)
> --
> 2.52.0
>
>
