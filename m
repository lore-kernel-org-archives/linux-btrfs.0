Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:47665 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751085AbeFVHm6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 03:42:58 -0400
Subject: Re: [PATCH] btrfs: treat -ERANGE as an error case in btrfs_get_acl()
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <20180622025816.29239-1-cgxu519@gmx.com>
 <88554c7b-f495-0295-574f-094a5181d9f1@gmx.com>
From: cgxu519 <cgxu519@gmx.com>
Message-ID: <869f200a-e214-2b2f-66a6-3fb58df3423d@gmx.com>
Date: Fri, 22 Jun 2018 15:42:41 +0800
MIME-Version: 1.0
In-Reply-To: <88554c7b-f495-0295-574f-094a5181d9f1@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/22/2018 01:59 PM, Qu Wenruo wrote:
>
> On 2018年06月22日 10:58, Chengguang Xu wrote:
>> Currently, when encoutering -ERANGE in btrfs_get_acl(),
>> just set acl to NULL so that we cannot get proper
>> acl information but the operation looks successful.
>>
>> This patch treats -ERANGE as an error case and meanwhile
>> print real errno before translating errno to -EIO.
>>
>> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
>> ---
>>   fs/btrfs/acl.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
>> index 15e1dfef56a5..7b3a83dd917c 100644
>> --- a/fs/btrfs/acl.c
>> +++ b/fs/btrfs/acl.c
>> @@ -42,9 +42,10 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
>>   	}
>>   	if (size > 0) {
>>   		acl = posix_acl_from_xattr(&init_user_ns, value, size);
>> -	} else if (size == -ERANGE || size == -ENODATA || size == 0) {
>> +	} else if (size == -ENODATA || size == 0) {
>>   		acl = NULL;
>>   	} else {
>> +		pr_err_ratelimited("BTRFS: get acl failed, err=%d\n", size);
> Is there any special reason to output this message even it's rate limited?
> This looks much like a debug output, no to mention we have
> btrfs_err/warn/info() wrapper to output with proper fs UUID.
Yeah, it will be better replacing pr_err with btrfs_err. The motivation to
print error message here is for helping debug when failing into error case.
As you know, most error code here will be override to -EIO, so I hope
to record a hint to indicate what has happened.

>
>>   		acl = ERR_PTR(-EIO);
> in fact we should let @acl to contain the correct error code from
> btrfs_getxattr(), other than overriding it with -EIO.
I'm also not so sure about the reason for overriding the errno with -EIO,
maybe it's easy to understand for end-user?

Thanks,
Chengguang.


