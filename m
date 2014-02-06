Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:11828 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756025AbaBFWnn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 17:43:43 -0500
Date: Fri, 7 Feb 2014 09:43:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, jbacik@fb.com
Subject: Re: [PATCH v3] Btrfs: add regression test for running snapshot and
 send concurrently
Message-ID: <20140206224337.GB13647@dastard>
References: <1391703008-2322-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391703008-2322-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 07, 2014 at 12:10:08AM +0800, Wang Shilong wrote:
> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
> +	$SCRATCH_MNT/snap_1 >> $seqres.full 2>&1
> +
> +do_snapshots &
> +snapshots_pid=$!
> +
> +$BTRFS_UTIL_PROG send $SCRATCH_MNT/snap_1 > /dev/null 2>&1 || echo "btrfs send failed"

Let's stop this anti-pattern before it takes hold.

If there's output from the send command it should be
filtered and captured in the golden image. Hence any deviation
caused by errors is automatically flagged as an error.

That's the whole point of using golden images for capturing errors -
you don't need to capture return values from binaries and it
guarantees that users are informed about failures through error
messages. IOWs:

$BTRFS_UTIL_PROG send $SCRATCH_MNT/snap_1 | _btrfs_send_filter

is what you should be doing here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
