Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46141 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754357AbaLJIMA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 03:12:00 -0500
Message-ID: <5487FFAD.9090601@cn.fujitsu.com>
Date: Wed, 10 Dec 2014 16:09:17 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, <cyril.scetbon@free.fr>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: qgroup: free reserved in exceeding quota.
References: <BA68E495-8B7B-4F0F-A64B-0413B1480B9C@free.fr> <b5f44049f85f372a286a1c7e600d274dc03a2e25.1418124311.git.yangds.fnst@cn.fujitsu.com> <54871850.3020809@fb.com>
In-Reply-To: <54871850.3020809@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/09/2014 11:42 PM, Josef Bacik wrote:
> On 12/09/2014 06:27 AM, Dongsheng Yang wrote:
>> When we exceed quota limit in writing, we will free
>> some reserved extent when we need to drop but not free
>> account in qgroup. It means, each time we exceed quota
>> in writing, there will be some remain space in qg->reserved
>> we can not use any more. If things go on like this, the
>> all space will be ate up.
>>
>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/extent-tree.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index a84e00d..014b7f2 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -5262,8 +5262,11 @@ out_fail:
>>               to_free = 0;
>>       }
>>       spin_unlock(&BTRFS_I(inode)->lock);
>> -    if (dropped)
>> +    if (dropped) {
>> +        if (root->fs_info->quota_enabled)
>> +            btrfs_qgroup_free(root, dropped * root->nodesize);
>
> This needs to be num_bytes + dropped * root->nodesize.  Thanks,

Let me try to explain why it did not free num_bytes here.

In out_fail, we did not reserve num_bytes in qgroup successfully, then 
we do not need
to free it in out_fail.

The problem this patch attempts to solve is that, when we run into 
out_fail here,
we will drop a outstanding extent. That said, in out_fail here, the 
extra reserved
nodesize for some extents should be freed.

Example:
     1). BTRFS_I(inode)->reserved_extents: 2, 
BTRFS_I(inode)->outstanding_extents: 1.
           In this case, we go intobtrfs_delalloc_reserve_metadata(). 
outstanding_extents
           will be increased at first. then 
BTRFS_I(inode)->outstanding_extents is 2.
           If we want to reserve space and failed. it will goto out_fail.
     2). In out_failed: reserved_extents is 2, outstanding_extents is 2. 
we will get a dropped of 1
          from dropping_outstanding_extent(). And now, 
reserved_extents:1, outstanding_extents:1.

In step 2, we just decrease the reserved_extents without freeing the 
related nodesize in qgroup
at the same time. So it will cause the problem I described in changelog 
which will eat the space.

Therefore, this patch here will free the nodesize related with the 
dropped extents in step 2.
About the num_bytes, as we did not reserve it successfully, no need to 
free it.

With my poor english, there must be something confusing in my 
description. Please correct me
if anything is wrong or not-good-explained.

Thanx
Yang
>
> Josef
>

