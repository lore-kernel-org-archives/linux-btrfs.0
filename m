Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27125 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752334AbaGHEWy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jul 2014 00:22:54 -0400
Message-ID: <53BB7289.4040807@cn.fujitsu.com>
Date: Tue, 8 Jul 2014 12:24:41 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: <bo.li.liu@oracle.com>, Anand Jain <Anand.Jain@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC] btrfs: code optimize use btrfs_get_bdev_and_sb()
 at btrfs_scan_one_device
References: <1404758317-7000-1-git-send-email-Anand.Jain@oracle.com> <20140708040818.GA20810@localhost.localdomain>
In-Reply-To: <20140708040818.GA20810@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 8 Jul 2014 12:08:19 +0800, Liu Bo wrote:
> On Tue, Jul 08, 2014 at 02:38:37AM +0800, Anand Jain wrote:
>> (for review comments pls).
>>
>> btrfs_scan_one_device() needs SB, instead of doing it from scratch could
>> use btrfs_get_bdev_and_sb()
>>
>> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
>> ---
>>  fs/btrfs/volumes.c | 51 ++++++---------------------------------------------
>>  1 file changed, 6 insertions(+), 45 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index c166355..94e6131 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1053,14 +1053,11 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>>  {
>>  	struct btrfs_super_block *disk_super;
>>  	struct block_device *bdev;
>> -	struct page *page;
>> -	void *p;
>>  	int ret = -EINVAL;
>>  	u64 devid;
>>  	u64 transid;
>>  	u64 total_devices;
>> -	u64 bytenr;
>> -	pgoff_t index;
>> +	struct buffer_head *bh;
>>  
>>  	/*
>>  	 * we would like to check all the supers, but that would make
>> @@ -1068,44 +1065,12 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>>  	 * So, we need to add a special mount option to scan for
>>  	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
>>  	 */
>> -	bytenr = btrfs_sb_offset(0);
>>  	mutex_lock(&uuid_mutex);
>>  
>> -	bdev = blkdev_get_by_path(path, flags, holder);
>> -
>> -	if (IS_ERR(bdev)) {
>> -		ret = PTR_ERR(bdev);
>> +	ret = btrfs_get_bdev_and_sb(path, flags, holder, 0, &bdev, &bh);
>> +	if (ret)
>>  		goto error;
>> -	}
>> -
>> -	/* make sure our super fits in the device */
>> -	if (bytenr + PAGE_CACHE_SIZE >= i_size_read(bdev->bd_inode))
>> -		goto error_bdev_put;
>> -
>> -	/* make sure our super fits in the page */
>> -	if (sizeof(*disk_super) > PAGE_CACHE_SIZE)
>> -		goto error_bdev_put;
>> -
>> -	/* make sure our super doesn't straddle pages on disk */
>> -	index = bytenr >> PAGE_CACHE_SHIFT;
>> -	if ((bytenr + sizeof(*disk_super) - 1) >> PAGE_CACHE_SHIFT != index)
>> -		goto error_bdev_put;
> 
> Apparently btrfs_get_bdev_and_sb() lacks the above two checks, otherwise looks good.

In fact, our disk_super size is constant and <= min page size (4K), and we are sure that
it is impossible that the super block is cross the block, so the above two checks are unnecessary.

Thanks
Miao

> 
> thanks,
> -liubo
> 
>> -
>> -	/* pull in the page with our super */
>> -	page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
>> -				   index, GFP_NOFS);
>> -
>> -	if (IS_ERR_OR_NULL(page))
>> -		goto error_bdev_put;
>> -
>> -	p = kmap(page);
>> -
>> -	/* align our pointer to the offset of the super block */
>> -	disk_super = p + (bytenr & ~PAGE_CACHE_MASK);
>> -
>> -	if (btrfs_super_bytenr(disk_super) != bytenr ||
>> -	    btrfs_super_magic(disk_super) != BTRFS_MAGIC)
>> -		goto error_unmap;
>> +	disk_super = (struct btrfs_super_block *) bh->b_data;
>>  
>>  	devid = btrfs_stack_device_id(&disk_super->dev_item);
>>  	transid = btrfs_super_generation(disk_super);
>> @@ -1125,13 +1090,9 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>>  		printk(KERN_CONT "devid %llu transid %llu %s\n", devid, transid, path);
>>  	}
>>  
>> -
>> -error_unmap:
>> -	kunmap(page);
>> -	page_cache_release(page);
>> -
>> -error_bdev_put:
>> +	brelse(bh);
>>  	blkdev_put(bdev, flags);
>> +
>>  error:
>>  	mutex_unlock(&uuid_mutex);
>>  	return ret;
>> -- 
>> 2.0.0.257.g75cc6c6
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

