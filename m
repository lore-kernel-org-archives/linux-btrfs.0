Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:24456 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbaBXF2R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 00:28:17 -0500
Date: Mon, 24 Feb 2014 16:28:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: add test btrfs/042 for btrfs incremental send
Message-ID: <20140224052801.GK4317@dastard>
References: <1392940976-1790-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392940976-1790-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 21, 2014 at 12:02:56AM +0000, Filipe David Borba Manana wrote:
> Regression test for a btrfs incremental send issue where invalid paths for
> utimes, chown and chmod operations were sent to the send stream, causing
> btrfs receive to fail.
> 
> If a directory had a move/rename operation delayed, and none of its parent
> directories, except for the immediate one, had delayed move/rename operations,
> after processing the directory's references, the incremental send code would
> issue invalid paths for utimes, chown and chmod operations.
> 
> This issue is fixed by the following linux kernel btrfs patch:
> 
>    Btrfs: fix send issuing outdated paths for utimes, chown and chmod
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
....
> +FSSUM_PROG=$here/src/fssum
> +[ -x $FSSUM_PROG ] || _notrun "fssum not built"

Helper...

.....
> +_scratch_unmount
> +_check_btrfs_filesystem $SCRATCH_DEV

And _check_scratch_fs....

> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/1.snap
> +run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1 2>> $seqres.full
> +
> +_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/2.snap
> +run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2 2>> $seqres.full

And the redirection....

I'm happy to see you write your tests consistently, Filipe :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
