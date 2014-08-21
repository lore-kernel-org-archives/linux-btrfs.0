Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbaHULSa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 07:18:30 -0400
Date: Thu, 21 Aug 2014 19:18:22 +0800
From: Eryu Guan <eguan@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/15] btrfs: new test to run btrfs balance and subvolume
 test simultaneously
Message-ID: <20140821111822.GE2977@dhcp-13-216.nay.redhat.com>
References: <1408556044-907-1-git-send-email-eguan@redhat.com>
 <1408556044-907-3-git-send-email-eguan@redhat.com>
 <53F553AE.5060707@cn.fujitsu.com>
 <20140821090105.GJ26465@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20140821090105.GJ26465@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 21, 2014 at 07:01:05PM +1000, Dave Chinner wrote:
> On Thu, Aug 21, 2014 at 10:04:30AM +0800, Qu Wenruo wrote:
> > 
> > -------- Original Message --------
> > Subject: [PATCH 01/15] btrfs: new test to run btrfs balance and
> > subvolume test simultaneously
> > From: Eryu Guan <eguan@redhat.com>
> > To: <fstests@vger.kernel.org>
> > Date: 2014年08月21日 01:33
> > >Run btrfs balance and subvolume create/mount/umount/delete simultaneously,
> > >with fsstress running in background.
> > >
> > >Signed-off-by: Eryu Guan <eguan@redhat.com>
[snip]
> > >+# real QA test starts here
> > >+_supported_fs btrfs
> > >+_supported_os Linux
> > >+_require_scratch
> > >+_require_scratch_dev_pool 4
> > >+
> > >+rm -f $seqres.full
> > >+
> > >+# test case array
> > >+tcs=(
> > >+	"-m single -d single"
> > >+	"-m dup -d single"
> > >+	"-m raid0 -d raid0"
> > >+	"-m raid1 -d raid0"
> > >+	"-m raid1 -d raid1"
> > >+	"-m raid10 -d raid10"
> > >+	"-m raid5 -d raid5"
> > >+	"-m raid6 -d raid6"
> > >+)
> > I wonder should we add the mkfs options there.
> > Since xfstests already use environment MKFS_OPTIONS to do mkfs,
> > if really need to test all mkfs options, IMO it is better to change
> > MKFS_OPTIONS on each test round.
> 
> Hmmm - I you didn't read the code, because:
> 
> > >+run_test()
> > >+{
> > >+	local mkfs_opts=$1
> > >+	local saved_mkfs_opts=$MKFS_OPTIONS
> > >+	local subvol_mnt=$tmp.mnt
> > >+
> > >+	echo "Test $mkfs_opts" >>$seqres.full
> > >+
> > >+	MKFS_OPTIONS="$MKFS_OPTIONS $mkfs_opts"
> > >+	# dup only works on single device
> 
> it's doing exactly what you suggest.
> 
> And it's wrong. This:
> 
> _scratch_mkfs $mkfs_opts
> 
> is all that is needed. This wheel does not need reinventing. ;)

I just noticed _scratch_pool_mkfs could do the same, thanks for the reminder!

Thanks,
Eryu
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
