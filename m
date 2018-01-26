Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:29749 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751852AbeAZKKb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 05:10:31 -0500
Subject: Re: [PATCH 09/15] btrfs-progs: lowmem check: change logic of leaf
 process if repair
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-10-suy.fnst@cn.fujitsu.com>
 <82116eb9-1ae0-a619-142e-79b27f44d431@gmx.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <b2a9c5af-65e3-e2f9-fa65-be4d8d912612@cn.fujitsu.com>
Date: Fri, 26 Jan 2018 18:15:09 +0800
MIME-Version: 1.0
In-Reply-To: <82116eb9-1ae0-a619-142e-79b27f44d431@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/26/2018 06:01 PM, Qu Wenruo wrote:
> 
> 
> On 2018年01月26日 16:35, Su Yue wrote:
>> In lowmem check without repair, process_one_leaf_v2() will process one
>> entire leaf and inner check_inode_item() leads path point next
>> leaf.
>> In the beginning, process_one_leaf_v2() will let path point fist inode
>> item or first position where inode id changed.
>>
>> However, in lowmem repair, process_one_leaf_v2() will be interrupted
>> to process one leaf because repair will CoW the leaf. Then some items
>> unprocessed is skipped.
>> Since repair may also delete some items, we can't use tricks like
>> record last checked key.
>>
>> So, only for lowmem repair:
>> 1. check_inode_item is responsible for handle case missing inode item.
> 
> I think the idea to use inode item as the indicator is a good idea.
> And since only check_inode_item() can delete inode item, let it to
> handle the path is reasonable.
> 
>> 2. process_one_leaf_v2() do not modify path manually, and check_inode()
>>     promise that @path points last checked item.
>>     Only when something are fixed, process_one_leaf_v2() will continue
>>     to check in next round.
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>   cmds-check.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++--------
>>   1 file changed, 59 insertions(+), 9 deletions(-)
>>
>> diff --git a/cmds-check.c b/cmds-check.c
>> index e57eea4e61c9..ae0a9e146399 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -2007,6 +2007,8 @@ static int process_one_leaf_v2(struct btrfs_root *root, struct btrfs_path *path,
>>   
>>   	cur_bytenr = cur->start;
>>   
>> +	if (repair)
>> +		goto again;
>>   	/* skip to first inode item or the first inode number change */
>>   	nritems = btrfs_header_nritems(cur);
>>   	for (i = 0; i < nritems; i++) {
>> @@ -2033,9 +2035,12 @@ again:
>>   		goto out;
>>   
>>   	/* still have inode items in thie leaf */
>> -	if (cur->start == cur_bytenr)
>> +	if (cur->start == cur_bytenr) {
>> +		ret = btrfs_next_item(root, path);
>> +		if (ret > 0)
>> +			goto out;
>>   		goto again;
>> -
>> +	}
>>   	/*
>>   	 * we have switched to another leaf, above nodes may
>>   	 * have changed, here walk down the path, if a node
>> @@ -5721,6 +5726,8 @@ static int repair_dir_item(struct btrfs_root *root, struct btrfs_key *key,
>>   				      ino);
>>   			}
>>   		}
>> +	} else {
>> +		true_filetype = filetype;
> 
> This modification doesn't seems related to this patch.
> 
> Maybe it's better to move it 4th patch?
> 
Yep.
>>   	}
>>   
>>   	/*
>> @@ -6489,6 +6496,45 @@ out:
>>   	return ret;
>>   }
>>   
>> +/*
>> + * Try insert new inode item frist.
>> + * If failed, jump to next inode item.
>> + */
>> +static int handle_inode_item_missing(struct btrfs_root *root,
>> +				     struct btrfs_path *path)
>> +{
>> +	struct btrfs_key key;
>> +	int ret;
>> +
>> +	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +
>> +	ret = repair_inode_item_missing(root, key.objectid, 0);
>> +	if (!ret) {
>> +		btrfs_release_path(path);
>> +		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>> +		if (ret)
>> +			goto next_inode;
>> +		else
>> +			goto out;
>> +	}
>> +
>> +next_inode:
>> +	error("inode item[%llu] is missing, skip to check next inode",
>> +	      key.objectid);
>> +	while (1) {
>> +		ret = btrfs_next_item(root, path);
>> +		if (ret > 0)
>> +			goto out;
> 
> ret < 0 case is not handled.
> 
>> +		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +		if (key.type == BTRFS_INODE_ITEM_KEY) {
>> +			ret = 0;
>> +			break;
>> +		}
>> +	}
>> +out:
>> +	return ret;
>> +}
>> +
>>   /*
>>    * Check INODE_ITEM and related ITEMs (the same inode number)
>>    * 1. check link count
>> @@ -6536,6 +6582,13 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
>>   			err |= LAST_ITEM;
>>   		return err;
>>   	}
>> +	if (key.type != BTRFS_INODE_ITEM_KEY && repair) {
>> +		ret = handle_inode_item_missing(root, path);
>> +		if (ret > 0)
>> +			err |= LAST_ITEM;
>> +		if (ret)
>> +			return err;
>> +	}
>>   
>>   	ii = btrfs_item_ptr(node, slot, struct btrfs_inode_item);
>>   	isize = btrfs_inode_size(node, ii);
>> @@ -6561,7 +6614,6 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
>>   		btrfs_item_key_to_cpu(node, &key, slot);
>>   		if (key.objectid != inode_id)
>>   			goto out;
>> -
>>   		switch (key.type) {
>>   		case BTRFS_INODE_REF_KEY:
>>   			ret = check_inode_ref(root, &key, path, namebuf,
>> @@ -6608,12 +6660,10 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
>>   	}
>>   
>>   out:
>> -	if (err & LAST_ITEM) {
>> -		btrfs_release_path(path);
>> -		ret = btrfs_search_slot(NULL, root, &last_key, path, 0, 0);
>> -		if (ret)
>> -			return err;
>> -	}
>> +	btrfs_release_path(path);
>> +	ret = btrfs_search_slot(NULL, root, &last_key, path, 0, 0);
>> +	if (ret)
>> +		return err;
> 
> Why the LAST_ITEM bit is ignored now?
> 
My bad. Wrong commit message. This patch influnces lowmem check too.
Here check_inode_item() points to last checked item.
Above process_one_leaf_v2() calls btrfs_next_item() but needs more
strict condition. Will fix it.

Thank,
Su

> Thanks,
> Qu
> 
>>   
>>   	/* verify INODE_ITEM nlink/isize/nbytes */
>>   	if (dir) {
>>
> 


