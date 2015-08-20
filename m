Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:14732 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbbHTVpO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 17:45:14 -0400
Date: Fri, 21 Aug 2015 07:45:11 +1000
From: Dave Chinner <david@fromorbit.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, eguan@redhat.com,
        fdmanana@gmail.com
Subject: Re: [PATCH v6 1/3] xfstests: btrfs: add functions to create dm-error
 device
Message-ID: <20150820214511.GP3902@dastard>
References: <1439549224-29784-1-git-send-email-anand.jain@oracle.com>
 <1439566305-12460-1-git-send-email-anand.jain@oracle.com>
 <1439566305-12460-2-git-send-email-anand.jain@oracle.com>
 <20150816235218.GD20596@dastard>
 <55D2B40E.5040801@oracle.com>
 <20150818221157.GE3902@dastard>
 <55D3F4FA.6080309@oracle.com>
 <20150819064529.GJ3902@dastard>
 <55D57D11.8050508@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55D57D11.8050508@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 20, 2015 at 03:09:05PM +0800, Anand Jain wrote:
> 
>  (thanks for the off-ML emails from the people who helped me
>  to understand).
> 
> Dave,
> 
>  looks like you are suggesting something like..
> 
> -------
> +_dmerror_mount_options()
> +{
> +       _scratch_options mount
> +       echo $SCRATCH_OPTIONS $MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS \
> +                                       $* $DMERROR_DEV $SCRATCH_MNT
> +}
> +
> +_dmerror_mount()
> +{
> +       _mount -t $FSTYP `_dmerror_mount_options $*`
> +}
> --------

Very close. :)

You've got the structure right, but missed one more thing: the
options are still cut'n'paste from _scratch_mount_options, and so
should be /factored/ into a common function...

_scratch_options is only useful to XFS to set external log/realtime
devices, and we don't want to do that for the dmerror device.
Everthing else is almost the same as _scratch_mount_options(),
however.  So:

# Used for mounting non-scratch devices (e.g. loop, dm constructs)
# with the safe set of scratch mount options (e.g. loop image may be
# hosted on $SCRATCH_DEV, so can't use external scratch devices).
_common_dev_mount_options()
{
	echo $MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS $*
}

_scratch_mount_options()
{
	_scratch_options mount

	echo `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
					    $SCRATCH_DEV $SCRATCH_MNT

}

_dmerror_mount_options()
{
       echo `_common_dev_mount_options $*` $DMERROR_DEV $SCRATCH_MNT
}

And to demonstrate why factoring like this is useful, this can also
be applied to _mount_flakey(), and we could also replace most of the
open-coded loop device mounts with a generic "mount device" function
like:

_mount_dev()
{
	_mount `_common_dev_mount_options $*`
}

and call it like:

_mount_dev $LOOP_DEV $MNT_POINT

or even

_mount_dev -o loop $MNT_POINT

We can then take it further: if we have a _mount_dev() wrapper we
can factor _common_dev_mount_options() from all the
_*_mount_options() functions. i.e:

_scratch_mount_options()
{
	_scratch_options mount

	echo $SCRATCH_OPTIONS $SCRATCH_DEV $SCRATCH_MNT
}

_scratch_mount()
{
	_mount_dev $* `_scratch_mount_options`
}

The result is we end up with a much cleaner set of mount functions
that are more generic, more extensible and easier to use, as well as
being more maintainable....

>  Sorry that the word 'should mirror _scratch_mount()' confused me.

Ok, I'll try to be more clear in future.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
