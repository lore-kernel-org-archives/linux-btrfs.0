Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:37386 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157AbbHRWVs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 18:21:48 -0400
Date: Wed, 19 Aug 2015 08:11:57 +1000
From: Dave Chinner <david@fromorbit.com>
To: anand jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, eguan@redhat.com,
        fdmanana@gmail.com
Subject: Re: [PATCH v6 1/3] xfstests: btrfs: add functions to create dm-error
 device
Message-ID: <20150818221157.GE3902@dastard>
References: <1439549224-29784-1-git-send-email-anand.jain@oracle.com>
 <1439566305-12460-1-git-send-email-anand.jain@oracle.com>
 <1439566305-12460-2-git-send-email-anand.jain@oracle.com>
 <20150816235218.GD20596@dastard>
 <55D2B40E.5040801@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55D2B40E.5040801@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 18, 2015 at 12:26:54PM +0800, anand jain wrote:
> 
> Hi Dave,
> 
>  All comments accepted thanks. except for this.
> 
> 
> >>+_mount_dmerror()
> >>+{
> >>+	$MOUNT_PROG -t $FSTYP $MOUNT_OPTIONS $DMERROR_DEV $SCRATCH_MNT
> >>+}
> >
> >Should mirror _scratch_mount.
> >
> >_mount -t $FSTYP `_scratch_mount_options` $DMERROR_DEV $SCRATCH_MNT
> 
> 
> `_scratch_mount_options` also returns $SCRATCH_DEV.
> in case of tests involving dmerror module, dmerror_init would use
> $SCRATCH_DEV as backing device and provide $DMERROR_DEV to be used
> instead of $SCRATCH_DEV. So I am proposing..
> 
> +	_mount -t $FSTYP $SCRATCH_OPTIONS $MOUNT_OPTIONS
> $SELINUX_MOUNT_OPTIONS $* $DMERROR_DEV $SCRATCH_MNT

Ok, SCRATCH_OPTIONS might not be the best idea here, so feel free to
drop it.

However, you've still missed the primary reason I suggested
_scratch_mount_options in the first place: what do we do instead of
copy'n'paste of random code fragments?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
