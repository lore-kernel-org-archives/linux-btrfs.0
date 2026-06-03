Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F35A256C61
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2026 12:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780490207; cv=none; b=MnBauQ+3ZfUMXReOej2YH82odZMKx6Se3KluDtZ6O4kDyVqOzS283a+srdX/WUO8Lf6WidK7heVPxVY0eTPqVBpy8IJv9WkhsehW4pSt+PBHomKYCCxxE886eqZPkIJiiHF52uapCijjAs84f6wfDQL7YfrRyccxbXeYT4UuuHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780490207; c=relaxed/simple;
	bh=Qs5KYChHLHoHA4z840LRdcaRfH0aPmZRfj64MEj1ObA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gIb2qLt7oYSk5QJXOuAxW4ZHCCqLSv07L7dMIo4DEAIMCcc0MZm2SACDCy5OdZX7WBaBY51VaCurw/bb1LIvrrCRrKEtHynXMEeTo/Gb2sjIwxnYBwEA6RGsFgzqxPtLPJndnf7LJjCZ+4cIz6PopdcaMaufEJy2wLnSEanpyvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i1LSUIDX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i1LSUIDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9A51F0089A
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2026 12:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780490206;
	bh=35dYtAIZ1//fMuvfDZ6ccVJxYuTISNuP2iqrx+lv1iE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=i1LSUIDXoOmrQcjtIqiN9HH3pe86Xx5erO2H66qAVb7QfAqe31RV1l9WUn6/tL3St
	 VebII6zm64k/jvs1D/I6EfU+Ri8zPkWrHQTR+85uA3jAUQ4a1pehE8h/fXXmqD+iIV
	 2Dobgvtt34Xf5ffzpPNr2qmTX/03mA7VRkVflEP5bKg3XzumbRfqVd9a30pl3lnDW6
	 MhxUUDl4TVT0OnlQNwwQ4JF3y+oR1azt1js9TjVe7aFvIr8mTI9xs5HtVQqhoazsW3
	 S9auA11uRgXN68VlAdGL+Ux+xJHirJ8oaItIaALDltDZUOvE4GzqoKRg3+rs5ig0au
	 Va61hHxFlFFMg==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bec441e4018so426582966b.2
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jun 2026 05:36:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/fKnJ+p0d5qAwmeuwzGVxLZXVXeSDgtlsEg+Grslcn81nFPoeMJMZyEBy1IjxVY0OAw/fQXvwiU9QiyA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKwEVrCJX2beYSAmW8jO2YvgxQEAxmTEGP2X6fo2nfOG/ELmBK
	mvZOO4Cm2sTBgfbkKEPYhTxndtZruLd4RP8hjOmB61vWDNl5MC+AiRKOfPTihk/8obaMoHB026K
	aanMIhPHCBFiVf4WhXcwsk881DQXMQ5E=
X-Received: by 2002:a17:906:9b4b:b0:bf1:1d19:cf98 with SMTP id
 a640c23a62f3a-bf11d19d687mr72618266b.15.1780490205050; Wed, 03 Jun 2026
 05:36:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260603120443.1394044-1-lgs201920130244@gmail.com>
In-Reply-To: <20260603120443.1394044-1-lgs201920130244@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 3 Jun 2026 13:36:08 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4qiQfY6ZjGPnqhRm=nteYmg-4vCb-FwV6eA5NHy1bthw@mail.gmail.com>
X-Gm-Features: AVHnY4IwFZ9QVWGYVXdtXOLje32NXDY7XTDayiAZmPUa8mPLHzfBcXC3xQWM6OM
Message-ID: <CAL3q7H4qiQfY6ZjGPnqhRm=nteYmg-4vCb-FwV6eA5NHy1bthw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix inline reflink deadlock at non-zero offset
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 3, 2026 at 1:25=E2=80=AFPM Guangshuo Li <lgs201920130244@gmail.=
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

Again?

You already sent this patch yesterday, and there's a reply:

https://lore.kernel.org/linux-btrfs/20260603120443.1394044-1-lgs20192013024=
4@gmail.com/

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
>                 goto out;
>         }
>
> --
> 2.43.0
>
>
