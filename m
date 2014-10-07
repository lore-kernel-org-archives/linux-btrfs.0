Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:35553 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380AbaJGTn5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Oct 2014 15:43:57 -0400
Date: Wed, 8 Oct 2014 06:43:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: add regression for inode bad compression ratio
 detection
Message-ID: <20141007194352.GF12693@dastard>
References: <1412724049-50613-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1412724049-50613-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 07, 2014 at 07:20:49PM -0400, Wang Shilong wrote:
> This test add a regression test to make sure btrfs dosen't set
> inode NOCOMPRESS flag when a small write(<=blocksize) happens.
> 
> Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
...
> +rm -f $seqres.full
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount "-o compress=lzo"
> +
> +$XFS_IO_PROG -f -c "pwrite 0 10M" -c "fsync" \
> +	$SCRATCH_MNT/data >> $seqres.full 2>&1
> +
> +filefrag $SCRATCH_MNT/data | $AWK_PROG '{print $2}'

We don't want to introduce new external dependencies if we have
internal functions that do the same thing. i.e:

. common/defrag
....
_extent_count $SCRATCH_MNT/data

Will do the same thing without introducing a dependence on filefrag.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
