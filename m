Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23697 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751479AbdCHGA5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Mar 2017 01:00:57 -0500
Subject: Re: [PATCH v3 7/7] btrfs: Enhance missing device kernel message
To: Andrei Borzenkov <arvidjaar@gmail.com>, <linux-btrfs@vger.kernel.org>,
        <anand.jain@oracle.com>, <kilobyte@angband.pl>, <demfloro@demfloro.ru>
References: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
 <20170308024124.16899-8-quwenruo@cn.fujitsu.com>
 <55e7ff1e-d06a-7963-b4f8-8f9c215347f2@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <751f2eec-abf7-820b-980e-5112fa392cdf@cn.fujitsu.com>
Date: Wed, 8 Mar 2017 13:43:17 +0800
MIME-Version: 1.0
In-Reply-To: <55e7ff1e-d06a-7963-b4f8-8f9c215347f2@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/08/2017 01:26 PM, Andrei Borzenkov wrote:
> 08.03.2017 05:41, Qu Wenruo пишет:
>> For missing device, btrfs will just refuse to mount with almost
>> meaningless kernel message like:
>>
>>  BTRFS info (device vdb6): disk space caching is enabled
>>  BTRFS info (device vdb6): has skinny extents
>>  BTRFS error (device vdb6): failed to read the system array: -5
>>  BTRFS error (device vdb6): open_ctree failed
>>
>> This patch will add extra device missing output, making the result to:
>>
>>  BTRFS info (device vdb6): disk space caching is enabled
>>  BTRFS info (device vdb6): has skinny extents
>>  BTRFS warning (device vdb6): devid 2 uuid 80470722-cad2-4b90-b7c3-fee294552f1b is missing
>>  BTRFS error (device vdb6): failed to read the system array: -5
>
> Unfortunately it is still unclear that failure to mount is caused by
> missing device. As you explained (and the whole reason of this patch
> series) we still are able to mount even with missing device(s). It
> should print error (not warning) telling that some extents are not
> accessible due to missing device(s)

If you specify -o degraded to allow read_chunk_tree to progress further, 
then there will be detailed reason for it:

  BTRFS info (device vdb7): allowing degraded mounts
  BTRFS info (device vdb7): disk space caching is enabled
  BTRFS info (device vdb7): has skinny extents
  BTRFS info (device vdb7): flagging fs with big metadata feature
  BTRFS warning (device vdb7): devid 1 uuid 
21cdf493-9d75-4a78-a8ee-d7426521a9f1 is missing
  BTRFS warning (device vdb7): chunk 12582912 missing 1 devices, max 
tolerance is 0 for writeble mount
  BTRFS warning (device vdb7): writeable mount is not allowed due to too 
many missing devices
  BTRFS error (device vdb7): open_ctree failed

Otherwise, normal mount doesn't allow any missing device and will just 
return -EIO from btrfs_read_chunk_tree(), preventing us from going to 
btrfs_check_rw_degradable().

I'll add more output for detailed reason why the mount fails in another 
patchset.

Thanks,
Qu

>
>>  BTRFS error (device vdb6): open_ctree failed
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Reviewed-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>  fs/btrfs/volumes.c | 24 +++++++++++++++++-------
>>  fs/btrfs/volumes.h |  2 ++
>>  2 files changed, 19 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 765d213ac5ef..f2c878d5f714 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -6442,6 +6442,7 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
>>  		if (!map->stripes[i].dev &&
>>  		    !btrfs_test_opt(fs_info, DEGRADED)) {
>>  			free_extent_map(em);
>> +			btrfs_report_missing_device(fs_info, devid, uuid);
>>  			return -EIO;
>>  		}
>>  		if (!map->stripes[i].dev) {
>> @@ -6452,8 +6453,7 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
>>  				free_extent_map(em);
>>  				return -EIO;
>>  			}
>> -			btrfs_warn(fs_info, "devid %llu uuid %pU is missing",
>> -				   devid, uuid);
>> +			btrfs_report_missing_device(fs_info, devid, uuid);
>>  		}
>>  		map->stripes[i].dev->in_fs_metadata = 1;
>>  	}
>> @@ -6570,17 +6570,21 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
>>
>>  	device = btrfs_find_device(fs_info, devid, dev_uuid, fs_uuid);
>>  	if (!device) {
>> -		if (!btrfs_test_opt(fs_info, DEGRADED))
>> +		if (!btrfs_test_opt(fs_info, DEGRADED)) {
>> +			btrfs_report_missing_device(fs_info, devid, dev_uuid);
>>  			return -EIO;
>> +		}
>>
>>  		device = add_missing_dev(fs_devices, devid, dev_uuid);
>>  		if (!device)
>>  			return -ENOMEM;
>> -		btrfs_warn(fs_info, "devid %llu uuid %pU missing",
>> -				devid, dev_uuid);
>> +		btrfs_report_missing_device(fs_info, devid, dev_uuid);
>>  	} else {
>> -		if (!device->bdev && !btrfs_test_opt(fs_info, DEGRADED))
>> -			return -EIO;
>> +		if (!device->bdev) {
>> +			btrfs_report_missing_device(fs_info, devid, dev_uuid);
>> +			if (!btrfs_test_opt(fs_info, DEGRADED))
>> +				return -EIO;
>> +		}
>>
>>  		if(!device->bdev && !device->missing) {
>>  			/*
>> @@ -6806,6 +6810,12 @@ static bool device_has_rw_degrade_error(struct extra_rw_degrade_errors *errors,
>>  	return ret;
>>  }
>>
>> +void btrfs_report_missing_device(struct btrfs_fs_info *fs_info, u64 devid,
>> +				 u8 *uuid)
>> +{
>> +	btrfs_warn_rl(fs_info, "devid %llu uuid %pU is missing", devid, uuid);
>> +}
>> +
>>  /*
>>   * Check if all chunks in the fs is OK for read-write degraded mount
>>   *
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index 67d7474e42a3..1f6ab55640da 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -573,4 +573,6 @@ void record_extra_rw_degrade_error(struct extra_rw_degrade_errors *errors,
>>
>>  bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
>>  			       struct extra_rw_degrade_errors *errors);
>> +void btrfs_report_missing_device(struct btrfs_fs_info *fs_info, u64 devid,
>> +				 u8 *uuid);
>>  #endif
>>
>
>
>


