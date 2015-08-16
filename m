Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:50816 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbbHPXwo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Aug 2015 19:52:44 -0400
Date: Mon, 17 Aug 2015 09:52:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, eguan@redhat.com,
        fdmanana@gmail.com
Subject: Re: [PATCH v6 1/3] xfstests: btrfs: add functions to create dm-error
 device
Message-ID: <20150816235218.GD20596@dastard>
References: <1439549224-29784-1-git-send-email-anand.jain@oracle.com>
 <1439566305-12460-1-git-send-email-anand.jain@oracle.com>
 <1439566305-12460-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439566305-12460-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 14, 2015 at 11:31:43PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> Controlled EIO from the device is achieved using the dm device.
> Helper functions are at common/dmerror.
> 
> Broadly steps will include calling _init_dmerror().
> _init_dmerror() will use SCRATCH_DEV to create dm linear device and assign
> DMERROR_DEV to /dev/mapper/error-test.
> 
> When test script is ready to get EIO, the test cases can call
> _load_dmerror_table() which then it will load the dm error.
> so that reading DMERROR_DEV will cause EIO. After the test case is
> complete, cleanup must be done by calling _cleanup_dmerror().
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> ---
> v5->v6: accepts Eryu's comments
> v4->v5: No Change. keep up with the patch set
> v3->v4: rebase on latest xfstests code
> v2.1->v3: accepts Filipe Manana's review comments, thanks
> v2->v2.1: fixed missed typo error fixup in the commit.
> v1->v2: accepts Dave Chinner's review comments, thanks

This is not a change log. A change log describes the changes that
were made, not who asked for changes to be made. i.e. I have no idea
what changes you actually made from the previous version in this
patch set....

....
> +# common functions for setting up and tearing down a dmerror device
> +
> +_init_dmerror()

All these function names shoul dbe prefixed _dmerror_<blah> so that
it is clear the namespace we are working on. (similar to
_scratch-<blah>, _test_<blah>, etc).

> +{
> +	$DMSETUP_PROG remove error-test > /dev/null 2>&1
> +
> +	local BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`

I think I've said this before - local variables are lower case,
global/exported variables are upper case.

> +
> +	DMERROR_DEV='/dev/mapper/error-test'
> +
> +	DMLINEAR_TABLE="0 $BLK_DEV_SIZE linear $SCRATCH_DEV 0"
> +
> +	$DMSETUP_PROG create error-test --table "$DMLINEAR_TABLE" || \
> +		_fatal "failed to create dm linear device"

That should be _fail...

_fatal() is local to common/config (as it can be included in scripts
without including common/rc). Tests include common/rc (and not
common/config directly), so they should all use _fail...


> +	DMERROR_TABLE="0 $BLK_DEV_SIZE error $SCRATCH_DEV 0"
> +}
> +
> +_scratch_mkfs_dmerror()
> +{
> +	$MKFS_BTRFS_PROG $MKFS_OPTIONS $* $DMERROR_DEV >> $seqres.full 2>&1 || \
> +			_fatal "failed to create mkfs.btrfs $* $DMERROR_DEV"
> +}

This has nothing to do with the scratch device. The test should
simply call '_mkfs_dev $DMERROR_DEV' as there's no need for a
wrapper here.



> +
> +_mount_dmerror()
> +{
> +	$MOUNT_PROG -t $FSTYP $MOUNT_OPTIONS $DMERROR_DEV $SCRATCH_MNT
> +}

Should mirror _scratch_mount.

_mount -t $FSTYP `_scratch_mount_options` $DMERROR_DEV $SCRATCH_MNT

> +
> +_unmount_dmerror()
> +{
> +	$UMOUNT_PROG $SCRATCH_MNT
> +}

Doesn't need a wrapper.

> +
> +_cleanup_dmerror()
> +{
> +	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
> +	$DMSETUP_PROG remove error-test > /dev/null 2>&1
> +}
> +
> +_load_dmerror_table()
> +{
> +	$DMSETUP_PROG suspend error-test
> +	[ $? -ne 0 ] && _fatal  "failed to suspend error-test"

Error message makes no sense when read as the reason for a test
failing. '_fail "dmsetup suspend failed"' makes more sense, as that is the
command that failed.

> +
> +	$DMSETUP_PROG load error-test --table "$DMERROR_TABLE"
> +	[ $? -ne 0 ] && _fatal "failed to load error table error-test"

_fail "dmsetup failed to load error table"

> +
> +	$DMSETUP_PROG resume error-test
> +	[ $? -ne 0 ] && _fatal  "failed to resume error-test"

_fail "dmsetup resume failed"

> +}
> diff --git a/common/rc b/common/rc
> index 70d2fa8..8d4da0e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1337,6 +1337,15 @@ _require_sane_bdev_flush()
>  	fi
>  }
>  
> +# this test requires the device mapper error target
> +#
> +_require_dmerror()
> +{
> +	_require_command "$DMSETUP_PROG" dmsetup
> +	$DMSETUP_PROG targets | grep error >/dev/null 2>&1
> +	[ $? -ne 0 ] && _notrun "This test requires dm error support"
> +}

Why isn't this in common/dmerror?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
