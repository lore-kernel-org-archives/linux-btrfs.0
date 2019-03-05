Return-Path: <SRS0=ObWa=RI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C14C43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 00:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E99720675
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 00:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfCEAuY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Mar 2019 19:50:24 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17348 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726066AbfCEAuY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Mar 2019 19:50:24 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail07.adl2.internode.on.net with ESMTP; 05 Mar 2019 11:20:22 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1h0yHk-000758-TD; Tue, 05 Mar 2019 11:50:20 +1100
Date:   Tue, 5 Mar 2019 11:50:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     fdmanana@kernel.org, fstests <fstests@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] generic: add test for fsync after shrinking truncate and
 rename
Message-ID: <20190305005020.GA26298@dastard>
References: <20190304140622.23997-1-fdmanana@kernel.org>
 <CAOQ4uxi87QhQHake0L_xVtUYChc3D2kLqho1obq14aG6zCMu6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi87QhQHake0L_xVtUYChc3D2kLqho1obq14aG6zCMu6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 04, 2019 at 05:04:23PM +0200, Amir Goldstein wrote:
> On Mon, Mar 4, 2019 at 4:44 PM <fdmanana@kernel.org> wrote:
> >
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Test that if we truncate a file to reduce its size, rename it and then
> > fsync it, after a power failure the file has a correct size and name.
> >
> 
> I am not sure that ext4/xfs semantics guaranty anything about
> persisting file name after fsync of file?...

They do.  It's that pesky "strictly ordered metadata" thing I keep
having to explain to people...

i.e. if you fsync an inode, then you are persisting all the changes
needed to reference that file and it's data. And so if there was a
rename in the history of that file, then that is persisted, too.
Which means that both the original and the new directory
modifications are persisted, too.

*POSIX* doesn't require this - it says that if you O_DSYNC data,
then it also includes all the metadata needed to reference that
data. So even if the data is there, POSIX doesn't define whether the
rename is there or noti, just that you can get to the fsync'd data
via either the old or new name. IOWs, POSIX allows the behaviour to
be implementation specific.

In this case, file systems with strictly ordered metadata will end
up making the rename visible because the rename occurred before the
truncate that the fsync() is persisting...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
