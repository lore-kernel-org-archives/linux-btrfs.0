Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:46150 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752314AbdK2QDQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 11:03:16 -0500
Received: by mail-vk0-f66.google.com with SMTP id 138so1494896vko.13
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 08:03:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e5388be2-25e5-a379-c014-f90d1cd40202@oracle.com>
References: <20171109154526.23181-1-anand.jain@oracle.com> <20171109154526.23181-5-anand.jain@oracle.com>
 <CAKuJGC_CrmmT8=U3KNcw4i_6sSDtwhCCs8iui4Ov+ECzsfAB6A@mail.gmail.com> <e5388be2-25e5-a379-c014-f90d1cd40202@oracle.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Wed, 29 Nov 2017 21:32:34 +0530
Message-ID: <CAKuJGC8v36WtNA6UY4vfpjk_zvNAsnKx9npKoacLQzLRi_KWjg@mail.gmail.com>
Subject: Re: [PATCH 4/4] btrfs: factor __btrfs_open_devices() to create btrfs_open_one_device()
To: Anand Jain <anand.jain@oracle.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,

Applied your fix, now the issue resolved. thanks!

----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org


On Mon, Nov 27, 2017 at 5:17 PM, Anand Jain <anand.jain@oracle.com> wrote:
>
> Hi Lakshmipathi,
>
>  Oops I can see the same. I am trying to narrow down.
>
> Thanks, Anand
>
>
> On 11/27/2017 02:47 PM, Lakshmipathi.G wrote:
>>
>> Hi Anand,
>>
>> With this patch applied, btrfs-progs/misc-test/021 error out. Is this
>> same for you?
>>
>> Without this patch: https://asciinema.org/a/RJmE5469mHlL3S1BIOCifWVn6
>> With this patch:    https://asciinema.org/a/1h5UX6DIFNsvvMXgLo4GiEgdE
>>
>> thanks!
>> ----
>> Cheers,
>> Lakshmipathi.G
>> http://www.giis.co.in http://www.webminal.org
>>
>>
>> On Thu, Nov 9, 2017 at 9:15 PM, Anand Jain <anand.jain@oracle.com> wrote:
>>>
>>> No functional changes, create btrfs_open_one_device() from
>>> __btrfs_open_devices(). This is a preparatory work to add dynamic
>>> device scan.
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>>   fs/btrfs/volumes.c | 126
>>> +++++++++++++++++++++++++++++------------------------
>>>   1 file changed, 69 insertions(+), 57 deletions(-)
>>>
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index 0857b580014d..d24e966ee29f 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -601,6 +601,73 @@ void btrfs_free_stale_device(struct btrfs_device
>>> *cur_dev)
>>>          }
>>>   }
>>>
>>> +static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
>>> +                       struct btrfs_device *device, fmode_t flags,
>>> +                       void *holder)
>>> +{
>>> +       struct request_queue *q;
>>> +       struct block_device *bdev;
>>> +       struct buffer_head *bh;
>>> +       struct btrfs_super_block *disk_super;
>>> +       u64 devid;
>>> +       int ret;
>>> +
>>> +       if (device->bdev)
>>> +               return -EINVAL;
>>> +       if (!device->name)
>>> +               return -EINVAL;
>>> +
>>> +       ret = btrfs_get_bdev_and_sb(device->name->str, flags, holder, 1,
>>> +                                   &bdev, &bh);
>>> +       if (ret)
>>> +               return ret;
>>> +
>>> +       disk_super = (struct btrfs_super_block *)bh->b_data;
>>> +       devid = btrfs_stack_device_id(&disk_super->dev_item);
>>> +       if (devid != device->devid)
>>> +               goto error_brelse;
>>> +
>>> +       if (memcmp(device->uuid, disk_super->dev_item.uuid,
>>> +                  BTRFS_UUID_SIZE))
>>> +               goto error_brelse;
>>> +
>>> +       device->generation = btrfs_super_generation(disk_super);
>>> +
>>> +       if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING) {
>>> +               device->writeable = 0;
>>> +               fs_devices->seeding = 1;
>>> +       } else {
>>> +               device->writeable = !bdev_read_only(bdev);
>>> +       }
>>> +
>>> +       q = bdev_get_queue(bdev);
>>> +       if (blk_queue_discard(q))
>>> +               device->can_discard = 1;
>>> +       if (!blk_queue_nonrot(q))
>>> +               fs_devices->rotating = 1;
>>> +
>>> +       device->bdev = bdev;
>>> +       device->in_fs_metadata = 0;
>>> +       device->mode = flags;
>>> +
>>> +       fs_devices->open_devices++;
>>> +       if (device->writeable &&
>>> +           device->devid != BTRFS_DEV_REPLACE_DEVID) {
>>> +               fs_devices->rw_devices++;
>>> +               list_add(&device->dev_alloc_list,
>>> +                        &fs_devices->alloc_list);
>>> +       }
>>> +       brelse(bh);
>>> +
>>> +       return 0;
>>> +
>>> +error_brelse:
>>> +       brelse(bh);
>>> +       blkdev_put(bdev, flags);
>>> +
>>> +       return -EINVAL;
>>> +}
>>> +
>>>   /*
>>>    * Add new device to list of registered devices
>>>    *
>>> @@ -978,69 +1045,14 @@ static int __btrfs_open_devices(struct
>>> btrfs_fs_devices *fs_devices,
>>>          flags |= FMODE_EXCL;
>>>
>>>          list_for_each_entry(device, head, dev_list) {
>>> -               struct request_queue *q;
>>> -               struct block_device *bdev;
>>> -               struct buffer_head *bh;
>>> -               struct btrfs_super_block *disk_super;
>>> -               u64 devid;
>>> -
>>> -               if (device->bdev)
>>> -                       continue;
>>> -               if (!device->name)
>>> -                       continue;
>>> -
>>>                  /* Just open everything we can; ignore failures here */
>>> -               if (btrfs_get_bdev_and_sb(device->name->str, flags,
>>> holder, 1,
>>> -                                           &bdev, &bh))
>>> +               ret = btrfs_open_one_device(fs_devices, device, flags,
>>> holder);
>>> +               if (ret)
>>>                          continue;
>>>
>>> -               disk_super = (struct btrfs_super_block *)bh->b_data;
>>> -               devid = btrfs_stack_device_id(&disk_super->dev_item);
>>> -               if (devid != device->devid)
>>> -                       goto error_brelse;
>>> -
>>> -               if (memcmp(device->uuid, disk_super->dev_item.uuid,
>>> -                          BTRFS_UUID_SIZE))
>>> -                       goto error_brelse;
>>> -
>>> -               device->generation = btrfs_super_generation(disk_super);
>>> -
>>> -               if (btrfs_super_flags(disk_super) &
>>> BTRFS_SUPER_FLAG_SEEDING) {
>>> -                       device->writeable = 0;
>>> -                       fs_devices->seeding = 1;
>>> -               } else {
>>> -                       device->writeable = !bdev_read_only(bdev);
>>> -               }
>>> -
>>> -               q = bdev_get_queue(bdev);
>>> -               if (blk_queue_discard(q))
>>> -                       device->can_discard = 1;
>>> -               if (!blk_queue_nonrot(q))
>>> -                       fs_devices->rotating = 1;
>>> -
>>> -               device->bdev = bdev;
>>> -               device->in_fs_metadata = 0;
>>> -               device->mode = flags;
>>> -
>>> -               fs_devices->open_devices++;
>>> -               if (device->writeable &&
>>> -                   device->devid != BTRFS_DEV_REPLACE_DEVID) {
>>> -                       fs_devices->rw_devices++;
>>> -                       list_add(&device->dev_alloc_list,
>>> -                                &fs_devices->alloc_list);
>>> -               }
>>> -               brelse(bh);
>>> -
>>>                  if (!latest_dev ||
>>>                      device->generation > latest_dev->generation)
>>>                          latest_dev = device;
>>> -
>>> -               continue;
>>> -
>>> -error_brelse:
>>> -               brelse(bh);
>>> -               blkdev_put(bdev, flags);
>>> -               continue;
>>>          }
>>>          if (fs_devices->open_devices == 0) {
>>>                  ret = -EINVAL;
>>> --
>>> 2.13.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
