Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54189 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751505AbbA3BUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Jan 2015 20:20:50 -0500
Message-ID: <54CADC6E.2070703@cn.fujitsu.com>
Date: Fri, 30 Jan 2015 09:20:46 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Miao Xie <miaoxie@huawei.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RESEND v4 2/8] btrfs: Make btrfs_parse_options() parse
 mount option in a atomic way
References: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com> <1422498281-20493-3-git-send-email-quwenruo@cn.fujitsu.com> <54CAD0FC.4010503@huawei.com>
In-Reply-To: <54CAD0FC.4010503@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH RESEND v4 2/8] btrfs: Make btrfs_parse_options() 
parse mount option in a atomic way
From: Miao Xie <miaoxie@huawei.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Date: 2015年01月30日 08:31
> On Thu, 29 Jan 2015 10:24:35 +0800, Qu Wenruo wrote:
>> Current btrfs_parse_options() is not atomic, which can set and clear a
>> bit, especially for nospace_cache case.
>>
>> For example, if a fs is mounted with nospace_cache,
>> btrfs_parse_options() will set SPACE_CACHE bit first(since
>> cache_generation is non-zeo) and clear the SPACE_CACHE bit due to
>> nospace_cache mount option.
>> So under heavy operations and remount a nospace_cache btrfs, there is a
>> windows for commit to create space cache.
>>
>> This bug can be reproduced by fstest/btrfs/071 073 074 with
>> nospace_cache mount option. It has about 50% chance to create space
>> cache, and about 10% chance to create wrong space cache, which can't
>> pass btrfsck.
>>
>> This patch will do the mount option parse in a copy-and-update method.
>> First copy the mount_opt from fs_info to new_opt, and only update
>> options in new_opt. At last, copy the new_opt back to
>> fs_info->mount_opt.
>>
>> This patch is already good enough to fix the above nospace_cache +
>> remount bug, but need later patch to make sure mount options does not
>> change during transaction.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>   fs/btrfs/ctree.h |  16 ++++----
>>   fs/btrfs/super.c | 115 +++++++++++++++++++++++++++++--------------------------
>>   2 files changed, 69 insertions(+), 62 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 5f99743..26bb47b 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -2119,18 +2119,18 @@ struct btrfs_ioctl_defrag_range_args {
>>   #define btrfs_test_opt(root, opt)	((root)->fs_info->mount_opt & \
>>   					 BTRFS_MOUNT_##opt)
>>   
>> -#define btrfs_set_and_info(root, opt, fmt, args...)			\
>> +#define btrfs_set_and_info(fs_info, val, opt, fmt, args...)		\
>>   {									\
>> -	if (!btrfs_test_opt(root, opt))					\
>> -		btrfs_info(root->fs_info, fmt, ##args);			\
>> -	btrfs_set_opt(root->fs_info->mount_opt, opt);			\
>> +	if (!btrfs_raw_test_opt(val, opt))				\
>> +		btrfs_info(fs_info, fmt, ##args);			\
>> +	btrfs_set_opt(val, opt);					\
>>   }
>>   
>> -#define btrfs_clear_and_info(root, opt, fmt, args...)			\
>> +#define btrfs_clear_and_info(fs_info, val, opt, fmt, args...)		\
>>   {									\
>> -	if (btrfs_test_opt(root, opt))					\
>> -		btrfs_info(root->fs_info, fmt, ##args);			\
>> -	btrfs_clear_opt(root->fs_info->mount_opt, opt);			\
>> +	if (btrfs_raw_test_opt(val, opt))				\
>> +		btrfs_info(fs_info, fmt, ##args);			\
>> +	btrfs_clear_opt(val, opt);					\
>>   }
>>   
>>   /*
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index b0c45b2..490fe1f 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -395,10 +395,13 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>>   	int ret = 0;
>>   	char *compress_type;
>>   	bool compress_force = false;
>> +	unsigned long new_opt;
>> +
>> +	new_opt = info->mount_opt;
> Here and
>
>>   
>>   	cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
>>   	if (cache_gen)
>> -		btrfs_set_opt(info->mount_opt, SPACE_CACHE);
> [SNIP]
>>   out:
>> -	if (!ret && btrfs_test_opt(root, SPACE_CACHE))
>> -		btrfs_info(root->fs_info, "disk space caching is enabled");
>> +	if (!ret) {
>> +		if (btrfs_raw_test_opt(new_opt, SPACE_CACHE))
>> +			btrfs_info(info, "disk space caching is enabled");
>> +		info->mount_opt = new_opt;
> Here need ACCESS_ONCE to wrap info->mount_opt, or the complier might use
> info->mount_opt instead of new_opt.
Thanks for pointing out this one.
>
> But I worried that this is not key reason of the wrong space cache. Could
> you explain the race condition which caused the wrong space cache?
>
> Thanks
> Miao
CPU0:
remount()
|- sync_fs() <- after sync_fs() we can start new trans
|- btrfs_parse_options()     CPU1:
                     |- start_transaction()
                     |- Do some bg allocation, not recorded in space_cache.
      |- set SPACE_CACHE bit due to cache_gen

                     |- commit_transaction()
                         |- write space cache and update cache_gen.
                             but since some of it is not recorded in 
space cache,
                             the space cache missing some records.
      |- clear SPACE_CACHE bit dut to nospace_cache

So the space cache is wrong.

Thanks,
Qu
>
>> +	}
>>   	kfree(orig);
>>   	return ret;
>>   }
>>

