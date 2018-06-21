Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39434 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932687AbeFUIdK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 04:33:10 -0400
Subject: Re: [PATCH] btrfs: Streamline memory allocation failure handling in
 btrfs_add_delayed_tree_ref
To: Su Yue <suy.fnst@cn.fujitsu.com>, dsterba@suse.com
References: <20180620142813.GC24375@twin.jikos.cz>
 <1529509392-17381-1-git-send-email-nborisov@suse.com>
 <6f2a0579-0946-ca44-e268-dc866d961a12@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <3cae9ee1-899f-ba9c-b06b-52a48ee8ca8b@suse.com>
Date: Thu, 21 Jun 2018 11:33:08 +0300
MIME-Version: 1.0
In-Reply-To: <6f2a0579-0946-ca44-e268-dc866d961a12@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21.06.2018 11:38, Su Yue wrote:
> 
> 
> On 06/20/2018 11:43 PM, Nikolay Borisov wrote:
>> Currently the function uses 2 goto labels to properly handle allocation
>> failures. This could be simplified by simply re-arranging the code so
>> that allocations are the in the beginning of the function. This allows
>> to use simple return statements. No function changes.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Hi, Nikolay
> 
> I just saw the patch wasn't CCed to mail list.
> It seems that you forgot to CC?

Indeed I seem to have missed that. I will resend

> 
> Thanks,
> Su
> 
>> ---
>>
>> So how about something like that
>>
>>   fs/btrfs/delayed-ref.c | 35 +++++++++++++++++------------------
>>   1 file changed, 17 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>> index 03dec673d12a..c2c2634693e1 100644
>> --- a/fs/btrfs/delayed-ref.c
>> +++ b/fs/btrfs/delayed-ref.c
>> @@ -730,27 +730,33 @@ int btrfs_add_delayed_tree_ref(struct
>> btrfs_fs_info *fs_info,
>>       if (!ref)
>>           return -ENOMEM;
>>   +    head_ref = kmem_cache_alloc(btrfs_delayed_ref_head_cachep,
>> GFP_NOFS);
>> +    if (!head_ref) {
>> +        kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
>> +        return -ENOMEM;
>> +    }
>> +
>> +    if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
>> +        is_fstree(ref_root)) {
>> +        record = kmalloc(sizeof(*record), GFP_NOFS);
>> +        if (!record) {
>> +            kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
>> +            kmem_cache_free(btrfs_delayed_ref_head_cachep, head_ref);
>> +            return -ENOMEM;
>> +        }
>> +    }
>> +
>>       if (parent)
>>           ref_type = BTRFS_SHARED_BLOCK_REF_KEY;
>>       else
>>           ref_type = BTRFS_TREE_BLOCK_REF_KEY;
>> +
>>       init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
>>                   ref_root, action, ref_type);
>>       ref->root = ref_root;
>>       ref->parent = parent;
>>       ref->level = level;
>>   -    head_ref = kmem_cache_alloc(btrfs_delayed_ref_head_cachep,
>> GFP_NOFS);
>> -    if (!head_ref)
>> -        goto free_ref;
>> -
>> -    if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
>> -        is_fstree(ref_root)) {
>> -        record = kmalloc(sizeof(*record), GFP_NOFS);
>> -        if (!record)
>> -            goto free_head_ref;
>> -    }
>> -
>>       init_delayed_ref_head(head_ref, record, bytenr, num_bytes,
>>                     ref_root, 0, action, false, is_system);
>>       head_ref->extent_op = extent_op;
>> @@ -779,13 +785,6 @@ int btrfs_add_delayed_tree_ref(struct
>> btrfs_fs_info *fs_info,
>>           btrfs_qgroup_trace_extent_post(fs_info, record);
>>         return 0;
>> -
>> -free_head_ref:
>> -    kmem_cache_free(btrfs_delayed_ref_head_cachep, head_ref);
>> -free_ref:
>> -    kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
>> -
>> -    return -ENOMEM;
>>   }
>>     /*
>>
> 
> 
> 
