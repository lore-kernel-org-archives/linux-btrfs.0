Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:46535 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728085AbeIQSwY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Sep 2018 14:52:24 -0400
Subject: Re: [PATCH v3 5/7] btrfs-progs: lowmem: do missing check of last item
 after check_inode_item()
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180917072852.25831-1-suy.fnst@cn.fujitsu.com>
 <20180917072852.25831-6-suy.fnst@cn.fujitsu.com>
 <e4ec3fbd-71c3-c59c-1915-0419f06a6c26@gmx.com>
From: Su Yue <Damenly_Su@gmx.com>
Message-ID: <c7f2ed73-94d2-23d8-7503-0611469af54c@gmx.com>
Date: Mon, 17 Sep 2018 21:24:55 +0800
MIME-Version: 1.0
In-Reply-To: <e4ec3fbd-71c3-c59c-1915-0419f06a6c26@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/17 8:53 PM, Qu Wenruo wrote:
> 
> 
> On 2018/9/17 下午3:28, Su Yue wrote:
>> After call of check_inode_item(), path may point to the last unchecked
>> slot of the leaf. The outer walk_up_tree() always treats the position
>> as checked slot then skips to the next. The last item will never be
>> checked.
>>
>> While checking backrefs, path passed to walk_up_tree() always
>> points to a checked slot.
>> While checking fs trees, path passed to walk_up_tree() always
>> points to an unchecked slot.
> 
> Can we unify this behavior?
> I has considered in three ways:
1) Change logical of the process_one_leaf. After it returns, path
points to the next slot checked.
To unify it, we can use saved key but will cost one search_slot time 
during serval nodes(>=1). Or call btrfs_previous_item() after every time 
check_inode_items() returns.

But why? why should we cost some time to swing the path. So I abandoned 1).

2) Change logical of the check_leaf_items(). What does the function
is just traverse all items then returns, which seems quite natural.
So I abandoned it.


3) It's what the patch does. The extra argument may seems strange,
I preferred to this way.

Maybe we can do something after check_leaf_items() returns, is it 
acceptable? I have no idea.

Thanks,
Su

> E.g, always points to an unchecked slot.
> 
> It would make things easier and no need for the extra parameter.
> 
> Thanks,
> Qu
> 
>>
>> Solution:
>> Add an argument @is_checked to walk_up_tree() to decide whether
>> to skip current slot.
>>
>> Fixes: 5e2dc770471b ("btrfs-progs: check: skip shared node or leaf check for low_memory mode")
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>   check/mode-lowmem.c | 37 +++++++++++++++++++++++++++++++++----
>>   1 file changed, 33 insertions(+), 4 deletions(-)
>>
>> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
>> index db44456fd85b..612e5e28e45b 100644
>> --- a/check/mode-lowmem.c
>> +++ b/check/mode-lowmem.c
>> @@ -4597,22 +4597,38 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
>>   	return err;
>>   }
>>   
>> +/*
>> + * Walk up throuh the path. Make path point to next slot to be checked.
>> + * walk_down_tree() should be called after this function.
>> + *
>> + * @root:	root of the tree
>> + * @path:	will point to next slot to check for walk_down_tree()
>> + * @level:	returns with level of next node to be checked
>> + * @is_checked:	means is the current node checked or not
>> + *		if false, the slot is unchecked, do not increase the slot
>> + *		if true, means increase the slot of the current node
>> + *
>> + * Returns 0 means success.
>> + * Returns >0 means the whole loop of walk up/down should be broken.
>> + */
>>   static int walk_up_tree(struct btrfs_root *root, struct btrfs_path *path,
>> -			int *level)
>> +			int *level, bool is_checked)
>>   {
>>   	int i;
>>   	struct extent_buffer *leaf;
>> +	int skip_cur =s_checked ? 1 : 0;
>>   
>>   	for (i =level; i < BTRFS_MAX_LEVEL - 1 && path->nodes[i]; i++) {
>>   		leaf =ath->nodes[i];
>> -		if (path->slots[i] + 1 < btrfs_header_nritems(leaf)) {
>> -			path->slots[i]++;
>> +		if (path->slots[i] + skip_cur < btrfs_header_nritems(leaf)) {
>> +			path->slots[i] +=kip_cur;
>>   			*level =;
>>   			return 0;
>>   		}
>>   		free_extent_buffer(path->nodes[*level]);
>>   		path->nodes[*level] =ULL;
>>   		*level = + 1;
>> +		skip_cur =;
>>   	}
>>   	return 1;
>>   }
>> @@ -4815,7 +4831,20 @@ static int check_btrfs_root(struct btrfs_root *root, int check_all)
>>   			break;
>>   		}
>>   
>> -		ret =alk_up_tree(root, &path, &level);
>> +		/*
>> +		 * The logical of walk trees are shared between backrefs
>> +		 * check and fs trees check.
>> +		 * In checking backrefs(check_all is true), after
>> +		 * check_leaf_items() returns, path points to
>> +		 * last checked item.
>> +		 * In checking fs roots(check_all is false), after
>> +		 * process_one_leaf() returns, path points to unchecked item.
>> +		 *
>> +		 * walk_up_tree() is reponsible to make path point to next
>> +		 * slot to be checked, above case is handled in
>> +		 * walk_up_tree().
>> +		 */
>> +		ret =alk_up_tree(root, &path, &level, check_all);
>>   		if (ret !=) {
>>   			/* Normal exit, reset ret to err */
>>   			ret =rr;
>>
