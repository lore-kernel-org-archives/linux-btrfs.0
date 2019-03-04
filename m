Return-Path: <SRS0=W6bw=RH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5108AC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 22:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15BB920823
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 22:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551738664;
	bh=rlrS1n7lfzI5++YpgX87kQ1dmROuZiuOQXJOzHUMNsk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=q/8shGrirrdAPQGHVkmD5ExVKMg8UFKOuOOmJ+cYBwDbSy67+9L2Qeuec+oV47XRn
	 s8lU4IE52F1KlLApzVP0+hIKZxFqzvBD68RpB3IDw3GB3mdz6aBlxM/c/ta6urCmpr
	 yBVW7LI2zyhxR7afVK2Xi7ms1EsmP+xDbSSAUnmc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfCDWbC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Mar 2019 17:31:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbfCDWbC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Mar 2019 17:31:02 -0500
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F180120835;
        Mon,  4 Mar 2019 22:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551738661;
        bh=rlrS1n7lfzI5++YpgX87kQ1dmROuZiuOQXJOzHUMNsk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HxgRWr2wITJZRlayZhEpGQhjisZAf8b31zQVPbHEs0gCjeI4hTKlPC/JVfbxGWtzR
         swWM/FgyyGLgjl2Tz8SZMBXr6kOUbtQD/XdWxiOsDJOgbkY0prHpJE8iB9HOljo/yh
         CXukRttknFBO2NjIKNqzvePFwPibav1Uydsbkt2s=
Received: by mail-vk1-f176.google.com with SMTP id w85so1507866vkw.11;
        Mon, 04 Mar 2019 14:31:00 -0800 (PST)
X-Gm-Message-State: APjAAAWzmbCFhcldnlWTr9LupQunequLdI5Uh/lTGcZ1ihXdtgX2RF5/
        PuJuMhF+/7zriYNiL26XcwMyqwiftYWSdu6rC0I=
X-Google-Smtp-Source: APXvYqysKZJjr7mv2K006NuYtztzKds4O0Rbd/QUaHoQ+hjcmHmBH2F3o5dLTlv57KOKRG5mAYBGiyMTUBuSYsjjDM0=
X-Received: by 2002:a1f:9dcb:: with SMTP id g194mr10994962vke.81.1551738660059;
 Mon, 04 Mar 2019 14:31:00 -0800 (PST)
MIME-Version: 1.0
References: <20190304140622.23997-1-fdmanana@kernel.org> <CAOQ4uxi87QhQHake0L_xVtUYChc3D2kLqho1obq14aG6zCMu6A@mail.gmail.com>
 <CAL3q7H6ceptNOyf65jbzojbZV5Nq3d0iKvYOvvE=pLaVnpgO2w@mail.gmail.com> <CAOQ4uxhno=ORXpLgLC2O7KoJJXm2sVEtZ8DgiHZi-4p_HmfEwg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhno=ORXpLgLC2O7KoJJXm2sVEtZ8DgiHZi-4p_HmfEwg@mail.gmail.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 4 Mar 2019 22:30:48 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6XDTkp+wHmM9+ON+smcqk6fR5fL3Bf1OmVFE06BRnEjw@mail.gmail.com>
Message-ID: <CAL3q7H6XDTkp+wHmM9+ON+smcqk6fR5fL3Bf1OmVFE06BRnEjw@mail.gmail.com>
Subject: Re: [PATCH] generic: add test for fsync after shrinking truncate and rename
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 4, 2019 at 5:59 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Mar 4, 2019 at 5:23 PM Filipe Manana <fdmanana@kernel.org> wrote:
> >
> > On Mon, Mar 4, 2019 at 3:04 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Mon, Mar 4, 2019 at 4:44 PM <fdmanana@kernel.org> wrote:
> > > >
> > > > From: Filipe Manana <fdmanana@suse.com>
> > > >
> > > > Test that if we truncate a file to reduce its size, rename it and then
> > > > fsync it, after a power failure the file has a correct size and name.
> > > >
> > >
> > > I am not sure that ext4/xfs semantics guaranty anything about
> > > persisting file name after fsync of file?...
> > >
> > > > This test is motivated by a bug found in btrfs, which is fixed by a
> > > > patch for the linux kernel titled:
> > > >
> > > >   "Btrfs: fix incorrect file size after shrinking truncate and fsync"
> > >
> > > At least the title of this patch says nothing about persisting the
> > > name.
> >
> > Because the bug in btrfs is not about persisting the name, it's about
> > persisting the correct inode size.
> >
>
> OK. Still AFAIK, ext4/xfs don't guaranty that the name bar will exist
> after power failure unless the parent dir was fsynced.
> If you fsync the parent dir instead of the file after rename, it will
> make the test correct for ext4/xfs (and POSIX for that matter).

I'm not so sure about that. Couldn't find anything explicit anywhere about that.
There are other tests that do similar assumptions, either after
renames or after adding a new
hard link (fsyncing just the file being enough to guarantee the new
hard link exits after a power
failure, without the need to fsync the parent directory). I don't
recall ever having had such
comment before, even for much more complex cases involving renames
such as [1] for example.

[1] https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/commit/?id=e2d866668a98af4cd47cd6913418e410cd80aa93

In this case both old and new names are in the same parent directory,
but if they were in different directories, and
requiring the user/application to fsync both directories, it could be
dangerous, if the old parent dir is fsync'ed and
a power failure happened before fsync'ing the new parent (requiring
the user/application to know about this
and fsync the new parent before the old parent dir also seems very
demanding), leading to a potential file loss
after replaying the log/journal (there were such cases in btrfs before).

> Will that test modification still catch the btrfs bug (pre fix)?

Yes, it will still trigger the btrfs bug.

Well, I don't mind doing such change, but I would like to hear other
opinions too, perhaps Dave could shed some light on this?
Even old reiserfs and f2fs (both on posix and strict fsync modes)
currently pass this test.

Thanks.

>
> Thanks,
> Amir.
>
> > >
> > > >
> > > > This test currently passes on ext4, xfs, f2fs and patched btrfs.
> > > >
> > > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > > ---
> > > >  tests/generic/532     | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/generic/532.out |  8 +++++++
> > > >  tests/generic/group   |  1 +
> > > >  3 files changed, 75 insertions(+)
> > > >  create mode 100755 tests/generic/532
> > > >  create mode 100644 tests/generic/532.out
> > > >
> > > > diff --git a/tests/generic/532 b/tests/generic/532
> > > > new file mode 100755
> > > > index 00000000..64992d85
> > > > --- /dev/null
> > > > +++ b/tests/generic/532
> > > > @@ -0,0 +1,66 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
> > > > +#
> > > > +# FS QA Test No. 532
> > > > +#
> > > > +# Test that if we truncate a file to reduce its size, rename it and then fsync
> > > > +# it, after a power failure the file has a correct size and name.
> > > > +#
> > > > +seq=`basename $0`
> > > > +seqres=$RESULT_DIR/$seq
> > > > +echo "QA output created by $seq"
> > > > +tmp=/tmp/$$
> > > > +status=1       # failure is the default!
> > > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > > +
> > > > +_cleanup()
> > > > +{
> > > > +       _cleanup_flakey
> > > > +       cd /
> > > > +       rm -f $tmp.*
> > > > +}
> > > > +
> > > > +# get standard environment, filters and checks
> > > > +. ./common/rc
> > > > +. ./common/filter
> > > > +. ./common/dmflakey
> > > > +
> > > > +# real QA test starts here
> > > > +_supported_fs generic
> > > > +_supported_os Linux
> > > > +_require_scratch
> > > > +_require_dm_target flakey
> > > > +
> > > > +rm -f $seqres.full
> > > > +
> > > > +_scratch_mkfs >>$seqres.full 2>&1
> > > > +_require_metadata_journaling $SCRATCH_DEV
> > > > +_init_flakey
> > > > +_mount_flakey
> > > > +
> > > > +# Create our test file with an initial size of 8000 bytes, then fsync it,
> > > > +# followed by a truncate that reduces its size down to 3000 bytes.
> > > > +$XFS_IO_PROG -f -c "pwrite -S 0xab 0 8000" \
> > > > +            -c "fsync" \
> > > > +            -c "truncate 3000" \
> > > > +            $SCRATCH_MNT/foo | _filter_xfs_io
> > > > +
> > > > +# Now rename the file and fsync it again.
> > > > +mv $SCRATCH_MNT/foo $SCRATCH_MNT/bar
> > > > +$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar
> > > > +
> > > > +# Simulate a power failure and mount the filesystem to check that the file was
> > > > +# persisted with the new name and has a size of 3000 bytes.
> > > > +_flakey_drop_and_remount
> > > > +
> > > > +[ -f $SCRATCH_MNT/bar ] || echo "file name 'bar' is missing"
> > > > +[ -f $SCRATCH_MNT/foo ] && echo "file name 'foo' still exists"
> > > > +
> > > > +echo "File content after power failure:"
> > > > +od -A d -t x1 $SCRATCH_MNT/bar
> > > > +
> > > > +_unmount_flakey
> > > > +
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/generic/532.out b/tests/generic/532.out
> > > > new file mode 100644
> > > > index 00000000..554fbe2a
> > > > --- /dev/null
> > > > +++ b/tests/generic/532.out
> > > > @@ -0,0 +1,8 @@
> > > > +QA output created by 532
> > > > +wrote 8000/8000 bytes at offset 0
> > > > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > > > +File content after power failure:
> > > > +0000000 ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab
> > > > +*
> > > > +0002992 ab ab ab ab ab ab ab ab
> > > > +0003000
> > > > diff --git a/tests/generic/group b/tests/generic/group
> > > > index 31011ac8..7d63f303 100644
> > > > --- a/tests/generic/group
> > > > +++ b/tests/generic/group
> > > > @@ -534,3 +534,4 @@
> > > >  529 auto quick attr
> > > >  530 auto quick unlink
> > > >  531 auto quick unlink
> > > > +532 auto quick log
> > > > --
> > > > 2.11.0
> > > >
