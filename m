Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795712958;
	b=s0LItZbsffSeQ1B3UIxieG1ZfXR7kJwrcmGVaAXIXx94EgqbdYGpSZ8i54mghe6SLu3S
	 zHQyFFno8rkSdiin5j1Lb/KbvBG7oxB8gDza1HBpmfzGiibk7YRFNTaigobO1IG/UI0+o
	 hZyYGhZJStyK3uCftJnTrWpyH4CqJ0QcFiMzlBFT/i88fRVtCT8RemFIkZaxwObKKJ/Yb
	 kI1dn9Na1rEgI+7dxibMbIuucIQsX7m982T+KO+YIHqjA07zrqgCjoukEUWLSxUBT+uJq
	 PYvK8pfoXmIkh2tUP/iHQbUqRyS5E1sjudazqo/ZdHnozTtfzsicfLOwawytS8njU3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795712958;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=il4uxrRB2DRKWBLesVcYgP97mBDI3r3pfIL9Rxur69w=;
	b=eHeuhMkQg/oU36ETj5aJ0mfas8XaGgNkF0nW+G1dIQ/FiyyUJHMHuKZ/kVaGZt+4669v
	 OZA117yUXwsqdBKiiDcYfeeX7d3FlSmVyPupdTXbofcXzDjeavW/4J/Xw17HofVscH/NB
	 GcNDVVyxWh71Jn46TgAk8Ndabvm0VizCDu9W+els4ZQXjj0bm+TgrqjB8cwaO/m8DQ204
	 EpkSFM49M+RbRCoL4Ghl4rL+5qlBRsQ6WVzwCKyx6jCRr3qdLC+/mBiO27mirtl2319+/
	 vT/cI5TyIQZUfRsLciZ8trwI2XxKOsMZqWIlV5iLfHhiInmao4BCxzlhvAF0nkWd+Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hKHkU8dj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4E6606A321
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 17:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hKHkU8dj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305331F000C4
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 17:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795712958;
	bh=il4uxrRB2DRKWBLesVcYgP97mBDI3r3pfIL9Rxur69w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hKHkU8djh3zGqyOOJBcGoQ2rQ+hpmv7pZGspPk+VTYVskwe+cpbF5HVnT2RgKyWNv
	 434D+sUsIQnB+7lvlI3+rhCFmDgeWZrVQqn5ZpBREHR3OU506qqISDzAeeNIcyhtXI
	 pDvFaWK9tdorPyLeqpYlEceGD6QSTG11kG5bfZnKIeOrr1rqpld6SPqvwsi3Rtc6tx
	 g9HPueYPGf8KuzneGkv1b/EQFYpv4h4rmiJvvKrwiGuJ+hGk/RvYUbZVXvS2ww4+zZ
	 03SQK4ZCu+mx+GW/wQBsm2EiGUh5zZCY8LfvxtCACLscfMIgoHYKyYdoI46Q/QRoxH
	 zNh7QQVVwmAvg==
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-74ab99038afso4711511137.3
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 09:09:18 -0800 (PST)
X-Gm-Message-State: APuU4Z/nVHksEIkJOw9a9fGL2zcMJR2hIdRhphD9pbrnMIOAiJEb3PEo
	pTu11d2Dg7PLaDTb/12JnU3Nr5ba8OVWlAxNmmT9oUBlqU4lJUu0079b5/3Epbqxg/ImB79p3Uv
	TxdtopizwEi1ooVxg1QpyG9Iefhh5fcc=
X-Received: by 2002:a05:6102:1621:b0:7cc:1045:604 with SMTP id
 ada2fe7eead31-7d73962898cmr12814270137.30.1795712957318; Thu, 26 Nov 2026
 09:09:17 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1795576387.git.wqu@suse.com> <a5657fae3becb14bcece1c86975f15584a048f73.1795576387.git.wqu@suse.com>
In-Reply-To: <a5657fae3becb14bcece1c86975f15584a048f73.1795576387.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 26 Nov 2026 17:08:41 +0000
X-Gmail-Original-Message-ID: <CAL3q7H66YYKGqcx1cfUFzEBFeEUaZ9cHPkjEL0n+MdEv0GdRpA@mail.gmail.com>
X-Gm-Features: Aa3M54qDESr0wJWtlrCWzLPvEE_Yv1I8X--nNyy_3zjxvcty11dtwnfQ1ndFobk
Message-ID: <CAL3q7H66YYKGqcx1cfUFzEBFeEUaZ9cHPkjEL0n+MdEv0GdRpA@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: tree-checker: reject parent backref that goes
 beyond MAX_LEVEL
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 3:15=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> Inspired by recent fixes to handle_indirect_tree_backref() and the
> original sashiko report, if a tree block is already at the max level
> (MAX_LEVEL - 1), it should not have a parent except itself.
>
> The self-parent case is for reloc tree and legacy case where backref_rev
> is smaller than BTRFS_MIXED_BACKREF_REV.
>
> So reject them when checking the inlined extent item.
> This is a very low priority hardening, as it's very hard to hit such
> high level tree block in the real world.
>
> Please note that, this is not going to cover all cases, keyed backref
> can still introduce the same problem, but with the default skinny
> metadata, we should catch most cases now.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
>  fs/btrfs/tree-checker.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index f021ac14babf..f7bc1ea19a0c 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1537,6 +1537,7 @@ static int check_extent_item(struct extent_buffer *=
leaf,
>         struct btrfs_fs_info *fs_info =3D leaf->fs_info;
>         struct btrfs_extent_item *ei;
>         bool is_tree_block =3D false;
> +       u8 level =3D 0;           /* Tree block level, only for tree bloc=
ks */
>         unsigned long ptr;      /* Current pointer inside inline refs */
>         unsigned long end;      /* Extent item end */
>         const u32 item_size =3D btrfs_item_size(leaf, slot);
> @@ -1666,14 +1667,17 @@ static int check_extent_item(struct extent_buffer=
 *leaf,
>                 struct btrfs_tree_block_info *info;
>
>                 info =3D (struct btrfs_tree_block_info *)ptr;
> -               if (unlikely(btrfs_tree_block_level(leaf, info) >=3D BTRF=
S_MAX_LEVEL)) {
> +               level =3D btrfs_tree_block_level(leaf, info);
> +               if (unlikely(level >=3D BTRFS_MAX_LEVEL)) {
>                         extent_err(leaf, slot,
>                         "invalid tree block info level, have %u expect [0=
, %u]",
> -                                  btrfs_tree_block_level(leaf, info),
> -                                  BTRFS_MAX_LEVEL - 1);
> +                                  level, BTRFS_MAX_LEVEL - 1);
>                         return -EUCLEAN;
>                 }
>                 ptr =3D (unsigned long)(struct btrfs_tree_block_info *)(i=
nfo + 1);
> +       } else if (is_tree_block) {
> +               /* METADATA_ITEM_KEY, key->offset is already verified. */
> +               level =3D key->offset;
>         }
>
>         /* Check inline refs */
> @@ -1719,6 +1723,20 @@ static int check_extent_item(struct extent_buffer =
*leaf,
>                                            inline_offset, fs_info->sector=
size);
>                                 return -EUCLEAN;
>                         }
> +                       /*
> +                        * A tree block at the highest level can not have=
 a
> +                        * parent node.
> +                        * The exception is the root of a reloc tree, or =
of a
> +                        * legacy tree with backref_rev < BTRFS_MIXED_BAC=
KREF_REV,
> +                        * which use the block itself as the parent.
> +                        */
> +                       if (unlikely(level =3D=3D BTRFS_MAX_LEVEL - 1 &&
> +                                    inline_offset !=3D key->objectid)) {
> +                               extent_err(leaf, slot,
> +       "invalid inline shared block ref, tree block at level %u can not =
have parent %llu",
> +                                          level, inline_offset);
> +                               return -EUCLEAN;
> +                       }
>                         inline_refs++;
>                         break;
>                 /*
> --
> 2.56.1
>
>
