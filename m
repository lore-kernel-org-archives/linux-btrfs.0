Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32181 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab3CRDSH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Mar 2013 23:18:07 -0400
Message-ID: <51468797.9090203@oracle.com>
Date: Mon, 18 Mar 2013 11:18:47 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Eric Sandeen <sandeen@redhat.com>
Subject: Re: btrfs_scan_one_device return error code
References: <51418AD5.6090207@oracle.com> <5141DCB6.6000605@redhat.com>
In-Reply-To: <5141DCB6.6000605@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




  As of now a common 'Invalid argument' return code is
  for a set of 5 errors,  that is misleading from
  the end-user context.

  Albeit the proposed return error codes are the closest
  they might not be the perfect though. Since the idea is
  at least if we use 'Invalid argument' only when no
  btrfs SB found, that will solve the bug in this context.

  Any other simpler fix ? or should we go for ioctl arg
  V2 and have room for return error string ? Thanks.

-Anand


>>   /dev/sdc does not contain btrfs SB at all..
>>
>> ---
>>   # btrfs dev scan /dev/sdc
>>   Scanning for Btrfs filesystems in '/dev/sdc'
>>   ERROR: unable to scan the device '/dev/sdc' - Invalid argument
>> ---
>>
>>   here appropriate error is something like
>>   no btrfs found on dev
>>
>>   However btrfs_scan_one_device (kernel) returns -EINVAL
>>   for other errors too
>>
>>   Does the below fix sound reasonable ?



> It's too bad that ioctl arg doesn't have room to pass back
> any other status.
>
> A rev of the ioctl (BTRFS_IOC_SCAN_DEV_V2), which allows
> passing status flags back out, would solve the problem nicely
> I think.


>>
>> --------------
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 6b9cff4..d6deae0 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -808,7 +808,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>>          struct block_device *bdev;
>>          struct page *page;
>>          void *p;
>> -       int ret = -EINVAL;
>> +       int ret = 0;
>>          u64 devid;
>>          u64 transid;
>>          u64 total_devices;
>> @@ -833,24 +833,32 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>>          }
>>
>>          /* make sure our super fits in the device */
>> -       if (bytenr + PAGE_CACHE_SIZE >= i_size_read(bdev->bd_inode))
>> +       if (bytenr + PAGE_CACHE_SIZE >= i_size_read(bdev->bd_inode)) {
>> +               ret = -ENOSPC;
>>                  goto error_bdev_put;
>> +       }
>>
>>          /* make sure our super fits in the page */
>> -       if (sizeof(*disk_super) > PAGE_CACHE_SIZE)
>> +       if (sizeof(*disk_super) > PAGE_CACHE_SIZE) {
>> +               ret = -ENOMEM;
>>                  goto error_bdev_put;
>> +       }
>>
>>          /* make sure our super doesn't straddle pages on disk */
>>          index = bytenr >> PAGE_CACHE_SHIFT;
>> -       if ((bytenr + sizeof(*disk_super) - 1) >> PAGE_CACHE_SHIFT != index)
>> +       if ((bytenr + sizeof(*disk_super) - 1) >> PAGE_CACHE_SHIFT != index) {
>> +               ret = -ENOMEM;
>>                  goto error_bdev_put;
>> +       }
>>
>>          /* pull in the page with our super */
>>          page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
>>                                     index, GFP_NOFS);
>>
>> -       if (IS_ERR_OR_NULL(page))
>> +       if (IS_ERR_OR_NULL(page)) {
>> +               ret = -EIO;
>>                  goto error_bdev_put;
>> +       }
>>
>>          p = kmap(page);
>>
>> @@ -858,8 +866,10 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>>          disk_super = p + (bytenr & ~PAGE_CACHE_MASK);
>>
>>          if (btrfs_super_bytenr(disk_super) != bytenr ||
>> -           disk_super->magic != cpu_to_le64(BTRFS_MAGIC))
>> +           disk_super->magic != cpu_to_le64(BTRFS_MAGIC)) {
>> +               ret = -EINVAL;
>>                  goto error_unmap;
>> +       }
>>
>>          devid = btrfs_stack_device_id(&disk_super->dev_item);
>>          transid = btrfs_super_generation(disk_super);
>> -------------------
