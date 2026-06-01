Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC963BE620
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 14:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780324227; cv=none; b=h91uEzYWcwLVCY71Eobe77XkFoLPiJNbJb82ZHrIv2Ng6P8h5joOP1u93p4/WOdn/6iu9UlFrsDiQZDy/lCbxnSGsh/OZkk+h00GO/cTO4KAGat8dH7zZgAJAH9WRoHCYK281CL0Mmhsb1+LIkw2+7IY69kSOREDf710FVOF23g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780324227; c=relaxed/simple;
	bh=m/I0zpdJ71P7zS/LuA/I19DpQ3v0JTWoA/WvuZaMw5E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dq6xMYgPEkeSYdecCyffPQW7GsAYPsR+egITT2UFaCDwdqbx8LLs9+9d8ohydtvF7c0RXeJB4Zpzlm6bEZkHUFTesErptTW9jH7mcSnWe5da3pMR1uXvekmGNBn0NuofY85hA5TC65N/TdQnqf9pBs+i1Cehnk2d77L0f7eo7lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pa4Hqe5B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pa4Hqe5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AF81F00893
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 14:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780324226;
	bh=QfWpIbrkA1ceSsX16E0eeSYuD7JU68UTA8KOXVZNR1w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Pa4Hqe5B5KL8psb0tjkWaiD3OHTWWIgk2NZm8qGw19nknYiP4THFqVQznxagHvUYE
	 4/b0Ful11DxMXzV7vIaDvy8OKFmrjbbtIxu5j5fWr2nyjkYTYIfgANt5Wq6JaHzDbC
	 /C+PHLTWQYltiXv4QWn5bW0kL+15hu+Z97028FyjJ10ZoZ8DBdJwdiG6oxdHbDYh4W
	 Lo3vr8pWkT/1HRnVwb4kdJhfIpsYjr4RZHl8+XW4PvGwLKKVJnkXsCL+mZMeUSI69S
	 fze39VZ0H3HEXvGbRthCysQeI2oeNxhuQ7WNikr7peIbq2vZiV+5NUcIk+1owyIeCj
	 DG9q4AacQb7xA==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-68bfcf11050so5487276a12.0
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2026 07:30:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/7TQX2b7hOCqaw0KXUhqRz0KgE3/f4Rm7c8Mgmkeae502nUcv4nR76an/AJBPx29c3qTYx8zu1kDX8XA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+MCBIJQWWTZWVU7dYXTV96halY/MAXni5gWNK0mMrtYiLWNNS
	vuEH/JkhhCNTfuDbJhywNhGf743zWb9v9X4hj8NQ9Ey1sskXwQsJK593aLPxQIffzp9iNgCj5kr
	U9GJ8MHjo59Pos4NmyVb3ZOyu+RJ4ur8=
X-Received: by 2002:a17:907:6d29:b0:bed:1876:975 with SMTP id
 a640c23a62f3a-bed187610b8mr293963566b.28.1780324224826; Mon, 01 Jun 2026
 07:30:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260601140958.1333017-1-lgs201920130244@gmail.com>
In-Reply-To: <20260601140958.1333017-1-lgs201920130244@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 1 Jun 2026 15:29:46 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6ZcDK=_s-_s7+E8LHXnGyPGMpnE-uysY85EmRbkRwKtQ@mail.gmail.com>
X-Gm-Features: AVHnY4IM9Log02HP-bD1FRznk2k76ZBQbOLeiZ2TuMWjKhSEMQFbqU5siGf-rlY
Message-ID: <CAL3q7H6ZcDK=_s-_s7+E8LHXnGyPGMpnE-uysY85EmRbkRwKtQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix inline reflink deadlock at non-zero offset
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 1, 2026 at 3:23=E2=80=AFPM Guangshuo Li <lgs201920130244@gmail.=
com> wrote:
>
> clone_copy_inline_extent() can copy an inline extent into a page of the
> destination inode before starting a transaction. If that page is beyond
> EOF, writeback started by a transaction commit with flushoncommit can
> invalidate the folio and block on the same extent range lock held by the
> reflink task, while the reflink task waits to start a transaction.
>
> The copy_to_page path already updates i_size after copy_inline_to_page(),
> so writeback no longer treats the copied page as beyond EOF. However,
> clone_copy_inline_extent() has an earlier new_key->offset > 0 path that
> also calls copy_inline_to_page() and then goes to out, where it starts a
> transaction. That path still leaves i_size unchanged before starting the
> transaction.
>
> Update i_size after a successful copy_inline_to_page() in the early
> non-zero offset path as well, matching the existing copy_to_page path.
>
> Fixes: 05a5a7621ce66 ("Btrfs: implement full reflink support for inline e=
xtents")
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>  fs/btrfs/reflink.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index 49865a463780..5722cccb53eb 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -185,6 +185,8 @@ static int clone_copy_inline_extent(struct btrfs_inod=
e *inode,
>         if (new_key->offset > 0) {
>                 ret =3D copy_inline_to_page(inode, new_key->offset,
>                                           inline_data, size, datal, comp_=
type);
> +               if (ret =3D=3D 0 && new_key->offset + datal > i_size_read=
(&inode->vfs_inode))
> +                       i_size_write(&inode->vfs_inode, new_key->offset +=
 datal);

Please don't copy code without an explanation.

This was already fixed here:

https://lore.kernel.org/linux-btrfs/cbaede508d12a0bd0ef9ec1b49f8338fc46a07f=
b.1779803705.git.fdmanana@suse.com/

Thanks.

>                 goto out;
>         }
>
> --
> 2.43.0
>
>
