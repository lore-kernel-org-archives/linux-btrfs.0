Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DAB32ED38
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Feb 2026 14:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771423759; cv=none; b=I2zxjc+AI4apmJe3HFuXy95KYQd6TAfdvlyHa8WGZLf6jImlP0IBNy+hjJOww9PmaD41O1cPO5LXcsCzH5xsiUg56A4/J12NtIO1iSkROpTCqmncjx/HUmiB5Wuaxiy65Ig+Jdu+MaxJjE3rOOzVNOWis+Lq90qMVzESgnGr5fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771423759; c=relaxed/simple;
	bh=6R1+D6Bl/BU1CwERBRP2VY7pbyvM50SHyd9f1AHaSgo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d6PEnDsSzEjK0tkLBkdTd6hc4XRbdJcj6MBDc2FcRskpmhJRHk9EOxoBjNQ1awiF2+/RIsArywvr9aUzQqU6Z/FCn9vRDlDUwY6U77tJBTQ2Vai5Y2alHkQa8EGr2RdyvwAE7px/WnN+Mut/KWBEPLeXjuJBOzf4t295GU0iXqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OY53sCMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OY53sCMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07DDC4AF09
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Feb 2026 14:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771423758;
	bh=6R1+D6Bl/BU1CwERBRP2VY7pbyvM50SHyd9f1AHaSgo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OY53sCMuL5iMVN1BzfAEzGElGxIxYdmllWuFD9zHuG0sgR6Q3eQugpLqotxsp79lv
	 EkDc7qMny1Ogf5Z8sS6cAFxv+UDPE8Za4q2aotkMzdJIYCtDR4Leym0JMjfcpXdaKA
	 uo6YLnTRyaNTh26EmvXB8UFM22DwoYjC09LUTy1BHeG9/HnBtY8EqyHDvj5XuDyXO4
	 0miD7S69/DL/Fimedy4yQZDCX+Is4CsUvjDF2AvZVZMFjmHa2JI3x127UzGXw991fx
	 TbwuAk579r0kG7M2MWAxPvMiqDb5juug76YIOCbVfXIyPCH4GAhjmNXROOac7VQ9HY
	 N1fNN6hKF+G3w==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-65a3fdeb7d9so7675245a12.0
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Feb 2026 06:09:18 -0800 (PST)
X-Gm-Message-State: AOJu0Yzh269lltQvM3pm6+wSE/LOyNvw/nH4Wy/TJx2scogTxzURLNmJ
	qPBjWGi6nAY+wzrtiOnFWmjFTjOnn1a/g8hzU/le5JY7XcCcX0I3rNLG7k/cg08e+dExb3T/DKu
	ML2BR9R6cepgl7LqV+aA9CryzUyyIeMQ=
X-Received: by 2002:a17:907:2da9:b0:b8d:be68:bc20 with SMTP id
 a640c23a62f3a-b8fb4772e81mr925215966b.64.1771423757388; Wed, 18 Feb 2026
 06:09:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260218130006.9563-1-mark@harmstone.com>
In-Reply-To: <20260218130006.9563-1-mark@harmstone.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 18 Feb 2026 14:08:40 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5Mo--qAZ4KbgT6e_BYEChZNikxoq4RkPv5cUxp6=qRJw@mail.gmail.com>
X-Gm-Features: AaiRm50FmAKROhm2tVwu3Fk8gQT5fAGbLyfzqwS_fA4JEjJI0FXyqbv9MojcHCQ
Message-ID: <CAL3q7H5Mo--qAZ4KbgT6e_BYEChZNikxoq4RkPv5cUxp6=qRJw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix unlikely in btrfs_insert_one_raid_extent()
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, johannes.thumshirn@wdc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 18, 2026 at 1:01=E2=80=AFPM Mark Harmstone <mark@harmstone.com>=
 wrote:
>
> Fix the unlikely added to btrfs_insert_one_raid_extent() by commit
> a929904c: the exclamation point is in the wrong place, so we are telling
> the compiler that allocation failure is actually expected.
>
> Signed-off-by: Mark Harmstone <mark@harmstone.com>
> Fixes: a929904cf73b ("btrfs: add unlikely annotations to branches leading=
 to transaction abort")

We use the Fixes tag for things that must be backported, which are
aither bug fixes or rather severe performance regressions (i.e. things
that affect users), and this doesn't fit into these categories.

Otherwise:

Reviewed-by: Filipe Manana <fdmanana@suse.com>


> ---
>  fs/btrfs/raid-stripe-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
> index 2987cb7c686e..638c4ad572c9 100644
> --- a/fs/btrfs/raid-stripe-tree.c
> +++ b/fs/btrfs/raid-stripe-tree.c
> @@ -300,7 +300,7 @@ int btrfs_insert_one_raid_extent(struct btrfs_trans_h=
andle *trans,
>         int ret;
>
>         stripe_extent =3D kzalloc(item_size, GFP_NOFS);
> -       if (!unlikely(stripe_extent)) {
> +       if (unlikely(!stripe_extent)) {
>                 btrfs_abort_transaction(trans, -ENOMEM);
>                 btrfs_end_transaction(trans);
>                 return -ENOMEM;
> --
> 2.52.0
>
>
