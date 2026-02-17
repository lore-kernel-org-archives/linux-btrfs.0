Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9DB280A29
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2026 18:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771353720; cv=none; b=hpbIFLzj8atkDRAUiCti3hVMMO80qeTjcaHeTfZ/zoChcv8I2bt3My0K/MgphKJ5l7wK+kSKZd6mhbCfJR/+GRKZIlTwLN+asigIN+ks59qvXQXibST/3xQDRFJqAFCSibUjAoQ5DgNaZoeqhQo3gzyM/LhgCZxMz6m28+fa5w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771353720; c=relaxed/simple;
	bh=58ucjnsgtO4BBjdoUmtLrzBrT06mCSjfVq0mFegGl6Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xn6loRLjLn+9h7MyG0RbqXsooVrWJsi5g4engLODz2E5R2+iumOk9rurKIFWUW//ktTzdlDZOAPOYvjA+CjxfgwScSuQArv1kvRqqLfYNAwWlarQ96760mh8EXVXE9Fk3t4swENfMhSjYd7wM0NdmjgWFaL+cYC9w25do/Y+hmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gPd92joW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPd92joW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E1FC19425
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2026 18:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771353720;
	bh=58ucjnsgtO4BBjdoUmtLrzBrT06mCSjfVq0mFegGl6Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gPd92joWXYjxbehFhGJLqFt+MPUfnERssHrc+lDJt7HuI9eG/ffH38Wchuma43iOS
	 zXhhwIeE1PMk0ApCGe53v0WI9PCeb3Zmw4N/AAfeLlTihkDv8SVoSY2KUnY856W4IG
	 4MtVLxv2vH3XX6UGW6bmlUW2Bc2y5sxEZvEtTWMNXmcsLUy3h/n8rmXgRCYmVnnyyW
	 1yjZBTwmRDihjKzuTXOB/C3bXeujm82NpZuOg2rJfbCVJ2/ZgnczJewTYKZIVwbRm/
	 y3Uf8vDrzrXHL5QXV2JTWwC5eL1rfCH6T3UlaLwFU4qby2RuWvG07qLfvQL7ui4mLL
	 S7W8VzR/nsxcg==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6580dbdb41eso5921214a12.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2026 10:42:00 -0800 (PST)
X-Gm-Message-State: AOJu0YwOYHsnivLcGmlmn7+oC+D6AJwLwjCau0WkJ+/lGfvPRPC6R/VJ
	8IsaH4Ng9CZZTNX6VDd41hsxGGR8vJBnXdpDrcEwgeqKlme+MDkMuoqN1E1UUIJYP1di7KYrosm
	bu8wpErb4fB88Z9m85OxdWlwK0CWQsuw=
X-Received: by 2002:a17:907:6d24:b0:b80:4103:537e with SMTP id
 a640c23a62f3a-b8fb451a74emr784171366b.53.1771353718633; Tue, 17 Feb 2026
 10:41:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260217182553.18091-1-mark@harmstone.com>
In-Reply-To: <20260217182553.18091-1-mark@harmstone.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 17 Feb 2026 18:41:21 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6QojXH+oiMu5KkdpmNyV8xDFXfBkPqb1Q=RyD3WxRd=A@mail.gmail.com>
X-Gm-Features: AaiRm52gMLvy3C1Jq1HS1rni4cKqONt8BMWmRdupjM6x_ExPdV-tBzxm2idsBRY
Message-ID: <CAL3q7H6QojXH+oiMu5KkdpmNyV8xDFXfBkPqb1Q=RyD3WxRd=A@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix error message in btrfs_delete_delayed_dir_index()
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 17, 2026 at 6:29=E2=80=AFPM Mark Harmstone <mark@harmstone.com>=
 wrote:
>
> Fix the error message in btrfs_delete_delayed_dir_index() if
> __btrfs_add_delayed_item() fails: the message says root, inode, index,
> error, but we're actually passing index, root, inode, error.
>
> Signed-off-by: Mark Harmstone <mark@harmstone.com>
> Fixes: adc1ef55dc04 ("btrfs: add details to error messages at btrfs_delet=
e_delayed_dir_index()")

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Pushed it to for-next, thanks.

> ---
>  fs/btrfs/delayed-inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 1739a0b29c49..2746841c167d 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1657,7 +1657,7 @@ int btrfs_delete_delayed_dir_index(struct btrfs_tra=
ns_handle *trans,
>         if (unlikely(ret)) {
>                 btrfs_err(trans->fs_info,
>  "failed to add delayed dir index item, root: %llu, inode: %llu, index: %=
llu, error: %d",
> -                         index, btrfs_root_id(node->root), node->inode_i=
d, ret);
> +                         btrfs_root_id(node->root), node->inode_id, inde=
x, ret);
>                 btrfs_delayed_item_release_metadata(dir->root, item);
>                 btrfs_release_delayed_item(item);
>         }
> --
> 2.52.0
>
>
