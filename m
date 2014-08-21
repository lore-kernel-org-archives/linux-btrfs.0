Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:22239 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791AbaHUJ3z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 05:29:55 -0400
Date: Thu, 21 Aug 2014 19:29:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/15] btrfs: new test to run btrfs balance and subvolume
 test simultaneously
Message-ID: <20140821092952.GL26465@dastard>
References: <1408556044-907-1-git-send-email-eguan@redhat.com>
 <1408556044-907-3-git-send-email-eguan@redhat.com>
 <53F553AE.5060707@cn.fujitsu.com>
 <20140821090105.GJ26465@dastard>
 <53F5B895.3000403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <53F5B895.3000403@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 21, 2014 at 05:15:01PM +0800, Qu Wenruo wrote:
> 
> -------- Original Message --------
> Subject: Re: [PATCH 01/15] btrfs: new test to run btrfs balance and
> subvolume test simultaneously
> From: Dave Chinner <david@fromorbit.com>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2014年08月21日 17:01
> >On Thu, Aug 21, 2014 at 10:04:30AM +0800, Qu Wenruo wrote:
> >>-------- Original Message --------
> >>Subject: [PATCH 01/15] btrfs: new test to run btrfs balance and
> >>subvolume test simultaneously
> >>From: Eryu Guan <eguan@redhat.com>
> >>To: <fstests@vger.kernel.org>
> >>Date: 2014年08月21日 01:33
> >>>Run btrfs balance and subvolume create/mount/umount/delete simultaneously,
> >>>with fsstress running in background.
....
> >>>+# test case array
> >>>+tcs=(
> >>>+	"-m single -d single"
> >>>+	"-m dup -d single"
> >>>+	"-m raid0 -d raid0"
> >>>+	"-m raid1 -d raid0"
> >>>+	"-m raid1 -d raid1"
> >>>+	"-m raid10 -d raid10"
> >>>+	"-m raid5 -d raid5"
> >>>+	"-m raid6 -d raid6"
> >>>+)
> >>I wonder should we add the mkfs options there.
> >>Since xfstests already use environment MKFS_OPTIONS to do mkfs,
> >>if really need to test all mkfs options, IMO it is better to change
> >>MKFS_OPTIONS on each test round.
> >Hmmm - I you didn't read the code, because:
> >
> >>>+run_test()
> >>>+{
> >>>+	local mkfs_opts=$1
> >>>+	local saved_mkfs_opts=$MKFS_OPTIONS
> >>>+	local subvol_mnt=$tmp.mnt
> >>>+
> >>>+	echo "Test $mkfs_opts" >>$seqres.full
> >>>+
> >>>+	MKFS_OPTIONS="$MKFS_OPTIONS $mkfs_opts"
> >>>+	# dup only works on single device
> >it's doing exactly what you suggest.
> I am afraid that you misunderstand what I mean...
> I just mean these mount option should be done by setting environment
> before runing check or set in local.conf.

You can override or append to MKFS_OPTIONS and MOUNT_OPTIONS in
tests if required - lots of tests do exactly that (e.g. any quota
test your care to name). That modification, however, is only valid
for the specific test being run because the modification is to the
environment of the test process, not the environment of check
process that is running the tests....

i.e. Running custom mkfs or mount options like this is perfectly
acceptable and I'm just commenting that the implementation of those
custom options could be a lot better.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
