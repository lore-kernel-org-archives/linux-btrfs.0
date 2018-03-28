Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:12290 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752514AbeC1B7l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 21:59:41 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 459C5AC013A
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Mar 2018 10:59:37 +0900 (JST)
Subject: Re: [PATCH v2 1/3] btrfs: Move may_destroy_subvol() from ioctl.c to
 inode.c
To: Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <ea15ef98-3668-b2bc-079c-439ec512ae76@jp.fujitsu.com>
 <68f8b2f8-8df9-ccc4-7eca-9b7a7e2d8a86@jp.fujitsu.com>
 <2c2a0e85-a5d1-fe02-e739-f59f302775a1@suse.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <3670d441-b5e6-94f6-4194-89e82eef7ae2@jp.fujitsu.com>
Date: Wed, 28 Mar 2018 10:59:32 +0900
MIME-Version: 1.0
In-Reply-To: <2c2a0e85-a5d1-fe02-e739-f59f302775a1@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/03/26 17:51, Nikolay Borisov wrote:
> 
> 
> On 26.03.2018 11:28, Misono Tomohiro wrote:
>> This is a preparation work to allow rmdir(2) to delete a subvolume.
>>
>> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
>> ---
>>  fs/btrfs/ctree.h |  1 +
>>  fs/btrfs/inode.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/btrfs/ioctl.c | 54 ------------------------------------------------------
>>  3 files changed, 55 insertions(+), 54 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index da308774b8a4..2dbead106aab 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -3166,6 +3166,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
>>  			struct btrfs_root *root,
>>  			struct inode *dir, u64 objectid,
>>  			const char *name, int name_len);
>> +noinline int may_destroy_subvol(struct btrfs_root *root);
> 
> Why the explicit noinline? If it's for "documentation"/appearing in
> stack traces purposes then you should use noinline_for_stack. But I
> don't think it's really needed.

Just to keep the original declaration.
Also, the third patch returns this function into static again (in ioctl.c).

> 
>>  int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
>>  			int front);
>>  int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index f53470112670..db66fa4fede6 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -4333,6 +4333,60 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
>>  	return ret;
>>  }
>>  
>> +/*
>> + * helper to check if the subvolume references other subvolumes
>> + */
>> +noinline int may_destroy_subvol(struct btrfs_root *root)
>> +{
>> +	struct btrfs_fs_info *fs_info = root->fs_info;
>> +	struct btrfs_path *path;
>> +	struct btrfs_dir_item *di;
>> +	struct btrfs_key key;
>> +	u64 dir_id;
>> +	int ret;
>> +
>> +	path = btrfs_alloc_path();
>> +	if (!path)
>> +		return -ENOMEM;
>> +
>> +	/* Make sure this root isn't set as the default subvol */
>> +	dir_id = btrfs_super_root_dir(fs_info->super_copy);
>> +	di = btrfs_lookup_dir_item(NULL, fs_info->tree_root, path,
>> +				   dir_id, "default", 7, 0);
>> +	if (di && !IS_ERR(di)) {
>> +		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
>> +		if (key.objectid == root->root_key.objectid) {
>> +			ret = -EPERM;
>> +			btrfs_err(fs_info,
>> +				  "deleting default subvolume %llu is not allowed",
>> +				  key.objectid);
>> +			goto out;
>> +		}
>> +		btrfs_release_path(path);
>> +	}
>> +
>> +	key.objectid = root->root_key.objectid;
>> +	key.type = BTRFS_ROOT_REF_KEY;
>> +	key.offset = (u64)-1;
>> +
>> +	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, path, 0, 0);
>> +	if (ret < 0)
>> +		goto out;
>> +	BUG_ON(ret == 0);
>> +
>> +	ret = 0;
>> +	if (path->slots[0] > 0) {
>> +		path->slots[0]--;
>> +		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +		if (key.objectid == root->root_key.objectid &&
>> +		    key.type == BTRFS_ROOT_REF_KEY)
>> +			ret = -ENOTEMPTY;
>> +	}
>> +out:
>> +	btrfs_free_path(path);
>> +	return ret;
>> +}
>> +
>>  static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
>>  {
>>  	struct inode *inode = d_inode(dentry);
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 111ee282b777..11af9eb449ef 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -1843,60 +1843,6 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
>>  	return ret;
>>  }
>>  
>> -/*
>> - * helper to check if the subvolume references other subvolumes
>> - */
>> -static noinline int may_destroy_subvol(struct btrfs_root *root)
>> -{
>> -	struct btrfs_fs_info *fs_info = root->fs_info;
>> -	struct btrfs_path *path;
>> -	struct btrfs_dir_item *di;
>> -	struct btrfs_key key;
>> -	u64 dir_id;
>> -	int ret;
>> -
>> -	path = btrfs_alloc_path();
>> -	if (!path)
>> -		return -ENOMEM;
>> -
>> -	/* Make sure this root isn't set as the default subvol */
>> -	dir_id = btrfs_super_root_dir(fs_info->super_copy);
>> -	di = btrfs_lookup_dir_item(NULL, fs_info->tree_root, path,
>> -				   dir_id, "default", 7, 0);
>> -	if (di && !IS_ERR(di)) {
>> -		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
>> -		if (key.objectid == root->root_key.objectid) {
>> -			ret = -EPERM;
>> -			btrfs_err(fs_info,
>> -				  "deleting default subvolume %llu is not allowed",
>> -				  key.objectid);
>> -			goto out;
>> -		}
>> -		btrfs_release_path(path);
>> -	}
>> -
>> -	key.objectid = root->root_key.objectid;
>> -	key.type = BTRFS_ROOT_REF_KEY;
>> -	key.offset = (u64)-1;
>> -
>> -	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, path, 0, 0);
>> -	if (ret < 0)
>> -		goto out;
>> -	BUG_ON(ret == 0);
>> -
>> -	ret = 0;
>> -	if (path->slots[0] > 0) {
>> -		path->slots[0]--;
>> -		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> -		if (key.objectid == root->root_key.objectid &&
>> -		    key.type == BTRFS_ROOT_REF_KEY)
>> -			ret = -ENOTEMPTY;
>> -	}
>> -out:
>> -	btrfs_free_path(path);
>> -	return ret;
>> -}
>> -
>>  static noinline int key_in_sk(struct btrfs_key *key,
>>  			      struct btrfs_ioctl_search_key *sk)
>>  {
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

