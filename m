Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14219 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750975AbcIMAKf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 20:10:35 -0400
Subject: Re: [PATCH 02/13] btrfs: Do per-chunk check for mount time check
To: Hugo Mills <hugo@carfax.org.uk>, Anand Jain <anand.jain@oracle.com>,
        <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>,
        <yauhen.kharuzhy@zavadatar.com>
References: <1462889372-5274-1-git-send-email-anand.jain@oracle.com>
 <1462889372-5274-4-git-send-email-anand.jain@oracle.com>
 <20160912214940.GG7138@carfax.org.uk>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <29f20ce4-ae38-827a-dd11-4565503d6a36@cn.fujitsu.com>
Date: Tue, 13 Sep 2016 08:10:28 +0800
MIME-Version: 1.0
In-Reply-To: <20160912214940.GG7138@carfax.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

IIRC it's now part of Anand Jain's hot device replace patchset.

And noone knows when hot device replace will be merged, the per chunk 
degrade check won't be merged.

Thanks,
Qu

At 09/13/2016 05:49 AM, Hugo Mills wrote:
>    What happened to these patches? (Particularly the per-chunk
> degraded checks). We've just had someone on IRC who could have used
> the capability...
>
>    Hugo.
>
> On Tue, May 10, 2016 at 10:09:21PM +0800, Anand Jain wrote:
>> From: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>
>> Now use the btrfs_check_degraded() to do mount time degraded check.
>>
>> With this patch, now we can mount with the following case:
>>  # mkfs.btrfs -f -m raid1 -d single /dev/sdb /dev/sdc
>>  # wipefs -a /dev/sdc
>>  # mount /dev/sdb /mnt/btrfs -o degraded
>>  As the single data chunk is only in sdb, so it's OK to mount as degraded,
>>  as missing one device is OK for RAID1.
>>
>> But still fail with the following case as expected:
>>  # mkfs.btrfs -f -m raid1 -d single /dev/sdb /dev/sdc
>>  # wipefs -a /dev/sdb
>>  # mount /dev/sdc /mnt/btrfs -o degraded
>>  As the data chunk is only in sdb, so it's not OK to mount it as degraded.
>>
>> Reported-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>> Reported-by: Anand Jain <anand.jain@oracle.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>
>> [Btrfs: use btrfs_error instead of btrfs_err during mount]
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>  fs/btrfs/disk-io.c | 18 ++++++++++--------
>>  1 file changed, 10 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index d01f89d130e0..4f91a049fbca 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -2885,6 +2885,16 @@ int open_ctree(struct super_block *sb,
>>  		goto fail_tree_roots;
>>  	}
>>
>> +	ret = btrfs_check_degradable(fs_info, fs_info->sb->s_flags);
>> +	if (ret < 0) {
>> +		btrfs_err(fs_info, "degraded writable mount failed %d", ret);
>> +		goto fail_tree_roots;
>> +	} else if (ret > 0 && !btrfs_test_opt(chunk_root, DEGRADED)) {
>> +		btrfs_warn(fs_info,
>> +			"Some device missing, but still degraded mountable, please mount with -o degraded option");
>> +		ret = -EACCES;
>> +		goto fail_tree_roots;
>> +	}
>>  	/*
>>  	 * keep the device that is marked to be the target device for the
>>  	 * dev_replace procedure
>> @@ -2988,14 +2998,6 @@ retry_root_backup:
>>  	}
>>  	fs_info->num_tolerated_disk_barrier_failures =
>>  		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
>> -	if (fs_info->fs_devices->missing_devices >
>> -	     fs_info->num_tolerated_disk_barrier_failures &&
>> -	    !(sb->s_flags & MS_RDONLY)) {
>> -		pr_warn("BTRFS: missing devices(%llu) exceeds the limit(%d), writeable mount is not allowed\n",
>> -			fs_info->fs_devices->missing_devices,
>> -			fs_info->num_tolerated_disk_barrier_failures);
>> -		goto fail_sysfs;
>> -	}
>>
>>  	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
>>  					       "btrfs-cleaner");
>> --
>> 2.7.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


