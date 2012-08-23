Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:34505 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab2HWKat (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Aug 2012 06:30:49 -0400
Message-ID: <50360659.4020903@oracle.com>
Date: Thu, 23 Aug 2012 18:30:49 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use larger limit for transition of logical to
 inode
References: <1345712189-6455-1-git-send-email-bo.li.liu@oracle.com> <1345712189-6455-2-git-send-email-bo.li.liu@oracle.com> <503600DD.9030309@jan-o-sch.net> <503604C2.90400@oracle.com>
In-Reply-To: <503604C2.90400@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/23/2012 06:24 PM, Liu Bo wrote:
> On 08/23/2012 06:07 PM, Jan Schmidt wrote:
>> On Thu, August 23, 2012 at 10:56 (+0200), Liu Bo wrote:
>>> This is the change of the kernel side.
>>>
>>> Transition of logical to inode used to have a limit 4096 on inode container's
>>> size, but the limit is not large enough for a data with a great many of refs,
>>> so when resolving logical address, we can end up with
>>> "ioctl ret=0, bytes_left=0, bytes_missing=19944, cnt=510, missed=2493"
>>>
>>> This changes to regard 4096 as the lowest limit.
>>>
>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>>> ---
>>>  fs/btrfs/ioctl.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>> index 9449b84..525915f 100644
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -3232,7 +3232,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
>>>  		goto out;
>>>  	}
>>>  
>>> -	size = min_t(u32, loi->size, 4096);
>>> +	size = max_t(u32, loi->size, 4096);
>>
>> Hum. I added this because I wanted to avoid allocations > PAGE_SIZE. We're doing
>> kmalloc GFP_NOFS with whatever one enters as size, I'm not sure that's a good
>> idea without any sanitizing.
>>
> 
> Yeah, I agree.
> 
> So we do need to make some sanity checks, according to my tests,
> we need about 30k to resolve a file shared by 4000 snapshots.
> 

s/4000/2000/g

> What about 32k as a upside limit?
> 
>> Second, we should probably add a fall back option to vmalloc, in case kmalloc
>> fails? Or should we even go for vmalloc directly, what do you think?
>>
> 
> Given loi->size is not reliable, going for vmalloc for an ioctl is reasonable.
> 
> thanks,
> liubo
> 
>> Thanks,
>> -Jan
>>
>>>  	inodes = init_data_container(size);
>>>  	if (IS_ERR(inodes)) {
>>>  		ret = PTR_ERR(inodes);
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

