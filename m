Return-Path: <SRS0=LIGD=RL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74F3C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 04:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 988CA20811
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 04:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbfCHEfI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 23:35:08 -0500
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:9915 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726250AbfCHEfI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 23:35:08 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail03.adl6.internode.on.net with ESMTP; 08 Mar 2019 15:05:05 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1h27Dr-0003NV-Ao; Fri, 08 Mar 2019 15:35:03 +1100
Date:   Fri, 8 Mar 2019 15:35:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jayashree Mohan <jayashree2912@gmail.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Filipe Manana <fdmanana@kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] generic: add test for fsync after shrinking truncate and
 rename
Message-ID: <20190308043503.GJ26298@dastard>
References: <20190304140622.23997-1-fdmanana@kernel.org>
 <CAOQ4uxi87QhQHake0L_xVtUYChc3D2kLqho1obq14aG6zCMu6A@mail.gmail.com>
 <20190305005020.GA26298@dastard>
 <CAOQ4uxgKj8pAKKra9jv+xTb9dOxG-J5fKvJ_6a_iabWR9RbgrQ@mail.gmail.com>
 <20190305223301.GD26298@dastard>
 <CAOQ4uxggon==2r2hibMvXc4_N4zod+2z0Ycw74eKRn+q1uwYsw@mail.gmail.com>
 <20190306214813.GE26298@dastard>
 <CAOQ4uxjM0-D8c3KR0ooXYhhUa5+19j_=3XUaXf6vGMbsNhShJw@mail.gmail.com>
 <CA+EzBbCuQJen9hSHf8-JSRGG3VPxo9X4ugscMdKuw_A6isHDUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EzBbCuQJen9hSHf8-JSRGG3VPxo9X4ugscMdKuw_A6isHDUQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 07, 2019 at 05:19:51PM -0600, Jayashree Mohan wrote:
> Hi Amir,
> 
> > I went back to look at similar fsync tests by Filipe:
> > generic/{106,107,335,336,341,342,343,348,498,501,502,509,510,512}
> >
> > I found some alleged subtle mistakes about SOMC assumptions.
> >
> > generic/336 does:
> > touch $SCRATCH_MNT/a/foo
> > ln $SCRATCH_MNT/a/foo $SCRATCH_MNT/b/foo_link
> > touch $SCRATCH_MNT/b/bar
> > sync
> > unlink $SCRATCH_MNT/b/foo_link
> > mv $SCRATCH_MNT/b/bar $SCRATCH_MNT/c/
> > $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/a/foo
> 
> This is probably what's happening in this particular test :
> 
> SOMC requires:
>           fsync(a/foo) must ensure unlink(b/foo_link)  (because they
> were linked at some point)
> 
> But what happens is:
>            fsync(a/foo)          -->  unlink(b/foo_link)
>            unlink(b/foo_link)  -->  fsync(b)
>            fsync(b)                 -->  rename goes through
> 
> SOMC should only require that the unlink persists.

That's a /fsync/ requirement, not SOMC.

SOMC says:

"If the rename after the fsync()d unlink is present after recovery,
then every metadata operation completed between the unlink and the
rename must also be present after recovery."

> The rename
> operation persists due to the side-effect of SOMC. So we should be
> only testing if the unlink operation went through.

No, it persists as a side effect of the a filesystem fsync()
implementation, not SOMC.

i.e. on fsync(), the filesystem must commit the journal at a point
in time that *includes the unlink*. That means it can chose any time
between the unlink and the moment the fsync() is received by the
filesystem. Once the point in time has been chosen by the fsync
operation, SOMC then defines what else must be journalled and
recovered with the information that must be fsync()d.

> Take a look at this thread that describes the bug which resulted in
> this test case (https://patchwork.kernel.org/patch/8293181/).

I really wouldn't try to infer anything from the bugs in btrfs fsync
behaviour or the test cases that expose them. 'Behave like other
filesystems" is not a substitute for having solid fundamental
algorithms...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
