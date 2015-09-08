Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:27237 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbIHJCq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 05:02:46 -0400
Message-ID: <55EEA428.4080006@huawei.com>
Date: Tue, 8 Sep 2015 17:02:32 +0800
From: Sheng Yong <shengyong1@huawei.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: trival fix of __btrfs_set_acl error handling
References: <1441702002-109706-1-git-send-email-shengyong1@huawei.com> <55EEA159.5060306@cn.fujitsu.com>
In-Reply-To: <55EEA159.5060306@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Qu

On 9/8/2015 4:50 PM, Qu Wenruo wrote:
> Sheng Yong wrote on 2015/09/08 08:46 +0000:
>> * If the allocation failed, don't free to free it, even though kfree
>>    allows to free a NULL pointer.
>> * If posix_acl_to_xattr() failed, cleanup the allocation and return
>>    the error directly.
> So, what's the point?
> For me, I didn't see the pros of the change.
> As kfree() allow NULL pointer, why not use it?
In fact, there is no semantic changes. It's just because when I walk through
the code, and find there is no need to call kfree(), and could be cleaned up.
It's fine to keep as it is :)

thanks,
Sheng
> 
> Thanks,
> Qu
>>
>> Signed-off-by: Sheng Yong <shengyong1@huawei.com>
>> ---
>>   fs/btrfs/acl.c | 14 +++++++-------
>>   1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
>> index 9a0124a..6d01d09 100644
>> --- a/fs/btrfs/acl.c
>> +++ b/fs/btrfs/acl.c
>> @@ -103,18 +103,18 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
>>       if (acl) {
>>           size = posix_acl_xattr_size(acl->a_count);
>>           value = kmalloc(size, GFP_NOFS);
>> -        if (!value) {
>> -            ret = -ENOMEM;
>> -            goto out;
>> -        }
>> +        if (!value)
>> +            return -ENOMEM;
>>
>>           ret = posix_acl_to_xattr(&init_user_ns, acl, value, size);
>> -        if (ret < 0)
>> -            goto out;
>> +        if (ret < 0) {
>> +            kfree(value);
>> +            return ret;
>> +        }
>>       }
>>
>>       ret = __btrfs_setxattr(trans, inode, name, value, size, 0);
>> -out:
>> +
>>       kfree(value);
>>
>>       if (!ret)
>>
> 
> 

