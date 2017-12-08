Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47428 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752481AbdLHKjX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Dec 2017 05:39:23 -0500
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ee4df708-3197-7d37-8c6a-65f07cc760b5@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <9228f06c-e22e-5ee5-fb73-382f67589463@oracle.com>
Date: Fri, 8 Dec 2017 18:39:46 +0800
MIME-Version: 1.0
In-Reply-To: <ee4df708-3197-7d37-8c6a-65f07cc760b5@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/08/2017 04:17 PM, Qu Wenruo wrote:
> 
> 
> On 2017年12月08日 15:57, Anand Jain wrote:
>> -EXPERIMENTAL-
>> As of now when primary SB fails we won't self heal and would fail mount,
>> this is an experimental patch which thinks why not go and read backup
>> copy.
> 
> Just curious about in which real world case that backup super block can
> help.
> At least from what I see in mail list, only few cases where backup super
> helps.

  Theoretical design helps. I ended up in this situation though. And
  ext4 has -o sb flag to manage this part. When we can expect EIO on
  any part of the disk block why not on the LBA which contains primary
  SB. And should we fail the mount for that reason ? No.

> Despite that self super heal seems good, although I agree with David, we
> need a weaker but necessary check (magic and fsid from primary super?)
> to ensure it's a valid btrfs before we use the backup supers.

  Of course, we already have btrfs_check_super_valid() to verify the SB,
  I don't understand why - how do we verify the SB should be the point of
  concern here, at all.

Thanks, Anand

> Thanks,
> Qu
> 
> 
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/disk-io.c |  8 +++++++-
>>   fs/btrfs/volumes.c | 10 +++++++---
>>   2 files changed, 14 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 9b20c1f3563b..a791b8dfe8a8 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3190,7 +3190,7 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
>>   	 * So, we need to add a special mount option to scan for
>>   	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
>>   	 */
>> -	for (i = 0; i < 1; i++) {
>> +	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>>   		ret = btrfs_read_dev_one_super(bdev, i, &bh);
>>   		if (ret)
>>   			continue;
>> @@ -4015,11 +4015,17 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
>>   		ret = -EINVAL;
>>   	}
>>   
>> +#if 0
>> +	/*
>> +	 * Need a way to check for any copy of SB, as its not a
>> +	 * strong check, just ignore this for now.
>> +	 */
>>   	if (btrfs_super_bytenr(sb) != BTRFS_SUPER_INFO_OFFSET) {
>>   		btrfs_err(fs_info, "super offset mismatch %llu != %u",
>>   			  btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
>>   		ret = -EINVAL;
>>   	}
>> +#endif
>>   
>>   	/*
>>   	 * Obvious sys_chunk_array corruptions, it must hold at least one key
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 9fa2539a8493..f368db94d62b 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1369,7 +1369,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>>   {
>>   	struct btrfs_super_block *disk_super;
>>   	struct block_device *bdev;
>> -	struct page *page;
>> +	struct buffer_head *sb_bh;
>>   	int ret = -EINVAL;
>>   	u64 devid;
>>   	u64 transid;
>> @@ -1392,8 +1392,12 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>>   		goto error;
>>   	}
>>   
>> -	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super))
>> +	sb_bh = btrfs_read_dev_super(bdev);
>> +	if (IS_ERR(sb_bh)) {
>> +		ret = PTR_ERR(sb_bh);
>>   		goto error_bdev_put;
>> +	}
>> +	disk_super = (struct btrfs_super_block *) sb_bh->b_data;
>>   
>>   	devid = btrfs_stack_device_id(&disk_super->dev_item);
>>   	transid = btrfs_super_generation(disk_super);
>> @@ -1413,7 +1417,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>>   	if (!ret && fs_devices_ret)
>>   		(*fs_devices_ret)->total_devices = total_devices;
>>   
>> -	btrfs_release_disk_super(page);
>> +	brelse(sb_bh);
>>   
>>   error_bdev_put:
>>   	blkdev_put(bdev, flags);
>>
> 
