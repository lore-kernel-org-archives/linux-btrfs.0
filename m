Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795628279;
	b=GRcjkj0WyDkCCHPJWjuJU+/PZvwCqAiL+64WmzPCHTmVp/2QLXpTDjYMcdO1wOMQTpQD
	 HG3hkhruZgj0RqDOIQqT7lZbaa3dWhTHSly2IIul/Ac1KjNGyGHgrVhZj/Hqlv+3ixJ/L
	 45kDJFGDyHRAFBzrP3SD5aMyl0U3JtMpfw47/9XLXjtTvIxMK2SkiARY7ay7MZ4LH3ag6
	 ltfZczzv6p3gi7XxiWKPHTsRgnNrMFGIYxPSuI1N2EeB5BkDn+Z+WzcIXsXEMAW60VESL
	 tvU7UgDkmHZKHSVZh5s0HsDT1/Cg1XL7VPYl/8SpuKqjA0AyqpTsagmk13PCLXOwh+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795628279;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=0svShfW9shblQTbUlL/JkG6kxTptexeOsInXxOic9OA=;
	b=2pxvF28sjoOzoYDHwXXGom1STAU1umxocYgTwfPd1zlULPWxdaQlOXWxX8Ok3R9c0gCG
	 fdOoz0c/h1qCj4i9b8ZNvxAcumdTs6Xj+shY7NL51xRqJKlVkQrAyaTungGQvSdRe3F/v
	 cZ00StoNBdTbPvebN5JVtt7njrGcS5cVRfYKZDIh7eYo1wadHuVfuEjcMfu9jOfVufGkE
	 JEsdwVQHSWgTROKYu0H/RqSYklH82oZGmfhgJtI5LHMvkBcowB/8MPYwK+tpNgvb9wuoo
	 hV1QAn/hIGpAkkUkH+Biot9PX3O9gmdvlH3jrzjVhB2yhn9BqwAjEE5zLGzA3Ha5AbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yl5VBzs3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9B5606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 17:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yl5VBzs3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A6F1F000D0
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 17:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795628279;
	bh=0svShfW9shblQTbUlL/JkG6kxTptexeOsInXxOic9OA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Yl5VBzs3zTaDgbe9jXHEByvTuG3LYkQbZYpYptDvpNVa4hA2rMP+SfWvdetjCSout
	 pGXkJm0EfZTmdslsRJ5U3WVEgu/yDFDt/WoXbll79A1DVmFsBYFddDcse6xIKwW7gH
	 06mLnNOsPPSYwG4CckwDLgCtNZ1M6H8OtfZk25wUkL0N2iZD+35wt0XnMuwp3Xl34y
	 cHRpzYYIstGVa2ZwLpOjMHP0qgmLPeE4GZNkaf+EAvTNon2/rFYyRMGR01ijaEiHUP
	 6GY1PZILd+2O1YHTcGXe6z1S7lAbHS95GlPnQknFOfYervqN4akNO24y7X6yTLv5r2
	 hwXEtDMJSbxng==
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-99e740a7131so2739067241.2
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 09:37:58 -0800 (PST)
X-Gm-Message-State: APuU4Z9CTUTGlUhasn4HPi6ralwzsnyFI1hl12auxQfERC6WyItoTMvh
	dHJehPvtZ57r3WYvVr6B9lCslWgrndfDAzC2I04SMN6W0kTijnWj1Nda5752yqjuLom5OSpB2fp
	S4XJHayU1nnuemQDsHjhRMOc2qXuTzV4=
X-Received: by 2002:a05:6102:374d:b0:7cc:971a:61ee with SMTP id
 ada2fe7eead31-7d7393ff678mr11174527137.10.1795628278144; Wed, 25 Nov 2026
 09:37:58 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1795466145.git.wqu@suse.com> <2a0a92aa027b67006da45ba8abb8177b333e31da.1795466145.git.wqu@suse.com>
In-Reply-To: <2a0a92aa027b67006da45ba8abb8177b333e31da.1795466145.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 25 Nov 2026 17:37:22 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6_1_fEkLo18DB1BfAfunfg3omGJ6OE0ZwMF-jrZRT-8g@mail.gmail.com>
X-Gm-Features: Aa3M54qwRUhH64rXn-RLu3v9hl1_5SCNo3-etrwy6hB0wXHD_6gdU6uZmBTorfw
Message-ID: <CAL3q7H6_1_fEkLo18DB1BfAfunfg3omGJ6OE0ZwMF-jrZRT-8g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] btrfs: avoid NULL-ptr-dreference after a
 lowest_level search
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 8:38=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> In handle_indirect_tree_backref(), if we got a corrupted backref item
> that has a valid level (e.g. 2), but higher than the subvolume root level
> (e.g. 0), btrfs_search_slot() will return 0 or 1 depending on if the key
> can be found in the leaf.
>
> But the returned path->nodes[] will be all be NULL.
>
> Later we call btrfs_node_blockptr(path->nodes[level]) will trigger a
> NULL pointer dereference.
>
> Fix it by checking if we got a valid eb pointer before calling
> btrfs_node_blockptr(), and reject it as we can not find the parent tree
> block.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/backref.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index e9434e033372..29737246d481 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -3336,7 +3336,8 @@ static int handle_indirect_tree_backref(struct btrf=
s_trans_handle *trans,
>                 path->slots[level]--;
>
>         eb =3D path->nodes[level];
> -       if (btrfs_node_blockptr(eb, path->slots[level]) !=3D cur->bytenr)=
 {
> +       if (unlikely(!eb || btrfs_node_blockptr(eb, path->slots[level]) !=
=3D
> +                    cur->bytenr)) {

It would be more readable to split the line after ||, instead of right
after the comparison operator of a subexpression.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

>                 btrfs_err(fs_info,
>  "couldn't find block (%llu) (level %d) in tree (%llu) with key " BTRFS_K=
EY_FMT,
>                           cur->bytenr, level - 1, btrfs_root_id(root),
> --
> 2.56.1
>
>
