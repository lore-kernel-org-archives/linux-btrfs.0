Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2205 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752262AbcFUBso (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 21:48:44 -0400
Subject: Re: [RFC PATCH] btrfs: fix free space calculation in
 dump_space_info()
To: Omar Sandoval <osandov@osandov.com>
References: <1466419625-6755-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <20160620180951.GA16446@vader.DHCP.thefacebook.com>
CC: <linux-btrfs@vger.kernel.org>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57689CA1.7040000@cn.fujitsu.com>
Date: Tue, 21 Jun 2016 09:47:13 +0800
MIME-Version: 1.0
In-Reply-To: <20160620180951.GA16446@vader.DHCP.thefacebook.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 06/21/2016 02:09 AM, Omar Sandoval wrote:
> On Mon, Jun 20, 2016 at 06:47:05PM +0800, Wang Xiaoguang wrote:
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/extent-tree.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index f3e6666..13a87fe 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -7736,8 +7736,8 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
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
> I think you meant to send this to linux-btrfs@vger.kernel.org
Yes, should I resend it to linux-btrfs@vger.kernel.org again? thanks.

Regards,
Xiaoguang Wang
>



