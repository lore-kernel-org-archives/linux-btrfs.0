Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54572 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751042AbeA2HKg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 02:10:36 -0500
Subject: Re: [PATCH] btrfs: Fix UAF
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <1516972827-1481-1-git-send-email-nborisov@suse.com>
 <8c70d5d1-16b7-d1a0-b2b1-6282ee12f0b0@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <92e89204-af54-e38f-4a0d-e73b70280cbf@suse.com>
Date: Mon, 29 Jan 2018 09:01:40 +0200
MIME-Version: 1.0
In-Reply-To: <8c70d5d1-16b7-d1a0-b2b1-6282ee12f0b0@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.01.2018 04:38, Anand Jain wrote:
> 
> 
> On 01/26/2018 09:20 PM, Nikolay Borisov wrote:
>> Commit 4fde46f0cc71 ("Btrfs: free the stale device") introduced
>> btrfs_free_stale_device which iterates the device lists for all
>> registered btrfs filesystems and deletes those devices which aren't
>> mounted. In a btrfs_devices structure has only 1 device attached to it
>> and it is unused then btrfs_free_stale_devices will proceed to also
>> free the btrfs_fs_devices struct itself. Currently this leads to a UAF
>> since list_for_each_entry will try to perform a check on the already-
>> freed memory to see if it has to terminated the loop.
>>
>> The fix is to use 'break' when we know we are freeing the current
>> fs_devs.
> 
>  No break is needed as we need to iterate all stale devices and delete
>  the found stale entry, so commit [1] used list_for_each_entry_safe()
>  and removed the break,

We only do the break if we know we have a single device in the current
fs_devs struct. And executing free_fs_devices would have already freed
the device + fs_devs.

> 
>  [1]
>   commit 38cf665d338fca33af4b16f9ec7cad6637fc0fec
>   Author: Anand Jain <Anand.Jain@oracle.com>
>     btrfs: make btrfs_free_stale_device() to iterate all stales
> 
> 
>  I am guessing UAF might be in[2], instead ?
> 
>  [2]
>     free_fs_devices(fs_devs)
> ::
>         while (!list_empty(&fs_devices->devices)) {
>                 device = list_entry(fs_devices->devices.next,
>                                     struct btrfs_device, dev_list);

It's not that, I thought so at first. But here using list_empty you are
awlays accessing the head the of the list, which is guaranteed to be
valid since you do the freeing of fs_devices outside of the while loop.


> 
> Thanks, Anand
> 
>> Fixes: 4fde46f0cc71 ("Btrfs: free the stale device")
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>
>> ---
>>   fs/btrfs/volumes.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index f7147740b68e..c3ab55336ee0 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -645,6 +645,7 @@ static void btrfs_free_stale_devices(const char
>> *path,
>>                   btrfs_sysfs_remove_fsid(fs_devs);
>>                   list_del(&fs_devs->list);
>>                   free_fs_devices(fs_devs);
>> +                break;
>>               } else {
>>                   fs_devs->num_devices--;
>>                   list_del(&dev->dev_list);
>>
> 
