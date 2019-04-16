Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08AAC10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 11:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61AA82075B
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 11:23:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KG1e2I0+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfDPLXL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 07:23:11 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:37884 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbfDPLXK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 07:23:10 -0400
Received: by mail-vs1-f68.google.com with SMTP id w13so11302021vsc.4
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 04:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=g01kF2fiz+RcWB3GINqPmVmOBGBOh3rVgu9fnfeKYCk=;
        b=KG1e2I0+JBmjh/nx/ZFY0ChXxTtJFx3FgvpSIzEBgDpWVwLbC0tO1N11D8S8Q36mMd
         ntIiR7LNuvmSbz9Rs83x9DaO15Tmw4xVZ/Hmi6o1wrP/yRwiuFoXBZyzdvDNZxU7hCfd
         s3w0xmwdNGsZ4hy7YMCI5AW4dVEgdYXpUko10/j6qzjE21ANUtA42D1dAshrEZ/kerUm
         yAPdYAmkPdudvNgF15bcJzAntYTdTtATiY6Iq3febIa1LpY3LxrVjJ5I5H0Riei7P4kx
         Z8ECRNwOeZ6M6xhseA1Mq5BeJ4jopQq0Yqz+iODutmNZaSlG/cVKhc2gcv491mjorXhy
         Nfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=g01kF2fiz+RcWB3GINqPmVmOBGBOh3rVgu9fnfeKYCk=;
        b=hp2EQ7SpqczBo6BigveDNduF9beoxPXTYPkhKclBwhZL+fZYkfVX8CiCfnZzY8NvHB
         PctSKqkVXW48a0Z1RSU4zeZgkanehoLFKAIg9u+tjWyE8OvDEdl2fr6INGoh2U3A6jZ+
         lKeG7UD2wNTUK/2YFeVDob1LYYuVomG0rMRZ8S+gsKx/jxumO4vGOwl3BWBmbZSI1ruN
         qbbTIGGYTQiS38l9yaHwxqozY9jtBWCwi1HW12BRkBPuOCCQA6S7caFeiprAuOi3UvKV
         qGXMYTYbxsxKAMizNAno/6HxKp5N84SAClMe4p+rntBJ2KLet/eyCKs0FZzjVVprbzXm
         kM4g==
X-Gm-Message-State: APjAAAWSZmk+LAAmJdHX+JKp6t8L8FvaG/CVmYZawzvG5QWpTwQP9zMN
        EpFaLBXRRsSU45q8KZ7u+wydRgz8/kNUOduvbplBdg==
X-Google-Smtp-Source: APXvYqxhfVT1Ar0zqE6QmznxS5ydGvjM5q01hBrVqyj5wGZYb4U5kshqfSyhsKoM30Mvts+A8T35IooG7ca8DaDuZ6Y=
X-Received: by 2002:a67:7e12:: with SMTP id z18mr20868818vsc.82.1555413789277;
 Tue, 16 Apr 2019 04:23:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190416102144.12173-1-wqu@suse.com> <20190416102144.12173-2-wqu@suse.com>
In-Reply-To: <20190416102144.12173-2-wqu@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 16 Apr 2019 11:22:58 +0000
Message-ID: <CAL3q7H7h8LJr98RBZeXbH12LFM4VO5SA1N1XVfAEPhEoZPv8dQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs-progs: Avoid nested chunk allocation call
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 16, 2019 at 11:23 AM Qu Wenruo <wqu@suse.com> wrote:
>
> There is a hidden call loop which can trigger itself:
>
> btrfs_reserve_extent()             <--|
> |- do_chunk_alloc()                   |
>    |- btrfs_alloc_chunk()             |
>       |- btrfs_insert_item()          |
>          |- btrfs_reserve_extent() <--|
>
> Currently, we're using root->ref_cows to determine whether we should do
> chunk prealloc to avoid such loop.
>
> But that's still a hidden trap. Instead of solving it using some hidden
> tricks, this patch will make chunk/block group allocation exclusive.
>
> Now if do_chunk_alloc() determines to alloc chunk, it will set a special
> flag in transaction handler so it new do_chunk_alloc() will refuse to
> allocate new chunk until current chunk allocation finishes.

What if the chunk allocated during the recursion is of a different type?
I.e. we're allocating a data chunk, then when inserting the items in the
extent, chunk, device, etc trees, we run out of metadata data space and
need to allocate a metadata chunk. What you are doing skips the allocation
of the metadata chunk and makes the inserts/updates of the trees fail
with ENOSPC.

thanks



>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  check/main.c  |  2 +-
>  extent-tree.c | 12 ++++++++++++
>  transaction.c |  3 ++-
>  transaction.h |  3 ++-
>  4 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/check/main.c b/check/main.c
> index 683c322eba6f..121be4b73c4f 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -10185,7 +10185,7 @@ int cmd_check(int argc, char **argv)
>                         goto close_out;
>                 }
>
> -               trans->reinit_extent_tree =3D true;
> +               trans->reinit_extent_tree =3D 1;
>                 if (init_extent_tree) {
>                         printf("Creating a new extent tree\n");
>                         ret =3D reinit_extent_tree(trans, info,
> diff --git a/extent-tree.c b/extent-tree.c
> index 8c9cdeff3b02..e25ddf02e5cc 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -1873,10 +1873,21 @@ static int do_chunk_alloc(struct btrfs_trans_hand=
le *trans,
>             (flags & BTRFS_BLOCK_GROUP_SYSTEM))
>                 return 0;
>
> +       /*
> +        * We're going to allocate new chunk, during the process, we will
> +        * allocate new tree blocks, which can trigger new chunk allocati=
on
> +        * again.
> +        * Avoid such loop call
> +        */
> +       if (trans->allocating_chunk)
> +               return 0;
> +       trans->allocating_chunk =3D 1;
> +
>         ret =3D btrfs_alloc_chunk(trans, fs_info, &start, &num_bytes,
>                                 space_info->flags);
>         if (ret =3D=3D -ENOSPC) {
>                 space_info->full =3D 1;
> +               trans->allocating_chunk =3D 0;
>                 return 0;
>         }
>
> @@ -1885,6 +1896,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle=
 *trans,
>         ret =3D btrfs_make_block_group(trans, fs_info, 0, space_info->fla=
gs,
>                                      start, num_bytes);
>         BUG_ON(ret);
> +       trans->allocating_chunk =3D 0;
>         return 0;
>  }
>
> diff --git a/transaction.c b/transaction.c
> index 3a63988b0969..21377282f806 100644
> --- a/transaction.c
> +++ b/transaction.c
> @@ -46,7 +46,8 @@ struct btrfs_trans_handle* btrfs_start_transaction(stru=
ct btrfs_root *root,
>         fs_info->generation++;
>         h->transid =3D fs_info->generation;
>         h->blocks_reserved =3D num_blocks;
> -       h->reinit_extent_tree =3D false;
> +       h->reinit_extent_tree =3D 0;
> +       h->allocating_chunk =3D 0;
>         root->last_trans =3D h->transid;
>         root->commit_root =3D root->node;
>         extent_buffer_get(root->node);
> diff --git a/transaction.h b/transaction.h
> index 34060252dd5c..b426cd112447 100644
> --- a/transaction.h
> +++ b/transaction.h
> @@ -28,7 +28,8 @@ struct btrfs_trans_handle {
>         u64 transid;
>         u64 alloc_exclude_start;
>         u64 alloc_exclude_nr;
> -       bool reinit_extent_tree;
> +       unsigned int reinit_extent_tree:1;
> +       unsigned int allocating_chunk:1;
>         u64 delayed_ref_updates;
>         unsigned long blocks_reserved;
>         unsigned long blocks_used;
> --
> 2.21.0
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
