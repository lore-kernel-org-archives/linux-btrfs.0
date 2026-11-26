Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795712917;
	b=0i87dphjn444tW8mz2DZ3i2esE7iuHFTaAr8hfp0dWxzJ5QtO1h76iV0582KjfSg+ILH
	 aZQ2BhRV4ULuc9ak4eNqeskkqK+KbgGAWdpNQleVuP9FPoT6F7bBWHjxPgKMV0/KGafIL
	 o//C7BPg+pcVieR2S/g5r2MeSXN04ew3ftNdIgHchrD4R6zi9sPc0r2KG/xEgQYPgPYy0
	 cQfdVXREQTVKsNhaHE5disTtLKPHBqlQ+V8aPHF848wZox5qA+xAXkCTVAheDP4dsCidk
	 Om38l6TxeLlGfJMYM/2SDETxmQd3gGTbVRr27bXiQq/5Ypj91CryS9ORAK00pdJgNdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795712917;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=GB9s9Z5fMY+jBxuhbWIMTzA7JHurDwgI1DXMTPpS/og=;
	b=k+JaM5hhzuEg8y2z3SEPGS6KykvAEqVx89+ZdKTwKldEfxHsalT+wxxAKwiaM7d8NI4Q
	 cZRz1eJUwAjiwcoAOyQjgRU/DuJpiCabBZhxXatJrXzpLveol+J9f70SMz/05979mWq/C
	 5dwz5Fyvt/oG6okjE7JHk4L0DGsrRHYdwQQ78BIghiLs/kH8pkIrggKEQy6GC1WszvueA
	 5oNQ7RAv/tp6TL8iToPWFe3ZA1vLuOJ11s08ZB144zn+r4QfkNXthtE2drMpuULnOKjCu
	 MRtCoKFFzaX1k629xNVLZM8DV8Cc2t/YpSeni2GRnaoB/i0/KamZLtxq9nXpGVA87Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EUmOTQZd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B371B606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 17:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EUmOTQZd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913391F000C4
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 17:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795712917;
	bh=GB9s9Z5fMY+jBxuhbWIMTzA7JHurDwgI1DXMTPpS/og=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EUmOTQZdDdyOp5j1loRpbg5WQ2mygTAeiKcxdo4pqG+rYRUlv4ub1czzsFGPxKxxo
	 VAHeRdsFKJQti/z4jkJsHgdPzSA7CitardTAJTvZvYGzLGbFIq7SoLb1H8jzZkuJ7L
	 ahKBuvo3UrbH77zBm61xs4NRKqkV2nym12z30uausHCStAN910goMMsIJhDB/AHrc5
	 KI9xoTPjbTnazdXfuAhojoVvtcBbjQH6DEalwXzU8FalshFwDG/1RACU2VW2dnOsn5
	 sUpEAIOKkEUUBVmZyy7XNZ9fSxdBTElbmFJIddHhOxbTlh3Vkas3LiCoTDNZHoZiLH
	 jkdktIqiLWZHg==
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5eadadf23e5so5064423e0c.2
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 09:08:37 -0800 (PST)
X-Gm-Message-State: APuU4Z9NULVlb76l6SHZjuwpdpjRtr7+FRwJQkKK/iBCl1fOOOBa6CEm
	+IbO+Vm8xDNOqtyDNIydJDNhzwUOAsCR6fFQbneX/UEd+E632zuvzQSD9b0of6ws/+H7NCOlG9J
	63UyusR5gszs9s1SF32adieR/mcXEdFw=
X-Received: by 2002:a05:6122:2092:b0:5ea:a0f0:1945 with SMTP id
 71dfb90a1353d-5ee8aec18e0mr13567427e0c.6.1795712916800; Thu, 26 Nov 2026
 09:08:36 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1795576387.git.wqu@suse.com> <6e3b33445364d7d0f4b95323e51ee2cbbee28aa0.1795576387.git.wqu@suse.com>
In-Reply-To: <6e3b33445364d7d0f4b95323e51ee2cbbee28aa0.1795576387.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 26 Nov 2026 17:08:00 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5714wRCO=FiQUwWMMVPg5ENJXj4oXOfm0LWHKQ9pXmig@mail.gmail.com>
X-Gm-Features: Aa3M54rTo8leBM0igAUbVTvMPPWZi8XTSPaqTCPJKCPynCsvtsEEW-QzOCFBv4c
Message-ID: <CAL3q7H5714wRCO=FiQUwWMMVPg5ENJXj4oXOfm0LWHKQ9pXmig@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: backref: reject direct parent if the current
 level is maxed out
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 3:15=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> Similar to the check in handle_indirect_tree_backref(), in
> handle_direct_tree_backref() we have a similar problem that if a tree
> block at level 7, searching for level 8 parent can lead to
> out-of-boundary access for btrfs_path structure during tree search.
>
> Fix it by rejecting such backref walk if it's not self-parenting (e.g.
> reloc root).
>
> Link: https://sashiko.dev/#/bug/linux-e90153be-7335-4621-9d72-6316f96cea8=
2
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/backref.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index a0fb90b7a9ed..e8c299e1c010 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -3221,6 +3221,17 @@ static int handle_direct_tree_backref(struct btrfs=
_backref_cache *cache,
>                 return 0;
>         }
>
> +       /*
> +        * Self-parent already checked, and if we're at MAX_LEVEL -1,
> +        * there can not be any higher level parent.
> +        */
> +       if (cur->level >=3D BTRFS_MAX_LEVEL - 1) {
> +               btrfs_err(cache->fs_info,
> +                         "tree block at %llu level %u can not have any p=
arent",
> +                         cur->bytenr, cur->level);
> +               return -EUCLEAN;
> +       }

Please use unlikely(), as all branches that lead into unexpected
critical conditions should use it.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> +
>         edge =3D btrfs_backref_alloc_edge(cache);
>         if (!edge)
>                 return -ENOMEM;
> --
> 2.56.1
>
>
