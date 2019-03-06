Return-Path: <SRS0=mVxD=RJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A95C43381
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 21:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8220D20663
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 21:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfCFVsS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:48:18 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:6942 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726226AbfCFVsR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Mar 2019 16:48:17 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail07.adl2.internode.on.net with ESMTP; 07 Mar 2019 08:18:15 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1h1eOb-0001Vg-Ps; Thu, 07 Mar 2019 08:48:13 +1100
Date:   Thu, 7 Mar 2019 08:48:13 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Filipe Manana <fdmanana@kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] generic: add test for fsync after shrinking truncate and
 rename
Message-ID: <20190306214813.GE26298@dastard>
References: <20190304140622.23997-1-fdmanana@kernel.org>
 <CAOQ4uxi87QhQHake0L_xVtUYChc3D2kLqho1obq14aG6zCMu6A@mail.gmail.com>
 <20190305005020.GA26298@dastard>
 <CAOQ4uxgKj8pAKKra9jv+xTb9dOxG-J5fKvJ_6a_iabWR9RbgrQ@mail.gmail.com>
 <20190305223301.GD26298@dastard>
 <CAOQ4uxggon==2r2hibMvXc4_N4zod+2z0Ycw74eKRn+q1uwYsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxggon==2r2hibMvXc4_N4zod+2z0Ycw74eKRn+q1uwYsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 06, 2019 at 09:51:23AM +0200, Amir Goldstein wrote:
> On Wed, Mar 6, 2019 at 12:33 AM Dave Chinner <david@fromorbit.com> wrote:
> > > So the reason this is working is because 2nd fsync needs to
> > > persist ctime of B and not because it needs to persist the
> > > truncate.
> >
> > ctime modifications during rename are irrelevent because there's no
> > fsync between the truncate and the rename so the file inode is
> > already dirty due to the truncate. I think you've got the wrong end
> > of the stick here, Amir. :)
> 
> Doh! The discussion is still interesting because people have
> hard time to understand that those hidden details like ctime
> update on rename may have different behavior on different fs
> regardless if they obay ordered metadata or not.
> Btrfs is different in the respect of metadata dependencies from
> xfs/ext4 in many ways as seen in the different rename/link
> crash consistency discussions.

Yes, little things like can result in different behaviour, but what
we are trying to do is get to the point where there is minimal
difference between all crash-recovery-capable linux filesystems.

e.g. what we see here is that by always including the inode being
moved in the rename transaction (regardless of how a filesystem
acheives that), we provide consistent, reliable, predictable
behaviour in all cases of "fsync after rename". IOWs, the SOMC model
that _require_metadata_journaling tests are supposed to conform to
is far more strict that POSIX requires and our tests need to reflect
this stricter consistency model.

IOWs, we should be encoding the behaviour we want in these tests
rather than implementing yet another "test POSIX compatible
behaviour" - POSIX is a complete crapshoot when it comes to
persistence requirements. And if a filesystem fails a SOMC-model
test, then the filesystem needs to be fixed, not have the test
"relaxed" to only exercise POSIX-defined behaviour.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
