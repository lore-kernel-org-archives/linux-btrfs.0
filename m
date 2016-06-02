Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63031 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750960AbcFBBBb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2016 21:01:31 -0400
Subject: Re: [PATCH v10 04/21] btrfs: dedupe: Introduce function to remove
 hash from in-memory tree
To: Mark Fasheh <mfasheh@suse.de>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-5-git-send-email-quwenruo@cn.fujitsu.com>
 <20160601194028.GG7633@wotan.suse.de>
CC: <linux-btrfs@vger.kernel.org>, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <d3366304-bc56-1b8f-82d8-84d4dbb98fe0@cn.fujitsu.com>
Date: Thu, 2 Jun 2016 09:01:25 +0800
MIME-Version: 1.0
In-Reply-To: <20160601194028.GG7633@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/02/2016 03:40 AM, Mark Fasheh wrote:
> On Fri, Apr 01, 2016 at 02:34:55PM +0800, Qu Wenruo wrote:
>> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>
>> Introduce static function inmem_del() to remove hash from in-memory
>> dedupe tree.
>> And implement btrfs_dedupe_del() and btrfs_dedup_destroy() interfaces.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>  fs/btrfs/dedupe.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 105 insertions(+)
>>
>> diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
>> index 4e8455e..a229ded 100644
>> --- a/fs/btrfs/dedupe.c
>> +++ b/fs/btrfs/dedupe.c
>> @@ -303,3 +303,108 @@ int btrfs_dedupe_add(struct btrfs_trans_handle *trans,
>>  		return inmem_add(dedupe_info, hash);
>>  	return -EINVAL;
>>  }
>> +
>> +static struct inmem_hash *
>> +inmem_search_bytenr(struct btrfs_dedupe_info *dedupe_info, u64 bytenr)
>> +{
>> +	struct rb_node **p = &dedupe_info->bytenr_root.rb_node;
>> +	struct rb_node *parent = NULL;
>> +	struct inmem_hash *entry = NULL;
>> +
>> +	while (*p) {
>> +		parent = *p;
>> +		entry = rb_entry(parent, struct inmem_hash, bytenr_node);
>> +
>> +		if (bytenr < entry->bytenr)
>> +			p = &(*p)->rb_left;
>> +		else if (bytenr > entry->bytenr)
>> +			p = &(*p)->rb_right;
>> +		else
>> +			return entry;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +/* Delete a hash from in-memory dedupe tree */
>> +static int inmem_del(struct btrfs_dedupe_info *dedupe_info, u64 bytenr)
>> +{
>> +	struct inmem_hash *hash;
>> +
>> +	mutex_lock(&dedupe_info->lock);
>> +	hash = inmem_search_bytenr(dedupe_info, bytenr);
>> +	if (!hash) {
>> +		mutex_unlock(&dedupe_info->lock);
>> +		return 0;
>> +	}
>> +
>> +	__inmem_del(dedupe_info, hash);
>> +	mutex_unlock(&dedupe_info->lock);
>> +	return 0;
>> +}
>> +
>> +/* Remove a dedupe hash from dedupe tree */
>> +int btrfs_dedupe_del(struct btrfs_trans_handle *trans,
>> +		     struct btrfs_fs_info *fs_info, u64 bytenr)
>> +{
>> +	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
>> +
>> +	if (!fs_info->dedupe_enabled)
>> +		return 0;
>> +
>> +	if (WARN_ON(dedupe_info == NULL))
>> +		return -EINVAL;
>> +
>> +	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
>> +		return inmem_del(dedupe_info, bytenr);
>> +	return -EINVAL;
>> +}
>> +
>> +static void inmem_destroy(struct btrfs_dedupe_info *dedupe_info)
>> +{
>> +	struct inmem_hash *entry, *tmp;
>> +
>> +	mutex_lock(&dedupe_info->lock);
>> +	list_for_each_entry_safe(entry, tmp, &dedupe_info->lru_list, lru_list)
>> +		__inmem_del(dedupe_info, entry);
>> +	mutex_unlock(&dedupe_info->lock);
>> +}
>> +
>> +int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
>> +{
>> +	struct btrfs_dedupe_info *dedupe_info;
>> +	int ret;
>> +
>> +	/* Here we don't want to increase refs of dedupe_info */
>> +	fs_info->dedupe_enabled = 0;
>
> Can this clear of fs_info->dedupe_enabled race with another thread in write?
> I don't see any locking (but perhaps that comes in a later patch).
> 	--Mark

Here we use sync fs to ensure no dedupe write will happen later.
(No need to ensure current transaction will go through dedupe)

Different buffered writer may get different dedupe_enabled flag, but 
whether we do dedupe is not determined by the flag at buffered write 
time.(For this V10 patch)

Instead it's determined by the flag when we run delalloc range.
And we use sync_fs() to write all dirty pages, ensuring no dedupe write 
will happen later, then freeing dedupe_info.

So it's should be fine, and test cases like btrfs/200(not mainlined) 
will test it.


Although the behavior may change a little in V11, to handle ENOSPC problem.

In next version, whether doing dedupe is determined at buffered write 
time, and restore the result to io_tree, to handle metadata reservation 
better.
And still use sync_fs() to ensure no other race.

Thanks,
Qu

>
> --
> Mark Fasheh
>
>


