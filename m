Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:34632 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753338AbaBCXmT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 18:42:19 -0500
Date: Tue, 4 Feb 2014 10:42:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: xfs@oss.sgi.com, jbacik@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add regression test for running snapshot and send
 concurrently
Message-ID: <20140203234212.GW13997@dastard>
References: <1391440956-31924-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391440956-31924-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 03, 2014 at 11:22:36PM +0800, Wang Shilong wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> 
> Btrfs would fail to send if snapshot run concurrently, this test is to make
> sure we have fixed the bug.
> 
Couple of comments below.

> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +
> +
> +touch $SCRATCH_MNT/foo
> +
> +# get file with fragments by using backwards writes.
> +for i in `seq 10240 -1 1`; do
> +	$XFS_IO_PROG -f -d -c "pwrite $(($i * 4096)) 4096" \
> +	$SCRATCH_MNT/foo > /dev/null | _filter_xfs_io

Indentation.

> +done
> +
> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
> +	$SCRATCH_MNT/snap_1 >> $seqres.full 2>&1
> +
> +$BTRFS_UTIL_PROG send -f $SCRATCH_MNT/send_file \
> +	$SCRATCH_MNT/snap_1 >> $seqres.full 2>&1 &
> +
> +pid=$!
> +
> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT/snap_1 \
> +	$SCRATCH_MNT/snap_2 >> $seqres.full 2>&1
> +
> +wait $pid || echo "Failed to send, see dmesg"

This seems kind of racy. It assumes that the send command
doesn't complete before the wait $pid call is made. If $pid doesn't
exist at this time because it has completed, wait will return 127
and the test will fail....

Also, why would a failure to send result in meaingful information in
dmesg? Shouldn't the userspace command output information to tell
you why there was a failure into $seqres.full?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
