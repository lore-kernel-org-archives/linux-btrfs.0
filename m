Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:63214 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752798AbaDNBWj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 21:22:39 -0400
Date: Mon, 14 Apr 2014 11:22:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [ANNOUNCE] xfstests: master branch updated to 8874560
Message-ID: <20140414012225.GF27694@dastard>
References: <20140414004938.GE27694@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140414004938.GE27694@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 14, 2014 at 10:49:38AM +1000, Dave Chinner wrote:
> Hi folks,
> 
> The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
> just been updated. Patches often get missed, so please check if your
> outstanding patches were in this update. If they have not been in
> this update, please resubmit them to xfs@oss.sgi.com so they can be
> picked up in the next update.
> 
> This update includes tests for the new renameat2 syscall, and a
> bunch of fixes for the new config file format infrastructure.

Actaully, it's now updated to:

8874560 generic/024: fix output number

because it missed a test number update in an output file again. That
test doesn't run yet on XFS, so I missed it until I ran some ext4
tests...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
