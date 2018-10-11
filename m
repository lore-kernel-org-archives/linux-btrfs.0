Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5CAC677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 20:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C404820644
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 20:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pr8jrn1G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C404820644
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbeJLEEx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 00:04:53 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:36367 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbeJLEEx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 00:04:53 -0400
Received: by mail-vs1-f65.google.com with SMTP id c205so9878879vsd.3
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 13:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=dwIykBiFSNPOCz6JIgn9lRs0ISesB0hDz/nYvxPM3bw=;
        b=pr8jrn1GnA1IvvsCKE7qoNvQVqlbBOdtWVJyhB7xgjqLiwIP7gI+vF3zOyvH5vhYFB
         BWMd4gv9TC03z/jibOp3e+UHU5OS0PGlIBSySC50nMiP6Ugr/VbHZbGgi56i1YN+TEe5
         Ma0tYikxQkj6Hyhc8n6dO2lUDCYxRb/ff3h3xoRdCqPKr80rrZXDnO0+ruYHrFRuKLdH
         19oHeBVlUdoqP9E/eWNd+K0VSYNoAGTFFXbFQ1djO9pw1TPDTmbwEzcFCwtdsctV+gQN
         r9vkdROHEqb5RSOdMnk689lnQcVFHTv/8RNK7wqV2m32SJbee0rFHygSZLBaG5Q7+iyt
         /1UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=dwIykBiFSNPOCz6JIgn9lRs0ISesB0hDz/nYvxPM3bw=;
        b=kqoJfRQu5Tfa4VQtKFt9by9gm4FGxUIKmD5HeJIRAweU/WZxoPKeiSwectrAAhUkkz
         NypjbrH4x8SXgczZwMQvEvrHn5O3eb/iSt/9RqIsNx695lzifu6HWKpDtwyO7p7RVeKd
         LXTZHPaCLZuYhN3dS9XsAFTIxE42RVpCq23MKVLIZklzNrO+csupqgC6ED/lXAbrsUSR
         lgMbIE+s6G3sRLQuiZtED9CKlmm98GkhXVn0KUQ005FyX4p21VXdY0B39O4ibRazo85f
         bg8edWDc73osEFLlltwiw3z0JgP9KUieLQlXm6Iwr3kfKIVl+Ojxs9lR2b2/G+qyk7gR
         /xaw==
X-Gm-Message-State: ABuFfoif+xMoOnyScXbTUTJQeO9xNHeta7yLXXSaTbRXYIAtXeuSvDK+
        z1SFQ8bjvOkNLHLfAiq/J1lMP4WL9ibPfihQ95c=
X-Google-Smtp-Source: ACcGV60BYJcKAEbawrhK9awJRdefStDfdKQ36+463OWNQVM5LmShTDxOqn3+6tZnp6uHm6JjN0Um/xbRhdogrXwfsmw=
X-Received: by 2002:ab0:4812:: with SMTP id b18mr1496536uad.30.1539290158406;
 Thu, 11 Oct 2018 13:35:58 -0700 (PDT)
MIME-Version: 1.0
References: <20181011195431.3441-1-josef@toxicpanda.com> <20181011195431.3441-33-josef@toxicpanda.com>
In-Reply-To: <20181011195431.3441-33-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 11 Oct 2018 21:35:46 +0100
Message-ID: <CAL3q7H6J6mLpr-toJporWoUcAmJ1HXRGOhRujf0dgxPRT3v=dQ@mail.gmail.com>
Subject: Re: [PATCH 32/42] btrfs: only free reserved extent if we didn't
 insert it
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 8:58 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> When we insert the file extent once the ordered extent completes we free
> the reserved extent reservation as it'll have been migrated to the
> bytes_used counter.  However if we error out after this step we'll still
> clear the reserved extent reservation, resulting in a negative
> accounting of the reserved bytes for the block group and space info.
> Fix this by only doing the free if we didn't successfully insert a file
> extent for this extent.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/inode.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 5a91055a13b2..2b257d14bd3d 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2992,6 +2992,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ord=
ered_extent *ordered_extent)
>         bool truncated =3D false;
>         bool range_locked =3D false;
>         bool clear_new_delalloc_bytes =3D false;
> +       bool clear_reserved_extent =3D true;
>
>         if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
>             !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags) &&
> @@ -3095,10 +3096,12 @@ static int btrfs_finish_ordered_io(struct btrfs_o=
rdered_extent *ordered_extent)
>                                                 logical_len, logical_len,
>                                                 compress_type, 0, 0,
>                                                 BTRFS_FILE_EXTENT_REG);
> -               if (!ret)
> +               if (!ret) {
> +                       clear_reserved_extent =3D false;
>                         btrfs_release_delalloc_bytes(fs_info,
>                                                      ordered_extent->star=
t,
>                                                      ordered_extent->disk=
_len);
> +               }
>         }
>         unpin_extent_cache(&BTRFS_I(inode)->extent_tree,
>                            ordered_extent->file_offset, ordered_extent->l=
en,
> @@ -3159,8 +3162,13 @@ static int btrfs_finish_ordered_io(struct btrfs_or=
dered_extent *ordered_extent)
>                  * wrong we need to return the space for this ordered ext=
ent
>                  * back to the allocator.  We only free the extent in the
>                  * truncated case if we didn't write out the extent at al=
l.
> +                *
> +                * If we made it past insert_reserved_file_extent before =
we
> +                * errored out then we don't need to do this as the accou=
nting
> +                * has already been done.
>                  */
>                 if ((ret || !logical_len) &&
> +                   clear_reserved_extent &&
>                     !test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags=
) &&
>                     !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->fl=
ags))
>                         btrfs_free_reserved_extent(fs_info,
> --
> 2.14.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
