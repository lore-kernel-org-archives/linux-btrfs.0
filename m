Return-Path: <SRS0=Nx1q=OJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B03C64EB4
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 17:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E74920834
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 17:15:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kzFwlc1E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E74920834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbeLAEZF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Nov 2018 23:25:05 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:41927 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbeLAEZE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Nov 2018 23:25:04 -0500
Received: by mail-ua1-f65.google.com with SMTP id z24so2131247ual.8
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 09:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=84K0f1Zk03sNd+QuCH14zv/nseRpih8UHODV+5fai2I=;
        b=kzFwlc1EOUM6dIOaNdvgUD82STMaxnSZPwAiK6pHF2V5flg4S3LEkcYC3zTHDVw7kt
         0N81Ne6CrHzZ7qb8UWfcF901v2HiRInM1x31Uq32Vbg0u9XOUCcTsoORAqGgzPZY/Eco
         0VyDkAbq9+Goes9ebkCOc1hRbIuwQ6OoxaGoyUpM6VMS03r2xzEXtOdYvHirgAaBIShz
         cwKTHPqxqapVxneU4RUj6EnHPiMP3PKC4kgqh3ws/UwsoPxSrOtY0Ts50Ki4D2mdFk2V
         vLWjWzztgdwtx/yj+2LbJ7bNlU/5L3o86AFIws35tJGNEY6G9WF6sEGxaXnqerh2mtWv
         XFxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=84K0f1Zk03sNd+QuCH14zv/nseRpih8UHODV+5fai2I=;
        b=sCZ6HGOFPg2IwADW8Aoo8cjWKzDnirrkJ/3qsYStQJmVkPUvMTu8tNdS8+5YDKCZLO
         Dg6WQh3Hg+M3YbjDsbC/NUzuTrdaU905EqiKOrYNckh98nKywhpA0iSHjhc1B9m6NPYS
         yqJoOSMapTTHRKSXQI9Dph6sy7+Cju25n+KtvIn7nGT+Gbq46JFwvCMi1xvfDbSPvlJR
         KmQ9czrcvBrOIe72yIeThjL5+ggwgfhwWfF7z9PJlh9jJMEZaogNH1AhIV2d6gPWarEF
         GpasUORnZK0JjknB787YuyRL3n6P9Fkhcu1ykjqgWDCv9N3RIG4uVetYZqkcfFcpV0HQ
         5lmQ==
X-Gm-Message-State: AA+aEWYdZE/ipQh3Qd+8i/lkmUrdtaHymkoab84N3iJpe+ChdZdo5m4k
        pB4DHapsXHZGn2MJQUqJh9jFg6+QONdFRnefeug=
X-Google-Smtp-Source: AFSGD/VjVcgYOMB4BgC8USLzWysKKPvtePAphm571fS1ECVqmuJqEkmCCUUHND/GKvqkRFKg6lOwYdQGWp+SzZh02Bg=
X-Received: by 2002:ab0:621a:: with SMTP id m26mr2565057uao.36.1543598105184;
 Fri, 30 Nov 2018 09:15:05 -0800 (PST)
MIME-Version: 1.0
References: <20181130165214.17883-1-josef@toxicpanda.com> <20181130165214.17883-2-josef@toxicpanda.com>
In-Reply-To: <20181130165214.17883-2-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 30 Nov 2018 17:14:54 +0000
Message-ID: <CAL3q7H6o=TiqyiQ9Ljy8=4Gc9+-ww-S1ATc-MNq=8k3F_BsLzQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: catch cow on deleting snapshots
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 30, 2018 at 4:53 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> From: Josef Bacik <jbacik@fb.com>
>
> When debugging some weird extent reference bug I suspected that we were
> changing a snapshot while we were deleting it, which could explain my
> bug.  This was indeed what was happening, and this patch helped me
> verify my theory.  It is never correct to modify the snapshot once it's
> being deleted, so mark the root when we are deleting it and make sure we
> complain about it when it happens.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/ctree.c       | 3 +++
>  fs/btrfs/ctree.h       | 1 +
>  fs/btrfs/extent-tree.c | 9 +++++++++
>  3 files changed, 13 insertions(+)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 5912a97b07a6..5f82f86085e8 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1440,6 +1440,9 @@ noinline int btrfs_cow_block(struct btrfs_trans_han=
dle *trans,
>         u64 search_start;
>         int ret;
>
> +       if (test_bit(BTRFS_ROOT_DELETING, &root->state))
> +               WARN(1, KERN_CRIT "cow'ing blocks on a fs root thats bein=
g dropped\n");

Please use btrfs_warn(), it makes sure we use a consistent message
style, identifies the fs, etc.
Also, "thats" should be "that is" or "that's".

With that fixed,
Reviewed-by: Filipe Manana <fdmanana@suse.com>

> +
>         if (trans->transaction !=3D fs_info->running_transaction)
>                 WARN(1, KERN_CRIT "trans %llu running %llu\n",
>                        trans->transid,
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index facde70c15ed..5a3a94ccb65c 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1199,6 +1199,7 @@ enum {
>         BTRFS_ROOT_FORCE_COW,
>         BTRFS_ROOT_MULTI_LOG_TASKS,
>         BTRFS_ROOT_DIRTY,
> +       BTRFS_ROOT_DELETING,
>  };
>
>  /*
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 581c2a0b2945..dcb699dd57f3 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9333,6 +9333,15 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>         if (block_rsv)
>                 trans->block_rsv =3D block_rsv;
>
> +       /*
> +        * This will help us catch people modifying the fs tree while we'=
re
> +        * dropping it.  It is unsafe to mess with the fs tree while it's=
 being
> +        * dropped as we unlock the root node and parent nodes as we walk=
 down
> +        * the tree, assuming nothing will change.  If something does cha=
nge
> +        * then we'll have stale information and drop references to block=
s we've
> +        * already dropped.
> +        */
> +       set_bit(BTRFS_ROOT_DELETING, &root->state);
>         if (btrfs_disk_key_objectid(&root_item->drop_progress) =3D=3D 0) =
{
>                 level =3D btrfs_header_level(root->node);
>                 path->nodes[level] =3D btrfs_lock_root_node(root);
> --
> 2.14.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
