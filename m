Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:37115 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbbHaKsv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 06:48:51 -0400
Received: from /spool/local
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 31 Aug 2015 16:18:48 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH] Abort tests on mkfs failure
Date: Mon, 31 Aug 2015 16:11:37 +0530
Message-ID: <1627818.5iIukl1gSh@localhost.localdomain>
In-Reply-To: <20150830232024.GL3902@dastard>
References: <1440945888-32220-1-git-send-email-chandan@linux.vnet.ibm.com> <20150830232024.GL3902@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 31 Aug 2015 09:20:24 Dave Chinner wrote:
> On Sun, Aug 30, 2015 at 08:14:48PM +0530, Chandan Rajendra wrote:
> > When creating small Btrfs filesystem instances (i.e. filesystem size <=
> > 1GiB), mkfs.btrfs can fail if "data block size" does not match "metadata
> > block size". In such cases this commit aborts the test instead of letting
> > it to continue and report misleading results.
> 
> NACK. Running the test, even with the wrong mkfs parameters, is more
> valuable to us than not running the test at all. This has been
> explained several times in the past 18 months when similar patches
> have been posted.
> 
> What you need to do is prevent mkfs from failing in your new corner
> case on small filesystems, or fail the test in the the filesystem
> specific mkfs routine.
> 
> e.g. Filesystems like xfs have custom functions (i.e.
> _scratch_mkfs_xfs) that prevent mkfs from failing in weird corner
> cases or when conflicting options are given (e.g. test option
> conflict with MKFS_OPTIONS given on the CLI).
> 
> Or, you can make the btrfs mkfs command in _scratch_mkfs_sized()
> specially handle this specific btrfs configuration correctly, and if
> it can't then it should fail there.
>
Dave, Thanks for the guidance.

For Btrfs filesystem instances <= 1GiB in size, Btrfs creates "mixed"
block-groups i.e. block groups that are capable of holding data and metadata
blocks. Hence the requirement for such instances to have the same block sizes
for "data" and "metadata". On such mismatched block sizes being provided as
input, mkfs.btrfs exits without making any changes to the underlying disk
(which may actually have a different filesystem created on it).

Based on this reasoning, I will write a patch that detects the conflict and
fails in btrfs specific command in _scratch_mkfs_sized() function.

-- 
chandan

