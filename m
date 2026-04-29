Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8243A3F0AAB
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 11:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777461851; cv=none; b=ELoyU3Bo6J99sFrK2BVUsipe2ISPKuAW148R+GpFMshtTKSqSqcDUvPrRjJjfJcD3syXUNnV8sZEQRW4EdZTYPBAECeqbfU3Dic4lvrnXXoYQKMhe1IcMZ31aFlXKdYkiEroQXryWtZnGeRzqylZXrOKVm3Kx+tuWgKaujj1oa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777461851; c=relaxed/simple;
	bh=GaSOwoM69eeDjB5BWxJbZoCrxKPRlWPy3RA3E8HQ9V0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WmHVVtrUqWkV7goVyqVoCfXOJlzdp95ixy8mkps+GyUXwon9xw8qZfG3PMeiGppGVxENemN8euFsWWxgp0zPRc8b+sqDVabRozQG0OhTzUDE3fqHGkNrdxepxjv8hA26CX9Ryd1FmXEu21azuhhwTroXtRFydcVPG2ANL1Snf1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kUBjU7hq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUBjU7hq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E27C2BCB3
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 11:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777461851;
	bh=GaSOwoM69eeDjB5BWxJbZoCrxKPRlWPy3RA3E8HQ9V0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kUBjU7hqYgunpM7OGxSi46fldlZY0ZgWhzTvjW/6Mp5ZpkjZrFuWkvPpL1b4mDejs
	 Jcl2cuH/m/qkDXLhyZPmrS9xCN7vobrPbI4LwTPM4BLF87utnjLuwU5YK1cSiEdFpu
	 aTBjOxYqoTLVtvezSZ+MBrUwSWn6VqkD38eaY/HqILPpvVYnMkNymKLmLvOPTXH2CF
	 7qfbhmljqj1jXwKxMI9ckG+HY24FhdKx2jVDWy+kZy0paTU1TxA4XXenuYQNExEIwq
	 Nscj4r6ZFryYkFPDmf4EKtMcsildz6J7ZvhYUeTHiIB9dJszXSlN6/4XqhSBTpuCWU
	 yy+SaXjclconw==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b9358dd7f79so976038566b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 04:24:10 -0700 (PDT)
X-Gm-Message-State: AOJu0YzW4N9FkxzcNJwNaELoNekZ+eD7LMZAMUf0bWcUUI0OIwJQ7hS5
	qhec1GGeeU7o/140UIvqRRv7xwjMRKtffg/upvnIbT6put9nqi1hFueuVKwRCisivH99HZ7ah+T
	75e4Tqa1aO1lHC/8rT+a1+QCXOkWKp8c=
X-Received: by 2002:a17:907:7a8e:b0:ba7:7f6d:be4a with SMTP id
 a640c23a62f3a-bb8038736a2mr472179866b.26.1777461849498; Wed, 29 Apr 2026
 04:24:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260429021351.596972-1-davechen@synology.com>
In-Reply-To: <20260429021351.596972-1-davechen@synology.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 29 Apr 2026 12:23:31 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7MfHDLMYy5L=JDNjBdU_eYn=5867dEba1G87Mqs7tw4g@mail.gmail.com>
X-Gm-Features: AVHnY4LkYp8raPCvdI0fuewV0AwMoOQZ8fQW1Fc9WJ7eNyqxBh2q38pjHl9m_xY
Message-ID: <CAL3q7H7MfHDLMYy5L=JDNjBdU_eYn=5867dEba1G87Mqs7tw4g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix fill_holes() to merge a new hole with both
 adjacent items
To: Dave Chen <davechen@synology.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, cccheng@synology.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2026 at 3:16=E2=80=AFAM Dave Chen <davechen@synology.com> w=
rote:
>
> fill_holes() currently merges a punched hole with either the previous
> or the next file extent item, but never both in the same call.  When
> holes are punched in a non-sequential order this leaves consecutive
> hole items in the file extent tree that should have been collapsed

file extent tree -> inode's subvolume tree

Using the term "file extent tree" is confusing because we have a
global extent tree for all data (and metadata) extents, and file items
are stored in a subvolume/fs tree.

> into a single one.

Ok, but that's harmless, we just use one more metadata item (file extent it=
em).

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
> Fixes: 2aaa66558172 ("Btrfs: add hole punching")

I pointed this out to you in a previous patch: the Fixes tag is meant
only for bug fixes or serious performance regressions that impact
users.
This is a small inefficiency; having an extra file extent item is
harmless - and more irrelevant today since no-holes has been the
default for some years now.

You're making it sound like a functional bug or a serious performance issue=
.
Please make it explicit in the changelog that this is only a small
inefficiency.

Thanks.

> Signed-off-by: Dave Chen <davechen@synology.com>
> ---
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
