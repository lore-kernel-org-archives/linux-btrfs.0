Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43960 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753864AbdLHOB6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Dec 2017 09:01:58 -0500
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ed75e747-4387-49a3-e62a-67e100dd4ea6@gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <474dfc45-1d77-35ec-66e1-5391592fccc0@oracle.com>
Date: Fri, 8 Dec 2017 22:02:22 +0800
MIME-Version: 1.0
In-Reply-To: <ed75e747-4387-49a3-e62a-67e100dd4ea6@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/08/2017 08:51 PM, Austin S. Hemmelgarn wrote:
> On 2017-12-08 02:57, Anand Jain wrote:
>> -EXPERIMENTAL-
>> As of now when primary SB fails we won't self heal and would fail mount,
>> this is an experimental patch which thinks why not go and read backup
>> copy.
> I like the concept, and actually think this should be default behavior 
> on a filesystem that's already mounted (we fix other errors, why not 
> SB's), 


> but I don't think it should be default behavior at mount time for 
> the reasons Qu has outlined (picking up old BTRFS SB's after 
> reformatting is bad).

  If the primary SB is not btrfs, then unless forced with -t btrfs
  option, this mount won't be in btrfs at all. That means it goes to
  the respective FS by default.

  If the old btrfs is over written with newer btrfs SB, and if mkfs.btrfs
  is not overwriting all the copies of SB then its a mkfs.btrfs bug.

  Which means there is already mount -t option to redirect to the FS
  module that is needed by the user, when primary SB is corrupted.
  We should use this feature.

Thanks, Anand


> However, I do think it's useful to be able to ask 
> for this behavior on mount, so that you don't need to fight with the 
> programs to get a filesystem to mount when the first SB is missing 
> (perhaps add a 'usebackupsb' option to mirror 'usebackuproot'?).
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/disk-io.c |  8 +++++++-
>>   fs/btrfs/volumes.c | 10 +++++++---
>>   2 files changed, 14 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 9b20c1f3563b..a791b8dfe8a8 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3190,7 +3190,7 @@ struct buffer_head *btrfs_read_dev_super(struct 
>> block_device *bdev)
>>        * So, we need to add a special mount option to scan for
>>        * later supers, using BTRFS_SUPER_MIRROR_MAX instead
>>        */
>> -    for (i = 0; i < 1; i++) {
>> +    for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>>           ret = btrfs_read_dev_one_super(bdev, i, &bh);
>>           if (ret)
>>               continue;
>> @@ -4015,11 +4015,17 @@ static int btrfs_check_super_valid(struct 
>> btrfs_fs_info *fs_info)
>>           ret = -EINVAL;
>>       }
>> +#if 0
>> +    /*
>> +     * Need a way to check for any copy of SB, as its not a
>> +     * strong check, just ignore this for now.
>> +     */
>>       if (btrfs_super_bytenr(sb) != BTRFS_SUPER_INFO_OFFSET) {
>>           btrfs_err(fs_info, "super offset mismatch %llu != %u",
>>                 btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
>>           ret = -EINVAL;
>>       }
>> +#endif
>>       /*
>>        * Obvious sys_chunk_array corruptions, it must hold at least 
>> one key
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 9fa2539a8493..f368db94d62b 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1369,7 +1369,7 @@ int btrfs_scan_one_device(const char *path, 
>> fmode_t flags, void *holder,
>>   {
>>       struct btrfs_super_block *disk_super;
>>       struct block_device *bdev;
>> -    struct page *page;
>> +    struct buffer_head *sb_bh;
>>       int ret = -EINVAL;
>>       u64 devid;
>>       u64 transid;
>> @@ -1392,8 +1392,12 @@ int btrfs_scan_one_device(const char *path, 
>> fmode_t flags, void *holder,
>>           goto error;
>>       }
>> -    if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super))
>> +    sb_bh = btrfs_read_dev_super(bdev);
>> +    if (IS_ERR(sb_bh)) {
>> +        ret = PTR_ERR(sb_bh);
>>           goto error_bdev_put;
>> +    }
>> +    disk_super = (struct btrfs_super_block *) sb_bh->b_data;
>>       devid = btrfs_stack_device_id(&disk_super->dev_item);
>>       transid = btrfs_super_generation(disk_super);
>> @@ -1413,7 +1417,7 @@ int btrfs_scan_one_device(const char *path, 
>> fmode_t flags, void *holder,
>>       if (!ret && fs_devices_ret)
>>           (*fs_devices_ret)->total_devices = total_devices;
>> -    btrfs_release_disk_super(page);
>> +    brelse(sb_bh);
>>   error_bdev_put:
>>       blkdev_put(bdev, flags);
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
