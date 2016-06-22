Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52010 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750718AbcFVVry (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 17:47:54 -0400
Date: Wed, 22 Jun 2016 17:47:05 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH v2 2/2] btrfs: wait for bdev put
To: Anand Jain <anand.jain@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, <holger@applied-asynchrony.com>,
        <dsterba@suse.com>, <xiaolong.ye@intel.com>
Message-ID: <1466632025.28956.0@smtp.office365.com>
In-Reply-To: <1b7bb28b-939e-c111-9bb0-5091ab1cdcf1@oracle.com>
References: <1465901726-15490-2-git-send-email-anand.jain@oracle.com>
	<1466504648-2937-1-git-send-email-anand.jain@oracle.com>
	<0eaf435d-f6e3-31c3-24e2-5a8b1df840a8@fb.com>
	<1b7bb28b-939e-c111-9bb0-5091ab1cdcf1@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, Jun 22, 2016 at 6:18 AM, Anand Jain <anand.jain@oracle.com> 
wrote:
> 
> 
>  Thanks for the review Chris.
> 
> On 06/21/2016 09:00 PM, Chris Mason wrote:
>> On 06/21/2016 06:24 AM, Anand Jain wrote:
>>> From: Anand Jain <Anand.Jain@oracle.com>
>>> 
>>> Further to the commit
>>>       bc178622d40d87e75abc131007342429c9b03351
>>>       btrfs: use rcu_barrier() to wait for bdev puts at unmount
>>> 
>>> This patch implements a method to time wait on the __free_device()
>>> which actually does the bdev put. This is needed as the user space
>>> running 'btrfs fi show -d' immediately after the replace and
>>> unmount, is still reading older information from the device.
>> 
>> Thanks for working on this Anand.  Since it looks like blkdev_put can
>> deadlock against us, can we please switch to making sure we fully 
>> flush
>> the outstanding IO?  It's probably enough to do a sync_blockdev() 
>> call
>> before we allow the unmount to finish, but we can toss in an
>> invalidate_bdev for good measure.
> 
> 
> ------------
> # git diff
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 604daf315669..e0ad29d6fe9a 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -870,6 +870,11 @@ static void btrfs_close_one_device(struct 
> btrfs_device *device)
>         if (device->missing)
>                 fs_devices->missing_devices--;
> 
> +       if (device->bdev && device->writeable) {
> +               sync_blockdev(device->bdev);
> +               invalidate_bdev(device->bdev);
> +       }
> +
>         new_device = btrfs_alloc_device(NULL, &device->devid,
>                                         device->uuid);
>         BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
> -----------
> 
> 
>  However, theoretically still there might be a problem - at the end of
>  unmount, if the device exclusive open is not actually closed, then
>  there might be a race with another program which is trying to open
>  the device in exclusive mode. Like for eg:
>       unmount /btrfs; fsck /dev/X
>  and here fsck might fail to open the device if it wins the race.

This true, but at least we know he'll have up to date buffers if he 
does manage to open the device.

With the generic code, the blkdev_put happens after the super is gone, 
so I'm not sure we can completely fix this from inside our callback.

-chris



