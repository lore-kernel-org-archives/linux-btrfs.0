Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:24058 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726558AbeING17 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 02:27:59 -0400
Subject: Re: [PATCH v2 5/7] btrfs-progs: lowmem: continue to check item in
 last slot while checking inodes
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, <damenly.su@gmail.com>,
        <linux-btrfs@vger.kernel.org>
References: <20180912204924.10089-1-suy.fnst@cn.fujitsu.com>
 <20180912204924.10089-6-suy.fnst@cn.fujitsu.com>
 <e415c063-772b-3dca-fdd1-ed88c90caf8b@gmx.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <7e3ec0fa-e436-6093-22b8-19f9795c4403@cn.fujitsu.com>
Date: Fri, 14 Sep 2018 09:22:48 +0800
MIME-Version: 1.0
In-Reply-To: <e415c063-772b-3dca-fdd1-ed88c90caf8b@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/14/2018 07:43 AM, Qu Wenruo wrote:
> 
> 
> On 2018/9/13 上午4:49, damenly.su@gmail.com wrote:
>> From: Su Yue <suy.fnst@cn.fujitsu.com>
>>
>> After call of check_inode_item(), path may point to the last unchecked
>> slot of the leaf. The outer walk_up_tree() always treats the position
>> as checked item then skips to next item.
> 
> So check_inode_item() always set its path to *unchecked* slot, while
> walk_up_tree() always think its path is set to *checked* slot.
> 
> Then this is indeed a problem.
> 
Yep, that's the case.

>>
>> If the last item was an inode item, yes, it was unchecked.
>> Then walk_up_tree() will think the leaf is checked and walk up to
>> upper node, process_one_leaf() in walk_down_tree() would skip to
>> check next inode item. Which means, the inode item won't be checked.
>>
>> Solution:
>> After check_inode_item returns, if found path point to the last item
>> of a leaf,
> 
> Would you please explain more about why last item makes a difference here?
> 
>  From previous statement, it looks like it's the difference in how
> walk_up_tree() and check_inode_item() handles the path.
> Not really related to last item.
>
Yes, the change is tricky. The core problem is walk_up_tree() will
skip to other nodes. Decreament of slot will let path still
point to the leaf after  walk_up_tree() returns.
Or we must change logical of walk_up_tree() or check_inode_item().

BTW,now process_one_leaf() checks inode_item from first inode_item
or second item with different ino. Change it start from last slot
should be the right way.

Thanks,
Su


Thanks,
Su
> Or did I miss something?
> 
> Thanks,
> Qu
> 
>> decrease path slot manually, so walk_up_tree() will stay
>> on the leaf.
>>
>> Fixes: 5e2dc770471b ("btrfs-progs: check: skip shared node or leaf check for low_memory mode")
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>   check/mode-lowmem.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
>> index 8fc9edab1d66..b6b33786d02b 100644
>> --- a/check/mode-lowmem.c
>> +++ b/check/mode-lowmem.c
>> @@ -2612,6 +2612,18 @@ again:
>>   	if (cur->start == cur_bytenr)
>>   		goto again;
>>   
>> +	/*
>> +	 * path may point at the last item(a inode item maybe) in a leaf.
>> +	 * Without below lines, walk_up_tree() will skip the item which
>> +	 * means all items related to the inode will never be checked.
>> +	 * Decrease the slot manually, walk_up_tree won't skip to next node
>> +	 * if it occurs.
>> +	 */
>> +	if (path->slots[0] + 1 >= btrfs_header_nritems(path->nodes[0])) {
>> +		if (path->slots[0])
>> +			path->slots[0]--;
>> +	}
>> +
>>   	/*
>>   	 * we have switched to another leaf, above nodes may
>>   	 * have changed, here walk down the path, if a node
>>
> 
> 
