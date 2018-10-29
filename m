Return-Path: <SRS0=e2uI=NJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 093F9C2BC61
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 09:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6AA920825
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 09:52:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GKaX0SPc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6AA920825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbeJ2Sko (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 29 Oct 2018 14:40:44 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:45019 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729528AbeJ2Sko (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Oct 2018 14:40:44 -0400
Received: by mail-vs1-f65.google.com with SMTP id w194so4798032vsc.11
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Oct 2018 02:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=S7u9j9uwBriXn5nfF5MaKOgn09W20wLjEURcb4HpzOc=;
        b=GKaX0SPcIiEbZNhcQJCfKEkQO/fTyQ9ztXXdejnSQuOtcGWt/1yc2G6eXGLswjO0Z+
         4ynndf/2vOR+sLUs5lE44ZuAMIoXnrsO8H9wTaVlZMfkExTVXesl7bPb8W7MNyGXCrnR
         01NQLpdNC8bkgZCU4yWdstgcZE+SUsTqfcaoA7ZsuB7pGlFSfcf0SLqnDutqdbeIN54b
         AshP4b6HGwA+0fBhJXP+jVyAnM6OAynO/ioVjzTeU97b0VZUbkuijiF8gP2tNox34Yzo
         Ru7Dnr6QffSrO9rLh1IWP1OQw5s8iu9bta7J0ah13mqOfzeS5CU8/dVz5INv1eC6ualx
         7pnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=S7u9j9uwBriXn5nfF5MaKOgn09W20wLjEURcb4HpzOc=;
        b=DGGpBsFXiC+oOvtkPeinGIjh8CB/bIxuqBdPhZUxtG0z/iAvGO1gOZLXUGtTJVoqHc
         a65JOOXrgoXzjzgVlXpO9mNlVb5TvEjNbcz/7JZi3azGql9I0r2Grx5usUrRu09vwhS8
         i2/oiRqMHwkUQZX9bYWHEPqw8UrmFZwyNJpKPEXYJgVMTOhvrYV7jd4VmpWK0ExH7ZAN
         GT737V7NGn4Ph/eoNdC+2WhHFLA4hAeJ8gLGOfuk4nN0d4RcH0eLRJh/qfN5HWxaGVPb
         5pFN/gUbHdNFgCgwKaYiiO53XWvcu3/5P/h+Rmfc/kNCjdauSFojoxUjHtJTqmlQt4DX
         tMuw==
X-Gm-Message-State: AGRZ1gLdhDkRLb5/mjAaXmWSC8k5gIGQGpcvnIn849EqbwFanRzb9k76
        bLVSNsXmXNvlPyrpOmAXVCHFIdzawqigs0f2jPo=
X-Google-Smtp-Source: AJdET5ftWuKjuALfLH22KdMXaULTa7I/s3QOxDW6eqmX6gcw8qhNO/KrSKCaQ7Hsq5ozthevuAC/jwxrr0IPvHcA+WM=
X-Received: by 2002:a67:4c51:: with SMTP id z78mr4663173vsa.99.1540806767840;
 Mon, 29 Oct 2018 02:52:47 -0700 (PDT)
MIME-Version: 1.0
References: <20181029063053.21130-1-wqu@suse.com>
In-Reply-To: <20181029063053.21130-1-wqu@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 29 Oct 2018 09:52:36 +0000
Message-ID: <CAL3q7H4tGLCpFUm-GR7cGng66zu3A342O7eM6jbfFsqx1-Zw=Q@mail.gmail.com>
Subject: Re: [PATCH] fstests: btrfs/057: Fix false alerts due to orphan files
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 29, 2018 at 6:31 AM Qu Wenruo <wqu@suse.com> wrote:
>
> For latest kernel, there is a chance that btrfs/057 reports false
> errors.

By latest kernel you mean 4.20?

>
> The false error would look like:
>   btrfs/057 4s ... - output mismatch (see /home/adam/xfstests-dev/results=
//btrfs/057.out.bad)
>       --- tests/btrfs/057.out   2017-08-21 09:25:33.166666666 +0800
>       +++ /home/adam/xfstests-dev/results//btrfs/057.out.bad    2018-10-2=
9 14:07:28.443651293 +0800
>       @@ -1,3 +1,3 @@
>        QA output created by 057
>        4096 4096
>       -4096 4096
>       +28672 28672
>
> This is related to the fact that "btrfs subvolume sync" (or
> vanilla sync) will not ensure orphan (unlinked but still exist) files to
> be removed.

So when did that happen, which commit introduced the behaviour change?

>
> In fact, for that false error case, if inspecting the fs after umount,
> its qgroup number is correct and btrfs check won't report qgroup error.
>
> To fix the false alerts, just skip any manual qgroup number comparison,
> and let fsck done after the test case to detect problem.
>
> This also elimiate the necessary of using specified mount and mkfs
> option, allowing us to improve coverage.
>
> Reported-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  tests/btrfs/057     | 17 ++++-------------
>  tests/btrfs/057.out |  3 +--
>  2 files changed, 5 insertions(+), 15 deletions(-)
>
> diff --git a/tests/btrfs/057 b/tests/btrfs/057
> index b019f4e1..0b5a36d3 100755
> --- a/tests/btrfs/057
> +++ b/tests/btrfs/057
> @@ -33,12 +33,9 @@ _require_scratch
>  rm -f $seqres.full
>
>  # use small leaf size to get higher btree height.
> -run_check _scratch_mkfs "-b 1g --nodesize 4096"
> +run_check _scratch_mkfs "-b 1g"
>
> -# inode cache is saved in the FS tree itself for every
> -# individual FS tree,that affects the sizes reported by qgroup show
> -# so we need to explicitly turn it off to get consistent values.
> -_scratch_mount "-o noinode_cache"
> +_scratch_mount
>
>  # -w ensures that the only ops are ones which cause write I/O
>  run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p 5 -n 1000 \
> @@ -53,14 +50,8 @@ run_check $FSSTRESS_PROG -d $SCRATCH_MNT/snap1 -w -p 5=
 -n 1000 \
>  _run_btrfs_util_prog quota enable $SCRATCH_MNT
>  _run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
>
> -# remove all file/dir other than subvolume
> -rm -rf $SCRATCH_MNT/snap1/* >& /dev/null
> -rm -rf $SCRATCH_MNT/p* >& /dev/null
> -
> -_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
> -units=3D`_btrfs_qgroup_units`
> -$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $SED_PROG -n '/[0-9]/=
p' \
> -       | $AWK_PROG '{print $2" "$3}'
> +echo "Silence is golden"
> +# btrfs check will detect any qgroup number mismatch.
>
>  status=3D0
>  exit
> diff --git a/tests/btrfs/057.out b/tests/btrfs/057.out
> index 60cb92d0..185023c7 100644
> --- a/tests/btrfs/057.out
> +++ b/tests/btrfs/057.out
> @@ -1,3 +1,2 @@
>  QA output created by 057
> -4096 4096
> -4096 4096
> +Silence is golden
> --
> 2.18.0
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
