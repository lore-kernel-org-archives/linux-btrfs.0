Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:22554 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912Ab2HXESI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 00:18:08 -0400
Date: Fri, 24 Aug 2012 14:18:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com,
        anand.jain@oracle.com
Subject: Re: [PATCH 3/3] xfstests: fix wrong number of the required devices
 and add independent device check for case 265
Message-ID: <20120824041804.GB19235@dastard>
References: <5036F1FB.80205@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5036F1FB.80205@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 24, 2012 at 11:16:11AM +0800, Miao Xie wrote:
> Case 265 need 4 devices to test RAID10, so we need 4 or more devices not 2.
> and it is better that these 4 devices are independent devices, especially
> the 2nd last one, so we add independent device check to check the devices
> in SCRATCH_DEV_POOL.

I don't see any reason for requiring the devices to be independent.
You're basically checking if the devices are on an MD device, which
isn't really a check for indpendent devices. e.g. my 4 devices could
be loopback devices with files all the in the same filesystem, or on
a VM using images at that are all hosted on the same device, or LVM
volumes on top of a single MD device, hardware lun, etc. They are
most certainly not independent, but your test won't pick up any of
them.

Hence the test does not require the devices to be independent to run
correctly.  Sure, the test will run faster if each device is on an
independent spindle, but it's not a requirement for test success or
failure....

> diff --git a/common.rc b/common.rc
> index 602513a..ede25fe 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -1699,12 +1699,14 @@ _require_scratch_dev_pool()
>  		_notrun "this test requires a valid \$SCRATCH_DEV_POOL"
>  	fi
>  
> -	# btrfs test case needs 2 or more scratch_dev_pool; other FS not sure
> +	# btrfs test case needs 4 or more scratch_dev_pool; other FS not sure
>  	# so fail it
> +	# common.config has moved the first device to SCRATCH_DEV, so
> +	# SCRATCH_DEV_POOL should have 3 or more disks.
>  	case $FSTYP in
>  	btrfs)
> -		if [ "`echo $SCRATCH_DEV_POOL|wc -w`" -lt 2 ]; then
> -			_notrun "btrfs and this test needs 2 or more disks in SCRATCH_DEV_POOL"
> +		if [ "`echo $SCRATCH_DEV_POOL|wc -w`" -lt 3 ]; then
> +			_notrun "btrfs and this test needs 4 or more disks in SCRATCH_DEV_POOL"
>  		fi
>  	;;
>  	*)

Rather than changing this every time a new number of disks is
required, change it so that the number of devices required by the
test is passed as a parameter to _require_scratch_dev_pool.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
