Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:38615 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753169AbcBIIcS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 03:32:18 -0500
Date: Tue, 9 Feb 2016 19:32:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 21/23] xfs: aio cow tests
Message-ID: <20160209083215.GP19486@dastard>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
 <20160209011401.23099.38.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160209011401.23099.38.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 08, 2016 at 05:14:01PM -0800, Darrick J. Wong wrote:
.,,,
> +
> +echo "Check for damage"
> +_dmerror_unmount
> +_dmerror_cleanup
> +_repair_scratch_fs >> "$seqres.full" 2>&1

Are you testing repair here? If so, why doesn't failure matter.
If not, why do it? Or is _require_scratch_nocheck all that is needed
here?

> +echo "CoW and unmount"
> +"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz * bsz)) 1" "$testdir/file2" >> "$seqres.full"
> +"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$TEST_DIR/moo" >> "$seqres.full"

offset = block size times block size?

I think some better names might be needed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
