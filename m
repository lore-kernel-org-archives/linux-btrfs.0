Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbbHNLDY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 07:03:24 -0400
Date: Fri, 14 Aug 2015 19:03:21 +0800
From: Eryu Guan <eguan@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v5 1/3] xfstests: btrfs: add functions to create dm-error
 device
Message-ID: <20150814110321.GO17933@dhcp-13-216.nay.redhat.com>
References: <1439549224-29784-1-git-send-email-anand.jain@oracle.com>
 <1439549224-29784-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439549224-29784-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 14, 2015 at 06:47:02PM +0800, Anand Jain wrote:
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
> v4->v5: No Change. keep up with the patch set
> v3->v4: rebase on latest xfstests code
> v2.1->v3: accepts Filipe Manana's review comments, thanks
> v2->v2.1: fixed missed typo error fixup in the commit.
> v1->v2: accepts Dave Chinner's review comments, thanks
>  common/dmerror | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  common/rc      |  9 ++++++++
>  2 files changed, 78 insertions(+)
>  create mode 100644 common/dmerror
> 
> diff --git a/common/dmerror b/common/dmerror
> new file mode 100644
> index 0000000..f895d90
> --- /dev/null
> +++ b/common/dmerror
> @@ -0,0 +1,69 @@
> +##/bin/bash
> +#
> +# Copyright (c) 2015 Oracle.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#
> +#
> +# common functions for setting up and tearing down a dmerror device
> +
> +_init_dmerror()
> +{
> +	$DMSETUP_PROG remove error-test > /dev/null 2>&1
> +
> +	local BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> +
> +	DMERROR_DEV='/dev/mapper/error-test'
> +
> +	DMLINEAR_TABLE="0 $BLK_DEV_SIZE linear $SCRATCH_DEV 0"
> +
> +	$DMSETUP_PROG create error-test --table "$DMLINEAR_TABLE" || \
> +		_fatal "failed to create dm linear device"
> +
> +	DMERROR_TABLE="0 $BLK_DEV_SIZE error $SCRATCH_DEV 0"
> +}
> +
> +_scratch_mkfs_dmerror()
> +{
> +	$MKFS_BTRFS_PROG $* $DMERROR_DEV >> $seqres.full 2>&1 || \
> +			_fatal "failed to create mkfs.btrfs $* $DMERROR_DEV"

I didn't follow previous reviews, please correct me if I miss anything.

Is dmerror only for btrfs testing? I saw $MKFS_BTRFS_PROG here. And do
we need $MKFS_OPTIONS too?

> +}
> +
> +_mount_dmerror()
> +{
> +	mount -t $FSTYP $MOUNT_OPTIONS $DMERROR_DEV $SCRATCH_MNT

$MOUNT_PROG ?

> +}
> +
> +_unmount_dmerror()
> +{
> +	$UMOUNT_PROGS $SCRATCH_MNT

$UMOUNT_PROG, no S at the end.

Thanks,
Eryu

> +}
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
> +
> +	$DMSETUP_PROG load error-test --table "$DMERROR_TABLE"
> +	[ $? -ne 0 ] && _fatal "failed to load error table error-test"
> +
> +	$DMSETUP_PROG resume error-test
> +	[ $? -ne 0 ] && _fatal  "failed to resume error-test"
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
> +
>  # this test requires the device mapper flakey target
>  #
>  _require_dm_flakey()
> -- 
> 2.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
