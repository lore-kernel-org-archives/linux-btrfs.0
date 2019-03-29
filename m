Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3014EC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 19:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD8B12184D
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 19:35:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y22G0GYM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbfC2Tf0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 15:35:26 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:39851 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729380AbfC2Tf0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 15:35:26 -0400
Received: by mail-vk1-f196.google.com with SMTP id s80so767160vke.6
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 12:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=/l23e7tvJu5rAFnftKkLfH0Xmr5kd4E9+g+A3M1VKB8=;
        b=Y22G0GYMk6sSbSiK2i9TpL2BnY8HqcGXH/TzYXw/B1/mizhACe+vsX2shaDcjyhzj9
         lbWBScY7gWdrDqFcdwxBdE1OMajhTf6qXHxU3zAjolFFrxra+mFXOtToCr20hsnjBcdZ
         YZ0wOyzWfl3Fin//FiBcMLld5bedgRmlt8nMpqKyjze3wv1srWNaX0JB9HtE5EOKJ1jo
         uWPYe8GmRTPeAjOzeu4D24iyqr/QFCUOA40fkbk2MghLZ/kxe0itvSuWVbD2PhHIA1Ma
         XGI+VhtEOLiN1nBUQFyWnOgWt7zQAj9hn4Axuz+7zWkb3dmvgukkbPH6mUsUy1ajZle+
         SqyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=/l23e7tvJu5rAFnftKkLfH0Xmr5kd4E9+g+A3M1VKB8=;
        b=I516Ri726gjeILKd+RA+S5rOFdslYfkQgFQ8D8w4XUvynYHuDvNKPyPq1MfwYqdymj
         Fc9x7i2o3l5a7s+RXqMRGxLyfKPN4RVBvJTV6Y7ShPKgiNpBOsZEcEWMqL000EHJaD0H
         K8dBXS5AWbBhVJjWWrKUOBa4+KD7/B108mA3xHsC/YS8aK/6mCXbfUkKZVfgREx0Miny
         Iq8HSa6JjZR1w5d9Nb9wZR0aiSjnJGLiyWbrfDOTAgQHYbqsB/Fj+gABI52ZIAUln3PN
         de9jMryP04cooEs7jFDiMGRsRP8oYcEH8H8BuKZgGMXhsuuU7/ekdF02iEsAnC6Mq+R6
         L+BQ==
X-Gm-Message-State: APjAAAVQJ3zbXYc+qbQst/zyF1/NIFWiQb82R3OaiJdG1jy5EaK0GRU4
        xD5wSr7y9NYwXECLWUy2FnA7cwf7isyegUtlMqsvYA==
X-Google-Smtp-Source: APXvYqytfU16qBW4gxfgrBppS/kEM9d47JNAuNuulMxtHxLdrsvWxJ5Aprg87s+qrC6H1xw1enRRbjgNimZ/IdzshG4=
X-Received: by 2002:ac5:c24b:: with SMTP id n11mr19451002vkk.81.1553888125006;
 Fri, 29 Mar 2019 12:35:25 -0700 (PDT)
MIME-Version: 1.0
References: <1553853807-25293-1-git-send-email-robbieko@synology.com>
In-Reply-To: <1553853807-25293-1-git-send-email-robbieko@synology.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 29 Mar 2019 19:35:14 +0000
Message-ID: <CAL3q7H5307o05_dozQDEkgWhUKYr4_zTdUvYBNgxXBHjyCjExQ@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: send, improve clone range
To:     robbieko <robbieko@synology.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 29, 2019 at 10:04 AM robbieko <robbieko@synology.com> wrote:
>
> From: Robbie Ko <robbieko@synology.com>
>
> Improve clone_range two use scenarios.
>
> 1. Remove the limit of inode size when find clone inodes
> We can do partial clone, so there is no need to limit the
> size of the candidate inode.
> When clone a range, we clone the legal range only by bytenr,
> offset, len, inode size.
>
> 2. In the scenarios of rewrite or clone_range, data_offset
> rarely matches exactly, so the chance of a clone is missed.
>
> e.g.
>     1. Write a 1M file
>         dd if=3D/dev/zero of=3D1M bs=3D1M count=3D1
>
>     2. Clone 1M file
>        cp --reflink 1M clone
>
>     3. Rewrite 4k on the clone file
>        dd if=3D/dev/zero of=3Dclone bs=3D4k count=3D1 conv=3Dnotrunc
>
>     The disk layout is as follows:
>     item 16 key (257 EXTENT_DATA 0) itemoff 15353 itemsize 53
>         extent data disk byte 1103101952 nr 1048576
>         extent data offset 0 nr 1048576 ram 1048576
>         extent compression(none)
>     ...
>     item 22 key (258 EXTENT_DATA 0) itemoff 14959 itemsize 53
>         extent data disk byte 1104150528 nr 4096
>         extent data offset 0 nr 4096 ram 4096
>         extent compression(none)
>     item 23 key (258 EXTENT_DATA 4096) itemoff 14906 itemsize 53
>         extent data disk byte 1103101952 nr 1048576
>         extent data offset 4096 nr 1044480 ram 1048576
>         extent compression(none)
>
> When send, inode 258 file offset 4096~1048576 (item 23) has a
> chance to clone_range, but because data_offset does not match
> inode 257 (item 16), it causes missed clone and can only transfer
> actual data.
>
> Improve the problem by judging whether the current data_offset
> has overlap with the file extent item, and if so, adjusting
> offset and extent_len so that we can clone correctly.
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Now it looks good. Thanks.

> ---
> V2:
> * fix clone error when offset > isize
> * fix uninitialized warning
> * remove unused variable backref_ctx->path
>
>  fs/btrfs/send.c | 52 +++++++++++++++++++++++++++++++++------------------=
-
>  1 file changed, 33 insertions(+), 19 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 7ea2d6b..1e9caa5 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -1160,7 +1160,6 @@ static int get_inode_path(struct btrfs_root *root,
>  struct backref_ctx {
>         struct send_ctx *sctx;
>
> -       struct btrfs_path *path;
>         /* number of total found references */
>         u64 found;
>
> @@ -1213,8 +1212,6 @@ static int __iterate_backrefs(u64 ino, u64 offset, =
u64 root, void *ctx_)
>  {
>         struct backref_ctx *bctx =3D ctx_;
>         struct clone_root *found;
> -       int ret;
> -       u64 i_size;
>
>         /* First check if the root is in the list of accepted clone sourc=
es */
>         found =3D bsearch((void *)(uintptr_t)root, bctx->sctx->clone_root=
s,
> @@ -1231,19 +1228,6 @@ static int __iterate_backrefs(u64 ino, u64 offset,=
 u64 root, void *ctx_)
>         }
>
>         /*
> -        * There are inodes that have extents that lie behind its i_size.=
 Don't
> -        * accept clones from these extents.
> -        */
> -       ret =3D __get_inode_info(found->root, bctx->path, ino, &i_size, N=
ULL, NULL,
> -                              NULL, NULL, NULL);
> -       btrfs_release_path(bctx->path);
> -       if (ret < 0)
> -               return ret;
> -
> -       if (offset + bctx->data_offset + bctx->extent_len > i_size)
> -               return 0;
> -
> -       /*
>          * Make sure we don't consider clones from send_root that are
>          * behind the current inode/offset.
>          */
> @@ -1319,8 +1303,6 @@ static int find_extent_clone(struct send_ctx *sctx,
>                 goto out;
>         }
>
> -       backref_ctx->path =3D tmp_path;
> -
>         if (data_offset >=3D ino_size) {
>                 /*
>                  * There may be extents that lie behind the file's size.
> @@ -5082,6 +5064,7 @@ static int clone_range(struct send_ctx *sctx,
>         struct btrfs_path *path;
>         struct btrfs_key key;
>         int ret;
> +       u64 clone_src_i_size;
>
>         /*
>          * Prevent cloning from a zero offset with a length matching the =
sector
> @@ -5107,6 +5090,16 @@ static int clone_range(struct send_ctx *sctx,
>                 return -ENOMEM;
>
>         /*
> +        * There are inodes that have extents that lie behind its i_size.=
 Don't
> +        * accept clones from these extents.
> +        */
> +       ret =3D __get_inode_info(clone_root->root, path, clone_root->ino,
> +                              &clone_src_i_size, NULL, NULL, NULL, NULL,=
 NULL);
> +       btrfs_release_path(path);
> +       if (ret < 0)
> +               goto out;
> +
> +       /*
>          * We can't send a clone operation for the entire range if we fin=
d
>          * extent items in the respective range in the source file that
>          * refer to different extents or if we find holes.
> @@ -5148,6 +5141,7 @@ static int clone_range(struct send_ctx *sctx,
>                 u8 type;
>                 u64 ext_len;
>                 u64 clone_len;
> +               u64 clone_data_offset;
>
>                 if (slot >=3D btrfs_header_nritems(leaf)) {
>                         ret =3D btrfs_next_leaf(clone_root->root, path);
> @@ -5201,10 +5195,30 @@ static int clone_range(struct send_ctx *sctx,
>                 if (key.offset >=3D clone_root->offset + len)
>                         break;
>
> +               if (key.offset >=3D clone_src_i_size)
> +                       break;
> +
> +               if (key.offset + ext_len > clone_src_i_size)
> +                       ext_len =3D clone_src_i_size - key.offset;
> +
> +               clone_data_offset =3D btrfs_file_extent_offset(leaf, ei);
> +               if (btrfs_file_extent_disk_bytenr(leaf, ei) =3D=3D disk_b=
yte) {
> +                       clone_root->offset =3D key.offset;
> +                       if (clone_data_offset < data_offset &&
> +                               clone_data_offset + ext_len > data_offset=
) {
> +                               u64 extent_offset;
> +
> +                               extent_offset =3D data_offset - clone_dat=
a_offset;
> +                               ext_len -=3D extent_offset;
> +                               clone_data_offset +=3D extent_offset;
> +                               clone_root->offset +=3D extent_offset;
> +                       }
> +               }
> +
>                 clone_len =3D min_t(u64, ext_len, len);
>
>                 if (btrfs_file_extent_disk_bytenr(leaf, ei) =3D=3D disk_b=
yte &&
> -                   btrfs_file_extent_offset(leaf, ei) =3D=3D data_offset=
)
> +                   clone_data_offset =3D=3D data_offset)
>                         ret =3D send_clone(sctx, offset, clone_len, clone=
_root);
>                 else
>                         ret =3D send_extent_data(sctx, offset, clone_len)=
;
> --
> 1.9.1
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
