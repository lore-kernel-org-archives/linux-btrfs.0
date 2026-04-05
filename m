Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485EB207DF7
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Apr 2026 10:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775383549; cv=pass; b=DhGKH7gewD106K/iSBK7c7quDlTO08xHCkWNYpZFAdRxbAOqV43h6ci8sG5QbvMxSOlmPE9xgZ2ut7BkcypY2SenEYO756NDryox50Lbvua9/iZgNVdmXTrwemIiIZqXRr+OH87jN2OOb5Twb4ibn0lfMmjz/uVQXTJjD+ePNas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775383549; c=relaxed/simple;
	bh=PLvhB6f5tPNUof+KCb50udsv+rewU9dQh1jN/S/DRrI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gXX2KwqRktlA5uFlJs102H3zRds3qaMuuDsvRqIjkL5PeYqSNU5TRIHycIfgJeDFbwKyohtrhsotLNi90I5OiAfdstpRfYrpMtAHCM5923POZtVhPN0m9ZtYBRRLLorZ4UV4J4bTtxI7z6LOmc+Qk1PQsZ7zLrZ33X2J6Xj80dQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dIuHNyhQ; arc=pass smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dIuHNyhQ"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-79be0de8610so28515077b3.2
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Apr 2026 03:05:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775383547; cv=none;
        d=google.com; s=arc-20240605;
        b=I+VpysI/W1iq7os0SyJMq6kghzkcX29zlHHSxT49/WoNpK6beE3GaGUUjXqevomGlT
         Ht++ijIksoPhB2x+zLVPMIwYJJsiqEakQn8UQYep8BYFxJrLKlHu5gG43nZR5wiy6mPN
         SUuUvpN6njrY01MAOVHLGbp8o8yJvN0B6JhrHO1iYZz/PM1WSasApVqU6aSCwDBI6e1x
         X2xxxCG78tuwiGaSe5gbjJy84468DsPSro7JJojAsHD4TNdL23uRNRd6pk69MTQY14EY
         VBZ0xipZ24hNrS/igYWmLHMduEy468pkm9uphzMLvxrWrBrTfTdZhvQm/vX8hb2gulzx
         bdQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aA4ut8iTGUbX9FTvkAUrIcRCoLUrVP3k1NaYUXgfAD0=;
        fh=I0BZtym/dq2AkUzeGWefekiLWTjcI/dwL9dya7WC7sI=;
        b=IObZwePvXDgxhBNF4hCJOjc9yAm7GUqHh9n3xEuxS5G7iA5HPd/0AmLN6ymp9FXS8M
         Pn0DDpZwGHWUiF+pfx8vmPMlombC1UVQyGRUjuyxgKfOUFd0WjbVyUZdTwTvsw0WQs30
         awPG825ZuhwpE8skdjCdHM3iv56sADOP9xw7r4veucXR3FPaFkxfj8AvJ4vwIAcOaYL2
         mhukXXTAUmQ8yoaubsEtK3LpKGWnJkVW1RiKY1D7loyY61xr9U5N0JNdIIm8znFi7fB9
         uomY2mFXGEyfoPfBrHEWKf5oYVJaWXVjeZT7iTK8BTCfjJEp2QJJX7pqKLuq5YovHKIl
         NPKw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775383547; x=1775988347; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aA4ut8iTGUbX9FTvkAUrIcRCoLUrVP3k1NaYUXgfAD0=;
        b=dIuHNyhQCtYKD/woXnZBnY/wUBqshd3//sN3KWOCgoSwz/l7piokO35n45bxEg/1Lq
         7qJf298cf63BDq/TJbatg+PjJttvRuCXeEWz0sByrZWGoL/v9HwwIasF4OU3kMMFTRaD
         7H646HzuScc9B0JOeTekWxdpQkubU9QiqrrxHnSWS2Cj1ZQxEIn3gYJ8hmHL2l762OXG
         0aHQxU+vvjdUzhYH43DdFNJ+943KKTyLcteF+axuzRRq0u14JfyXDUb8RrMM7ctN0qQ7
         ThEjjEyXg/eR/h91pE+F95nwABQoHONcPSt96zX8UIqhRTH+VV2YA/SM7gYzxYDB63gs
         z5OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775383547; x=1775988347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aA4ut8iTGUbX9FTvkAUrIcRCoLUrVP3k1NaYUXgfAD0=;
        b=Xd9TwXHXoq5/wrpc1Ae5M9NYGclCwBwllPiE1Adfu9OmEkp40dvxDjp5f9SDuDvqaL
         NYti9YNhJ+nHQquzWsVd/XnOz5vA79Q+K+fwPdNXRszo8RhzC/xG4GFBA+Dl9BmnjQXo
         kUHFLEe3/oTxo0MDt76MelsjsLe4jZJdqRRHKMcqwj1avRri6W1il3J0oto50pZ4i02x
         P1Ff7iTOMdLSIxBSjy6DgFGmzipoGoQzpbHTliWydA+GWQgSGOT/JZFMWu/4Jjh81eh9
         eWTYsmBkoM+TJGVQuP6N5SAVDbVlCym0oqEfEfj68j5I0p6QA5HsbMG84PkjxJzZR9Yv
         MkMA==
X-Gm-Message-State: AOJu0Yw+NStua4v5VXzLO/YQJsC9/USuv1/sONwyeyf5kcvkjrPuK9N9
	cZCkpy1PfB+aQFXHlcQ9+rT6upAicdEiUK9oPlD4hfqEkjYVib4FU8jLzgX2BhsdAZVHdrvSWxK
	2ZD+tYcBv0GbRqswtVZdZ853KCaTtC+vq0qajhgc=
X-Gm-Gg: AeBDiesQ6sLAA6/h7wBKQrtKC9hRDGtaoaw5SHQRihrmlq7Nrykg3GX5m/PkoCHZQ4G
	wMKy6DRONq3zryrKsddKElyFttob3p5O0UWJ1u6qr8x6VDybmLk8mzJTU63khVI9YtBVcirjBzg
	76S4wLh7hZ5DIVyHtftwVnFxmqdWu4G2bnsZf+LG0HUEXGoqeu9RXCDfPEafEGPkKPmLhVRATmO
	A6pf9YFxUJlR3R/DuJnXpRkFd7qNrUm8paF2Q1tuCq9SGx6bD0Q5TUR9rkB2wv/TUssQTsoA3u8
	Xu+7aDU=
X-Received: by 2002:a05:690c:6e86:b0:79a:c7f8:d99f with SMTP id
 00721157ae682-7a4d3bd7d64mr88019887b3.19.1775383547203; Sun, 05 Apr 2026
 03:05:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1c3a439e1e21c4ee32575b264ac0bc3935ea4f53.1775364843.git.wqu@suse.com>
In-Reply-To: <1c3a439e1e21c4ee32575b264ac0bc3935ea4f53.1775364843.git.wqu@suse.com>
From: =?UTF-8?B?66eQ656A66eQ7JW8?= <iamsyahn@gmail.com>
Date: Sun, 5 Apr 2026 19:05:35 +0900
X-Gm-Features: AQROBzCUA-EQwmFfkK_e2a8E5HJxcyoK6J5G8LZCaflx8F8yQlz2EdAz8iwiZB8
Message-ID: <CAF88fHW78qAz6gxkJct2pSdDN0L4Np=uQPUixVr3Gim4430AAA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: warn about extent buffer that can not be released
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Teng Liu <27rabbitlt@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Qu,

Thank you for the patch and for including me in the report.

Please understand that I am using an AI assistant to write this email
as my English is not very strong, but I wanted to make sure my message
is clear.

Unfortunately, I have already formatted the problematic drive to
recover my system, so I cannot reproduce the exact same corrupted
state to test this patch at the moment.

However, I am very honored and glad to hear that my report helped
improve BTRFS for everyone. Thank you for your hard work on this fix!

Best regards,

Seok-Young Ahn


2026=EB=85=84 4=EC=9B=94 5=EC=9D=BC (=EC=9D=BC) =EC=98=A4=ED=9B=84 1:56, Qu=
 Wenruo <wqu@suse.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> When we unmount the fs or during mount failures, btrfs will call
> invalidate_inode_pages() to release all btree inode folios.
>
> However that function can return -EBUSY if any folios can not be
> invalidated.
> This can be caused by:
>
> - Some extent buffers are still held by btrfs
>   This is a logic error, as we should release all tree root nodes
>   during unmount and mount failure handling.
>
> - Some extent buffers are under readahead and haven't yet finished
>   This is much rarer but valid cases.
>   In that case we should wait for those extent buffers.
>
> Introduce a new helper invalidate_btree_folios() which will:
>
> - Call invalidate_inode_pages2() and catch its return value
>   If it returned 0 as expected, that's great and we can call it a day.
>
> - Otherwise go through each extent buffer in buffer_tree
>   For eb that still has EXTENT_BUFFER_READING flag, wait for them to
>   finish first.
>
>   Then check if the refs of the eb is greater than 1, if so it means
>   it's still held by someone, give it a warning.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D221270
> Reported-by: AHN SEOK-YOUNG <iamsyahn@gmail.com>
> Cc: Teng Liu <27rabbitlt@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> This new debug feature has exposed some problems, e.g. generic/648,
> after an injected failure for device barrier, transaction is aborted but
> we have a lot of dirty tree blocks unreleased and triggered the new
> warning.
>
> We still need to fix these corner cases.
>
> Meanwhile if Ahn or Teng can give this patch a try for the existing
> use-after-free problem, it would be appreciated a lot.
> ---
>  fs/btrfs/disk-io.c   | 52 ++++++++++++++++++++++++++++++++++++++++++--
>  fs/btrfs/extent_io.c |  6 -----
>  fs/btrfs/extent_io.h |  6 +++++
>  3 files changed, 56 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index b8ac3275d8f8..d450bfc6d89b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3276,6 +3276,54 @@ static bool fs_is_full_ro(const struct btrfs_fs_in=
fo *fs_info)
>         return false;
>  }
>
> +static void invalidate_btree_folios(struct btrfs_fs_info *fs_info)
> +{
> +       XA_STATE(xas, &fs_info->buffer_tree, 0);
> +       unsigned int checked =3D 0;
> +       void *tmp;
> +       int ret;
> +
> +       ret =3D invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +       if (likely(ret =3D=3D 0))
> +               return;
> +
> +       /*
> +        * Some btree pages can not be invalidated, this happens when som=
e
> +        * tree blocks are still held (either by some pointer or readahea=
d).
> +        */
> +       xas_lock_irq(&xas);
> +       xas_for_each(&xas, tmp, ULONG_MAX) {
> +               struct extent_buffer *eb =3D tmp;
> +
> +               /* Wait for any readahead first. */
> +               if (test_bit(EXTENT_BUFFER_READING, &eb->bflags)) {
> +                       xas_pause(&xas);
> +                       xas_unlock_irq(&xas);
> +                       wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING=
,
> +                                      TASK_UNINTERRUPTIBLE);
> +                       xas_lock_irq(&xas);
> +               }
> +
> +               spin_lock(&eb->refs_lock);
> +               if (refcount_read(&eb->refs) > 1 || extent_buffer_under_i=
o(eb)) {
> +                       btrfs_warn(fs_info,
> +                       "unbale to release extent buffer %llu owner %llu =
flags 0x%lx",
> +                                  eb->start, btrfs_header_owner(eb), eb-=
>bflags);
> +                       if (IS_ENABLED(CONFIG_BTRFS_DEBUG))
> +                               WARN_ON_ONCE(true);
> +               }
> +               spin_unlock(&eb->refs_lock);
> +               if (++checked % XA_CHECK_SCHED)
> +                       continue;
> +               xas_pause(&xas);
> +               xas_unlock_irq(&xas);
> +               cond_resched();
> +               xas_lock_irq(&xas);
> +       }
> +       xas_unlock_irq(&xas);
> +       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +}
> +
>  int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *f=
s_devices)
>  {
>         u32 sectorsize;
> @@ -3706,7 +3754,7 @@ int __cold open_ctree(struct super_block *sb, struc=
t btrfs_fs_devices *fs_device
>         if (fs_info->data_reloc_root)
>                 btrfs_drop_and_free_fs_root(fs_info, fs_info->data_reloc_=
root);
>         free_root_pointers(fs_info, true);
> -       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +       invalidate_btree_folios(fs_info);
>
>  fail_sb_buffer:
>         btrfs_stop_all_workers(fs_info);
> @@ -4445,7 +4493,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_in=
fo)
>          * We must make sure there is not any read request to
>          * submit after we stop all workers.
>          */
> -       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +       invalidate_btree_folios(fs_info);
>         btrfs_stop_all_workers(fs_info);
>
>         /*
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 1ba8a7d3587b..a8887285deda 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2877,12 +2877,6 @@ bool try_release_extent_mapping(struct folio *foli=
o, gfp_t mask)
>         return try_release_extent_state(io_tree, folio);
>  }
>
> -static int extent_buffer_under_io(const struct extent_buffer *eb)
> -{
> -       return (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
> -               test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
> -}
> -
>  static bool folio_range_has_eb(struct folio *folio)
>  {
>         struct btrfs_folio_state *bfs;
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index fd209233317f..b284aee1bfb0 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -326,6 +326,12 @@ static inline bool extent_buffer_uptodate(const stru=
ct extent_buffer *eb)
>         return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
>  }
>
> +static inline bool extent_buffer_under_io(const struct extent_buffer *eb=
)
> +{
> +       return (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
> +               test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
> +}
> +
>  int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptr=
v,
>                          unsigned long start, unsigned long len);
>  void read_extent_buffer(const struct extent_buffer *eb, void *dst,
> --
> 2.53.0
>
