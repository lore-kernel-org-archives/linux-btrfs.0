Return-Path: <SRS0=e2uI=NJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A5AC0044C
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 11:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F027F2082D
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 11:45:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hs44qef6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F027F2082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbeJ2Udl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 29 Oct 2018 16:33:41 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:35829 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbeJ2Udl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Oct 2018 16:33:41 -0400
Received: by mail-vs1-f66.google.com with SMTP id d62so3256831vsd.2;
        Mon, 29 Oct 2018 04:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=J4CxOGsH9uIEPD9RsAR9mHRJDZZXHmxhdISmpaeq0VA=;
        b=Hs44qef6SYRejAbVwPlK/s/2NnhCQBZ3Sdcv+0thOqWnBrs7fna8LTmN8daTrFGh0E
         dgWy4oeci5b5RD1tw2XWRlbsRFBWbgFiXCWUHi3w2LxV/lE5Xczu4fr+guc64L04+nWi
         4bdi/8bKHaSxn+vSAVU4g9JJHNyCEzlI9JHd0Orw0u21kIt0qmwMu/JV3sJo9pC/E5CA
         Qq3mbJHDX+5Mrfyi7nrs3mlwpqByujoB21ckU8K4CgGE+Ze9r3aoPAyegGNVsFU9sumn
         qz62yA9NILuCZ4tS/HZlYEbngnZSSZX6pynhCdkfDPD9ctZVNgaVF4SaJKPOHVjiNPtX
         T+ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=J4CxOGsH9uIEPD9RsAR9mHRJDZZXHmxhdISmpaeq0VA=;
        b=rsp8GZGuL6+z9fldUX6DcVn4Hwpbwvmm107sYH1YJ7l8CgoCgX6BQ8mZ3krOOnijA2
         3aojv8rbRKlXaqcPH7CRXYKqXGtb+x7UvvbJ1oqG0MeXBexx02wi82Ta1mlKgbnUAXph
         jHj1CHsEGd0r2oFWYEBNgJpongsBciTfLtz1z5zfGeVwfosRWLf3sF2+nF9tlckqIAUP
         UbstSNCFwjJ5s/9O5vKh8n9BMVJ2FOBs2ghmyVcHAuEEBriGcB2P3ZXGhkiwyDM/2urF
         w+CfghzFDBahmtDvg7gS398Z9gPnOt4DBSbVolZYjM5xxteW2V+8/7on4LI8p39nmSBw
         IJeA==
X-Gm-Message-State: AGRZ1gK5dUhX1RNBtyBHX9MCtbvsaxMZiHwaM1SFz1VzAvBuHxbZ3it5
        6yC0kZ3YC0HxYDRFEgBdfpvpp9ZDF7kxViPgfpg=
X-Google-Smtp-Source: AJdET5caYSqAwO0i5U48mgzblKQgG8bpGSNAfj0KZ+Qvpu7Tpelg85zlEbNTT/wxRNa4dsBt+Cyk8fPfOXooik5omKY=
X-Received: by 2002:a67:3b1b:: with SMTP id i27mr5860878vsa.14.1540813522047;
 Mon, 29 Oct 2018 04:45:22 -0700 (PDT)
MIME-Version: 1.0
References: <20181029063501.21604-1-wqu@suse.com>
In-Reply-To: <20181029063501.21604-1-wqu@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 29 Oct 2018 11:45:10 +0000
Message-ID: <CAL3q7H7whUCd-a97ZvqkLUFO1oe1L2aYhmiECxH1n5Bx6Wf-tg@mail.gmail.com>
Subject: Re: [PATCH] fstests: btrfs/057: Fix false alerts due to orphan files
To:     Qu Wenruo <wqu@suse.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 29, 2018 at 6:35 AM Qu Wenruo <wqu@suse.com> wrote:
>
> For latest kernel, there is a chance that btrfs/057 reports false
> errors.
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

Reviewed-by: Filipe Manana <fdmanana@suse.com>

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

The comment above should go away too.

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
