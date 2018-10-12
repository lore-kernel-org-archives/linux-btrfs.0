Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51250C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 09:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10DD12075B
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 09:01:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CNK87MmX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10DD12075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbeJLQc6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:32:58 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:36216 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbeJLQc6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 12:32:58 -0400
Received: by mail-vs1-f68.google.com with SMTP id c205so11249267vsd.3
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 02:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=efYR/zbb2QzElkEDns6NZEsK1ut7TJeNAcuSDSiKwjY=;
        b=CNK87MmXcjWN045kT6W3f/FtFlaYxpGUP0CACf7uQml9p0gt4kgwg77e2UnMI9cA0U
         6qUeQwevXamYW6ZPvY67C0QXPdaI4X+Joc5XXwmq1/3STbQ88DnAMKtMYB/JZUWy7edJ
         IZE/ZNc/zvu+bK/B+//lmed19oURyM/AWIRsTbNfW3eOCJh5U4zLXhYbecNt7HWdL+Id
         Uig0fZ8NDp/jJ+ixaXRCFZOl+g44eI/8TUQglxOrByRFqWBuoUFwwx7FaFOqfSD3+mhr
         O5oPGbOw3H0wyjhKh2TUWz9nAP7i2PuuGYDNsLzQS9eqt63BRAnK2lZCVaj12LlG/J54
         ReWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=efYR/zbb2QzElkEDns6NZEsK1ut7TJeNAcuSDSiKwjY=;
        b=He1gxHvDufdFUZzEiZqBNJiHWl0WMvmweRJo96Em8xMXtS+E2/DvYvOeuPQSpxxHV+
         XAleqrOMG1K0CxKu6WfNPDe8V4tRGzJzIQTtK/I839pwT8Z4yAIOxk/3aw4PSRs0/f2w
         NB3LCM1thC0L7Gw6Ms2ULBPUG7LRQRvc/JDSNA66B98peQDaxJoH/aUylTwxuJaQ4SNt
         eH83hoLo9bKGXKdeIwhBBuKTWUfiWzBnOs0yx9cvnQK16+HrZMjWDeOCHXFeKiqxpoz7
         ZSjgjaGvS9sZb4nsDlxbcJVBzTOeA9HAl6/H0qqbIld5ISDu0rP6x4yVGoIPMFkr7r7x
         x/VA==
X-Gm-Message-State: ABuFfoifn6Mu5WzSVg6D2Tw5hdUFUDm8nCm8yedbHPC8nuAbeL0wxJlq
        MTUqaT17GvBKWiteG4Uoyp1DIuA5bOYxSnsvl1U=
X-Google-Smtp-Source: ACcGV60dV6cVj5aobxdIDlYU01sCkzEflAx6yXFyMrbAOWRkxl8b8o55U+tU1r75i0BgneSaeUzDTeDSX5NbbXlhaXU=
X-Received: by 2002:a67:8a88:: with SMTP id m130mr2070974vsd.206.1539334891518;
 Fri, 12 Oct 2018 02:01:31 -0700 (PDT)
MIME-Version: 1.0
References: <20181011195431.3441-1-josef@toxicpanda.com> <20181011195431.3441-21-josef@toxicpanda.com>
In-Reply-To: <20181011195431.3441-21-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 12 Oct 2018 10:01:20 +0100
Message-ID: <CAL3q7H7uG9o1+QM5oQSbhd7sDf2=TxDchy+Em38Veo-NCqzoag@mail.gmail.com>
Subject: Re: [PATCH 20/42] btrfs: don't use ctl->free_space for max_extent_size
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 8:57 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> From: Josef Bacik <jbacik@fb.com>
>
> max_extent_size is supposed to be the largest contiguous range for the
> space info, and ctl->free_space is the total free space in the block
> group.  We need to keep track of these separately and _only_ use the
> max_free_space if we don't have a max_extent_size, as that means our
> original request was too large to search any of the block groups for and
> therefore wouldn't have a max_extent_size set.
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/extent-tree.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 6e7bc3197737..4f48d047a1ec 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7496,6 +7496,7 @@ static noinline int find_free_extent(struct btrfs_f=
s_info *fs_info,
>         struct btrfs_block_group_cache *block_group =3D NULL;
>         u64 search_start =3D 0;
>         u64 max_extent_size =3D 0;
> +       u64 max_free_space =3D 0;
>         u64 empty_cluster =3D 0;
>         struct btrfs_space_info *space_info;
>         int loop =3D 0;
> @@ -7791,8 +7792,8 @@ static noinline int find_free_extent(struct btrfs_f=
s_info *fs_info,
>                         spin_lock(&ctl->tree_lock);
>                         if (ctl->free_space <
>                             num_bytes + empty_cluster + empty_size) {
> -                               if (ctl->free_space > max_extent_size)
> -                                       max_extent_size =3D ctl->free_spa=
ce;
> +                               max_free_space =3D max(max_free_space,
> +                                                    ctl->free_space);
>                                 spin_unlock(&ctl->tree_lock);
>                                 goto loop;
>                         }
> @@ -7959,6 +7960,8 @@ static noinline int find_free_extent(struct btrfs_f=
s_info *fs_info,
>         }
>  out:
>         if (ret =3D=3D -ENOSPC) {
> +               if (!max_extent_size)
> +                       max_extent_size =3D max_free_space;
>                 spin_lock(&space_info->lock);
>                 space_info->max_extent_size =3D max_extent_size;
>                 spin_unlock(&space_info->lock);
> --
> 2.14.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
