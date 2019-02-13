Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11BA0C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 12:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D68DE222B5
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 12:39:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c4GXaULY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730888AbfBMMjN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 07:39:13 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:34935 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfBMMjM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 07:39:12 -0500
Received: by mail-ua1-f66.google.com with SMTP id d2so720829ual.2
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2019 04:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=jcnwiOaP8MQBOT0bPikppREoDyQmx8MP4q72NY5qBKo=;
        b=c4GXaULYsyMIbsaAIPA7uc7f4uFNFO7eQHfA52XQFvqtVS/0nbe6yFGrhiQXOk+ExA
         mKgcggRaE0ccx5vXGbvIoWfRC9uA4xiIT9ZhLSYAsYsjfhl6UwbXI3ShR6JPNniVVFEj
         xiaIgmzb0zbhHpMkIxQYqXOuPD07abFlUSYKFbFU2HPuofE+DFmP80FSOWlzV6vPCNFc
         vRHs79aQmEV21eq/dwbZnoPhE7ROIi1v7uzkMSX3RJ/ni+ejnt2VeEixuYl0RT5iswnZ
         zCQf7Pj4fcLKLVkIFXWQXO5F54q2OLbQu9w3xA0XF6RLBFn/cm4taxWm4mdjyb7phsBa
         /FCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=jcnwiOaP8MQBOT0bPikppREoDyQmx8MP4q72NY5qBKo=;
        b=KJFgwUwEfiiHyzrmH6sc7/i3VAnJewrDK9dQzKKP8aoW6BVxzSZI4/nsE9R682F7Mq
         Pj4kpTT+J+xdAsllwLzRGnt90ctA3Ci5nZO32j2UNn5Jn6nSailjhCMAPoOBFrPcagiD
         70WEOpK+IvmYOuxECMaGRB5fGEjnlNXPHWk3h8PO1nPx8odQRAo8ULWM+fk99fhLV4dW
         Am2D4xmI4twC3xLW0WyVRRpOY7fpw0jF35ng2wmR1YofKLxl92nsL+EPL1sba1JSjkw9
         xMNNWRezb9DAqy+WeAL5uEZIGZDnkoQcvlJVs2Ktp4AGryDHl36mphErRCYykw/Ieyc5
         B4ow==
X-Gm-Message-State: AHQUAuaOHcLbg5/F6H84bDqQHoF+1H/6V9tmpEM9ONJMvzqVUFnE12RY
        7zyGLCrZ2qDBN7cEzLZZiU/UNf0tSa/10qPsF+Rf1/hz
X-Google-Smtp-Source: AHgI3IbZ61HKS5ygWCbPTMc+stWhwCUrGnloWlmxIQIOYio55OoFmmjxIg1fbVjiuC78sefmMeNMSlLp2d0g2A7Bo80=
X-Received: by 2002:ab0:3384:: with SMTP id y4mr119328uap.30.1550061551029;
 Wed, 13 Feb 2019 04:39:11 -0800 (PST)
MIME-Version: 1.0
References: <20190207165426.15866-1-josef@toxicpanda.com> <20190207165426.15866-3-josef@toxicpanda.com>
In-Reply-To: <20190207165426.15866-3-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 13 Feb 2019 12:38:59 +0000
Message-ID: <CAL3q7H458ZzjK0RPrHtsURL3RkjzmPQqg1jwHvc6=oPZjMJzWA@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: use the existing credit for our first prop
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 7, 2019 at 4:57 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> We're now reserving an extra items worth of space for property
> inheritance.  We only have one property at the moment so this covers us,
> but if we add more in the future this will allow us to not get bitten by
> the extra space reservation.  If we do add more properties in the future
> we should re-visit how we calculate the space reservation needs by the
> callers.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
>  fs/btrfs/props.c | 32 ++++++++++++++++++++++++--------
>  1 file changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
> index dc6140013ae8..b3d22fef8c92 100644
> --- a/fs/btrfs/props.c
> +++ b/fs/btrfs/props.c
> @@ -291,6 +291,7 @@ static int inherit_props(struct btrfs_trans_handle *t=
rans,
>         struct btrfs_fs_info *fs_info =3D root->fs_info;
>         int ret;
>         int i;
> +       bool need_reserve =3D false;
>
>         if (!test_bit(BTRFS_INODE_HAS_PROPS,
>                       &BTRFS_I(parent)->runtime_flags))
> @@ -308,16 +309,31 @@ static int inherit_props(struct btrfs_trans_handle =
*trans,
>                 if (!value)
>                         continue;
>
> -               num_bytes =3D btrfs_calc_trans_metadata_size(fs_info, 1);
> -               ret =3D btrfs_block_rsv_add(root, trans->block_rsv,
> -                                         num_bytes, BTRFS_RESERVE_NO_FLU=
SH);
> -               if (ret)
> -                       goto out;
> +               /*
> +                * Currently callers should be reserving 1 credit for
> +                * properties, since we only have 1 property that we curr=
ently
> +                * support.  If we add more in the future we need to try =
and
> +                * reserve more space for them.  But we should also revis=
it how
> +                * we do space reservations if we do add more properties =
in the
> +                * future.
> +                */
> +               if (need_reserve) {
> +                       num_bytes =3D btrfs_calc_trans_metadata_size(fs_i=
nfo, 1);
> +                       ret =3D btrfs_block_rsv_add(root, trans->block_rs=
v,
> +                                                 num_bytes,
> +                                                 BTRFS_RESERVE_NO_FLUSH)=
;
> +                       if (ret)
> +                               goto out;
> +               }
>                 ret =3D __btrfs_set_prop(trans, inode, h->xattr_name,
>                                        value, strlen(value), 0);
> -               btrfs_block_rsv_release(fs_info, trans->block_rsv, num_by=
tes);
> -               if (ret)
> -                       goto out;
> +               if (need_reserve) {
> +                       btrfs_block_rsv_release(fs_info, trans->block_rsv=
,
> +                                               num_bytes);
> +                       if (ret)
> +                               goto out;
> +               }
> +               need_reserve =3D true;
>         }
>         ret =3D 0;
>  out:
> --
> 2.14.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
