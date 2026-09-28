Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF055388860
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 18:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790620482; cv=none; b=ngwBPC4+9X6kTihCBgr0LfquI/7Y2Om/y2N0f07yfbNnY1YngXs4fd+rQyV045vCyhAQCoyf7tyLeyl5c38QkoG1frRyy/6YaYRwLuZe24KykfyPj9uPB18esCROouNb90/D9xoiWaBkx6irBjb6+n8bUVPz1WvPwSlUufGCM5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790620482; c=relaxed/simple;
	bh=Ch/l9BEXIvj+MJvgxbhHHvReoRMdp7ZV7lBHvHDvxBw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=riJpS/dfoKJ1qctwLsiuoiwcQIHJsY1hVpZslkOOtR7clgF77iCZ37xN9SKoWTnB+JHRRun40DWMQT1UZS6YfSLwB0PszsEjzNKlQcBsoQzxdNqxi/JnyAJ4P1lc4WToQE3NbshKPyQ7m6wUSBzRGl6CJtMhLdU2KB/ikFgItdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kptFicth; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kptFicth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11FF1F00893
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 18:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790620480;
	bh=d3BeyuyHtxUbcF7fyJ6ugIHejkrYFTuHOi8kWJ6pZ+g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kptFicth/Tu6Eplrjs9JNlqzafqmPP+zI/xoduwPht6H6E1JvMNZeaJSY637dF9ug
	 rSqWkyppaI6TzSuNFvuXKyCGIiBvq0djLmTYO1sto3X3BijQW1UaWaCAolI/DqhuU2
	 FpDCefNDWvSiWy1c4pFM6YNPbmdpoB0hQbEpHWiqjHf96nvTFKzbienUzHZl47SO3l
	 M2ZtIngE3+WarXPokMmAEsO/NSLsIlL9ZXIzG2gf5hY0kK3Ra7uEBihy0cB44UhlZT
	 48InIC9WYK4NBuQ5PvB9z10ZHOu2sjtUrmtcmcUxNSBBbUE8H/NJaf5Dbx5Pi+GoMj
	 kMHXLqJBJmCuA==
Received: by mail-vs2-f39.google.com with SMTP id 71dfb90a1353d-5cd1d9d65e2so2115137e0c.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 11:34:40 -0700 (PDT)
X-Gm-Message-State: AFq9FYKowoi6tfZJ9PYflm8EcQT57Q5otihWmI+gUZFNJ5ggRBuqfpb0
	vYMyQ80hEsRRtBUwZoyI7vT5ua48TFTVbYACTW6CTpSEhkIFZzjGpD6pKT0RXfzWDcdVUOeELpZ
	8vy2/uqUoQSooVYwjnxINZ/MDI7aPWVw=
X-Received: by 2002:a67:e703:0:b0:7a7:36ac:b17a with SMTP id
 ada2fe7eead31-7af1e4f6353mr4590946137.20.1790620479869; Mon, 28 Sep 2026
 11:34:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1790229298.git.wqu@suse.com> <35418bcbdb67010774673ae2e4c434e0755a9849.1790229298.git.wqu@suse.com>
In-Reply-To: <35418bcbdb67010774673ae2e4c434e0755a9849.1790229298.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 28 Sep 2026 19:34:03 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6m9-Fq69XYWOYg46KhyQ2ic6DCK1Rm1sN5YfzkZ2hp4Q@mail.gmail.com>
X-Gm-Features: AclHuK8dpaajrihK4XW__iw5FcqW1EUshYKBsDbC0O1IStoxEmnhjmUOkOTicQo
Message-ID: <CAL3q7H6m9-Fq69XYWOYg46KhyQ2ic6DCK1Rm1sN5YfzkZ2hp4Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] btrfs: remove __TRANS_* flags
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2026 at 7:01=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> After patch "btrfs: remove __TRANS_FREEZABLE", each TRANS_* flag is just
> the corresponding single-bit __TRANS_* flag.
>
> There is no need to split __TRANS_* and TRANS_* flags, just remove
> __TRANS_* flags and use TRANS_* flags instead.
>
> Since every TRANS_* flag is a single bit, do extra cleanups:
>
> - Add an ASSERT() in start_transaction()
>   To make sure there is only a single bit set in @type
>
> - Rename TRANS_EXTWRITERS to TRANS_EXTWRITERS_MASK
>   To follow the naming scheme that a multi-bit value has the _MASK
>   suffix.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/transaction.c | 77 ++++++++++++++++++++----------------------
>  1 file changed, 37 insertions(+), 40 deletions(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index d73c8723ed70..2532b7b27f9a 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -39,26 +39,20 @@
>  static struct kmem_cache *btrfs_trans_handle_cachep;
>
>  enum {
> -       ENUM_BIT(__TRANS_START),
> -       ENUM_BIT(__TRANS_ATTACH),
> -       ENUM_BIT(__TRANS_JOIN),
> -       ENUM_BIT(__TRANS_JOIN_NOLOCK),
> +       ENUM_BIT(TRANS_START),
> +       ENUM_BIT(TRANS_ATTACH),
> +       ENUM_BIT(TRANS_JOIN),
> +       ENUM_BIT(TRANS_JOIN_NOLOCK),
>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> -       ENUM_BIT(__TRANS_DUMMY),
> +       ENUM_BIT(TRANS_DUMMY),
>  #endif
> -       ENUM_BIT(__TRANS_JOIN_NOSTART),
> +       ENUM_BIT(TRANS_JOIN_NOSTART),
>  };
>
> -#define TRANS_START            (__TRANS_START)
> -#define TRANS_ATTACH           (__TRANS_ATTACH)
> -#define TRANS_JOIN             (__TRANS_JOIN)
> -#define TRANS_JOIN_NOLOCK      (__TRANS_JOIN_NOLOCK)
> -#define TRANS_JOIN_NOSTART     (__TRANS_JOIN_NOSTART)

Ok, so this does what I asked for in the review of the previous patch,
so forget the previous comment.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> -
>  /* Those types need to hold sb intwrite lock. */
> -#define TRANS_SB_INTWRITER_MASK (__TRANS_START | __TRANS_JOIN)
> +#define TRANS_SB_INTWRITER_MASK (TRANS_START | TRANS_JOIN)
>
> -#define TRANS_EXTWRITERS       (__TRANS_START | __TRANS_ATTACH)
> +#define TRANS_EXTWRITERS_MASK  (TRANS_START | TRANS_ATTACH)
>
>  /*
>   * Transaction states and transitions
> @@ -139,32 +133,32 @@ enum {
>  static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] =3D=
 {
>         [TRANS_STATE_RUNNING]           =3D 0U,
>         [TRANS_STATE_COMMIT_PREP]       =3D 0U,
> -       [TRANS_STATE_COMMIT_START]      =3D (__TRANS_START | __TRANS_ATTA=
CH),
> -       [TRANS_STATE_COMMIT_DOING]      =3D (__TRANS_START |
> -                                          __TRANS_ATTACH |
> -                                          __TRANS_JOIN |
> -                                          __TRANS_JOIN_NOSTART),
> -       [TRANS_STATE_UNBLOCKED]         =3D (__TRANS_START |
> -                                          __TRANS_ATTACH |
> -                                          __TRANS_JOIN |
> -                                          __TRANS_JOIN_NOLOCK |
> -                                          __TRANS_JOIN_NOSTART),
> -       [TRANS_STATE_SUPER_COMMITTED]   =3D (__TRANS_START |
> -                                          __TRANS_ATTACH |
> -                                          __TRANS_JOIN |
> -                                          __TRANS_JOIN_NOLOCK |
> -                                          __TRANS_JOIN_NOSTART),
> -       [TRANS_STATE_COMPLETED]         =3D (__TRANS_START |
> -                                          __TRANS_ATTACH |
> -                                          __TRANS_JOIN |
> -                                          __TRANS_JOIN_NOLOCK |
> -                                          __TRANS_JOIN_NOSTART),
> +       [TRANS_STATE_COMMIT_START]      =3D (TRANS_START | TRANS_ATTACH),
> +       [TRANS_STATE_COMMIT_DOING]      =3D (TRANS_START |
> +                                          TRANS_ATTACH |
> +                                          TRANS_JOIN |
> +                                          TRANS_JOIN_NOSTART),
> +       [TRANS_STATE_UNBLOCKED]         =3D (TRANS_START |
> +                                          TRANS_ATTACH |
> +                                          TRANS_JOIN |
> +                                          TRANS_JOIN_NOLOCK |
> +                                          TRANS_JOIN_NOSTART),
> +       [TRANS_STATE_SUPER_COMMITTED]   =3D (TRANS_START |
> +                                          TRANS_ATTACH |
> +                                          TRANS_JOIN |
> +                                          TRANS_JOIN_NOLOCK |
> +                                          TRANS_JOIN_NOSTART),
> +       [TRANS_STATE_COMPLETED]         =3D (TRANS_START |
> +                                          TRANS_ATTACH |
> +                                          TRANS_JOIN |
> +                                          TRANS_JOIN_NOLOCK |
> +                                          TRANS_JOIN_NOSTART),
>  };
>
>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>  bool btrfs_trans_is_dummy(const struct btrfs_trans_handle *trans)
>  {
> -       return trans->type =3D=3D __TRANS_DUMMY;
> +       return trans->type =3D=3D TRANS_DUMMY;
>  }
>
>  void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
> @@ -172,7 +166,7 @@ void btrfs_init_dummy_trans(struct btrfs_trans_handle=
 *trans,
>  {
>         memset(trans, 0, sizeof(*trans));
>         trans->transid =3D 1;
> -       trans->type =3D __TRANS_DUMMY;
> +       trans->type =3D TRANS_DUMMY;
>         trans->fs_info =3D fs_info;
>  }
>  #endif
> @@ -261,21 +255,21 @@ static noinline void switch_commit_roots(struct btr=
fs_trans_handle *trans)
>  static inline void extwriter_counter_inc(struct btrfs_transaction *trans=
,
>                                          unsigned int type)
>  {
> -       if (type & TRANS_EXTWRITERS)
> +       if (type & TRANS_EXTWRITERS_MASK)
>                 atomic_inc(&trans->num_extwriters);
>  }
>
>  static inline void extwriter_counter_dec(struct btrfs_transaction *trans=
,
>                                          unsigned int type)
>  {
> -       if (type & TRANS_EXTWRITERS)
> +       if (type & TRANS_EXTWRITERS_MASK)
>                 atomic_dec(&trans->num_extwriters);
>  }
>
>  static inline void extwriter_counter_init(struct btrfs_transaction *tran=
s,
>                                           unsigned int type)
>  {
> -       atomic_set(&trans->num_extwriters, ((type & TRANS_EXTWRITERS) ? 1=
 : 0));
> +       atomic_set(&trans->num_extwriters, ((type & TRANS_EXTWRITERS_MASK=
) ? 1 : 0));
>  }
>
>  static inline int extwriter_counter_read(struct btrfs_transaction *trans=
)
> @@ -662,11 +656,14 @@ start_transaction(struct btrfs_root *root, unsigned=
 int num_items,
>         bool do_chunk_alloc =3D false;
>         int ret;
>
> +       /* The type must be a single TRANS_* bit set. */
> +       ASSERT(is_power_of_2(type));
> +
>         if (unlikely(BTRFS_FS_ERROR(fs_info)))
>                 return ERR_PTR(-EROFS);
>
>         if (current->journal_info) {
> -               WARN_ON(type & TRANS_EXTWRITERS);
> +               WARN_ON(type & TRANS_EXTWRITERS_MASK);
>                 h =3D current->journal_info;
>                 refcount_inc(&h->use_count);
>                 WARN_ON(refcount_read(&h->use_count) > 2);
> --
> 2.55.0
>
>
