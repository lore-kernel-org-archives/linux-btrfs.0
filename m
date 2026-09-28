Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0305138D3F9
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 18:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790620110; cv=none; b=hXmksmC1ufT+1WB3bTrvfSKqcVmmlj8/U35t/hG3GQWZg6E4tLmfdFrBkPGJnxlPL9UYLsQqVNk0EWJj8LdaLKGOZn2YXAdhSqybza7A9rg+COS1m91rqwsc9IsoDPL58MwnMzNl/MesJeQcQyMALeDQzukrRhjQ4xapIjuIO/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790620110; c=relaxed/simple;
	bh=oz4qw0PgPobh08MLxHYx13mKaxZeyfOdRQlB+G8tzFc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SoxMkSua33S/bzEYaOVX7spdBYpesbKtUM3ipGCwTzP+GqEskgRQjODy0TR8YjyZ96R5ziJwub5IqLe9HuY9oJ0kTlVUNmuSNdnvRJrHB4Q+3mGyu2SvTSlwH8Qa0KiHbPiRg6NxovHoYYMpZcwB6lIqEAUQJR/hs9E9EJH8bKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K8cwFqTf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K8cwFqTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF8E1F000FF
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 18:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790620108;
	bh=71ZUnx0wm8o0PaQime5Hie9DWOQ7O9y+TeiIDjbRRO4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=K8cwFqTf9CCVW6vDEeoy6tugCulVdQH0y9RSXAEgyxjC449Tzx8sLIu9ycKzLeqXJ
	 BbgCThYrXxk+id+0z261Q3kq1GXkui98AMucc4wn6ufZbfZet8ZY/fBPE6UDEJS6Jv
	 2laG8kEKY5jPeHIq4f9gQJe6os97MI2Zh01OQugETFXzx+82wwcqtlwRMIg6R+CgI5
	 E2ZT5qbygVweyxNzEFiHEVxo21wJ40W3kwVGfaTPH6R4DABofAztNJ7zxmlCDFuMg+
	 IDKBgaex2dD5havPyy4+RJe+Ra8N8NiBKyf4XGwGDeHnal5LpfyG1mVY+m1EZrcvl/
	 XqP+785VKYfmw==
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5d082395235so81827e0c.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 11:28:28 -0700 (PDT)
X-Gm-Message-State: AFq9FYLSNr0ZYIoWrXO0voPVQkPrbLmUdvpeipcMw6kaORH4kgA9ZxOI
	4I8mE7g6uyn6RiApH3aL0eWzfvfHHUfi1iYI9uKIevkeOrloAK5uGWOuT8vlW5R6CwfTe4bj/9g
	+ciZf+PrdOv/w9PDnlsJOZLSw4jaMgzQ=
X-Received: by 2002:a05:6102:a141:b0:7aa:fbd3:b004 with SMTP id
 ada2fe7eead31-7b9513c06b1mr40931137.43.1790620107781; Mon, 28 Sep 2026
 11:28:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1790229298.git.wqu@suse.com> <f8b46621fa212642c4d961f790bac84ec42adb49.1790229298.git.wqu@suse.com>
In-Reply-To: <f8b46621fa212642c4d961f790bac84ec42adb49.1790229298.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 28 Sep 2026 19:27:51 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5MNUCakyQSzYQgBcrb79qtYDEHGfsrjoaHTAkRv=Kz_A@mail.gmail.com>
X-Gm-Features: AclHuK8IrBNDc6aLRCbLOninRfGFnOei38k0wgefSqwk3HFHvC9wD0C511lZVeA
Message-ID: <CAL3q7H5MNUCakyQSzYQgBcrb79qtYDEHGfsrjoaHTAkRv=Kz_A@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] btrfs: move __TRANS_* and TRANS_* flags out of transaction.h
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2026 at 7:00=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> Among all those flags, only __TRANS_DUMMY is used outside of
> transaction.[ch], and there are only two places using it:
>
> - find_parent_nodes()
>   Introduce a helper, btrfs_trans_is_dummy(), for this call site.
>
> - btrfs_init_dummy_trans()
>   Move the function into transaction.[ch], and hide it behind
>   CONFIG_BTRFS_FS_RUN_SANITY_TESTS.
>
> With the above changes, we can hide __TRANS_* and TRANS_* flags inside
> transaction.c. This allows us to modify those flags in the future
> without causing any changes to existing callers.
>
> After the flags relocation, now we can also hide __TRANS_DUMMY behind
> CONFIG_BTRFS_FS_RUN_SANITY_TESTS.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/backref.c           |  2 +-
>  fs/btrfs/tests/btrfs-tests.c |  9 ---------
>  fs/btrfs/tests/btrfs-tests.h |  2 --
>  fs/btrfs/transaction.c       | 36 ++++++++++++++++++++++++++++++++++++
>  fs/btrfs/transaction.h       | 29 +++++++++++------------------
>  5 files changed, 48 insertions(+), 30 deletions(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 1be632c742bd..939511629ecc 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1432,7 +1432,7 @@ static int find_parent_nodes(struct btrfs_backref_w=
alk_ctx *ctx,
>                 goto out;
>         }
>
> -       if (ctx->trans && likely(ctx->trans->type !=3D __TRANS_DUMMY) &&
> +       if (ctx->trans && likely(!btrfs_trans_is_dummy(ctx->trans)) &&
>             ctx->time_seq !=3D BTRFS_SEQ_LAST) {
>                 /*
>                  * We have a specific time_seq we care about and trans wh=
ich
> diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
> index 6287d940323d..cebc9a17b94d 100644
> --- a/fs/btrfs/tests/btrfs-tests.c
> +++ b/fs/btrfs/tests/btrfs-tests.c
> @@ -247,15 +247,6 @@ void btrfs_init_dummy_transaction(struct btrfs_trans=
action *trans, struct btrfs_
>         spin_lock_init(&trans->delayed_refs.lock);
>  }
>
> -void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
> -                           struct btrfs_fs_info *fs_info)
> -{
> -       memset(trans, 0, sizeof(*trans));
> -       trans->transid =3D 1;
> -       trans->type =3D __TRANS_DUMMY;
> -       trans->fs_info =3D fs_info;
> -}
> -
>  int btrfs_run_sanity_tests(void)
>  {
>         int ret, i;
> diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
> index cea58fe84a6d..a16855138105 100644
> --- a/fs/btrfs/tests/btrfs-tests.h
> +++ b/fs/btrfs/tests/btrfs-tests.h
> @@ -59,8 +59,6 @@ btrfs_alloc_dummy_block_group(struct btrfs_fs_info *fs_=
info, unsigned long lengt
>  void btrfs_free_dummy_block_group(struct btrfs_block_group *cache);
>  DEFINE_FREE(btrfs_free_dummy_block_group, struct btrfs_block_group *,
>             btrfs_free_dummy_block_group(_T));
> -void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
> -                           struct btrfs_fs_info *fs_info);
>  void btrfs_init_dummy_transaction(struct btrfs_transaction *trans, struc=
t btrfs_fs_info *fs_info);
>  struct btrfs_device *btrfs_alloc_dummy_device(struct btrfs_fs_info *fs_i=
nfo);
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index ca114235bbe1..4181f3897a30 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -38,6 +38,26 @@
>
>  static struct kmem_cache *btrfs_trans_handle_cachep;
>
> +enum {
> +       ENUM_BIT(__TRANS_FREEZABLE),
> +       ENUM_BIT(__TRANS_START),
> +       ENUM_BIT(__TRANS_ATTACH),
> +       ENUM_BIT(__TRANS_JOIN),
> +       ENUM_BIT(__TRANS_JOIN_NOLOCK),
> +#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> +       ENUM_BIT(__TRANS_DUMMY),
> +#endif
> +       ENUM_BIT(__TRANS_JOIN_NOSTART),
> +};
> +
> +#define TRANS_START            (__TRANS_START | __TRANS_FREEZABLE)
> +#define TRANS_ATTACH           (__TRANS_ATTACH)
> +#define TRANS_JOIN             (__TRANS_JOIN | __TRANS_FREEZABLE)
> +#define TRANS_JOIN_NOLOCK      (__TRANS_JOIN_NOLOCK)
> +#define TRANS_JOIN_NOSTART     (__TRANS_JOIN_NOSTART)
> +
> +#define TRANS_EXTWRITERS       (__TRANS_START | __TRANS_ATTACH)
> +
>  /*
>   * Transaction states and transitions
>   *
> @@ -139,6 +159,22 @@ static const unsigned int btrfs_blocked_trans_types[=
TRANS_STATE_MAX] =3D {
>                                            __TRANS_JOIN_NOSTART),
>  };
>
> +#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> +bool btrfs_trans_is_dummy(const struct btrfs_trans_handle *trans)
> +{

So most of our exported transaction functions have names like:

btrfs_end_transaction()
btrfs_commit_transaction()
btrfs_start_transaction()
btrfs_abort_transaction()
etc

So I would suggest, for consistency, naming it as:  btrfs_is_dummy_transact=
ion()

> +       return trans->type =3D=3D __TRANS_DUMMY;
> +}
> +
> +void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
> +                           struct btrfs_fs_info *fs_info)
> +{

And here; btrfs_init_dummy_transaction()

Otherwise:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> +       memset(trans, 0, sizeof(*trans));
> +       trans->transid =3D 1;
> +       trans->type =3D __TRANS_DUMMY;
> +       trans->fs_info =3D fs_info;
> +}
> +#endif
> +
>  void btrfs_put_transaction(struct btrfs_transaction *transaction)
>  {
>         if (refcount_dec_and_test(&transaction->use_count)) {
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 89153cd22596..9eb92b1ad54d 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -119,24 +119,6 @@ struct btrfs_transaction {
>         wait_queue_head_t pending_wait;
>  };
>
> -enum {
> -       ENUM_BIT(__TRANS_FREEZABLE),
> -       ENUM_BIT(__TRANS_START),
> -       ENUM_BIT(__TRANS_ATTACH),
> -       ENUM_BIT(__TRANS_JOIN),
> -       ENUM_BIT(__TRANS_JOIN_NOLOCK),
> -       ENUM_BIT(__TRANS_DUMMY),
> -       ENUM_BIT(__TRANS_JOIN_NOSTART),
> -};
> -
> -#define TRANS_START            (__TRANS_START | __TRANS_FREEZABLE)
> -#define TRANS_ATTACH           (__TRANS_ATTACH)
> -#define TRANS_JOIN             (__TRANS_JOIN | __TRANS_FREEZABLE)
> -#define TRANS_JOIN_NOLOCK      (__TRANS_JOIN_NOLOCK)
> -#define TRANS_JOIN_NOSTART     (__TRANS_JOIN_NOSTART)
> -
> -#define TRANS_EXTWRITERS       (__TRANS_START | __TRANS_ATTACH)
> -
>  /*
>   * Number of extent buffers a transaction handle tracks for writeback
>   * inhibition. The CLOCK reference bits pack into a u32 so this must not=
 exceed
> @@ -305,6 +287,17 @@ do {                                                =
               \
>                                   __LINE__, __error);           \
>  } while (0)
>
> +#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> +bool btrfs_trans_is_dummy(const struct btrfs_trans_handle *trans);
> +void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
> +                           struct btrfs_fs_info *fs_info);
> +#else
> +static inline bool btrfs_trans_is_dummy(const struct btrfs_trans_handle =
*trans)
> +{
> +       return false;
> +}
> +#endif
> +
>  int btrfs_end_transaction(struct btrfs_trans_handle *trans);
>  struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *ro=
ot,
>                                                    unsigned int num_items=
);
> --
> 2.55.0
>
>
