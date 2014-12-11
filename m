Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12513 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964919AbaLKIQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 03:16:16 -0500
Message-ID: <548952CD.9000804@cn.fujitsu.com>
Date: Thu, 11 Dec 2014 16:16:13 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <mwilck@arcor.de>, <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 05/18] btrfs-progs: ctree.h: fix btrfs_inode_[amc]time
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de> <1418244708-7087-6-git-send-email-mwilck@arcor.de> <54894EF2.4070808@cn.fujitsu.com>
In-Reply-To: <54894EF2.4070808@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 05/18] btrfs-progs: ctree.h: fix btrfs_inode_[amc]time
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: mwilck@arcor.de, linux-btrfs@vger.kernel.org
Date: 2014年12月11日 15:59
>
> -------- Original Message --------
> Subject: [PATCH 05/18] btrfs-progs: ctree.h: fix btrfs_inode_[amc]time
> From: <mwilck@arcor.de>
> To: <linux-btrfs@vger.kernel.org>
> Date: 2014年12月11日 04:51
>> From: Martin Wilck <mwilck@arcor.de>
>>
>> make btrfs_inode_[amc]time work like the other btrfs_inode_xxx
>> functions. The current definition appears broken to me; it never
>> returns valid pointer unless an extent buffer address is added.
> The original method returns the ptr in the way just like 
> btrfs_item_ptr(), which you should call
> read_extent_buffer() to read them into a struct of btrfs_timespec.
> That's the same in kernel codes.
>
> If just want to read the timespec, you could try 
> btrfs_stack_timespec_[n]spec() marco.
Oh, sorry, for your case, it is btrfs_timespec_[n]spec() marcro, not the 
stack ones.
And that one uses the timespec returned by btrfs_inode_[amc]time() marcor.

Thanks,
Qu
>
> Thanks,
> Qu
>> Signed-off-by: Martin Wilck <mwilck@arcor.de>
>> ---
>>   ctree.h |   15 +++++++++------
>>   1 files changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/ctree.h b/ctree.h
>> index 89036de..1d5a5fc 100644
>> --- a/ctree.h
>> +++ b/ctree.h
>> @@ -1414,27 +1414,30 @@ BTRFS_SETGET_STACK_FUNCS(stack_inode_flags,
>>                struct btrfs_inode_item, flags, 64);
>>     static inline struct btrfs_timespec *
>> -btrfs_inode_atime(struct btrfs_inode_item *inode_item)
>> +btrfs_inode_atime(struct extent_buffer *eb,
>> +          struct btrfs_inode_item *inode_item)
>>   {
>>       unsigned long ptr = (unsigned long)inode_item;
>>       ptr += offsetof(struct btrfs_inode_item, atime);
>> -    return (struct btrfs_timespec *)ptr;
>> +    return (struct btrfs_timespec *)(ptr + eb->data);
>>   }
>>     static inline struct btrfs_timespec *
>> -btrfs_inode_mtime(struct btrfs_inode_item *inode_item)
>> +btrfs_inode_mtime(struct extent_buffer *eb,
>> +          struct btrfs_inode_item *inode_item)
>>   {
>>       unsigned long ptr = (unsigned long)inode_item;
>>       ptr += offsetof(struct btrfs_inode_item, mtime);
>> -    return (struct btrfs_timespec *)ptr;
>> +    return (struct btrfs_timespec *)(ptr + eb->data);
>>   }
>>     static inline struct btrfs_timespec *
>> -btrfs_inode_ctime(struct btrfs_inode_item *inode_item)
>> +btrfs_inode_ctime(struct extent_buffer *eb,
>> +          struct btrfs_inode_item *inode_item)
>>   {
>>       unsigned long ptr = (unsigned long)inode_item;
>>       ptr += offsetof(struct btrfs_inode_item, ctime);
>> -    return (struct btrfs_timespec *)ptr;
>> +    return (struct btrfs_timespec *)(ptr + eb->data);
>>   }
>>     static inline struct btrfs_timespec *
>

