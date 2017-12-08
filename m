Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39842 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752212AbdLHKc6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Dec 2017 05:32:58 -0500
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <d39224a3-5431-90a7-d2f3-e4536b4842a4@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d681bb3c-f22f-a7f4-ff82-3208327f4590@oracle.com>
Date: Fri, 8 Dec 2017 18:33:23 +0800
MIME-Version: 1.0
In-Reply-To: <d39224a3-5431-90a7-d2f3-e4536b4842a4@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/08/2017 04:40 PM, Nikolay Borisov wrote:
> 
> 
> On  8.12.2017 09:57, Anand Jain wrote:
>> -EXPERIMENTAL-
>> As of now when primary SB fails we won't self heal and would fail mount,
>> this is an experimental patch which thinks why not go and read backup
>> copy.
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
> 
> This patch prompts another question: why do we have a page-based and a
> bufferhead-based interface to reading the super block?

  Right. we need to know that. Sorry I just saw this.

  I have a very old patch to converge them and clean this up, but haven't
  sent it because there are some missing information on why it ended up
  like that in the first place.

Thanks, Anand


> I did prototype
> switching the bufferheads to page based but the resulting code wasn't
> any cleaner. I believe there is also open the question what happens when
> btrfs is run on a 64k page machine. I.e. we are going to read a single
> page and the sb is going to be in the first 4k but what about the rest
> 60, they could potentially contain other metadata. The page will have to
> be freed asap so as not to peg the neighboring metadata?


> 
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
