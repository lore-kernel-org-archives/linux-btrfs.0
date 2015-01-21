Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:39376 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbbAUEyv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 23:54:51 -0500
Date: Wed, 21 Jan 2015 15:54:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstest: btrfs/006: Add extra check on return value and
 'fi show' by device
Message-ID: <20150121045435.GG16510@dastard>
References: <1421373430-21915-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150121040315.GC16510@dastard>
 <54BF28D4.80303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54BF28D4.80303@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 21, 2015 at 12:19:32PM +0800, Qu Wenruo wrote:
> From: Dave Chinner <david@fromorbit.com>
> >On Fri, Jan 16, 2015 at 09:57:10AM +0800, Qu Wenruo wrote:
> >>Reported in Red Hat BZ#1181627, 'btrfs fi show' on unmounted device will
> >>return 1 even no error happens.
> >Please describe the bug in the commit message, don't make me have to
> >go look at some web page to work out what you are trying to fix.
> OK, I'll make the description more detailed.
> >
> >>Introduced by: commit 2513077f
> >>btrfs-progs: fix device missing of btrfs fi show with seed devices
> >>
> >>Patch fixing it:
> >>https://patchwork.kernel.org/patch/5626001/
> >>btrfs-progs: Fix wrong return value when executing 'fi show' on
> >>umounted device.
> >What btrfs progs commit introduced and fixed is not actually
> >relevant to fstests.
> This just saves some time for some users who failed the test and
> what to check if the bug is fixed or not.

Doesn't save me time - it takes me much longer as I have to use 3
different tools to follow those three references to try to
understand why you are making the change.

> >If I have to go read other stuff to understand
> >the change you are making, then the description needs more detail
> >and less external references....

> I understand that I need to make the description more detailed.
> Although external reference does not help much for fstests, but it
> will really saves time for some tests.  Like Fillipe Manana's
> test, which embedded such info into the test script, saved me a
> lot of time to find the regression commit.

What it helps is people running a new fstests tree on an older
distro kernels. It doesn't save time for reviewers, yet reviewer
resources are in much scarcer supply than distro QA resources.
If you want your changes reviewed faster, then commit messages need
to be reviewer friendly. Further, if you review other people's
changes, then they are much more likely to review your changes
quickly.

If the review burden is left to me all the time then, like Andrew
Morton, I get grumpy when people say "but it helps me".....

> BTW, do I need to cleanup all the $BTRFS_UTIL_PROG in the original test?

Not if it causes older btrfs progs installations to fail.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
