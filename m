Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60897 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbeIUNY5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 09:24:57 -0400
Subject: Re: [PATCH v2 2/2] btrfs: relocation: Remove redundant tree level
 check
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180921072030.20531-1-wqu@suse.com>
 <20180921072030.20531-2-wqu@suse.com>
 <c83bfc6d-569e-aa9f-ce91-637e194672f5@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2ea5ad51-cd44-a8b6-892c-27528a31b3bf@gmx.com>
Date: Fri, 21 Sep 2018 15:37:10 +0800
MIME-Version: 1.0
In-Reply-To: <c83bfc6d-569e-aa9f-ce91-637e194672f5@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/21 下午3:33, Nikolay Borisov wrote:
> 
> 
> On 21.09.2018 10:20, Qu Wenruo wrote:
>> Commit 581c1760415c ("btrfs: Validate child tree block's level and first
>> key") has made tree block level check mandatory.
>>
>> So if tree block level doesn't match, we won't get a valid extent
>> buffer.
>> The extra WARN_ON() check can be removed completely.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> Changelog:
>> v2:
>>   Added tags.
> 
> Nope you didn't :)

Face palm, only added in formatted patch, and just re-formatted patch again.

Anyway, David could handle it.

Thanks,
Qu

> 
>> ---
>>  fs/btrfs/relocation.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index 94aa148ccde6..a554e7861b6e 100644
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -2911,7 +2911,6 @@ static int get_tree_block_key(struct btrfs_fs_info *fs_info,
>>  		free_extent_buffer(eb);
>>  		return -EIO;
>>  	}
>> -	WARN_ON(btrfs_header_level(eb) != block->level);
>>  	if (block->level == 0)
>>  		btrfs_item_key_to_cpu(eb, &block->key, 0);
>>  	else
>>
