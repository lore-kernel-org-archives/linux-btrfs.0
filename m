Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425942AbcBRJxV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 04:53:21 -0500
Date: Thu, 18 Feb 2016 10:53:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 12/13] btrfs: introduce device delete by devid
Message-ID: <20160218095314.GX4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
 <1455328900-1476-13-git-send-email-anand.jain@oracle.com>
 <20160217104911.GS4374@twin.jikos.cz>
 <56C56BCE.3020009@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56C56BCE.3020009@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 18, 2016 at 02:59:26PM +0800, Anand Jain wrote:
> #define BTRFS_PATH_NAME_MAX 4087
> #define BTRFS_SUBVOL_NAME_MAX 4039
> 
>   I am fine with using BTRFS_SUBVOL_NAME_MAX for now. But theoretical
>   anomaly is that add-device code path will use BTRFS_PATH_NAME_MAX and
>   delete device will use BTRFS_SUBVOL_NAME_MAX.. its only theoretical
>   as most of the devices path are well below 4k IMO. So its a good
>   trade off than other solutions like.. (just for the understanding),
> 
>     - Update add device code as well to use btrfs_ioctl_vol_args_v2
>       Which means we need to introduce BTRFS_IOC_ADD_DEV_V2 (system
>       PATH_MAX is 4096).
> 
>     OR
> 
>     - Create new btrfs_ioctl_vol_args_v3 with name[BTRFS_PATH_NAME_MAX+1]
>     (instead of name[BTRFS_SUBVOL_NAME_MAX+1]) and BTRFS_IOC_RM_DEV_V2
>     will be the only consumer of btrfs_ioctl_vol_args_v3 as of now.

I'd rather not introduce any new structures or ioctls, the problem seems
to be marginal. As mentioned, paths are way shorter than 4k. A symlink
can be used as a workaround. We can document that.

The use of BTRFS_SUBVOL_NAME_MAX is confusing for devices, we can do

#define BTRFS_DEVICE_PATH_MAX	BTRFS_SUBVOL_NAME_MAX
