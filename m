Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1697 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab2IFBIk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Sep 2012 21:08:40 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8618aam013528
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 09:08:36 +0800
Message-ID: <5047F787.2080705@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 09:08:23 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 4/7] Btrfs: use a slab for ordered extents allocation
References: <503D96C2.7000802@cn.fujitsu.com> <20120905161619.GM17430@twin.jikos.cz>
In-Reply-To: <20120905161619.GM17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 5 Sep 2012 18:16:19 +0200, David Sterba wrote:
> On Wed, Aug 29, 2012 at 12:12:50PM +0800, Miao Xie wrote:
>> The ordered extent allocation is in the fast path of the IO, so use a slab
>> to improve the speed of the allocation.
> 
> Good. Size of the struct is 280, so this will fall into the size-512
> bucket, giving 8 objects per page, while own slab will pack 14 objects
> into a page.
> 
> Another benefit I see is to check for leaked objects when the
> module is removed (and the cache destroy takes place).
> 
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>>  fs/btrfs/ordered-data.c |   23 +++++++++++++++++++++--
>>  fs/btrfs/ordered-data.h |    2 ++
>>  fs/btrfs/super.c        |    9 ++++++++-
>>  3 files changed, 31 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
>> index 2eb79cc..a07ae77 100644
>> --- a/fs/btrfs/ordered-data.c
>> +++ b/fs/btrfs/ordered-data.c
>> @@ -958,3 +960,20 @@ void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
>>  	}
>>  	spin_unlock(&root->fs_info->ordered_extent_lock);
>>  }
>> +
>> +int __init ordered_data_init(void)
>> +{
>> +	ordered_extent_cache = kmem_cache_create("ordered_extent",
> 
> Please use the 'btrfs_' prefix, ie. 'btrfs_ordered_extent'

Thanks for your review. I'll update this patch by your advice.

Regards
Miao

> 
>> +				sizeof(struct btrfs_ordered_extent), 0,
>> +				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
>> +				NULL);
>> +	if (!ordered_extent_cache)
>> +		return -ENOMEM;
>> +	return 0;
>> +}
>> +
> 


