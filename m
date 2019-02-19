Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169D6C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 12:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE998208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 12:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550577868;
	bh=g/6tPboaRx1QwFNmU74qxUyfDs/yyRsflHnX2RrWIAk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=IpdJN0KYqNVR3uBRNDAhUJQ6FzlLEc3VlKLeFEXxk0qvL5uuOSpGxtX4HOqPPMhOn
	 6pC/eJMxQKX6AgWo9XAtXEZbc8HrJKN8qYzIT1rF/56LxBIo8Mfa6MeZ+dkr4fimAc
	 59ccO4MwJyy0D19RoD9LloFQvccaL7ojHfEm55AE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfBSME2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 07:04:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbfBSME2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 07:04:28 -0500
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 013412177E;
        Tue, 19 Feb 2019 12:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550577867;
        bh=g/6tPboaRx1QwFNmU74qxUyfDs/yyRsflHnX2RrWIAk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LwDsbdkp/bJwelt9ei71PDATeo5BxF30PtgW5UqIpE7cAqdP9Pd6cDJhxznmml273
         lBwFKLc33M57FPcqlwaJT1iwU8n07MuxZv3mcGD/O7c5DaoyjtQw9M/q8sbQz/QPQq
         NJGcyXr3psSgMRDvtfy/njJnvjkm3tRY5bxUMz48=
Received: by mail-vk1-f181.google.com with SMTP id l62so2260334vkh.0;
        Tue, 19 Feb 2019 04:04:26 -0800 (PST)
X-Gm-Message-State: AHQUAualcAxxIlNXr8YVH4G/byazwUZxh2z0ae4M3rIrHtMZ5lJ+pCdI
        1Rl4XVQYY9R39mBwyTNwMlDbqzBWEdoBWfNjQqo=
X-Google-Smtp-Source: AHgI3IapvdI9fGFa09Mh2hzUReL1F92Nqds+qKjq6YmpMMPtNsybZ4ZUFC7LUhf9LRQqhQ3LpEaF1xt+6sjd3rSXapI=
X-Received: by 2002:a1f:7f10:: with SMTP id o16mr4824064vki.31.1550577865920;
 Tue, 19 Feb 2019 04:04:25 -0800 (PST)
MIME-Version: 1.0
References: <20190212180807.26368-1-fdmanana@kernel.org> <1ef915e7-2c1e-872f-4686-0a636d822ddd@huawei.com>
In-Reply-To: <1ef915e7-2c1e-872f-4686-0a636d822ddd@huawei.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Tue, 19 Feb 2019 12:04:14 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6ExsyQbyEW1j7Sr=a2k0YibWqQqT+sVOPRainO9pzRBQ@mail.gmail.com>
Message-ID: <CAL3q7H6ExsyQbyEW1j7Sr=a2k0YibWqQqT+sVOPRainO9pzRBQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] fstests: generic, test fsync after succession of file renames
To:     Chao Yu <yuchao0@huawei.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 19, 2019 at 1:29 AM Chao Yu <yuchao0@huawei.com> wrote:
>
> On 2019/2/13 2:08, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Test that after a combination of file renames, linking and creating a new
> > file with the old name of a renamed file, if we fsync the new file, after
> > a power failure we are able to mount the filesystem and all file names
> > correspond to the correct inodes.
> >
> > This test is motivated by a bug found in btrfs which is fixed by a patch
> > for the linux kernel titled:
> >
> >   "Btrfs: fix fsync after succession of renames of different files"
> >
> > The test passes on ext4, xfs and patched btrfs, however at least in a
> > 5.0-rc5 linux kernel, it fails on f2fs.
>
> We have introduced one additional mount option to handle that case:
>
> fsync_mode=%s
>
> Control the policy of fsync. Currently supports "posix",
> "strict", and "nobarrier". In "posix" mode, which is
> default, fsync will follow POSIX semantics and does a
> light operation to improve the filesystem performance.
> In "strict" mode, fsync will be heavy and behaves in line
> with xfs, ext4 and btrfs, where xfstest generic/342 will
> pass, but the performance will regress. "nobarrier" is
> based on "posix", but doesn't issue flush command for
> non-atomic files likewise "nobarrier" mount option.
>
> I've tested for confirmation, it passed both tests 526/527 on f2fs once I
> changed mount option from default to fsync_mode=strict.
>
> Filipe, could you please check that?

Thanks. I wasn't aware of that mount option.
Btw, it seems complicated for a user to know which option to use for
that mount option,
even if it's very well documented, as it's unlikely the user is aware
of what all applications
in the system do and expect (or make the strict mode the default).

Thanks.

>
> Thanks,
>
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  tests/generic/526     | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/526.out |  5 ++++
> >  tests/generic/group   |  1 +
> >  3 files changed, 78 insertions(+)
> >  create mode 100755 tests/generic/526
> >  create mode 100644 tests/generic/526.out
> >
> > diff --git a/tests/generic/526 b/tests/generic/526
> > new file mode 100755
> > index 00000000..d0b51f87
> > --- /dev/null
> > +++ b/tests/generic/526
> > @@ -0,0 +1,72 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (C) 2018 SUSE Linux Products GmbH. All Rights Reserved.
> > +#
> > +# FS QA Test No. 526
> > +#
> > +# Test that after a combination of file renames, linking and creating a new file
> > +# with the old name of a renamed file, if we fsync the new file, after a power
> > +# failure we are able to mount the filesystem and all file names correspond to
> > +# the correct inodes.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +tmp=/tmp/$$
> > +status=1     # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +     _cleanup_flakey
> > +     cd /
> > +     rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/dmflakey
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_scratch
> > +_require_dm_target flakey
> > +
> > +rm -f $seqres.full
> > +
> > +_scratch_mkfs >>$seqres.full 2>&1
> > +_require_metadata_journaling $SCRATCH_DEV
> > +_init_flakey
> > +_mount_flakey
> > +
> > +mkdir $SCRATCH_MNT/testdir
> > +echo -n "foo" > $SCRATCH_MNT/testdir/fname1
> > +echo -n "hello" > $SCRATCH_MNT/testdir/fname2
> > +
> > +# Make sure everything done so far is durably persisted.
> > +sync
> > +
> > +# Rename and link files such that one new name corresponds to the name of
> > +# another renamed file and one new file has the old name of one of the renamed
> > +# files. Then fsync only the new file.
> > +mv $SCRATCH_MNT/testdir/fname1 $SCRATCH_MNT/testdir/fname3
> > +mv $SCRATCH_MNT/testdir/fname2 $SCRATCH_MNT/testdir/fname4
> > +ln $SCRATCH_MNT/testdir/fname3 $SCRATCH_MNT/testdir/fname2
> > +echo -n "bar" > $SCRATCH_MNT/testdir/fname1
> > +$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/testdir/fname1
> > +
> > +# Simulate a power failure and mount the filesystem to check that all file names
> > +# exist and correspond to the correct inodes.
> > +_flakey_drop_and_remount
> > +
> > +echo "File fname1 data after power failure: $(cat $SCRATCH_MNT/testdir/fname1)"
> > +echo "File fname2 data after power failure: $(cat $SCRATCH_MNT/testdir/fname2)"
> > +echo "File fname3 data after power failure: $(cat $SCRATCH_MNT/testdir/fname3)"
> > +echo "File fname4 data after power failure: $(cat $SCRATCH_MNT/testdir/fname4)"
> > +
> > +_unmount_flakey
> > +
> > +status=0
> > +exit
> > diff --git a/tests/generic/526.out b/tests/generic/526.out
> > new file mode 100644
> > index 00000000..83979d28
> > --- /dev/null
> > +++ b/tests/generic/526.out
> > @@ -0,0 +1,5 @@
> > +QA output created by 526
> > +File fname1 data after power failure: bar
> > +File fname2 data after power failure: foo
> > +File fname3 data after power failure: foo
> > +File fname4 data after power failure: hello
> > diff --git a/tests/generic/group b/tests/generic/group
> > index cfd003d3..492a5875 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -528,3 +528,4 @@
> >  523 auto quick attr
> >  524 auto quick
> >  525 auto quick rw
> > +526 auto quick log
> >
>
