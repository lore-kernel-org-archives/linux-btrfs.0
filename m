Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:37268 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751917AbeEGCBO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 May 2018 22:01:14 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v2 02/10] btrfs-progs: extract btrfs_link_subvol from
 btrfs_mksubvol
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: <linux-btrfs@vger.kernel.org>
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-3-lufq.fnst@cn.fujitsu.com>
 <55438435-3da6-6b84-a8dc-22cc976e648f@gmx.com>
Message-ID: <6bd78b48-37b1-a632-9add-aa7122ca60b9@cn.fujitsu.com>
Date: Mon, 7 May 2018 10:00:39 +0800
MIME-Version: 1.0
In-Reply-To: <55438435-3da6-6b84-a8dc-22cc976e648f@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2018 at 01:02:43PM +0800, Qu Wenruo wrote:
>
>
>On 2018年03月27日 15:06, Lu Fengqi wrote:
>> The original btrfs_mksubvol is too specific to specify the directory that
>> the subvolume will link to. Furthermore, in this transaction, we don't only
>> need to create root_ref/dir-item, but also update the refs or flags of
>> root_item. Extract a generic btrfs_link_subvol that allow the caller pass a
>> trans argument for later subvolume undelete.
>
>The idea makes sense.
>
>Although some small nitpicks inlined below.

Sorry I've taken so long to reply.

>
>> 
>> No functional changes for the btrfs_mksubvol.
>> 
>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>> ---
>>  convert/main.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  ctree.h        |  5 +++--
>>  inode.c        | 46 +++++++++++++++++++++-------------------------
>>  3 files changed, 81 insertions(+), 27 deletions(-)
>> 
>> diff --git a/convert/main.c b/convert/main.c
>> index 6bdfab40d0b0..dd6b42a1f2b1 100644
>> --- a/convert/main.c
>> +++ b/convert/main.c
>> @@ -1002,6 +1002,63 @@ err:
>>  	return ret;
>>  }
>>  
>> +/*
>> + * Link the subvolume specified by @root_objectid to the root_dir of @root.
>
>However the function name is btrfs_mksubvol(), not btrfs_link_subvol().
>After reading the code, it turns out that btrfs_mksubvol() is just an
>less generic btrfs_link_subvol().

The function name is really confusing. I will rename this function and
reword this comment to make it clear.

>
>> + * @root		the root of the file tree which the subvolume will
>> + *			be linked to.
>
>Here you're using btrfs_root for source subvolume.
>
>> + * @subvol_name		the name of the subvolume which will be linked.
>> + * @root_objectid	specify the subvolume which will be linked.
>
>But here you're specifying subvolume id as destination.
>
>It would be much better to unify both parameter to the same structure.
>And personally I prefer both btrfs_root.

Unfortunately, btrfs_root can't pass the subvolume name string.

>
>> + * @convert		the flag to determine whether to try to resolve
>> + *			the name conflict.
>
>This parameter is not used in this function, and the name "convert"
>doesn't reflect the name conflict check.
>

Yeah, I keep it to follow the original btrfs_mksubvol, but it is really
redundant and I will remove it. Of course, I will also rename it at
btrfs_link_subvol.

>Personally speaking, I would like the parameters to be something like
>btrfs_mksubolv(struct btrfs_root *dst_root,
>               struct btrfs_root *src_root)

How about the following defination?
link_subvolv_for_convert(struct btrfs_root *root,
			 const char *subvol_name, u64 root_objectid)

-- 
Thanks,
Lu

>
>> + *
>> + * Return the root of the subvolume if success, otherwise return NULL.
>> + */
>> +static struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
>> +					 const char *subvol_name,
>> +					 u64 root_objectid,
>> +					 bool convert)
>> +{
>> +	struct btrfs_trans_handle *trans;
>> +	struct btrfs_root *subvol_root = NULL;
>> +	struct btrfs_key key;
>> +	u64 dirid = btrfs_root_dirid(&root->root_item);
>> +	int ret;
>> +
>> +
>> +	trans = btrfs_start_transaction(root, 1);
>> +	if (IS_ERR(trans)) {
>> +		error("unable to start transaction");
>> +		goto fail;
>> +	}
>> +
>> +	ret = btrfs_link_subvol(trans, root, subvol_name, root_objectid, dirid,
>> +				true);
>> +	if (ret) {
>> +		error("unable to link subvolume %s", subvol_name);
>> +		goto fail;
>> +	}
>> +
>> +	ret = btrfs_commit_transaction(trans, root);
>> +	if (ret) {
>> +		error("transaction commit failed: %d", ret);
>> +		goto fail;
>> +	}
>> +
>> +	key.objectid = root_objectid;
>> +	key.offset = (u64)-1;
>> +	key.type = BTRFS_ROOT_ITEM_KEY;
>> +
>> +	subvol_root = btrfs_read_fs_root(root->fs_info, &key);
>> +	if (!subvol_root) {
>> +		error("unable to link subvolume %s", subvol_name);
>> +		goto fail;
>> +	}
>> +
>> +fail:
>> +	return subvol_root;
>> +}
>> +
>>  /*
>>   * Migrate super block to its default position and zero 0 ~ 16k
>>   */
>> diff --git a/ctree.h b/ctree.h
>> index 0fc31dd8d998..4bff0b821472 100644
>> --- a/ctree.h
>> +++ b/ctree.h
>> @@ -2797,8 +2797,9 @@ int btrfs_del_orphan_item(struct btrfs_trans_handle *trans,
>>  			  struct btrfs_root *root, u64 offset);
>>  int btrfs_mkdir(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>>  		char *name, int namelen, u64 parent_ino, u64 *ino, int mode);
>> -struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root, const char *base,
>> -				  u64 root_objectid, bool convert);
>> +int btrfs_link_subvol(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>> +		      const char *base, u64 root_objectid, u64 dirid,
>> +		      bool convert);
>>  
>>  /* file.c */
>>  int btrfs_get_extent(struct btrfs_trans_handle *trans,
>> diff --git a/inode.c b/inode.c
>> index 8d0812c7cf50..478036562652 100644
>> --- a/inode.c
>> +++ b/inode.c
>> @@ -606,19 +606,28 @@ out:
>>  	return ret;
>>  }
>>  
>> -struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
>> -				  const char *base, u64 root_objectid,
>> -				  bool convert)
>> +/*
>> + * Link the subvolume specified by @root_objectid to the directory specified by
>> + * @dirid on the file tree specified by @root.
>> + *
>> + * @root		the root of the file tree where the directory on.
>> + * @base		the name of the subvolume which will be linked.
>> + * @root_objectid	specify the subvolume which will be linked.
>
>Same nitpick about parameter here.
>
>Thanks,
>Qu
>
>> + * @dirid		specify the directory which the subvolume will be
>> + *			linked to.
>> + * @convert		the flag to determine whether to try to resolve
>> + *			the name conflict.
>> + */
>> +int btrfs_link_subvol(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>> +		      const char *base, u64 root_objectid, u64 dirid,
>> +		      bool convert)
>>  {
>> -	struct btrfs_trans_handle *trans;
>>  	struct btrfs_fs_info *fs_info = root->fs_info;
>>  	struct btrfs_root *tree_root = fs_info->tree_root;
>> -	struct btrfs_root *new_root = NULL;
>>  	struct btrfs_path path;
>>  	struct btrfs_inode_item *inode_item;
>>  	struct extent_buffer *leaf;
>>  	struct btrfs_key key;
>> -	u64 dirid = btrfs_root_dirid(&root->root_item);
>>  	u64 index = 2;
>>  	char buf[BTRFS_NAME_LEN + 1]; /* for snprintf null */
>>  	int len;
>> @@ -627,8 +636,9 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
>>  
>>  	len = strlen(base);
>>  	if (len == 0 || len > BTRFS_NAME_LEN)
>> -		return NULL;
>> +		return -EINVAL;
>>  
>> +	/* find the free dir_index */
>>  	btrfs_init_path(&path);
>>  	key.objectid = dirid;
>>  	key.type = BTRFS_DIR_INDEX_KEY;
>> @@ -649,12 +659,7 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
>>  	}
>>  	btrfs_release_path(&path);
>>  
>> -	trans = btrfs_start_transaction(root, 1);
>> -	if (IS_ERR(trans)) {
>> -		error("unable to start transaction");
>> -		goto fail;
>> -	}
>> -
>> +	/* add the dir_item/dir_index */
>>  	key.objectid = dirid;
>>  	key.offset = 0;
>>  	key.type =  BTRFS_INODE_ITEM_KEY;
>> @@ -675,6 +680,7 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
>>  
>>  	memcpy(buf, base, len);
>>  	if (convert) {
>> +		/* try to resolve name conflict by adding the number suffix */
>>  		for (i = 0; i < 1024; i++) {
>>  			ret = btrfs_insert_dir_item(trans, root, buf, len,
>>  					dirid, &key, BTRFS_FT_DIR, index);
>> @@ -719,18 +725,8 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
>>  		goto fail;
>>  	}
>>  
>> -	ret = btrfs_commit_transaction(trans, root);
>> -	if (ret) {
>> -		error("transaction commit failed: %d", ret);
>> -		goto fail;
>> -	}
>>  
>> -	new_root = btrfs_read_fs_root(fs_info, &key);
>> -	if (IS_ERR(new_root)) {
>> -		error("unable to fs read root: %lu", PTR_ERR(new_root));
>> -		new_root = NULL;
>> -	}
>>  fail:
>> -	btrfs_init_path(&path);
>> -	return new_root;
>> +	btrfs_release_path(&path);
>> +	return ret;
>>  }
>> 
>


