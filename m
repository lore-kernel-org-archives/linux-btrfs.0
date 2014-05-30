Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60108 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751665AbaE3Imv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 04:42:51 -0400
Message-ID: <538844C8.6060800@cn.fujitsu.com>
Date: Fri, 30 May 2014 16:43:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>, <linux-btrfs@vger.kernel.org>
CC: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH RFC] btrfs: Add ctime/mtime update for btrfs device add/remove.
References: <1397638952-16691-1-git-send-email-quwenruo@cn.fujitsu.com> <53883883.8020608@oracle.com>
In-Reply-To: <53883883.8020608@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH RFC] btrfs: Add ctime/mtime update for btrfs device 
add/remove.
From: Anand Jain <Anand.Jain@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: 2014年05月30日 15:51
>
>
>
>
> Hi Qu,
>
>  In line below...
>
> On 16/04/14 17:02, Qu Wenruo wrote:
>> Btrfs will send uevent to udev inform the device change,
>> but ctime/mtime for the block device inode is not udpated, which cause
>> libblkid used by btrfs-progs unable to detect device change and use old
>> cache, causing 'btrfs dev scan; btrfs dev rmove; btrfs dev scan' give an
>> error message.
>>
>> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> Cc: Karel Zak <kzak@redhat.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>   fs/btrfs/volumes.c | 26 ++++++++++++++++++++++++--
>>   1 file changed, 24 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 49d7fab..ce232d7 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1452,6 +1452,22 @@ out:
>>       return ret;
>>   }
>>
>> +/*
>> + * Function to update ctime/mtime for a given device path.
>> + * Mainly used for ctime/mtime based probe like libblkid.
>> + */
>> +static void update_dev_time(char *path_name)
>> +{
>> +    struct file *filp;
>> +
>> +    filp = filp_open(path_name, O_RDWR, 0);
>> +    if (!filp)
>> +        return;
>> +    file_update_time(filp);
>> +    filp_close(filp, NULL);
>> +    return;
>> +}
>> +
>
>   IMO /(I might be wrong) I think its not a good idea to explicitly
>   achieve this. Since this thread would have already scratched the
>   device's SB, shouldn't that take care of updating the mtime ?
>
> Thanks, Anand
Yes, scratching SB will update the time of the device's inode.
But the problem is that, the *block file*'s ctime/mtime is not changed 
according to the device's inode mtime/ctime.

So in the patch, I use the device's *full path* not the *device's inode* 
to update ctime/mtime since kernel operations
will not update ctime/mtine of *device files under /dev*.

About your fix patch ([PATCH] btrfs: kobject_uevent should use bd_part 
instead of bd_disk )
I am unable to reproduce the problem on 3.15-rc4 kernel with 3.14.1 
btrfs-progs. :(

But the ctime/mtime things will not change as the following example:
------
# btrfs dev scan;stat /dev/sdd ; btrfs dev del /dev/sdd 
/mnt/scratch/;stat /dev/sdd ; btrfs dev scan
Scanning for Btrfs filesystems
   File: '/dev/sdd'
   Size: 0             Blocks: 0          IO Block: 4096   block special 
file
Device: 5h/5d    Inode: 8569        Links: 1     Device type: 8,30
Access: (0660/brw-rw----)  Uid: (    0/    root)   Gid: (    6/ disk)
Access: 2014-05-30 16:39:06.104006687 +0800
Modify: 2014-05-30 16:38:57.638006272 +0800 <<<ctime/mtime does not change
Change: 2014-05-30 16:38:57.638006272 +0800
  Birth: -
   File: '/dev/sdd'
   Size: 0             Blocks: 0          IO Block: 4096   block special 
file
Device: 5h/5d    Inode: 8569        Links: 1     Device type: 8,30
Access: (0660/brw-rw----)  Uid: (    0/    root)   Gid: (    6/ disk)
Access: 2014-05-30 16:39:06.104006687 +0800
Modify: 2014-05-30 16:38:57.638006272 +0800 <<<ctime/mtime does not change
Change: 2014-05-30 16:38:57.638006272 +0800
  Birth: -
Scanning for Btrfs filesystems
^^^ But no error message now.... :(
------

Thanks,
Qu
>
>
>>   static int btrfs_rm_dev_item(struct btrfs_root *root,
>>                    struct btrfs_device *device)
>>   {
>> @@ -1704,10 +1720,14 @@ int btrfs_rm_device(struct btrfs_root *root, 
>> char *device_path)
>>
>>       ret = 0;
>>
>> -    /* Notify udev that device has changed */
>> -    if (bdev)
>> +    if (bdev) {
>> +        /* Notify udev that device has changed */
>>           btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
>>
>> +        /* Update ctime/mtime for device path for libblkid */
>> +        update_dev_time(device_path);
>> +    }
>> +
>
>
>
>>   error_brelse:
>>       brelse(bh);
>>       if (bdev)
>> @@ -2146,6 +2166,8 @@ int btrfs_init_new_device(struct btrfs_root 
>> *root, char *device_path)
>>           ret = btrfs_commit_transaction(trans, root);
>>       }
>>
>> +    /* Update ctime/mtime for libblkid */
>> +    update_dev_time(device_path);
>>       return ret;
>>
>>   error_trans:
>>

