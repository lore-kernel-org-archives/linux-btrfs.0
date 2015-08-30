Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:26320 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752411AbbH3XU2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Aug 2015 19:20:28 -0400
Date: Mon, 31 Aug 2015 09:20:24 +1000
From: Dave Chinner <david@fromorbit.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH] Abort tests on mkfs failure
Message-ID: <20150830232024.GL3902@dastard>
References: <1440945888-32220-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440945888-32220-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 30, 2015 at 08:14:48PM +0530, Chandan Rajendra wrote:
> When creating small Btrfs filesystem instances (i.e. filesystem size <= 1GiB),
> mkfs.btrfs can fail if "data block size" does not match "metadata block
> size". In such cases this commit aborts the test instead of letting it to
> continue and report misleading results.

NACK. Running the test, even with the wrong mkfs parameters, is more
valuable to us than not running the test at all. This has been
explained several times in the past 18 months when similar patches
have been posted.

What you need to do is prevent mkfs from failing in your new corner
case on small filesystems, or fail the test in the the filesystem
specific mkfs routine.

e.g. Filesystems like xfs have custom functions (i.e.
_scratch_mkfs_xfs) that prevent mkfs from failing in weird corner
cases or when conflicting options are given (e.g. test option
conflict with MKFS_OPTIONS given on the CLI).

Or, you can make the btrfs mkfs command in _scratch_mkfs_sized()
specially handle this specific btrfs configuration correctly, and if
it can't then it should fail there.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
