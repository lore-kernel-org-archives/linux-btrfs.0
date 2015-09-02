Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65482 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754623AbbIBP3f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Sep 2015 11:29:35 -0400
Subject: Re: [PATCH 5/6] Btrfs: wire up the free space tree to the extent tree
To: Omar Sandoval <osandov@osandov.com>
References: <cover.1441131625.git.osandov@fb.com>
 <5354d2ad80625f36be4032664a7d39f4c4874119.1441131625.git.osandov@fb.com>
 <55E60129.3070009@fb.com> <20150902044249.GB14575@huxley.hsd1.ca.comcast.net>
CC: <linux-btrfs@vger.kernel.org>, Omar Sandoval <osandov@fb.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <55E715DB.6060305@fb.com>
Date: Wed, 2 Sep 2015 11:29:31 -0400
MIME-Version: 1.0
In-Reply-To: <20150902044249.GB14575@huxley.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/02/2015 12:42 AM, Omar Sandoval wrote:
> On Tue, Sep 01, 2015 at 03:48:57PM -0400, Josef Bacik wrote:
>> On 09/01/2015 03:05 PM, Omar Sandoval wrote:
>>> From: Omar Sandoval <osandov@fb.com>
>>>
>>> The free space tree is updated in tandem with the extent tree. There are
>>> only a handful of places where we need to hook in:
>>>
>>> 1. Block group creation
>>> 2. Block group deletion
>>> 3. Delayed refs (extent creation and deletion)
>>> 4. Block group caching
>>>
>>> Signed-off-by: Omar Sandoval <osandov@fb.com>
>>> ---
>>>   fs/btrfs/extent-tree.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++---
>>>   1 file changed, 70 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index 37179a569f40..3f10df3932f0 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -33,6 +33,7 @@
>>>   #include "raid56.h"
>>>   #include "locking.h"
>>>   #include "free-space-cache.h"
>>> +#include "free-space-tree.h"
>>>   #include "math.h"
>>>   #include "sysfs.h"
>>>   #include "qgroup.h"
>>> @@ -589,7 +590,41 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
>>>   	cache->cached = BTRFS_CACHE_FAST;
>>>   	spin_unlock(&cache->lock);
>>>
>>> -	if (fs_info->mount_opt & BTRFS_MOUNT_SPACE_CACHE) {
>>> +	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
>>> +		if (load_cache_only) {
>>> +			spin_lock(&cache->lock);
>>> +			cache->caching_ctl = NULL;
>>> +			cache->cached = BTRFS_CACHE_NO;
>>> +			spin_unlock(&cache->lock);
>>> +			wake_up(&caching_ctl->wait);
>>> +		} else {
>>> +			mutex_lock(&caching_ctl->mutex);
>>> +			ret = load_free_space_tree(fs_info, cache);
>>> +			if (ret) {
>>> +				btrfs_warn(fs_info, "failed to load free space tree for %llu: %d",
>>> +					   cache->key.objectid, ret);
>>> +				spin_lock(&cache->lock);
>>> +				cache->caching_ctl = NULL;
>>> +				cache->cached = BTRFS_CACHE_ERROR;
>>> +				spin_unlock(&cache->lock);
>>> +				goto tree_out;
>>> +			}
>>> +
>>> +			spin_lock(&cache->lock);
>>> +			cache->caching_ctl = NULL;
>>> +			cache->cached = BTRFS_CACHE_FINISHED;
>>> +			cache->last_byte_to_unpin = (u64)-1;
>>> +			caching_ctl->progress = (u64)-1;
>>> +			spin_unlock(&cache->lock);
>>> +			mutex_unlock(&caching_ctl->mutex);
>>> +
>>> +tree_out:
>>> +			wake_up(&caching_ctl->wait);
>>> +			put_caching_control(caching_ctl);
>>> +			free_excluded_extents(fs_info->extent_root, cache);
>>> +			return 0;
>>> +		}
>>> +	} else if (fs_info->mount_opt & BTRFS_MOUNT_SPACE_CACHE) {
>>>   		mutex_lock(&caching_ctl->mutex);
>>
>> So the reason we have this load_cache_only thing is because the free space
>> cache could be loaded almost instantaneously since it was contiguously
>> allocated.  This isn't the case with the free space tree, and although it is
>> better than the no space cache way of doing things, we are still going to
>> incur a bit of latency when seeking through a large free space tree.  So
>> break this out and make the caching kthread either do the old style load or
>> load the free space tree.  Then you can use the add free space helpers that
>> will wake anybody up waiting on allocations and you incur less direct
>> latency.  Thanks,
>>
>> Josef
>
> Okay, I'll do the load from caching_thread(). Do you think we're going
> to need the need_resched() || rwsem_is_contended(commit_root) check and
> retry for the free space tree like we do with the extent tree? It seems
> like it could get complicated since we would need to worry about the
> format changing underneath us.
>

So we make it so we can't change the format of a block group we're 
caching, problem solved.  But I get your point, we could probably drop 
that since it shouldn't take that long to cache a whole block group, but 
that sort of thinking got us into this situation in the first place. 
We're reading from the commit root anyway, we have to re-search when we 
do this, if the block group has been converted to a bitmap in the 
meantime we'll still end up at the right offset correct?  I think it'll 
be fine.  Thanks,

Josef
