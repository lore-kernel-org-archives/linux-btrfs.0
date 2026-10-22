Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792678686;
	b=gVwe7jj1/9REp1fVFRV+o6XilkpYwkN/CHqtHIML84CkGGVfd05Wg2Kx32E+Jzt/aPv9
	 d+Wmoa7iZgDguDa0ci1csG9udX9prs9K3T2D5v5nGe2tKeSY/gmrKXif6sJUfyOnxGoya
	 wlkpxtMcP5N+2Ck/TCZp9zclsixkDKKj5dPExfzWQIBsF+w09a7Vu4SczfH3vlK/9vxBN
	 rFvSzUo7Dj8DaZbXQ15W7W+0ygaT7o/ZjZpLum2NAzd7gPshYv7aLwuf8t86o+AqrJJM5
	 gi4rkK7Elwn+TQm4eqOxrSAsxhQ7tVzMhqNbvQIGcyZjDN9/lLqkuaMMeLWkCTlJKjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792678686;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=fI59J8mrTfyc8Sa++1Xq4I9fQ8Eh3+L+3jgAKcFsvuk=;
	b=sOsVyuMD+FXZU3v/onNJ6jXZkU8NOsyxMfqOGqRgzJ4z/F3RicShls9o7w74ggm16tLr
	 gEsihaNBfxtotPfawIgrLMTEVG0w2wS0tBx9AokwDC928KYeFmDp4cQTLTvWeGsk1FIgM
	 8AmkoVipXTJoPRF6tUTqK9VPOPMPIyEaYaffGvpcoz/X3FwkwNOOUoTpumn62T1gwK/D6
	 bmPLA8y9r2UwGG6F0GHh6SXArPQQXD1W/bFbAvkPmK6d0nL4fgS7VjMNSUFQWT+tzjVCN
	 je1oueOlLfEelkYA28zF9YHbSOhmAldhHQU4yUKnzLY85PAQEdsgsjHGDtB4LVKVCQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KCUiSmxS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0A9606A31A
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 14:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KCUiSmxS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED3D1F000C1
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 14:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792678685;
	bh=fI59J8mrTfyc8Sa++1Xq4I9fQ8Eh3+L+3jgAKcFsvuk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KCUiSmxSB+x5u46lBbT+ANtehmPFYRzya1p4EpB72Nx2z8eMiz0G4Z8dfDlrhaVTU
	 glmablp3R076AZi23K10ONgOy7RM3ukUJKhw4hW1BJv5ktKvDcMLo0gU46MILbcK7M
	 d7THNwclQfertEk9i51jGpzzHUh4RsdSt5eaRqHNI4Hm90SUGaXQvTAte0LHURi6By
	 g0kUcUgJIIT/4mPz97spzRIPA9NhiL26A4HgK3EcpjfuL3QnE/Xfbp6FTv+aOoro5V
	 0J0SZXIFDMDC9inpoEjxExSX2rz9Eb9BQOFaTDvG3On9gsFXqBPfQ5EPYWFXIwht6x
	 WpJUPTdrNz9UQ==
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-98c7798ce74so505402241.1
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 07:18:05 -0700 (PDT)
X-Gm-Message-State: AFq9FYIHu1AJhpYZBbPNc9BTynGr8z3bpza2FoI5hXrTDkmuPpMKM7pm
	I6s5UnWsBUJcXgCl4kMRSbJa48oSR87WoPupmpi/zEm7vIo5I1v+e0Y7UZo1JIvd6xtk6wmuWNK
	PEveOm7UVGzDgF+vbei6zJapx0EjivR4=
X-Received: by 2002:a05:6102:61d6:20b0:7cc:971a:61f4 with SMTP id
 ada2fe7eead31-7cc971a66edmr1095999137.5.1792678684650; Thu, 22 Oct 2026
 07:18:04 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261022090653.2584545-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20261022090653.2584545-1-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 22 Oct 2026 15:17:26 +0100
X-Gmail-Original-Message-ID: <CAL3q7H44AGF5pBJwN3AGtXizBruq_hHngaLn9Lr30eqNZfeqyA@mail.gmail.com>
X-Gm-Features: AclHuK9Oefj2YfNzrIzMfT0yALZHoSWNH7LgP8aMAaW2C0H0OJ3Pz4WQeGbqFIQ
Message-ID: <CAL3q7H44AGF5pBJwN3AGtXizBruq_hHngaLn9Lr30eqNZfeqyA@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: force a transaction commit when fsyncing
 stripe-tree extents
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>, 
	Filipe Manana <fdmanana@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 22, 2026 at 10:07=E2=80=AFAM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> An extent in a block-group that uses the RAID stripe-tree has its logical
> to physical mapping stored in that tree, which only becomes persistent
> when the stripe-tree is written out at transaction commit. But the RAID
> stripe-tree is not logged in the log tree.
>
> A fsync therefore logs a file-extent item whose logical range cannot be
> resolved after a crash. Replay restores the file-extent item and the
> file has the correct size, but reading it fails with EIO and nothing is
> reported.
>
> Force a full commit when logging such an extent. Extents reach the log
> both from log_one_extent() and from copy_items(), so check in both.
> copy_items() skips extents from a past transaction, their mapping is
> already committed, the same reason their checksums are not logged.
>
> Fixes: 02c372e1f016 ("btrfs: add support for inserting raid stripe extent=
s")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good now, thanks.

> ---
>
> Changes to v1:
> - Don't just fix the fast fsync
>
>  fs/btrfs/tree-log.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 1d9dfb63fc5a..e50f924bca59 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -30,6 +30,8 @@
>  #include "print-tree.h"
>  #include "tree-checker.h"
>  #include "delayed-inode.h"
> +#include "volumes.h"
> +#include "raid-stripe-tree.h"
>
>  #define MAX_CONFLICT_INODES 10
>
> @@ -4741,6 +4743,24 @@ static int log_csums(struct btrfs_trans_handle *tr=
ans,
>         return ret;
>  }
>
> +static bool log_extent_needs_stripe_tree(struct btrfs_fs_info *fs_info,
> +                                        u64 disk_bytenr)
> +{
> +       struct btrfs_chunk_map *map __free(btrfs_free_chunk_map) =3D NULL=
;
> +
> +       if (!btrfs_fs_incompat(fs_info, RAID_STRIPE_TREE))
> +               return false;
> +
> +       if (disk_bytenr =3D=3D 0 || disk_bytenr >=3D EXTENT_MAP_LAST_BYTE=
)
> +               return false;
> +
> +       map =3D btrfs_find_chunk_map(fs_info, disk_bytenr, 1);
> +       if (!map)
> +               return false;
> +
> +       return btrfs_need_stripe_tree_update(fs_info, map->type);
> +}
> +
>  static noinline int copy_items(struct btrfs_trans_handle *trans,
>                                struct btrfs_inode *inode,
>                                struct btrfs_path *dst_path,
> @@ -4847,6 +4867,14 @@ static noinline int copy_items(struct btrfs_trans_=
handle *trans,
>                     inode->last_reflink_trans < trans->transid)
>                         continue;
>
> +               if (!is_old_extent &&
> +                   btrfs_file_extent_type(src, extent) !=3D BTRFS_FILE_E=
XTENT_INLINE) {
> +                       u64 bytenr =3D btrfs_file_extent_disk_bytenr(src,=
 extent);
> +
> +                       if (log_extent_needs_stripe_tree(trans->fs_info, =
bytenr))
> +                               return BTRFS_LOG_FORCE_COMMIT;
> +               }
> +
>                 if (skip_csum)
>                         goto add_to_batch;
>
> @@ -5124,6 +5152,9 @@ static int log_one_extent(struct btrfs_trans_handle=
 *trans,
>         u64 block_len;
>         int ret;
>
> +       if (log_extent_needs_stripe_tree(inode->root->fs_info, em->disk_b=
ytenr))
> +               return BTRFS_LOG_FORCE_COMMIT;
> +
>         btrfs_set_stack_file_extent_generation(&fi, trans->transid);
>         if (em->flags & EXTENT_FLAG_PREALLOC)
>                 btrfs_set_stack_file_extent_type(&fi, BTRFS_FILE_EXTENT_P=
REALLOC);
> --
> 2.56.0
>
>
