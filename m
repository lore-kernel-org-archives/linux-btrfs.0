Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3143C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 19:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8A042084D
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 19:09:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XcKdmYUC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfBYTJP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 14:09:15 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:45645 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbfBYTJP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 14:09:15 -0500
Received: by mail-ua1-f68.google.com with SMTP id u1so8705745uae.12
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 11:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=aHKEoD+sDU2NtWwKllshD99vb1/Zzw/t+l/SEZqVO4E=;
        b=XcKdmYUCjKc40EXZY5LySHL4Igt5oNtT7vsOqF1tTru8jyJ4aMANe91sY/kf9qFzGA
         oKXBrJvKcRfxZi7rkGKHjAosZyBX3kH29aRGwJXXthRUOJosw2KYJR2WoezKLtnybBfv
         IododOoODR9vsau6Kty9rbpdXEQ5Krtm1BUrEutqOs3S1p51RM+2mbaAFaLgREaL+ncF
         zVtZwY8oBzZYRrR9QFz9auVNbmELlIbERLM50AKeUA+pe1l6rsaoduuRwssQ7ysIV8dO
         f5Wt8K445OvzquUBUQySF7ogXidSpq0adljnhi2FT3928JcMgCwBvH2RbhEPcs+ssRNB
         S5Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=aHKEoD+sDU2NtWwKllshD99vb1/Zzw/t+l/SEZqVO4E=;
        b=iVxwxkwTDHnvXveJiv4WQiak1+leD4W69rH5D0p5AO9nHrStdGAzzgsFitv5RjMDFu
         9WDoJLKrHr9MkSglvvFEx/4+H66saVC5uaem0qHVsz6ySYGDA12EfW8GHCTRfaYWxJdO
         W20Z0NhaJGbDVfj6pEkcFQp+RhLxBw6emF4sjAWooHhNMWf3vf5q92TZUTpyXKD6yOVF
         i/v0ijLlXmn4By3T8fjG4xrepIUl8yeVLkYpGVE23ul9A65FCOrx2WpQ/0EFZb7t6s7D
         xjb8CTP+RDlEijQm8gNfudAC6G1vqC89KIvgQ4dU1YLvif2xwc03Aaq2OSE7govOduFq
         Q8jw==
X-Gm-Message-State: AHQUAuZvHIvgmDq9CBuAABgAfiv6FCaQfFC77veOONZl0rlKfTbne8wi
        Me4ScOfjXkyB1+cPnVL1QVgpH6iSddQ+oC6CCJEg2A==
X-Google-Smtp-Source: AHgI3IZ+q9vNMOve4d532UjmxMztqUSCtAhPZnpR8SgXKBH96gfDPRd7YNrZvcBa/LfxEKw0U5vz6ercymqHffi9vZk=
X-Received: by 2002:a67:bc0e:: with SMTP id t14mr9472856vsn.206.1551121753898;
 Mon, 25 Feb 2019 11:09:13 -0800 (PST)
MIME-Version: 1.0
References: <20190225185544.14516-1-dsterba@suse.com>
In-Reply-To: <20190225185544.14516-1-dsterba@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 25 Feb 2019 19:09:02 +0000
Message-ID: <CAL3q7H7L=183ndntoQLuUkPpmWgN1gmhS=vhiA23moP1Y7=0fQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: move ulist allocation out of transaction in quota enable
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 25, 2019 at 6:58 PM David Sterba <dsterba@suse.com> wrote:
>
> The allocation happens with GFP_KERNEL after a transaction has been
> started, this can potentially cause deadlock if reclaim tries to get the
> memory by flushing filesystem data.
>
> The qgroup_ulist is not used during transaction start as the quotas are
> not yet enabled but to provide the same semantics, use a temporary
> variable and assign fs_info::qgroup_ulist as before.
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/qgroup.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index c1cd5558a646..9e49d5e132b8 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -887,6 +887,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
>         struct btrfs_key found_key;
>         struct btrfs_qgroup *qgroup =3D NULL;
>         struct btrfs_trans_handle *trans =3D NULL;
> +       struct ulist *tmp_ulist;
>         int ret =3D 0;
>         int slot;
>
> @@ -894,6 +895,12 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info=
)
>         if (fs_info->quota_root)
>                 goto out;
>
> +       tmp_ulist =3D ulist_alloc(GFP_KERNEL);
> +       if (!tmp_ulist) {
> +               ret =3D -ENOMEM;
> +               goto out;
> +       }

tmp_ulist needs to be freed if starting the transaction below fails.

Other then that, looks good.

> +
>         /*
>          * 1 for quota root item
>          * 1 for BTRFS_QGROUP_STATUS item
> @@ -909,12 +916,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info=
)
>                 goto out;
>         }
>
> -       fs_info->qgroup_ulist =3D ulist_alloc(GFP_KERNEL);
> -       if (!fs_info->qgroup_ulist) {
> -               ret =3D -ENOMEM;
> -               btrfs_abort_transaction(trans, ret);
> -               goto out;
> -       }
> +       fs_info->qgroup_ulist =3D tmp_ulist;
>
>         /*
>          * initially create the quota tree
> --
> 2.20.1
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
