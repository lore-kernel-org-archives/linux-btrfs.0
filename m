Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20056 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbbHTHLq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 03:11:46 -0400
Message-ID: <55D57D11.8050508@oracle.com>
Date: Thu, 20 Aug 2015 15:09:05 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, eguan@redhat.com,
        fdmanana@gmail.com
Subject: Re: [PATCH v6 1/3] xfstests: btrfs: add functions to create dm-error
 device
References: <1439549224-29784-1-git-send-email-anand.jain@oracle.com> <1439566305-12460-1-git-send-email-anand.jain@oracle.com> <1439566305-12460-2-git-send-email-anand.jain@oracle.com> <20150816235218.GD20596@dastard> <55D2B40E.5040801@oracle.com> <20150818221157.GE3902@dastard> <55D3F4FA.6080309@oracle.com> <20150819064529.GJ3902@dastard>
In-Reply-To: <20150819064529.GJ3902@dastard>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  (thanks for the off-ML emails from the people who helped me
  to understand).

Dave,

  looks like you are suggesting something like..

-------
+_dmerror_mount_options()
+{
+       _scratch_options mount
+       echo $SCRATCH_OPTIONS $MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS \
+                                       $* $DMERROR_DEV $SCRATCH_MNT
+}
+
+_dmerror_mount()
+{
+       _mount -t $FSTYP `_dmerror_mount_options $*`
+}
--------

  Sorry that the word 'should mirror _scratch_mount()' confused me.

  Pls clarify.

Thanks, Anand


 >>> +_mount_dmerror()
 >>> +{
 >>> +	$MOUNT_PROG -t $FSTYP $MOUNT_OPTIONS $DMERROR_DEV $SCRATCH_MNT
 >>> +}


 >> Should mirror _scratch_mount.
 >>
 >> _mount -t $FSTYP `_scratch_mount_options` $DMERROR_DEV $SCRATCH_MNT


 > So I am proposing..

 > +	_mount -t $FSTYP $SCRATCH_OPTIONS $MOUNT_OPTIONS
 > $SELINUX_MOUNT_OPTIONS $* $DMERROR_DEV $SCRATCH_MNT


However, you've still missed the primary reason I suggested
_scratch_mount_options in the first place: what do we do instead of
copy'n'paste of random code fragments?

