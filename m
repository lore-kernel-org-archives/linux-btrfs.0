From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs:make btrfs_init_compress() return void
Date: Tue, 23 Aug 2011 08:05:41 +0800
Message-ID: <4E52EED5.3020007@cn.fujitsu.com>
References: <1314022940-6717-1-git-send-email-wanlong.gao@gmail.com> <4E52E986.8030405@jp.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Wanlong Gao <wanlong.gao@gmail.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, chris.mason@oracle.com
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E52E986.8030405@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/23/2011 07:43 AM, Tsutomu Itoh wrote:
> (2011/08/22 23:22), Wanlong Gao wrote:
>> From: Wanlong Gao<gaowanlong@cn.fujitsu.com>
>>
>> Make btrfs_init_compress() return void, since it always return 0,
>> and no need to check return value.
>>
>> Signed-off-by: Wanlong Gao<gaowanlong@cn.fujitsu.com>
>> ---
>>   fs/btrfs/compression.c |    3 +--
>>   fs/btrfs/compression.h |    2 +-
>>   fs/btrfs/super.c       |    7 ++-----
>>   3 files changed, 4 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
>> index 8ec5d86..b2dbefa 100644
>> --- a/fs/btrfs/compression.c
>> +++ b/fs/btrfs/compression.c
>> @@ -731,7 +731,7 @@ struct btrfs_compress_op *btrfs_compress_op[] = {
>>   	&btrfs_lzo_compress,
>>   };
>>
>> -int __init btrfs_init_compress(void)
>> +void __init btrfs_init_compress(void)
>>   {
>>   	int i;
>>
>> @@ -741,7 +741,6 @@ int __init btrfs_init_compress(void)
>>   		atomic_set(&comp_alloc_workspace[i], 0);
>>   		init_waitqueue_head(&comp_workspace_wait[i]);
>>   	}
>> -	return 0;
>>   }
>>
>>   /*
>> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
>> index a12059f..9afb0a6 100644
>> --- a/fs/btrfs/compression.h
>> +++ b/fs/btrfs/compression.h
>> @@ -19,7 +19,7 @@
>>   #ifndef __BTRFS_COMPRESSION_
>>   #define __BTRFS_COMPRESSION_
>>
>> -int btrfs_init_compress(void);
>> +void btrfs_init_compress(void);
>>   void btrfs_exit_compress(void);
>>
>>   int btrfs_compress_pages(int type, struct address_space *mapping,
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 15634d4..31e9654 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -1238,9 +1238,7 @@ static int __init init_btrfs_fs(void)
>>   	if (err)
>>   		return err;
>>
>> -	err = btrfs_init_compress();
>> -	if (err)
>> -		goto free_sysfs;
>> +	btrfs_init_compress();
>>
>>   	err = btrfs_init_cachep();
>>   	if (err)
>> @@ -1281,8 +1279,7 @@ free_cachep:
>>   	btrfs_destroy_cachep();
>>   free_compress:
>>   	btrfs_exit_compress();
>
>> -free_sysfs:
>> -	btrfs_exit_sysfs();
>> +
>
> Why remove btrfs_exit_sysfs()?

Yeah, a mistake, just wanna remove the label.

Thanks
-Wanlong Gao
>
>   -Tsutomu
>
>>   	return err;
>>   }
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

