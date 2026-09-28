Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A20437F31D
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 18:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790620390; cv=none; b=ZvVSC1pcXiZWhMAhRzAFwyd965e1rbLoz/T/BdBGdDTGYgt8rZck3phzBlO47IuqElVdtCIpIk8NZeBiTlIgDtyv1ctxLjsuLM6bRdAbLriQ465+PUUyTxMEqF7buAZ4fQ4XygLwr0KD4xo+FsGI9oBxttIPOvvsRlzLgGRCY0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790620390; c=relaxed/simple;
	bh=F4t9gixp2PQFHNIf3XpzGTgkzScJ7JnOU7nnBkzAKB4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VDbyuxEwtUtCPT17wtQKgU48HzqjaGpQNgGj0k7iQjPSWxx75golgyNYwXu+yOPoP4kTYKapXkRvr91fnAxKNogYSkBD7uPytEQ5xfP3SxAtIX3O6X5txBBn3n/8sihxWEh9ShSw9IZOZnuW5XmMtlaDDKUHtD4K4zt0b8oHjck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QYfOY7p5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QYfOY7p5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112831F000FF
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 18:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790620388;
	bh=dsHov0P0BAAq898pPxhMTP2B+zSh43Qgcs7pFXlEQ1s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QYfOY7p55cxZ/NaCaxjr23bQ9cjh6ajSeK5t1Vbw37tnEB2guoQVbGz88fENC5PPf
	 cY7R128DHzAaA6ormrNNXStLkpw+mZjdhFcUvZ37CuvnIbELQq+a8NWQelFfZ6jm0w
	 eReLhHr6Omo0ogGHo5rjFpgi99xgNrN9nJ2m/n9LQc8YHleSVcQEmR44ZIpebzjHZZ
	 y3IfFgg+nOFtLvnp6x73O31eZOD5TmaLlZ1UN8iP3LMlWX0HltlPkl0tScdjIgRuE8
	 NsOXKodUuOY+LefzC5ineBteVuton0ip2uXMfTFXCY6OQJ4qzr/Psjj4Kc/Ft2JloS
	 l484ftRr77LWw==
Received: by mail-ua2-f12.google.com with SMTP id a1e0cc1a2514c-97e7c72bfe7so990788241.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 11:33:08 -0700 (PDT)
X-Gm-Message-State: AFq9FYK292Ogt0UUXwJljh7W/opikZS6coZ7E9YWo/FVN+/kBbQJYOgw
	r+Z6b2pihPegnLy16uUTN4Qcg9EAUKeu/7DGo0brtV+TpjKBIdLiL1wTXcM56YGv5poVEpY2vV/
	b7gcBfhxBOnY7lOxAFXxO+OFV/985Tys=
X-Received: by 2002:a05:6102:2d08:b0:7a2:2632:ee08 with SMTP id
 ada2fe7eead31-7b1c770de8fmr2751706137.23.1790620387296; Mon, 28 Sep 2026
 11:33:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1790229298.git.wqu@suse.com> <0eae09fa05791ff4079a10f778c02cc0da0653b0.1790229298.git.wqu@suse.com>
In-Reply-To: <0eae09fa05791ff4079a10f778c02cc0da0653b0.1790229298.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 28 Sep 2026 19:32:30 +0100
X-Gmail-Original-Message-ID: <CAL3q7H51sixGzyORoDR5eLqzp2Krem0ir57UsYTAEzgefRW6Ww@mail.gmail.com>
X-Gm-Features: AclHuK8E25U9A16O714L6wuFTuOV-6v_Z6J-bbKs3TVSMeoY-Wd4zNb8Fl4bEdA
Message-ID: <CAL3q7H51sixGzyORoDR5eLqzp2Krem0ir57UsYTAEzgefRW6Ww@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] btrfs: remove __TRANS_FREEZABLE
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2026 at 7:01=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> Inside transaction.c most TRANS_* flags are just a single bit, but there
> are 2 exceptions:
>
> - TRANS_START
>   Which is (__TRANS_START | __TRANS_FREEZABLE)
>
> - TRANS_JOIN
>   Which is (__TRANS_JOIN | __TRANS_FREEZABLE)
>
> The extra __TRANS_FREEZABLE flag indicates that those operations need
> to acquire sb intwrite lock to handle fs freezing.
>
> However since there are only two operations requiring sb intwrite lock,
> there is no need to introduce a dedicated flag for it, we can introduce
> a new TRANS_SB_INTWRITER_MASK to cover the only two cases, then use that
> new mask to determine whether the type requires sb intwrite lock.
>
> This makes all TRANS_* flags a single bit.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/transaction.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 4181f3897a30..d73c8723ed70 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -39,7 +39,6 @@
>  static struct kmem_cache *btrfs_trans_handle_cachep;
>
>  enum {
> -       ENUM_BIT(__TRANS_FREEZABLE),
>         ENUM_BIT(__TRANS_START),
>         ENUM_BIT(__TRANS_ATTACH),
>         ENUM_BIT(__TRANS_JOIN),
> @@ -50,12 +49,15 @@ enum {
>         ENUM_BIT(__TRANS_JOIN_NOSTART),
>  };
>
> -#define TRANS_START            (__TRANS_START | __TRANS_FREEZABLE)
> +#define TRANS_START            (__TRANS_START)
>  #define TRANS_ATTACH           (__TRANS_ATTACH)
> -#define TRANS_JOIN             (__TRANS_JOIN | __TRANS_FREEZABLE)
> +#define TRANS_JOIN             (__TRANS_JOIN)

So after this change, can't we rename the enum members to remove the
__ prefix and get rid of these #defines?
Since none of them are ORed combinations anymore...

Anyway:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

>  #define TRANS_JOIN_NOLOCK      (__TRANS_JOIN_NOLOCK)
>  #define TRANS_JOIN_NOSTART     (__TRANS_JOIN_NOSTART)
>
> +/* Those types need to hold sb intwrite lock. */
> +#define TRANS_SB_INTWRITER_MASK (__TRANS_START | __TRANS_JOIN)
> +
>  #define TRANS_EXTWRITERS       (__TRANS_START | __TRANS_ATTACH)
>
>  /*
> @@ -746,6 +748,8 @@ start_transaction(struct btrfs_root *root, unsigned i=
nt num_items,
>         }
>
>         /*
> +        * Only TRANS_START and TRANS_JOIN require sb intwrite lock.
> +        *
>          * If we are JOIN_NOLOCK we're already committing a transaction a=
nd
>          * waiting on this guy, so we don't need to do the sb_start_intwr=
ite
>          * because we're already holding a ref.  We need this because we =
could
> @@ -755,7 +759,7 @@ start_transaction(struct btrfs_root *root, unsigned i=
nt num_items,
>          * If we are ATTACH, it means we just want to catch the current
>          * transaction and commit it, so we needn't do sb_start_intwrite(=
).
>          */
> -       if (type & __TRANS_FREEZABLE)
> +       if (type & TRANS_SB_INTWRITER_MASK)
>                 sb_start_intwrite(fs_info->sb);
>
>         if (may_wait_transaction(fs_info, type))
> @@ -857,7 +861,7 @@ start_transaction(struct btrfs_root *root, unsigned i=
nt num_items,
>         return h;
>
>  join_fail:
> -       if (type & __TRANS_FREEZABLE)
> +       if (type & TRANS_SB_INTWRITER_MASK)
>                 sb_end_intwrite(fs_info->sb);
>         kmem_cache_free(btrfs_trans_handle_cachep, h);
>  alloc_fail:
> @@ -1138,7 +1142,7 @@ static int __btrfs_end_transaction(struct btrfs_tra=
ns_handle *trans,
>
>         btrfs_trans_release_chunk_metadata(trans);
>
> -       if (trans->type & __TRANS_FREEZABLE)
> +       if (trans->type & TRANS_SB_INTWRITER_MASK)
>                 sb_end_intwrite(info->sb);
>
>         /*
> @@ -2150,7 +2154,7 @@ static void cleanup_transaction(struct btrfs_trans_=
handle *trans, int err)
>                 fs_info->running_transaction =3D NULL;
>         spin_unlock(&fs_info->trans_lock);
>
> -       if (trans->type & __TRANS_FREEZABLE)
> +       if (trans->type & TRANS_SB_INTWRITER_MASK)
>                 sb_end_intwrite(fs_info->sb);
>         btrfs_put_transaction(cur_trans);
>         btrfs_put_transaction(cur_trans);
> @@ -2682,7 +2686,7 @@ int btrfs_commit_transaction(struct btrfs_trans_han=
dle *trans)
>         btrfs_put_transaction(cur_trans);
>         btrfs_put_transaction(cur_trans);
>
> -       if (trans->type & __TRANS_FREEZABLE)
> +       if (trans->type & TRANS_SB_INTWRITER_MASK)
>                 sb_end_intwrite(fs_info->sb);
>
>         btrfs_scrub_continue(fs_info);
> --
> 2.55.0
>
>
