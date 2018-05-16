Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49993 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750995AbeEPHGj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 03:06:39 -0400
Subject: Re: [PATCH 4/6] Btrfs: remove unused check of skip_locking
To: Nikolay Borisov <nborisov@suse.com>, Liu Bo <bo.liu@linux.alibaba.com>,
        linux-btrfs@vger.kernel.org
References: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526406728-109055-5-git-send-email-bo.liu@linux.alibaba.com>
 <760f01dd-db0f-0110-d48b-751cfcd733e8@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f1722837-aef9-1d82-0705-3df02323edb8@gmx.com>
Date: Wed, 16 May 2018 15:06:24 +0800
MIME-Version: 1.0
In-Reply-To: <760f01dd-db0f-0110-d48b-751cfcd733e8@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年05月16日 15:03, Nikolay Borisov wrote:
> 
> 
> On 15.05.2018 20:52, Liu Bo wrote:
>> The check is superfluous since all of callers who set search_for_commit
>> also have skip_locking set.
> 
> This is false. For example btrfs_qgroup_rescan_worker sets
> search_commit_root = 1 but doesn't set skip locking. So either your
> assumption is wrong or the code in btrfs_qgroup_rescan_worker has missed
> that (which seems more likely).

Liu's assumption on all commit root searcher don't need lock looks good
to me, thus qgroup code could set skip_locking.

> 
> I think this change necessitates either:
> 
> a) ASSERT(p->skip_locking) inside the if (p->search_commit_root) branch
> 
> or
> 
> b) Unconditionally setting ->skip_locking if we have set
> search_commit_root and removing opencoded set of skip_locking alongside
> search_commit_root.
> 
> I think b) is the better option since it provides "fire and forget"
> semantics when you want to search the commit root, since it's only read
> only.

b) looks better to me.

Thanks,
Qu

> 
>>
>> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
>> ---
>>  fs/btrfs/ctree.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index 399839df7a8f..cf34eca41d4e 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -2623,8 +2623,6 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
>>  		level = btrfs_header_level(b);
>>  		if (p->need_commit_sem)
>>  			up_read(&fs_info->commit_root_sem);
>> -		if (!p->skip_locking)
>> -			btrfs_tree_read_lock(b);
>>  
>>  		goto out;
>>  	}
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
