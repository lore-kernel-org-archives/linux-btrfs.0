Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:60632 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953AbaDPAYE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 20:24:04 -0400
Date: Wed, 16 Apr 2014 10:23:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, jbacik@fb.com
Subject: Re: [PATCH] xfstests: btrfs, test send's ability to punch holes and
 prealloc extents
Message-ID: <20140416002349.GV15995@dastard>
References: <1397580201-27475-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1397580201-27475-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 15, 2014 at 05:43:21PM +0100, Filipe David Borba Manana wrote:
> This test verifies that after an incremental btrfs send the replicated file has
> the same exact hole and data structure as in the origin filesystem. This didn't
> use to be the case before the send stream version 2 - holes were sent as write
> operations of 0 valued bytes instead of punching holes with the fallocate system
> call, and pre-allocated extents were sent as well as write operations of 0 valued
> bytes instead of intructions for the receiver to use the fallocate system call.
> Also checks that prealloc extents that lie beyond the file's size are replicated
> by an incremental send.

Can you wrap commit messages at 68 columns?

....
> +md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
> +# List all hole and data segments.
> +$XFS_IO_PROG -r -c "seek -r -a 0" $SCRATCH_MNT/mysnap2/foo
> +# List all extents, we're interested here in prealloc extents that lie beyond
> +# the file's size.
> +$XFS_IO_PROG -r -c "fiemap -l" $SCRATCH_MNT/mysnap2/foo | _filter_scratch

That dumps raw block numbers into the golden output. _filter_fiemap
is probably needed here.

> +md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
> +# List all hole and data segments.
> +$XFS_IO_PROG -r -c "seek -r -a 0" $SCRATCH_MNT/mysnap2/foo
> +# List all extents, we're interested here in prealloc extents that lie beyond
> +# the file's size.
> +$XFS_IO_PROG -r -c "fiemap -l" $SCRATCH_MNT/mysnap2/foo | _filter_scratch

Same here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
