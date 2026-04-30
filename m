Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F08A3D6472
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 11:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777548140; cv=none; b=X08QFdgnicXaJeY7FzjOaqzYp1PvWo6WNJhENUylvHUUWvNn6vapdOAP+oUM6uHrv2ly22WcZ/JrBMZ7MwdesKi7GdAPBpVIzITYWLwnqUaWC4+B5eoIKq1JQHHd/XydeSD3LMhiTVvUU5fJwlkuJHyQKE2Y9xZQYP2l21rb1d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777548140; c=relaxed/simple;
	bh=x/C0OQbv04JS8s7SXRWpGkVORwb1DcYw9yJhsKoBOQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IlJkS3X3miHjEBJJX2Jx9TvupvaPSAZmVC2rR1NytapIKiv3L/vFcb8n3GmOCrG70jXPaLQxzJZ6wE/vOIkhV4SSauFWQWT+oyOGhyF7pOPHzg7MbQxi26cif2U6unDwgRaxVgWqJ02KGS/hciYlbC0K/+sjGVQzIa0Xf3W+Tic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SW+wuwMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SW+wuwMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC413C2BCB3
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 11:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777548140;
	bh=x/C0OQbv04JS8s7SXRWpGkVORwb1DcYw9yJhsKoBOQY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SW+wuwMB6IBUJ8QzcIwA36XqWoddFMNNSWdr7su480XwDMwNjYXkCGD+rfVquJ/CZ
	 gpSGoLjA3PNB7VWh2kM5mOwP/FieyJBb67OIhyofoOAYcEIRVeVz29qml8r421ZvFg
	 3Az5XZZ2vwayQhChfSGO7Ggs7QCgzAeSVzO6OYkceDbM/o1vKT29HnJnhEVnygclCY
	 ebHOXRWF/cDFZVkPtWZd+R9ZytXMhOc2fpoKcV1phIF91ujrYrwfclzbDC4oUbY7sY
	 d4UvJty42cuRus4Oxn3oEov3Lz7Ekx2WXo0M5Hifix8yv5we7jv59i1QFaubwxUHk6
	 UHSzXdxjnBQUQ==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ba545100a13so135952166b.2
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 04:22:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9t7u+72YYqHu/5QJU+ooGHO7yUm5oy9x0ieOp7JCgAI5TetKvAmm6ybMHY+FRdUf3Bzq1bk1iID4QcUg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyI3L6Y0m9i6nM/vpFlv/2TXs88yqxooltoMOVhH7z+qSHlybz+
	oh7Yl871cinJjGTSatdJRXeF4wfS3ypkKOCI9TYGY8zOhYX+DA+QucL2YUC2NIFOan/rg8iSqGh
	FYne3/LX3E/TTdJraxRrWJCAflx4c64w=
X-Received: by 2002:a17:907:9613:b0:ba3:99:29d0 with SMTP id
 a640c23a62f3a-bbac50f06f5mr159737466b.18.1777548138476; Thu, 30 Apr 2026
 04:22:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260429021351.596972-1-davechen@synology.com> <20260430022721.1274249-1-davechen@synology.com>
In-Reply-To: <20260430022721.1274249-1-davechen@synology.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 30 Apr 2026 12:21:40 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7Aarcgd-x0ejNAjDVsqUYdXDLg5Ka_mKVNRJP=OK9mjw@mail.gmail.com>
X-Gm-Features: AVHnY4JqN3X1dVpQa4qnS33PIUY4XQRqgmd033X-4dD7vbfv2ONfxzv08RphW9s
Message-ID: <CAL3q7H7Aarcgd-x0ejNAjDVsqUYdXDLg5Ka_mKVNRJP=OK9mjw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: optimize fill_holes() to merge a new hole with
 both adjacent items
To: Dave Chen <davechen@synology.com>
Cc: fdmanana@suse.com, cccheng@synology.com, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 30, 2026 at 3:31=E2=80=AFAM Dave Chen <davechen@synology.com> w=
rote:
>
> fill_holes() currently merges a punched hole with either the previous
> or the next file extent item, but never both in the same call.  When
> holes are punched in a non-sequential order this leaves consecutive
> hole items in the inode's subvolume tree that should have been collapsed
> into a single one.
>
> This is a minor metadata optimization that reduces the number of file
> extent items when holes are punched in non-sequential order. While
> having extra file extent items is harmless and has no functional
> impact, reducing metadata overhead can benefit workloads with heavily
> fragmented hole patterns.
>
> For example:
>
>   fallocate -p -o 4K  -l 4K ${FILE}
>   fallocate -p -o 12K -l 4K ${FILE}
>   fallocate -p -o 8K  -l 4K ${FILE}
>
> After the third punch the [4K, 8K) and [12K, 16K) holes become
> adjacent to the new [8K, 12K) hole, but fill_holes() merges only one
> side and leaves two separate hole items ([4K, 12K) and [12K, 16K))
> instead of the expected single [4K, 16K) hole item.
>
> Fix this by checking both path->slots[0] - 1 and path->slots[0] in one
> pass:
>
>   - If only the previous slot is mergeable, extend it forward as
>     before.
>   - If only the next slot is mergeable, extend it backward and update
>     its key offset as before.
>   - If both are mergeable, extend the previous item to cover the new
>     hole plus the next item, and remove the redundant next item with
>     btrfs_del_items().
>
> Because the merge path may now delete an item, switch the initial
> btrfs_search_slot() call from a plain lookup (ins_len =3D 0) to a
> search-for-deletion (ins_len =3D -1), so the leaf is prepared for a
> possible item removal.
>
> Note: This optimization only applies to filesystems without the
> NO_HOLES feature enabled. Since NO_HOLES is now the default, this
> primarily benefits older filesystems or those explicitly created with
> NO_HOLES disabled.
>
> Signed-off-by: Dave Chen <davechen@synology.com>
> ---
> Changes in v2:
> - Replace "file extent tree" with "inode's subvolume tree" to avoid
>   confusion with the global extent tree (Filipe)
> - Remove the Fixes: tag as this is a minor metadata optimization
>   rather than a functional bug fix (Filipe)
> - Reframe commit message to explicitly characterize this as a small
>   optimization with no functional impact (Filipe)
> - Add note about NO_HOLES default status and applicability scope
>
>  fs/btrfs/file.c | 48 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 31 insertions(+), 17 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index cf1cb5c4db757..84450452d2347 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2093,6 +2093,10 @@ static int fill_holes(struct btrfs_trans_handle *t=
rans,
>         struct btrfs_file_extent_item *fi;
>         struct extent_map *hole_em;
>         struct btrfs_key key;
> +       int modify_slot =3D -1;
> +       int del_slot =3D -1;
> +       bool update_offset =3D false;
> +       u64 num_bytes =3D 0;
>         int ret;
>
>         if (btrfs_fs_incompat(fs_info, NO_HOLES))
> @@ -2102,7 +2106,7 @@ static int fill_holes(struct btrfs_trans_handle *tr=
ans,
>         key.type =3D BTRFS_EXTENT_DATA_KEY;
>         key.offset =3D offset;
>
> -       ret =3D btrfs_search_slot(trans, root, &key, path, 0, 1);
> +       ret =3D btrfs_search_slot(trans, root, &key, path, -1, 1);
>         if (ret <=3D 0) {
>                 /*
>                  * We should have dropped this offset, so if we find it t=
hen
> @@ -2115,33 +2119,43 @@ static int fill_holes(struct btrfs_trans_handle *=
trans,
>
>         leaf =3D path->nodes[0];
>         if (hole_mergeable(inode, leaf, path->slots[0] - 1, offset, end))=
 {
> -               u64 num_bytes;
> -
> -               path->slots[0]--;
> -               fi =3D btrfs_item_ptr(leaf, path->slots[0],
> +               fi =3D btrfs_item_ptr(leaf, path->slots[0] - 1,
>                                     struct btrfs_file_extent_item);
>                 num_bytes =3D btrfs_file_extent_num_bytes(leaf, fi) +
>                         end - offset;
> -               btrfs_set_file_extent_num_bytes(leaf, fi, num_bytes);
> -               btrfs_set_file_extent_ram_bytes(leaf, fi, num_bytes);
> -               btrfs_set_file_extent_offset(leaf, fi, 0);
> -               btrfs_set_file_extent_generation(leaf, fi, trans->transid=
);
> -               goto out;
> +               modify_slot =3D path->slots[0] - 1;
>         }
> -
>         if (hole_mergeable(inode, leaf, path->slots[0], offset, end)) {
> -               u64 num_bytes;
> -
> -               key.offset =3D offset;
> -               btrfs_set_item_key_safe(trans, path, &key);
>                 fi =3D btrfs_item_ptr(leaf, path->slots[0],
>                                     struct btrfs_file_extent_item);
> -               num_bytes =3D btrfs_file_extent_num_bytes(leaf, fi) + end=
 -
> -                       offset;
> +               if (modify_slot !=3D -1) {
> +                       num_bytes +=3D btrfs_file_extent_num_bytes(leaf, =
fi);
> +                       del_slot =3D path->slots[0];
> +               } else {
> +                       num_bytes =3D btrfs_file_extent_num_bytes(leaf, f=
i) +
> +                               end - offset;
> +                       modify_slot =3D path->slots[0];
> +                       update_offset =3D true;
> +               }
> +       }
> +       if (modify_slot >=3D 0) {
> +               fi =3D btrfs_item_ptr(leaf, modify_slot,
> +                                   struct btrfs_file_extent_item);
>                 btrfs_set_file_extent_num_bytes(leaf, fi, num_bytes);
>                 btrfs_set_file_extent_ram_bytes(leaf, fi, num_bytes);
> +               if (update_offset) {
> +                       key.offset =3D offset;
> +                       btrfs_set_item_key_safe(trans, path, &key);
> +               }
>                 btrfs_set_file_extent_offset(leaf, fi, 0);
>                 btrfs_set_file_extent_generation(leaf, fi, trans->transid=
);
> +               if (del_slot >=3D 0) {
> +                       ret =3D btrfs_del_items(trans, root, path, del_sl=
ot, 1);
> +                       if (ret) {

Here, upon error, we must abort the transaction, otherwise metadata
will be inconsistent because we modified the item at modify_slot.

Otherwise it looks fine, thanks.

> +                               btrfs_release_path(path);
> +                               return ret;
> +                       }
> +               }
>                 goto out;
>         }
>         btrfs_release_path(path);
> --
> 2.43.0
>
>
> Disclaimer: The contents of this e-mail message and any attachments are c=
onfidential and are intended solely for addressee. The information may also=
 be legally privileged. This transmission is sent in trust, for the sole pu=
rpose of delivery to the intended recipient. If you have received this tran=
smission in error, any use, reproduction or dissemination of this transmiss=
ion is strictly prohibited. If you are not the intended recipient, please i=
mmediately notify the sender by reply e-mail or phone and delete this messa=
ge and its attachments, if any.
>
