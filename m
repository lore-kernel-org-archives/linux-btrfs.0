Return-Path: <SRS0=e2uI=NJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A21C0044C
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 11:41:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F4D02082D
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 11:41:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e9yyVnAW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F4D02082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbeJ2UaA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 29 Oct 2018 16:30:00 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:37219 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbeJ2U37 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Oct 2018 16:29:59 -0400
Received: by mail-ua1-f65.google.com with SMTP id c5so1208111uak.4
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Oct 2018 04:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=VXxJA0qSj6qYASf0ogDcVMOdrhHgFBG0xUqmyzPJzwg=;
        b=e9yyVnAWprLkIL471/IkBlnzChoKC+yJGwICr1Quw5/AmOwSy/SHJebcbgcQSOUBi8
         uaADj1ibXTMomYF2lemD4IEgIhayQwxKuMaBIV7L9AaqheNQ3yln74S4evEIrJpHAbWM
         NVbxDSFyUTAJMTlPHA7Qz3iW7DxB/j2Hc46EZQ+q/K7Evp3zr1P5fCpuGPiJZ5LY+SsC
         mplbXrPri3CqfBbxmwxv+MPfAqjH7YsCvAUWdSdZ7srgXvw5ZvsKBAoRWHNi/chWhYYB
         dWxftUnGTqwjnPW6eeX8KKaSRhuyyExxp0x4Zz5SLGlvWWyAeE9RQWQmBFqVNzp5V4bS
         FYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=VXxJA0qSj6qYASf0ogDcVMOdrhHgFBG0xUqmyzPJzwg=;
        b=QLcQWEx6nDttH5L3I+X1R+IqjDEaOMFukPnY4pf7r3+n3ITeLys7921BQWcnkx4GIa
         /x8w87VE2+q6BrdnLcT4Y/uGDISnnHCyKtcOIUUa+p/hFz3NjsviFFG+fQIS43IURFo9
         6Jz/H1sGIdGsnIVqtjSwoaQDMJOcX49YRn3xuiK8VeDKIJ2N3NnNDHdI+86G+qWUmcRR
         aTulQMrzkbVzIzJEWV/qv+yFCJhHtItSQWMCjaAQdYdw1sjtt/DxtgzNMr/U0vg3T6hF
         uE4wcG1NXM5cB4zenL2hgthhL2OFuh+5jvgpvQ/zN7XNA5TPM3KMPz4BWyRJOGheRIlr
         tflg==
X-Gm-Message-State: AGRZ1gK5ab0syuQh0iP/bwwwi4ccAJE4okCge0kLgZKsHrFlGGeUuD4v
        dvjkGbcsGxkpZ3hJtvRyZVrcBOmHb7ErGQR6ekE=
X-Google-Smtp-Source: AJdET5dpkf6o9I0QIr26m5som9zqniomoDOTqUw+xCNNGC4ecqnNySp5D3YyAO93+pL1Kvc5f8WaNm6RmaySrKeTK9k=
X-Received: by 2002:ab0:621a:: with SMTP id m26mr677512uao.36.1540813300841;
 Mon, 29 Oct 2018 04:41:40 -0700 (PDT)
MIME-Version: 1.0
References: <20181029063053.21130-1-wqu@suse.com> <CAL3q7H4tGLCpFUm-GR7cGng66zu3A342O7eM6jbfFsqx1-Zw=Q@mail.gmail.com>
 <140cc051-9e73-a051-c1e5-71590d829606@gmx.com>
In-Reply-To: <140cc051-9e73-a051-c1e5-71590d829606@gmx.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 29 Oct 2018 11:41:29 +0000
Message-ID: <CAL3q7H5iwm7k70TdRX_oOn2YnFMejDGuzQO_uG9jud6rUbZP4w@mail.gmail.com>
Subject: Re: [PATCH] fstests: btrfs/057: Fix false alerts due to orphan files
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 29, 2018 at 11:33 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2018/10/29 =E4=B8=8B=E5=8D=885:52, Filipe Manana wrote:
> > On Mon, Oct 29, 2018 at 6:31 AM Qu Wenruo <wqu@suse.com> wrote:
> >>
> >> For latest kernel, there is a chance that btrfs/057 reports false
> >> errors.
> >
> > By latest kernel you mean 4.20?
>
> I mean almost all kernels.

So s/For latest kernel/For any recent kernel/ or something like that
which isn't singular.

>
> >
> >>
> >> The false error would look like:
> >>   btrfs/057 4s ... - output mismatch (see /home/adam/xfstests-dev/resu=
lts//btrfs/057.out.bad)
> >>       --- tests/btrfs/057.out   2017-08-21 09:25:33.166666666 +0800
> >>       +++ /home/adam/xfstests-dev/results//btrfs/057.out.bad    2018-1=
0-29 14:07:28.443651293 +0800
> >>       @@ -1,3 +1,3 @@
> >>        QA output created by 057
> >>        4096 4096
> >>       -4096 4096
> >>       +28672 28672
> >>
> >> This is related to the fact that "btrfs subvolume sync" (or
> >> vanilla sync) will not ensure orphan (unlinked but still exist) files =
to
> >> be removed.
> >
> > So when did that happen, which commit introduced the behaviour change?
>
> No behavior change, it's always the case.
> Just not that easy to hit.
>
> Thanks,
> Qu
>
> >
> >>
> >> In fact, for that false error case, if inspecting the fs after umount,
> >> its qgroup number is correct and btrfs check won't report qgroup error=
.
> >>
> >> To fix the false alerts, just skip any manual qgroup number comparison=
,
> >> and let fsck done after the test case to detect problem.
> >>
> >> This also elimiate the necessary of using specified mount and mkfs
> >> option, allowing us to improve coverage.
> >>
> >> Reported-by: Nikolay Borisov <nborisov@suse.com>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>

Anyway, looks good to me.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

> >> ---
> >>  tests/btrfs/057     | 17 ++++-------------
> >>  tests/btrfs/057.out |  3 +--
> >>  2 files changed, 5 insertions(+), 15 deletions(-)
> >>
> >> diff --git a/tests/btrfs/057 b/tests/btrfs/057
> >> index b019f4e1..0b5a36d3 100755
> >> --- a/tests/btrfs/057
> >> +++ b/tests/btrfs/057
> >> @@ -33,12 +33,9 @@ _require_scratch
> >>  rm -f $seqres.full
> >>
> >>  # use small leaf size to get higher btree height.
> >> -run_check _scratch_mkfs "-b 1g --nodesize 4096"
> >> +run_check _scratch_mkfs "-b 1g"
> >>
> >> -# inode cache is saved in the FS tree itself for every
> >> -# individual FS tree,that affects the sizes reported by qgroup show
> >> -# so we need to explicitly turn it off to get consistent values.
> >> -_scratch_mount "-o noinode_cache"
> >> +_scratch_mount
> >>
> >>  # -w ensures that the only ops are ones which cause write I/O
> >>  run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p 5 -n 1000 \
> >> @@ -53,14 +50,8 @@ run_check $FSSTRESS_PROG -d $SCRATCH_MNT/snap1 -w -=
p 5 -n 1000 \
> >>  _run_btrfs_util_prog quota enable $SCRATCH_MNT
> >>  _run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
> >>
> >> -# remove all file/dir other than subvolume
> >> -rm -rf $SCRATCH_MNT/snap1/* >& /dev/null
> >> -rm -rf $SCRATCH_MNT/p* >& /dev/null
> >> -
> >> -_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
> >> -units=3D`_btrfs_qgroup_units`
> >> -$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $SED_PROG -n '/[0-=
9]/p' \
> >> -       | $AWK_PROG '{print $2" "$3}'
> >> +echo "Silence is golden"
> >> +# btrfs check will detect any qgroup number mismatch.
> >>
> >>  status=3D0
> >>  exit
> >> diff --git a/tests/btrfs/057.out b/tests/btrfs/057.out
> >> index 60cb92d0..185023c7 100644
> >> --- a/tests/btrfs/057.out
> >> +++ b/tests/btrfs/057.out
> >> @@ -1,3 +1,2 @@
> >>  QA output created by 057
> >> -4096 4096
> >> -4096 4096
> >> +Silence is golden
> >> --
> >> 2.18.0
> >>
> >
> >
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
