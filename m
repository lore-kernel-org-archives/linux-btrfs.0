Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E42C6783C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 09:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C023B2075B
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 09:02:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iZplF7fy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C023B2075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbeJLQd4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:33:56 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:46034 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbeJLQd4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 12:33:56 -0400
Received: by mail-vs1-f67.google.com with SMTP id g201so11218493vsd.12
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 02:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=zbMg3LW++o1Sqsjc+h4A3m1zJpb9IMna0JYwU/J3G84=;
        b=iZplF7fyl5qNsil882SZzaX1Ke7Ny9ktyGEkRi/wZkVDcgfU/rfLHnn/Yz5tjA+x2H
         33wOR88z0sxxhbCYx/uMXcuOIHWIdVsk9wJ0KEWlydpGqkKcEazw3i6Yyp8SlCh1/JCi
         /+28LNCuETcDa06GrIqdYdUkXPoUflQ3Eu48/3QfNn5bYc0garWHkJNTDejlTsMHBDLr
         rT0XI5nTmTM3bXaalkPqhMD78ICcXk7+a6jSimFgK5M1pH7fFd+c8vmJv7wrt0IT7sXk
         pUfjM00Au/+47PPa2BMJWzRwDTI9aQONvzvawBqG0EHgeGOrmhuI/W4aUl7zIUvv5Zii
         MLxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=zbMg3LW++o1Sqsjc+h4A3m1zJpb9IMna0JYwU/J3G84=;
        b=MDbZPX7SYgwvvSleSxcqS6ltsCrSNyOpArQMrHTY2ZFuhjZOB4DvWp0848QSWPGUnh
         Or9fEyIt7J4vymQQzJ5HUfawcU/d/OhEYzgyOmlDPEYYiVhFHxMw8VHA1pHtPKcAM49e
         cVPLysJLq/ruCAveD510L5LNBfs52dTVKtDsQmi2gcuOTZmu4ehuzscLGEt7nqJFaHtY
         6PXbPKV8YNBCq4FpLJ9C86jepHMbWa1ANrgF7Mn1eMdYvzHCr7SVhcBSV9BiNj1aZOzn
         q3Iqsfg5aubJUqjCyCPCTTFnTtmlCFWT+I3aiE4GtQPQNz1VmKoKub20vLhx/XCgBqeI
         ViVA==
X-Gm-Message-State: ABuFfogBPs90LbfXqjNb8K0ya34SP0rQY/xZ8H7kDQebVjUas7dJiBiQ
        CQJkJ4B4EEkTBo9BtX8fZBE+52AgV9dB8Csd2OzMwwnv
X-Google-Smtp-Source: ACcGV62HFcugx1TAIMrJBKNoMziTfiKuXrKAdCscHMkvMK5HhZiG2Bd3CF122kMDwZt/o+3jzO3DeG/rBmjENlB0Tyw=
X-Received: by 2002:a9f:2727:: with SMTP id a36-v6mr2318875uaa.137.1539334949379;
 Fri, 12 Oct 2018 02:02:29 -0700 (PDT)
MIME-Version: 1.0
References: <20181011195431.3441-1-josef@toxicpanda.com> <20181011195431.3441-15-josef@toxicpanda.com>
In-Reply-To: <20181011195431.3441-15-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 12 Oct 2018 10:02:18 +0100
Message-ID: <CAL3q7H7Z4csvF=wLgNME9HXCDg2vyFuaq_pk9ZnQ+hMt0=0eHQ@mail.gmail.com>
Subject: Re: [PATCH 14/42] btrfs: reset max_extent_size properly
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 8:57 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> If we use up our block group before allocating a new one we'll easily
> get a max_extent_size that's set really really low, which will result in
> a lot of fragmentation.  We need to make sure we're resetting the
> max_extent_size when we add a new chunk or add new space.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/extent-tree.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index cd2280962c8c..f84537a1d7eb 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4573,6 +4573,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle=
 *trans, u64 flags,
>                         goto out;
>         } else {
>                 ret =3D 1;
> +               space_info->max_extent_size =3D 0;
>         }
>
>         space_info->force_alloc =3D CHUNK_ALLOC_NO_FORCE;
> @@ -6671,6 +6672,7 @@ static int btrfs_free_reserved_bytes(struct btrfs_b=
lock_group_cache *cache,
>                 space_info->bytes_readonly +=3D num_bytes;
>         cache->reserved -=3D num_bytes;
>         space_info->bytes_reserved -=3D num_bytes;
> +       space_info->max_extent_size =3D 0;
>
>         if (delalloc)
>                 cache->delalloc_bytes -=3D num_bytes;
> --
> 2.14.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
