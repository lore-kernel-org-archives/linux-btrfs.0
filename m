Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3FAC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 12:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C72A2133D
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 12:34:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U/bpz19A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbfB0MeV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 07:34:21 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:38646 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729963AbfB0MeV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 07:34:21 -0500
Received: by mail-ua1-f66.google.com with SMTP id d4so4025787uap.5
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2019 04:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=YlnCn5qqyzp2KYnkwdVnFNHPwAlf43u/Ne+gAzJTlms=;
        b=U/bpz19Ao8LEw5vzuQpp2b3dUQb3w7KwNLHz0uQYRsln/XKAcExKzvEabBfrWAoWGr
         UhAbkk/v/Q/kQo4r0WjlAQN4OcCeVeoEgG37AN2FMDA/av45GhOAGSlRYAfMs80SxHEL
         UJEFb7rYkFBZpiWimNbkm3CNw3Vjs4Gg+QrF7Pf8Qx7EkLvScb5D56j58yZxwwVNPOAH
         s/vVTqVhgfqu7pln0N4yJX4t1Rl8rxDD2YdD1ZwM1IgKupFn0BsS/sv2wPwVI25eqw2S
         0gvMl2L6iUWcPVqyz6XF29vJ/Hu4Tjli5YBA5rwzL29CFhgAEkbrabnfcDyQOLvbPCJj
         fd3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=YlnCn5qqyzp2KYnkwdVnFNHPwAlf43u/Ne+gAzJTlms=;
        b=pgkKrtt6g9IFn3kxrzGGXv6W84Fd9Ro7YNVcRFFw8vl1BROdAO06Pt431pzJbXgu3n
         P9nHMcHC+bNvWm+Z2pxRCeP8efy/Kl/7PNJIKH1R4qHJDX9KlXuMlacLo9IcIbmgPRkt
         HxUaQgV6Z+MsDXULc87gMMF7o/L6CrCyjtMtvwRAJcqRUJJwAtIqPj9RV9HVhWumefVz
         qoG8pAD/vbTLDuB8sW1ukJNZUoUWi0/DvBth85TtXns1iNT4ZIx2WCEcZpyFLkpKgya0
         W0IRAb9RkAH4TUnDwTaYK1NXsp2VTpEYzt1v8w1pzRymdf1KdB33+tzZ1Tje1hIgZ3E9
         MdYg==
X-Gm-Message-State: AHQUAuZSx+8RkPcTmEQc2NQhgaN77jfg7h3MfyZFfVMjZe5uW5J+aAD9
        dbq+mYndT1pCUA8L3AyVXc6wwO8CwyzCXXn02+SGOA==
X-Google-Smtp-Source: AHgI3IZZ6dCdBkSsBnCugxMoz4AXDop5EYuQ/SMhnrlEipLsRqiqVemZN8b6kBzcHUgwm6rnviN8AeCtLgi8yApgmoY=
X-Received: by 2002:a67:eed3:: with SMTP id o19mr1434297vsp.99.1551270859968;
 Wed, 27 Feb 2019 04:34:19 -0800 (PST)
MIME-Version: 1.0
References: <20190225185544.14516-1-dsterba@suse.com> <20190227121323.20498-1-dsterba@suse.com>
In-Reply-To: <20190227121323.20498-1-dsterba@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 27 Feb 2019 12:34:08 +0000
Message-ID: <CAL3q7H7wk7i-0fgNBLctVuphwdmTAuBMSNXtjeBz084Ry_hF_Q@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: move ulist allocation out of transaction in
 quota enable
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 27, 2019 at 12:12 PM David Sterba <dsterba@suse.com> wrote:
>
> The allocation happens with GFP_KERNEL after a transaction has been
> started, this can potentially cause deadlock if reclaim tries to get the
> memory by flushing filesystem data.
>
> The fs_info::qgroup_ulist is not used during transaction start when
> quotas are not enabled. The status bit BTRFS_FS_QUOTA_ENABLED is set
> later in btrfs_quota_enable so it's safe to move it before the
> transaction start.
>
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good now.

>
> v2:
> - use qgroup_ulist directly, drop the temporary variable
> - update changelog
> ---
>  fs/btrfs/qgroup.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index c1cd5558a646..eb680b715dd6 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -894,6 +894,12 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info=
)
>         if (fs_info->quota_root)
>                 goto out;
>
> +       fs_info->qgroup_ulist =3D ulist_alloc(GFP_KERNEL);
> +       if (!fs_info->qgroup_ulist) {
> +               ret =3D -ENOMEM;
> +               goto out;
> +       }
> +
>         /*
>          * 1 for quota root item
>          * 1 for BTRFS_QGROUP_STATUS item
> @@ -909,13 +915,6 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info=
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
> -
>         /*
>          * initially create the quota tree
>          */
> --
> 2.20.1
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
