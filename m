Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FC62D780C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 19:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773777280; cv=none; b=tWu3wBVt9Oqmg0S5od96jDU9TTuRCD50r/bwjKD/JvICdpKK98OOJXKtNgguW5IJpIHt8DcCBEI/bjB6gBXM2XM1+FGcEcMAjg9bUGbIgv7vaZbW0zH7+RKoWAIkvjVOED2uWD16xhbLADJS7bGJ3JV97zcS2eXe4biwAieIMT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773777280; c=relaxed/simple;
	bh=tcpy5nZQbKvD7cen2UDYpjtxlToZzEPKqp6MKyQgTC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aBV5ghuoa3FdSt1i5b0UJNYJSGdtxnKmD2cMMGTyQJVN1GHBnForXf17BSuPVKXsfqm/sUzJsLcxhtRm68sfjTaR01m/GmPzs137FslkRXI4wGo7/L2Nq4BTCsSIKzP+jXykczJAGi+ZuBBGBEuFW6oOryGDx9ITm5p5AcdrMSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gZ2l9LCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZ2l9LCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A30C4CEF7
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 19:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773777280;
	bh=tcpy5nZQbKvD7cen2UDYpjtxlToZzEPKqp6MKyQgTC0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gZ2l9LCknrmfrbtUlTnoytZis7xLX55kdqTW57uFsBXVb4QUdu2UdL5f3yJYNwKKZ
	 pKecOC+quNQRl7TJC5xMzid7bgolZIk5AQIZWhWhLJvL8QwEhsTgiQCYiNLf9G+dXy
	 pmU4JzjWIIotdSn0UWl3+lGnhHik/Ry38xxHfXza0soCEbo9GGEeECUl/BpqqwMcEk
	 LcHBEAYzK1KDz2dRl3uIPTkOB937b0DmelKpjNVuqEyeMygra9r1nTiHWJ4UBeBXWL
	 7y92hWVX8+KbIwsYpowLZpqQeenm9OngVfcFpc1gU5jU45zUoHCRv0lnRm65WdnMUB
	 QcOpqJS464Sng==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b97be593f09so37985566b.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 12:54:40 -0700 (PDT)
X-Gm-Message-State: AOJu0YyLstqe333ORkijDrY2U6yskRet3UIq1m9yUsgCldEIcV2v9nWE
	FCQGlYlNbZYXMQ1SikIeqipTJSvJ73+UVxwONqJjfvk+TgWhMVa/5/uv0XYIVkjjnLNT7+a89Et
	GN7SRpkq0Mpc+pZt7AU3A5wnISNE4r2c=
X-Received: by 2002:a17:907:3f26:b0:b97:ec8d:b10e with SMTP id
 a640c23a62f3a-b97ec8db2c1mr114462866b.27.1773777278686; Tue, 17 Mar 2026
 12:54:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260317132526.299099-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260317132526.299099-1-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 17 Mar 2026 19:54:01 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4SzFpqBYCZ7V52Gg-c=oRCTGKp==QUhy26kBdKfJEG-g@mail.gmail.com>
X-Gm-Features: AaiRm5209MdRDyyctyb-whuLuPGsD5klFWS_sq1LfsC2GEgl21r2-e6LYRtbFr8
Message-ID: <CAL3q7H4SzFpqBYCZ7V52Gg-c=oRCTGKp==QUhy26kBdKfJEG-g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: decrease indendation of find_free_extent_update_loop
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 17, 2026 at 1:29=E2=80=AFPM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> Decrease the indendation of find_free_extent_update_loop(), by inverting
> the check if the loop state is smaller than LOOP_NO_EMPTY_SIZE.
>
> This also allows for an early return from find_free_extent_update_loop(),
> in case LOOP_NO_EMPTY_SIZE is already set at this point.
>
> While at if change a

if -> it

>
> if () {
> }
> else if
> else
>
> pattern to all using curly braces and be consistent with the rest of btrf=
s
> code.
>
> No functional changes intended.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/extent-tree.c | 111 +++++++++++++++++++++--------------------
>  1 file changed, 57 insertions(+), 54 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a55b910c755b..062fc1beb26b 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4349,71 +4349,74 @@ static int find_free_extent_update_loop(struct bt=
rfs_fs_info *fs_info,
>                 return 1;
>
>         /* See the comments for btrfs_loop_type for an explanation of the=
 phases. */
> -       if (ffe_ctl->loop < LOOP_NO_EMPTY_SIZE) {
> -               ffe_ctl->index =3D 0;
> -               /*
> -                * We want to skip the LOOP_CACHING_WAIT step if we don't=
 have
> -                * any uncached bgs and we've already done a full search
> -                * through.
> -                */
> -               if (ffe_ctl->loop =3D=3D LOOP_CACHING_NOWAIT &&
> -                   (!ffe_ctl->orig_have_caching_bg && full_search))
> -                       ffe_ctl->loop++;
> +       if (ffe_ctl->loop =3D=3D LOOP_NO_EMPTY_SIZE)
> +               return -ENOSPC;
> +
> +       ffe_ctl->index =3D 0;
> +       /*
> +        * We want to skip the LOOP_CACHING_WAIT step if we don't have
> +        * any uncached bgs and we've already done a full search
> +        * through.
> +        */
> +       if (ffe_ctl->loop =3D=3D LOOP_CACHING_NOWAIT &&
> +           (!ffe_ctl->orig_have_caching_bg && full_search))
>                 ffe_ctl->loop++;
> +       ffe_ctl->loop++;
>
> -               if (ffe_ctl->loop =3D=3D LOOP_ALLOC_CHUNK) {
> -                       struct btrfs_trans_handle *trans;
> -                       int exist =3D 0;
> +       if (ffe_ctl->loop =3D=3D LOOP_ALLOC_CHUNK) {
> +               struct btrfs_trans_handle *trans;
> +               int exist =3D 0;

This is a good opportunity to change the variable type to bool and
give it a more meaningful and correct name:

bool have_trans =3D false;

>
> -                       /* Check if allocation policy allows to create a =
new chunk */
> -                       ret =3D can_allocate_chunk(fs_info, ffe_ctl);
> -                       if (ret)
> -                               return ret;
> +               /* Check if allocation policy allows to create a new chun=
k */

A good opportunity too to add missing punctuation to comment.

> +               ret =3D can_allocate_chunk(fs_info, ffe_ctl);
> +               if (ret)
> +                       return ret;
>
> -                       trans =3D current->journal_info;
> -                       if (trans)
> -                               exist =3D 1;
> -                       else
> -                               trans =3D btrfs_join_transaction(root);
> +               trans =3D current->journal_info;
> +               if (trans)
> +                       exist =3D 1;

And then here:

have_trans =3D true;

> +               else
> +                       trans =3D btrfs_join_transaction(root);
>
> -                       if (IS_ERR(trans))
> -                               return PTR_ERR(trans);
> +               if (IS_ERR(trans))
> +                       return PTR_ERR(trans);
>
> -                       ret =3D btrfs_chunk_alloc(trans, space_info, ffe_=
ctl->flags,
> -                                               CHUNK_ALLOC_FORCE_FOR_EXT=
ENT);
> +               ret =3D btrfs_chunk_alloc(trans, space_info, ffe_ctl->fla=
gs,
> +                                       CHUNK_ALLOC_FORCE_FOR_EXTENT);
>
> -                       /* Do not bail out on ENOSPC since we can do more=
. */
> -                       if (ret =3D=3D -ENOSPC) {
> -                               ret =3D 0;
> -                               ffe_ctl->loop++;
> -                       }
> -                       else if (ret < 0)
> -                               btrfs_abort_transaction(trans, ret);
> -                       else
> -                               ret =3D 0;
> -                       if (!exist)
> -                               btrfs_end_transaction(trans);
> -                       if (ret)
> -                               return ret;
> +               /* Do not bail out on ENOSPC since we can do more. */
> +               if (ret =3D=3D -ENOSPC) {
> +                       ret =3D 0;
> +                       ffe_ctl->loop++;
> +               } else if (ret < 0) {
> +                       btrfs_abort_transaction(trans, ret);
> +               } else {
> +                       ret =3D 0;
>                 }
>
> -               if (ffe_ctl->loop =3D=3D LOOP_NO_EMPTY_SIZE) {
> -                       if (ffe_ctl->policy !=3D BTRFS_EXTENT_ALLOC_CLUST=
ERED)
> -                               return -ENOSPC;
> +               if (!exist)

And here:

if (!have_trans)

And have such change mentioned in the changelog too.

Otherwise it looks good:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.


> +                       btrfs_end_transaction(trans);
>
> -                       /*
> -                        * Don't loop again if we already have no empty_s=
ize and
> -                        * no empty_cluster.
> -                        */
> -                       if (ffe_ctl->empty_size =3D=3D 0 &&
> -                           ffe_ctl->empty_cluster =3D=3D 0)
> -                               return -ENOSPC;
> -                       ffe_ctl->empty_size =3D 0;
> -                       ffe_ctl->empty_cluster =3D 0;
> -               }
> -               return 1;
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       if (ffe_ctl->loop =3D=3D LOOP_NO_EMPTY_SIZE) {
> +               if (ffe_ctl->policy !=3D BTRFS_EXTENT_ALLOC_CLUSTERED)
> +                       return -ENOSPC;
> +
> +               /*
> +                * Don't loop again if we already have no empty_size and
> +                * no empty_cluster.
> +                */
> +               if (ffe_ctl->empty_size =3D=3D 0 &&
> +                   ffe_ctl->empty_cluster =3D=3D 0)
> +                       return -ENOSPC;
> +               ffe_ctl->empty_size =3D 0;
> +               ffe_ctl->empty_cluster =3D 0;
>         }
> -       return -ENOSPC;
> +
> +       return 1;
>  }
>
>  static int prepare_allocation_clustered(struct btrfs_fs_info *fs_info,
> --
> 2.53.0
>
>
