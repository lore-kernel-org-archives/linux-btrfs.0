Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2349C43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 07:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88B5B2063F
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 07:52:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oGW+MdyP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfCGHwR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 02:52:17 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:40990 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfCGHwR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2019 02:52:17 -0500
Received: by mail-yw1-f66.google.com with SMTP id q128so12551490ywg.8;
        Wed, 06 Mar 2019 23:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LuGQvvG4Dltf0AzmrxGD+ka+45Stojh5hh4VdPeaDRw=;
        b=oGW+MdyPf1WPK9u+teJZG/0U+jBR81HjJi7T1op6On1gEumX2KhFWZjEp0Qtla8+LN
         60dhRI6SZ0s6IeF3WMR5cr6wQUUkBDa5+Hu7oFE1/F19aGdQXPxymM17H8mwGlI6wr0x
         wseebMIOmeX04vqcKkKmED0MBTNz1CrAm5FFt8tcqzVirFhSBtM7M/JkFtB5/3P5QjjO
         /vRuuXh7L0Fk1ODgKFykxs/7L3hQ8lexeebS1fcXMvCQsSjtDsGgdvWiY9bTa1lYRhVl
         lsSZFpD7a53hEFL6OA4jaNiKKzkeIpOyJaRM41VBr+AW6zwaJgkkdc9zRPrl8Xvteye+
         FYTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LuGQvvG4Dltf0AzmrxGD+ka+45Stojh5hh4VdPeaDRw=;
        b=YgTrphA2syW4dGOy7NGCBw0eyikKUqyGguD19X8rRB/NN3bYjfSl/T+bTrjMFHtcL2
         IqAs1WVFhJn2o+5aqmFJ5+/y5U22gaF/PmU0DVORnE0vc3TiVAQ9DbCRscyBXyDU4GS9
         9Ypcdsav4kKTvatQAN/lvM/TexV9t9qoJgDa0f7VJEqidygxB+jiMDzymqVMIkocLGoI
         kYzU0hmF7Psho+KbHvH5Bcg+WVp3fYhesvOcdrioj/wfSH0Iv0BPXsMsUHHYuvW6qWKg
         QxT6cKiVc0DAiuyBj0ajID4eNybAK6pr9d99UmIIqnUuNKQMT06J5JdCsxTZlO4UYl6F
         xZPw==
X-Gm-Message-State: APjAAAVMKF/iHbFB7GF7APw1A2FvImpP9WrFySMVM5q2q3IxKLbxWkPt
        PxRmA7TxZGtuTSfno1HITl6Ny1rOT8SXwtbCoBo=
X-Google-Smtp-Source: APXvYqwNWVH2OnBspi7nzDGYiZiHkIX6qEth+eDfvNM5KzKQp/pEN5t3+oKTisQlebTFf1Dk3LztIcXCVTkIbb9WXd4=
X-Received: by 2002:a25:1488:: with SMTP id 130mr10494095ybu.507.1551945136107;
 Wed, 06 Mar 2019 23:52:16 -0800 (PST)
MIME-Version: 1.0
References: <20190304140622.23997-1-fdmanana@kernel.org> <CAOQ4uxi87QhQHake0L_xVtUYChc3D2kLqho1obq14aG6zCMu6A@mail.gmail.com>
 <20190305005020.GA26298@dastard> <CAOQ4uxgKj8pAKKra9jv+xTb9dOxG-J5fKvJ_6a_iabWR9RbgrQ@mail.gmail.com>
 <20190305223301.GD26298@dastard> <CAOQ4uxggon==2r2hibMvXc4_N4zod+2z0Ycw74eKRn+q1uwYsw@mail.gmail.com>
 <20190306214813.GE26298@dastard>
In-Reply-To: <20190306214813.GE26298@dastard>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 7 Mar 2019 09:52:03 +0200
Message-ID: <CAOQ4uxjM0-D8c3KR0ooXYhhUa5+19j_=3XUaXf6vGMbsNhShJw@mail.gmail.com>
Subject: Re: [PATCH] generic: add test for fsync after shrinking truncate and rename
To:     Dave Chinner <david@fromorbit.com>
Cc:     Filipe Manana <fdmanana@kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 6, 2019 at 11:48 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Wed, Mar 06, 2019 at 09:51:23AM +0200, Amir Goldstein wrote:
> > On Wed, Mar 6, 2019 at 12:33 AM Dave Chinner <david@fromorbit.com> wrote:
> > > > So the reason this is working is because 2nd fsync needs to
> > > > persist ctime of B and not because it needs to persist the
> > > > truncate.
> > >
> > > ctime modifications during rename are irrelevent because there's no
> > > fsync between the truncate and the rename so the file inode is
> > > already dirty due to the truncate. I think you've got the wrong end
> > > of the stick here, Amir. :)
> >
> > Doh! The discussion is still interesting because people have
> > hard time to understand that those hidden details like ctime
> > update on rename may have different behavior on different fs
> > regardless if they obay ordered metadata or not.
> > Btrfs is different in the respect of metadata dependencies from
> > xfs/ext4 in many ways as seen in the different rename/link
> > crash consistency discussions.
>
> Yes, little things like can result in different behaviour, but what
> we are trying to do is get to the point where there is minimal
> difference between all crash-recovery-capable linux filesystems.
>
> e.g. what we see here is that by always including the inode being
> moved in the rename transaction (regardless of how a filesystem
> acheives that), we provide consistent, reliable, predictable
> behaviour in all cases of "fsync after rename". IOWs, the SOMC model
> that _require_metadata_journaling tests are supposed to conform to
> is far more strict that POSIX requires and our tests need to reflect
> this stricter consistency model.
>
> IOWs, we should be encoding the behaviour we want in these tests
> rather than implementing yet another "test POSIX compatible
> behaviour" - POSIX is a complete crapshoot when it comes to
> persistence requirements. And if a filesystem fails a SOMC-model
> test, then the filesystem needs to be fixed, not have the test
> "relaxed" to only exercise POSIX-defined behaviour.
>

Agreed! v1 is better than v2. Sorry for my mistake in v1 review.

I went back to look at similar fsync tests by Filipe:
generic/{106,107,335,336,341,342,343,348,498,501,502,509,510,512}

I found some alleged subtle mistakes about SOMC assumptions.

generic/336 does:
touch $SCRATCH_MNT/a/foo
ln $SCRATCH_MNT/a/foo $SCRATCH_MNT/b/foo_link
touch $SCRATCH_MNT/b/bar
sync
unlink $SCRATCH_MNT/b/foo_link
mv $SCRATCH_MNT/b/bar $SCRATCH_MNT/c/
$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/a/foo

And expects both unlink and rename to persist.
However, this is only true in the *very likely* case that there is no
journal commit in between unlink and rename, because fsync foo
is only guaranteed to persist metadata changes that depend on the
unlink and happened BEFORE it, which is not the case for the rename
of bar.

generic/343 and generic/510 do something similar.

At first glance, generic/498 is actually broken (for xfs) or at least
I don't understand why it works.

Thanks,
Amir.
