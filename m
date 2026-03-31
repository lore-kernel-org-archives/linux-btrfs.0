Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F8A3B774B
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 07:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774942352; cv=none; b=m6Bvh5wQbeqbDz9dmbZl294XXEbTieRagyfXN+LlQ3frbRxsAayrsdojdVcpQZgbUEnc3XSiIafdlCSBhsavsFzBGxOOiUo//4C9Aziqpb8k/f1czWoti/Duu6Da6YOePILANeJKZYkAO/65UzKu17Lap/MasU+udPFZYgNAtE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774942352; c=relaxed/simple;
	bh=9+Vn4C3fvj/ZQ95bhRuipolL1GeBUEQlk3N+5eY32Dg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O/0/LCQ+7vK6IByZgsI9tBBZhLeWaxTenFDcQP/V0eaZjXQVddGtOe83vLO3R6O2HV7qfv7VrNZs1SilAu2j+pZdR8BQp0L+8nQg9r8KudacnWlruf8ajytRiSfIDWnDqDvpR9NkXchEr4LRwKfCy1tVEwfXsGLd0KQ7o5ZwcD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u6qo2JVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u6qo2JVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67400C19423
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 07:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774942351;
	bh=9+Vn4C3fvj/ZQ95bhRuipolL1GeBUEQlk3N+5eY32Dg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=u6qo2JVoUyx7L4A5wop6D6bioXDckNKMHLjULQQMol38XkVoV8xj/qP4ZlFY0zauA
	 NZE0Ckf3fk2uEBc11nflmP4E21pCArL9QUGEZB1Q5v3oAipAuhcC9bMcaihk4ms7Wi
	 7kRV9D+IEABc5IoGDSHCDPJJlG+HNbLI6aAaAS9R7xQVIkqnIoM/RpFOY/1SKgCStv
	 JbN6CEE9Ppwp3aK57srgz6F9SGLpnyM5mTA3gBNnZJldjQbPXW9v9i/TcCdvKUmAZk
	 Yf6xznSlzuX1I5VOzdKPyNA/hAIvxFG/RwOSWN6j8+DdBwomyJxmSDuV9ExAN6wuxK
	 Bq/cEy1EUzQTQ==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so1030229566b.2
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 00:32:31 -0700 (PDT)
X-Gm-Message-State: AOJu0YwpE3C5SMfd+S5Tjb2hUL2ckVkdhEKB49s1y/x7bzTfZlkcK/lE
	95umJJeMUM2+UDS4I7NbQl/Z/6IbaQ6pZfkZ6lyEp8dQSoSKj220kZ76dGerQPH73AHUoCgG0oU
	AletGyL/UFB1D9xGQOzk+EztRRouriPg=
X-Received: by 2002:a17:907:3e83:b0:b98:1b:5157 with SMTP id
 a640c23a62f3a-b9b5034ab9amr934277066b.23.1774942349873; Tue, 31 Mar 2026
 00:32:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <90443bccdf0d1d7f93f945c0fc0c64cca438a82b.1774909310.git.wqu@suse.com>
In-Reply-To: <90443bccdf0d1d7f93f945c0fc0c64cca438a82b.1774909310.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 31 Mar 2026 08:31:53 +0100
X-Gmail-Original-Message-ID: <CAL3q7H70habyOymX73tYkQj1TW4bbYwsDvxU7sFFDPX1PhC=vg@mail.gmail.com>
X-Gm-Features: AQROBzDH24eBbapk5Um8_d3I7VIgiPooNE7e28CzIBVigqYdUrzpLmbZej6ol04
Message-ID: <CAL3q7H70habyOymX73tYkQj1TW4bbYwsDvxU7sFFDPX1PhC=vg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: only invalidate btree inode pages after all ebs
 are released
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 30, 2026 at 11:22=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> In close_ctree(), we call invalidate_inode_pages2() to invalidate all
> pages from btree inode.
>
> But the problem is, it never returns 0, but always -EBUSY.
>
> The problem is that we are still holding all the essential tree root
> nodes, thus pages hodling those tree blocks can not be invalidated thus

hodling -> holding

> invalidate_inode_pages2() always return -EBUSY.

return -> returns

>
> This is also against the error cleanup path of open_ctree(), which
> properly free all root pointers before calling invalidate_inode_pages().

free -> frees

>
> So fix the order by delaying invalidate_inode_pages2() until we have
> freed all root pointers.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> In theory we should also check the return value from
> invalidate_inode_pages2(), which can still return -EBUSY if we have
> pending metadata readahead, but that's a problem Teng Liu is working on
> and I don't want to take credit from him.
> ---
>  fs/btrfs/disk-io.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index c835141ee384..75f3c6c4c249 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4434,13 +4434,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_i=
nfo)
>
>         btrfs_put_block_group_cache(fs_info);
>
> -       /*
> -        * we must make sure there is not any read request to
> -        * submit after we stopping all workers.
> -        */
> -       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> -       btrfs_stop_all_workers(fs_info);
> -
>         /* We shouldn't have any transaction open at this point */
>         warn_about_uncommitted_trans(fs_info);
>
> @@ -4448,6 +4441,13 @@ void __cold close_ctree(struct btrfs_fs_info *fs_i=
nfo)
>         free_root_pointers(fs_info, true);
>         btrfs_free_fs_roots(fs_info);
>
> +       /*
> +        * we must make sure there is not any read request to

Since we are moving the comment, this is a good opportunity to fix it
and capitalize the first word to comply with our preferred style (and
correctness).

> +        * submit after we stopping all workers.

We can also do a fix here: stopping -> stop

Otherwise:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.



> +        */
> +       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +       btrfs_stop_all_workers(fs_info);
> +
>         /*
>          * We must free the block groups after dropping the fs_roots as w=
e could
>          * have had an IO error and have left over tree log blocks that a=
ren't
> --
> 2.53.0
>
>
