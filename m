Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38390 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933382AbdKGJaJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Nov 2017 04:30:09 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA79U7UW005553
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Nov 2017 09:30:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vA79U763020858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Nov 2017 09:30:07 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA79U7s3030741
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Nov 2017 09:30:07 GMT
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 1/4] Btrfs: introduce device flags
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171102005405.20420-1-bo.li.liu@oracle.com>
 <20171102005405.20420-2-bo.li.liu@oracle.com>
Message-ID: <e03b68bf-c120-715c-191e-2c07819a949f@oracle.com>
Date: Tue, 7 Nov 2017 17:30:16 +0800
MIME-Version: 1.0
In-Reply-To: <20171102005405.20420-2-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/02/2017 08:54 AM, Liu Bo wrote:
> Here we have defined two flags,
> - Fautly
> - In_sync
> 
> Currently only In_sync is in use, it only matters when device serves
> as part of a raid profile.  The flag In_sync is decided when mounting
> a btrfs and opening a device, by default every device is set with
> In_sync, but would not be set if its generation was out of date.
> 
> If the device doesn't get resync and to avoid overriding its
> generation during writing superblock, if the !In_sync device is still
> writeable, its last valid generation will be recorded in
> superblock.dev_item.generation instead of superblock.generation, such
> that the last valid generation can be retained through several reboot,
> btrfs is able to detect the out-of-sync device.

  Based on the bug you are trying to address in patch 2/4.
  - I still don't get the point the need for explicit flag
  In_Sync for the whole disk and not just depend on stripe
  for which anyway crc will fail ?
  - Here whole disk isn't the problem. Only the stripe which
  were missed on the missing disk is the problem.

> @@ -6592,6 +6625,14 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
>   				return -EIO;
>   		}
>   
> +		if (!test_bit(In_sync, &device->flags) &&
> +		    !btrfs_test_opt(fs_info, DEGRADED)) {
> +			btrfs_warn(fs_info,
> +				   "devid %llu uuid %pU is Not in_sync, but we're not under degraded mode",
> +				   devid, dev_uuid);
> +			return -EIO;
> +		}
> +

  degrade option is for the missing device and if user still want to
  continue, here its about device with not_In_Sync flag, degrade option
  check is not required.

  Similarly the test case should be updated as well.

Thanks, Anand
