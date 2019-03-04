Return-Path: <SRS0=W6bw=RH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B95DC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 17:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D6F7206BA
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 17:59:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sRUUc+8H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfCDR7P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Mar 2019 12:59:15 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44786 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbfCDR7P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2019 12:59:15 -0500
Received: by mail-yw1-f65.google.com with SMTP id x21so4754008ywx.11;
        Mon, 04 Mar 2019 09:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vFn483uWDyWi6+542jYzx7S96Xl1pdANkuogTeY9SDA=;
        b=sRUUc+8HVUp1uCmLLoOdDDSpn8etBaY3ZzgFr6Uznc3RR+sK9MOWYFjIc9PkX6yOUC
         VqnasnfBk8nUpWw6Fjhsh+NqwvYYVb2vFTql3msqpEnsbSuqaPLHscjRdFAYfLoYvwuJ
         2ypwxknAnNzPxrx8O78qkwjNliY2k0d2ezzIKQcGRZEjxFmCG6RcT58QinT8w35OSWVB
         HYYiDCh18+mYAKW/J1Uen9OPiJ/c3jx2oBqb0smS4bEW2xD9rze73519m38ce6FDgY39
         AhshLVtOyTmK9NbrCh6LsBHB/FFd6OfloGbcMUhmkh6lFLrANyBSpoLrVoXvqAJVfaz3
         SNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vFn483uWDyWi6+542jYzx7S96Xl1pdANkuogTeY9SDA=;
        b=aOrRkK6pVqfb4JvRavSz244oTT0lZhnPN8NB6XjQQRFqTEtwlztOaykJgspk+VjdRp
         f2bNw45bAr64KNBAQhzteVLZI0rElKBASWtsfkLYiuzlWHSszqPxbrr2rla34bnR0BVX
         +HpfraH8XR1Pab1/vsMn9JKZT9JptGo7t1tax4DiGKlwIk9X9epZ5zvMZOGFoNQe4hDs
         Yxdhk4EIIs96wE8bsCuaHG/wdSVDCuv+YFs2LuxBf2cuTMmCDNEIH3X3mvgxeQQZYk+j
         XiuhXRHfgNh0vvi8sBnm8zawa5XqsjnXuZBKSqN6ATj5XtbFVNsP3bxWCY0D3rvqc3qq
         fNnA==
X-Gm-Message-State: APjAAAUfL0h5ZKtKXtlWc4ofxbAmgqM60bm+L5OrXcOsd0+d0j59ZgJI
        QkrRSfn6SETZC7+Aak4eKhLWHmo/YXEmlCMbxFQ=
X-Google-Smtp-Source: APXvYqzpLedwPB9LICbA8sU+4TBM7bLkwfHbKOqa3nRQX1eSjtLiPwnQ14JK4HYo2d9lDsFs5hpKi/nPw1//niNEdhM=
X-Received: by 2002:a25:1488:: with SMTP id 130mr16489457ybu.507.1551722353685;
 Mon, 04 Mar 2019 09:59:13 -0800 (PST)
MIME-Version: 1.0
References: <20190304140622.23997-1-fdmanana@kernel.org> <CAOQ4uxi87QhQHake0L_xVtUYChc3D2kLqho1obq14aG6zCMu6A@mail.gmail.com>
 <CAL3q7H6ceptNOyf65jbzojbZV5Nq3d0iKvYOvvE=pLaVnpgO2w@mail.gmail.com>
In-Reply-To: <CAL3q7H6ceptNOyf65jbzojbZV5Nq3d0iKvYOvvE=pLaVnpgO2w@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 4 Mar 2019 19:59:02 +0200
Message-ID: <CAOQ4uxhno=ORXpLgLC2O7KoJJXm2sVEtZ8DgiHZi-4p_HmfEwg@mail.gmail.com>
Subject: Re: [PATCH] generic: add test for fsync after shrinking truncate and rename
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     fstests <fstests@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 4, 2019 at 5:23 PM Filipe Manana <fdmanana@kernel.org> wrote:
>
> On Mon, Mar 4, 2019 at 3:04 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Mon, Mar 4, 2019 at 4:44 PM <fdmanana@kernel.org> wrote:
> > >
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > Test that if we truncate a file to reduce its size, rename it and then
> > > fsync it, after a power failure the file has a correct size and name.
> > >
> >
> > I am not sure that ext4/xfs semantics guaranty anything about
> > persisting file name after fsync of file?...
> >
> > > This test is motivated by a bug found in btrfs, which is fixed by a
> > > patch for the linux kernel titled:
> > >
> > >   "Btrfs: fix incorrect file size after shrinking truncate and fsync"
> >
> > At least the title of this patch says nothing about persisting the
> > name.
>
> Because the bug in btrfs is not about persisting the name, it's about
> persisting the correct inode size.
>

OK. Still AFAIK, ext4/xfs don't guaranty that the name bar will exist
after power failure unless the parent dir was fsynced.
If you fsync the parent dir instead of the file after rename, it will
make the test correct for ext4/xfs (and POSIX for that matter).
Will that test modification still catch the btrfs bug (pre fix)?

Thanks,
Amir.

> >
> > >
> > > This test currently passes on ext4, xfs, f2fs and patched btrfs.
> > >
> > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > ---
> > >  tests/generic/532     | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/532.out |  8 +++++++
> > >  tests/generic/group   |  1 +
> > >  3 files changed, 75 insertions(+)
> > >  create mode 100755 tests/generic/532
> > >  create mode 100644 tests/generic/532.out
> > >
> > > diff --git a/tests/generic/532 b/tests/generic/532
> > > new file mode 100755
> > > index 00000000..64992d85
> > > --- /dev/null
> > > +++ b/tests/generic/532
> > > @@ -0,0 +1,66 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 532
> > > +#
> > > +# Test that if we truncate a file to reduce its size, rename it and then fsync
> > > +# it, after a power failure the file has a correct size and name.
> > > +#
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +tmp=/tmp/$$
> > > +status=1       # failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +       _cleanup_flakey
> > > +       cd /
> > > +       rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +. ./common/dmflakey
> > > +
> > > +# real QA test starts here
> > > +_supported_fs generic
> > > +_supported_os Linux
> > > +_require_scratch
> > > +_require_dm_target flakey
> > > +
> > > +rm -f $seqres.full
> > > +
> > > +_scratch_mkfs >>$seqres.full 2>&1
> > > +_require_metadata_journaling $SCRATCH_DEV
> > > +_init_flakey
> > > +_mount_flakey
> > > +
> > > +# Create our test file with an initial size of 8000 bytes, then fsync it,
> > > +# followed by a truncate that reduces its size down to 3000 bytes.
> > > +$XFS_IO_PROG -f -c "pwrite -S 0xab 0 8000" \
> > > +            -c "fsync" \
> > > +            -c "truncate 3000" \
> > > +            $SCRATCH_MNT/foo | _filter_xfs_io
> > > +
> > > +# Now rename the file and fsync it again.
> > > +mv $SCRATCH_MNT/foo $SCRATCH_MNT/bar
> > > +$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar
> > > +
> > > +# Simulate a power failure and mount the filesystem to check that the file was
> > > +# persisted with the new name and has a size of 3000 bytes.
> > > +_flakey_drop_and_remount
> > > +
> > > +[ -f $SCRATCH_MNT/bar ] || echo "file name 'bar' is missing"
> > > +[ -f $SCRATCH_MNT/foo ] && echo "file name 'foo' still exists"
> > > +
> > > +echo "File content after power failure:"
> > > +od -A d -t x1 $SCRATCH_MNT/bar
> > > +
> > > +_unmount_flakey
> > > +
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/532.out b/tests/generic/532.out
> > > new file mode 100644
> > > index 00000000..554fbe2a
> > > --- /dev/null
> > > +++ b/tests/generic/532.out
> > > @@ -0,0 +1,8 @@
> > > +QA output created by 532
> > > +wrote 8000/8000 bytes at offset 0
> > > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > > +File content after power failure:
> > > +0000000 ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab
> > > +*
> > > +0002992 ab ab ab ab ab ab ab ab
> > > +0003000
> > > diff --git a/tests/generic/group b/tests/generic/group
> > > index 31011ac8..7d63f303 100644
> > > --- a/tests/generic/group
> > > +++ b/tests/generic/group
> > > @@ -534,3 +534,4 @@
> > >  529 auto quick attr
> > >  530 auto quick unlink
> > >  531 auto quick unlink
> > > +532 auto quick log
> > > --
> > > 2.11.0
> > >
