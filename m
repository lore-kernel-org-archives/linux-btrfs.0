Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44081 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751122AbdFBDxb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jun 2017 23:53:31 -0400
Subject: Re: [PATCH v2 1/9] btrfs: Introduce btrfs_is_namelen_valid to avoid
 reading beyond boundary
To: Nikolay Borisov <nborisov@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
References: <20170601085716.25898-1-suy.fnst@cn.fujitsu.com>
 <20170601085716.25898-2-suy.fnst@cn.fujitsu.com>
 <03d086d0-544c-38cd-ecad-c98af1319c91@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <a911e7e4-8479-c79c-d181-2223001f91e7@cn.fujitsu.com>
Date: Fri, 2 Jun 2017 11:55:29 +0800
MIME-Version: 1.0
In-Reply-To: <03d086d0-544c-38cd-ecad-c98af1319c91@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/01/2017 05:44 PM, Nikolay Borisov wrote:
> 
> 
> On  1.06.2017 11:57, Su Yue wrote:
>> Introduce function btrfs_is_namelen_valid.
>>
>> The function compares arg @namelen with item boundary then returns value
>> represents namelen is valid or not.
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/ctree.h    |  2 ++
>>   fs/btrfs/dir-item.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 75 insertions(+)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 643c70d2b2e6..70d8778f849b 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -3037,6 +3037,8 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
>>   						 struct btrfs_path *path,
>>   						 const char *name,
>>   						 int name_len);
>> +bool btrfs_is_namelen_valid(struct extent_buffer *leaf, int slot,
>> +			    unsigned long start, u16 namelen);
>>   
>>   /* orphan.c */
>>   int btrfs_insert_orphan_item(struct btrfs_trans_handle *trans,
>> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
>> index c24d615e3d7f..fbda228192ed 100644
>> --- a/fs/btrfs/dir-item.c
>> +++ b/fs/btrfs/dir-item.c
>> @@ -484,3 +484,76 @@ int verify_dir_item(struct btrfs_fs_info *fs_info,
>>   
>>   	return 0;
>>   }
>> +
>> +bool btrfs_is_namelen_valid(struct extent_buffer *leaf, int slot,
>> +			    unsigned long start, u16 namelen)
>> +{
>> +	struct btrfs_fs_info *fs_info = leaf->fs_info;
>> +	struct btrfs_key key;
>> +	u32 read_start;
>> +	u32 read_end;
>> +	u32 item_start;
>> +	u32 item_end;
>> +	u32 size;
>> +	bool ret = true;
>> +
>> +	ASSERT(start > btrfs_leaf_data(leaf));
>> +
>> +	read_start = start - btrfs_leaf_data(leaf);
>> +	read_end = read_start + namelen;
>> +	item_start = btrfs_item_offset_nr(leaf, slot);
>> +	item_end = btrfs_item_end_nr(leaf, slot);
>> +
>> +	btrfs_item_key_to_cpu(leaf, &key, slot);
>> +
>> +	switch (key.type) {
>> +	case BTRFS_DIR_ITEM_KEY:
>> +	case BTRFS_XATTR_ITEM_KEY:
>> +	case BTRFS_DIR_INDEX_KEY:
>> +		size = sizeof(struct btrfs_dir_item);
>> +		break;
>> +	case BTRFS_INODE_REF_KEY:
>> +		size = sizeof(struct btrfs_inode_ref);
>> +		break;
>> +	case BTRFS_INODE_EXTREF_KEY:
>> +		size = sizeof(struct btrfs_inode_extref);
>> +		break;
>> +	default:
>> +		size = 0;
>> +	}
>> +
>> +	if (!size) {
>> +		ret = false;
>> +		goto out;
>> +	}
> 
> Why don't you fold this check directly in the 'default' case in the
> switch. It makes more clear the intention that this function only
> handles the items, explicitly listed in the 'case' statements.
> 
Thanks for your advice! :)
>> +
>> +	if (read_start < item_start) {
>> +		ret = false;
>> +		goto out;
>> +	}
>> +	if (read_end > item_end) {
>> +		ret = false;
>> +		goto out;
>> +	}
>> +
>> +	/* there shall be item(s) before name */
>> +	if (read_start - item_start < size) {
>> +		ret = false;
>> +		goto out;
>> +	}
>> +
>> +	/*
>> +	 * This may be the last item in the slot
>> +	 * Or same type item(s) is left between read_end and item_end
>> +	 */
>> +	if (item_end != read_end &&
>> +	    item_end - read_end < size) {
>> +		ret = false;
>> +		goto out;
>> +	}
>> +out:
>> +	if (!ret)
>> +		btrfs_crit(fs_info, "invalid dir item name len: %u",
>> +			   (unsigned int)namelen);
>> +	return ret;
>> +}
>>
> 
> 


