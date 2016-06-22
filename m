Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42890 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbcFVKSc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 06:18:32 -0400
Subject: Re: [PATCH v2 2/2] btrfs: wait for bdev put
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
References: <1465901726-15490-2-git-send-email-anand.jain@oracle.com>
 <1466504648-2937-1-git-send-email-anand.jain@oracle.com>
 <0eaf435d-f6e3-31c3-24e2-5a8b1df840a8@fb.com>
Cc: holger@applied-asynchrony.com, dsterba@suse.com, xiaolong.ye@intel.com
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <1b7bb28b-939e-c111-9bb0-5091ab1cdcf1@oracle.com>
Date: Wed, 22 Jun 2016 18:18:45 +0800
MIME-Version: 1.0
In-Reply-To: <0eaf435d-f6e3-31c3-24e2-5a8b1df840a8@fb.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Thanks for the review Chris.

On 06/21/2016 09:00 PM, Chris Mason wrote:
> On 06/21/2016 06:24 AM, Anand Jain wrote:
>> From: Anand Jain <Anand.Jain@oracle.com>
>>
>> Further to the commit
>>       bc178622d40d87e75abc131007342429c9b03351
>>       btrfs: use rcu_barrier() to wait for bdev puts at unmount
>>
>> This patch implements a method to time wait on the __free_device()
>> which actually does the bdev put. This is needed as the user space
>> running 'btrfs fi show -d' immediately after the replace and
>> unmount, is still reading older information from the device.
>
> Thanks for working on this Anand.  Since it looks like blkdev_put can
> deadlock against us, can we please switch to making sure we fully flush
> the outstanding IO?  It's probably enough to do a sync_blockdev() call
> before we allow the unmount to finish, but we can toss in an
> invalidate_bdev for good measure.


------------
# git diff
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 604daf315669..e0ad29d6fe9a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -870,6 +870,11 @@ static void btrfs_close_one_device(struct 
btrfs_device *device)
         if (device->missing)
                 fs_devices->missing_devices--;

+       if (device->bdev && device->writeable) {
+               sync_blockdev(device->bdev);
+               invalidate_bdev(device->bdev);
+       }
+
         new_device = btrfs_alloc_device(NULL, &device->devid,
                                         device->uuid);
         BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
-----------


  However, theoretically still there might be a problem - at the end of
  unmount, if the device exclusive open is not actually closed, then
  there might be a race with another program which is trying to open
  the device in exclusive mode. Like for eg:
       unmount /btrfs; fsck /dev/X
  and here fsck might fail to open the device if it wins the race.


> Then we can get rid of the mdelay loop completely, which seems pretty
> error prone to me.

  Yes, the code got little complex here (and also when sysfs fixes
  were wrote) as struct btrfs_device is getting migrated to a new
  struct btrfs_device at unmount, which I don't think was necessary?


Thanks, Anand


> Thanks!
>
> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
