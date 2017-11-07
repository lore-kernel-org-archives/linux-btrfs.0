Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48110 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752119AbdKGIcs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Nov 2017 03:32:48 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA78WkSw009626
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Nov 2017 08:32:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA78WkQ6023123
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Nov 2017 08:32:46 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vA78WkFt020712
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Nov 2017 08:32:46 GMT
Subject: Re: [PATCH 2/4] Btrfs: fix data corruption in raid6
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171102005405.20420-1-bo.li.liu@oracle.com>
 <20171102005405.20420-3-bo.li.liu@oracle.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <133f72d7-4254-ccd4-76e5-1078f0b8a079@oracle.com>
Date: Tue, 7 Nov 2017 16:32:55 +0800
MIME-Version: 1.0
In-Reply-To: <20171102005405.20420-3-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/02/2017 08:54 AM, Liu Bo wrote:
> With raid6 profile, btrfs can end up with data corruption by the
> following steps.
> 
> Say we have a 5 disks that are set up with raid6 profile,
> 
> 1) mount this btrfs
> 2) one disk gets pulled out
> 3) write something to btrfs and sync
> 4) another disk gets pulled out
> 5) write something to btrfs and sync
> 6) umount this btrfs
> 7) bring the two disk back
> 8) reboot
> 9) mount this btrfs
> 
> Chances are mount will fail (even with -odegraded) because of failure
> on reading metadata blocks, IOW, our raid6 setup is not able to
> protect two disk failures in some cases.
> 
> So it turns out that there is a bug in raid6's recover code, that is,
> 
> if we have one of stripes in the raid6 layout as shown here,
> 
> | D1(*)  | D2(*)  | D3 | D4 | D5    |
> -------------------------------------
> | data1  | data2  | P  | Q  | data0 |


> D1 and D2 are the two disks which got pulled out and brought back.
> When mount reads data1 and finds out that data1 doesn't match its crc,
> btrfs goes to recover data1 from other stripes, what it'll be doing is
> 
> 1) read data2, parity P, parity Q and data0
>
> 2) as we have a valid parity P and two data stripes, it goes to
>     recover in raid5 style.


> (However, since disk D2 was pulled out and data2 on D2 could be stale,

  data2 should end up crc error, if not then raid5 recover is as
  expected OR this example is confusing to explain the context of
  two data stipe missing.

Thanks, Anand


> we still get the wrong data1 from this reconstruction.)
> 
> 3) btrfs continues to try to reconstruct data1 from parity Q, data2
>     and data0, we still get the wrong one for the same reason.
> 
> The fix here is to take advantage of the device flag, ie. 'In_sync',
> all data on a device might be stale if 'In_sync' has not been set.
 >
> With this, we can build the correct data2 from parity P, Q and data1.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>   fs/btrfs/raid56.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 67262f8..3c0ce61 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1076,7 +1076,8 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
>   	disk_start = stripe->physical + (page_index << PAGE_SHIFT);
>   
>   	/* if the device is missing, just fail this stripe */
> -	if (!stripe->dev->bdev)
> +	if (!stripe->dev->bdev ||
> +	    !test_bit(In_sync, &stripe->dev->flags))
>   		return fail_rbio_index(rbio, stripe_nr);
>   
>   	/* see if we can add this page onto our existing bio */
> 
