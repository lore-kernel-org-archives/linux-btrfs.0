Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:10798 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756500AbaBFWtK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 17:49:10 -0500
Date: Fri, 7 Feb 2014 09:49:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: xfs@oss.sgi.com, jbacik@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add regression test for running snapshot and send
 concurrently
Message-ID: <20140206224908.GD13647@dastard>
References: <1391440956-31924-1-git-send-email-wangshilong1991@gmail.com>
 <20140203234212.GW13997@dastard>
 <9BC2AB41-F187-4A1A-89D6-743C72446293@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <9BC2AB41-F187-4A1A-89D6-743C72446293@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 06, 2014 at 09:12:51PM +0800, Wang Shilong wrote:
> Hi Dave,
> 
> > On Mon, Feb 03, 2014 at 11:22:36PM +0800, Wang Shilong wrote:
> >> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> >> 
> >> Btrfs would fail to send if snapshot run concurrently, this test is to make
> >> sure we have fixed the bug.
> >> 
> > Couple of comments below.
> > 
> >> +_scratch_mkfs > /dev/null 2>&1
> >> +_scratch_mount
> >> +
> >> +
> >> +touch $SCRATCH_MNT/foo
> >> +
> >> +# get file with fragments by using backwards writes.
> >> +for i in `seq 10240 -1 1`; do
> >> +	$XFS_IO_PROG -f -d -c "pwrite $(($i * 4096)) 4096" \
> >> +	$SCRATCH_MNT/foo > /dev/null | _filter_xfs_io
> > 
> > Indentation.
> > 
> >> +done
> >> +
> >> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
> >> +	$SCRATCH_MNT/snap_1 >> $seqres.full 2>&1
> >> +
> >> +$BTRFS_UTIL_PROG send -f $SCRATCH_MNT/send_file \
> >> +	$SCRATCH_MNT/snap_1 >> $seqres.full 2>&1 &
> >> +
> >> +pid=$!
> >> +
> >> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT/snap_1 \
> >> +	$SCRATCH_MNT/snap_2 >> $seqres.full 2>&1
> >> +
> >> +wait $pid || echo "Failed to send, see dmesg"
> > 
> > This seems kind of racy. It assumes that the send command
> > doesn't complete before the wait $pid call is made. If $pid doesn't
> > exist at this time because it has completed, wait will return 127
> > and the test will fail….
> 
> Sorry for delay reply!
> 
> Maybe a better idea for this will be:
> 
> Opposite to previous way, we do snapshots background while at the
> same time we do sending.
> 
> And btrfs-progs should output meaningful information on send failure, i will
> make a tiny patch to address this issue. but to make this test more friendly, i
> think we can still do something like:
> 
> btrfs send <..>  || echo "Failed to send"

If send is emitting error messages on failures, then the
"|| echo..." is redundant and not necessary to cause a golden image
mismatch. If send is not emitting error messages on failure, then it
needs fixing because users are going to hate you for silently
failing to send the data they asked to be sent.

Either way, the echo command on error in the test is not needed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
