Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F809214813
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 15:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777909665; cv=none; b=Fs89YkVMa0MQQ0165dvM0NXZeSL6slFnaaEr70bPti7HKTyxRFNKyRISMh5vPU7KVPrr73r3NRLmxbqb5FYfZ/65qNMxAhpZJBxpIDbO0+Wcq0S2Aq94EN+BKsrF0V52U2pBlTT1Hh/i2xbseUrITE40vLvXuONfJcWXZCaZ8Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777909665; c=relaxed/simple;
	bh=jgTA5eW+WC9E9ZuSTFQvsQ5ax97MR7X2xWxzAmNqUOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ErqUYYkC77nePXfdZGMmXre0Cbxv7vZsk06ocIe88T4sMWxNLSMYGZt3oJbJ29tDuMbrpY3BLxznRZJ7aTirhjErzTKBDZ57M1zGyYKPNXf/ZTw72ONI5ZraJV8W7bfIxXBHOeHXdHFFaWso6KxFvoHvtBIqkUZMS3NP2HTCEG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpw6Ei6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpw6Ei6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2DFC2BCC4
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 15:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777909665;
	bh=jgTA5eW+WC9E9ZuSTFQvsQ5ax97MR7X2xWxzAmNqUOY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dpw6Ei6d39rRCStFmI90RdaZgl+OAbbTFfGfhbT1zfczuj2GPwY+CZ+yIs3nEssTf
	 HRH/+uWYkZb0gl3VX6f5Y/0o/Fb8MJgv3Ennhv5s3QPCbRkUuuWjFzsWs01PqqncqX
	 pffW5TW7dzjK353+wGKwk28Ttl/Sg5UfAQV7i4iESIJR9tQF2wTTA7BxVFwFs7TIiW
	 AYfbamRBcT5Ps6gqgINeRAwvZ1p37kCXDKl/UyAmuNPPnlx8n4A+IMmi8bWxMdxM8/
	 UAc0kUtU+POVa5pHL9PqXyh5nNyfAXrKv15xP44WGkcGEncogdL0P2eljCh3f0Nlnu
	 QIb8+cw7oPeng==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-bab8ae52954so643417166b.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2026 08:47:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8ZQm54EC+UPzDA5ehji3lZwkSexe+w+k3nB0d855tpyBybshd4q4yY7GdtAbi8NFiuAfSi2gmEfQ/75A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzgcmdz9EsVrtb8AfPxpJMK/8hJ81TnpRGTQiDBKfZvoHYndc50
	J+CppSGjpgHVxVtEOuRT+Hbftmt1BXgVKxe4xVDo4p4lwEEwfb+OZD0EdKhZlR48I8KoQPdtrTb
	bYdOcFl0XPL+4KsjhZyACRlA4+oi2GoU=
X-Received: by 2002:a17:906:9fcf:b0:ba6:be92:a58f with SMTP id
 a640c23a62f3a-bbffd8c7a5fmr551929166b.44.1777909663469; Mon, 04 May 2026
 08:47:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260429021351.596972-1-davechen@synology.com> <20260504014356.3548849-1-davechen@synology.com>
In-Reply-To: <20260504014356.3548849-1-davechen@synology.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 4 May 2026 16:47:05 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7UOOEn2r5gMM_zfOPNz5ziQgBYDK-2Fcm9nrYFLK6K_w@mail.gmail.com>
X-Gm-Features: AVHnY4LOmL9eps_WUn0llQLyMXeHv7K1DfWGhbE_wYcuV-ZdlnER_RtTx28QR7s
Message-ID: <CAL3q7H7UOOEn2r5gMM_zfOPNz5ziQgBYDK-2Fcm9nrYFLK6K_w@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: optimize fill_holes() to merge a new hole with
 both adjacent items
To: Dave Chen <davechen@synology.com>
Cc: fdmanana@suse.com, cccheng@synology.com, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 4, 2026 at 2:44=E2=80=AFAM Dave Chen <davechen@synology.com> wr=
ote:
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

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks, pushed it to the for-next branch in github.

> ---
> Changes in v3:
> - Add btrfs_abort_transaction() on btrfs_del_items() failure to
>   prevent metadata inconsistency (Filipe)
>
> Changes in v2:
> - Replace "file extent tree" with "inode's subvolume tree" to avoid
>   confusion with the global extent tree (Filipe)
> - Remove the Fixes: tag as this is a minor metadata optimization
>   rather than a functional bug fix (Filipe)
> - Reframe commit message to explicitly characterize this as a small
>   optimization with no functional impact (Filipe)
> - Add note about NO_HOLES default status and applicability scope
>
>  fs/btrfs/file.c | 49 ++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 32 insertions(+), 17 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index cf1cb5c4db757..44ed7ddecd451 100644
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
> @@ -2115,33 +2119,44 @@ static int fill_holes(struct btrfs_trans_handle *=
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
> +                               btrfs_abort_transaction(trans, ret);
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
