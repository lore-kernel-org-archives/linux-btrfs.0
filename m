Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EDA51FCB5
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 16:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791910368; cv=none; b=t7m7cUPPYjdRyXvRwRMq0E0q6tESEM5cwdpM1yF7cvyFz/BB+3A2klnCZqBMLfOe1myAebnpoBsuFDo36LvEhQqy30kyLu4obr3oU0w01i/CcniTBQN+5sJ95gM1qKcqywfb3j7QfKC3yxuQwqcE7zKVKsJeF8i/0p9ZmqKidfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791910368; c=relaxed/simple;
	bh=ZiKfTLnKgyOuq4FBYmSAOnLlBep1SnIu1I/HZDdqS3E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c7+bSU1jsOhwXCLAx/1u3rFHCwI5PoM26EGT3fHpjp1XTTelmXLg+ZKN4TuMJLO6yukJRPdnRohcuj0/KnWZ9zPN2vtMNeH4ZVRCIHQ9LvExGBmSkAzvWNVYP30P4C9gc38W5pb3SnkzDlo+YO7RlPQlolbeK3Bt3v0aCTjmmOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gfmLxYuu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gfmLxYuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47EE1F000FF
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 16:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791910366;
	bh=+BRcw0eY6qo+FNosY0hWH2pixm0GccAXXH7HVImoEsY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gfmLxYuuBxCw3MWAXgsDnfm+6p2R4zvGKoX/jWyrrUXh4ORmaKi+i8A3Cn2WtDndq
	 ZA8yGS0WOlkz1eNtlbDtUNsiN1pYTFf1RWEDwoGKKONk+j9Z4nkJUfq05XM02VbCzw
	 pUyZ2rdzsQ2QZj+nlyM6dfrssVidLIh16ClEnJOoKgtaSh43oTyYx3JGbGhaog2ENr
	 gWyUb8LCIAb6xTNIYxTZsYa7Tbx3lXZ7aSIWfpbfyguPyCmQ7qqNii4/lpEeOyDG74
	 cLpuB9femjrqlnGfKHjbRi8xiJJBnhR92jHRO48c4QNQqTZytgJZEQJqcqmFHvgWXW
	 oTmiN4hJXMqLw==
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-7c420c2c4faso2080502137.1
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 09:52:46 -0700 (PDT)
X-Gm-Message-State: AFq9FYLb7KNHcJrXLBiSqNzM3fi6a6efZSSmect68W/IKZMJELh/XYIQ
	B55kD8r4iK5xc1KQFgg6HT8SP2VBp8EQfsbOEbfFpFsJ01X6tjh3Tr19UARfb65AUOBkeA1N6E0
	m+in75CgLaShxee2NpbRoqsQ+kHktD0I=
X-Received: by 2002:a05:6102:41cd:b0:7cb:393d:d264 with SMTP id
 ada2fe7eead31-7cb393dddb3mr3115187137.11.1791910365890; Tue, 13 Oct 2026
 09:52:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791869895.git.wqu@suse.com> <e71e6fcda482f306e8841292ea0031594de78577.1791869895.git.wqu@suse.com>
In-Reply-To: <e71e6fcda482f306e8841292ea0031594de78577.1791869895.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 13 Oct 2026 17:52:09 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7Bo56aLRZ7w-LbZ2h01bZipsBAKXxWVpCTqvTMn=E8mw@mail.gmail.com>
X-Gm-Features: AclHuK_3ORibTlBFElKQL-Nc4LhSmN5g9sTR0YC88liUpfCxRYAgoSzBhlfFZeE
Message-ID: <CAL3q7H7Bo56aLRZ7w-LbZ2h01bZipsBAKXxWVpCTqvTMn=E8mw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] btrfs: always remove quota_root from dirty_cowonly_roots
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 6:41=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [ERROR HANDLING QUIRK]
> When btrfs_quota_disable() failed at btrfs_clean_quota_tree() or
> btrfs_del_root(), the quota_root->dirty_list is not removed from
> fs_info->dirty_cowonly_roots, but the quota_root itself will be freed.
>
> This leaves a dangling pointer in the dirty_cowonly_roots.
>
> This is not a huge problem, as the transaction is aborted thus no one
> will read the dirty_cowonly_roots for now.
>
> Furthermore, quota_root should never be logged nor have qgroup swapped
> tree blocks, thus it won't cause leaks from extent io tree nor qgroup
> swapped blocks.
>
> [ENHANCEMENT]
> For the incoming cleanup of dirty_cowonly_roots during
> btrfs_free_fs_roots(), any root that is still linked to
> dirty_cowonly_roots will be read again, and this existing dangling
> pointer is going to cause problem.
>
> To prepare for that cleanup, move the list_del() call into the out
> label, so that even if the transaction is aborted, we still unlink
> quota_root from dirty_cowonly_roots before freeing it.
>
> Assisted-by: LLM (exposing the bug during review)
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index a0651fbfe778..8bd3abdf4805 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1440,10 +1440,6 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_i=
nfo)
>                 goto out;
>         }
>
> -       spin_lock(&fs_info->trans_lock);
> -       list_del(&quota_root->dirty_list);
> -       spin_unlock(&fs_info->trans_lock);
> -
>         btrfs_tree_lock(quota_root->node);
>         btrfs_clear_buffer_dirty(trans, quota_root->node);
>         btrfs_tree_unlock(quota_root->node);
> @@ -1454,6 +1450,12 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_i=
nfo)
>                 btrfs_abort_transaction(trans, ret);
>
>  out:
> +       if (quota_root) {
> +               spin_lock(&fs_info->trans_lock);
> +               list_del(&quota_root->dirty_list);
> +               spin_unlock(&fs_info->trans_lock);
> +       }
> +
>         btrfs_put_root(quota_root);

Same comment I had in another patch:

Can we place btrfs_put_root() inside the if statement's block that
checks quota_root is not NULL?
It just feels odd to have it outside, even though it can handle a NULL poin=
ter.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

>         mutex_unlock(&fs_info->qgroup_ioctl_lock);
>         if (ret && trans)
> --
> 2.56.0
>
>
