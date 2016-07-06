Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46406 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751223AbcGFKSV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 06:18:21 -0400
Subject: Re: [PATCH 2/2] btrfs: fix free space calculation in
 dump_space_info()
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20160629051216.16876-1-wangxg.fnst@cn.fujitsu.com>
 <20160704171025.GL13336@twin.jikos.cz>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <577CDA66.1050309@cn.fujitsu.com>
Date: Wed, 6 Jul 2016 18:16:06 +0800
MIME-Version: 1.0
In-Reply-To: <20160704171025.GL13336@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 07/05/2016 01:10 AM, David Sterba wrote:
> On Wed, Jun 29, 2016 at 01:12:16PM +0800, Wang Xiaoguang wrote:
>
> Can you please describe in more detail what is this patch fixing?
In original dump_space_info(), free space info is calculated by
info->total_bytes - info->bytes_used - info->bytes_pinned - 
info->bytes_reserved - info->bytes_readonly,
but I think free space info should also minus info->bytes_may_use :)

Regards,
Xiaoguang Wang

>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/extent-tree.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 8550a0e..520ba8f 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -7747,8 +7747,8 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
>>   	printk(KERN_INFO "BTRFS: space_info %llu has %llu free, is %sfull\n",
>>   	       info->flags,
>>   	       info->total_bytes - info->bytes_used - info->bytes_pinned -
>> -	       info->bytes_reserved - info->bytes_readonly,
>> -	       (info->full) ? "" : "not ");
>> +	       info->bytes_reserved - info->bytes_readonly -
>> +	       info->bytes_may_use, (info->full) ? "" : "not ");
>>   	printk(KERN_INFO "BTRFS: space_info total=%llu, used=%llu, pinned=%llu, "
>>   	       "reserved=%llu, may_use=%llu, readonly=%llu\n",
>>   	       info->total_bytes, info->bytes_used, info->bytes_pinned,
>> -- 
>> 2.9.0
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



