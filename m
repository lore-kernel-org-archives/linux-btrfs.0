Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FF833D6D7
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 14:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777473394; cv=none; b=twoDdcxwqrWC7111oJRFUDKisPS4+VRw0zZuTEe6kXh+5rZhJPpMoq3RnH2CumPOgrXbsm0dSo05FiIvPTGEhbGft6sOoTZtz64JjntixUCaScrDgIo0tiOTldltVjmcEGz28ukIr44VXSVVFcKPsW9BUq16Jbjnmg8GwFjG1PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777473394; c=relaxed/simple;
	bh=G3ekscDTOm0hQIuZIc4iYISAuzoZGpK01FK7VaG3ajo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QNhHQ2UoAkJg47SFiAVoUh0so4gmP5FxiFuLyl6A0qS8sPo7BuxK+VDJWCV7vp0R0GxC1nTyNNw96fGY5owZRH+OjKxFSr/QZBRf2MyVhVrCVnr/0fOl4Bu2e/usUKgtmz14/zIMQzKVkX9CO92OnwaUJeWPkzurocwjPel09zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OMVYPLmg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMVYPLmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C08EC2BCB8
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 14:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777473394;
	bh=G3ekscDTOm0hQIuZIc4iYISAuzoZGpK01FK7VaG3ajo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OMVYPLmgwBUfId2m4zTHBb9ce6klfTFUqjiaCiqtXr3uqDXIm+t0Q+N6Sk2R2seIX
	 Ys/9rqmR9K6uVQNOulMP85YEWuJMRlKeBSf2XgVXHSuohNHShpKVlUvF2S3On8FRbq
	 VuFyuwdGJL4MEMaKQGuNM1xRAHO7tU+OSrJ0bKHnzagTjB+dqZWPO9HASpBC1M6/Gj
	 WFx9jb0Mt8ZFkWR4GF1DLT3aBEzQyvjQlDYDyX7oWCdK3DNIRV/ep17g1iUDEOE/xn
	 2kkz4msfyW3I3S068fKi7mTfkB8CFSVlJl+dRvgkFHevClz3vEm4/xiOM4PX4HDq9h
	 0F/ArbwltxIsA==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b93698bb57aso196863366b.0
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 07:36:34 -0700 (PDT)
X-Gm-Message-State: AOJu0YxSR0+uplfaR5jr3ZyIUNUgvkltI59X8I8C79EMqfm5caGgEQ7T
	+gQXmGPibRcD3ArgflnS5sOWhT7WznAFFf//h92plQcdYPstqsD9cWHDHJDFPM0uQwyYn9GjuiZ
	HcZ6+Q9XbBU6HIixqB1qTNZayqxjOJy8=
X-Received: by 2002:a17:907:86ac:b0:b90:4838:46ff with SMTP id
 a640c23a62f3a-bb9599b7b0emr192581466b.21.1777473392776; Wed, 29 Apr 2026
 07:36:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428155148.2399-1-dsterba@suse.com> <20260429143253.2236286-1-dsterba@suse.com>
In-Reply-To: <20260429143253.2236286-1-dsterba@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 29 Apr 2026 15:35:55 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5=v-trO08Vx=BTb4FJR0BvSPDzRJyeYrnpb6muVAD07w@mail.gmail.com>
X-Gm-Features: AVHnY4K3Q-CZ8KTxsyObp4GCwVYWRPraazSDdn09E8VDWnQDW0kmrr-iXN1x2No
Message-ID: <CAL3q7H5=v-trO08Vx=BTb4FJR0BvSPDzRJyeYrnpb6muVAD07w@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: move transaction abort message to __btrfs_abort_transaction()
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2026 at 3:33=E2=80=AFPM David Sterba <dsterba@suse.com> wro=
te:
>
> The btrfs_abort_transaction() is called at the location where we want to
> report the abort. It must be a macro so we get the correct line and
> stack trace. This inlines the necessary code and the rest is pushed to
> __btrfs_abort_transaction().
>
> There's a possibility to reduce the inlined code if we move the message
> to the helper function as well, without loss of information. The
> difference is only that the WARN will not print it inside the stack
> report but after:
>
>   --[ cut here ]--
>   WARNING: fs/btrfs/transaction.c:2045 at btrfs_commit_transaction+0xa21/=
0xd30 [btrfs], CPU#11: bonnie++/3377975
>   ...
>   --[ end trace ] --
>   BTRFS error (device dm-0 state A): Transaction aborted (error -28)
>
> While previously there would be one more line like:
>
>   --[ cut here ]--
>   BTRFS: Transaction aborted (error -28)
>   WARNING: fs/btrfs/transaction.c:2045 at btrfs_commit_transaction+0xa21/=
0xd30 [btrfs], CPU#11: bonnie++/3377975
>   ...
>   --[ end trace ] --
>
> This removes about 20KiB of btrfs.ko on a release config.
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>
> v2:
> - move message in __btrfs_abort_transaction() under 'first_hit', also to
>   make the WRITE_ONCE() assignments immediate
> - savings updated to 20K, it depends on the config and compiler, use an
>   average of a few setups
>
>  fs/btrfs/transaction.c |  8 ++++++--
>  fs/btrfs/transaction.h | 11 +----------
>  2 files changed, 7 insertions(+), 12 deletions(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 194f581b36f3..184fe976450e 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2731,8 +2731,12 @@ void __cold __btrfs_abort_transaction(struct btrfs=
_trans_handle *trans,
>
>         WRITE_ONCE(trans->aborted, error);
>         WRITE_ONCE(trans->transaction->aborted, error);
> -       if (first_hit && error =3D=3D -ENOSPC)
> -               btrfs_dump_space_info_for_trans_abort(fs_info);
> +       if (first_hit) {
> +               btrfs_err(trans->fs_info, "Transaction %llu aborted (erro=
r %d)",

There's already a local fs_info variable, no need to trans->fs_info.

Otherwise:

Filipe Manana <fdmanana@suse.com>

> +                         trans->transid, error);
> +               if (error =3D=3D -ENOSPC)
> +                       btrfs_dump_space_info_for_trans_abort(fs_info);
> +       }
>         /* Wake up anybody who may be waiting on this transaction */
>         wake_up(&fs_info->transaction_wait);
>         wake_up(&fs_info->transaction_blocked_wait);
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 7d70fe486758..f1cb05460cec 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -253,16 +253,7 @@ do {                                                =
               \
>         if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,     \
>                         &((trans)->fs_info->fs_state))) {       \
>                 __first =3D true;                                 \
> -               if (WARN(btrfs_abort_should_print_stack(error), \
> -                       KERN_ERR                                \
> -                       "BTRFS: Transaction aborted (error %d)\n",      \
> -                       (error))) {                                     \
> -                       /* Stack trace printed. */                      \
> -               } else {                                                \
> -                       btrfs_err((trans)->fs_info,                     \
> -                                 "Transaction aborted (error %d)",     \
> -                                 (error));                     \
> -               }                                               \
> +               WARN_ON(btrfs_abort_should_print_stack(error)); \
>         }                                                       \
>         __btrfs_abort_transaction((trans), __func__,            \
>                                   __LINE__, (error), __first);  \
> --
> 2.53.0
>
>
