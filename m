Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50382 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755207Ab3HLBMa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Aug 2013 21:12:30 -0400
Date: Mon, 12 Aug 2013 11:11:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: chandan <chandan@linux.vnet.ibm.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, sekharan@linux.vnet.ibm.com
Subject: Re: [PATCH] _test_generic_punch: Extend $testfile's size to work
 with 64k block.
Message-ID: <20130812011155.GL12779@dastard>
References: <3326777.u9YeDIQiYF@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3326777.u9YeDIQiYF@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 11:40:04AM +0530, chandan wrote:
> From cf6e1fc3a8d7806a97055b5f483cf50f58c8294f Mon Sep 17 00:00:00 2001
> From: chandan <chandan@linux.vnet.ibm.com>
> Date: Thu, 8 Aug 2013 11:33:10 +0530
> Subject: [PATCH] _test_generic_punch: Extend $testfile's size to work with 64k
>  block.
> 
> The current script does not work with 64k block size. This patch fixes it
> by creating a larger $testfile.

I can see why we might want to support such a configuration, but the
changes being made defeat the purpose of the sizes chosen for this
test.

That is, most people testing are using 4k block size filesystems,
and the sizes are selected such that single blocks are being
manipulated by the test. it's looking for corner/edge case problems,
and changing the code to now use chunks of 64k changes all the edge
cases being tested.

Indeed, even the new bmap output is likely to cause problems in that
small block size filesystems are no guaranteed to allocate
contiguous blocks linearly. This is another reason that 4k was
chosen as the size of the regions.

So, to do this properly, I'd suggest that the code needs to scale
the offset/size of the IO being done by the filesystem block size,
not use a fixed size. Using a filter on the bmap output to handle
the different block ranges will ensure everything works correctly
from a golden output POV, except for one thing - the md5sum.

The md5sum of the file is used for integrity checking and will
change as the block size changes. I haven't thought about a way to
avoid his problem yet but we do need some form of integrity check
to ensure all filesystems are ending up with the correct contents in
the files.

In the interim, if all you want to do is stop a test failure on your
power machines, then either add a "_requires_le_4k_blocksize" check
to avoid running the test on problematic filesystems or specifically
create the fileystem being tested with a 4k block size...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
