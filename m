Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40741 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbdKIJ3N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Nov 2017 04:29:13 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA99TCmB006857
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 09:29:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA99TCwG006304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 09:29:12 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA99TCsJ010284
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 09:29:12 GMT
Subject: Re: [PATCH 2/4] Btrfs: fix data corruption in raid6
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
References: <20171102005405.20420-1-bo.li.liu@oracle.com>
 <20171102005405.20420-3-bo.li.liu@oracle.com>
 <133f72d7-4254-ccd4-76e5-1078f0b8a079@oracle.com>
 <20171108195315.GB14443@dhcp-10-11-181-32.int.fusionio.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ca33de53-1894-09d9-240d-d0f128a5fc83@oracle.com>
Date: Thu, 9 Nov 2017 17:29:25 +0800
MIME-Version: 1.0
In-Reply-To: <20171108195315.GB14443@dhcp-10-11-181-32.int.fusionio.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/09/2017 03:53 AM, Liu Bo wrote:
> On Tue, Nov 07, 2017 at 04:32:55PM +0800, Anand Jain wrote:
>>
>>
>> On 11/02/2017 08:54 AM, Liu Bo wrote:
>>> With raid6 profile, btrfs can end up with data corruption by the
>>> following steps.
>>>
>>> Say we have a 5 disks that are set up with raid6 profile,
>>>
>>> 1) mount this btrfs
>>> 2) one disk gets pulled out
>>> 3) write something to btrfs and sync
>>> 4) another disk gets pulled out
>>> 5) write something to btrfs and sync
>>> 6) umount this btrfs
>>> 7) bring the two disk back
>>> 8) reboot
>>> 9) mount this btrfs
>>>
>>> Chances are mount will fail (even with -odegraded) because of failure
>>> on reading metadata blocks, IOW, our raid6 setup is not able to
>>> protect two disk failures in some cases.
>>>
>>> So it turns out that there is a bug in raid6's recover code, that is,
>>>
>>> if we have one of stripes in the raid6 layout as shown here,
>>>
>>> | D1(*)  | D2(*)  | D3 | D4 | D5    |
>>> -------------------------------------
>>> | data1  | data2  | P  | Q  | data0 |
>>
>>
>>> D1 and D2 are the two disks which got pulled out and brought back.
>>> When mount reads data1 and finds out that data1 doesn't match its crc,
>>> btrfs goes to recover data1 from other stripes, what it'll be doing is
>>>
>>> 1) read data2, parity P, parity Q and data0
>>>
>>> 2) as we have a valid parity P and two data stripes, it goes to
>>>     recover in raid5 style.
>>
>>
>>> (However, since disk D2 was pulled out and data2 on D2 could be stale,
>>
>>   data2 should end up crc error, if not then raid5 recover is as
>>   expected OR this example is confusing to explain the context of
>>   two data stipe missing.
> 
> The assumption you have is not true, 

> when doing reconstruction, we
> don't verify checksum for each data stripe that is read from disk.

  Why ? what if data0 (which has InSync flag) was wrong ?

  I am wary about the In_sync approach. IMO we are loosing the
  advantage of FS being merged with volume manager - which is to
  know exactly which active stripes were lost for quicker reconstruct.

  Lets say RAID6 is 50% full and disk1 is pulled out, and at 75%
  full disk2 is pulled out and reaches 90% full.

  So now when all the disks are back, two disks will not have
  In_sync flag? hope I understood this correctly.

  Now.
  15% of the data have lost two stripes.
  25% of the data have lost one stripe.
  50% of the data did not loose any stripe at all.

  Now for read and reconstruct..
  50% of the data does not need any reconstruction.
  25% of the data needs RAID5 style reconstruction as they have lost 
only one stripe.
  15% of the data needs RAID6 reconstruction since they have lost two 
stripes.

  Does InSync design here help to work like this ?

  Now for RAID1, lets say disk1 lost first 10% of the stripes and
  disk2 lost the last 10% of the stripes and these stripes are mutually
  exclusive. That means there is no single stripe which has lost
  completely.

  There is no code yet where I can see when the In_sync will be reset,
  which is fine for this eg. Assume no reconstruction is done. But now
  when both the disks are being mounted and as the In_sync will be based
  on dev_item.generation, one of it will get In_sync to me it looks like
  there will be 10% of stripes which will fail even though its not
  practically true in this example.


Thanks, Anand



> Thanks,
> 
> -liubo
>>
>> Thanks, Anand
>>
>>
>>> we still get the wrong data1 from this reconstruction.)
>>>
>>> 3) btrfs continues to try to reconstruct data1 from parity Q, data2
>>>     and data0, we still get the wrong one for the same reason.
>>>
>>> The fix here is to take advantage of the device flag, ie. 'In_sync',
>>> all data on a device might be stale if 'In_sync' has not been set.
>>>
>>> With this, we can build the correct data2 from parity P, Q and data1.
>>>
>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>>> ---
>>>   fs/btrfs/raid56.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
>>> index 67262f8..3c0ce61 100644
>>> --- a/fs/btrfs/raid56.c
>>> +++ b/fs/btrfs/raid56.c
>>> @@ -1076,7 +1076,8 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
>>>   	disk_start = stripe->physical + (page_index << PAGE_SHIFT);
>>>   	/* if the device is missing, just fail this stripe */
>>> -	if (!stripe->dev->bdev)
>>> +	if (!stripe->dev->bdev ||
>>> +	    !test_bit(In_sync, &stripe->dev->flags))
>>>   		return fail_rbio_index(rbio, stripe_nr);
>>>   	/* see if we can add this page onto our existing bio */
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
