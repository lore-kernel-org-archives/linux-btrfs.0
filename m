Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:50358 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752521AbeAZJ1L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 04:27:11 -0500
Subject: Re: [PATCH 02/15] btrfs-progs: lowmem check: find and guess inode
 filetype
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-3-suy.fnst@cn.fujitsu.com>
 <cafbed34-4b59-7cc3-3cf9-f52d9e74ba4f@gmx.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <568ca340-ea42-0247-5594-cc75111eb748@cn.fujitsu.com>
Date: Fri, 26 Jan 2018 17:31:24 +0800
MIME-Version: 1.0
In-Reply-To: <cafbed34-4b59-7cc3-3cf9-f52d9e74ba4f@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/26/2018 05:14 PM, Qu Wenruo wrote:
> 
> 
> On 2018年01月26日 16:35, Su Yue wrote:
>> Introduce find_file_type_lowmem() and guess_file_type_lowmem().
>>
>> find_file_type_lowmem() gets filetypes from inode_item, dir_item and
>> dir_index. If two of three's filetype are same and valid, it thinks
>> the value is correct.
>>
>> guess_file_type_lowmem() searches file_extent and dir_item/index then
>> returns with filetype.
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>   cmds-check.c | 193 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 193 insertions(+)
>>
>> diff --git a/cmds-check.c b/cmds-check.c
>> index e3505a7f9d6b..b200fdccf0e5 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -3306,6 +3306,199 @@ static int find_file_type(struct inode_record *rec, u8 *type)
>>   	return -ENOENT;
>>   }
>>   
>> +/*
>> + * Fetch filetype from exited completed dir_item, dir_index and inode_item.
>                            ^^^^^^
>                            existing?

Oh.. a Typo.
>> + * If two of tree items'filetype are same, we think the type is trusted.
>> + *
>> + * Return 0 if file type is found and BTRFS_FT_* is stored into type.
>> + * Return <0 if file type is not found.
> 
> This also includes extra error like -EIO from btrfs_search_slot().
> 
>> + */
>> +static int find_file_type_lowmem(struct btrfs_root *root, u64 ino, u8 *type)
>> +{
>> +	struct btrfs_key key;
>> +	struct btrfs_path path;
>> +	struct btrfs_path path2;
>> +	struct btrfs_inode_ref *iref;
>> +	struct btrfs_dir_item *dir_item;
>> +	struct btrfs_dir_item *dir_index;
>> +	struct extent_buffer *eb;
>> +	u64 dir;
>> +	u64 index;
>> +	char namebuf[BTRFS_NAME_LEN] = {0};
>> +	u32 namelen;
>> +	u8 inode_filetype = BTRFS_FT_UNKNOWN;
>> +	u8 dir_item_filetype;
>> +	u8 dir_index_filetype;
>> +	u8 true_file_type;
>> +	int slot;
>> +	int ret;
>> +
>> +	key.objectid = ino;
>> +	key.type = BTRFS_INODE_ITEM_KEY;
>> +	key.offset = 0;
>> +
>> +	btrfs_init_path(&path);
>> +	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
>> +	if (ret < 0)
>> +		goto out;
>> +	if (!ret) {
>> +		struct btrfs_inode_item *ii;
>> +
>> +		ii = btrfs_item_ptr(path.nodes[0], path.slots[0],
>> +				    struct btrfs_inode_item);
>> +		inode_filetype = imode_to_type(btrfs_inode_mode(path.nodes[0],
>> +								ii));
>> +	}
>> +
>> +	key.objectid = ino;
>> +	key.type = BTRFS_INODE_REF_KEY;
>> +	key.offset = (u64)-1;
>> +
>> +	btrfs_release_path(&path);
>> +	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
>> +	if (ret < 0)
>> +		goto out;
>> +	if (!ret) {
>> +		ret = -EIO;
>> +		goto out;
>> +	}
>> +
>> +	btrfs_init_path(&path2);
>> +next:
>> +	btrfs_release_path(&path2)> +	ret = btrfs_previous_item(root, &path, ino, BTRFS_INODE_REF_KEY);
>> +	if (ret) {
>> +		ret = -ENOENT;
> 
> For ret < 0 case, return value is overwritten.
> 
Will fix it.
> 
>> +		goto out;
>> +	}
>> +
>> +	eb = path.nodes[0];
>> +	slot = path.slots[0];
>> +	btrfs_item_key_to_cpu(eb, &key, slot);
>> +	dir = key.offset;
>> +	iref = btrfs_item_ptr(eb, slot, struct btrfs_inode_ref);
>> +	index = btrfs_inode_ref_index(eb, iref);
>> +	namelen = btrfs_inode_ref_name_len(eb, iref);
>> +	read_extent_buffer(eb, namebuf, (unsigned long)(iref + 1), namelen);
>> +
>> +	dir_index = btrfs_lookup_dir_index(NULL, root, &path2, dir, namebuf,
>> +					   namelen, index, 0);
>> +	if (!dir_index)
>> +		goto next;
>> +	dir_index_filetype = btrfs_dir_type(path2.nodes[0], dir_index);
>> +	btrfs_release_path(&path2);
>> +	if (dir_index_filetype == inode_filetype) {
>> +		true_file_type = inode_filetype;
>> +		goto found;
>> +	}
>> +
>> +	dir_item = btrfs_lookup_dir_item(NULL, root, &path2, dir, namebuf,
>> +					 namelen, 0);
>> +	if (!dir_item)
>> +		goto next;
>> +	dir_item_filetype = btrfs_dir_type(path2.nodes[0], dir_item);
>> +	btrfs_release_path(&path2);
>> +	if (dir_item_filetype == inode_filetype) {
>> +		true_file_type = inode_filetype;
>> +		goto found;
>> +	}
>> +
>> +	if (dir_index_filetype == dir_item_filetype) {
>> +		true_file_type = dir_index_filetype;
>> +		goto found;
>> +	}
>> +	goto next;
>> +found:
>> +	/* rare case, two of three items are both corrupted */
>> +	if (true_file_type == BTRFS_FT_UNKNOWN ||
>> +	    true_file_type >= BTRFS_FT_MAX)
>> +		goto next;
>> +	*type = true_file_type;
>> +	ret = 0;
>> +out:
>> +	btrfs_release_path(&path);
>> +	return ret;
>> +}
>> +
>> +static int find_normal_file_extent(struct btrfs_root *root, u64 ino);
>> +/*
>> + * Try to determine inode type if type not found.
>> + *
>> + * For found regular file extent, it must be FILE.
>> + * For found dir_item/index, it must be DIR.
>> + *
>> + * Return 0 if file type is confirmed and BTRFS_FT_* is stored into type.
>> + * Return <0 if file type is unknown.
>> + */
>> +static int guess_file_type_lowmem(struct btrfs_root *root, u64 ino, u8 *type)
>> +{
>> +	struct btrfs_key key;
>> +	struct btrfs_path *path = NULL;
>> +	bool is_dir = false;
>> +	bool is_file = false;
>> +	int ret;
>> +
>> +	if (find_normal_file_extent(root, ino)) {
> 
> Nice reusing the existing code.
> 
>> +		is_file = true;
>> +		goto out;
>> +	}
>> +
>> +	key.objectid = ino;
>> +	key.type = BTRFS_DIR_ITEM_KEY;
> 
> You could merge the code together, using just one loop instead of using
> two search separately for DIR_ITEM and DIR_INDEX.
> 
> Search for key (ino, DIR_INDEX, -1), as DIR_INDEX is larger than DIR_ITEM.
> 
> And search backward, not using btrfs_previous_item() but manually
> checking the type (and do prev_leaf() manually).
> It should save you several lines.
> 
I have thought up this way. I prefer to call btrfs_previous_item()
instead because it make code more readable and manually move path
pointer is pretty tricky.

Since your suggestion is more efficient, I will do it in next version.

Thanks,
Su

> Thanks,
> Qu
> 
>> +	key.offset = (u64)-1;
>> +
>> +	path = btrfs_alloc_path();
>> +	if (!path)
>> +		goto out;
>> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>> +	if (ret < 0)
>> +		goto out;
>> +	/*
>> +	 * (u64)-1 may hit the hashed value in offset.
>> +	 */
>> +	if (!ret) {
>> +		is_dir = true;
>> +		goto out;
>> +	}
>> +
>> +	ret = btrfs_previous_item(root, path, ino, BTRFS_DIR_ITEM_KEY);> +	if (!ret) {
>> +		is_dir = true;
>> +		goto out;
>> +	}
>> +
>> +	key.type = BTRFS_DIR_INDEX_KEY;
>> +	key.offset = (u64)-1;
>> +
>> +	btrfs_release_path(path);
>> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>> +	if (ret < 0)
>> +		goto out;
>> +	if (!ret) {
>> +		is_dir = true;
>> +		goto out;
>> +	}
>> +	ret = btrfs_previous_item(root, path, ino, BTRFS_DIR_INDEX_KEY);
>> +	if (!ret) {
>> +		is_dir = true;
>> +		goto out;
>> +	}
>> +out:
>> +	if (path)
>> +		btrfs_release_path(path);
>> +
>> +	if (is_dir) {
>> +		*type = BTRFS_FT_DIR;
>> +		ret = 0;
>> +	} else if (is_file) {
>> +		*type = BTRFS_FT_REG_FILE;
>> +		ret = 0;
>> +	} else {
>> +		ret = -ENOENT;
>> +	}
>> +	return ret;
>> +}
>> +
>>   /*
>>    * To determine the file name for nlink repair
>>    *
>>
> 


