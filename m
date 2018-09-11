Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:20135 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726622AbeIKRJN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 13:09:13 -0400
Date: Tue, 11 Sep 2018 20:10:04 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/4] btrfs: factor out btrfs_link_subvol from
 create_subvol
Message-ID: <20180911121004.GB2790@fnst.localdomain>
References: <20180911112903.25985-1-lufq.fnst@cn.fujitsu.com>
 <20180911112903.25985-2-lufq.fnst@cn.fujitsu.com>
 <5a15af8a-687b-3a16-867b-9d1e72d24a28@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <5a15af8a-687b-3a16-867b-9d1e72d24a28@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2018 at 07:57:03PM +0800, Qu Wenruo wrote:
>
>
>On 2018/9/11 下午7:29, Lu Fengqi wrote:
>> The function btrfs_link_subvol is responsible to link the subvolume to
>> the specified directory, which is the opposite of what
>> btrfs_unlink_subvol does.
>> 
>> No functional change.
>> 
>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>
>The patch itself is OK.
>
>Just small nitpicks inlined below.
>
>> ---
>>  fs/btrfs/ioctl.c | 64 +++++++++++++++++++++++++++++++-----------------
>>  1 file changed, 41 insertions(+), 23 deletions(-)
>> 
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 4905d13dee0a..1b03d07acde2 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -542,6 +542,45 @@ int btrfs_is_empty_uuid(u8 *uuid)
>>  	return 1;
>>  }
>>  
>> +static int btrfs_link_subvol(struct btrfs_trans_handle *trans,
>> +			     struct inode *dir, u64 objectid, const char *name,
>> +			     int namelen)
>> +{
>> +	struct btrfs_root *root = BTRFS_I(dir)->root;
>> +	struct btrfs_key key;
>> +	u64 index = 0;
>> +	int ret;
>> +
>> +	/*
>> +	 * insert the directory item
>> +	 */
>> +	ret = btrfs_set_inode_index(BTRFS_I(dir), &index);
>> +	if (ret) {
>> +		btrfs_abort_transaction(trans, ret);
>> +		return ret;
>> +	}
>> +
>> +	key.objectid = objectid;
>> +	key.type = BTRFS_ROOT_ITEM_KEY;
>> +	key.offset = -1;
>> +	ret = btrfs_insert_dir_item(trans, name, namelen, BTRFS_I(dir), &key,
>> +				    BTRFS_FT_DIR, index);
>> +	if (ret) {
>> +		btrfs_abort_transaction(trans, ret);
>> +		return ret;
>> +	}
>> +
>> +	btrfs_i_size_write(BTRFS_I(dir), dir->i_size + namelen * 2);
>> +	ret = btrfs_update_inode(trans, root, dir);
>> +	BUG_ON(ret);
>
>What about clean up this BUG_ON()?
>
>> +
>> +	ret = btrfs_add_root_ref(trans, objectid, root->root_key.objectid,
>> +				 btrfs_ino(BTRFS_I(dir)), index, name, namelen);
>> +	BUG_ON(ret);
>
>And this one?

Sorry, this makes you confused. This is exactly the cleanup done by Patch 2, because
I want to just move the code in Patch 1.

Thanks,
Lu

>
>Thanks,
>Qu
>
>> +
>> +	return ret;
>> +}
>> +
>>  static noinline int create_subvol(struct inode *dir,
>>  				  struct dentry *dentry,
>>  				  const char *name, int namelen,
>> @@ -563,7 +602,6 @@ static noinline int create_subvol(struct inode *dir,
>>  	int err;
>>  	u64 objectid;
>>  	u64 new_dirid = BTRFS_FIRST_FREE_OBJECTID;
>> -	u64 index = 0;
>>  	uuid_le new_uuid;
>>  
>>  	root_item = kzalloc(sizeof(*root_item), GFP_KERNEL);
>> @@ -677,29 +715,9 @@ static noinline int create_subvol(struct inode *dir,
>>  	new_root->highest_objectid = new_dirid;
>>  	mutex_unlock(&new_root->objectid_mutex);
>>  
>> -	/*
>> -	 * insert the directory item
>> -	 */
>> -	ret = btrfs_set_inode_index(BTRFS_I(dir), &index);
>> -	if (ret) {
>> -		btrfs_abort_transaction(trans, ret);
>> -		goto fail;
>> -	}
>> -
>> -	ret = btrfs_insert_dir_item(trans, name, namelen, BTRFS_I(dir), &key,
>> -				    BTRFS_FT_DIR, index);
>> -	if (ret) {
>> -		btrfs_abort_transaction(trans, ret);
>> +	ret = btrfs_link_subvol(trans, dir, objectid, name, namelen);
>> +	if (ret)
>>  		goto fail;
>> -	}
>> -
>> -	btrfs_i_size_write(BTRFS_I(dir), dir->i_size + namelen * 2);
>> -	ret = btrfs_update_inode(trans, root, dir);
>> -	BUG_ON(ret);
>> -
>> -	ret = btrfs_add_root_ref(trans, objectid, root->root_key.objectid,
>> -				 btrfs_ino(BTRFS_I(dir)), index, name, namelen);
>> -	BUG_ON(ret);
>>  
>>  	ret = btrfs_uuid_tree_add(trans, root_item->uuid,
>>  				  BTRFS_UUID_KEY_SUBVOL, objectid);
>> 
>
