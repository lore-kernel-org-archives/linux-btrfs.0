Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbaIILz7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Sep 2014 07:55:59 -0400
Date: Tue, 9 Sep 2014 19:55:54 +0800
From: Eryu Guan <eguan@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/15 v2] btrfs: new test to run btrfs balance and scrub
 simultaneously
Message-ID: <20140909115554.GV2977@dhcp-13-216.nay.redhat.com>
References: <1409233676-22787-1-git-send-email-eguan@redhat.com>
 <1409233676-22787-3-git-send-email-eguan@redhat.com>
 <20140908100441.GG30012@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140908100441.GG30012@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 08, 2014 at 08:04:41PM +1000, Dave Chinner wrote:
> On Thu, Aug 28, 2014 at 09:47:43PM +0800, Eryu Guan wrote:
> > Run btrfs balance and scrub operations simultaneously with fsstress
> > running in background.
> > +run_test()
> > +{
> > +	local mkfs_opts=$1
> > +
> > +	echo "Test $mkfs_opts" >>$seqres.full
> > +
> > +	# dup only works on single device
> > +	if [[ "$mkfs_opts" =~ dup ]]; then
> > +		_scratch_mkfs $mkfs_opts >>$seqres.full 2>&1
> > +	else
> > +		_scratch_pool_mkfs $mkfs_opts >>$seqres.full 2>&1
> > +	fi
> > +	# make sure we created btrfs with desired options
> > +	if [ $? -ne 0 ]; then
> > +		echo "mkfs $mkfs_opts failed"
> > +		return
> > +	fi
> > +	_scratch_mount >>$seqres.full 2>&1
> 
> This mkfs/mount code is repeated in all of the first three tests.
> Factor, please.

OK.

> 
> > +	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT >/dev/null 2>&1
> > +	_scratch_unmount
> > +	_check_scratch_fs
> 
> And why, exactly do we need a special btrfs "sync" before unmount?
> THose three lines should be just one: _check_scratch_fs
> 
> If the test actually requires a special btrfs hack before unmount,
> add a comment explaining why that hack is necessary....

No special reason here, just want to make sure nothing blocks the
umount, will remove it.

Thanks,
Eryu
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
