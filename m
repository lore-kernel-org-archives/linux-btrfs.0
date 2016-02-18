Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23418 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424863AbcBRG7c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 01:59:32 -0500
Subject: Re: [PATCH v4 12/13] btrfs: introduce device delete by devid
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
 <1455328900-1476-13-git-send-email-anand.jain@oracle.com>
 <20160217104911.GS4374@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56C56BCE.3020009@oracle.com>
Date: Thu, 18 Feb 2016 14:59:26 +0800
MIME-Version: 1.0
In-Reply-To: <20160217104911.GS4374@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/17/2016 06:49 PM, David Sterba wrote:
> On Sat, Feb 13, 2016 at 10:01:39AM +0800, Anand Jain wrote:
>> +	if (vol_args->flags & BTRFS_DEVICE_BY_ID) {
>> +		ret = btrfs_rm_device(root, NULL, vol_args->devid);
>> +	} else {
>> +		vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
>
> 			       BTRFS_SUBVOL_NAME_MAX
>
> Spotted by Chris,
>
> fs/btrfs/ioctl.c:2703: warning: array subscript is above array bounds
>
> my gcc version does not report that. Fixed and for-next pushed.

  mine either. Sorry about that, thanks for the catch.

#define BTRFS_PATH_NAME_MAX 4087
#define BTRFS_SUBVOL_NAME_MAX 4039

  I am fine with using BTRFS_SUBVOL_NAME_MAX for now. But theoretical
  anomaly is that add-device code path will use BTRFS_PATH_NAME_MAX and
  delete device will use BTRFS_SUBVOL_NAME_MAX.. its only theoretical
  as most of the devices path are well below 4k IMO. So its a good
  trade off than other solutions like.. (just for the understanding),

    - Update add device code as well to use btrfs_ioctl_vol_args_v2
      Which means we need to introduce BTRFS_IOC_ADD_DEV_V2 (system
      PATH_MAX is 4096).

    OR

    - Create new btrfs_ioctl_vol_args_v3 with name[BTRFS_PATH_NAME_MAX+1]
    (instead of name[BTRFS_SUBVOL_NAME_MAX+1]) and BTRFS_IOC_RM_DEV_V2
    will be the only consumer of btrfs_ioctl_vol_args_v3 as of now.


Thanks, Anand




