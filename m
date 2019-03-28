Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECC6C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 22:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A00442075E
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 22:53:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jyo96hc4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbfC1WxG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 18:53:06 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:45857 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727648AbfC1WxG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 18:53:06 -0400
Received: by mail-ua1-f67.google.com with SMTP id c13so45499uao.12
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2019 15:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=eROEQ2NIyLqFGBObjtP0arxgf877J7jGOsfE2qIwO54=;
        b=jyo96hc4kPwDxGRihtvv0MPv/mQnvROhejrwR3a7ONAv0OHQMJkEHSWUyy4Xf8cnaR
         Yb1oIdkU3BW4ssz1Y76h5Dro7/h+LZ9VqIybQMj8qxSYwWtS+jlT6cyGjzZB2EMqbMYh
         hE9aIpRwjcrm3YXUZSJFQejnsGwC4WFWpMJwhLSHoLksie3cMRWbLcf2sD4OKUqYgipo
         L6T38qr30KEAoOyiMTRnImpxoZVn+R8/2kv9cMsEX1LfqNEy9ykKU0z09Zn+fFGPodcL
         F70GW93Gyf3RMHQuDpr8iFAdo1EEK9LHsnY/zEIaTGUlsDomFp34tb8ymBSgEdMAbaqn
         nSPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=eROEQ2NIyLqFGBObjtP0arxgf877J7jGOsfE2qIwO54=;
        b=HL6W8fz/tifwyZGY5juncF4WHxAIOYCQzXCxKq1vsDl783BdDf2V731a5iphcaGIC9
         dkC3p78gczYu2OU9g0GV7BUPomm6DCA4cC4OAdAzyXXGBA+T/HpwRAkInWUFXE4I3uIO
         gTorYzwrE/Vun8yxgkja3USNjA496D65GgMrDPkEngt7UMUsqgfS1EeB4DoCBiskShB/
         1GC/b3cYWB8Qv3L5x+FlGx70ybuE3myVfnPq2EayffXm3U5nOM8qUC5GrA9BQ/pqyhqD
         XwB+CzqGNGCZMF6wpz1+YOB4CGGn2dzPqXV1g1EdYYWVqwYWDiy8Kb7iD96JW4wkntRX
         nJyQ==
X-Gm-Message-State: APjAAAUWKQcxLLMQzBcXmiy33M40077rg66VIgHOXkt6lBR1hwqetG9y
        48ecEVDfIGUbcaumKWC48bWqiHWxtRj5V77GxTnjJCbw
X-Google-Smtp-Source: APXvYqw3dwEUnL48idpMAfOjRCrnGqLzT79m0eyIJsuY0p2wuH/Z6AFjzapvEsOIjMY66zjnAWvV9EGW3esWikbaLn4=
X-Received: by 2002:ab0:156b:: with SMTP id p40mr1280794uae.83.1553813584643;
 Thu, 28 Mar 2019 15:53:04 -0700 (PDT)
MIME-Version: 1.0
References: <1553766036-20689-1-git-send-email-robbieko@synology.com>
In-Reply-To: <1553766036-20689-1-git-send-email-robbieko@synology.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 28 Mar 2019 22:52:53 +0000
Message-ID: <CAL3q7H7SOQt-9BVU+0YxoHXNkb7qiY4tN13gogayEH_8GNSK5A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: send, improve clone range
To:     robbieko <robbieko@synology.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 28, 2019 at 9:41 AM robbieko <robbieko@synology.com> wrote:
>
> From: Robbie Ko <robbieko@synology.com>
>
> Improve clone_range two use scenarios.
>
> 1. Remove the limit of clone inode size
> We can do partial clone range, so there is no need to limit
> the inode size.

There is.
Cloning from a source range that goes beyond the source's i_size
results in an -EINVAL error returned from the clone ioctl.

Try running fstests btrfs/007, with a seed value of 1553175244 and
2000 operations instead of 200:

# /home/fdmanana/git/hub/btrfs-progs/btrfs receive
/home/fdmanana/btrfs-tests/scratch_1
ERROR: failed to clone extents to p0/df/d10/f2c: Invalid argument
At snapshot incr
failed: '/home/fdmanana/git/hub/btrfs-progs/btrfs receive
/home/fdmanana/btrfs-tests/scratch_1'


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
> ---
>  fs/btrfs/send.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 7ea2d6b..7766b12 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -1240,9 +1240,6 @@ static int __iterate_backrefs(u64 ino, u64 offset, =
u64 root, void *ctx_)
>         if (ret < 0)
>                 return ret;
>
> -       if (offset + bctx->data_offset + bctx->extent_len > i_size)
> -               return 0;

And this is why the failure above happens.

> -
>         /*
>          * Make sure we don't consider clones from send_root that are
>          * behind the current inode/offset.
> @@ -5148,6 +5145,7 @@ static int clone_range(struct send_ctx *sctx,
>                 u8 type;
>                 u64 ext_len;
>                 u64 clone_len;
> +               u64 clone_data_offset;

  CC [M]  fs/btrfs/send.o
fs/btrfs/send.c: In function 'process_extent':
fs/btrfs/send.c:5218:60: warning: 'clone_data_offset' may be used
uninitialized in this function [-Wmaybe-uninitialized]
   if (btrfs_file_extent_disk_bytenr(leaf, ei) =3D=3D disk_byte &&
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~
       clone_data_offset =3D=3D data_offset)
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fs/btrfs/send.c:5148:7: note: 'clone_data_offset' was declared here
   u64 clone_data_offset;
       ^~~~~~~~~~~~~~~~~
  LD [M]  fs/btrfs/btrfs.o

$ gcc --version
gcc --version
gcc (Debian 6.3.0-18+deb9u1) 6.3.0 20170516
Copyright (C) 2016 Free Software Foundation, Inc.

Harmless but we shouldn't have warnings, initialize it to something
impossible (u64(-1) / U64_MAX) or re-structure the change below.

>
>                 if (slot >=3D btrfs_header_nritems(leaf)) {
>                         ret =3D btrfs_next_leaf(clone_root->root, path);
> @@ -5201,10 +5199,24 @@ static int clone_range(struct send_ctx *sctx,
>                 if (key.offset >=3D clone_root->offset + len)
>                         break;
>
> +               if (btrfs_file_extent_disk_bytenr(leaf, ei) =3D=3D disk_b=
yte) {
> +                       clone_root->offset =3D key.offset;
> +                       clone_data_offset =3D btrfs_file_extent_offset(le=
af, ei);
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
