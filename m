Return-Path: <SRS0=LIGD=RL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA03C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 03:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2B8920675
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 03:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfCHDqx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 22:46:53 -0500
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:9107 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726268AbfCHDqw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 22:46:52 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail03.adl2.internode.on.net with ESMTP; 08 Mar 2019 14:16:48 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1h26T8-0003Jx-KI; Fri, 08 Mar 2019 14:46:46 +1100
Date:   Fri, 8 Mar 2019 14:46:46 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Filipe Manana <fdmanana@kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] generic: add test for fsync after shrinking truncate and
 rename
Message-ID: <20190308034646.GI26298@dastard>
References: <20190304140622.23997-1-fdmanana@kernel.org>
 <CAOQ4uxi87QhQHake0L_xVtUYChc3D2kLqho1obq14aG6zCMu6A@mail.gmail.com>
 <20190305005020.GA26298@dastard>
 <CAOQ4uxgKj8pAKKra9jv+xTb9dOxG-J5fKvJ_6a_iabWR9RbgrQ@mail.gmail.com>
 <20190305223301.GD26298@dastard>
 <CAOQ4uxggon==2r2hibMvXc4_N4zod+2z0Ycw74eKRn+q1uwYsw@mail.gmail.com>
 <20190306214813.GE26298@dastard>
 <CAOQ4uxjM0-D8c3KR0ooXYhhUa5+19j_=3XUaXf6vGMbsNhShJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjM0-D8c3KR0ooXYhhUa5+19j_=3XUaXf6vGMbsNhShJw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 07, 2019 at 09:52:03AM +0200, Amir Goldstein wrote:
> On Wed, Mar 6, 2019 at 11:48 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Wed, Mar 06, 2019 at 09:51:23AM +0200, Amir Goldstein wrote:
> > > On Wed, Mar 6, 2019 at 12:33 AM Dave Chinner <david@fromorbit.com> wrote:
> > > > > So the reason this is working is because 2nd fsync needs to
> > > > > persist ctime of B and not because it needs to persist the
> > > > > truncate.
> > > >
> > > > ctime modifications during rename are irrelevent because there's no
> > > > fsync between the truncate and the rename so the file inode is
> > > > already dirty due to the truncate. I think you've got the wrong end
> > > > of the stick here, Amir. :)
> > >
> > > Doh! The discussion is still interesting because people have
> > > hard time to understand that those hidden details like ctime
> > > update on rename may have different behavior on different fs
> > > regardless if they obay ordered metadata or not.
> > > Btrfs is different in the respect of metadata dependencies from
> > > xfs/ext4 in many ways as seen in the different rename/link
> > > crash consistency discussions.
> >
> > Yes, little things like can result in different behaviour, but what
> > we are trying to do is get to the point where there is minimal
> > difference between all crash-recovery-capable linux filesystems.
> >
> > e.g. what we see here is that by always including the inode being
> > moved in the rename transaction (regardless of how a filesystem
> > acheives that), we provide consistent, reliable, predictable
> > behaviour in all cases of "fsync after rename". IOWs, the SOMC model
> > that _require_metadata_journaling tests are supposed to conform to
> > is far more strict that POSIX requires and our tests need to reflect
> > this stricter consistency model.
> >
> > IOWs, we should be encoding the behaviour we want in these tests
> > rather than implementing yet another "test POSIX compatible
> > behaviour" - POSIX is a complete crapshoot when it comes to
> > persistence requirements. And if a filesystem fails a SOMC-model
> > test, then the filesystem needs to be fixed, not have the test
> > "relaxed" to only exercise POSIX-defined behaviour.
> >
> 
> Agreed! v1 is better than v2. Sorry for my mistake in v1 review.
> 
> I went back to look at similar fsync tests by Filipe:
> generic/{106,107,335,336,341,342,343,348,498,501,502,509,510,512}
> 
> I found some alleged subtle mistakes about SOMC assumptions.
> 
> generic/336 does:
> touch $SCRATCH_MNT/a/foo
> ln $SCRATCH_MNT/a/foo $SCRATCH_MNT/b/foo_link
> touch $SCRATCH_MNT/b/bar
> sync
> unlink $SCRATCH_MNT/b/foo_link
> mv $SCRATCH_MNT/b/bar $SCRATCH_MNT/c/
> $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/a/foo
> 
> And expects both unlink and rename to persist.

*nod*. Yup, that's a typical async transactional ordering
behaviour because the dirty state is carried on the inode, not the
path or fd that is being used to access it.

> However, this is only true in the *very likely* case that there is no
> journal commit in between unlink and rename, because fsync foo
> is only guaranteed to persist metadata changes that depend on the
> unlink and happened BEFORE it, which is not the case for the rename
> of bar.

Yup, most likely. I haven't looked at any of these btrfs-inspired
fsync tests in any detail so it wouldn't surprise me that there are
issues like this in them - I just don't have time to look at
everything.

Indeed, if there are mistaken assumptions in the tests based around
pending dirty state and async transaction aggregation, then running
the tests with "-o dirsync" or even "-o wsync" should cause such
tests to fail.

> At first glance, generic/498 is actually broken (for xfs) or at least
> I don't understand why it works.

The test does this:

mkdir $SCRATCH_MNT/A
mkdir $SCRATCH_MNT/B
mkdir $SCRATCH_MNT/A/C
touch $SCRATCH_MNT/B/foo
$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/B/foo

# It is important the new hard link is located in a hierarchy of new directories
# (not yet persisted).
ln $SCRATCH_MNT/B/foo $SCRATCH_MNT/A/C/foo
$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/A

_flakey_drop_and_remount

And it expects /A and B/foo to be there afterwards. The comment
"(not yet persisted)" is about the buggy btrfs behaviour, not how a
SOMC fs should behave.

So, yeah, that should always work on XFS, because the first fsync
persists everything the test checks (due to common ancestors), and
second fsync is a no-opt because dir A has already been
checkpointed.


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
