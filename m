Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49009 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbeIQSXJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Sep 2018 14:23:09 -0400
Subject: Re: [PATCH v3 4/7] btrfs-progs: lowmem: search key of root again
 after check_fs_root() after repair
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180917072852.25831-1-suy.fnst@cn.fujitsu.com>
 <20180917072852.25831-5-suy.fnst@cn.fujitsu.com>
 <0841e3f5-0e2c-220b-4627-41347a89280c@gmx.com>
From: Su Yue <Damenly_Su@gmx.com>
Message-ID: <b26bc272-9756-cbfd-1e78-0df999ee22c2@gmx.com>
Date: Mon, 17 Sep 2018 20:55:47 +0800
MIME-Version: 1.0
In-Reply-To: <0841e3f5-0e2c-220b-4627-41347a89280c@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/17 8:51 PM, Qu Wenruo wrote:
> 
> 
> On 2018/9/17 下午3:28, Su Yue wrote:
>> In check_fs_roots_lowmem(), we do search and follow the resulted path
>> to call check_fs_root(), then call btrfs_next_item() to check next
>> root.
>> However, if repair is enabled, the root tree can be cowed, the
>> existed path can cause strange errors.
>>
>> Solution:
>>    If repair, save the key before calling check_fs_root,
>>    search the saved key again before checking next root.
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> 
> The idea is pretty valid, however I'm not pretty sure about one practice
> below.
> 
>> ---
>>   check/mode-lowmem.c | 22 ++++++++++++++++++++++
>>   1 file changed, 22 insertions(+)
>>
>> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
>> index 4db12cc7f9fe..db44456fd85b 100644
>> --- a/check/mode-lowmem.c
>> +++ b/check/mode-lowmem.c
>> @@ -4967,9 +4967,13 @@ int check_fs_roots_lowmem(struct btrfs_fs_info *fs_info)
>>   	}
>>   
>>   	while (1) {
>> +		struct btrfs_key saved_key;
>> +
>>   		node = path.nodes[0];
>>   		slot = path.slots[0];
>>   		btrfs_item_key_to_cpu(node, &key, slot);
>> +		if (repair)
>> +			saved_key = key;
> 
> Is this OK? Shouldn't it be something like memcpy(&saved_key, &key,
> sizeof(key));
> 
> Or some new C standard make it work?
> 
I don't quite know how C89 standard defines this behavior.
It should work in C99...

Seems you are not familiar with this style, will use memcpy.

Thanks,
Su
> Although compiler doesn't give any warning on this.
> 
> Thanks,
> Qu
> 
>>   		if (key.objectid > BTRFS_LAST_FREE_OBJECTID)
>>   			goto out;
>>   		if (key.type == BTRFS_ROOT_ITEM_KEY &&
>> @@ -5000,6 +5004,24 @@ int check_fs_roots_lowmem(struct btrfs_fs_info *fs_info)
>>   			err |= ret;
>>   		}
>>   next:
>> +		/*
>> +		 * Since root tree can be cowed during repair,
>> +		 * here search the saved key again.
>> +		 */
>> +		if (repair) {
>> +			btrfs_release_path(&path);
>> +			ret = btrfs_search_slot(NULL, fs_info->tree_root,
>> +						&saved_key, &path, 0, 0);
>> +			/* Repair never deletes trees, search must succeed. */
>> +			if (ret > 0)
>> +				ret = -ENOENT;
>> +			if (ret) {
>> +				error(
>> +			"search root key[%llu %u %llu] failed after repair: %s",
>> +				      saved_key.objectid, saved_key.type,
>> +				      saved_key.offset, strerror(-ret));
>> +			}
>> +		}
>>   		ret = btrfs_next_item(tree_root, &path);
>>   		if (ret > 0)
>>   			goto out;
>>
