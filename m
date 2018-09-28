Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B251DC43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 17:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F94920657
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 17:12:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OLgMBz8V"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F94920657
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbeI1Xh2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 19:37:28 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:34292 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbeI1Xh2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 19:37:28 -0400
Received: by mail-ua1-f65.google.com with SMTP id r15-v6so2584287uao.1;
        Fri, 28 Sep 2018 10:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=2sN9OUi8J1tBv1khD1wcefSExB5E3HWMFFsA4lpCBAA=;
        b=OLgMBz8V2QLm9/6VPob1HHFqo2/a8mG/5PWkGBTuUvb85MKwcCwd7dasBRtHuvGO3T
         GbVW8iyac+FE79VU/eHihdDwsrbQklAmX7OCYGecT8DAhrO6vE0WuQJb4+FxnTACWadi
         98NkQFgEVyK3Wd8gmycovaWuxpHSfCir6rngJnEE1kGXEaSHO5uJ7d8BrJRQVn4d5vgf
         ShtnHc+PWtTw/bLWeRWdP/TCU/vIc7NU2BbNsw2iUz9mOchuCfDhg/gbt9f9Wxr86Ge6
         coyC4PdPjq1Angm2NEavYTQiURTvqgNBztEcJGbu+WEAIcNvwi5fDC4PWD+07rroLGzr
         IphA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=2sN9OUi8J1tBv1khD1wcefSExB5E3HWMFFsA4lpCBAA=;
        b=btcc21koV2U8sF61+VcOLyR3+Rcxnub30RZXCWSjgp/jWSXv0hgPPmWkPeFwd7kk4g
         Vl5/RaPIRgMsvN/mqoIMYQz01Pgws2J9ucDqy54z3V0BekLzR2jKMXF8OY5q+ZzHnyWx
         Qt4qsuK01du0AZg0jUCtjcZ4JDh3y5SHpzTWW6USYSGStgl8DsElmdLPqdYN8bVvK33d
         pIGdOeh9DHchytEKR5F9oY2QiiXlvQWZTFdAj2C6LAsQgNYMo9AA9pDiS9x77CtrM5+U
         6m6lHrqFuv/QwQcaKK6dw6dqnZg/JrsIKaCfd3UxNy3BvNMy7ZnyQKyjIQFthVyMxC1q
         MDng==
X-Gm-Message-State: ABuFfoihkCE53FBjP8MS/oLoRhQ9gue7JChmfvhPKIGssS4orlLA79/S
        VG1NLM2Zzw3y2ilW1bAawAU+uwO7ahPZ7IUk+MQ=
X-Google-Smtp-Source: ACcGV61dbCEJaW4BbqoWv2nT7WH3K5rfT3g2Wxm7+Oy+7G/g2Z+vhcznB3t1iabKeOk8WLapAI9VbwesYFRb1IaAVEQ=
X-Received: by 2002:ab0:268f:: with SMTP id t15-v6mr6392440uao.137.1538154764896;
 Fri, 28 Sep 2018 10:12:44 -0700 (PDT)
MIME-Version: 1.0
References: <1538146248-1759-1-git-send-email-anand.jain@oracle.com> <CAL3q7H4XNMMHwQLdQbvGvxcj=ALqjFJzJi00UFiyA9VV4dKhiw@mail.gmail.com>
In-Reply-To: <CAL3q7H4XNMMHwQLdQbvGvxcj=ALqjFJzJi00UFiyA9VV4dKhiw@mail.gmail.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 28 Sep 2018 18:12:33 +0100
Message-ID: <CAL3q7H7SBJS4Kh_mksA1bp-jw_333d+gt3aQ-03x-jbDPDS7BA@mail.gmail.com>
Subject: Re: [PATCH v3] test unaligned punch hole at ENOSPC
To:     Anand Jain <anand.jain@oracle.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 28, 2018 at 6:08 PM Filipe Manana <fdmanana@gmail.com> wrote:
>
> On Fri, Sep 28, 2018 at 3:51 PM Anand Jain <anand.jain@oracle.com> wrote:
> >
> > Try to punch hole with unaligned size and offset when the FS
> > returns ENOSPC
>
> The FS returns ENOSPC is confusing. It's more clear to say when the
> filesystem doesn't have more space available for data allocation.
> >
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > ---
> > v2->v3:
> >  add _require_xfs_io_command "fpunch"
> >  add more logs to $seqfull.full
> >    mount options and
> >    group profile info
> >  add sync after dd upto ENOSPC
> >  drop fallocate -p and use xfs_io punch to create holes
> > v1->v2: Use at least 256MB to test.
> > This test case fails on btrfs as of now.
> >
> >  tests/btrfs/172     | 74 +++++++++++++++++++++++++++++++++++++++++++++=
++++++++
> >  tests/btrfs/172.out |  2 ++
> >  tests/btrfs/group   |  1 +
> >  3 files changed, 77 insertions(+)
> >  create mode 100755 tests/btrfs/172
> >  create mode 100644 tests/btrfs/172.out
> >
> > diff --git a/tests/btrfs/172 b/tests/btrfs/172
> > new file mode 100755
> > index 000000000000..59413a5de12f
> > --- /dev/null
> > +++ b/tests/btrfs/172
> > @@ -0,0 +1,74 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2018 Oracle. All Rights Reserved.
> > +#
> > +# FS QA Test 172
> > +#
> > +# Test if the unaligned (by size and offset) punch hole is successful =
when FS
> > +# is at ENOSPC.
> > +#
> > +seq=3D`basename $0`
> > +seqres=3D$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=3D`pwd`
> > +tmp=3D/tmp/$$
> > +status=3D1       # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +       cd /
> > +       rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs btrfs
> > +_supported_os Linux
> > +_require_scratch
> > +_require_xfs_io_command "fpunch"
> > +
> > +_scratch_mkfs_sized $((256 * 1024 *1024)) >> $seqres.full
> > +
> > +# max_inline helps to create regular extent
> max_inline ensures data is not inlined within metadata extents
>
> > +_scratch_mount "-o max_inline=3D0,nodatacow"
> > +
> > +cat /proc/self/mounts | grep $SCRATCH_DEV >> $seqres.full
> > +$BTRFS_UTIL_PROG filesystem df $SCRATCH_MNT >> $seqres.full
> > +
> > +extent_size=3D$(_scratch_btrfs_sectorsize)
> > +unalign_by=3D512
> > +echo extent_size=3D$extent_size unalign_by=3D$unalign_by >> $seqres.fu=
ll
> > +
> > +$XFS_IO_PROG -f -d -c "pwrite -S 0xab 0 $((extent_size * 10))" \
> > +                                       $SCRATCH_MNT/testfile >> $seqre=
s.full

Also missing _require_odirect.
Why is direct IO needed? If not needed (which I don't see why), it can
be avoided.

> > +
> > +echo "Fill fs upto ENOSPC" >> $seqres.full
> Fill all space available for data and all unallocated space.
>
> > +dd status=3Dnone if=3D/dev/zero of=3D$SCRATCH_MNT/filler bs=3D512 >> $=
seqres.full 2>&1
> Why do you use dd here and not xfs_io?
>
> > +sync
> Why is the sync needed?
>
> > +
> > +hole_offset=3D0
> > +hole_len=3D$unalign_by
> > +$XFS_IO_PROG -f -d -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/tes=
tfile
>
> No need to pass -f anymore. No need for -d either.
>
> > +
> > +hole_offset=3D$(($extent_size + $unalign_by))
> > +hole_len=3D$(($extent_size - $unalign_by))
> > +$XFS_IO_PROG -f -d -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/tes=
tfile
>
> No need to pass -f anymore. No need for -d either.
>
> > +
> > +hole_offset=3D$(($extent_size * 2 + $unalign_by))
> > +hole_len=3D$(($extent_size * 5))
> > +$XFS_IO_PROG -f -d -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/tes=
tfile
>
> No need to pass -f anymore. No need for -d either.
> > +
> > +# success, all done
> > +echo "Silence is golden"
> > +status=3D0
> > +exit
> > diff --git a/tests/btrfs/172.out b/tests/btrfs/172.out
> > new file mode 100644
> > index 000000000000..ce2de3f0d107
> > --- /dev/null
> > +++ b/tests/btrfs/172.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 172
> > +Silence is golden
> > diff --git a/tests/btrfs/group b/tests/btrfs/group
> > index feffc45b6564..7e1a638ab7e1 100644
> > --- a/tests/btrfs/group
> > +++ b/tests/btrfs/group
> > @@ -174,3 +174,4 @@
> >  169 auto quick send
> >  170 auto quick snapshot
> >  171 auto quick qgroup
> > +172 auto quick
> > --
> > 1.8.3.1
> >
>
>
> --
> Filipe David Manana,
>
> =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you'=
re right.=E2=80=9D



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
