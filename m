Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31781 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbbHRE3c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 00:29:32 -0400
Message-ID: <55D2B40E.5040801@oracle.com>
Date: Tue, 18 Aug 2015 12:26:54 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, eguan@redhat.com,
        fdmanana@gmail.com
Subject: Re: [PATCH v6 1/3] xfstests: btrfs: add functions to create dm-error
 device
References: <1439549224-29784-1-git-send-email-anand.jain@oracle.com> <1439566305-12460-1-git-send-email-anand.jain@oracle.com> <1439566305-12460-2-git-send-email-anand.jain@oracle.com> <20150816235218.GD20596@dastard>
In-Reply-To: <20150816235218.GD20596@dastard>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Dave,

  All comments accepted thanks. except for this.


>> +_mount_dmerror()
>> +{
>> +	$MOUNT_PROG -t $FSTYP $MOUNT_OPTIONS $DMERROR_DEV $SCRATCH_MNT
>> +}
>
> Should mirror _scratch_mount.
>
> _mount -t $FSTYP `_scratch_mount_options` $DMERROR_DEV $SCRATCH_MNT


`_scratch_mount_options` also returns $SCRATCH_DEV.
in case of tests involving dmerror module, dmerror_init would use 
$SCRATCH_DEV as backing device and provide $DMERROR_DEV to be used 
instead of $SCRATCH_DEV. So I am proposing..

+	_mount -t $FSTYP $SCRATCH_OPTIONS $MOUNT_OPTIONS 
$SELINUX_MOUNT_OPTIONS $* $DMERROR_DEV $SCRATCH_MNT



Thanks, Anand

