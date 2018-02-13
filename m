Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53128 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751689AbeBMKZr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 05:25:47 -0500
Subject: Re: [PATCH v2] btrfs: fix endianness compatibility during the SB RW
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20180212153749.19705-1-anand.jain@oracle.com>
 <20180213030046.14093-1-anand.jain@oracle.com>
 <358780ca-cb85-4de1-f849-3a642d3fc2c7@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <500c44b5-0c99-100f-6a70-a79d3ad8a388@oracle.com>
Date: Tue, 13 Feb 2018 18:27:13 +0800
MIME-Version: 1.0
In-Reply-To: <358780ca-cb85-4de1-f849-3a642d3fc2c7@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/13/2018 05:01 PM, Qu Wenruo wrote:
> 
> 
> On 2018年02月13日 11:00, Anand Jain wrote:
>> Fixes the endianness bug in the fs_info::super_copy by using its
>> btrfs_set_super...() function to set values in the SB, as these
>> functions manage the endianness compatibility nicely.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> Also went through all btrfs_super_block SETGET functions, greping using
> \><member name>, seems that there are still some left here:
> 
> fs/btrfs/sysfs.c:
> In both btrfs_sectorsize_show() and btrfs_clone_alignment_show():
> 	return snprintf(buf, PAGE_SIZE, "%u\n",
> 			fs_info->super_copy->sectorsize);
> 
> In btrfs_nodesize_show():
> 	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->super_copy->nodesize);

  Oh. Thanks. Will fix. Maybe it's a good idea to add sysfs fixes
  into a new patch.

> And what about cc this to stable kernel?
> IIRC it's a very critical problem for btrfs.
> 
> Maybe cc: stable@vger.kernel.org # v3.2+?

  Thanks for the suggestion. Will do. Any idea what if the patch which
  applied on mainline ends up conflict on LTS, so write a separate patch
  to stable?

Thanks, Anand


> Thanks,
> Qu
> 
>> ---
>> v1->v2: Update change log. Update $Subject.
>>          Old:
>>          [PATCH] btrfs: use set functions to update latest refs to the SB
>>   fs/btrfs/transaction.c | 20 ++++++++++++--------
>>   1 file changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index 04f07144b45c..9220f004001c 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -1722,19 +1722,23 @@ static void update_super_roots(struct btrfs_fs_info *fs_info)
>>   
>>   	super = fs_info->super_copy;
>>   
>> +	/* update latest btrfs_super_block::chunk_root refs */
>>   	root_item = &fs_info->chunk_root->root_item;
>> -	super->chunk_root = root_item->bytenr;
>> -	super->chunk_root_generation = root_item->generation;
>> -	super->chunk_root_level = root_item->level;
>> +	btrfs_set_super_chunk_root(super, root_item->bytenr);
>> +	btrfs_set_super_chunk_root_generation(super, root_item->generation);
>> +	btrfs_set_super_chunk_root_level(super, root_item->level);
>>   
>> +	/* update latest btrfs_super_block::root refs */
>>   	root_item = &fs_info->tree_root->root_item;
>> -	super->root = root_item->bytenr;
>> -	super->generation = root_item->generation;
>> -	super->root_level = root_item->level;
>> +	btrfs_set_super_root(super, root_item->bytenr);
>> +	btrfs_set_super_generation(super, root_item->generation);
>> +	btrfs_set_super_root_level(super, root_item->level);
>> +
>>   	if (btrfs_test_opt(fs_info, SPACE_CACHE))
>> -		super->cache_generation = root_item->generation;
>> +		btrfs_set_super_cache_generation(super, root_item->generation);
>>   	if (test_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags))
>> -		super->uuid_tree_generation = root_item->generation;
>> +		btrfs_set_super_uuid_tree_generation(super,
>> +						     root_item->generation);
>>   }
>>   
>>   int btrfs_transaction_in_commit(struct btrfs_fs_info *info)
>>
> 
