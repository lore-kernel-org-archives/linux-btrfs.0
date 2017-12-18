Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54720 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752890AbdLROiy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 09:38:54 -0500
Subject: Re: [PATCH RESEND 1/2] btrfs: handle volume split brain scenario
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <20171217135247.1838-1-anand.jain@oracle.com>
 <c010dd5d-734a-6aad-e693-93041224735c@gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2722fb00-5fed-44b7-7516-272ea052c3cc@oracle.com>
Date: Mon, 18 Dec 2017 22:39:32 +0800
MIME-Version: 1.0
In-Reply-To: <c010dd5d-734a-6aad-e693-93041224735c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




>> Now the procedure to assemble the disks would be to continue to mount
>> the good set first without the device set on which new data can be
>> ignored, and later run btrfs device scan to bring in the missing device
>> and complete the RAID group which then shall reset the flag
>> BTRFS_SUPER_FLAG_VOL_MOVED_ON.
> Couple of thoughts on this:
> 
> 1. This needs to go in _after_ the patches to allow the kernel to forget 
> devices.

  Right will mention that explicitly or it can use kernel module reload
  if its a choice.

>  Otherwise, the only way to handle things is to physically 
> disconnect the device you don't want, mount the other one, and then 
> reconnect the disconnected device, because pretty much everything uses 
> udev, which by default scans for BTRFS on every device that gets 
> connected, and handling it like that is not an option for some people 
> (potentially for quite a few people).

  Yeah. That's a problem. If its a choice then they can reload
  the module.

> 2. How exactly is this supposed to work for people who don't have new 
> enough btrfs-progs to tell the kernel to forget the device?  Ideally, 
> there should be some other way to tell the kernel which one to use 
> (perhaps a one-shot mount option?) without needing any userspace support 
> (and if that happens, then I retract my first comment).  I'm not saying 
> that the currently proposed method is a bad solution, just that it's not 
> a complete solution from a usability perspective.

  Oh. I got it. But the current solution using forget cli OR kernel
  module reload is a kind of general solution, also split brain problem
  arises from wrong usage.

  Your concern of not having forget cli is only a short term concern,
  developing a new mount-option for a short term concern is not
  sure if its right. I am ok either way, if more people prefer that
  way I don't mind writing one.

> 3. How does this get handled with volumes using the raid1 profile and 
> more than 2 devices?
> In that case, things get complicated fast. 
> Handling an array of N devices in raid1 mode where N-1 devices have this 
> flag set is in theory easy, except you have no verification that the N-1 
> devices were mounted separately or as a group (in the first case, the 
> user needs to pick one, in the second, it should automatically recover 
> since they all agree on the state of the filesystem).

  Even in N device raid1, the number of device that can be missing
  is still one. There will be at least one or more devices which
  are common to both the sets. So split brain can't happen.

> 4. Having some way to do this solely from btrfs-progs would be nice too 
> (so that you can just drop to a shell during boot, or drop to the 
> initramfs, and fix things without having to mess with device scanning), 
> but is secondary to the kernel-side IMHO.

  Pls. Note this patch only detects and avoids the split brain devices
  to loose data, by failing the mount. However the fix is out side of
  this patch. Next, cli 'btrfs dev forget' is anyway isn't purposely
  made for this purpose. Its a generic un-scan code which helps here
  otherwise as well.

  If we need a purposely built cli (btrfstune ?) to fix the SB, it
  can be done. But I think it will be complicated.

> Other than all of that, I do think this is a good idea.  Being able to 
> more sanely inform the user about the situation and help them figure out 
> how to fix it correctly is something that's desperately needed here.

Thanks, Anand

>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> On top of kdave misc-next.
>>
>>   fs/btrfs/disk-io.c              | 56 
>> ++++++++++++++++++++++++++++++++++++++++-
>>   fs/btrfs/volumes.c              | 14 +++++++++--
>>   include/uapi/linux/btrfs_tree.h |  1 +
>>   3 files changed, 68 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index a3e9b74f6006..55bc6c846671 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -61,7 +61,8 @@
>>                    BTRFS_HEADER_FLAG_RELOC |\
>>                    BTRFS_SUPER_FLAG_ERROR |\
>>                    BTRFS_SUPER_FLAG_SEEDING |\
>> -                 BTRFS_SUPER_FLAG_METADUMP)
>> +                 BTRFS_SUPER_FLAG_METADUMP|\
>> +                 BTRFS_SUPER_FLAG_VOL_MOVED_ON)
>>   static const struct extent_io_ops btree_extent_io_ops;
>>   static void end_workqueue_fn(struct btrfs_work *work);
>> @@ -2383,6 +2384,43 @@ static int btrfs_read_roots(struct 
>> btrfs_fs_info *fs_info)
>>       return 0;
>>   }
>> +bool volume_has_split_brain(struct btrfs_fs_info *fs_info)
>> +{
>> +    unsigned long devs_moved_on = 0;
>> +    struct btrfs_fs_devices *fs_devs = fs_info->fs_devices;
>> +    struct list_head *head = &fs_devs->devices;
>> +    struct btrfs_device *dev;
>> +
>> +again:
>> +    list_for_each_entry(dev, head, dev_list) {
>> +        struct buffer_head *bh;
>> +        struct btrfs_super_block *sb;
>> +
>> +        if (!dev->devid)
>> +            continue;
>> +
>> +        bh = btrfs_read_dev_super(dev->bdev);
>> +        if (IS_ERR(bh))
>> +            continue;
>> +
>> +        sb = (struct btrfs_super_block *)bh->b_data;
>> +        if (btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_VOL_MOVED_ON)
>> +            devs_moved_on++;
>> +        brelse(bh);
>> +    }
>> +
>> +    fs_devs = fs_devs->seed;
>> +    if (fs_devs) {
>> +        head = &fs_devs->devices;
>> +        goto again;
>> +    }
>> +
>> +    if (devs_moved_on == fs_info->fs_devices->total_devices)
>> +        return true;
>> +    else
>> +        return false;
>> +}
>> +
>>   int open_ctree(struct super_block *sb,
>>              struct btrfs_fs_devices *fs_devices,
>>              char *options)
>> @@ -2872,6 +2910,22 @@ int open_ctree(struct super_block *sb,
>>           goto fail_sysfs;
>>       }
>> +    if (fs_info->fs_devices->missing_devices) {
>> +        btrfs_set_super_flags(fs_info->super_copy,
>> +            fs_info->super_copy->flags |
>> +            BTRFS_SUPER_FLAG_VOL_MOVED_ON);
>> +    } else if (fs_info->super_copy->flags &
>> +            BTRFS_SUPER_FLAG_VOL_MOVED_ON) {
>> +        if (volume_has_split_brain(fs_info)) {
>> +            btrfs_err(fs_info,
>> +                "Detected 'moved_on' flag on all device");
>> +            goto fail_sysfs;
>> +        }
>> +        btrfs_set_super_flags(fs_info->super_copy,
>> +            fs_info->super_copy->flags &
>> +            ~BTRFS_SUPER_FLAG_VOL_MOVED_ON);
>> +    }
>> +
>>       fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
>>                              "btrfs-cleaner");
>>       if (IS_ERR(fs_info->cleaner_kthread))
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 33e814ef992f..c08b9b89e285 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -2057,8 +2057,13 @@ int btrfs_rm_device(struct btrfs_fs_info 
>> *fs_info, const char *device_path,
>>       device->fs_devices->num_devices--;
>>       device->fs_devices->total_devices--;
>> -    if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
>> +    if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)) {
>>           device->fs_devices->missing_devices--;
>> +        if (!device->fs_devices->missing_devices)
>> +            btrfs_set_super_flags(fs_info->super_copy,
>> +                fs_info->super_copy->flags &
>> +                ~BTRFS_SUPER_FLAG_VOL_MOVED_ON);
>> +    }
>>       btrfs_assign_next_active_device(fs_info, device, NULL);
>> @@ -2132,8 +2137,13 @@ void btrfs_rm_dev_replace_remove_srcdev(struct 
>> btrfs_fs_info *fs_info,
>>       list_del_rcu(&srcdev->dev_list);
>>       list_del(&srcdev->dev_alloc_list);
>>       fs_devices->num_devices--;
>> -    if (test_bit(BTRFS_DEV_STATE_MISSING, &srcdev->dev_state))
>> +    if (test_bit(BTRFS_DEV_STATE_MISSING, &srcdev->dev_state)) {
>>           fs_devices->missing_devices--;
>> +        if (!fs_devices->missing_devices)
>> +            btrfs_set_super_flags(fs_info->super_copy,
>> +                fs_info->super_copy->flags &
>> +                ~BTRFS_SUPER_FLAG_VOL_MOVED_ON);
>> +    }
>>       if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &srcdev->dev_state))
>>           fs_devices->rw_devices--;
>> diff --git a/include/uapi/linux/btrfs_tree.h 
>> b/include/uapi/linux/btrfs_tree.h
>> index 6d6e5da51527..a9f625be0589 100644
>> --- a/include/uapi/linux/btrfs_tree.h
>> +++ b/include/uapi/linux/btrfs_tree.h
>> @@ -456,6 +456,7 @@ struct btrfs_free_space_header {
>>   #define BTRFS_SUPER_FLAG_SEEDING    (1ULL << 32)
>>   #define BTRFS_SUPER_FLAG_METADUMP    (1ULL << 33)
>> +#define BTRFS_SUPER_FLAG_VOL_MOVED_ON    (1ULL << 36)
>>   /*
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
