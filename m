Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:40260 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751192AbaAMD04 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 22:26:56 -0500
Date: Mon, 13 Jan 2014 14:26:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com,
        Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: Add pairing mount options test
Message-ID: <20140113032650.GH3469@dastard>
References: <1389162648-19309-1-git-send-email-quwenruo@cn.fujitsu.com>
 <52D01CA9.4040107@sandeen.net>
 <52D33F92.2000609@cn.fujitsu.com>
 <52D342F0.5020402@sandeen.net>
 <20140113015239.GD3469@dastard>
 <52D34EBD.4020508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52D34EBD.4020508@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 13, 2014 at 10:26:05AM +0800, Qu Wenruo wrote:
> On mon, 13 Jan 2014 12:52:39 +1100, Dave Chinner wrote:
> >On Sun, Jan 12, 2014 at 07:35:44PM -0600, Eric Sandeen wrote:
> >>I won't say no to this, but it seems to be of somewhat limited use.
> >What happens to the test when mount options are deprecated/removed?
> >How are we going to handle the matrix of testable/untestable mount
> >options across kernels with different mount option support?
> In my opinion,there may be two ways to deal it:
> 1) Introduce up_limit_kver and down_limit_kver to *every* mount option.
> If needed also add deprecated flags.

Both of which are messy, and kernel version number checks don't work
with vendor kernels that have stuff back ported to them.

> This method will introduce more effort tomaintain the test case, but
> due to the small codes and
> relativly less changes in mount options, I consider it as an
> acceptable method.

What you are saying is that such a test will require constant
maintenance from upstream developers to keep working across all the
kernels that btrfs supports.

When combined with Eric's comments that it doesn't test the
functionality and so has relatively little benefit in terms of
improving code coverage, it doesn't paint a pretty picture. So from
that point of view, I'd say no to such a test.

> It would be quite nice if any one can provide any better idea.

Write a test for each individual feature that exercises and
validates that feature in some way. Part of a functional test would
be to test that the mount options for that function do what they are
intended to do. Eric suggested the same thing (though in a different
way).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
